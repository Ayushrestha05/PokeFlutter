import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_flutter/utils/services/api_services.dart';

class APINotifier extends Notifier<APIService> {
  @override
  build() {
    return APIService();
  }
}

final apiNotifierProvider =
    NotifierProvider<APINotifier, APIService>(() => APINotifier());
