class PokeDetailModel {
  final String id;
  final String name;
  final String baseExp;
  final String height;
  final String order;
  final String weight;
  final List abilities;
  final List forms;
  final Map sprites;
  final List stats;
  final List types;

  PokeDetailModel(
      {required this.id,
      required this.name,
      required this.baseExp,
      required this.height,
      required this.order,
      required this.weight,
      required this.abilities,
      required this.forms,
      required this.sprites,
      required this.stats,
      required this.types});

  factory PokeDetailModel.fromJson(Map<String, dynamic> json) {
    return PokeDetailModel(
      id: json['id'].toString(),
      name: json['name'],
      baseExp: json['base_experience'].toString(),
      height: json['height'].toString(),
      order: json['order'].toString(),
      weight: json['weight'].toString(),
      abilities: json['abilities'].map((e) => PokeAbility.fromJson(e)).toList(),
      forms: json['forms'],
      sprites: json['sprites'],
      stats: json['stats'].map((e) => PokeStats.fromJson(e)).toList(),
      types: json['types'].map((e) => e['type']['name']).toList(),
    );
  }
}

class PokeStats {
  final String name;
  final String baseStat;
  final String effort;

  PokeStats({required this.name, required this.baseStat, required this.effort});

  factory PokeStats.fromJson(Map<String, dynamic> json) {
    return PokeStats(
      name: json['stat']['name'],
      baseStat: json['base_stat'].toString(),
      effort: json['effort'].toString(),
    );
  }
}

class PokeAbility {
  final String name;
  final String url;

  PokeAbility({required this.name, required this.url});

  factory PokeAbility.fromJson(Map<String, dynamic> json) {
    return PokeAbility(
      name: json['ability']['name'],
      url: json['ability']['url'],
    );
  }
}
