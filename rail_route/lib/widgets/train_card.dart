import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'status_badge.dart';
import '../themes/app_themes.dart';

class TrainCard extends StatelessWidget {
  final String trainNumber;
  final String trainName;
  final String status;
  final int? delayMinutes;
  final String? departureTime;
  final String? platform;
  final VoidCallback? onTap;

  const TrainCard({
    super.key,
    required this.trainNumber,
    required this.trainName,
    required this.status,
    this.delayMinutes,
    this.departureTime,
    this.platform,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'on time':
        return AppThemes.onTimeGreen;
      case 'delayed':
        return AppThemes.delayAmber;
      case 'cancelled':
        return AppThemes.cancelledRed;
      default:
        return AppThemes.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppThemes.surfaceSlate,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemes.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 10, // Thicker bar as per design
                color: statusColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trainNumber,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  trainName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppThemes.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StatusBadge(
                            status: status,
                            delayMinutes: delayMinutes,
                          ),
                        ],
                      ),
                      if (departureTime != null || platform != null) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (departureTime != null) ...[
                              const Icon(Icons.access_time_filled_rounded, 
                                size: 14, 
                                color: AppThemes.primaryBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                departureTime!,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                            if (platform != null) ...[
                              const Icon(Icons.train_rounded, 
                                size: 14, 
                                color: AppThemes.primaryBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Platform $platform',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppThemes.primaryBlue,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
