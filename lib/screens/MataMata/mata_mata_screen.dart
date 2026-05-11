import 'package:flutter/material.dart';
import 'widgets/fase_coluna.dart';
import 'widgets/conector.dart';
import 'widgets/final_column.dart';

class MataMataScreen extends StatelessWidget {
  const MataMataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FaseColuna(titulo: '16-avos', jogos: 8),
            const Conector(),
            const FaseColuna(titulo: 'Oitavas', jogos: 4),
            const Conector(),
            const FaseColuna(titulo: 'Quartas', jogos: 2),
            const Conector(),
            const FaseColuna(titulo: 'Semi', jogos: 1),
            const SizedBox(width: 24),
            const FinalColumn(),
            const SizedBox(width: 24),
            const FaseColuna(titulo: 'Semi', jogos: 1, invertido: true),
            const Conector(direita: true),
            const FaseColuna(titulo: 'Quartas', jogos: 2, invertido: true),
            const Conector(direita: true),
            const FaseColuna(titulo: 'Oitavas', jogos: 4, invertido: true),
            const Conector(direita: true),
            const FaseColuna(titulo: '16-avos', jogos: 8, invertido: true),
          ],
        ),
      ),
    );
  }
}