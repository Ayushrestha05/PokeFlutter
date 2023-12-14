import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/models/poke_model.dart';
import 'package:poke_flutter/utils/services/api_services.dart';
import 'package:poke_flutter/views/main/poke_data_state.dart';

class PokeNotifier extends Notifier<PokeDataState> {
  PokeNotifier() : super();

  List<PokeModel> pokeDataInit = <PokeModel>[];

  @override
  build() {
    getAllPokeData();
    return PokeDataState(status: PokeDataStatus.loading);
  }

  void getAllPokeData() async {
    final List<PokeModel> pokeData = await APIService().getAllPokemon();
    setPokeStateData(pokeData);
  }

  void setPokeStateData(List<PokeModel> pokeData) {
    pokeDataInit = pokeData;
    state = PokeDataState(status: PokeDataStatus.loaded, pokemons: pokeData);
  }

  void filterPokeData(String query) async {
    log('Query: $query');
    if (query.isNotEmpty) {
      final List<PokeModel> pokeData = pokeDataInit
          .where((poke) => poke.name.toLowerCase().contains(query))
          .toList();
      state = PokeDataState(status: PokeDataStatus.loaded, pokemons: pokeData);
    } else {
      state =
          PokeDataState(status: PokeDataStatus.loaded, pokemons: pokeDataInit);
    }
  }
}

final pokeNotifierProvider = NotifierProvider<PokeNotifier, PokeDataState>(() {
  //Keep Alive Provider for 1 hour
  return PokeNotifier();
});
