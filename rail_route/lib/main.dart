import 'package:flutter/material.dart';
import 'screens/repsonsive_home.dart';
import 'screens/stateless_stateful_demo.dart';
import 'screens/state_management_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sprint 2 – Responsive & Stateful Demo',
      theme: ThemeData(

      title: 'State Management Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

      home: const StateManagementDemo(),
    );
  }
}
