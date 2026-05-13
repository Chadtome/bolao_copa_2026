import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/participante_list.dart';

class ParticipantesScreen extends StatelessWidget {
  const ParticipantesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'PARTICIPANTES',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ParticipanteList(isWide: constraints.maxWidth > 800);
            },
          ),
        ),
      ],
    );
  }
}
