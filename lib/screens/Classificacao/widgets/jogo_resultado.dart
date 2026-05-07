import 'package:flutter/material.dart';
import 'placar_field.dart';

class JogoResultado extends StatelessWidget {
  final String home;
  final String away;
  final String homeFlag;
  final String awayFlag;
  final String date;
  final String time;

  const JogoResultado({
    super.key,
    required this.home,
    required this.away,
    required this.homeFlag,
    required this.awayFlag,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '$date - $time',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            home,
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(homeFlag, style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const PlacarField(),
                  const SizedBox(width: 6),
                  const Text('x', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 6),
                  const PlacarField(),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(awayFlag, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            away,
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}