import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_service.dart';
import 'widgets/group_phase_view.dart';
import 'widgets/knockout_phase_view.dart';

class BetScreen extends StatefulWidget {
  const BetScreen({super.key});

  @override
  State<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  int _currentPhase = 0;
  bool _isLoading = true;
  final Map<String, Map<String, int>> _palpites = {};

  final List<Map<String, dynamic>> _phases = [
    {'title': 'Fase de Grupos', 'icon': Icons.groups},
    {'title': '16-avos de Final', 'icon': Icons.sports_soccer},
    {'title': 'Oitavas de Final', 'icon': Icons.sports_soccer},
    {'title': 'Quartas de Final', 'icon': Icons.sports_soccer},
    {'title': 'Semifinal', 'icon': Icons.emoji_events},
    {'title': 'Final + 3º Lugar', 'icon': Icons.stars},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregarPalpites());
  }

  Future<void> _carregarPalpites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      final bets = await firebaseService.getUserBetsList(user.uid);
      if (bets != null) {
        setState(() {
          for (var bet in bets) {
            _palpites[bet['gameId']] = {
              'home': bet['homeBet'],
              'away': bet['awayBet'],
            };
          }
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar palpites: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onPalpiteChanged(String gameId, int home, int away) {
    _palpites[gameId] = {'home': home, 'away': away};
  }

  Future<void> _salvarPalpites(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login primeiro!'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_palpites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha pelo menos um palpite!'), backgroundColor: Colors.orange),
      );
      return;
    }

    final firebaseService = Provider.of<FirebaseService>(context, listen: false);

    try {
      for (var entry in _palpites.entries) {
        await firebaseService.saveBet(
          userId: user.uid,
          gameId: entry.key,
          homeBet: entry.value['home']!,
          awayBet: entry.value['away']!,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Palpites salvos com sucesso! ✅'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
      );
    }
  }

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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _currentPhase == 0
                  ? GroupPhaseView(key: ValueKey(_palpites.length), onPalpiteChanged: _onPalpiteChanged, palpites: _palpites)
                  : KnockoutPhaseView(currentPhase: _currentPhase, onPalpiteChanged: _onPalpiteChanged, palpites: _palpites),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _salvarPalpites(context),
              icon: const Icon(Icons.save),
              label: const Text('SALVAR TODOS OS PALPITES'),
            ),
          ),
        ),
      ],
    );
  }
}