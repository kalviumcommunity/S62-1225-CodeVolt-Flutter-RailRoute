import 'package:flutter/material.dart';

class StationTimeline extends StatelessWidget {
  final List<StationStop> stations;
  final int currentStationIndex;

  const StationTimeline({
    super.key,
    required this.stations,
    required this.currentStationIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        final isPassed = index < currentStationIndex;
        final isCurrent = index == currentStationIndex;
        final isFuture = index > currentStationIndex;

        Color dotColor;
        if (isPassed) {
          dotColor = Colors.grey;
        } else if (isCurrent) {
          dotColor = Theme.of(context).colorScheme.primary;
        } else {
          dotColor = Colors.grey.shade300;
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dotColor,
                        border: Border.all(
                          color: isCurrent ? Theme.of(context).colorScheme.primary : dotColor,
                          width: isCurrent ? 3 : 2,
                        ),
                      ),
                    ),
                    if (index < stations.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: isPassed ? Colors.grey : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          color: isFuture ? Colors.grey : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            station.arrivalTime ?? '--',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (station.platform != null) ...[
                            const SizedBox(width: 12),
                            Text(
                              'Platform ${station.platform}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StationStop {
  final String name;
  final String? arrivalTime;
  final String? platform;

  StationStop({
    required this.name,
    this.arrivalTime,
    this.platform,
  });
}
