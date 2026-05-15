import 'package:bolao_copa_2026/data/teams.dart';
import 'package:bolao_copa_2026/providers/resultados_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FinalColumn extends StatelessWidget {
  const FinalColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final resultados = Provider.of<ResultadosProvider>(context);
    final finalistaCima = resultados.getTime(63);
    final finalistaBaixo = resultados.getTime(64);
    final terceiroCima = resultados.getTime(61);
    final terceiroBaixo = resultados.getTime(62);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 160),
        Text(
          'FINAL',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        _finalista(context, finalistaCima),
        const SizedBox(height: 8),
        const Icon(Icons.arrow_downward, color: Colors.grey, size: 20),
        Image.asset('assets/images/trofeu_copa.png', width: 100, height: 130, fit: BoxFit.contain),
        const Icon(Icons.arrow_upward, color: Colors.grey, size: 20),
        const SizedBox(height: 8),
        _finalista(context, finalistaBaixo),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Text(
            '🏆 CAMPEÃO: A definir',
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.amber.shade900),
          ),
        ),
        const SizedBox(height: 16),

        // Terceiro Lugar
        Text(
          '3º LUGAR',
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.brown.shade400),
        ),
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Container(
            width: 180,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.brown.shade200),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              terceiroCima ?? '?',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(terceiroCima != null ? Teams.get(terceiroCima).flag : '⚽', style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: 22,
                            height: 18,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                counterText: '',
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              terceiroBaixo ?? '?',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(terceiroBaixo != null ? Teams.get(terceiroBaixo).flag : '⚽', style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: 22,
                            height: 18,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                counterText: '',
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(child: Divider(height: 1, color: Theme.of(context).dividerColor)),
                ),
                Positioned(top: 0, bottom: 0, right: 42, child: Container(width: 1, color: Theme.of(context).dividerColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _finalista(BuildContext context, String? nome) {
    final flag = nome != null ? Teams.get(nome).flag : '⚽';
    final name = nome ?? '?';

    return IntrinsicHeight(
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(width: 1, color: Theme.of(context).dividerColor),
            SizedBox(
              width: 30,
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 18,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
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
