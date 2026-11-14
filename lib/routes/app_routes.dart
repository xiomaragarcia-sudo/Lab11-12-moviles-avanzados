import 'package:flutter/cupertino.dart';

import '../screens/listar_alumnos_screen.dart';
import '../screens/login_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/registrar_alumno_screen.dart';

/// RUTAS con nombre de la aplicación.
class AppRoutes {
  static const login = '/';
  static const menu = '/menu';
  static const alumnos = '/alumnos';
  static const registrar = '/registrar';
  static const perfil = '/perfil';

  /// Mapa ruta -> pantalla que usa CupertinoApp.
  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginScreen(),
        menu: (_) => const MenuScreen(),
        alumnos: (_) => const ListarAlumnosScreen(),
        registrar: (_) => const RegistrarAlumnoScreen(),
        perfil: (_) => const PerfilScreen(),
      };
}
