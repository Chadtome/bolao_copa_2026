import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../data/group_phase_games.dart';
import '../../../../../providers/resultados_provider.dart';

class ResultadoIcon extends StatelessWidget {
  final String gameId;
  final int homeBet;
  final int awayBet;

  const ResultadoIcon({super.key, required this.gameId, required this.homeBet, required this.awayBet});

  @override
  Widget build(BuildContext context) {
    final resultados = Provider.of<ResultadosProvider>(context, listen: false);
    Map<String, dynamic>? real;

    if (gameId.startsWith('grupo_')) {
      final partes = gameId.split('_');
      if (partes.length >= 3) {
        final grupoIndex = ['A','B','C','D','E','F','G','H','I','J','K','L'].indexOf(partes[1]);
        if (grupoIndex >= 0) {
          final games = GroupPhaseGames.groups[grupoIndex]['games'] as List;
          final idx = int.tryParse(partes[2]) ?? 0;
          if (idx < games.length) {
            real = resultados.getResultadoGrupo(games[idx]['homeTeam'], games[idx]['awayTeam']);
          }
        }
      }
    } else {
      int? slotA;
      if (gameId.startsWith('16avos_')) {
        final num = int.tryParse(gameId.replaceAll('16avos_', '')) ?? 0;
        slotA = num <= 8 ? 1 + (num - 1) * 2 : 17 + (num - 9) * 2;
      } else if (gameId.startsWith('oitavas_')) {
        final num = int.tryParse(gameId.replaceAll('oitavas_', '')) ?? 0;
        slotA = (num <= 4 ? 33 : 41) + ((num <= 4 ? num - 1 : num - 5) * 2);
      } else if (gameId.startsWith('quartas_')) {
        final num = int.tryParse(gameId.replaceAll('quartas_', '')) ?? 0;
        slotA = (num <= 2 ? 49 : 53) + ((num <= 2 ? num - 1 : num - 3) * 2);
      } else if (gameId.startsWith('semi_')) {
        final num = int.tryParse(gameId.replaceAll('semi_', '')) ?? 0;
        slotA = num == 1 ? 57 : 59;
      } else if (gameId == 'final') slotA = 63;
      else if (gameId == 'terceiro') slotA = 61;
      if (slotA != null) real = resultados.getResultado(slotA, slotA + 1);
    }

    if (real == null) return const SizedBox();
    final rh = (real['home'] as num).toInt();
    final ra = (real['away'] as num).toInt();

    String icon;
    if (homeBet == rh && awayBet == ra) icon = '✅';
    else if ((rh > ra && homeBet > awayBet) || (rh < ra && homeBet < awayBet) || (rh == ra && homeBet == awayBet)) icon = '🟡';
    else icon = '❌';

    return Text(icon, style: const TextStyle(fontSize: 14));
  }
}