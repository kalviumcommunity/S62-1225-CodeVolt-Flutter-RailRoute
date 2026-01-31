import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/train_model.dart';
import '../services/train_service.dart';
import '../themes/app_themes.dart';

class TrainStatusScreen extends StatefulWidget {
  const TrainStatusScreen({super.key});

  @override
  State<TrainStatusScreen> createState() => _TrainStatusScreenState();
}

class _TrainStatusScreenState extends State<TrainStatusScreen> {
  final _trainService = TrainService();
  late Future<TrainModel?> _trainFuture;
  TrainModel? _currentTrain;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is TrainModel) {
      _currentTrain = args;
      _trainFuture = _trainService.getTrainStatus(args.number);
    } else if (args is String) {
      _trainFuture = _trainService.getTrainStatus(args);
    }
  }

  void _showAlternateRoutes(TrainModel train) {
    Navigator.pushNamed(
      context, 
      '/route-suggestions',
      arguments: {
        'from': train.sourceStationCode,
        'to': train.destinationStationCode,
        'currentTrainName': train.name,
        'currentTravelTime': train.travelTimeMinutes,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TrainModel?>(
      future: _trainFuture,
      builder: (context, snapshot) {
        final train = snapshot.data ?? _currentTrain;
        
        if (train == null && snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (train == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Train not found')),
          );
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${train.number} - ${train.name}', 
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800)),
                Text('Scheduled to ${train.nextStation}', 
                  style: GoogleFonts.outfit(fontSize: 11, color: AppThemes.textSecondary)),
              ],
            ),
            actions: [
              IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: () {
                setState(() {
                  _trainFuture = _trainService.getTrainStatus(train.number);
                });
              }),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 120),
                
                // Current Status Hero Card
                _buildStatusHero(train),

                const SizedBox(height: 32),

                // Route Progress Section
                _buildSectionHeader('Route Progress', 'TODAY\'S RUN'),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: train.stations.isEmpty 
                      ? [Center(child: Padding(padding: const EdgeInsets.all(32), child: Text('No schedule data found', style: GoogleFonts.outfit(color: AppThemes.textSecondary))))]
                      : train.stations.map((stn) => _buildStationStep(stn, train.currentStation)).toList(),
                  ),
                ),

                const SizedBox(height: 32),

                // Smart Suggestion
                if (train.status == 'delayed') _buildSmartSuggestion(train),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusHero(TrainModel train) {
    bool isDelayed = train.status == 'delayed';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemes.surfaceSlate,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemes.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: isDelayed ? AppThemes.cancelledRed : AppThemes.onTimeGreen, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text('CURRENT STATUS', style: GoogleFonts.outfit(color: isDelayed ? AppThemes.cancelledRed : AppThemes.onTimeGreen, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isDelayed ? '${train.delayMinutes} mins late' : 'On Time',
                  style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text('At ${train.currentStation} (PF ${train.platform})', 
                  style: GoogleFonts.outfit(fontSize: 14, color: AppThemes.textSecondary, fontWeight: FontWeight.w500)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildHeroButton(Icons.share_rounded, 'Share'),
                    const SizedBox(width: 12),
                    _buildHeroButton(Icons.map_rounded, 'Map'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/train_hero.png',
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppThemes.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppThemes.primaryBlue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppThemes.primaryBlue, size: 14),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.outfit(color: AppThemes.primaryBlue, fontSize: 10, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String tag) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppThemes.surfaceSlate, borderRadius: BorderRadius.circular(6)),
            child: Text(tag, style: GoogleFonts.outfit(color: AppThemes.textSecondary, fontSize: 10, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _buildStationStep(StationStopModel stn, String currentStation) {
    bool isPassed = stn.isPassed;
    bool isCurrent = stn.name == currentStation;

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isPassed ? AppThemes.onTimeGreen : (isCurrent ? AppThemes.primaryBlue : AppThemes.surfaceSlate),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                ),
                child: isPassed ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: isPassed ? AppThemes.onTimeGreen : AppThemes.cardBorder,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(stn.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      if (stn.platform.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(color: AppThemes.primaryBlue.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                          child: Text('PF ${stn.platform}', style: GoogleFonts.outfit(color: AppThemes.primaryBlue, fontSize: 9, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isPassed ? 'Departed: ${stn.arrivalTime}' : 'Scheduled: ${stn.arrivalTime}',
                    style: GoogleFonts.outfit(color: isPassed ? AppThemes.onTimeGreen : AppThemes.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartSuggestion(TrainModel train) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemes.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemes.primaryBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline_rounded, color: AppThemes.primaryBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Smart Suggestion', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                    Text('Avoid delays! Check for faster alternatives.',
                      style: GoogleFonts.outfit(color: AppThemes.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showAlternateRoutes(train),
            child: const Text('View Alternate Routes'),
          ),
        ],
      ),
    );
  }
}
