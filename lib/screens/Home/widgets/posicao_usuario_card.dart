import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/firebase_service.dart';

class PosicaoUsuarioCard extends StatelessWidget {
  const PosicaoUsuarioCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    final firebaseService = Provider.of<FirebaseService>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: firebaseService.getUsersStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final users = snapshot.data!.docs;
        int posicao = 1;
        int pontos = 0;

        for (int i = 0; i < users.length; i++) {
          if (users[i].id == user.uid) {
            posicao = i + 1;
            pontos = users[i]['totalPoints'] ?? 0;
            break;
          }
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              Text('Sua posição atual no ranking é:', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 16),
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withOpacity(0.6)]),
                ),
                child: Center(child: Text('${posicao}º', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white))),
              ),
              const SizedBox(height: 12),
              Text('$pontos pontos',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        );
      },
    );
  }
}