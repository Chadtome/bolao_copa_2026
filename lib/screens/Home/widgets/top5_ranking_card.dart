import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Top5RankingCard extends StatelessWidget {
  final bool isWide;

  const Top5RankingCard({super.key, required this.isWide});

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
                'RANKING',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ...List.generate(5, (index) {
                final medals = ['🥇', '🥈', '🥉', '4º', '5º'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      SizedBox(width: 40, child: Text(medals[index], style: const TextStyle(fontSize: 18))),
                      Expanded(
                        child: Text(
                          'Usuário ${index + 1}',
                          style: TextStyle(fontSize: 14, fontWeight: index < 3 ? FontWeight.w600 : FontWeight.w400),
                        ),
                      ),
                      Text(
                        '${50 - index * 5} pts',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}