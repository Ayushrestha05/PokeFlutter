import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedPokeNotifier extends Notifier<int> {
  @override
  build() {
    return 0;
  }

  void setPokeID(int pokeID) {
    state = pokeID;
  }
}

final selectedPokeNotifierProvider =
    NotifierProvider<SelectedPokeNotifier, int>(() {
  return SelectedPokeNotifier();
});
