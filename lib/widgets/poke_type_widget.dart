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
          style: TextStyle(
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
  if (type == null) {
    return Color(0xffdbd9d9);
  }
  switch (type) {
    case 'fire':
      return Color(0xffF08030);

    case 'grass':
      return Color(0xff7AC74C);

    case 'water':
      return Color.fromARGB(255, 105, 123, 161);

    case 'rock':
      return Color(0xffB6A136);

    case 'bug':
      return Color(0xffA8B820);

    case 'normal':
      return Color(0xffA8A878);

    case 'poison':
      return Color(0xffA33EA1);

    case 'electric':
      return Color(0xfffce321);

    case 'ground':
      return Color(0xffE2BF65);

    case 'ice':
      return Color(0xff98D8D8);

    case 'dark':
      return Color(0xff705746);

    case 'fairy':
      return Color(0xffD685AD);

    case 'psychic':
      return Color(0xffF95587);

    case 'fighting':
      return Color(0xffC22E28);

    case 'ghost':
      return Color(0xff735797);

    case 'flying':
      return Color(0xffA98FF3);

    case 'dragon':
      return Color(0xff6F35FC);

    case 'steel':
      return Color(0xffB7B7CE);

    default:
      return Color(0xffdbd9d9);
  }
}
