import 'package:bolao_copa_2026/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Palpites/bet_screen.dart';
import '../Classificacao/classification_screen.dart';
import '../Participantes/participantes_screen.dart';
import '../Ranking/ranking_screen.dart';
import '../Login/login_screen.dart';
import 'home_content.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeScreen({super.key, required this.isDarkMode, required this.onThemeToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;

  final List<Widget> _screens = [
    const HomeContent(),
    const BetScreen(),
    const ParticipantesScreen(),
    const ClassificationScreen(),
    const RankingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bolão Copa 2026'),
          actions: [
            IconButton(
              icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: widget.onThemeToggle,
              tooltip: widget.isDarkMode ? 'Modo claro' : 'Modo escuro',
            ),
          ],
        ),
        // body: LoginScreen(onLoginSuccess: () => setState(() => _isLoggedIn = true)),
        body: LoginScreen(
          onLoginSuccess: () {
            setState(() {
              _isLoggedIn = true;
              _currentIndex = 0;
            });
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bolão Copa 2026'),
        actions: [
          // Botão Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sair'),
                  content: const Text('Tem certeza que deseja sair?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sair')),
                  ],
                ),
              );

              if (confirmar == true) {
                final firebaseService = Provider.of<FirebaseService>(context, listen: false);
                await firebaseService.logout();
                setState(() => _isLoggedIn = false);
              }
            },
            tooltip: 'Sair',
          ),
          // Botão Tema
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
            tooltip: widget.isDarkMode ? 'Modo claro' : 'Modo escuro',
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.sports_soccer), label: 'Palpites'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Participantes'),
          NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Resultados'),
          NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Ranking'),
        ],
      ),
    );
  }
}
