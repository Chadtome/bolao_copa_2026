import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PosicaoUsuarioCard extends StatelessWidget {
  const PosicaoUsuarioCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Caro "Usuário", sua posição atual no ranking é:',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.6),
                ],
              ),
            ),
            child: const Center(
              child: Text('5º',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '52 pontos',
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}