import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/firebase_service.dart';

class Top5RankingCard extends StatelessWidget {
  final bool isWide;

  const Top5RankingCard({super.key, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: firebaseService.getUsersStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const SizedBox();

        final users = snapshot.data!.docs.take(5).toList();
        final medals = ['🥇', '🥈', '🥉', '4º', '5º'];

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Center(
            child: Container(
              width: isWide ? 600 : double.infinity,
              child: Column(
                children: [
                  Text('RANKING', textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  ...List.generate(users.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(width: 40, child: Text(medals[index], style: const TextStyle(fontSize: 18))),
                          Expanded(
                            child: Text(users[index]['name'] ?? 'Sem nome',
                                style: TextStyle(fontSize: 14, fontWeight: index < 3 ? FontWeight.w600 : FontWeight.w400)),
                          ),
                          Text('${users[index]['totalPoints'] ?? 0} pts',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}