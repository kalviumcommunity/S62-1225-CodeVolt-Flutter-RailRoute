import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/train_model.dart';
import '../services/train_service.dart';
import '../themes/app_themes.dart';

class RouteSuggestionsScreen extends StatefulWidget {
  const RouteSuggestionsScreen({super.key});

  @override
  State<RouteSuggestionsScreen> createState() => _RouteSuggestionsScreenState();
}

class _RouteSuggestionsScreenState extends State<RouteSuggestionsScreen> {
  final _trainService = TrainService();
  late Future<List<TrainModel>> _alternativesFuture;
  String _currentTrainName = '';
  int _currentTravelTime = 0;
  String _activeFilter = 'Fastest';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      final from = args['from'] as String;
      final to = args['to'] as String;
      _currentTrainName = args['currentTrainName'] as String;
      _currentTravelTime = args['currentTravelTime'] as int? ?? 0;
      _alternativesFuture = _trainService.getTrainsBetweenStations(from, to);
    } else {
      _alternativesFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alternative Routes', style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<List<TrainModel>>(
        future: _alternativesFuture,
        builder: (context, snapshot) {
          final trains = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Original Train Section
                _buildSectionHeader('Original Train', 'Delayed'),
                _buildOriginalTrainCard(),

                const SizedBox(height: 32),

                // Smart Suggestions Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Smart Suggestions', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                      Text('Based on real-time traffic and connection data', 
                        style: GoogleFonts.outfit(fontSize: 12, color: AppThemes.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildFilterChip('Fastest', Icons.bolt_rounded),
                      const SizedBox(width: 8),
                      _buildFilterChip('Earliest', Icons.access_time_rounded),
                      const SizedBox(width: 8),
                      _buildFilterChip('Direct Only', Icons.swap_calls_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Alternative Listings
                ...trains.where((t) => t.name != _currentTrainName).map((t) => _buildAlternativeCard(t)).toList(),
                
                if (trains.isEmpty && snapshot.connectionState != ConnectionState.waiting)
                  const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No alternatives found.'))),
                
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String tag) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.red.withOpacity(0.2))),
            child: Text(tag, style: GoogleFonts.outfit(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginalTrainCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemes.surfaceSlate,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemes.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CURRENT ROUTE', style: GoogleFonts.outfit(color: AppThemes.textSecondary, fontSize: 11, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(_currentTrainName, style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, color: Colors.red, size: 14),
                        const SizedBox(width: 6),
                        Text('Delayed by 1h 45m', style: GoogleFonts.outfit(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF334155).withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.train_rounded, color: AppThemes.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeCol('Departure', '22:00'),
              const Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Divider(color: AppThemes.cardBorder))),
              _buildTimeCol('Arrival', '07:10', textAlign: TextAlign.right),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.location_on_rounded, size: 18),
            label: const Text('Track Live Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: AppThemes.cardBorder),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCol(String label, String time, {TextAlign textAlign = TextAlign.left}) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(label, style: GoogleFonts.outfit(color: AppThemes.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(time, style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    bool isActive = _activeFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppThemes.primaryBlue : AppThemes.surfaceSlate,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? AppThemes.primaryBlue : AppThemes.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? Colors.white : AppThemes.textSecondary, size: 16),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.outfit(color: isActive ? Colors.white : AppThemes.textSecondary, fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeCard(TrainModel train) {
    bool isFaster = _currentTravelTime > 0 && train.travelTimeMinutes > 0 && train.travelTimeMinutes < _currentTravelTime;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isFaster ? AppThemes.primaryBlue.withOpacity(0.5) : AppThemes.cardBorder),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isFaster) const SizedBox(height: 12),
                Text('${train.number} - ${train.name}', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppThemes.onTimeGreen, size: 14),
                    const SizedBox(width: 6),
                    Text('On Time', style: GoogleFonts.outfit(color: AppThemes.onTimeGreen, fontSize: 12, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    if (isFaster)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppThemes.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text('Saves ${(_currentTravelTime - train.travelTimeMinutes)}m', 
                          style: GoogleFonts.outfit(color: AppThemes.primaryBlue, fontSize: 11, fontWeight: FontWeight.w800)),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCompactTime('DEPARTS', '22:45'),
                    _buildCompactTime('DURATION', '${train.travelTimeMinutes}m', isCenter: true),
                    _buildCompactTime('ARRIVES', '07:15', isEnd: true),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AppThemes.primaryBlue),
                        child: const Text('Switch Route'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(color: AppThemes.surfaceSlate, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppThemes.cardBorder)),
                      child: const Icon(Icons.info_outline_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isFaster)
            Positioned(
              top: 0,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(color: AppThemes.primaryBlue, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text('BETTER OPTION', style: GoogleFonts.outfit(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactTime(String label, String value, {bool isCenter = false, bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isCenter ? CrossAxisAlignment.center : (isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start),
      children: [
        Text(label, style: GoogleFonts.outfit(color: AppThemes.textSecondary, fontSize: 9, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
