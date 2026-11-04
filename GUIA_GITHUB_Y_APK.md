# Subir a GitHub y generar el APK

## A. Subir el proyecto a GitHub

1. Crea una cuenta en <https://github.com> y un repositorio nuevo: **`conecta-con-pijino`** (Público o Privado, sin README).
2. Descomprime `conecta_con_pijino.zip`. **Sube todo el contenido de la carpeta** (incluida la carpeta oculta `.github`).

**Opción fácil (sin comandos):** en el repositorio → *uploading an existing file* → arrastra todas las carpetas y archivos → *Commit changes*.
> Si el navegador no sube la carpeta `.github`, usa la opción de comandos o GitHub Desktop.

**Opción con comandos:**
```bash
cd conecta_con_pijino
git init
git add .
git commit -m "Primera versión de APP Conecta con Pijiño"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/conecta-con-pijino.git
git push -u origin main
```

## B. Antes de subir: configura Firebase
Completa `lib/firebase_options.dart` (guía `GUIA_FIREBASE.md`). Si lo subes sin configurar, el APK se genera pero mostrará la pantalla “Falta configurar Firebase”.

## C. Obtener el APK
1. En GitHub abre la pestaña **Actions** → workflow **Generar APK** (se ejecuta solo al subir el código; también con *Run workflow*).
2. Espera ~8–12 minutos hasta ver ✅.
3. Entra a la ejecución → sección **Artifacts** → descarga **conecta-con-pijino-apk** (ZIP con `conecta-con-pijino.apk`).
4. Pásalo al celular e instálalo (permite “instalar apps de origen desconocido”).

**Publicar una versión descargable (Releases):**
```bash
git tag v1.0.0
git push origin v1.0.0
```
GitHub creará un *Release* con el APK adjunto, con un enlace público para compartir.

## D. Si el workflow falla
Abre el paso en rojo en *Actions* y copia el error. Causas frecuentes:
* Versión de Flutter: cambia `flutter-version` en `.github/workflows/build-apk.yml` (por ejemplo a la última estable).
* Firebase mal copiado en `firebase_options.dart` (no afecta la compilación, solo el funcionamiento).
* El paso *Analizar código* no bloquea; el que bloquea es *Compilar APK*.

## E. Para Google Play (futuro)
El APK de este flujo está firmado con la llave de depuración: sirve para pruebas y para la sustentación. Para Play Store se necesita una llave propia (`keystore`), formato AAB (`flutter build appbundle`) y guardar la llave como *Secret* de GitHub. **Nunca subas archivos `.jks`, `.keystore` ni `key.properties`** (ya están en `.gitignore`).
