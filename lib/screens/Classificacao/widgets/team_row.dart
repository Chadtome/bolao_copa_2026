import 'package:flutter/material.dart';

class TeamRow extends StatelessWidget {
  final int pos;
  final String name;

  const TeamRow({
    super.key,
    required this.pos,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: pos == 1
                      ? Colors.green.shade700
                      : pos == 2
                          ? Colors.green.shade400
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '$pos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: pos <= 2 ? Colors.white : null,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Text(
                name,
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
          ],
        ),
      ),
    );
  }
}