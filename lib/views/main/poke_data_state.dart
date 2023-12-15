import 'package:poke_flutter/models/poke_model.dart';

class PokeDataState {
  final PokeDataStatus status;
  final List<PokeModel>? pokemons;
  final String? error;

  PokeDataState({required this.status, this.pokemons, this.error});

  PokeDataState copyWith(
      {PokeDataStatus? status, List<PokeModel>? pokemons, String? error}) {
    return PokeDataState(
        status: status ?? this.status,
        pokemons: pokemons ?? this.pokemons,
        error: error ?? this.error);
  }
}

enum PokeDataStatus { loading, loaded, error }
