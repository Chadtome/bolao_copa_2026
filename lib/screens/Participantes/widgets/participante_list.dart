import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'palpites_modal.dart';

class ParticipanteList extends StatelessWidget {
  final bool isWide;

  const ParticipanteList({super.key, required this.isWide});

  final bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Center(
          child: Container(
            width: isWide ? 600 : double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${20} participantes', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      final pago = index < 5;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                        title: Text('Usuário ${index + 1}', style: const TextStyle(fontSize: 14)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isAdmin)
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  pago ? 'Pago' : 'Pendente',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: pago ? Colors.green : Colors.grey),
                                ),
                              )
                            else
                              Icon(
                                pago ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: pago ? Colors.green : Colors.grey.shade400,
                                size: 24,
                              ),
                            const SizedBox(width: 4),
                            const Icon(Icons.visibility, size: 20, color: Colors.grey),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => PalpitesModal(nome: 'Usuário ${index + 1}'),
                          );
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
  }
}
