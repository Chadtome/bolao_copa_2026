import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/teams.dart';

class FaseColuna extends StatelessWidget {
  final String titulo;
  final int jogos;
  final bool invertido;
  final List<Map<String, String?>>? confrontos;

  const FaseColuna({super.key, required this.titulo, required this.jogos, this.invertido = false, this.confrontos});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          titulo,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        ...List.generate(jogos, (index) => _buildCard(context, index)),
      ],
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    String timeA = '?';
    String timeB = '?';
    String flagA = '⚽';
    String flagB = '⚽';

    if (confrontos != null && index < confrontos!.length) {
      final c = confrontos![index];
      if (c['timeA'] != null) {
        timeA = c['timeA']!;
        flagA = Teams.get(timeA).flag;
      }
      if (c['timeB'] != null) {
        timeB = c['timeB']!;
        flagB = Teams.get(timeB).flag;
      }
    }

    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Row(
              children: invertido
                  ? [
                      _buildCampos(context),
                      Container(width: 1, color: Theme.of(context).dividerColor),
                      _buildTimes(context, timeA, flagA, timeB, flagB, alinharEsquerda: true),
                    ]
                  : [
                      _buildTimes(context, timeA, flagA, timeB, flagB, alinharEsquerda: false),
                      Container(width: 1, color: Theme.of(context).dividerColor),
                      _buildCampos(context),
                    ],
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(child: Divider(height: 1, color: Theme.of(context).dividerColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimes(BuildContext context, String timeA, String flagA, String timeB, String flagB, {required bool alinharEsquerda}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_timeRow(context, flagA, timeA, alinharEsquerda), _timeRow(context, flagB, timeB, alinharEsquerda)],
      ),
    );
  }

  Widget _timeRow(BuildContext context, String flag, String name, bool alinharEsquerda) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisAlignment: alinharEsquerda ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: alinharEsquerda
            ? [
                Text(flag, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]
            : [
                Flexible(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(flag, style: const TextStyle(fontSize: 14)),
              ],
      ),
    );
  }

  Widget _buildCampos(BuildContext context) {
    return SizedBox(
      width: 30,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [_campo(), const SizedBox(height: 14), _campo()]),
    );
  }

  Widget _campo() {
    return SizedBox(
      height: 18,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 2,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(counterText: '', isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
      ),
    );
  }
}
