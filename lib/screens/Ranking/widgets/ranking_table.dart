import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'tbl_cell.dart';

class RankingTable extends StatelessWidget {
  final List<QueryDocumentSnapshot> users;
  final bool isWide;

  const RankingTable({super.key, required this.users, required this.isWide});

  Future<void> _gerarPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(16),
            color: PdfColor.fromHex('#009C3B'),
            child: pw.Text('Bolão Copa do Mundo 2026 - Ranking',
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
            children: [
              pw.TableRow(
                decoration:  pw.BoxDecoration(color: PdfColor.fromHex('#009C3B')),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text('Pos', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white), textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text('Usuário', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white), textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text('Pontos', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white), textAlign: pw.TextAlign.center),
                  ),
                ],
              ),
              ...users.asMap().entries.map((entry) {
                final i = entry.key;
                final u = entry.value;
                return pw.TableRow(
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('${i + 1}º', textAlign: pw.TextAlign.center)),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(u['name'] ?? 'Sem nome', textAlign: pw.TextAlign.center)),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('${u['totalPoints'] ?? 0}', textAlign: pw.TextAlign.center)),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: isWide ? 600 : double.infinity,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Classificação Geral', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: Icon(Icons.picture_as_pdf, color: Colors.red.shade700, size: 28),
                    tooltip: 'Baixar PDF',
                    onPressed: _gerarPDF,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(60),
                      1: FlexColumnWidth(),
                      2: FixedColumnWidth(80),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Theme.of(context).dividerColor.withOpacity(0.3)),
                        children: const [
                          TblCell('Pos', bold: true),
                          TblCell('Usuário', bold: true),
                          TblCell('Pontos', bold: true),
                        ],
                      ),
                      for (int i = 0; i < users.length; i++)
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
                            TblCell(
                              '${i + 1}º',
                              isTop3: i < 3,
                              medal: i == 0 ? '🥇' : i == 1 ? '🥈' : i == 2 ? '🥉' : null,
                            ),
                            TblCell(users[i]['name'] ?? 'Sem nome', isTop3: i < 3),
                            TblCell('${users[i]['totalPoints'] ?? 0}', isTop3: i < 3),
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
    );
  }
}