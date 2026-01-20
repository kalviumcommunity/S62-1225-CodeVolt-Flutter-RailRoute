import 'package:flutter/material.dart';
import 'screens/repsonsive_home.dart';
import 'screens/stateless_stateful_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sprint 2 – Responsive Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ResponsiveHome(),
        '/demo': (context) => const StatelessStatefulDemo(),
      },
    );
  }
}