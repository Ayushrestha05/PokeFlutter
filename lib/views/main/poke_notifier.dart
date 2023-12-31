
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/models/poke_model.dart';
import 'package:poke_flutter/utils/services/api_notifier.dart';
import 'package:poke_flutter/utils/services/api_services.dart';
import 'package:poke_flutter/views/main/poke_data_state.dart';

class PokeNotifier extends Notifier<PokeDataState> {
  PokeNotifier() : super();

  List<PokeModel> pokeDataInit = <PokeModel>[];
  late APIService apiProvider;

  @override
  build() {
    apiProvider = ref.read(apiNotifierProvider);
    getAllPokeData();

    return PokeDataState(status: PokeDataStatus.loading);
  }

  void getAllPokeData() async {
    final List<PokeModel> pokeData = await apiProvider.getAllPokemon();
    setPokeStateData(pokeData);
  }

  void setPokeStateData(List<PokeModel> pokeData) {
    pokeDataInit = pokeData;
    state = PokeDataState(status: PokeDataStatus.loaded, pokemons: pokeData);
  }

  void filterPokeData(String query) async {
    if (query.isNotEmpty) {
      //Search can be done by name or PokeID
      final List<PokeModel> pokeData = pokeDataInit
          .where((poke) =>
              poke.name.toLowerCase().contains(query) ||
              poke.id.toString().contains(query))
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
