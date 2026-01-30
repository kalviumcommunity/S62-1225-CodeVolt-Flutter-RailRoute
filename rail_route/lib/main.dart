import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/second_screen.dart';
import 'screens/state_handling_screen.dart';
import 'screens/asset_demo_screen.dart';
import 'screens/user_input_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rail Route',

      // 🔐 AUTH GATE
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return const HomeScreen(); // CRUD screen
          }

          return const UserInputForm(); // Login / Signup screen
        },
      ),

      // 🛣️ Named routes (still usable after login)
      routes: {
        '/second': (context) => const SecondScreen(),
        '/state': (context) => StateHandlingScreen(),
        '/assets': (context) => const AssetDemoScreen(),
      },
    );
  }
}
