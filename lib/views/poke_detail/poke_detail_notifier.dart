import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/services/api_services.dart';
import 'package:poke_flutter/views/poke_detail/poke_detail_state.dart';
import 'package:poke_flutter/views/poke_detail/poke_selected_notifier.dart';

class PokeDetailNotifier extends Notifier<PokeDetailState> {
  late int pokeID;
  PokeDetailNotifier() : super();

  late PokeDetailModel pokeDetailInit;
  @override
  build() {
    pokeID = ref.read(selectedPokeNotifierProvider);
    getPokeDetailData();
    return PokeDetailState(status: PokeDetailStatus.loading);
  }

  void getPokeDetailData() async {
    final PokeDetailModel pokeDetailData =
        await APIService().getPokemonDetail(pokeID);
    setPokeDetailStateData(pokeDetailData);
  }

  void setPokeDetailStateData(PokeDetailModel pokeDetailData) {
    state = PokeDetailState(
        status: PokeDetailStatus.loaded, detail: pokeDetailData);
  }
}

final pokeDetailNotifierProvider =
    NotifierProvider<PokeDetailNotifier, PokeDetailState>(() {
  return PokeDetailNotifier();
});
