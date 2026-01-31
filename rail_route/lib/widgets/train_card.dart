import 'package:flutter/material.dart';
import 'status_badge.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trainName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
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
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (departureTime != null) ...[
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        departureTime!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (platform != null) ...[
                      const Icon(Icons.train, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Platform $platform',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
