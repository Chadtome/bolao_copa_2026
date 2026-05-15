// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../services/firebase_service.dart';
// import 'widgets/login_form.dart';
// import 'widgets/cadastro_form.dart';

// class LoginScreen extends StatefulWidget {
//   final VoidCallback onLoginSuccess;

//   const LoginScreen({super.key, required this.onLoginSuccess});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _isLogin = true;
//   bool _isLoading = false;
//   bool _mostrandoSnackBar = false;

//   final _emailController = TextEditingController();
//   final _senhaController = TextEditingController();
//   final _nomeController = TextEditingController();
//   final _pixController = TextEditingController();
//   final _whatsappController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _senhaController.dispose();
//     _nomeController.dispose();
//     _pixController.dispose();
//     _whatsappController.dispose();
//     super.dispose();
//   }

//   void _limparCampos() {
//     _emailController.clear();
//     _senhaController.clear();
//     _nomeController.clear();
//     _pixController.clear();
//     _whatsappController.clear();
//   }

//   Future<void> _fazerLogin() async {
//     final email = _emailController.text.trim();
//     final senha = _senhaController.text.trim();

//     if (email.isEmpty || senha.isEmpty) {
//       _mostrarErro('Preencha email e senha.');
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final firebaseService = Provider.of<FirebaseService>(context, listen: false);
//       final user = await firebaseService.login(email, senha);
//       if (user != null) {
//         widget.onLoginSuccess();
//       } else {
//         _mostrarErro('Email ou senha incorretos.');
//       }
//     } catch (e) {
//       _mostrarErro('Erro ao fazer login.');
//     }

//     setState(() => _isLoading = false);
//   }

//   Future<void> _fazerCadastro() async {
//     final nome = _nomeController.text.trim();
//     final email = _emailController.text.trim();
//     final senha = _senhaController.text.trim();
//     final whatsapp = _whatsappController.text.trim();
//     final pix = _pixController.text.trim();

//     if (nome.isEmpty || email.isEmpty || senha.isEmpty || whatsapp.isEmpty || pix.isEmpty) {
//       _mostrarErro('Preencha todos os campos.');
//       return;
//     }
//     if (senha.length < 6) {
//       _mostrarErro('A senha deve ter no mínimo 6 caracteres.');
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final firebaseService = Provider.of<FirebaseService>(context, listen: false);
//       final user = await firebaseService.register(nome, email, senha, whatsapp: whatsapp, pix: pix);
//       if (user != null) {
//         _mostrarSucesso('Cadastro realizado! Faça login para entrar.');
//         setState(() => _isLogin = true);
//         _limparCampos();
//       } else {
//         _mostrarErro('Erro ao cadastrar.');
//       }
//     } catch (e) {
//       _mostrarErro('Este email já pode estar em uso.');
//     }

//     setState(() => _isLoading = false);
//   }

//   Future<void> _esqueceuSenha() async {
//     final email = _emailController.text.trim();
//     if (email.isEmpty) {
//       _mostrarErro('Digite seu email para recuperar a senha.');
//       return;
//     }
//     try {
//       final firebaseService = Provider.of<FirebaseService>(context, listen: false);
//       await firebaseService.resetPassword(email);
//       _mostrarSucesso('Email de recuperação enviado! Verifique sua caixa de entrada e spam.');
//     } catch (e) {
//       _mostrarErro('Erro ao enviar email.');
//     }
//   }

//   void _mostrarErro(String msg) {
//     if (_mostrandoSnackBar) return;
//     _mostrandoSnackBar = true;
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red)).closed.then((_) => _mostrandoSnackBar = false);
//   }

//   void _mostrarSucesso(String msg) {
//     if (_mostrandoSnackBar) return;
//     _mostrandoSnackBar = true;
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green)).closed.then((_) => _mostrandoSnackBar = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 400),
//           padding: const EdgeInsets.all(32),
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surfaceContainerHighest,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('⚽', style: TextStyle(fontSize: 48)),
//               const SizedBox(height: 16),
//               Text(
//                 'Bolão Copa 2026',
//                 style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
//               ),
//               const SizedBox(height: 8),
//               Text(_isLogin ? 'Faça login para continuar' : 'Crie sua conta', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
//               const SizedBox(height: 32),
//               _isLogin
//                   ? LoginForm(
//                       emailController: _emailController,
//                       senhaController: _senhaController,
//                       onLogin: _fazerLogin,
//                       onEsqueceuSenha: _esqueceuSenha,
//                       onAlternar: () => setState(() {
//                         _isLogin = false;
//                         _limparCampos();
//                       }),
//                       isLoading: _isLoading,
//                     )
//                   : CadastroForm(
//                       nomeController: _nomeController,
//                       whatsappController: _whatsappController,
//                       pixController: _pixController,
//                       emailController: _emailController,
//                       senhaController: _senhaController,
//                       onCadastrar: _fazerCadastro,
//                       onAlternar: () => setState(() {
//                         _isLogin = true;
//                         _limparCampos();
//                       }),
//                       isLoading: _isLoading,
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';
import '../../providers/user_provider.dart';
import 'widgets/login_form.dart';
import 'widgets/cadastro_form.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _mostrandoSnackBar = false;

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _pixController = TextEditingController();
  final _whatsappController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _nomeController.dispose();
    _pixController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _limparCampos() {
    _emailController.clear();
    _senhaController.clear();
    _nomeController.clear();
    _pixController.clear();
    _whatsappController.clear();
  }

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mostrarErro('Preencha email e senha.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      final user = await firebaseService.login(email, senha);
      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        widget.onLoginSuccess();
      } else {
        _mostrarErro('Email ou senha incorretos.');
      }
    } catch (e) {
      _mostrarErro('Erro ao fazer login.');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _fazerCadastro() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final whatsapp = _whatsappController.text.trim();
    final pix = _pixController.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || whatsapp.isEmpty || pix.isEmpty) {
      _mostrarErro('Preencha todos os campos.');
      return;
    }
    if (senha.length < 6) {
      _mostrarErro('A senha deve ter no mínimo 6 caracteres.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      final user = await firebaseService.register(nome, email, senha, whatsapp: whatsapp, pix: pix);
      if (user != null) {
        _mostrarSucesso('Cadastro realizado! Faça login para entrar.');
        setState(() => _isLogin = true);
        _limparCampos();
      } else {
        _mostrarErro('Erro ao cadastrar.');
      }
    } catch (e) {
      _mostrarErro('Este email já pode estar em uso.');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _esqueceuSenha() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _mostrarErro('Digite seu email para recuperar a senha.');
      return;
    }
    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      await firebaseService.resetPassword(email);
      _mostrarSucesso('Email de recuperação enviado! Verifique sua caixa de entrada e spam.');
    } catch (e) {
      _mostrarErro('Erro ao enviar email.');
    }
  }

  void _mostrarErro(String msg) {
    if (_mostrandoSnackBar) return;
    _mostrandoSnackBar = true;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red)).closed.then((_) => _mostrandoSnackBar = false);
  }

  void _mostrarSucesso(String msg) {
    if (_mostrandoSnackBar) return;
    _mostrandoSnackBar = true;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green)).closed.then((_) => _mostrandoSnackBar = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⚽', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(
                'Bolão Copa 2026',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(_isLogin ? 'Faça login para continuar' : 'Crie sua conta', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 32),
              _isLogin
                  ? LoginForm(
                      emailController: _emailController,
                      senhaController: _senhaController,
                      onLogin: _fazerLogin,
                      onEsqueceuSenha: _esqueceuSenha,
                      onAlternar: () => setState(() {
                        _isLogin = false;
                        _limparCampos();
                      }),
                      isLoading: _isLoading,
                    )
                  : CadastroForm(
                      nomeController: _nomeController,
                      whatsappController: _whatsappController,
                      pixController: _pixController,
                      emailController: _emailController,
                      senhaController: _senhaController,
                      onCadastrar: _fazerCadastro,
                      onAlternar: () => setState(() {
                        _isLogin = true;
                        _limparCampos();
                      }),
                      isLoading: _isLoading,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
