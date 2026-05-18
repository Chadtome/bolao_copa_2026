import 'package:flutter/material.dart';
import '../../../data/group_phase_games.dart';
import 'group_panel.dart';

class GroupPhaseView extends StatelessWidget {
  const GroupPhaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        if (isWide) {
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: (GroupPhaseGames.groups.length / 2).ceil(),
            itemBuilder: (context, index) {
              final i = index * 2;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: GroupPanel(group: GroupPhaseGames.groups[i])),
                    const SizedBox(width: 8),
                    if (i + 1 < GroupPhaseGames.groups.length)
                      Expanded(child: GroupPanel(group: GroupPhaseGames.groups[i + 1]))
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              );
            },
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: GroupPhaseGames.groups.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GroupPanel(group: GroupPhaseGames.groups[index]),
          ),
        );
      },
    );
  }
}