import 'package:poke_flutter/models/poke_detail_model.dart';

class PokeDetailState {
  final PokeDetailStatus status;
  final PokeDetailModel? detail;
  final String? error;

  PokeDetailState({required this.status, this.detail, this.error});

  PokeDetailState copyWith(
      {PokeDetailStatus? status, PokeDetailModel? detail, String? error}) {
    return PokeDetailState(
        status: status ?? this.status,
        detail: detail ?? this.detail,
        error: error ?? this.error);
  }
}

enum PokeDetailStatus { loading, loaded, error }
