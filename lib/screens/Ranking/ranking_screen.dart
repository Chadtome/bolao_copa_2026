import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';
import 'widgets/ranking_table.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: firebaseService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum participante ainda.'));
        }

        final users = snapshot.data!.docs;

        return LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('RANKING',
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
                ),
                Expanded(child: RankingTable(users: users, isWide: constraints.maxWidth > 800)),
              ],
            );
          },
        );
      },
    );
  }
}