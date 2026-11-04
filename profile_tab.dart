import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../services/auth_service.dart';
import '../widgets/common.dart';
import 'about_screen.dart';
import 'contact_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = AuthService.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil'), backgroundColor: AppColors.arenaClara),
      body: StreamBuilder<UserProfile?>(
        stream: AuthService.instance.profileStream(user.uid),
        builder: (context, snap) {
          final p = snap.data;
          final name = (p?.name.isNotEmpty ?? false) ? p!.name : (user.displayName ?? 'Usuario');
          final email = user.email ?? p?.email ?? '';
          final phone = p?.phone ?? '';
          final relation = p?.relation ?? '';
          final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.naranja,
                  child: Text(initial,
                      style: const TextStyle(
                          fontSize: 40, color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              ),
              Center(child: Text(email, style: const TextStyle(color: AppColors.cafe))),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.groups, color: AppColors.naranja),
                      title: const Text('Relación con Pijiño'),
                      subtitle: Text(relation.isEmpty ? 'Sin especificar' : relation),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone, color: AppColors.naranja),
                      title: const Text('Celular'),
                      subtitle: Text(phone.isEmpty ? 'Sin especificar' : phone),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_month, color: AppColors.naranja),
                      title: const Text('Miembro desde'),
                      subtitle: Text(p?.createdAt != null ? fechaLarga(p!.createdAt!) : '—'),
                    ),
                    ListTile(
                      leading: Icon(
                          user.emailVerified ? Icons.verified : Icons.mark_email_unread,
                          color: user.emailVerified ? AppColors.verde : AppColors.naranja),
                      title: Text(user.emailVerified ? 'Correo verificado' : 'Correo sin verificar'),
                      subtitle: user.emailVerified
                          ? null
                          : const Text('Revisa tu bandeja de entrada o spam.'),
                      trailing: user.emailVerified
                          ? null
                          : TextButton(
                              onPressed: () async {
                                try {
                                  await AuthService.instance.resendVerification();
                                  if (context.mounted) {
                                    showMessage(context, 'Correo de verificación enviado.');
                                  }
                                } on AuthFailure catch (e) {
                                  if (context.mounted) showMessage(context, e.message, error: true);
                                }
                              },
                              child: const Text('Reenviar'),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => _editProfile(context, name, phone, relation),
                icon: const Icon(Icons.edit),
                label: const Text('Editar perfil'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const ContactScreen())),
                icon: const Icon(Icons.mail),
                label: const Text('Contacto y sugerencias'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AboutScreen())),
                icon: const Icon(Icons.info),
                label: const Text('Acerca del proyecto'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _confirmSignOut(context),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
              ),
              TextButton.icon(
                onPressed: () => _deleteAccount(context),
                style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
                icon: const Icon(Icons.delete_forever),
                label: const Text('Eliminar mi cuenta'),
              ),
              const Center(
                child: Text('Versión ${AppInfo.version}',
                    style: TextStyle(fontSize: 12, color: AppColors.cafe)),
              ),
              const CreditsFooter(),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir de tu cuenta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Salir')),
        ],
      ),
    );
    if (ok == true) await AuthService.instance.signOut();
  }

  Future<void> _editProfile(
      BuildContext context, String name, String phone, String relation) async {
    final nameC = TextEditingController(text: name);
    final phoneC = TextEditingController(text: phone);
    String rel = kRelaciones.contains(relation) ? relation : kRelaciones.first;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: const Text('Editar perfil'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameC,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Nombre completo'),
                ),
                TextField(
                  controller: phoneC,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Celular'),
                ),
                const SizedBox(height: 14),
                const Text('Relación con Pijiño',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final r in kRelaciones)
                      ChoiceChip(
                        label: Text(r, style: const TextStyle(fontSize: 12)),
                        selected: rel == r,
                        onSelected: (_) => setSt(() => rel = r),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Guardar')),
          ],
        ),
      ),
    );

    if (saved == true) {
      if (nameC.text.trim().length < 3) {
        if (context.mounted) showMessage(context, 'El nombre es muy corto.', error: true);
        return;
      }
      try {
        await AuthService.instance
            .updateProfile(name: nameC.text, phone: phoneC.text, relation: rel);
        if (context.mounted) showMessage(context, 'Perfil actualizado.');
      } on AuthFailure catch (e) {
        if (context.mounted) showMessage(context, e.message, error: true);
      }
    }
    nameC.dispose();
    phoneC.dispose();
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final passC = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Se borrarán tu cuenta y tus datos de forma permanente. Para confirmar, escribe tu contraseña.'),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    final pass = passC.text;
    passC.dispose();
    if (ok != true) return;
    try {
      await AuthService.instance.deleteAccount(pass);
    } on AuthFailure catch (e) {
      if (context.mounted) showMessage(context, e.message, error: true);
    }
  }
}
