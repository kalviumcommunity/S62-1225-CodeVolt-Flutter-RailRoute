import 'dart:async';

class DataService {
  Future<List<String>> fetchItems() async {
    await Future.delayed(const Duration(seconds: 2));

    // 🔁 Uncomment ONE at a time to test states

    // 1️⃣ SUCCESS
    return ['Apple', 'Banana', 'Orange'];

    // 2️⃣ EMPTY STATE
    // return [];

    // 3️⃣ ERROR STATE
    // throw Exception("Failed to load data");
  }
}