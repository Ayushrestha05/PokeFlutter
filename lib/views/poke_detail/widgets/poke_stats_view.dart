import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/utils/constants.dart';
import 'package:poke_flutter/widgets/error_widget.dart';

class PokeDetailStatsView extends StatelessWidget {
  final PokeDetailModel? detail;
  const PokeDetailStatsView({super.key, this.detail});

  @override
  Widget build(BuildContext context) {
    //Get the largest stat value or 255 if there is no detail
    int maxValue = (detail != null && detail!.stats.isNotEmpty)
        ? detail!.stats
            .map((e) => int.parse(e.baseStat))
            .reduce((a, b) => a > b ? a : b)
        : 255;
    return detail != null
        ? detail!.stats.isNotEmpty
            ? SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(children: [
                    ...detail!.stats
                        .map((e) => StatIndicator(
                              stat: e,
                              maxValue: maxValue,
                            ))
                        .toList(),
                  ]),
                ),
              )
            : PokeErrorWidget(
                message: 'No Stats were found for the PKmN',
                color: Colors.black,
              )
        : const PokeErrorWidget();
  }
}

class StatIndicator extends StatelessWidget {
  final PokeStats stat;
  final int maxValue;
  const StatIndicator({super.key, required this.stat, required this.maxValue});

  String shortStatName(String name) {
    switch (name) {
      case 'special-attack':
        return 'Sp. Atk';
      case 'special-defense':
        return 'Sp. Def';
      case 'hp':
        return 'HP';
      case 'attack':
        return 'ATK';
      case 'defense':
        return 'DEF';
      case 'speed':
        return 'SPD';

      default:
        return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(shortStatName(stat.name),
                style: const TextStyle(color: Colors.black)),
          ),
          Expanded(
              flex: 3,
              child: LayoutBuilder(builder: (context, constraints) {
                log('Value : ${(double.parse(stat.baseStat) / maxValue)}');
                log('Max Width : ${constraints.maxWidth}');
                double value = (double.parse(stat.baseStat) / maxValue);
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    LinearProgressIndicator(
                      minHeight: 30,
                      backgroundColor: Colors.transparent,
                      color: kPrimaryColor,
                      value: value,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    //Position Text Just inside the progress bar in the right
                    // TODO Might be able to find a progressBar where text can be shown inside
                    Positioned(
                      left: value > 0.5
                          ? ((constraints.maxWidth) * 0.80) * value
                          : ((constraints.maxWidth) * 0.65) * value,
                      child: Text(
                        stat.baseStat,
                      ),
                    ),
                  ],
                );
              })),
        ],
      ),
    );
  }
}
