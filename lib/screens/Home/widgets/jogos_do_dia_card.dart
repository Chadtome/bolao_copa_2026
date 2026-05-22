import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/group_phase_games.dart';

class JogosDoDiaCard extends StatelessWidget {
  final bool isWide;

  const JogosDoDiaCard({super.key, required this.isWide});

  List<Map<String, String>> _getJogosDoDia() {
    final hoje = DateTime.now();
    final dia = '${hoje.day.toString().padLeft(2, '0')}/${hoje.month.toString().padLeft(2, '0')}';
    
    final jogos = <Map<String, String>>[];
    for (var group in GroupPhaseGames.groups) {
      final games = group['games'] as List;
      for (var game in games) {
        if (game['date'] == dia) {
          jogos.add({
            'home': game['homeTeam'],
            'away': game['awayTeam'],
            'homeFlag': game['homeFlag'],
            'awayFlag': game['awayFlag'],
            'time': game['time'],
          });
        }
      }
    }
    return jogos;
  }

  @override
  Widget build(BuildContext context) {
    final jogos = _getJogosDoDia();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Center(
        child: Container(
          width: isWide ? 600 : double.infinity,
          child: Column(
            children: [
              Text('Jogos do Dia', textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              if (jogos.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Não há jogos hoje 😴',
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
                )
              else
                SizedBox(
                  height: 140,
                  child: isWide
                      ? Row(
                          children: jogos.take(4).map((j) => Expanded(child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _jogoCard(j),
                          ))).toList(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: jogos.length,
                          itemBuilder: (context, index) => Container(
                            width: 160, margin: const EdgeInsets.only(right: 8),
                            child: _jogoCard(jogos[index]),
                          ),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jogoCard(Map<String, String> jogo) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(jogo['homeFlag'] ?? '⚽', style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Flexible(child: Text(jogo['home'] ?? '?', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 6),
          Text(jogo['time'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(jogo['awayFlag'] ?? '⚽', style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Flexible(child: Text(jogo['away'] ?? '?', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      ),
    );
  }
}