import 'package:flutter/material.dart';
import '../Palpites/bet_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const BetScreen(),
    const _RankingPlaceholder(),
    const _ResultsPlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bolão Copa 2026'),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onThemeToggle,
            tooltip: widget.isDarkMode ? 'Modo claro' : 'Modo escuro',
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_soccer),
            label: 'Palpites',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events),
            label: 'Ranking',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard),
            label: 'Resultados',
          ),
        ],
      ),
    );
  }
}

// Placeholders temporários para as outras telas
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('⚽ Bolão Copa do Mundo 2026', style: TextStyle(fontSize: 24)),
    );
  }
}

class _RankingPlaceholder extends StatelessWidget {
  const _RankingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('🏆 Ranking em breve'));
  }
}

class _ResultsPlaceholder extends StatelessWidget {
  const _ResultsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('📊 Resultados em breve'));
  }
}