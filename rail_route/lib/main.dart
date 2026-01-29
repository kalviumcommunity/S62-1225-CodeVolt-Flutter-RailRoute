import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/second_screen.dart';
import 'screens/state_handling_screen.dart';
import 'screens/asset_demo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi-Screen Navigation Demo',

      // 🔑 Initial route
      initialRoute: '/',

      // 🛣️ Named routes
      routes: {
        '/': (context) => const HomeScreen(),
        '/second': (context) => const SecondScreen(),
        '/state': (context) => StateHandlingScreen(),
        '/assets': (context) => const AssetDemoScreen(),
      },
    );
  }
}