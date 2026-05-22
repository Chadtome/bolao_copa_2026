import 'package:flutter/material.dart';

class TblCell extends StatelessWidget {
  final String text;
  final bool bold;
  final bool isTop3;
  final String? medal;

  const TblCell(this.text, {super.key, this.bold = false, this.isTop3 = false, this.medal});

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