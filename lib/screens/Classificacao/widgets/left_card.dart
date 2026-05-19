import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/group_phase_games.dart';
import '../../../providers/resultados_provider.dart';
import '../../../services/group_classifier.dart';
import 'team_row.dart';

class LeftCard extends StatelessWidget {
  final String grupoNome;
  final int groupIndex;

  const LeftCard({super.key, required this.grupoNome, required this.groupIndex});

  @override
  Widget build(BuildContext context) {
    final resultados = Provider.of<ResultadosProvider>(context);

    final group = GroupPhaseGames.groups[groupIndex];
    final games = group['games'] as List;

    final resultadosMap = <String, Map<String, dynamic>>{};
    for (var game in games) {
      final r = resultados.getResultadoGrupo(game['homeTeam'], game['awayTeam']);
      if (r != null) {
        resultadosMap['${game['homeTeam']}_${game['awayTeam']}'] = r;
      }
    }

    final classifier = GroupClassifier(resultadosMap);
    final teams = classifier.classificar(groupIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Grupo $grupoNome', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
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
              Expanded(
                child: Column(
                  children: [
                    for (int j = 0; j < teams.length; j++) ...[
                      TeamRow(pos: j + 1, name: teams[j], teamData: _getTeamData(teams[j], games, resultados)),
                      if (j < teams.length - 1) Divider(height: 1, color: Theme.of(context).dividerColor),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, int> _getTeamData(String team, List games, ResultadosProvider resultados) {
    int pontos = 0, jogos = 0, vitorias = 0, empates = 0, derrotas = 0, gp = 0, gc = 0;

    for (var game in games) {
      final r = resultados.getResultadoGrupo(game['homeTeam'], game['awayTeam']);
      if (r == null) continue;

      final home = (r['home'] as num).toInt();
      final away = (r['away'] as num).toInt();

      if (game['homeTeam'] == team) {
        jogos++;
        gp += home;
        gc += away;
        if (home > away) { pontos += 3; vitorias++; }
        else if (home == away) { pontos += 1; empates++; }
        else derrotas++;
      } else if (game['awayTeam'] == team) {
        jogos++;
        gp += away;
        gc += home;
        if (away > home) { pontos += 3; vitorias++; }
        else if (home == away) { pontos += 1; empates++; }
        else derrotas++;
      }
    }

    return {'P': pontos, 'J': jogos, 'V': vitorias, 'E': empates, 'D': derrotas, 'GP': gp, 'GC': gc, 'SG': gp - gc};
  }
}