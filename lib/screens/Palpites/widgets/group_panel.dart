import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/match_card.dart';

class GroupPanel extends StatelessWidget {
  final Map<String, dynamic> group;
  const GroupPanel({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text('Grupo ${group['name']}',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
          ),
          ...List<Widget>.from((group['games'] as List).map((game) => MatchCard(
                homeTeam: game['homeTeam'],
                awayTeam: game['awayTeam'],
                homeFlag: game['homeFlag'],
                awayFlag: game['awayFlag'],
                date: game['date'],
                time: game['time'],
                status: game['status'] ?? 'open',
                isEditable: game['status'] == 'open',
                homeBet: game['homeBet'],
                awayBet: game['awayBet'],
                homeScore: game['homeScore'],
                awayScore: game['awayScore'],
                onBetChanged: (home, away) {
                  debugPrint('Palpite: ${game['homeTeam']} $home x $away ${game['awayTeam']}');
                },
              ))),
        ],
      ),
    );
  }
}