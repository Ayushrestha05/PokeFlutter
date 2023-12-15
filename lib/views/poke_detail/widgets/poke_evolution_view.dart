import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/models/poke_evolution_model.dart';
import 'package:poke_flutter/models/poke_model.dart';
import 'package:poke_flutter/utils/constants.dart';
import 'package:poke_flutter/utils/extensions/string_extension.dart';
import 'package:poke_flutter/utils/services/api_notifier.dart';
import 'package:poke_flutter/views/poke_detail/poke_detail_notifier.dart';
import 'package:poke_flutter/views/poke_detail/poke_detail_view.dart';
import 'package:poke_flutter/widgets/error_widget.dart';

class PokeEvolutionView extends StatelessWidget {
  final PokeDetailModel? detail;
  const PokeEvolutionView({super.key, this.detail});

  @override
  Widget build(BuildContext context) {
    return detail != null
        ? detail!.species.isNotEmpty
            ? SingleChildScrollView(
                child: Consumer(builder: (context, ref, child) {
                  final apiProvider = ref.read(apiNotifierProvider);
                  return FutureBuilder(
                      future: apiProvider.getPokeEvolution(
                          detail!.species['url'].split('/')[6]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            List<Widget> evolutionWidget =
                                addEvolutions(evolution: snapshot.data!);

                            return SingleChildScrollView(
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    children: evolutionWidget,
                                  )),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const PokeLoadWidget();
                        } else {
                          return const SizedBox();
                        }
                      });
                }),
              )
            : const PokeErrorWidget(
                message: 'No Evolution Data was found for the PKmN',
                color: Colors.black,
              )
        : const PokeErrorWidget();
  }

  List<Widget> addEvolutions({required PokemonEvolutionModel evolution}) {
    List<Widget> evolutionWidget = [];
    // Show current evolution and then the evolution chain within the same model
    for (int i = 0; i < evolution.evolutions!.length; i++) {
      evolutionWidget.add(EvolutionWidget(
        currentShowingPokemon: detail!.id.toString(),
        currentEvolution: evolution.currentEvolution!,
        currentEvolutionID: evolution.currentEvolutionID!.toString(),
        nextEvolution: evolution.evolutions![i].nextEvolution,
        nextEvolutionID: evolution.evolutions![i].nextEvolutionID,
      ));

      // Check if there are more evolutions
      if (evolution.evolutions![i].evolutions != null) {
        for (int j = 0; j < evolution.evolutions![i].evolutions!.length; j++) {
          evolutionWidget.add(EvolutionWidget(
            currentShowingPokemon: detail!.id.toString(),
            currentEvolution: evolution.evolutions![i].nextEvolution,
            currentEvolutionID: evolution.evolutions![i].nextEvolutionID,
            nextEvolution:
                evolution.evolutions![i].evolutions![j].nextEvolution,
            nextEvolutionID:
                evolution.evolutions![i].evolutions![j].nextEvolutionID,
          ));
        }
      }
    }

    return evolutionWidget;
  }
}

class EvolutionWidget extends ConsumerWidget {
  final String currentEvolution;
  final String nextEvolution;
  final String currentEvolutionID;
  final String nextEvolutionID;
  final String currentShowingPokemon;
  const EvolutionWidget(
      {super.key,
      required this.currentShowingPokemon,
      required this.currentEvolution,
      required this.currentEvolutionID,
      required this.nextEvolution,
      required this.nextEvolutionID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Check if the tapped evolution is the same as the current showing pokemon
                if (currentShowingPokemon != currentEvolutionID) {
                  final int selectedPokeID = int.parse(currentEvolutionID);
                  ref
                      .watch(pokeDetailNotifierProvider.notifier)
                      .getPokeDetailData(id: selectedPokeID);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PokeDetailView(
                          pokemon: PokeModel(
                              id: selectedPokeID,
                              name: currentEvolution,
                              url:
                                  "https://pokeapi.co/api/v2/pokemon/$currentEvolutionID/"),
                        );
                      },
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  CachedNetworkImage(
                      imageUrl: getKPokeImage(currentEvolutionID)),
                  Text(
                    currentEvolution.capitalize(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const Text('Evolves to', style: TextStyle(color: Colors.black)),
            GestureDetector(
              onTap: () {
                // Check if the tapped evolution is the same as the current showing pokemon
                if (currentShowingPokemon != nextEvolutionID) {
                  final int selectedPokeID = int.parse(nextEvolutionID);
                  ref
                      .watch(pokeDetailNotifierProvider.notifier)
                      .getPokeDetailData(id: selectedPokeID);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PokeDetailView(
                          pokemon: PokeModel(
                              id: selectedPokeID,
                              name: nextEvolution,
                              url:
                                  "https://pokeapi.co/api/v2/pokemon/$nextEvolutionID/"),
                        );
                      },
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  CachedNetworkImage(imageUrl: getKPokeImage(nextEvolutionID)),
                  Text(nextEvolution.capitalize(),
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
        const Divider()
      ],
    );
  }
}
