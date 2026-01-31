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
        Color textColor;
        double opacity = 1.0;

        if (isPassed) {
          dotColor = Theme.of(context).colorScheme.primary.withOpacity(0.4);
          textColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
          opacity = 0.5;
        } else if (isCurrent) {
          dotColor = Theme.of(context).colorScheme.primary;
          textColor = Theme.of(context).colorScheme.onSurface;
          opacity = 1.0;
        } else {
          dotColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.1);
          textColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.3);
          opacity = 0.4;
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrent ? Colors.white : dotColor,
                        border: Border.all(
                          color: dotColor,
                          width: isCurrent ? 4 : 2,
                        ),
                        boxShadow: isCurrent ? [
                          BoxShadow(
                            color: dotColor.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ] : null,
                      ),
                    ),
                    if (index < stations.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: dotColor,
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
                      Row(
                        children: [
                          Text(
                            station.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                              color: textColor,
                              letterSpacing: isCurrent ? -0.5 : 0,
                            ),
                          ),
                          if (isCurrent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            station.arrivalTime,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                              color: textColor.withOpacity(textColor.opacity * 0.7),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Platform ${station.platform}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                              color: textColor.withOpacity(textColor.opacity * 0.7),
                            ),
                          ),
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
