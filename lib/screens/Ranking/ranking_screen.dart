import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        return Column(
          children: [
            // Título
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'RANKING',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            // Conteúdo
            Expanded(
              child: Center(
                child: Container(
                  width: isWide ? 600 : double.infinity,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabeçalho com ícone PDF
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Classificação Geral',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red.shade700,
                                size: 28,
                              ),
                              tooltip: 'Baixar PDF',
                              onPressed: () {
                                // TODO: Gerar PDF do ranking
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            Table(
                              columnWidths: {
                                0: const FixedColumnWidth(60),
                                1: const FlexColumnWidth(),
                                2: const FixedColumnWidth(80),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).dividerColor.withOpacity(0.3),
                                  ),
                                  children: const [
                                    _TblCell('Pos', bold: true),
                                    _TblCell('Usuário', bold: true),
                                    _TblCell('Pontos', bold: true),
                                  ],
                                ),
                                for (int i = 0; i < 20; i++)
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: i == 0
                                          ? Colors.amber.withOpacity(0.3)
                                          : i == 1
                                              ? Colors.grey.withOpacity(0.2)
                                              : i == 2
                                                  ? Colors.brown.withOpacity(0.2)
                                                  : null,
                                    ),
                                    children: [
                                      _TblCell(
                                        '${i + 1}º',
                                        isTop3: i < 3,
                                        medal: i == 0 ? '🥇' : i == 1 ? '🥈' : i == 2 ? '🥉' : null,
                                      ),
                                      _TblCell('Usuário ${i + 1}', isTop3: i < 3),
                                      _TblCell('0', isTop3: i < 3),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TblCell extends StatelessWidget {
  final String text;
  final bool bold;
  final bool isTop3;
  final String? medal;

  const _TblCell(this.text, {this.bold = false, this.isTop3 = false, this.medal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (medal != null) ...[
            Text(medal!, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTop3 ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}