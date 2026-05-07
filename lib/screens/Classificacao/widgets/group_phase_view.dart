import 'package:flutter/material.dart';
import 'left_card.dart';
import 'right_card.dart';

class GroupPhaseView extends StatelessWidget {
  final Map<int, int> rodadas;
  final void Function(int) onRodadaAnterior;
  final void Function(int) onProximaRodada;

  const GroupPhaseView({
    super.key,
    required this.rodadas,
    required this.onRodadaAnterior,
    required this.onProximaRodada,
  });

  static const grupos = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        if (isWide) {
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (int i = 0; i < 12; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: LeftCard(grupoNome: grupos[i], groupIndex: i)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          height: 287,
                          child: VerticalDivider(width: 1, color: Colors.grey.shade300),
                        ),
                      ),
                      Expanded(
                        child: RightCard(
                          grupoIndex: i,
                          rodada: rodadas[i]!,
                          onRodadaAnterior: () => onRodadaAnterior(i),
                          onProximaRodada: () => onProximaRodada(i),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            for (int i = 0; i < 12; i++) ...[
              LeftCard(grupoNome: grupos[i], groupIndex: i),
              const SizedBox(height: 12),
              RightCard(
                grupoIndex: i,
                rodada: rodadas[i]!,
                isMobile: true,
                onRodadaAnterior: () => onRodadaAnterior(i),
                onProximaRodada: () => onProximaRodada(i),
              ),
              const SizedBox(height: 24),
            ],
          ],
        );
      },
    );
  }
}