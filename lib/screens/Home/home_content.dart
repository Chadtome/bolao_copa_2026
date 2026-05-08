import 'package:bolao_copa_2026/screens/Home/widgets/boas_vidas_card.dart';
import 'package:flutter/material.dart';
import 'widgets/posicao_usuario_card.dart';
import 'widgets/top5_ranking_card.dart';
import 'widgets/jogos_do_dia_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        BoasVindasCard(isWide: isWide),
        const SizedBox(height: 20),
        const PosicaoUsuarioCard(),
        const SizedBox(height: 20),
        Top5RankingCard(isWide: isWide),
        const SizedBox(height: 20),
        JogosDoDiaCard(isWide: isWide),
        const SizedBox(height: 20),
      ],
    );
  }
}