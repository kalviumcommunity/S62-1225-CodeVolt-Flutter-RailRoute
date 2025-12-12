import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            clicked ? "Button Clicked!" : "Hello, Flutter!",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.train, size: 90),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                clicked = !clicked;
              });
            },
            child: const Text("Click Me"),
          ),
        ],
      ),
    );
  }
}
