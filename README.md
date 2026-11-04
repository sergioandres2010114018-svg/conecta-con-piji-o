# APP · Conecta con Pijiño

> *“El corazón de Pijiño en cada atarraya”*

Aplicación móvil Android (Flutter) informativa, cultural y turística de **Pijiño del Carmen, Magdalena**.
Proyecto productivo del programa *Técnico en Programación de Aplicaciones para Dispositivos Móviles* (SENA – Centro Acuícola y Agroindustrial de Gaira), articulación con la Educación Media, **I.E.T.D. Pijiño del Carmen**. Grupo 3321831.

**App móvil creada por: Valentina Lopez, Lorena Lopez, Maria Machado y Yair Palomino · IE Pijiño · Proyecto SENATIC**

---

## Qué incluye (según el documento del proyecto)

| Requisito del PMV | Dónde está en la app |
|---|---|
| Pantalla de inicio | Splash con logo + pestaña **Inicio** (accesos rápidos, próximo evento, video, consejo ambiental) |
| Información general del municipio | **Explorar → El municipio** |
| Historia, cultura y tradiciones | **Explorar → Historia / Cultura y tradiciones** |
| Gastronomía | **Explorar → Gastronomía** |
| Sitios turísticos (con enlace a mapas) | **Explorar → Sitios turísticos** |
| Fiestas y eventos | Pestaña **Eventos** (cuenta regresiva a la próxima fiesta) |
| Galería multimedia | Pestaña **Galería**: fotos con zoom y **videos** con reproductor |
| Información ambiental | **Explorar → Cuidemos el entorno** + consejo del día |
| Contacto / participación / enlaces | **Explorar → Contacto** (formulario guardado en Firestore + enlaces de interés) |
| Login y registro de usuarios | Registro, inicio de sesión, recuperar contraseña, verificación de correo, perfil editable y eliminar cuenta |
| Identidad corporativa | Logo oficial, paleta (naranja, café, arena, negro), misión, visión, valores, simbología y organigrama en **Acerca del proyecto** |
| Créditos | Pie de página en login, registro, inicio y todas las pantallas |

Los usuarios se almacenan en **Firebase Authentication** (acceso) y **Cloud Firestore** (colección `usuarios`: nombre, correo, teléfono, relación con Pijiño, fecha de registro y último acceso).

## Estructura del repositorio

```
conecta_con_pijino/
├── .github/workflows/build-apk.yml   ← GitHub genera el APK automáticamente
├── assets/
│   ├── data/contenido.json           ← TODOS los textos editables (historia, fiestas, etc.)
│   ├── images/                       ← logo, organigrama, ilustraciones, galería
│   ├── videos/                       ← videos MP4 de la galería
│   └── icon/                         ← ícono de la app (logo)
├── lib/
│   ├── main.dart · firebase_options.dart
│   ├── core/ models/ services/ widgets/
│   └── screens/ (auth/, inicio, explorar, galería, eventos, perfil...)
├── tools/patch_android.dart          ← ajusta permisos/minSdk del proyecto Android
├── docs/                             ← guías paso a paso
├── firestore.rules                   ← reglas de seguridad de la base de datos
├── test/ · pubspec.yaml · analysis_options.yaml · .gitignore
```

La carpeta `android/` **no se sube**: se genera sola con `flutter create` (lo hace el workflow de GitHub y lo puedes hacer en tu PC). Así el repositorio queda liviano y siempre compatible con la versión de Flutter.

## Pasos rápidos

1. **Firebase** → sigue [`docs/GUIA_FIREBASE.md`](docs/GUIA_FIREBASE.md) y pega tus datos en `lib/firebase_options.dart`.
2. **GitHub + APK** → sigue [`docs/GUIA_GITHUB_Y_APK.md`](docs/GUIA_GITHUB_Y_APK.md). Al subir el código, GitHub Actions construye el APK y lo deja descargable.
3. **Contenido** → revisa [`docs/CONTENIDOS_POR_VALIDAR.md`](docs/CONTENIDOS_POR_VALIDAR.md) con la comunidad y edita `assets/data/contenido.json`.

### Compilar en tu computador (opcional)

```bash
flutter create --platforms=android --org co.edu.pijino --project-name conecta_pijino .
dart run tools/patch_android.dart
flutter pub get
dart run flutter_launcher_icons
flutter build apk --release
# APK en: build/app/outputs/flutter-apk/app-release.apk
```

## Cambiar fotos y videos por los reales

Las imágenes y videos incluidos son **ilustraciones y videos de ejemplo** hechos con la paleta del logo (el equipo debe reemplazarlos por material propio, como indica el plan de trabajo: fotos y videos con cámara de celular).

* Fotos: reemplaza los archivos de `assets/images/gallery/` y `assets/images/sections/` **con el mismo nombre** (JPG, ~1200×800).
* Videos: reemplaza `assets/videos/*.mp4` (H.264, idealmente < 20 MB) o agrega nuevos y regístralos en `contenido.json` → `galeria.videos` (`asset` para archivos locales, `url` para un enlace directo `.mp4`).

## Tecnologías

Flutter / Dart · Firebase Auth · Cloud Firestore · video_player · url_launcher · GitHub Actions.

## Licencia y datos

Proyecto académico. Los contenidos culturales deben validarse con la comunidad antes de publicarse (ver documento de contenidos por validar). Los datos de usuarios se tratan conforme a la Ley 1581 de 2012.
