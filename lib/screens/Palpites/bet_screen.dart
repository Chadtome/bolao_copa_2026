import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/group_phase_view.dart';
import 'widgets/knockout_phase_view.dart';

class BetScreen extends StatefulWidget {
  const BetScreen({super.key});

  @override
  State<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  int _currentPhase = 0;

  final List<Map<String, dynamic>> _phases = [
    {'title': 'Fase de Grupos', 'icon': Icons.groups},
    {'title': '16-avos de Final', 'icon': Icons.sports_soccer},
    {'title': 'Oitavas de Final', 'icon': Icons.sports_soccer},
    {'title': 'Quartas de Final', 'icon': Icons.sports_soccer},
    {'title': 'Semifinal', 'icon': Icons.emoji_events},
    {'title': 'Final + 3º Lugar', 'icon': Icons.stars},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPhase > 0 ? () => setState(() => _currentPhase--) : null,
              ),
              Text(_phases[_currentPhase]['title'],
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPhase < _phases.length - 1 ? () => setState(() => _currentPhase++) : null,
              ),
            ],
          ),
        ),
        Expanded(
          child: _currentPhase == 0 ? const GroupPhaseView() : KnockoutPhaseView(currentPhase: _currentPhase),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Palpites salvos com sucesso! ✅'), duration: Duration(seconds: 2)),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('SALVAR TODOS OS PALPITES'),
            ),
          ),
        ),
      ],
    );
  }
}