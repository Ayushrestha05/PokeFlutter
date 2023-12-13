import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/models/poke_model.dart';
import 'package:poke_flutter/services/api_response_cache_box.dart';

class APIService {
  String endpoint = 'https://pokeapi.co/api/v2/';
  static int _cacheTimeout = Duration(hours: 1).inMilliseconds; // 1 hour

  Future<List<PokeModel>> getAllPokemon() async {
    final box = await Hive.openBox('apiResponses');

    //returns first element according to the condition or empty object
    final cachedResponse = box.values.firstWhere(
      (response) => response!.url == '${endpoint}pokemon?limit=100000&offset=0',
      orElse: () => null,
    );

    if (cachedResponse != null &&
        ((DateTime.now().millisecondsSinceEpoch - cachedResponse.timestamp) <
            _cacheTimeout)) {
      // Return cached response if it's not expired yet
      final List result = jsonDecode(cachedResponse.response)['results'];
      List<PokeModel> pokeData = [];
      for (var i = 0; i < result.length; i++) {
        pokeData.add(PokeModel.fromJson(result[i], id: i + 1));
      }
      log('Returned Cache Data');
      return pokeData;
    }

    var response =
        await http.get(Uri.parse('${endpoint}pokemon?limit=100000&offset=0'));
    if (response.statusCode == 200) {
      saveAPICacheData(
          endpoint: '${endpoint}pokemon?limit=100000&offset=0',
          response: response);
      // Return response
      final List result = jsonDecode(response.body)['results'];
      List<PokeModel> pokeData = [];
      for (var i = 0; i < result.length; i++) {
        pokeData.add(PokeModel.fromJson(result[i], id: i + 1));
      }
      log('Return All Pokemon Network Data');
      return pokeData;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<PokeDetailModel> getPokemonDetail(int pokeID) async {
    final box = await Hive.openBox('apiResponses');
    //returns first element according to the condition or empty object
    final cachedResponse = box.values.firstWhere(
      (response) => response!.url == '${endpoint}pokemon/$pokeID',
      orElse: () => null,
    );
    log('Cached Response: ${cachedResponse}');
    if (cachedResponse != null &&
        ((DateTime.now().millisecondsSinceEpoch - cachedResponse.timestamp) <
            _cacheTimeout)) {
      return PokeDetailModel.fromJson(jsonDecode(cachedResponse.response));
    }
    var response = await http.get(Uri.parse('${endpoint}pokemon/$pokeID'));
    if (response.statusCode == 200) {
      saveAPICacheData(
          endpoint: '${endpoint}pokemon/$pokeID', response: response);
      log('Returned Network Data (Pokemon Detail)');
      return PokeDetailModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  void saveAPICacheData(
      {required String endpoint, required http.Response response}) async {
    final box = await Hive.openBox('apiResponses');
    // Save new response to cache
    final newResponse = ApiResponseCacheBox()
      ..url = endpoint
      ..response = response.body
      ..timestamp = DateTime.now().millisecondsSinceEpoch;
    //Remove Existing Cache Data and Add New Cache Data
    await box.values.where((response) => response!.url == endpoint)
      ..forEach((response) => response.delete());
    await box.add(newResponse);
  }
}
