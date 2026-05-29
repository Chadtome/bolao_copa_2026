
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/firebase_service.dart';
import 'providers/mata_mata_provider.dart';
import 'providers/resultados_provider.dart';
import 'providers/user_provider.dart';
import 'providers/palpites_provider.dart';
import 'theme/app_theme.dart';
import 'screens/Home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: firebaseOptions);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ResultadosProvider>(context, listen: false).carregarDoFirestore();
      await Provider.of<MataMataProvider>(context, listen: false).carregarDoFirestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseService>(create: (_) => FirebaseService()),
        ChangeNotifierProvider(create: (_) => MataMataProvider()),
        ChangeNotifierProvider(create: (_) => ResultadosProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PalpitesProvider()),
      ],
      child: MaterialApp(
        title: 'Bolão Copa 2026',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: HomeScreen(isDarkMode: _isDarkMode, onThemeToggle: toggleTheme),
      ),
    );
  }
}