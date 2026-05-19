import 'package:flutter/material.dart';

class PlacarField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const PlacarField({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 28,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 2,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(counterText: '', isDense: true, contentPadding: EdgeInsets.zero, filled: true, fillColor: Colors.transparent, border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
        onChanged: onChanged,
      ),
    );
  }
}
