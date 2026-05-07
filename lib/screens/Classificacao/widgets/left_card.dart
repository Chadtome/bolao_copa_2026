import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/group_phase_games.dart';
import 'team_row.dart';

class LeftCard extends StatelessWidget {
  final String grupoNome;
  final int groupIndex;

  const LeftCard({
    super.key,
    required this.grupoNome,
    required this.groupIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grupo $grupoNome',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Row(
                  children: [
                    SizedBox(width: 24),
                    Expanded(flex: 3, child: Text('Classificação', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('P', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('J', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('V', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('E', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('D', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('GP', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('GC', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('SG', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              Expanded(child: _buildTeamList(context, groupIndex)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamList(BuildContext context, int groupIndex) {
    final group = GroupPhaseGames.groups[groupIndex];
    final games = group['games'] as List;

    final teams = <String>[];
    for (var game in games) {
      if (!teams.contains(game['homeTeam'])) teams.add(game['homeTeam']);
      if (!teams.contains(game['awayTeam'])) teams.add(game['awayTeam']);
    }

    return Column(
      children: [
        for (int j = 0; j < teams.length; j++) ...[
          TeamRow(pos: j + 1, name: teams[j]),
          if (j < teams.length - 1)
            Divider(height: 1, color: Theme.of(context).dividerColor),
        ],
      ],
    );
  }
}