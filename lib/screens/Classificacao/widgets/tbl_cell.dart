import 'package:flutter/material.dart';

class TblCell extends StatelessWidget {
  final String text;
  final bool bold;
  final TextStyle? style;
  final bool ellipsis;
  final TextAlign align;
  final EdgeInsetsGeometry padding;

  const TblCell(
    this.text, {
    super.key,
    this.bold = false,
    this.style,
    this.ellipsis = false,
    this.align = TextAlign.center,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        textAlign: align,
        overflow: ellipsis ? TextOverflow.ellipsis : null,
        maxLines: 1,
        style: style ??
            TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
      ),
    );
  }
}