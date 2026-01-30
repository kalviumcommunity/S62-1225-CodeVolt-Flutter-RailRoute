import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

  // Get all items as a stream
  Stream<QuerySnapshot> getItems() {
    return _itemsCollection.orderBy('createdAt', descending: true).snapshots();
  }

  // Add a new item
  Future<void> addItem(String title, String description) async {
    await _itemsCollection.add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete an item by document ID
  Future<void> deleteItem(String id) async {
    await _itemsCollection.doc(id).delete();
  }
}
