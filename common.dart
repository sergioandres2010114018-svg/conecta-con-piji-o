import 'package:flutter/material.dart';
import '../core/constants.dart';

/// Logo oficial de la app (tomado del documento del proyecto).
class AppLogo extends StatelessWidget {
  final double size;
  final bool circle;
  const AppLogo({super.key, this.size = 120, this.circle = false});

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(AppInfo.logoAsset, width: size, height: size, fit: BoxFit.contain);
    if (!circle) return img;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 10)],
      ),
      child: ClipOval(child: Padding(padding: EdgeInsets.all(size * 0.04), child: img)),
    );
  }
}

/// Créditos solicitados por el equipo del proyecto.
class CreditsFooter extends StatelessWidget {
  final bool light;
  const CreditsFooter({super.key, this.light = false});

  @override
  Widget build(BuildContext context) {
    final color = light ? Colors.white70 : AppColors.cafe;
    final style = TextStyle(fontSize: 12.5, color: color, height: 1.35);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        children: [
          Divider(color: color.withValues(alpha: 0.35)),
          const SizedBox(height: 8),
          Text(AppInfo.createdBy, textAlign: TextAlign.center, style: style),
          const SizedBox(height: 4),
          Text('${AppInfo.institution}  ·  ${AppInfo.project}',
              textAlign: TextAlign.center,
              style: style.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// Imagen de asset con degradado oscuro y título encima.
class ImageBanner extends StatelessWidget {
  final String image;
  final String? title;
  final String? subtitle;
  final double height;
  final Widget? child;
  const ImageBanner({
    super.key,
    required this.image,
    this.title,
    this.subtitle,
    this.height = 180,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(image, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0xB3000000)],
              ),
            ),
          ),
          if (title != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title!,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  if (subtitle != null)
                    Text(subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  final IconData? icon;
  const SectionTitle(this.text, {super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.naranja, size: 22),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.cafeOscuro)),
          ),
        ],
      ),
    );
  }
}

/// Aviso para contenidos que deben confirmarse con la comunidad.
class ValidationNotice extends StatelessWidget {
  const ValidationNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.arena,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.naranja.withValues(alpha: 0.4)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: AppColors.cafe),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Contenido en proceso de validación con la comunidad y fuentes institucionales. '
              'Si tienes datos o fotos para mejorarlo, envíalos desde la sección Contacto.',
              style: TextStyle(fontSize: 12.5, color: AppColors.cafeOscuro),
            ),
          ),
        ],
      ),
    );
  }
}
