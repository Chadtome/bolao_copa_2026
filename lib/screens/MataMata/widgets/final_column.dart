import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinalColumn extends StatelessWidget {
  const FinalColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('FINAL', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
        const SizedBox(height: 8),
        _finalista(context, '🇧🇷', 'Brasil'),
        const SizedBox(height: 8),
        const Icon(Icons.arrow_downward, color: Colors.grey, size: 20),
        Image.asset('assets/images/trofeu_copa.png', width: 100, height: 130, fit: BoxFit.contain),
        const Icon(Icons.arrow_upward, color: Colors.grey, size: 20),
        const SizedBox(height: 8),
        _finalista(context, '🇩🇪', 'Alemanha'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.amber.shade300)),
          child: Text('🏆 CAMPEÃO: A definir', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.amber.shade900)),
        ),
      ],
    );
  }

  Widget _finalista(BuildContext context, String flag, String name) {
    return IntrinsicHeight(
      child: Container(
        width: 180,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Flexible(child: Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ),
            Container(width: 1, color: Theme.of(context).dividerColor),
            SizedBox(
              width: 30,
              child: Center(
                child: SizedBox(
                  width: 22, height: 18,
                  child: TextField(
                    textAlign: TextAlign.center, keyboardType: TextInputType.number, maxLength: 2,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(counterText: '', isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}