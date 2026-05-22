import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../data/teams.dart';
import '../../../../services/firebase_service.dart';

class CampeaoPalpiteCard extends StatefulWidget {
  const CampeaoPalpiteCard({super.key});

  @override
  State<CampeaoPalpiteCard> createState() => _CampeaoPalpiteCardState();
}

class _CampeaoPalpiteCardState extends State<CampeaoPalpiteCard> {
  String? _selecionado;
  bool _salvo = false;

  @override
  void initState() {
    super.initState();
    _carregarPalpite();
  }

  Future<void> _carregarPalpite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      final userData = await firebaseService.getCurrentUserData();
      if (userData != null && userData.campeaoPalpite != null && mounted) {
        setState(() {
          _selecionado = userData.campeaoPalpite;
          _salvo = true;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade800, Colors.green.shade600, Colors.amber.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 8),
              Text('Escolha seu Campeão!',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Vale 10 pontos no final', style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.8))),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selecionado,
            isExpanded: true,
            hint: const Text('Selecione uma seleção', style: TextStyle(color: Colors.white70)),
            dropdownColor: Colors.green.shade800,
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              prefixIcon: const Icon(Icons.flag, color: Colors.white),
            ),
            items: Teams.all.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Row(
                  children: [
                    Text(entry.value.flag, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Flexible(child: Text(entry.key, style: const TextStyle(fontSize: 13, color: Colors.white))),
                  ],
                ),
              );
            }).toList(),
            onChanged: _salvo ? null : (value) {
              setState(() => _selecionado = value);
            },
          ),
          const SizedBox(height: 12),
          if (!_salvo)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selecionado != null
                    ? () => _salvar(user.uid)
                    : null,
                icon: const Icon(Icons.check),
                label: const Text('CONFIRMAR CAMPEÃO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Campeão escolhido: $_selecionado',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _salvar(String userId) async {
    if (_selecionado == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Atenção!'),
        content: Text('Você está escolhendo "$_selecionado" como campeão.\n\nEsta escolha não poderá ser alterada depois!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      await firebaseService.salvarCampeaoPalpite(userId, _selecionado!);
      setState(() => _salvo = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campeão escolhido com sucesso! 🏆'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
      );
    }
  }
}