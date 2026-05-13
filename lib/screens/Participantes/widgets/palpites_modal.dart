import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/group_phase_games.dart';

class PalpitesModal extends StatelessWidget {
  final String nome;

  const PalpitesModal({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    String _faseSelecionada = 'Grupo A';

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Palpites de $nome', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _faseSelecionada,
                  decoration: InputDecoration(
                    labelText: 'Fase',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: const [
                    'Grupo A',
                    'Grupo B',
                    'Grupo C',
                    'Grupo D',
                    'Grupo E',
                    'Grupo F',
                    'Grupo G',
                    'Grupo H',
                    'Grupo I',
                    'Grupo J',
                    'Grupo K',
                    'Grupo L',
                    '16 avos',
                    'Oitavas',
                    'Quartas',
                    'Semi',
                    'Final',
                  ].map((fase) => DropdownMenuItem(value: fase, child: Text(fase))).toList(),
                  onChanged: (value) => setState(() => _faseSelecionada = value!),
                ),
                const SizedBox(height: 16),
                ..._buildGames(_faseSelecionada, context),
              ],
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('FECHAR'))],
        );
      },
    );
  }

  List<Widget> _buildGames(String fase, BuildContext context) {
    if (fase.startsWith('Grupo')) {
      final grupoNome = fase.replaceAll('Grupo ', '');
      final grupos = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];
      final grupoIndex = grupos.indexOf(grupoNome);
      final group = GroupPhaseGames.groups[grupoIndex];
      final games = group['games'] as List;

      return games.map((game) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            dense: true,
            title: Text('${game['homeTeam']} vs ${game['awayTeam']}', style: const TextStyle(fontSize: 13)),
            trailing: Text(
              '? x ?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
            ),
          ),
        );
      }).toList();
    }

    return [
      const Card(
        child: ListTile(dense: true, title: Text('A definir...', style: TextStyle(fontSize: 13))),
      ),
    ];
  }
}
