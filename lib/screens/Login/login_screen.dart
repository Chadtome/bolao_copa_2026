// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../services/firebase_service.dart';

// class LoginScreen extends StatefulWidget {
//   final VoidCallback onLoginSuccess;

//   const LoginScreen({super.key, required this.onLoginSuccess});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _isLogin = true;
//   bool _isLoading = false;
//   bool _emailVazio = false;
//   bool _senhaVazia = false;
//   bool _nomeVazio = false;
//   bool _whatsappVazio = false;
//   bool _pixVazio = false;
//   bool _mostrarSenha = false;

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
//     setState(() {
//       _emailVazio = false;
//       _senhaVazia = false;
//       _nomeVazio = false;
//       _whatsappVazio = false;
//       _pixVazio = false;
//       _mostrarSenha = false;
//     });
//   }

//   Future<void> _fazerLogin() async {
//     final email = _emailController.text.trim();
//     final senha = _senhaController.text.trim();

//     setState(() {
//       _emailVazio = email.isEmpty;
//       _senhaVazia = senha.isEmpty;
//     });

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
//       _mostrarErro('Erro ao fazer login. Verifique suas credenciais.');
//     }

//     setState(() => _isLoading = false);
//   }

//   Future<void> _fazerCadastro() async {
//     final nome = _nomeController.text.trim();
//     final email = _emailController.text.trim();
//     final senha = _senhaController.text.trim();
//     final whatsapp = _whatsappController.text.trim();
//     final pix = _pixController.text.trim();

//     setState(() {
//       _nomeVazio = nome.isEmpty;
//       _emailVazio = email.isEmpty;
//       _senhaVazia = senha.isEmpty;
//       _whatsappVazio = whatsapp.isEmpty;
//       _pixVazio = pix.isEmpty;
//     });

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
//       final user = await firebaseService.register(nome, email, senha);

//       if (user != null) {
//         _mostrarSucesso('Cadastro realizado! Faça login para entrar.');
//         setState(() => _isLogin = true);
//         _limparCampos();
//       } else {
//         _mostrarErro('Erro ao cadastrar. Tente novamente.');
//       }
//     } catch (e) {
//       _mostrarErro('Erro ao cadastrar. Este email já pode estar em uso.');
//     }

//     setState(() => _isLoading = false);
//   }

//   Future<void> _esqueceuSenha() async {
//     final email = _emailController.text.trim();

//     if (email.isEmpty) {
//       setState(() => _emailVazio = true);
//       _mostrarErro('Digite seu email para recuperar a senha.');
//       return;
//     }

//     try {
//       final firebaseService = Provider.of<FirebaseService>(context, listen: false);
//       await firebaseService.resetPassword(email);
//       _mostrarSucesso('Email de recuperação enviado! Verifique sua caixa de entrada e também a pasta de spam.');
//     } catch (e) {
//       _mostrarErro('Erro ao enviar email de recuperação.');
//     }
//   }

//   void _mostrarErro(String mensagem) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem), backgroundColor: Colors.red));
//   }

//   void _mostrarSucesso(String mensagem) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem), backgroundColor: Colors.green));
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

//               // ===== CAMPOS DE CADASTRO =====
//               if (!_isLogin) ...[
//                 TextField(
//                   controller: _nomeController,
//                   decoration: InputDecoration(
//                     labelText: 'Nome ou apelido',
//                     prefixIcon: const Icon(Icons.person),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: _nomeVazio ? Colors.red : Colors.grey),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: _nomeVazio ? Colors.red : Colors.grey.shade400),
//                     ),
//                   ),
//                   onChanged: (_) => setState(() => _nomeVazio = false),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _whatsappController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: 'WhatsApp (com DDD)',
//                     prefixIcon: const Icon(Icons.phone),
//                     hintText: '(11) 99999-9999',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: _whatsappVazio ? Colors.red : Colors.grey),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: _whatsappVazio ? Colors.red : Colors.grey.shade400),
//                     ),
//                   ),
//                   onChanged: (_) => setState(() => _whatsappVazio = false),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _pixController,
//                   decoration: InputDecoration(
//                     labelText: 'Chave PIX',
//                     prefixIcon: const Icon(Icons.pix),
//                     hintText: 'CPF, email ou telefone',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: _pixVazio ? Colors.red : Colors.grey),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: _pixVazio ? Colors.red : Colors.grey.shade400),
//                     ),
//                   ),
//                   onChanged: (_) => setState(() => _pixVazio = false),
//                 ),
//                 const SizedBox(height: 16),
//               ],

//               // ===== EMAIL =====
//               TextField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: const Icon(Icons.email),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: _emailVazio ? Colors.red : Colors.grey),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: _emailVazio ? Colors.red : Colors.grey.shade400),
//                   ),
//                 ),
//                 onChanged: (_) => setState(() => _emailVazio = false),
//               ),
//               const SizedBox(height: 16),

//               // ===== SENHA =====
//               TextField(
//                 controller: _senhaController,
//                 obscureText: !_mostrarSenha,
//                 decoration: InputDecoration(
//                   labelText: 'Senha',
//                   prefixIcon: const Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(_mostrarSenha ? Icons.visibility : Icons.visibility_off),
//                     onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: _senhaVazia ? Colors.red : Colors.grey),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: _senhaVazia ? Colors.red : Colors.grey.shade400),
//                   ),
//                 ),
//                 onChanged: (_) => setState(() => _senhaVazia = false),
//               ),
//               const SizedBox(height: 8),

//               // ===== ESQUECEU SENHA =====
//               if (_isLogin)
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: _esqueceuSenha,
//                     child: Text('Esqueceu a senha?', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
//                   ),
//                 ),
//               const SizedBox(height: 16),

//               // ===== BOTÃO =====
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : (_isLogin ? _fazerLogin : _fazerCadastro),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                       : Text(_isLogin ? 'ENTRAR' : 'CADASTRAR', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // ===== ALTERNAR =====
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(_isLogin ? 'Não tem conta?' : 'Já tem conta?', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey)),
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         _isLogin = !_isLogin;
//                         _limparCampos();
//                       });
//                     },
//                     child: Text(
//                       _isLogin ? 'Cadastre-se' : 'Entrar',
//                       style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
//                     ),
//                   ),
//                 ],
//               ),
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
      final user = await firebaseService.register(nome, email, senha);
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _mostrarSucesso(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
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
