import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GerenciarFasesScreen extends StatefulWidget {
  const GerenciarFasesScreen({super.key});

  @override
  State<GerenciarFasesScreen> createState() => _GerenciarFasesScreenState();
}

class _GerenciarFasesScreenState extends State<GerenciarFasesScreen> {
  Map<String, bool> _fases = {
    'fase_grupos': true,
    '16_avos': true,
    'oitavas': true,
    'quartas': true,
    'semi': true,
    'final': true,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarStatus();
  }

  Future<void> _carregarStatus() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('config').doc('fases').get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          doc.data()!.forEach((key, value) {
            if (_fases.containsKey(key)) {
              _fases[key] = value == true;
            }
          });
        });
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _toggleFase(String fase, bool valor) async {
    setState(() => _fases[fase] = valor);
    try {
      await FirebaseFirestore.instance.collection('config').doc('fases').set({fase: valor}, SetOptions(merge: true));
    } catch (e) {
      setState(() => _fases[fase] = !valor);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fasesNome = {
      'fase_grupos': 'Fase de Grupos',
      '16_avos': '16-avos de Final',
      'oitavas': 'Oitavas de Final',
      'quartas': 'Quartas de Final',
      'semi': 'Semifinal',
      'final': 'Final + 3º Lugar',
    };

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Fases')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Controle de bloqueio dos palpites',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Quando indisponível, os usuários não podem editar os palpites da fase.',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          ..._fases.entries.map((entry) {
            final disponivel = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: SwitchListTile(
                title: Text(fasesNome[entry.key] ?? entry.key,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: Text(disponivel ? '🟢 Disponível para palpites' : '🔴 Indisponível (bloqueado)',
                    style: GoogleFonts.inter(fontSize: 11, color: disponivel ? Colors.green : Colors.red)),
                value: disponivel,
                activeColor: Colors.green,
                onChanged: (value) => _toggleFase(entry.key, value),
              ),
            );
          }),
        ],
      ),
    );
  }
}