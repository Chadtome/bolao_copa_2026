import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'score_section.dart';

class MatchCard extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String? homeFlag;
  final String? awayFlag;
  final int? homeScore;
  final int? awayScore;
  final int? homeBet;
  final int? awayBet;
  final String? date;
  final String? time;
  final String status;
  final bool isEditable;
  final Function(int home, int away)? onBetChanged;

  const MatchCard({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    this.homeFlag,
    this.awayFlag,
    this.homeScore,
    this.awayScore,
    this.homeBet,
    this.awayBet,
    this.date,
    this.time,
    this.status = 'open',
    this.isEditable = false,
    this.onBetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            // Data
            SizedBox(
              width: 42,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    date ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    time ?? '',
                    style: GoogleFonts.inter(fontSize: 9, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            // Time casa
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      homeTeam,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Tooltip(
                    message: homeTeam,
                    child: Text(
                      homeFlag ?? '⚽',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Placar
            SizedBox(
              width: 72,
              child: ScoreSection(
                homeScore: homeScore,
                awayScore: awayScore,
                homeBet: homeBet,
                awayBet: awayBet,
                status: status,
                isEditable: isEditable,
                onChanged: onBetChanged,
              ),
            ),

            const SizedBox(width: 8),

            // Time visitante
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Tooltip(
                    message: awayTeam,
                    child: Text(
                      awayFlag ?? '⚽',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      awayTeam,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}