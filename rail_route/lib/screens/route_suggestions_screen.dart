import 'package:flutter/material.dart';
import '../widgets/train_card.dart';

class RouteSuggestionsScreen extends StatelessWidget {
  const RouteSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock alternate routes
    final alternateTrains = [
      {
        'trainNumber': '11111',
        'trainName': 'Express Special',
        'status': 'on time',
        'departureTime': '1:45 PM',
        'platform': '2',
        'eta': '5:15 PM',
      },
      {
        'trainNumber': '22222',
        'trainName': 'Fast Passenger',
        'status': 'on time',
        'departureTime': '2:00 PM',
        'platform': '6',
        'eta': '5:45 PM',
      },
      {
        'trainNumber': '33333',
        'trainName': 'Local Express',
        'status': 'delayed',
        'delayMinutes': 5,
        'departureTime': '2:15 PM',
        'platform': '1',
        'eta': '6:00 PM',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alternate Routes'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.amber.shade50,
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade900),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your train is delayed. Here are faster options.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Available Trains',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: alternateTrains.length,
              itemBuilder: (context, index) {
                final train = alternateTrains[index];
                return Column(
                  children: [
                    TrainCard(
                      trainNumber: train['trainNumber'] as String,
                      trainName: train['trainName'] as String,
                      status: train['status'] as String,
                      delayMinutes: train['delayMinutes'] as int?,
                      departureTime: train['departureTime'] as String,
                      platform: train['platform'] as String,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/train-status',
                          arguments: train['trainNumber'],
                        );
                      },
                    ),
                    if (train['eta'] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Arrives at ${train['eta']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
