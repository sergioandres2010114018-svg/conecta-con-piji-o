import 'package:flutter/material.dart';

import '../../core/utils.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart' show kEmailRegex;

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService.instance.sendPasswordReset(_email.text);
      if (!mounted) return;
      showMessage(context, 'Te enviamos un correo para restablecer la contraseña.');
      Navigator.of(context).pop();
    } on AuthFailure catch (e) {
      if (mounted) showMessage(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Escribe el correo con el que te registraste y te enviaremos un enlace para crear una contraseña nueva.'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || !kEmailRegex.hasMatch(v.trim()))
                    ? 'Escribe un correo válido'
                    : null,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _loading ? null : _send,
                child: Text(_loading ? 'Enviando...' : 'Enviar enlace'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
