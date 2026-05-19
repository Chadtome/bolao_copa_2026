import 'package:flutter/material.dart';

class TeamRow extends StatelessWidget {
  final int pos;
  final String name;
  final Map<String, int> teamData;

  const TeamRow({super.key, required this.pos, required this.name, required this.teamData});

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
                  color: pos == 1 ? Colors.green.shade700 : pos == 2 ? Colors.green.shade400 : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('$pos', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: pos <= 2 ? Colors.white : null)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(flex: 3, child: Text(name, style: const TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis)),
            Expanded(flex: 1, child: Text('${teamData['P']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
            Expanded(flex: 1, child: Text('${teamData['J']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
            Expanded(flex: 1, child: Text('${teamData['V']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
            Expanded(flex: 1, child: Text('${teamData['E']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
            Expanded(flex: 1, child: Text('${teamData['D']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
            Expanded(flex: 1, child: Text('${teamData['GP']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
            Expanded(flex: 1, child: Text('${teamData['GC']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
            Expanded(flex: 1, child: Text('${teamData['SG']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
          ],
        ),
      ),
    );
  }
}