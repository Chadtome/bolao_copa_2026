// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../../data/group_phase_games.dart';
// import '../../../providers/mata_mata_provider.dart';
// import '../../../providers/resultados_provider.dart';
// import '../../../services/firebase_service.dart';

// class PalpitesModal extends StatefulWidget {
//   final String nome;
//   final String userId;

//   const PalpitesModal({super.key, required this.nome, required this.userId});

//   @override
//   State<PalpitesModal> createState() => _PalpitesModalState();
// }

// class _PalpitesModalState extends State<PalpitesModal> {
//   String _faseSelecionada = 'Grupo A';
//   List<Map<String, dynamic>> _palpites = [];
//   bool _isLoading = true;
//   String? _campeaoEscolhido;
//   Map<String, bool> _fasesStatus = {};

//   @override
//   void initState() {
//     super.initState();
//     _carregarPalpites();
//     _carregarCampeao();
//     _carregarStatusFases();
//   }

//   Future<void> _carregarPalpites() async {
//     final firebaseService = Provider.of<FirebaseService>(context, listen: false);
//     final bets = await firebaseService.getUserBetsList(widget.userId);
//     if (bets != null) { setState(() { _palpites = bets; _isLoading = false; }); }
//     else { setState(() => _isLoading = false); }
//   }

//   Future<void> _carregarCampeao() async {
//     try {
//       final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
//       if (userDoc.exists && mounted) setState(() => _campeaoEscolhido = userDoc['campeaoPalpite']);
//     } catch (_) {}
//   }

//   Future<void> _carregarStatusFases() async {
//     try {
//       final doc = await FirebaseFirestore.instance.collection('config').doc('fases').get();
//       if (doc.exists && doc.data() != null) {
//         setState(() { doc.data()!.forEach((key, value) => _fasesStatus[key] = value == true); });
//       }
//     } catch (_) {}
//   }

//   String _getFaseKey(String fase) {
//     if (fase.startsWith('Grupo')) return 'fase_grupos';
//     if (fase == '16 avos') return '16_avos';
//     if (fase == 'Oitavas') return 'oitavas';
//     if (fase == 'Quartas') return 'quartas';
//     if (fase == 'Semi') return 'semi';
//     if (fase == 'Final') return 'final';
//     return '';
//   }

//   bool _isFaseFechada(String fase) => _fasesStatus[_getFaseKey(fase)] == false;

//   @override
//   Widget build(BuildContext context) {
//     final faseFechada = _isFaseFechada(_faseSelecionada);

//     return AlertDialog(
//       title: Text('Palpites de ${widget.nome}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//       content: SizedBox(
//         width: 400,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (_campeaoEscolhido != null)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(colors: [Colors.green.shade800, Colors.green.shade600, Colors.amber.shade700]),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                       const Text('🏆', style: TextStyle(fontSize: 20)), const SizedBox(width: 8),
//                       Text('Campeão: $_campeaoEscolhido', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
//                     ]),
//                   ),
//                 ),
//               DropdownButtonFormField<String>(
//                 value: _faseSelecionada,
//                 decoration: InputDecoration(labelText: 'Fase', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
//                 items: const ['Grupo A','Grupo B','Grupo C','Grupo D','Grupo E','Grupo F','Grupo G','Grupo H','Grupo I','Grupo J','Grupo K','Grupo L','16 avos','Oitavas','Quartas','Semi','Final']
//                     .map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
//                 onChanged: (v) => setState(() => _faseSelecionada = v!),
//               ),
//               const SizedBox(height: 16),
//               if (_isLoading)
//                 const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))
//               else if (!faseFechada)
//                 Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(children: [
//                     const Icon(Icons.lock, size: 40, color: Colors.grey), const SizedBox(height: 12),
//                     Text('Palpites disponíveis apenas após o fechamento da fase.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey)),
//                   ]),
//                 )
//               else
//                 ..._buildGames(_faseSelecionada, context),
//             ],
//           ),
//         ),
//       ),
//       actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('FECHAR'))],
//     );
//   }

//   String? _timeDoSlot(int slot) {
//     final mataMata = Provider.of<MataMataProvider>(context, listen: false);
//     final resultados = Provider.of<ResultadosProvider>(context, listen: false);
//     return mataMata.slots[slot] ?? resultados.getTime(slot);
//   }

//   void _ordenar(List<Map<String, dynamic>> lista) {
//     lista.sort((a, b) {
//       final aStr = (a['gameId'] as String).split('_').last;
//       final bStr = (b['gameId'] as String).split('_').last;
//       return (int.tryParse(aStr) ?? 0).compareTo(int.tryParse(bStr) ?? 0);
//     });
//   }

//   String _getResultadoIcon(String gameId, int homeBet, int awayBet) {
//     final resultados = Provider.of<ResultadosProvider>(context, listen: false);
//     Map<String, dynamic>? real;

//     if (gameId.startsWith('grupo_')) {
//       final partes = gameId.split('_');
//       if (partes.length >= 3) {
//         final grupoNome = partes[1];
//         final index = int.parse(partes[2]);
//         final grupoIndex = ['A','B','C','D','E','F','G','H','I','J','K','L'].indexOf(grupoNome);
//         if (grupoIndex >= 0 && grupoIndex < GroupPhaseGames.groups.length) {
//           final group = GroupPhaseGames.groups[grupoIndex];
//           final games = group['games'] as List;
//           if (index < games.length) {
//             real = resultados.getResultadoGrupo(games[index]['homeTeam'], games[index]['awayTeam']);
//           }
//         }
//       }
//     } else {
//       int? slotA;
//       if (gameId.startsWith('16avos_')) {
//         final num = int.tryParse(gameId.replaceAll('16avos_', '')) ?? 0;
//         slotA = num <= 8 ? 1 + (num - 1) * 2 : 17 + (num - 9) * 2;
//       } else if (gameId.startsWith('oitavas_')) {
//         final num = int.tryParse(gameId.replaceAll('oitavas_', '')) ?? 0;
//         slotA = (num <= 4 ? 33 : 41) + ((num <= 4 ? num - 1 : num - 5) * 2);
//       } else if (gameId.startsWith('quartas_')) {
//         final num = int.tryParse(gameId.replaceAll('quartas_', '')) ?? 0;
//         slotA = (num <= 2 ? 49 : 53) + ((num <= 2 ? num - 1 : num - 3) * 2);
//       } else if (gameId.startsWith('semi_')) {
//         final num = int.tryParse(gameId.replaceAll('semi_', '')) ?? 0;
//         slotA = num == 1 ? 57 : 59;
//       } else if (gameId == 'final') slotA = 63;
//       else if (gameId == 'terceiro') slotA = 61;
//       if (slotA != null) real = resultados.getResultado(slotA, slotA + 1);
//     }

//     if (real == null) return '';
//     final rh = (real['home'] as num).toInt();
//     final ra = (real['away'] as num).toInt();

//     if (homeBet == rh && awayBet == ra) return '✅';
//     if ((rh > ra && homeBet > awayBet) || (rh < ra && homeBet < awayBet) || (rh == ra && homeBet == awayBet)) return '🟡';
//     return '❌';
//   }

//   List<Widget> _buildGames(String fase, BuildContext context) {
//     List<Map<String, dynamic>> palpitesFase;
//     if (fase.startsWith('Grupo')) {
//       final prefixo = 'grupo_${fase.replaceAll('Grupo ', '')}_';
//       palpitesFase = _palpites.where((p) => p['gameId'].startsWith(prefixo)).toList();
//       _ordenar(palpitesFase);
//     } else if (fase == '16 avos') { palpitesFase = _palpites.where((p) => p['gameId'].startsWith('16avos_')).toList(); _ordenar(palpitesFase); }
//     else if (fase == 'Oitavas') { palpitesFase = _palpites.where((p) => p['gameId'].startsWith('oitavas_')).toList(); _ordenar(palpitesFase); }
//     else if (fase == 'Quartas') { palpitesFase = _palpites.where((p) => p['gameId'].startsWith('quartas_')).toList(); _ordenar(palpitesFase); }
//     else if (fase == 'Semi') { palpitesFase = _palpites.where((p) => p['gameId'].startsWith('semi_')).toList(); _ordenar(palpitesFase); }
//     else if (fase == 'Final') { palpitesFase = _palpites.where((p) => p['gameId'] == 'final' || p['gameId'] == 'terceiro').toList(); }
//     else { palpitesFase = []; }

//     if (palpitesFase.isEmpty) {
//       return [const Padding(padding: EdgeInsets.all(16), child: Text('Nenhum palpite encontrado.', style: TextStyle(color: Colors.grey)))];
//     }

//     return palpitesFase.map((p) {
//       final gameId = p['gameId'] as String;
//       final homeBet = p['homeBet'] as int, awayBet = p['awayBet'] as int;
//       String homeTeam = 'Time A', awayTeam = 'Time B';

//       if (gameId.startsWith('grupo_')) {
//         final partes = gameId.split('_');
//         if (partes.length >= 3) {
//           final grupoIndex = ['A','B','C','D','E','F','G','H','I','J','K','L'].indexOf(partes[1]);
//           if (grupoIndex >= 0) {
//             final games = GroupPhaseGames.groups[grupoIndex]['games'] as List;
//             final idx = int.tryParse(partes[2]) ?? 0;
//             if (idx < games.length) { homeTeam = games[idx]['homeTeam'] ?? 'Time A'; awayTeam = games[idx]['awayTeam'] ?? 'Time B'; }
//           }
//         }
//       } else if (gameId.startsWith('16avos_')) {
//         final num = int.tryParse(gameId.replaceAll('16avos_', '')) ?? 0;
//         final sA = num <= 8 ? 1 + (num - 1) * 2 : 17 + (num - 9) * 2;
//         homeTeam = _timeDoSlot(sA) ?? 'Time A'; awayTeam = _timeDoSlot(sA + 1) ?? 'Time B';
//       } else if (gameId.startsWith('oitavas_')) {
//         final num = int.tryParse(gameId.replaceAll('oitavas_', '')) ?? 0;
//         final sA = (num <= 4 ? 33 : 41) + ((num <= 4 ? num - 1 : num - 5) * 2);
//         homeTeam = _timeDoSlot(sA) ?? 'Time A'; awayTeam = _timeDoSlot(sA + 1) ?? 'Time B';
//       } else if (gameId.startsWith('quartas_')) {
//         final num = int.tryParse(gameId.replaceAll('quartas_', '')) ?? 0;
//         final sA = (num <= 2 ? 49 : 53) + ((num <= 2 ? num - 1 : num - 3) * 2);
//         homeTeam = _timeDoSlot(sA) ?? 'Time A'; awayTeam = _timeDoSlot(sA + 1) ?? 'Time B';
//       } else if (gameId.startsWith('semi_')) {
//         final num = int.tryParse(gameId.replaceAll('semi_', '')) ?? 0;
//         final sA = num == 1 ? 57 : 59;
//         homeTeam = _timeDoSlot(sA) ?? 'Time A'; awayTeam = _timeDoSlot(sA + 1) ?? 'Time B';
//       } else if (gameId == 'final') { homeTeam = _timeDoSlot(63) ?? 'Time A'; awayTeam = _timeDoSlot(64) ?? 'Time B'; }
//       else if (gameId == 'terceiro') { homeTeam = _timeDoSlot(61) ?? 'Time A'; awayTeam = _timeDoSlot(62) ?? 'Time B'; }

//       return Card(
//         margin: const EdgeInsets.only(bottom: 8),
//         child: ListTile(
//           dense: true,
//           title: Text('$homeTeam vs $awayTeam', style: const TextStyle(fontSize: 13)),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(_getResultadoIcon(gameId, homeBet, awayBet), style: const TextStyle(fontSize: 14)),
//               const SizedBox(width: 4),
//               Text('$homeBet x $awayBet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
//             ],
//           ),
//         ),
//       );
//     }).toList();
//   }
// }

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

    return AlertDialog(
      title: Text('Palpites de ${widget.nome}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_campeaoEscolhido != null)
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