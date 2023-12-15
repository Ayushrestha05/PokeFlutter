//PokeEvolutionView
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/models/poke_evolution_model.dart';
import 'package:poke_flutter/utils/constants.dart';
import 'package:poke_flutter/utils/extensions/string_extension.dart';
import 'package:poke_flutter/utils/services/api_notifier.dart';
import 'package:poke_flutter/utils/services/api_services.dart';

class PokeEvolutionView extends StatelessWidget {
  final PokeDetailModel? detail;
  const PokeEvolutionView({super.key, this.detail});

  @override
  Widget build(BuildContext context) {
    return detail != null
        ? Consumer(builder: (context, ref, child) {
            final apiProvider = ref.read(apiNotifierProvider);
            return FutureBuilder(
                future: apiProvider
                    .getPokeEvolution(detail!.species['url'].split('/')[6]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<Widget> evolutionWidget = [];
                      final evolution = snapshot.data!;
                      // Show current evolution and then the evolution chain within the same model
                      for (int i = 0; i < evolution.evolutions!.length; i++) {
                        evolutionWidget.add(EvolutionWidget(
                          currentEvolution: evolution.currentEvolution!,
                          currentEvolutionID:
                              evolution.currentEvolutionID!.toString(),
                          nextEvolution: evolution.evolutions![i].nextEvolution,
                          nextEvolutionID:
                              evolution.evolutions![i].nextEvolutionID,
                        ));

                        // Check if there are more evolutions
                        if (evolution.evolutions![i].evolutions != null) {
                          for (int j = 0;
                              j < evolution.evolutions![i].evolutions!.length;
                              j++) {
                            evolutionWidget.add(EvolutionWidget(
                              currentEvolution:
                                  evolution.evolutions![i].nextEvolution,
                              currentEvolutionID:
                                  evolution.evolutions![i].nextEvolutionID,
                              nextEvolution: evolution
                                  .evolutions![i].evolutions![j].nextEvolution,
                              nextEvolutionID: evolution.evolutions![i]
                                  .evolutions![j].nextEvolutionID,
                            ));
                          }
                        }
                      }

                      return SingleChildScrollView(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: evolutionWidget,
                            )),
                      );
                    } else {
                      return SizedBox();
                    }
                  } else {
                    return SizedBox();
                  }
                });
          })
        : Placeholder();
  }
}

class EvolutionWidget extends StatelessWidget {
  final String currentEvolution;
  final String nextEvolution;
  final String currentEvolutionID;
  final String nextEvolutionID;
  const EvolutionWidget(
      {super.key,
      required this.currentEvolution,
      required this.currentEvolutionID,
      required this.nextEvolution,
      required this.nextEvolutionID});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CachedNetworkImage(imageUrl: getKPokeImage(currentEvolutionID)),
                Text(
                  currentEvolution.capitalize(),
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            Text('Evolves to', style: TextStyle(color: Colors.black)),
            Column(
              children: [
                CachedNetworkImage(imageUrl: getKPokeImage(nextEvolutionID)),
                Text(nextEvolution.capitalize(),
                    style: TextStyle(color: Colors.black)),
              ],
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
