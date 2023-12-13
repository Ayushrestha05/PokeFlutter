import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poke_flutter/models/poke_model.dart';

class APIService {
  String endpoint = 'https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0';

  Future<List<PokeModel>> getAllPokemon() async {
    var response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['results'];
      return result.map((e) => PokeModel.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
