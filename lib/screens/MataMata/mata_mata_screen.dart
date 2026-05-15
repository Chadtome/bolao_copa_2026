import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mata_mata_provider.dart';
import 'widgets/fase_coluna.dart';
import 'widgets/conector.dart';
import 'widgets/final_column.dart';

class MataMataScreen extends StatelessWidget {
  const MataMataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MataMataProvider>(context);

    // Constrói lista de confrontos para os 16-avos
    List<Map<String, String?>> _buildConfrontos(int startSlot) {
      return List.generate(8, (i) {
        final slotA = startSlot + i * 2;
        final slotB = startSlot + i * 2 + 1;
        return {'timeA': provider.slots[slotA], 'timeB': provider.slots[slotB]};
      });
    }

    final confrontosEsquerda = _buildConfrontos(1); // Slots 1-16
    final confrontosDireita = _buildConfrontos(17); // Slots 17-32

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
              FaseColuna(titulo: '16-avos', jogos: 8, confrontos: confrontosEsquerda),
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
              FaseColuna(titulo: '16-avos', jogos: 8, invertido: true, confrontos: confrontosDireita),
            ],
          ),
        ),
      ),
    );
  }
}
