import 'package:flutter/material.dart';

class AssetDemoScreen extends StatelessWidget {
  const AssetDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets Demo'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/train_front_view.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // dark overlay for readability
          color: Colors.black.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Local image
              Image.asset(
                'assets/images/train_location.png',
                width: 120,
              ),

              const SizedBox(height: 20),

              // 🔹 Text
              const Text(
                'RailRoute Asset Demo',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Flutter built-in icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_on, color: Colors.red, size: 32),
                  SizedBox(width: 16),
                  Icon(Icons.train, color: Colors.white, size: 32),
                  SizedBox(width: 16),
                  Icon(Icons.favorite, color: Colors.pink, size: 32),
                ],
              ),

              const SizedBox(height: 30),

              // 🔹 Downloaded PNG icon
              Image.asset(
                'assets/images/bookmark.png',
                width: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
