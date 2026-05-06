import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'editable_score.dart';

class ScoreSection extends StatelessWidget {
  final int? homeScore;
  final int? awayScore;
  final int? homeBet;
  final int? awayBet;
  final String status;
  final bool isEditable;
  final Function(int home, int away)? onChanged;

  const ScoreSection({
    super.key,
    this.homeScore,
    this.awayScore,
    this.homeBet,
    this.awayBet,
    required this.status,
    required this.isEditable,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditable && status == 'open') {
      return EditableScore(
        homeBet: homeBet,
        awayBet: awayBet,
        onChanged: onChanged,
      );
    }

    if (status == 'finished' && homeScore != null) {
      return Center(
        child: Text(
          '$homeScore x $awayScore',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (homeBet != null) {
      return Center(
        child: Text(
          '$homeBet x $awayBet',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      );
    }

    return Center(
      child: Text(
        '? x ?',
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}