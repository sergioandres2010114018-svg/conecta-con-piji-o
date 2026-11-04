// Ajusta el proyecto Android generado con `flutter create`:
//  - Permiso de INTERNET (necesario en el APK de producción)
//  - Nombre visible de la app: "Conecta con Pijiño"
//  - Consultas para abrir enlaces y mapas (url_launcher, Android 11+)
//  - minSdk 23 (requerido por Firebase)
//  - Memoria de Gradle moderada (builds en GitHub Actions)
//
// Uso (desde la raíz del proyecto):  dart run tools/patch_android.dart
import 'dart:io';

void main() {
  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  if (!manifestFile.existsSync()) {
    stderr.writeln('No existe android/. Ejecuta primero: '
        'flutter create --platforms=android --org co.edu.pijino --project-name conecta_pijino .');
    exit(1);
  }

  // ------------------------------------------------------------ AndroidManifest
  var m = manifestFile.readAsStringSync();

  if (!m.contains('android.permission.INTERNET')) {
    m = m.replaceFirstMapped(
      RegExp(r'<manifest[^>]*>'),
      (match) =>
          '${match.group(0)}\n    <uses-permission android:name="android.permission.INTERNET"/>',
    );
  }

  m = m.replaceAll(
    RegExp(r'android:label="[^"]*"'),
    'android:label="Conecta con Pijiño"',
  );

  const queries = '''
        <intent>
            <action android:name="android.intent.action.VIEW"/>
            <data android:scheme="https"/>
        </intent>
        <intent>
            <action android:name="android.intent.action.VIEW"/>
            <data android:scheme="http"/>
        </intent>
        <intent>
            <action android:name="android.intent.action.VIEW"/>
            <data android:scheme="geo"/>
        </intent>''';

  if (!m.contains('android:scheme="https"')) {
    if (m.contains('<queries>')) {
      m = m.replaceFirst('<queries>', '<queries>\n$queries');
    } else {
      m = m.replaceFirst('</manifest>', '    <queries>\n$queries\n    </queries>\n</manifest>');
    }
  }
  manifestFile.writeAsStringSync(m);
  stdout.writeln('✔ AndroidManifest.xml actualizado');

  // ----------------------------------------------------------------- minSdk
  var patched = false;
  for (final path in ['android/app/build.gradle.kts', 'android/app/build.gradle']) {
    final f = File(path);
    if (!f.existsSync()) continue;
    var g = f.readAsStringSync();
    final before = g;
    g = g.replaceAll(RegExp(r'minSdk\s*=\s*flutter\.minSdkVersion'), 'minSdk = 23');
    g = g.replaceAll(RegExp(r'minSdkVersion\s+flutter\.minSdkVersion'), 'minSdkVersion 23');
    if (g != before) {
      f.writeAsStringSync(g);
      patched = true;
      stdout.writeln('✔ minSdk = 23 en $path');
    }
  }
  if (!patched) {
    stdout.writeln('ℹ minSdk no modificado (revisa android/app/build.gradle*; debe ser 23 o más).');
  }

  // ------------------------------------------------------- memoria de Gradle
  final props = File('android/gradle.properties');
  if (props.existsSync()) {
    var p = props.readAsStringSync();
    p = p.replaceAll(
      RegExp(r'org\.gradle\.jvmargs=.*'),
      'org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G -XX:+HeapDumpOnOutOfMemoryError',
    );
    props.writeAsStringSync(p);
    stdout.writeln('✔ gradle.properties actualizado');
  }
}
