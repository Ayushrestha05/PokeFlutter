import 'package:hive/hive.dart';

part 'api_response_cache_box.g.dart';

@HiveType(typeId: 0)
class ApiResponseCacheBox extends HiveObject {
  @HiveField(0)
  late String url;

  @HiveField(1)
  late String response;

  @HiveField(2)
  late int timestamp;
}
