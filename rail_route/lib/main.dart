import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/repsonsive_home.dart';
import 'screens/stateless_stateful_demo.dart';
import 'screens/animation_demo_screen.dart';
import 'screens/bottom_nav_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

/// 🔁 Theme Provider
class ThemeProvider extends ChangeNotifier {
  ThemeMode mode = ThemeMode.system;

  void toggleTheme(bool isDark) {
    mode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sprint 2 – Responsive Demo',

      // 🌞 Light Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),

      // 🌙 Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),

      // 🔄 Dynamic switching
      themeMode: themeProvider.mode,

      // 🔑 BottomNavigationBar is the root
      home: const BottomNavScreen(),

      // ✅ SAME routes kept for internal navigation
      routes: {
        '/home': (context) => const ResponsiveHome(),
        '/demo': (context) => const StatelessStatefulDemo(),
        '/animations': (context) => AnimationDemoScreen(),
      },
    );
  }
}