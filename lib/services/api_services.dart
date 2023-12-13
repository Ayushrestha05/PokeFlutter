import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/models/poke_model.dart';

class APIService {
  String endpoint = 'https://pokeapi.co/api/v2/';

  Future<List<PokeModel>> getAllPokemon() async {
    var response =
        await http.get(Uri.parse('${endpoint}pokemon?limit=100000&offset=0'));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['results'];
      List<PokeModel> pokeData = [];
      for (var i = 0; i < result.length; i++) {
        pokeData.add(PokeModel.fromJson(result[i], id: i + 1));
      }
      return pokeData;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<PokeDetailModel> getPokemonDetail(int pokeID) async {
    var response = await http.get(Uri.parse('${endpoint}pokemon/$pokeID'));
    if (response.statusCode == 200) {
      return PokeDetailModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
