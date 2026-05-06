import 'package:bolao_copa_2026/data/group_phase_games.dart';
import 'package:bolao_copa_2026/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BetScreen extends StatefulWidget {
  const BetScreen({super.key});

  @override
  State<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  int _currentPhase = 0;

  final List<Map<String, dynamic>> _phases = [
    {'title': 'Fase de Grupos', 'icon': Icons.groups},
    {'title': 'Oitavas de Final', 'icon': Icons.sports_soccer},
    {'title': 'Quartas de Final', 'icon': Icons.sports_soccer},
    {'title': 'Semifinal', 'icon': Icons.emoji_events},
    {'title': 'Final', 'icon': Icons.stars},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Navegação entre fases
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPhase > 0
                    ? () => setState(() => _currentPhase--)
                    : null,
              ),
              Text(
                _phases[_currentPhase]['title'],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPhase < _phases.length - 1
                    ? () => setState(() => _currentPhase++)
                    : null,
              ),
            ],
          ),
        ),

        // Conteúdo
        Expanded(
          child: _currentPhase == 0
              ? _buildGroupPhase(context)
              : _buildKnockoutPlaceholder(),
        ),

        // Botão SALVAR
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Palpites salvos com sucesso! ✅'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('SALVAR TODOS OS PALPITES'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupPhase(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isWide = constraints.maxWidth > 600;

      if (isWide) {
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: (GroupPhaseGames.groups.length / 2).ceil(),
          itemBuilder: (context, index) {
            final i = index * 2;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _GroupPanel(group: GroupPhaseGames.groups[i]),
                  ),
                  const SizedBox(width: 8),
                  if (i + 1 < GroupPhaseGames.groups.length)
                    Expanded(
                      child: _GroupPanel(group: GroupPhaseGames.groups[i + 1]),
                    )
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
            );
          },
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: GroupPhaseGames.groups.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _GroupPanel(group: GroupPhaseGames.groups[index]),
        ),
      );
    },
  );
}


  Widget _buildKnockoutPlaceholder() {
    return const Center(
      child: Text(
        '🔜 Em breve\nOitavas de Final',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class _GroupPanel extends StatelessWidget {
  final Map<String, dynamic> group;
  const _GroupPanel({required this.group});

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
            child: Text(
              'Grupo ${group['name']}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ...List<Widget>.from(
            (group['games'] as List).map((game) => MatchCard(
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
                )),
          ),
        ],
      ),
    );
  }
}