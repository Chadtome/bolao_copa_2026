import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/palpites_provider.dart';
import '../../services/firebase_service.dart';
import 'widgets/group_phase_view.dart';
import 'widgets/knockout_phase_view.dart';
import 'widgets/campeao_palpite_card.dart';

class BetScreen extends StatefulWidget {
  const BetScreen({super.key});

  @override
  State<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  int _currentPhase = 0;
  bool _isLoading = true;
  bool _showValidation = false;
  bool _isBlocked = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarPalpites();
      _verificarBloqueio();
    });
  }

  Future<void> _carregarPalpites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) { setState(() => _isLoading = false); return; }
    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      final bets = await firebaseService.getUserBetsList(user.uid);
      final palpitesProvider = Provider.of<PalpitesProvider>(context, listen: false);
      if (bets != null) {
        palpitesProvider.carregarDoFirebase(bets);
      }
    } catch (e) { debugPrint('Erro ao carregar palpites: $e'); }
    finally { setState(() => _isLoading = false); }
  }

  Future<void> _verificarBloqueio() async {
    final blocked = await _isFaseBloqueada();
    if (mounted) setState(() => _isBlocked = blocked);
  }

  void _mudarFase(int novaFase) {
    setState(() {
      _currentPhase = novaFase;
      _showValidation = false;
    });
    _verificarBloqueio();
  }

  void _onPalpiteChanged(String gameId, int home, int away) {
    final palpitesProvider = Provider.of<PalpitesProvider>(context, listen: false);
    if (home == -1 && away == -1) {
      palpitesProvider.removePalpite(gameId);
    } else {
      palpitesProvider.setPalpite(gameId, home, away);
    }
    if (_showValidation) setState(() {});
  }

  int _getTotalJogos() {
    if (_currentPhase == 0) return 72;
    if (_currentPhase == 1) return 16;
    if (_currentPhase == 2) return 8;
    if (_currentPhase == 3) return 4;
    if (_currentPhase == 4) return 2;
    if (_currentPhase == 5) return 2;
    return 0;
  }

  Future<bool> _isFaseBloqueada() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('config').doc('fases').get();
      if (doc.exists && doc.data() != null) {
        String faseKey;
        if (_currentPhase == 0) faseKey = 'fase_grupos';
        else if (_currentPhase == 1) faseKey = '16_avos';
        else if (_currentPhase == 2) faseKey = 'oitavas';
        else if (_currentPhase == 3) faseKey = 'quartas';
        else if (_currentPhase == 4) faseKey = 'semi';
        else faseKey = 'final';
        return doc.data()![faseKey] == false;
      }
    } catch (_) {}
    return false;
  }

  Future<void> _salvarPalpites(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login primeiro!'), backgroundColor: Colors.red));
      return;
    }

    if (_isBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Esta fase está bloqueada para palpites! 🔒'), backgroundColor: Colors.orange));
      return;
    }

    final palpitesProvider = Provider.of<PalpitesProvider>(context, listen: false);
    final palpites = palpitesProvider.palpites;

    final totalJogos = _getTotalJogos();
    final preenchidos = palpites.keys.where((k) {
      if (_currentPhase == 0) return k.startsWith('grupo_');
      if (_currentPhase == 1) return k.startsWith('16avos_');
      if (_currentPhase == 2) return k.startsWith('oitavas_');
      if (_currentPhase == 3) return k.startsWith('quartas_');
      if (_currentPhase == 4) return k.startsWith('semi_');
      if (_currentPhase == 5) return k == 'final' || k == 'terceiro';
      return false;
    }).length;

    if (preenchidos < totalJogos) {
      setState(() => _showValidation = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os palpites da fase! ($preenchidos de $totalJogos preenchidos)'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _showValidation = false);
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    try {
      for (var entry in palpites.entries) {
        await firebaseService.saveBet(userId: user.uid, gameId: entry.key, homeBet: entry.value['home']!, awayBet: entry.value['away']!);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Palpites salvos com sucesso! ✅'), backgroundColor: Colors.green));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final palpitesProvider = Provider.of<PalpitesProvider>(context);
    final palpites = palpitesProvider.palpites;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.chevron_left), onPressed: _currentPhase > 0 ? () => _mudarFase(_currentPhase - 1) : null),
              Text(_phases[_currentPhase]['title'],
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
              IconButton(icon: const Icon(Icons.chevron_right), onPressed: _currentPhase < _phases.length - 1 ? () => _mudarFase(_currentPhase + 1) : null),
            ],
          ),
        ),
        if (_isBlocked)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            color: Colors.red.withOpacity(0.1),
            child: const Text('🔒 Esta fase está bloqueada para palpites', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _currentPhase == 0
                  ? GroupPhaseView(onPalpiteChanged: _onPalpiteChanged, palpites: palpites, showValidation: _showValidation, isBlocked: _isBlocked)
                  : KnockoutPhaseView(currentPhase: _currentPhase, onPalpiteChanged: _onPalpiteChanged, palpites: palpites, showValidation: _showValidation, isBlocked: _isBlocked),
        ),
        if (_currentPhase == 0) const CampeaoPalpiteCard(),
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