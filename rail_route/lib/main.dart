import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'themes/app_themes.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/train_status_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/route_suggestions_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const RailRouteApp());
}

class RailRouteApp extends StatelessWidget {
  const RailRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RailRoute',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/train-status': (context) => const TrainStatusScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/route-suggestions': (context) => const RouteSuggestionsScreen(),
      },
    );
  }
}