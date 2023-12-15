import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/utils/services/api_notifier.dart';
import 'package:poke_flutter/widgets/error_widget.dart';

class PokeAboutView extends StatelessWidget {
  final PokeDetailModel? detail;
  const PokeAboutView({super.key, this.detail});

  @override
  Widget build(BuildContext context) {
    return detail != null
        ? SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Consumer(builder: (context, ref, child) {
                    final apiProvider = ref.read(apiNotifierProvider);
                    return FutureBuilder(
                        future: apiProvider
                            .getPokeFlavorText(int.parse(detail!.id)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if ((snapshot.data ?? '').isNotEmpty) {
                              return AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    snapshot.data
                                        .toString()
                                        .replaceAll('\n', ' '),
                                    textStyle:
                                        const TextStyle(color: Colors.black),
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
                        });
                  }),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Height',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                          '${(detail!.height.isNotEmpty) ? (int.parse(detail!.height) / 10) : 'N/A'} m tall',
                          style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Weight',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                          '${(detail!.weight.isNotEmpty) ? (int.parse(detail!.weight) / 10) : 'N/A'} kg',
                          style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          )
        : const PokeErrorWidget(
            color: Colors.black,
          );
  }
}
