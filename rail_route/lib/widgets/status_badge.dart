import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        displayText = delayMinutes != null ? '$delayMinutes Mins Late' : 'Delayed';
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: GoogleFonts.outfit(
          color: badgeColor,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}
