import 'package:bolao_copa_2026/screens/Classificacao/widgets/best_third_table.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/resultados_provider.dart';
import 'widgets/group_phase_view.dart';
import '../MataMata/mata_mata_screen.dart';

class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  Map<int, int> _rodadas = {for (int i = 0; i < 12; i++) i: 1};
  int _faseAtual = 0;
  final _titulos = ['FASE DE GRUPOS', 'MELHORES TERCEIROS', 'MATA-MATA'];

 @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await Provider.of<ResultadosProvider>(context, listen: false).carregarDoFirestore();
    if (mounted) setState(() {});
  });
}

  void _rodadaAnterior(int grupoIndex) {
    if (_rodadas[grupoIndex]! > 1) setState(() => _rodadas[grupoIndex] = _rodadas[grupoIndex]! - 1);
  }

  void _proximaRodada(int grupoIndex) {
    if (_rodadas[grupoIndex]! < 3) setState(() => _rodadas[grupoIndex] = _rodadas[grupoIndex]! + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: _faseAtual > 0 ? Theme.of(context).colorScheme.primary : Colors.grey),
                onPressed: _faseAtual > 0 ? () => setState(() => _faseAtual--) : null,
              ),
              Expanded(
                child: Text(_titulos[_faseAtual], textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: _faseAtual < 2 ? Theme.of(context).colorScheme.primary : Colors.grey),
                onPressed: _faseAtual < 2 ? () => setState(() => _faseAtual++) : null,
              ),
            ],
          ),
        ),
        Expanded(
          child: _faseAtual == 0
              ? GroupPhaseView(rodadas: _rodadas, onRodadaAnterior: _rodadaAnterior, onProximaRodada: _proximaRodada)
              : _faseAtual == 1
                  ? const BestThirdsTable()
                  : const MataMataScreen(),
        ),
      ],
    );
  }
}