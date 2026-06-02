import 'package:bolao_copa_2026/providers/palpites_provider.dart';
import 'package:bolao_copa_2026/providers/user_provider.dart';
import 'package:bolao_copa_2026/screens/Admin/gerenciar_fases_screen.dart';
import 'package:bolao_copa_2026/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Palpites/bet_screen.dart';
import '../Classificacao/classification_screen.dart';
import '../Participantes/participantes_screen.dart';
import '../Ranking/ranking_screen.dart';
import '../Login/login_screen.dart';
import '../Admin/admin_mata_mata_screen.dart';
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

  final List<Widget> _screens = [
    const HomeContent(),
    BetScreen(),
    const ParticipantesScreen(),
    const ClassificationScreen(),
    const RankingScreen(),
  ];

  Future<void> _editarNome(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final nomeAtual = userProvider.user?.name ?? '';
  final TextEditingController nomeController = TextEditingController(text: nomeAtual);
  
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar Nome'),
      content: TextField(
        controller: nomeController,
        decoration: const InputDecoration(
          labelText: 'Novo nome',
          hintText: 'Digite seu nome',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, nomeController.text.trim()),
          child: const Text('Salvar'),
        ),
      ],
    ),
  );
  
  if (result != null && result.isNotEmpty && result != nomeAtual) {
    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      final user = firebaseService.currentUser;
      
      if (user != null) {
        // Atualiza no Firestore
        await firebaseService.atualizarNomeUsuario(user.uid, result);
        
        // Recarrega os dados do usuário do Firestore
        final userModelAtualizado = await firebaseService.getCurrentUserData();
        userProvider.setUser(userModelAtualizado);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nome alterado com sucesso! ✅'), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao alterar nome: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isLoggedIn = userProvider.user != null;
    final isLoading = userProvider.isLoading;
    final isAdmin = userProvider.isAdmin;

    // Mostra loading enquanto verifica o login
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Se não está logado, mostra tela de login
    if (!isLoggedIn) {
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
        body: LoginScreen(
          onLoginSuccess: () {
            // Força rebuild da tela - o UserProvider já detecta o login sozinho
            setState(() {});
          },
        ),
      );
    }

    // Usuário logado - mostra tela principal
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bolão Copa 2026'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'tema') {
                widget.onThemeToggle();
              } else if (value == 'editar_nome') {
                await _editarNome(context);
              } else if (value == 'admin') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMataMataScreen()));
              } else if (value == 'gerenciar_fases') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GerenciarFasesScreen()));  
              } else if (value == 'sair') {
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
                  Provider.of<UserProvider>(context, listen: false).clear();
                  Provider.of<PalpitesProvider>(context, listen: false).limpar();
                  setState(() {});
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'editar_nome',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 20),
                    SizedBox(width: 8),
                    Text('Editar Nome'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'tema',
                child: Row(
                  children: [
                    Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode, size: 20),
                    const SizedBox(width: 8),
                    Text(widget.isDarkMode ? 'Modo claro' : 'Modo escuro'),
                  ],
                ),
              ),
              if (isAdmin)
                const PopupMenuItem(
                  value: 'admin',
                  child: Row(children: [Icon(Icons.settings, size: 20), SizedBox(width: 8), Text('Configurar Mata-Mata')]),
                ),
              if (isAdmin)
                const PopupMenuItem(
                  value: 'gerenciar_fases',
                  child: Row(
                    children: [
                      Icon(Icons.lock, size: 20),
                      SizedBox(width: 8),
                      Text('Gerenciar Fases'),
                    ],
                  ),
                ),  
              const PopupMenuItem(
                value: 'sair',
                child: Row(children: [Icon(Icons.logout, size: 20), SizedBox(width: 8), Text('Sair')]),
              ),
            ],
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
          NavigationDestination(icon: Icon(Icons.people), label: 'Usuários'),
          NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Resultados'),
          NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Ranking'),
        ],
      ),
    );
  }
}