import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CadastroForm extends StatefulWidget {
  final TextEditingController nomeController;
  final TextEditingController whatsappController;
  final TextEditingController pixController;
  final TextEditingController emailController;
  final TextEditingController senhaController;
  final VoidCallback onCadastrar;
  final VoidCallback onAlternar;
  final bool isLoading;

  const CadastroForm({
    super.key,
    required this.nomeController,
    required this.whatsappController,
    required this.pixController,
    required this.emailController,
    required this.senhaController,
    required this.onCadastrar,
    required this.onAlternar,
    required this.isLoading,
  });

  @override
  State<CadastroForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  bool _mostrarSenha = false;
  bool _nomeVazio = false;
  bool _whatsappVazio = false;
  bool _pixVazio = false;
  bool _emailVazio = false;
  bool _senhaVazia = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nome
        TextField(
          controller: widget.nomeController,
          decoration: _decoration('Nome ou apelido', Icons.person, _nomeVazio),
          onChanged: (_) => setState(() => _nomeVazio = false),
        ),
        const SizedBox(height: 16),

        // WhatsApp
        TextField(
          controller: widget.whatsappController,
          keyboardType: TextInputType.phone,
          decoration: _decoration('WhatsApp (com DDD)', Icons.phone, _whatsappVazio),
          onChanged: (_) => setState(() => _whatsappVazio = false),
        ),
        const SizedBox(height: 16),

        // PIX
        TextField(
          controller: widget.pixController,
          decoration: _decoration('Chave PIX', Icons.pix, _pixVazio),
          onChanged: (_) => setState(() => _pixVazio = false),
        ),
        const SizedBox(height: 16),

        // Email
        TextField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _decoration('Email', Icons.email, _emailVazio),
          onChanged: (_) => setState(() => _emailVazio = false),
        ),
        const SizedBox(height: 16),

        // Senha
        TextField(
          controller: widget.senhaController,
          obscureText: !_mostrarSenha,
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
        const SizedBox(height: 24),

        // Botão Cadastrar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    setState(() {
                      _nomeVazio = widget.nomeController.text.trim().isEmpty;
                      _whatsappVazio = widget.whatsappController.text.trim().isEmpty;
                      _pixVazio = widget.pixController.text.trim().isEmpty;
                      _emailVazio = widget.emailController.text.trim().isEmpty;
                      _senhaVazia = widget.senhaController.text.trim().isEmpty;
                    });
                    widget.onCadastrar();
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: widget.isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text('CADASTRAR', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 16),

        // Alternar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Já tem conta?', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey)),
            TextButton(
              onPressed: widget.onAlternar,
              child: Text(
                'Entrar',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _decoration(String label, IconData icon, bool vazio) {
    return InputDecoration(labelText: label, prefixIcon: Icon(icon), border: _borda(vazio), enabledBorder: _bordaEnabled(vazio));
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
