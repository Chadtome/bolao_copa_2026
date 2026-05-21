import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/group_phase_games.dart';
import '../../../providers/resultados_provider.dart';
import '../../../services/firebase_service.dart';

class RightCard extends StatefulWidget {
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
  State<RightCard> createState() => _RightCardState();
}

class _RightCardState extends State<RightCard> {
  final Map<int, TextEditingController> _homeControllers = {};
  final Map<int, TextEditingController> _awayControllers = {};
  final Map<int, int> _ultimoHome = {};
  final Map<int, int> _ultimoAway = {};

  @override
  void dispose() {
    for (var c in _homeControllers.values) { c.dispose(); }
    for (var c in _awayControllers.values) { c.dispose(); }
    super.dispose();
  }

  TextEditingController _getHomeController(int gameIndex) {
    if (!_homeControllers.containsKey(gameIndex)) {
      _homeControllers[gameIndex] = TextEditingController();
      final group = GroupPhaseGames.groups[widget.grupoIndex];
      final games = group['games'] as List;
      final game = games[gameIndex];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final resultados = Provider.of<ResultadosProvider>(context, listen: false);
        final saved = resultados.getResultadoGrupo(game['homeTeam'], game['awayTeam']);
        if (saved != null) {
          _homeControllers[gameIndex]!.text = '${saved['home']}';
        }
      });
    }
    return _homeControllers[gameIndex]!;
  }

  TextEditingController _getAwayController(int gameIndex) {
    if (!_awayControllers.containsKey(gameIndex)) {
      _awayControllers[gameIndex] = TextEditingController();
      final group = GroupPhaseGames.groups[widget.grupoIndex];
      final games = group['games'] as List;
      final game = games[gameIndex];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final resultados = Provider.of<ResultadosProvider>(context, listen: false);
        final saved = resultados.getResultadoGrupo(game['homeTeam'], game['awayTeam']);
        if (saved != null) {
          _awayControllers[gameIndex]!.text = '${saved['away']}';
        }
      });
    }
    return _awayControllers[gameIndex]!;
  }

  @override
  Widget build(BuildContext context) {
    final group = GroupPhaseGames.groups[widget.grupoIndex];
    final games = group['games'] as List;
    final startIndex = (widget.rodada - 1) * 2;

    return Column(
      children: [
        if (!widget.isMobile) const SizedBox(height: 38),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, size: 28,
                          color: widget.rodada > 1 ? Theme.of(context).colorScheme.primary : Colors.grey),
                      onPressed: widget.onRodadaAnterior,
                    ),
                    Expanded(
                      child: Text('${widget.rodada}º RODADA', textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, size: 28,
                          color: widget.rodada < 3 ? Theme.of(context).colorScheme.primary : Colors.grey),
                      onPressed: widget.onProximaRodada,
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              Expanded(
                child: Column(
                  children: [
                    _buildJogo(startIndex),
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                    _buildJogo(startIndex + 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJogo(int gameIndex) {
    final group = GroupPhaseGames.groups[widget.grupoIndex];
    final games = group['games'] as List;
    final game = games[gameIndex];
    final resultados = Provider.of<ResultadosProvider>(context);

    final homeCtrl = _getHomeController(gameIndex);
    final awayCtrl = _getAwayController(gameIndex);

    void salvar() {
  final home = int.tryParse(homeCtrl.text);
  final away = int.tryParse(awayCtrl.text);
  if (home != null && away != null) {
    if (_ultimoHome[gameIndex] == home && _ultimoAway[gameIndex] == away) return;
    _ultimoHome[gameIndex] = home;
    _ultimoAway[gameIndex] = away;

    resultados.setResultadoGrupo(game['homeTeam'], game['awayTeam'], home, away);

    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final gameId = 'grupo_${group['name']}_$gameIndex';
    debugPrint('🔥 Calculando pontos GRUPO: gameId=$gameId, home=$home, away=$away');
    firebaseService.calculatePointsForGame(gameId, home, away);
  }
}

    // void salvar() {
    //   final home = int.tryParse(homeCtrl.text);
    //   final away = int.tryParse(awayCtrl.text);
    //   if (home != null && away != null) {
    //     if (_ultimoHome[gameIndex] == home && _ultimoAway[gameIndex] == away) return;
    //     _ultimoHome[gameIndex] = home;
    //     _ultimoAway[gameIndex] = away;

    //     resultados.setResultadoGrupo(game['homeTeam'], game['awayTeam'], home, away);

    //     final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    //     final gameId = 'grupo_${group['name']}_$gameIndex';
    //     firebaseService.calculatePointsForGame(gameId, home, away);
    //   }
    // }

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('${game['date']} - ${game['time']}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(child: Text(game['homeTeam'], style: const TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 6),
                        Text(game['homeFlag'], style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  _campo(homeCtrl, salvar),
                  const SizedBox(width: 6),
                  const Text('x', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 6),
                  _campo(awayCtrl, salvar),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(game['awayFlag'], style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Flexible(child: Text(game['awayTeam'], style: const TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campo(TextEditingController controller, VoidCallback onSalvar) {
    return SizedBox(
      width: 30,
      height: 28,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 2,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(counterText: '', isDense: true, contentPadding: EdgeInsets.zero,
            filled: true, fillColor: Colors.transparent, border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
        onChanged: (_) => onSalvar(),
      ),
    );
  }
}