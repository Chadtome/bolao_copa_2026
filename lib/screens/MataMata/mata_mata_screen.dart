import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mata_mata_provider.dart';
import '../../providers/resultados_provider.dart';
import 'widgets/fase_coluna.dart';
import 'widgets/conector.dart';
import 'widgets/final_column.dart';

class MataMataScreen extends StatelessWidget {
  const MataMataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mataMata = Provider.of<MataMataProvider>(context);
    final resultados = Provider.of<ResultadosProvider>(context);

    List<Map<String, String?>> _confrontos(List<int> slots) {
      return List.generate(slots.length ~/ 2, (i) {
        return {
          'timeA': mataMata.slots[slots[i * 2]] ?? resultados.getTime(slots[i * 2]),
          'timeB': mataMata.slots[slots[i * 2 + 1]] ?? resultados.getTime(slots[i * 2 + 1]),
        };
      });
    }

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FaseColuna(titulo: '16-avos', jogos: 8, confrontos: _confrontos([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]), startSlot: 1),
              const Conector(),
              FaseColuna(titulo: 'Oitavas', jogos: 4, confrontos: _confrontos([33, 34, 35, 36, 37, 38, 39, 40]), startSlot: 33),
              const Conector(),
              FaseColuna(titulo: 'Quartas', jogos: 2, confrontos: _confrontos([49, 50, 51, 52]), startSlot: 49),
              const Conector(),
              FaseColuna(titulo: 'Semi', jogos: 1, confrontos: _confrontos([57, 58]), startSlot: 57),
              const SizedBox(width: 24),
              const FinalColumn(),
              const SizedBox(width: 24),
              FaseColuna(titulo: 'Semi', jogos: 1, invertido: true, confrontos: _confrontos([59, 60]), startSlot: 59),
              const Conector(direita: true),
              FaseColuna(titulo: 'Quartas', jogos: 2, invertido: true, confrontos: _confrontos([53, 54, 55, 56]), startSlot: 53),
              const Conector(direita: true),
              FaseColuna(titulo: 'Oitavas', jogos: 4, invertido: true, confrontos: _confrontos([41, 42, 43, 44, 45, 46, 47, 48]), startSlot: 41),
              const Conector(direita: true),
              FaseColuna(
                titulo: '16-avos',
                jogos: 8,
                invertido: true,
                confrontos: _confrontos([17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]),
                startSlot: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
