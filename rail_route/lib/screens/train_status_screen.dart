import 'package:flutter/material.dart';
import '../widgets/status_badge.dart';
import '../widgets/station_timeline.dart';

class TrainStatusScreen extends StatefulWidget {
  const TrainStatusScreen({super.key});

  @override
  State<TrainStatusScreen> createState() => _TrainStatusScreenState();
}

class _TrainStatusScreenState extends State<TrainStatusScreen> {
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrainStatus();
  }

  void _loadTrainStatus() async {
    // TODO: Load from Firebase/API
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    // TODO: Save to Firebase
  }

  void _showAlternateRoutes() {
    Navigator.pushNamed(context, '/route-suggestions');
  }

  @override
  Widget build(BuildContext context) {
    final trainNumber = ModalRoute.of(context)?.settings.arguments as String?;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(trainNumber ?? 'Train Status'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Mock data
    final stations = [
      StationStop(name: 'Mumbai Central', arrivalTime: '10:00 AM', platform: '3'),
      StationStop(name: 'Borivali', arrivalTime: '10:25 AM', platform: '2'),
      StationStop(name: 'Vapi', arrivalTime: '11:45 AM', platform: '1'),
      StationStop(name: 'Surat', arrivalTime: '1:15 PM', platform: '4'),
      StationStop(name: 'Vadodara', arrivalTime: '3:00 PM', platform: '2'),
      StationStop(name: 'Ahmedabad', arrivalTime: '5:30 PM', platform: '1'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(trainNumber ?? 'Train Status'),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTrainStatus,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainNumber ?? '12345',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rajdhani Express',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const StatusBadge(
                    status: 'delayed',
                    delayMinutes: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.location_on, 'Current Station', 'Surat'),
                      const Divider(height: 24),
                      _buildInfoRow(Icons.access_time, 'Expected Arrival', '1:30 PM'),
                      const Divider(height: 24),
                      _buildInfoRow(Icons.train, 'Platform', '4'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: _showAlternateRoutes,
                icon: const Icon(Icons.alt_route),
                label: const Text('View Alternate Routes'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Route Timeline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: StationTimeline(
                    stations: stations,
                    currentStationIndex: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
