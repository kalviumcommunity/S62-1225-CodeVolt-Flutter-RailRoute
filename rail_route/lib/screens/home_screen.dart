import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // ➡️ Navigate to second screen using named route
            Navigator.pushNamed(
              context,
              '/second',
              arguments: 'Hello from Home Screen!',
            );
          },
          child: const Text('Go to Second Screen'),
        ),
      ),
    );
  }
}