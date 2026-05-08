import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JogosDoDiaCard extends StatelessWidget {
  final bool isWide;

  const JogosDoDiaCard({super.key, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Center(
        child: Container(
          width: isWide ? 600 : double.infinity,
          child: Column(
            children: [
              Text(
                'Jogos do Dia',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: isWide
                    ? Row(
                        children: [
                          Expanded(child: _jogoCard()),
                          const SizedBox(width: 8),
                          Expanded(child: _jogoCard()),
                          const SizedBox(width: 8),
                          Expanded(child: _jogoCard()),
                          const SizedBox(width: 8),
                          Expanded(child: _jogoCard()),
                        ],
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 160,
                            margin: const EdgeInsets.only(right: 8),
                            child: _jogoCard(),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jogoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('Jogo')),
    );
  }
}