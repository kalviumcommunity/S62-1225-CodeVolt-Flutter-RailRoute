import 'package:flutter/material.dart';
import '../services/data_service.dart';

class StateHandlingScreen extends StatelessWidget {
  StateHandlingScreen({super.key});

  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Handling Demo'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: _dataService.fetchItems(),
        builder: (context, snapshot) {

          // ⏳ LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ❌ ERROR STATE
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Something went wrong"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // rebuilds the widget
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // 📭 EMPTY STATE
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No items found.\nTap + to add your first item!",
                textAlign: TextAlign.center,
              ),
            );
          }

          // ✅ SUCCESS STATE
          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(items[index]),
              );
            },
          );
        },
      ),
    );
  }
}