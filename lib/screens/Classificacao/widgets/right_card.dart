import 'package:flutter/material.dart';
import '../../../data/group_phase_games.dart';
import 'jogo_resultado.dart';

class RightCard extends StatelessWidget {
  final int grupoIndex;
  final int rodada;
  final bool isMobile;
  final VoidCallback onRodadaAnterior;
  final VoidCallback onProximaRodada;

  const RightCard({
    super.key,
    required this.grupoIndex,
    required this.rodada,
    this.isMobile = false,
    required this.onRodadaAnterior,
    required this.onProximaRodada,
  });

  @override
  Widget build(BuildContext context) {
    final group = GroupPhaseGames.groups[grupoIndex];
    final games = group['games'] as List;
    final startIndex = (rodada - 1) * 2;

    return Column(
      children: [
        if (!isMobile) const SizedBox(height: 38),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: 28,
                        color: rodada > 1 ? Theme.of(context).colorScheme.primary : Colors.grey,
                      ),
                      onPressed: onRodadaAnterior,
                    ),
                    Expanded(
                      child: Text(
                        '$rodadaº RODADA',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        size: 28,
                        color: rodada < 3 ? Theme.of(context).colorScheme.primary : Colors.grey,
                      ),
                      onPressed: onProximaRodada,
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              Expanded(
                child: Column(
                  children: [
                    JogoResultado(
                      home: games[startIndex]['homeTeam'],
                      away: games[startIndex]['awayTeam'],
                      homeFlag: games[startIndex]['homeFlag'],
                      awayFlag: games[startIndex]['awayFlag'],
                      date: games[startIndex]['date'],
                      time: games[startIndex]['time'],
                    ),
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                    JogoResultado(
                      home: games[startIndex + 1]['homeTeam'],
                      away: games[startIndex + 1]['awayTeam'],
                      homeFlag: games[startIndex + 1]['homeFlag'],
                      awayFlag: games[startIndex + 1]['awayFlag'],
                      date: games[startIndex + 1]['date'],
                      time: games[startIndex + 1]['time'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}