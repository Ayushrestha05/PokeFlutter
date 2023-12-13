import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poke_flutter/services/api_response_cache_box.dart';
import 'package:poke_flutter/views/main/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Setting up Hive Box
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
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
      title: 'User Data',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF0e4e8b),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'PKMN',
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: MyHomePage(),
    );
  }
}
