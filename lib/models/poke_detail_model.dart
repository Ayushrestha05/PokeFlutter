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
      abilities: json['abilities'],
      forms: json['forms'],
      sprites: json['sprites'],
      stats: json['stats'],
      types: json['types'].map((e) => e['type']['name']).toList(),
    );
  }
}
