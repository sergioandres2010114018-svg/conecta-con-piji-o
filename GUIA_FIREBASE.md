# Guía de Firebase (usuarios y base de datos)

Firebase guarda a las personas que se registran. El plan gratuito (Spark) es suficiente para el PMV.

## 1. Crear el proyecto
1. Entra a <https://console.firebase.google.com> con una cuenta de Google del equipo.
2. **Crear un proyecto** → nombre: `conecta-con-pijino` → (Analytics es opcional) → Crear.

## 2. Registrar la app Android
1. En el proyecto: **Agregar app → Android**.
2. **Nombre del paquete:** `co.edu.pijino.conecta_pijino` (debe ser exactamente este).
3. Apodo: `Conecta con Pijiño`. El SHA-1 no es necesario para correo/contraseña.
4. Puedes **omitir** la descarga de `google-services.json` y los pasos de Gradle: esta app usa `firebase_options.dart`.

## 3. Copiar los datos a `lib/firebase_options.dart`
En **Configuración del proyecto (⚙) → General → Tus apps → Android** (o en el archivo `google-services.json` si lo descargas) encuentras:

| En `firebase_options.dart` | Dónde está en la consola / en el JSON |
|---|---|
| `_apiKey` | Clave de API web → `client[0].api_key[0].current_key` |
| `_appId` | ID de la aplicación → `client[0].client_info.mobilesdk_app_id` |
| `_messagingSenderId` | Número del proyecto → `project_info.project_number` |
| `_projectId` | ID del proyecto → `project_info.project_id` |
| `_storageBucket` | `project_info.storage_bucket` |

Reemplaza cada texto `REEMPLAZAR_...`. (Alternativa: instalar `flutterfire configure` y generar el archivo).

> Estos valores **no son secretos** (viajan dentro de cualquier APK). Lo que protege los datos son las reglas del paso 5.

## 4. Activar el inicio de sesión
**Compilación → Authentication → Comenzar → Método de acceso → Correo electrónico/contraseña → Habilitar → Guardar.**

## 5. Crear la base de datos y las reglas
1. **Compilación → Firestore Database → Crear base de datos** → ubicación (p. ej. `nam5` o `southamerica-east1`) → modo **producción**.
2. Pestaña **Reglas** → pega el contenido de [`firestore.rules`](../firestore.rules) → **Publicar**.

## 6. Dónde ver a los usuarios registrados
* **Authentication → Usuarios:** correo, fecha de creación y último ingreso.
* **Firestore → colección `usuarios`:** nombre, correo, teléfono, relación con Pijiño (habitante, visitante, estudiante...).
* **Firestore → colección `sugerencias`:** mensajes enviados desde la sección Contacto.
* Para exportar a Excel: Firestore permite exportar con Google Cloud, o puedes copiar los datos desde la consola.

## 7. Recomendaciones de seguridad
* En <https://console.cloud.google.com> → APIs y servicios → Credenciales, **restringe la clave de API** a aplicaciones Android con el paquete `co.edu.pijino.conecta_pijino`.
* Respalda periódicamente los datos (el documento del proyecto lo señala como riesgo).
* Para publicar en Google Play necesitarás firmar la app con tu propia llave (ver guía de GitHub).
