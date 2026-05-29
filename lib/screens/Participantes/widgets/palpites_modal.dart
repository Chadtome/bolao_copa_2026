import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../services/firebase_service.dart';
import 'palpites_modal/game_list.dart';

class PalpitesModal extends StatefulWidget {
  final String nome;
  final String userId;

  const PalpitesModal({super.key, required this.nome, required this.userId});

  @override
  State<PalpitesModal> createState() => _PalpitesModalState();
}

class _PalpitesModalState extends State<PalpitesModal> {
  String _faseSelecionada = 'Grupo A';
  List<Map<String, dynamic>> _palpites = [];
  bool _isLoading = true;
  String? _campeaoEscolhido;
  Map<String, bool> _fasesStatus = {};

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final bets = await firebaseService.getUserBetsList(widget.userId);
    if (bets != null) _palpites = bets;

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (userDoc.exists && mounted) _campeaoEscolhido = userDoc['campeaoPalpite'];
    } catch (_) {}

    try {
      final doc = await FirebaseFirestore.instance.collection('config').doc('fases').get();
      if (doc.exists && doc.data() != null) {
        doc.data()!.forEach((key, value) => _fasesStatus[key] = value == true);
      }
    } catch (_) {}

    setState(() => _isLoading = false);
  }

  String _getFaseKey(String fase) {
    if (fase.startsWith('Grupo')) return 'fase_grupos';
    if (fase == '16 avos') return '16_avos';
    if (fase == 'Oitavas') return 'oitavas';
    if (fase == 'Quartas') return 'quartas';
    if (fase == 'Semi') return 'semi';
    if (fase == 'Final') return 'final';
    return '';
  }

  bool _isFaseFechada(String fase) => _fasesStatus[_getFaseKey(fase)] == false;

  @override
  Widget build(BuildContext context) {
    final faseFechada = _isFaseFechada(_faseSelecionada);
    final gruposFechada = _isFaseFechada('Grupo A');

    return AlertDialog(
      title: Text('Palpites de ${widget.nome}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_campeaoEscolhido != null && gruposFechada)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.shade800, Colors.green.shade600, Colors.amber.shade700]), borderRadius: BorderRadius.circular(8)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('🏆', style: TextStyle(fontSize: 20)), const SizedBox(width: 8),
                      Text('Campeão: $_campeaoEscolhido', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                    ]),
                  ),
                ),
              DropdownButtonFormField<String>(
                value: _faseSelecionada,
                decoration: InputDecoration(labelText: 'Fase', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                items: const ['Grupo A','Grupo B','Grupo C','Grupo D','Grupo E','Grupo F','Grupo G','Grupo H','Grupo I','Grupo J','Grupo K','Grupo L','16 avos','Oitavas','Quartas','Semi','Final']
                    .map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                onChanged: (v) => setState(() => _faseSelecionada = v!),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))
              else if (!faseFechada)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(children: [const Icon(Icons.lock, size: 40, color: Colors.grey), const SizedBox(height: 12),
                    Text('Palpites disponíveis apenas após o fechamento da fase.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey))]),
                )
              else
                GameList(palpites: _palpites, fase: _faseSelecionada),
            ],
          ),
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('FECHAR'))],
    );
  }
}