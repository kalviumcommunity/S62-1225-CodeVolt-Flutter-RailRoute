import 'package:flutter/material.dart';

class StatelessStatefulDemo extends StatelessWidget {
  const StatelessStatefulDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sprint 2 Demo'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            DemoHeader(),
            SizedBox(height: 30),
            CounterWidget(),
          ],
        ),
      ),
    );
  }
}

class DemoHeader extends StatelessWidget {
  const DemoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Interactive Counter App',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 0;

  void incrementCounter() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Count: $count',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: incrementCounter,
          child: const Text('Increase'),
        ),
      ],
    );
  }
}