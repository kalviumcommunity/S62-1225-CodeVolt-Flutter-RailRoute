import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/train_card.dart';
import '../models/train_model.dart';
import '../services/train_service.dart';
import '../themes/app_themes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _trainService = TrainService();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchTrain() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final results = await _trainService.searchTrains(query);
      if (results.isNotEmpty && mounted) {
        Navigator.pushNamed(
          context,
          '/train-status',
          arguments: results.first,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Train not found')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppThemes.primaryBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.train_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Text('RailRoute', style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search train number or name',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: const Icon(Icons.mic_none_rounded),
                ),
                onSubmitted: (_) => _searchTrain(),
              ),
            ),

            // Live Status Hero Card
            _buildLiveStatusHero(),

            const SizedBox(height: 24),

            // Favorite Routes
            _buildSectionHeader('Favorite Routes', 'View All'),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                   _buildFavoriteCard('DAILY COMMUTE', 'NDLS → GZB', Icons.home_rounded),
                   _buildFavoriteCard('BUSINESS TRIP', 'CSMT → PUNE', Icons.work_rounded),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Searches
            _buildSectionHeader('Recent Searches', 'Clear'),
            _buildRecentSearchItem('12002 - Shatabdi Express', 'Bhopal to New Delhi'),
            _buildRecentSearchItem('22436 - Vande Bharat Exp', 'Varanasi to New Delhi'),
            _buildRecentSearchItem('12952 - Mumbai Rajdhani', 'Mumbai Central to New Delhi'),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppThemes.surfaceSlate,
        selectedItemColor: AppThemes.primaryBlue,
        unselectedItemColor: AppThemes.textSecondary,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.train_rounded), label: 'PNR'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_rounded), label: 'Stations'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppThemes.primaryBlue,
        child: const Icon(Icons.map_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildLiveStatusHero() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppThemes.primaryBlue, const Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('12301 - HOWRAH RAJDHANI', style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w700)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                      child: Text('DELAY', style: GoogleFonts.outfit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('New Delhi (NDLS)', style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                    Container(
                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                       decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                       child: Text('15 Mins Late', style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text('DEPARTURE: 16:55', style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w600)),
                     Text('ARRIVAL: 10:00 (+1)', style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress Bar
                Stack(
                  children: [
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(3)),
                    ),
                    Container(
                      height: 6,
                      width: 150, // Mock progress
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text('Approaching Kanpur Central', style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Text('Details', style: GoogleFonts.outfit(color: AppThemes.primaryBlue, fontSize: 14, fontWeight: FontWeight.w800)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios_rounded, color: AppThemes.primaryBlue, size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          Text(action, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppThemes.primaryBlue)),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(String label, String route, IconData icon) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemes.surfaceSlate,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppThemes.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppThemes.primaryBlue, size: 24),
              const Icon(Icons.more_vert_rounded, color: AppThemes.textSecondary, size: 16),
            ],
          ),
          const Spacer(),
          Text(label, style: GoogleFonts.outfit(color: AppThemes.textSecondary, fontSize: 10, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(route, style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemes.surfaceSlate,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppThemes.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, color: AppThemes.textSecondary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                Text(subtitle, style: GoogleFonts.outfit(color: AppThemes.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Icons.north_west_rounded, color: AppThemes.textSecondary, size: 18),
        ],
      ),
    );
  }
}
