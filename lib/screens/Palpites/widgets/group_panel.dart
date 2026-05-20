import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/match_card.dart';

class GroupPanel extends StatelessWidget {
  final Map<String, dynamic> group;
  final Function(String, int, int)? onPalpiteChanged;
  final Map<String, Map<String, int>> palpites;

  const GroupPanel({super.key, required this.group, this.onPalpiteChanged, this.palpites = const {}});

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
          ...List<Widget>.from((group['games'] as List).asMap().entries.map((entry) {
            final index = entry.key;
            final game = entry.value;
            final gameId = 'grupo_${group['name']}_$index';

            return MatchCard(
              key: ValueKey(gameId),
              homeTeam: game['homeTeam'],
              awayTeam: game['awayTeam'],
              homeFlag: game['homeFlag'],
              awayFlag: game['awayFlag'],
              date: game['date'],
              time: game['time'],
              status: game['status'] ?? 'open',
              isEditable: game['status'] == 'open',
              gameId: gameId,
              homeBet: palpites[gameId]?['home'],
              awayBet: palpites[gameId]?['away'],
              homeScore: game['homeScore'],
              awayScore: game['awayScore'],
              onBetChanged: onPalpiteChanged,
            );
          })),
        ],
      ),
    );
  }
}