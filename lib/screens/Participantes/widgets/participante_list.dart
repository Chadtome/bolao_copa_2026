import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/firebase_service.dart';
import 'palpites_modal.dart';

class ParticipanteList extends StatelessWidget {
  final bool isWide;

  const ParticipanteList({super.key, required this.isWide});

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

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Center(
              child: Container(
                width: isWide ? 600 : double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${users.length} participantes',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index].data() as Map<String, dynamic>;
                          final nome = user['name'] ?? 'Sem nome';
                          final palpitesSalvos = user['palpitesSalvos'] ?? false;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                              ),
                            ),
                            title: Text(nome, style: const TextStyle(fontSize: 14)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  palpitesSalvos ? 'Salvo' : 'Pendente',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: palpitesSalvos ? Colors.green : Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.visibility, size: 20, color: Colors.grey),
                              ],
                            ),
                            onTap: () {
                              final userId = users[index].id;
                              showDialog(
                                context: context, 
                                builder: (_) => PalpitesModal(nome: nome, userId: userId)
                                );
                              // showDialog(
                              //   context: context,
                              //   builder: (_) => PalpitesModal(nome: nome),
                              // );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}