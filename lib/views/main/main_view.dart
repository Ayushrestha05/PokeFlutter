import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/models/poke_model.dart';
import 'package:poke_flutter/views/main/poke_data_state.dart';
import 'package:poke_flutter/views/main/poke_notifier.dart';
import 'package:poke_flutter/services/api_services.dart';

// apiProvider is a provider that returns an instance of APIService
final apiProvider = Provider<APIService>((ref) => APIService());

final pokeDataProvider = FutureProvider<List<PokeModel>>((ref) async {
  final List<PokeModel> pokeData = await ref.read(apiProvider).getAllPokemon();
  return pokeData;
});

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final pokeData = ref.watch(pokeDataProvider);
    final poke = ref.watch(pokeNotifierProvider);
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        // Round Search Bar
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            onChanged: ((value) =>
                ref.read(pokeNotifierProvider.notifier).filterPokeData(value)),
            decoration: const InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              icon: Icon(Icons.search),
            ),
          ),
        ),
        // Depending upon the PokeDataState, we either show a
        // loading indicator, an error message or the list of pokemon.
        if (poke.status == PokeDataStatus.loading) ...[
          const Center(child: CircularProgressIndicator()),
        ] else if (poke.status == PokeDataStatus.error) ...[
          Center(child: Text(poke.error!))
        ] else ...[
          Expanded(
            child: ListView.builder(
              itemCount: poke.pokemons!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(poke.pokemons![index].name),
                  subtitle: Text(poke.pokemons![index].url),
                );
              },
            ),
          ),
        ],
      ]),
    ));
  }
}
