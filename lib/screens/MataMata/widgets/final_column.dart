import 'package:bolao_copa_2026/data/teams.dart';
import 'package:bolao_copa_2026/providers/resultados_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FinalColumn extends StatefulWidget {
  const FinalColumn({super.key});

  @override
  State<FinalColumn> createState() => _FinalColumnState();
}

class _FinalColumnState extends State<FinalColumn> {
  final _homeController = TextEditingController();
  final _awayController = TextEditingController();
  final _homeTerceiroController = TextEditingController();
  final _awayTerceiroController = TextEditingController();
  bool _penaltisFinalDecididos = false;
  bool _penaltisTerceiroDecididos = false;

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    _homeTerceiroController.dispose();
    _awayTerceiroController.dispose();
    super.dispose();
  }

  bool _isEmpate(TextEditingController c1, TextEditingController c2) {
    final a = int.tryParse(c1.text);
    final b = int.tryParse(c2.text);
    return a != null && b != null && a == b;
  }

  void _salvarResultadoFinal(ResultadosProvider resultados) {
    final home = int.tryParse(_homeController.text);
    final away = int.tryParse(_awayController.text);
    if (home != null && away != null) {
      resultados.setResultado(63, 64, home, away);
    }
  }

  void _salvarResultadoTerceiro(ResultadosProvider resultados) {
    final home = int.tryParse(_homeTerceiroController.text);
    final away = int.tryParse(_awayTerceiroController.text);
    if (home != null && away != null) {
      resultados.setResultado(61, 62, home, away);
    }
  }

  void _passarPenaltisFinal(bool timeCima, ResultadosProvider resultados, String? timeCimaNome, String? timeBaixoNome) {
    _penaltisFinalDecididos = true;
    if (timeCima && timeCimaNome != null) {
      resultados.setAvancou(65, timeCimaNome);
    } else if (!timeCima && timeBaixoNome != null) {
      resultados.setAvancou(65, timeBaixoNome);
    }
    setState(() {});
  }

  void _passarPenaltisTerceiro(bool timeCima, ResultadosProvider resultados, String? timeCimaNome, String? timeBaixoNome) {
    _penaltisTerceiroDecididos = true;
    if (timeCima && timeCimaNome != null) {
      resultados.setAvancou(66, timeCimaNome);
    } else if (!timeCima && timeBaixoNome != null) {
      resultados.setAvancou(66, timeBaixoNome);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final resultados = Provider.of<ResultadosProvider>(context);
    final finalistaCima = resultados.getTime(63);
    final finalistaBaixo = resultados.getTime(64);
    final terceiroCima = resultados.getTime(61);
    final terceiroBaixo = resultados.getTime(62);

    // Campeão: verifica resultado ou pênaltis
    String campeao = 'A definir';
    final resultadoFinal = resultados.getResultado(63, 64);
    if (resultadoFinal != null) {
      if (resultadoFinal['home']! > resultadoFinal['away']!) {
        campeao = finalistaCima ?? '?';
      } else if (resultadoFinal['away']! > resultadoFinal['home']!) {
        campeao = finalistaBaixo ?? '?';
      }
    }
    // Verifica se teve pênaltis
    final campeaoPenaltis = resultados.getTime(65);
    if (campeaoPenaltis != null) {
      campeao = campeaoPenaltis;
    }

    final empateFinal = _isEmpate(_homeController, _awayController) && !_penaltisFinalDecididos;
    final empateTerceiro = _isEmpate(_homeTerceiroController, _awayTerceiroController) && !_penaltisTerceiroDecididos;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 160),
        Text(
          'FINAL',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        _finalista(
          context,
          finalistaCima,
          _homeController,
          (r) => _salvarResultadoFinal(r),
          empateFinal ? () => _passarPenaltisFinal(true, resultados, finalistaCima, finalistaBaixo) : null,
        ),
        const SizedBox(height: 8),
        const Icon(Icons.arrow_downward, color: Colors.grey, size: 20),
        Image.asset('assets/images/trofeu_copa.png', width: 100, height: 130, fit: BoxFit.contain),
        const Icon(Icons.arrow_upward, color: Colors.grey, size: 20),
        const SizedBox(height: 8),
        _finalista(
          context,
          finalistaBaixo,
          _awayController,
          (r) => _salvarResultadoFinal(r),
          empateFinal ? () => _passarPenaltisFinal(false, resultados, finalistaCima, finalistaBaixo) : null,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Text(
            '🏆 CAMPEÃO: $campeao',
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.amber.shade900),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '3º LUGAR',
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.brown.shade400),
        ),
        const SizedBox(height: 8),
        _terceiroLugar(context, terceiroCima, terceiroBaixo, resultados, empateTerceiro),
      ],
    );
  }

  Widget _finalista(
    BuildContext context,
    String? nome,
    TextEditingController controller,
    Function(ResultadosProvider) onSalvar,
    VoidCallback? onPenalti,
  ) {
    final flag = nome != null ? Teams.get(nome).flag : '⚽';
    final name = nome ?? '?';
    final resultados = Provider.of<ResultadosProvider>(context, listen: false);

    return IntrinsicHeight(
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(width: 1, color: Theme.of(context).dividerColor),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 18,
                      child: TextField(
                        controller: controller,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(counterText: '', isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                        onChanged: (_) => onSalvar(resultados),
                      ),
                    ),
                  ),
                ),
                if (onPenalti != null)
                  GestureDetector(
                    onTap: onPenalti,
                    child: const Text('⚽', style: TextStyle(fontSize: 10)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _terceiroLugar(BuildContext context, String? timeA, String? timeB, ResultadosProvider resultados, bool empate) {
    final flagA = timeA != null ? Teams.get(timeA).flag : '⚽';
    final flagB = timeB != null ? Teams.get(timeB).flag : '⚽';
    final nomeA = timeA ?? '?';
    final nomeB = timeB ?? '?';

    return IntrinsicHeight(
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.brown.shade200),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          nomeA,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(flagA, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 18,
                            child: TextField(
                              controller: _homeTerceiroController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                counterText: '',
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              onChanged: (_) => _salvarResultadoTerceiro(resultados),
                            ),
                          ),
                          if (empate)
                            GestureDetector(
                              onTap: () => _passarPenaltisTerceiro(true, resultados, timeA, timeB),
                              child: const Text('⚽', style: TextStyle(fontSize: 10)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          nomeB,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(flagB, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 18,
                            child: TextField(
                              controller: _awayTerceiroController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                counterText: '',
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              onChanged: (_) => _salvarResultadoTerceiro(resultados),
                            ),
                          ),
                          if (empate)
                            GestureDetector(
                              onTap: () => _passarPenaltisTerceiro(false, resultados, timeA, timeB),
                              child: const Text('⚽', style: TextStyle(fontSize: 10)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(child: Divider(height: 1, color: Theme.of(context).dividerColor)),
            ),
            Positioned(top: 0, bottom: 0, right: 42, child: Container(width: 1, color: Theme.of(context).dividerColor)),
          ],
        ),
      ),
    );
  }
}
