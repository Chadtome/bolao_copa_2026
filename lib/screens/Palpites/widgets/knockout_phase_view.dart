import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/teams.dart';
import '../../../providers/mata_mata_provider.dart';
import '../../../providers/resultados_provider.dart';
import '../../../widgets/match_card.dart';

class KnockoutPhaseView extends StatelessWidget {
  final int currentPhase;
  final Function(String, int, int)? onPalpiteChanged;
  final Map<String, Map<String, int>> palpites;
  final bool showValidation;
  final bool isBlocked;

  const KnockoutPhaseView({super.key, required this.currentPhase, this.onPalpiteChanged, this.palpites = const {}, this.showValidation = false, this.isBlocked = false});

  String _gameId(int index) {
    switch (currentPhase) {
      case 1: return '16avos_${index + 1}';
      case 2: return 'oitavas_${index + 1}';
      case 3: return 'quartas_${index + 1}';
      case 4: return 'semi_${index + 1}';
      case 5: return index == 0 ? 'final' : 'terceiro';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mataMata = Provider.of<MataMataProvider>(context);
    final resultados = Provider.of<ResultadosProvider>(context);
    String? timeDoSlot(int slot) => mataMata.slots[slot] ?? resultados.getTime(slot);
    final jogos = _getConfrontos(currentPhase, mataMata, timeDoSlot);

    if (jogos.isEmpty) {
      return const Center(child: Text('🔜 Em breve', style: TextStyle(fontSize: 18)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: jogos.length,
      itemBuilder: (context, index) {
        final j = jogos[index];
        final timeA = j['timeA'] ?? '?';
        final timeB = j['timeB'] ?? '?';
        final gameId = _gameId(index);

        return MatchCard(
          key: ValueKey(gameId),
          homeTeam: timeA,
          awayTeam: timeB,
          homeFlag: timeA != '?' ? Teams.get(timeA).flag : '⚽',
          awayFlag: timeB != '?' ? Teams.get(timeB).flag : '⚽',
          date: 'A definir',
          time: '',
          status: 'open',
          isEditable: !isBlocked,
          gameId: gameId,
          homeBet: palpites[gameId]?['home'],
          awayBet: palpites[gameId]?['away'],
          showError: showValidation && palpites[gameId] == null,
          onBetChanged: onPalpiteChanged,
        );
      },
    );
  }

  List<Map<String, String?>> _getConfrontos(int phase, MataMataProvider mataMata, String? Function(int) timeDoSlot) {
    switch (phase) {
      case 1:
        final esq = List.generate(8, (i) { final a = 1 + i * 2; return {'timeA': mataMata.slots[a], 'timeB': mataMata.slots[a + 1]}; });
        final dir = List.generate(8, (i) { final a = 17 + i * 2; return {'timeA': mataMata.slots[a], 'timeB': mataMata.slots[a + 1]}; });
        return esq + dir;
      case 2:
        final esq = List.generate(4, (i) => {'timeA': timeDoSlot(33 + i * 2), 'timeB': timeDoSlot(33 + i * 2 + 1)});
        final dir = List.generate(4, (i) => {'timeA': timeDoSlot(41 + i * 2), 'timeB': timeDoSlot(41 + i * 2 + 1)});
        return esq + dir;
      case 3:
        final esq = List.generate(2, (i) => {'timeA': timeDoSlot(49 + i * 2), 'timeB': timeDoSlot(49 + i * 2 + 1)});
        final dir = List.generate(2, (i) => {'timeA': timeDoSlot(53 + i * 2), 'timeB': timeDoSlot(53 + i * 2 + 1)});
        return esq + dir;
      case 4:
        return [{'timeA': timeDoSlot(57), 'timeB': timeDoSlot(58)}, {'timeA': timeDoSlot(59), 'timeB': timeDoSlot(60)}];
      case 5:
        return [{'timeA': timeDoSlot(63), 'timeB': timeDoSlot(64)}, {'timeA': timeDoSlot(61), 'timeB': timeDoSlot(62)}];
      default:
        return [];
    }
  }
}