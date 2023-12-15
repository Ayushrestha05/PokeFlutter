import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poke_flutter/utils/constants.dart';
import 'package:poke_flutter/utils/services/api_response_cache_box.dart';
import 'package:poke_flutter/views/main/main_view.dart';

void main() async {
  // Ensures that the Flutter Widgets library is initialized before any plugins.
  WidgetsFlutterBinding.ensureInitialized();

  //Setting up Hive Box
  // If Platform.Android, is used during a web build, it will throw an error
  // So, we use kIsWeb to check if the build is for web
  if (kIsWeb) {
    Hive.initFlutter();
  } else if (Platform.isAndroid) {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  } else {
    Hive.initFlutter();
  }
  Hive.registerAdapter(ApiResponseCacheBoxAdapter());

  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeFlutter',
      theme: ThemeData(
        scaffoldBackgroundColor: kPrimaryColor,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'PKMN',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
