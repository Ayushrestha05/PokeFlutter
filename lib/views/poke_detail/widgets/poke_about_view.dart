import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/utils/services/api_services.dart';

class PokeAboutView extends StatelessWidget {
  final PokeDetailModel? detail;
  const PokeAboutView({super.key, this.detail});

  @override
  Widget build(BuildContext context) {
    return detail != null
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                FutureBuilder(
                    future:
                        APIService().getPokeFlavorText(int.parse(detail!.id)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if ((snapshot.data ?? '').isNotEmpty) {
                          return AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                snapshot.data.toString().replaceAll('\n', ' '),
                                textStyle: TextStyle(color: Colors.black),
                              )
                            ],
                            isRepeatingAnimation: false,
                          );
                        } else {
                          return const SizedBox();
                        }
                      } else {
                        return const SizedBox();
                      }
                    }),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Height',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text('${(int.parse(detail!.height) / 10)} m tall',
                        style: const TextStyle(color: Colors.black)),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      'Weight',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text('${(int.parse(detail!.weight) / 10)} kg',
                        style: TextStyle(color: Colors.black)),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Divider(),
              ],
            ),
          )
        : Container();
  }
}
