import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:poke_flutter/models/poke_detail_model.dart';
import 'package:poke_flutter/utils/extensions/string_extension.dart';

class PokeSpriteView extends StatelessWidget {
  final PokeDetailModel? detail;
  const PokeSpriteView({super.key, this.detail});

  @override
  Widget build(BuildContext context) {
    Map filteredMap = {};
    if (detail != null) {
      filteredMap = detail!.sprites
        ..removeWhere(
            (key, value) => (value == null || value.runtimeType != String));
    }

    return Column(
      children: [
        CarouselSlider.builder(
            itemCount: filteredMap.length,
            itemBuilder: (context, index, realIndex) {
              final key = filteredMap.keys.elementAt(index);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                      imageUrl: filteredMap[key],
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      placeholder: (context, url) => Center(
                            child: LottieBuilder.asset(
                              'assets/pokeLoad.json',
                              height: 100,
                              width: 100,
                            ),
                          )),
                  Text(
                    key.toString().capitalize().replaceAll('_', ' '),
                    style: TextStyle(color: Colors.black),
                  )
                ],
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              autoPlayAnimationDuration: Duration(milliseconds: 500),
            ))
      ],
    );
  }
}
