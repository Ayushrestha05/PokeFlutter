class PokeModel {
  final int id;
  final String name;
  final String url;

  PokeModel({required this.id, required this.name, required this.url});

  factory PokeModel.fromJson(Map<String, dynamic> json, {required int id}) {
    return PokeModel(
      id: id,
      name: json['name'],
      url: json['url'],
    );
  }
}
