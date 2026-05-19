import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/resultados_provider.dart';
import 'placar_field.dart';

class JogoResultado extends StatefulWidget {
  final String home;
  final String away;
  final String homeFlag;
  final String awayFlag;
  final String date;
  final String time;

  const JogoResultado({
    super.key,
    required this.home,
    required this.away,
    required this.homeFlag,
    required this.awayFlag,
    required this.date,
    required this.time,
  });

  @override
  State<JogoResultado> createState() => _JogoResultadoState();
}

class _JogoResultadoState extends State<JogoResultado> {
  late TextEditingController _homeController;
  late TextEditingController _awayController;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _homeController = TextEditingController();
    _awayController = TextEditingController();
    
    // Carrega valor salvo após o build inicial
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSaved());
  }

  void _loadSaved() {
    final resultados = Provider.of<ResultadosProvider>(context, listen: false);
    final saved = resultados.getResultadoGrupo(widget.home, widget.away);
    if (saved != null && mounted) {
      setState(() {
        _homeController.text = '${saved['home']}';
        _awayController.text = '${saved['away']}';
        _loaded = true;
      });
    }
  }

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    super.dispose();
  }

  void _salvar() {
    final home = int.tryParse(_homeController.text);
    final away = int.tryParse(_awayController.text);
    if (home != null && away != null) {
      final resultados = Provider.of<ResultadosProvider>(context, listen: false);
      resultados.setResultadoGrupo(widget.home, widget.away, home, away);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('${widget.date} - ${widget.time}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
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
                        Flexible(child: Text(widget.home, style: const TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 6),
                        Text(widget.homeFlag, style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  PlacarField(controller: _homeController, onChanged: (_) => _salvar()),
                  const SizedBox(width: 6),
                  const Text('x', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 6),
                  PlacarField(controller: _awayController, onChanged: (_) => _salvar()),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.awayFlag, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Flexible(child: Text(widget.away, style: const TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis)),
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
}