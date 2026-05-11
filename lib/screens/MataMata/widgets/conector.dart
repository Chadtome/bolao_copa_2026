import 'package:flutter/material.dart';

class Conector extends StatelessWidget {
  final bool direita;
  const Conector({super.key, this.direita = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 28),
          Icon(direita ? Icons.chevron_left : Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          Icon(direita ? Icons.chevron_left : Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          Icon(direita ? Icons.chevron_left : Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}