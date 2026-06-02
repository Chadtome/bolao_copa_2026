import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController senhaController;
  final VoidCallback onLogin;
  final VoidCallback onEsqueceuSenha;
  final VoidCallback onAlternar;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.senhaController,
    required this.onLogin,
    required this.onEsqueceuSenha,
    required this.onAlternar,
    required this.isLoading,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _mostrarSenha = false;
  bool _emailVazio = false;
  bool _senhaVazia = false;

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Email
          TextField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
              border: _borda(_emailVazio),
              enabledBorder: _bordaEnabled(_emailVazio),
            ),
            onChanged: (_) => setState(() => _emailVazio = false),
          ),
          const SizedBox(height: 16),

          // Senha
          TextField(
            controller: widget.senhaController,
            obscureText: !_mostrarSenha,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_mostrarSenha ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
              ),
              border: _borda(_senhaVazia),
              enabledBorder: _bordaEnabled(_senhaVazia),
            ),
            onChanged: (_) => setState(() => _senhaVazia = false),
          ),
          const SizedBox(height: 8),

          // Esqueceu senha
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onEsqueceuSenha,
              child: Text('Esqueceu a senha?', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 16),

          // Botão Entrar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      setState(() {
                        _emailVazio = widget.emailController.text.trim().isEmpty;
                        _senhaVazia = widget.senhaController.text.trim().isEmpty;
                      });
                      widget.onLogin();
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: widget.isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('ENTRAR', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 16),

          // Alternar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Não tem conta?', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey)),
              TextButton(
                onPressed: widget.onAlternar,
                child: Text(
                  'Cadastre-se',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _borda(bool vazio) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: vazio ? Colors.red : Colors.grey),
    );
  }

  OutlineInputBorder _bordaEnabled(bool vazio) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: vazio ? Colors.red : Colors.grey.shade400),
    );
  }
}