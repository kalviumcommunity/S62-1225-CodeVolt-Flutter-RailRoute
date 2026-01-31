import 'package:flutter/material.dart';
import '../widgets/status_badge.dart';
import '../widgets/station_timeline.dart';
import '../models/train_model.dart';
import '../services/train_service.dart';

class TrainStatusScreen extends StatefulWidget {
  const TrainStatusScreen({super.key});

  @override
  State<TrainStatusScreen> createState() => _TrainStatusScreenState();
}

class _TrainStatusScreenState extends State<TrainStatusScreen> {
  bool _isFavorite = false;
  late Future<TrainModel> _trainFuture;
  TrainModel? _initialData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    
    // Check if arguments is the String (train number) or TrainModel
    // Because DashboardScreen passes the MODEL, but old code passed STRING.
    // We should handle both if we want robustness, but Dashboard now passes Model.
    // However, if we refresh, we might want to refetch using ID.
    
    if (args is TrainModel) {
      _initialData = args;
      // We start a fresh fetch to ensure data is live
      _trainFuture = TrainService().getTrainStatus(args.number);
    } else if (args is String) {
      // If just a number was passed
      _trainFuture = TrainService().getTrainStatus(args);
    } else {
       // Fallback for safety
      _trainFuture = Future.error('Invalid arguments'); 
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
    return FutureBuilder<TrainModel>(
      future: _trainFuture,
      initialData: _initialData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _initialData == null) {
          return Scaffold(
             appBar: AppBar(title: const Text('Loading...')),
             body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
           return Scaffold(
             appBar: AppBar(title: const Text('Error')),
             body: Center(
               child: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Text(
                   'Could not load train status.\n${snapshot.error}\n(Check your API Key or Quota)',
                   textAlign: TextAlign.center,
                   style: const TextStyle(color: Colors.red),
                 ),
               ),
             ),
           );
        }

        if (!snapshot.hasData) {
           return Scaffold(
             appBar: AppBar(title: const Text('No Data')),
             body: const Center(child: Text('Train not found')),
           );
        }

        final train = snapshot.data!;
        
        // Convert stations to station timeline format
        // If stations are empty (API limitation), show placeholder
        final stations = train.stations.isNotEmpty 
          ? train.stations.map((s) => StationStop(
            name: s.name,
            arrivalTime: s.arrivalTime,
            platform: s.platform,
          )).toList()
          : <StationStop>[]; // Empty list if no schedule

        // Determine current station index based on 'isPassed' flag or names
        int currentStationIndex = 0;
        if (stations.isNotEmpty) {
           for (int i = 0; i < stations.length; i++) {
            if (stations[i].name == train.currentStation) {
              currentStationIndex = i;
              break;
            }
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(train.number),
            actions: [
              IconButton(
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                   setState(() {
                     _trainFuture = TrainService().getTrainStatus(train.number);
                   });
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Refreshing live status...')),
                   );
                },
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
                        train.number,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        train.name,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                       StatusBadge(
                        status: train.status,
                        delayMinutes: train.delayMinutes,
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
                          _buildInfoRow(Icons.location_on, 'Current Station', train.currentStation),
                          const Divider(height: 24),
                          _buildInfoRow(Icons.arrow_forward, 'Next Station', train.nextStation),
                          const Divider(height: 24),
                          _buildInfoRow(Icons.train, 'Platform', train.platform),
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
                
                // Only show timeline if we have stations
                if (stations.isNotEmpty) ...[
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
                          currentStationIndex: currentStationIndex,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                   const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Center(child: Text("Schedule details unavailable from API", style: TextStyle(color: Colors.grey))),
                   )
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
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
