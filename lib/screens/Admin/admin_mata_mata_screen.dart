import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/classified_teams.dart';
import '../../data/teams.dart';
import '../../providers/mata_mata_provider.dart';
import '../../providers/resultados_provider.dart';

class AdminMataMataScreen extends StatefulWidget {
  const AdminMataMataScreen({super.key});

  @override
  State<AdminMataMataScreen> createState() => _AdminMataMataScreenState();
}

class _AdminMataMataScreenState extends State<AdminMataMataScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MataMataProvider>(context);
    final resultados = Provider.of<ResultadosProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar 16-avos'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Confrontos salvos!'), backgroundColor: Colors.green));
              Navigator.pop(context);
            },
            child: const Text('SALVAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Selecione os confrontos dos 16-avos de final', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Slots 1-16: Lado esquerdo | Slots 17-32: Lado direito', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          ...List.generate(32, (index) {
            final slot = index + 1;
            return _buildSlotCard(slot, provider, resultados);
          }),
        ],
      ),
    );
  }

  Widget _buildSlotCard(int slot, MataMataProvider provider, ResultadosProvider resultados) {
    final selected = provider.slots[slot];
    final all = _getAvailableTimes(slot, provider, resultados);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Text('$slot', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
        ),
        title: selected != null
            ? Row(
                children: [
                  Text(Teams.get(selected).flag, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Flexible(child: Text(selected, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                ],
              )
            : const Text('Selecionar time', style: TextStyle(color: Colors.grey)),
        trailing: PopupMenuButton<String>(
          icon: Icon(selected != null ? Icons.swap_horiz : Icons.arrow_drop_down_circle, color: Colors.grey.shade600),
          onSelected: (value) {
            provider.setSlot(slot, value);
          },
          itemBuilder: (context) => all.map((time) {
            final t = Teams.get(time);
            return PopupMenuItem<String>(
              value: time,
              child: Row(
                children: [
                  Text(t.flag, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Flexible(child: Text(time, style: const TextStyle(fontSize: 14))),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<String> _getAvailableTimes(int slot, MataMataProvider provider, ResultadosProvider resultados) {
    final all = ClassifiedTeams.getAllClassified(resultados);

    final used = <String>{};
    provider.slots.forEach((s, time) {
      if (s != slot) used.add(time);
    });

    return all.where((t) => !used.contains(t) || t == provider.slots[slot]).toList();
  }
}