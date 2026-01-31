import 'package:flutter/material.dart';
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
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias, // Important for the left bar
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left status indicator bar
              Container(
                width: 6,
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
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900, // Extra bold for Gen-Z feel
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  trainName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                              Icon(Icons.access_time_filled_rounded, 
                                size: 16, 
                                color: Theme.of(context).colorScheme.primary
                              ),
                              const SizedBox(width: 6),
                              Text(
                                departureTime!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                            if (platform != null) ...[
                              Icon(Icons.train_rounded, 
                                size: 16, 
                                color: Theme.of(context).colorScheme.primary
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Platform $platform',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
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
