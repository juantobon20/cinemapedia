# cinemapedia

# Dev

1. Copiar el archivo .env.template y renombrarlo a .env
2. Cambiar las variables de entorno (TheMovieDb)
3. Cambios en la entidad, hay que ejecutar el comando
``
flutter pub run build_runner build
``

Cambiar nombre del package de la aplicacion
``
flutter pub run change_app_package_name:main com.appinc.cinemapedia
``

Cambiar el icono de la aplicación
``
flutter pub run flutter_launcher_icons
``

Cambiar el splash screen
``
dart run flutter_native_splash:create
``

Generar Keystore
``
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
``
