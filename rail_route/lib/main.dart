import 'package:flutter/material.dart';
import 'screens/user_input_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter User Input Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserInputForm(),
    );
  }
}