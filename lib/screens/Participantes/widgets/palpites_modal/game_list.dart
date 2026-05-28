import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../data/group_phase_games.dart';
import '../../../../../providers/mata_mata_provider.dart';
import '../../../../../providers/resultados_provider.dart';
import 'resultado_icon.dart';

class GameList extends StatelessWidget {
  final List<Map<String, dynamic>> palpites;
  final String fase;

  const GameList({super.key, required this.palpites, required this.fase});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> palpitesFase;
    if (fase.startsWith('Grupo')) {
      final prefixo = 'grupo_${fase.replaceAll('Grupo ', '')}_';
      palpitesFase = palpites.where((p) => p['gameId'].startsWith(prefixo)).toList();
      _ordenar(palpitesFase);
    } else if (fase == '16 avos') { palpitesFase = palpites.where((p) => p['gameId'].startsWith('16avos_')).toList(); _ordenar(palpitesFase); }
    else if (fase == 'Oitavas') { palpitesFase = palpites.where((p) => p['gameId'].startsWith('oitavas_')).toList(); _ordenar(palpitesFase); }
    else if (fase == 'Quartas') { palpitesFase = palpites.where((p) => p['gameId'].startsWith('quartas_')).toList(); _ordenar(palpitesFase); }
    else if (fase == 'Semi') { palpitesFase = palpites.where((p) => p['gameId'].startsWith('semi_')).toList(); _ordenar(palpitesFase); }
    else if (fase == 'Final') { palpitesFase = palpites.where((p) => p['gameId'] == 'final' || p['gameId'] == 'terceiro').toList(); }
    else { palpitesFase = []; }

    if (palpitesFase.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('Nenhum palpite encontrado.', style: TextStyle(color: Colors.grey)));
    }

    return Column(
      children: palpitesFase.map((p) {
        final gameId = p['gameId'] as String;
        final homeBet = p['homeBet'] as int, awayBet = p['awayBet'] as int;
        final nomes = _getNomes(gameId, context);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            dense: true,
            title: Text('${nomes[0]} vs ${nomes[1]}', style: const TextStyle(fontSize: 13)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ResultadoIcon(gameId: gameId, homeBet: homeBet, awayBet: awayBet),
                const SizedBox(width: 4),
                Text('$homeBet x $awayBet',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String? _timeDoSlot(int slot, BuildContext context) {
    final mataMata = Provider.of<MataMataProvider>(context, listen: false);
    final resultados = Provider.of<ResultadosProvider>(context, listen: false);
    return mataMata.slots[slot] ?? resultados.getTime(slot);
  }

  List<String> _getNomes(String gameId, BuildContext context) {
    String homeTeam = 'Time A', awayTeam = 'Time B';

    if (gameId.startsWith('grupo_')) {
      final partes = gameId.split('_');
      if (partes.length >= 3) {
        final grupoIndex = ['A','B','C','D','E','F','G','H','I','J','K','L'].indexOf(partes[1]);
        if (grupoIndex >= 0) {
          final games = GroupPhaseGames.groups[grupoIndex]['games'] as List;
          final idx = int.tryParse(partes[2]) ?? 0;
          if (idx < games.length) { homeTeam = games[idx]['homeTeam'] ?? 'Time A'; awayTeam = games[idx]['awayTeam'] ?? 'Time B'; }
        }
      }
    } else {
      int? sA;
      if (gameId.startsWith('16avos_')) { final n = int.tryParse(gameId.replaceAll('16avos_', '')) ?? 0; sA = n <= 8 ? 1 + (n-1)*2 : 17 + (n-9)*2; }
      else if (gameId.startsWith('oitavas_')) { final n = int.tryParse(gameId.replaceAll('oitavas_', '')) ?? 0; sA = (n <= 4 ? 33 : 41) + ((n <= 4 ? n-1 : n-5)*2); }
      else if (gameId.startsWith('quartas_')) { final n = int.tryParse(gameId.replaceAll('quartas_', '')) ?? 0; sA = (n <= 2 ? 49 : 53) + ((n <= 2 ? n-1 : n-3)*2); }
      else if (gameId.startsWith('semi_')) { final n = int.tryParse(gameId.replaceAll('semi_', '')) ?? 0; sA = n == 1 ? 57 : 59; }
      else if (gameId == 'final') sA = 63;
      else if (gameId == 'terceiro') sA = 61;
      if (sA != null) { homeTeam = _timeDoSlot(sA, context) ?? 'Time A'; awayTeam = _timeDoSlot(sA + 1, context) ?? 'Time B'; }
    }
    return [homeTeam, awayTeam];
  }

  void _ordenar(List<Map<String, dynamic>> lista) {
    lista.sort((a, b) {
      final aStr = (a['gameId'] as String).split('_').last;
      final bStr = (b['gameId'] as String).split('_').last;
      return (int.tryParse(aStr) ?? 0).compareTo(int.tryParse(bStr) ?? 0);
    });
  }
}