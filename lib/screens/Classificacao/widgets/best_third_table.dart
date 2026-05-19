import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/group_phase_games.dart';
import '../../../providers/resultados_provider.dart';
import '../../../services/group_classifier.dart';
import 'tbl_cell.dart';

class BestThirdsTable extends StatelessWidget {
  const BestThirdsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final resultados = Provider.of<ResultadosProvider>(context);

    // Pega os 3º colocados de cada grupo com seus dados
    final thirdsData = _getAllThirdsData(resultados);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final col0Width = isWide ? 300.0 : 160.0;

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: Colors.orange.shade700, size: isWide ? 28 : 22),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Melhores Terceiros Colocados',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isWide ? 24 : 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: isWide ? 800 : double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Classificam-se os 8 melhores para as Oitavas de Final',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          columnWidths: {
                            0: FixedColumnWidth(col0Width),
                            1: const FixedColumnWidth(60),
                            2: const FixedColumnWidth(50),
                            3: const FixedColumnWidth(50),
                            4: const FixedColumnWidth(50),
                            5: const FixedColumnWidth(50),
                            6: const FixedColumnWidth(60),
                            7: const FixedColumnWidth(60),
                            8: const FixedColumnWidth(60),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Theme.of(context).dividerColor.withOpacity(0.3)),
                              children: const [
                                TblCell('Classificação', bold: true),
                                TblCell('P', bold: true),
                                TblCell('J', bold: true),
                                TblCell('V', bold: true),
                                TblCell('E', bold: true),
                                TblCell('D', bold: true),
                                TblCell('GP', bold: true),
                                TblCell('GC', bold: true),
                                TblCell('SG', bold: true),
                              ],
                            ),
                            for (int i = 0; i < 12; i++)
                              TableRow(
                                decoration: i == 7
                                    ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.green.shade700, width: 2)))
                                    : null,
                                children: [
                                  TblCell(
                                    '${i + 1}º  ${thirdsData[i]['time']}',
                                    ellipsis: !isWide,
                                    align: TextAlign.start,
                                    padding: const EdgeInsets.only(left: 8),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: i < 8 ? FontWeight.bold : FontWeight.w400,
                                      color: i < 8 ? Colors.green.shade700 : Colors.grey,
                                    ),
                                  ),
                                  TblCell('${thirdsData[i]['P']}', style: const TextStyle(fontSize: 16)),
                                  TblCell('${thirdsData[i]['J']}', style: const TextStyle(fontSize: 16)),
                                  TblCell('${thirdsData[i]['V']}', style: const TextStyle(fontSize: 16)),
                                  TblCell('${thirdsData[i]['E']}', style: const TextStyle(fontSize: 16)),
                                  TblCell('${thirdsData[i]['D']}', style: const TextStyle(fontSize: 16)),
                                  TblCell('${thirdsData[i]['GP']}', style: const TextStyle(fontSize: 16)),
                                  TblCell('${thirdsData[i]['GC']}', style: const TextStyle(fontSize: 16)),
                                  TblCell('${thirdsData[i]['SG']}', style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(2)),
                          ),
                          const SizedBox(width: 6),
                          Text('Classificados (8 primeiros)',
                              style: GoogleFonts.inter(fontSize: 11, color: Colors.green.shade700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static List<Map<String, dynamic>> _getAllThirdsData(ResultadosProvider resultados) {
    final allThirds = <Map<String, dynamic>>[];

    for (int i = 0; i < 12; i++) {
      final group = GroupPhaseGames.groups[i];
      final games = group['games'] as List;

      // Constrói mapa de resultados para o classificador
      final resultadosMap = <String, Map<String, dynamic>>{};
      for (var game in games) {
        final r = resultados.getResultadoGrupo(game['homeTeam'], game['awayTeam']);
        if (r != null) {
          resultadosMap['${game['homeTeam']}_${game['awayTeam']}'] = r;
        }
      }

      final classifier = GroupClassifier(resultadosMap);
      final teams = classifier.classificar(i);
      final thirdTeam = teams[2]; // 3º colocado

      // Calcula dados do time
      int pontos = 0, jogos = 0, vitorias = 0, empates = 0, derrotas = 0, gp = 0, gc = 0;

      for (var game in games) {
        final r = resultados.getResultadoGrupo(game['homeTeam'], game['awayTeam']);
        if (r == null) continue;

        final home = (r['home'] as num).toInt();
        final away = (r['away'] as num).toInt();

        if (game['homeTeam'] == thirdTeam) {
          jogos++; gp += home; gc += away;
          if (home > away) { pontos += 3; vitorias++; }
          else if (home == away) { pontos += 1; empates++; }
          else derrotas++;
        } else if (game['awayTeam'] == thirdTeam) {
          jogos++; gp += away; gc += home;
          if (away > home) { pontos += 3; vitorias++; }
          else if (home == away) { pontos += 1; empates++; }
          else derrotas++;
        }
      }

      allThirds.add({
        'time': thirdTeam,
        'P': pontos, 'J': jogos, 'V': vitorias, 'E': empates, 'D': derrotas,
        'GP': gp, 'GC': gc, 'SG': gp - gc,
      });
    }

    // Ordena por pontos, saldo, gols marcados
    allThirds.sort((a, b) {
      if (a['P'] != b['P']) return (b['P'] as int).compareTo(a['P'] as int);
      if (a['SG'] != b['SG']) return (b['SG'] as int).compareTo(a['SG'] as int);
      return (b['GP'] as int).compareTo(a['GP'] as int);
    });

    return allThirds;
  }
}