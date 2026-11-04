import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../services/auth_service.dart';
import '../../widgets/common.dart';
import 'login_screen.dart' show kEmailRegex;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  final _pass2 = TextEditingController();
  String _relation = kRelaciones.first;
  bool _hide = true;
  bool _accepted = false;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _pass.dispose();
    _pass2.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (!_accepted) {
      showMessage(context, 'Debes aceptar el tratamiento de datos para continuar.', error: true);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await AuthService.instance.register(
        name: _name.text,
        email: _email.text,
        password: _pass.text,
        phone: _phone.text,
        relation: _relation,
      );
      if (!mounted) return;
      showMessage(context, '¡Cuenta creada! Bienvenido a Conecta con Pijiño.');
      // Cierra el registro; AuthGate ya muestra la app porque hay sesión.
      Navigator.of(context).popUntil((r) => r.isFirst);
    } on AuthFailure catch (e) {
      if (mounted) showMessage(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showPolicy() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tratamiento de datos'),
        content: const SingleChildScrollView(
          child: Text(
            'Conecta con Pijiño guarda tu nombre, correo, teléfono (opcional) y tu relación con '
            'el municipio únicamente para gestionar tu cuenta, conocer a la comunidad que usa la app '
            'y mejorar sus contenidos, conforme a la Ley 1581 de 2012 (Colombia).\n\n'
            'No vendemos ni compartimos tus datos con terceros. Puedes editar tu información o '
            'eliminar tu cuenta en cualquier momento desde el perfil.\n\n'
            'Responsables: equipo del Proyecto SENATIC - IE Pijiño.',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: AppLogo(size: 110)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: _dec('Nombre completo', Icons.person_outline),
                  validator: (v) =>
                      (v == null || v.trim().length < 3) ? 'Escribe tu nombre' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _dec('Correo electrónico', Icons.email_outlined),
                  validator: (v) => (v == null || !kEmailRegex.hasMatch(v.trim()))
                      ? 'Escribe un correo válido'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: _dec('Celular (opcional)', Icons.phone_outlined),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return null;
                    return RegExp(r'^[0-9+\s-]{7,15}$').hasMatch(t) ? null : 'Número no válido';
                  },
                ),
                const SizedBox(height: 18),
                const Text('Mi relación con Pijiño',
                    style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.cafeOscuro)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final r in kRelaciones)
                      ChoiceChip(
                        label: Text(r),
                        selected: _relation == r,
                        onSelected: (_) => setState(() => _relation = r),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _pass,
                  obscureText: _hide,
                  decoration: _dec('Contraseña (mín. 6 caracteres)', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_hide ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _hide = !_hide),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _pass2,
                  obscureText: _hide,
                  decoration: _dec('Repite la contraseña', Icons.lock_reset),
                  validator: (v) => v != _pass.text ? 'Las contraseñas no coinciden' : null,
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: _accepted,
                  onChanged: (v) => setState(() => _accepted = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Acepto el tratamiento de mis datos personales.',
                      style: TextStyle(fontSize: 13.5)),
                  subtitle: GestureDetector(
                    onTap: _showPolicy,
                    child: const Text('Leer política',
                        style: TextStyle(
                            color: AppColors.naranja, decoration: TextDecoration.underline)),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                      : const Text('Registrarme', style: TextStyle(fontSize: 16)),
                ),
                const CreditsFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
