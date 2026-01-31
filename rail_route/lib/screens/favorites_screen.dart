import 'package:flutter/material.dart';
import '../widgets/train_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Mock favorites data
  final List<Map<String, dynamic>> _favorites = [
    {
      'trainNumber': '12345',
      'trainName': 'Rajdhani Express',
      'status': 'on time',
      'departureTime': '10:30 AM',
      'platform': '3',
    },
    {
      'trainNumber': '67890',
      'trainName': 'Shatabdi Express',
      'status': 'delayed',
      'delayMinutes': 15,
      'departureTime': '2:45 PM',
      'platform': '5',
    },
  ];

  void _removeFavorite(int index) {
    setState(() {
      _favorites.removeAt(index);
    });
    // TODO: Remove from Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from favorites')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: _favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add trains to quickly access them',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final train = _favorites[index];
                return Dismissible(
                  key: Key(train['trainNumber']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) => _removeFavorite(index),
                  child: TrainCard(
                    trainNumber: train['trainNumber'],
                    trainName: train['trainName'],
                    status: train['status'],
                    delayMinutes: train['delayMinutes'],
                    departureTime: train['departureTime'],
                    platform: train['platform'],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/train-status',
                        arguments: train['trainNumber'],
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
