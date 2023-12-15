import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PokeErrorWidget extends StatelessWidget {
  final Color? color;
  final String? message;
  const PokeErrorWidget({super.key, this.color, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/pokeball.png',
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
              message ??
                  'Seems like this data wants to hide inside this pokeball',
              textAlign: TextAlign.center,
              style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

class PokeLoadWidget extends StatelessWidget {
  const PokeLoadWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset(
        'assets/pokeLoad.json',
        height: 100,
        width: 100,
      ),
    );
  }
}
