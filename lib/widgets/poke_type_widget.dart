import 'package:flutter/material.dart';
import 'package:poke_flutter/utils/extensions/string_extension.dart';

Widget pokeTypeWidget({required String type, bool? isSmall = true}) {
  return Container(
    decoration: BoxDecoration(
      color: setTypeColor(type),
      borderRadius: BorderRadius.circular(2),
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Center(
        child: Text(
          isSmall! ? type.capitalize().substring(0, 1) : type.capitalize(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Color setTypeColor(String type) {
  type = type.toLowerCase();
  switch (type) {
    case 'fire':
      return const Color(0xffF08030);

    case 'grass':
      return const Color(0xff7AC74C);

    case 'water':
      return const Color.fromARGB(255, 105, 123, 161);

    case 'rock':
      return const Color(0xffB6A136);

    case 'bug':
      return const Color(0xffA8B820);

    case 'normal':
      return const Color(0xffA8A878);

    case 'poison':
      return const Color(0xffA33EA1);

    case 'electric':
      return const Color(0xfffce321);

    case 'ground':
      return const Color(0xffE2BF65);

    case 'ice':
      return const Color(0xff98D8D8);

    case 'dark':
      return const Color(0xff705746);

    case 'fairy':
      return const Color(0xffD685AD);

    case 'psychic':
      return const Color(0xffF95587);

    case 'fighting':
      return const Color(0xffC22E28);

    case 'ghost':
      return const Color(0xff735797);

    case 'flying':
      return const Color(0xffA98FF3);

    case 'dragon':
      return const Color(0xff6F35FC);

    case 'steel':
      return const Color(0xffB7B7CE);

    default:
      return const Color(0xffdbd9d9);
  }
}
