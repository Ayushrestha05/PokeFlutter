import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/models/poke_evolution_model.dart';
import 'package:poke_flutter/models/poke_model.dart';
import 'package:poke_flutter/utils/services/api_response_cache_box.dart';

class APIService {
  String endpoint = 'https://pokeapi.co/api/v2/';
  static final int _cacheTimeout =
      const Duration(hours: 1).inMilliseconds; // 1 hour

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
      log(response.reasonPhrase.toString());
      return [];
    }
  }

  Future<PokeDetailModel> getPokemonDetail(int pokeID) async {
    final box = await Hive.openBox('apiResponses');
    //returns first element according to the condition or empty object
    final cachedResponse = box.values.firstWhere(
      (response) => response!.url == '${endpoint}pokemon/$pokeID',
      orElse: () => null,
    );
    if (cachedResponse != null &&
        ((DateTime.now().millisecondsSinceEpoch - cachedResponse.timestamp) <
            _cacheTimeout)) {
      return PokeDetailModel.fromJson(jsonDecode(cachedResponse.response));
    }
    var response = await http.get(Uri.parse('${endpoint}pokemon/$pokeID'));
    log('API : ${endpoint}pokemon/$pokeID');
    log('Respnse Code : ${response.statusCode}');
    if (response.statusCode == 200) {
      saveAPICacheData(
          endpoint: '${endpoint}pokemon/$pokeID', response: response);
      log('Returned Network Data (Pokemon Detail)');
      return PokeDetailModel.fromJson(jsonDecode(response.body));
    } else {
      log(response.reasonPhrase.toString());
      // Return empty object
      return PokeDetailModel(
          id: '0',
          name: '',
          baseExp: '',
          height: '',
          order: '',
          weight: '',
          abilities: [],
          forms: [],
          sprites: {},
          stats: [],
          types: [],
          species: {});
    }
  }

  Future<String> getPokeFlavorText(int pokeID) async {
    final box = await Hive.openBox('apiResponses');
    //returns first element according to the condition or empty object
    final cachedResponse = box.values.firstWhere(
      (response) => response!.url == '${endpoint}pokemon-species/$pokeID',
      orElse: () => null,
    );
    if (cachedResponse != null &&
        ((DateTime.now().millisecondsSinceEpoch - cachedResponse.timestamp) <
            _cacheTimeout)) {
      return jsonDecode(cachedResponse.response)['flavor_text_entries'][0]
          ['flavor_text'];
    }
    var response =
        await http.get(Uri.parse('${endpoint}pokemon-species/$pokeID'));
    if (response.statusCode == 200) {
      saveAPICacheData(
          endpoint: '${endpoint}pokemon-species/$pokeID', response: response);
      return jsonDecode(response.body)['flavor_text_entries'][0]['flavor_text'];
    } else {
      log(response.reasonPhrase.toString());
      // Return empty object
      return '';
    }
  }

  Future<String> getPokeAbilityDesc(String abilityURL) async {
    final box = await Hive.openBox('apiResponses');
    //returns first element according to the condition or empty object
    final cachedResponse = box.values.firstWhere(
      (response) => response!.url == abilityURL,
      orElse: () => null,
    );
    if (cachedResponse != null &&
        ((DateTime.now().millisecondsSinceEpoch - cachedResponse.timestamp) <
            _cacheTimeout)) {
      return jsonDecode(cachedResponse.response)['effect_entries'].firstWhere(
          (element) => element['language']['name'] == 'en')['short_effect'];
    }
    var response = await http.get(Uri.parse(abilityURL));
    if (response.statusCode == 200) {
      saveAPICacheData(endpoint: abilityURL, response: response);
      return jsonDecode(response.body)['effect_entries'].firstWhere(
          (element) => element['language']['name'] == 'en')['short_effect'];
    } else {
      log(response.reasonPhrase.toString());
      // Return empty object
      return '';
    }
  }

  Future<PokemonEvolutionModel> getPokeEvolution(String id) async {
    final box = await Hive.openBox('apiResponses');
    //first retrieve the evolution chain from the pokemon species
    final cachedSpeciesResponse = box.values.firstWhere(
      (response) => response!.url == '${endpoint}pokemon-species/$id',
      orElse: () => null,
    );
    if (cachedSpeciesResponse != null &&
        ((DateTime.now().millisecondsSinceEpoch -
                cachedSpeciesResponse.timestamp) <
            _cacheTimeout)) {
      String evolutionChainID =
          jsonDecode(cachedSpeciesResponse.response)['evolution_chain']['url']
              .split('/')[6];
      //then retrieve the evolution chain from the pokemon species
      final cachedEvolutionResponse = box.values.firstWhere(
        (response) =>
            response!.url == '${endpoint}evolution-chain/$evolutionChainID',
        orElse: () => null,
      );
      if (cachedEvolutionResponse != null &&
          ((DateTime.now().millisecondsSinceEpoch -
                  cachedEvolutionResponse.timestamp) <
              _cacheTimeout)) {
        return PokemonEvolutionModel.fromJson(
            jsonDecode(cachedEvolutionResponse.response)['chain']);
      }
    }

    // GET EVOLUTION CHAIN ID FROM POKEMON SPECIES
    String evolutionChainID = '1';
    var response = await http.get(Uri.parse('${endpoint}pokemon-species/$id'));
    if (response.statusCode == 200) {
      saveAPICacheData(
          endpoint: '${endpoint}pokemon-species/$id', response: response);
      evolutionChainID =
          jsonDecode(response.body)['evolution_chain']['url'].split('/')[6];
    } else {
      log(response.reasonPhrase.toString());
      return PokemonEvolutionModel();
    }
    // GET EVOLUTION CHAIN FROM EVOLUTION CHAIN ID
    var evolutionResponse = await http
        .get(Uri.parse('${endpoint}evolution-chain/$evolutionChainID'));
    if (evolutionResponse.statusCode == 200) {
      saveAPICacheData(
          endpoint: '${endpoint}evolution-chain/$id',
          response: evolutionResponse);
      PokemonEvolutionModel model = PokemonEvolutionModel.fromJson(
          jsonDecode(evolutionResponse.body)['chain']);
      return model;
    } else {
      log(evolutionResponse.reasonPhrase.toString());
      return PokemonEvolutionModel();
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
    box.values
        .where((response) => response!.url == endpoint)
        .forEach((response) => response.delete());
    await box.add(newResponse);
  }
}
