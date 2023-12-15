
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/utils/services/api_notifier.dart';
import 'package:poke_flutter/utils/services/api_services.dart';
import 'package:poke_flutter/views/poke_detail/poke_detail_state.dart';

class PokeDetailNotifier extends Notifier<PokeDetailState> {
  PokeDetailNotifier() : super();

  late PokeDetailModel pokeDetailInit;
  late APIService apiProvider;

  @override
  build() {
    apiProvider = ref.read(apiNotifierProvider);

    return PokeDetailState(status: PokeDetailStatus.loading);
  }

  void getPokeDetailData({required int id}) async {
    final PokeDetailModel pokeDetailData =
        await apiProvider.getPokemonDetail(id);
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
