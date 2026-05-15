import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/teams.dart';
import '../../../providers/resultados_provider.dart';

class FaseColuna extends StatefulWidget {
  final String titulo;
  final int jogos;
  final bool invertido;
  final List<Map<String, String?>>? confrontos;
  final int? startSlot;

  const FaseColuna({super.key, required this.titulo, required this.jogos, this.invertido = false, this.confrontos, this.startSlot});

  @override
  State<FaseColuna> createState() => _FaseColunaState();
}

class _FaseColunaState extends State<FaseColuna> {
  final Map<int, TextEditingController> _homeControllers = {};
  final Map<int, TextEditingController> _awayControllers = {};
  final Map<int, bool> _penaltisDecididos = {};

  @override
  void dispose() {
    for (var c in _homeControllers.values) {
      c.dispose();
    }
    for (var c in _awayControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getHomeController(int index) {
    if (!_homeControllers.containsKey(index)) {
      _homeControllers[index] = TextEditingController();
    }
    return _homeControllers[index]!;
  }

  TextEditingController _getAwayController(int index) {
    if (!_awayControllers.containsKey(index)) {
      _awayControllers[index] = TextEditingController();
    }
    return _awayControllers[index]!;
  }

  void _avancarProximaFase(int slot, String vencedor, String perdedor, ResultadosProvider resultados) {
    int slotVencedor;
    int slotPerdedor = 0;

    if (slot <= 16) {
      slotVencedor = 33 + ((slot - 1) ~/ 2);
    } else if (slot <= 32) {
      slotVencedor = 41 + ((slot - 17) ~/ 2);
    } else if (slot <= 40) {
      slotVencedor = 49 + ((slot - 33) ~/ 2);
    } else if (slot <= 48) {
      slotVencedor = 53 + ((slot - 41) ~/ 2);
    } else if (slot <= 52) {
      slotVencedor = 57 + ((slot - 49) ~/ 2);
    } else if (slot <= 56) {
      slotVencedor = 59 + ((slot - 53) ~/ 2);
    } else if (slot == 57) {
      slotVencedor = 63;
      slotPerdedor = 62;
    } else if (slot == 58) {
      slotVencedor = 63;
      slotPerdedor = 62;
    } else if (slot == 59) {
      slotVencedor = 64;
      slotPerdedor = 61;
    } else if (slot == 60) {
      slotVencedor = 64;
      slotPerdedor = 61;
    } else {
      return;
    }

    resultados.setAvancou(slotVencedor, vencedor);
    if (slotPerdedor > 0 && perdedor.isNotEmpty) {
      resultados.setAvancou(slotPerdedor, perdedor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.titulo,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        ...List.generate(widget.jogos, (index) => _buildCard(context, index)),
      ],
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    final resultados = Provider.of<ResultadosProvider>(context);

    String timeA = '?';
    String timeB = '?';
    String flagA = '⚽';
    String flagB = '⚽';

    if (widget.confrontos != null && index < widget.confrontos!.length) {
      final c = widget.confrontos![index];
      if (c['timeA'] != null) {
        timeA = c['timeA']!;
        flagA = Teams.get(timeA).flag;
      }
      if (c['timeB'] != null) {
        timeB = c['timeB']!;
        flagB = Teams.get(timeB).flag;
      }
    }

    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Row(
              children: widget.invertido
                  ? [
                      _buildCampos(context, index, resultados, timeA, timeB),
                      Container(width: 1, color: Theme.of(context).dividerColor),
                      _buildTimes(context, timeA, flagA, timeB, flagB, alinharEsquerda: true),
                    ]
                  : [
                      _buildTimes(context, timeA, flagA, timeB, flagB, alinharEsquerda: false),
                      Container(width: 1, color: Theme.of(context).dividerColor),
                      _buildCampos(context, index, resultados, timeA, timeB),
                    ],
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(child: Divider(height: 1, color: Theme.of(context).dividerColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimes(BuildContext context, String timeA, String flagA, String timeB, String flagB, {required bool alinharEsquerda}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_timeRow(context, flagA, timeA, alinharEsquerda), _timeRow(context, flagB, timeB, alinharEsquerda)],
      ),
    );
  }

  Widget _timeRow(BuildContext context, String flag, String name, bool alinharEsquerda) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisAlignment: alinharEsquerda ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: alinharEsquerda
            ? [
                Text(flag, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]
            : [
                Flexible(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(flag, style: const TextStyle(fontSize: 14)),
              ],
      ),
    );
  }

  Widget _buildCampos(BuildContext context, int cardIndex, ResultadosProvider resultados, String timeA, String timeB) {
    final slotA = widget.startSlot != null ? widget.startSlot! + cardIndex * 2 : null;
    final slotB = widget.startSlot != null ? widget.startSlot! + cardIndex * 2 + 1 : null;

    final homeController = _getHomeController(cardIndex);
    final awayController = _getAwayController(cardIndex);

    bool isEmpate() {
      final home = int.tryParse(homeController.text);
      final away = int.tryParse(awayController.text);
      return home != null && away != null && home == away;
    }

    void salvarResultado() {
      final home = int.tryParse(homeController.text);
      final away = int.tryParse(awayController.text);
      if (home != null && away != null && slotA != null && slotB != null) {
        resultados.setResultado(slotA, slotB, home, away);

        if (home > away) {
          if (timeA != '?') _avancarProximaFase(slotA, timeA, timeB != '?' ? timeB : '', resultados);
        } else if (away > home) {
          if (timeB != '?') _avancarProximaFase(slotA, timeB, timeA != '?' ? timeA : '', resultados);
        }
      }
    }

    void passarComPenaltis(bool timeAVenceu) {
      if (slotA != null && slotB != null) {
        _penaltisDecididos[cardIndex] = true;
        if (timeAVenceu && timeA != '?') {
          _avancarProximaFase(slotA, timeA, timeB != '?' ? timeB : '', resultados);
        } else if (!timeAVenceu && timeB != '?') {
          _avancarProximaFase(slotA, timeB, timeA != '?' ? timeA : '', resultados);
        }
        setState(() {});
      }
    }

    final empate = isEmpate() && !(_penaltisDecididos[cardIndex] ?? false);

    return SizedBox(
      width: 30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 18,
            child: TextField(
              controller: homeController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 2,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(counterText: '', isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
              onChanged: (_) => salvarResultado(),
            ),
          ),
          if (empate)
            GestureDetector(
              onTap: () => passarComPenaltis(true),
              child: const Text('⚽', style: TextStyle(fontSize: 10)),
            ),
          SizedBox(height: empate ? 8 : 14),
          SizedBox(
            height: 18,
            child: TextField(
              controller: awayController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 2,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(counterText: '', isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
              onChanged: (_) => salvarResultado(),
            ),
          ),
          if (empate)
            GestureDetector(
              onTap: () => passarComPenaltis(false),
              child: const Text('⚽', style: TextStyle(fontSize: 10)),
            ),
        ],
      ),
    );
  }
}
