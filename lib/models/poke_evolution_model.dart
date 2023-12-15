class PokemonEvolutionModel {
  final String? currentEvolution;
  final int? currentEvolutionID;
  final List<Evolution>? evolutions;

  PokemonEvolutionModel({
    this.currentEvolution,
    this.currentEvolutionID,
    this.evolutions,
  });

  factory PokemonEvolutionModel.fromJson(Map<String, dynamic> json) {
    final currentEvolution = json['species']['name'];
    final currentEvolutionID = json['species']['url'].split('/')[6];
    final evolutions = <Evolution>[];

    if (json['evolves_to'] != null) {
      final evolvesTo = (json['evolves_to']);
      for (var i = 0; i < evolvesTo.length; i++) {
        evolutions.add(Evolution.fromJson(evolvesTo[i]));
      }
    }

    return PokemonEvolutionModel(
      currentEvolution: currentEvolution,
      currentEvolutionID: int.parse(currentEvolutionID),
      evolutions: evolutions,
    );
  }
}

class Evolution {
  final String nextEvolution;
  final String nextEvolutionID;
  final int? level;
  final String? itemRequired;
  final List<Evolution>? evolutions;

  Evolution({
    required this.nextEvolution,
    required this.nextEvolutionID,
    required this.level,
    required this.itemRequired,
    this.evolutions,
  });

  factory Evolution.fromJson(Map<String, dynamic> json) {
    final nextEvolution = json['species']['name'];
    final nextEvolutionID = json['species']['url'].split('/')[6];
    final level = json['evolution_details'][0]['min_level'];
    String? itemRequired;
    if (json['evolution_details'][0]['item'] != null) {
      itemRequired = json['evolution_details'][0]['item']['name'];
    }
    // Check more evolutions
    List<Evolution>? moreEvolutions;
    if (json['evolves_to'] != null && json['evolves_to'].length > 0) {
      moreEvolutions = [];
      final evolvesTo = (json['evolves_to']);
      for (var i = 0; i < evolvesTo.length; i++) {
        moreEvolutions.add(Evolution.fromJson(evolvesTo[i]));
      }
    }

    return Evolution(
      nextEvolution: nextEvolution,
      nextEvolutionID: nextEvolutionID,
      level: level,
      itemRequired: itemRequired,
      evolutions: moreEvolutions,
    );
  }

  //From Map
  factory Evolution.fromMap(Map<String, dynamic> map) {
    return Evolution(
      nextEvolution: map['species']['name'],
      nextEvolutionID: map['species']['url'].split('/')[6],
      level: map['evolution_details'][0]['min_level'],
      itemRequired: (map['evolution_details'][0]['item'] != null)
          ? map['evolution_details'][0]['item']['name']
          : null,
      evolutions: (map['evolves_to'] != null && map['evolves_to'].length > 0)
          ? map['evolves_to'].forEach((e) => Evolution.fromMap(e)).toList()
          : null,
    );
  }
}
