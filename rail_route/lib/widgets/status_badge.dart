import 'package:flutter/material.dart';
import '../themes/app_themes.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final int? delayMinutes;

  const StatusBadge({
    super.key,
    required this.status,
    this.delayMinutes,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'on time':
        badgeColor = AppThemes.onTimeGreen;
        displayText = 'On Time';
        break;
      case 'delayed':
        badgeColor = AppThemes.delayAmber;
        displayText = delayMinutes != null ? 'Delayed $delayMinutes min' : 'Delayed';
        break;
      case 'cancelled':
        badgeColor = AppThemes.cancelledRed;
        displayText = 'Cancelled';
        break;
      default:
        badgeColor = Colors.grey;
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor, width: 1.5),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
