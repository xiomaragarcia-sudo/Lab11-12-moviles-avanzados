import 'package:flutter/cupertino.dart';

import '../routes/app_routes.dart';

// ---------------------------------------------------------------------------
// LISTAS y MAPAS: los datos de la app se guardan como List<Map<String, ...>>.
// Usamos ValueNotifier para que las pantallas se actualicen solas
// cuando se agrega, edita o elimina algo.
// ---------------------------------------------------------------------------

/// Opciones del menú (una lista de mapas).
final List<Map<String, dynamic>> menuItems = [
  {
    'titulo': 'Registrar Alumnos',
    'icono': CupertinoIcons.person_badge_plus_fill,
    'color': const Color(0xFF5B47D6),
    'ruta': AppRoutes.registrar,
  },
  {
    'titulo': 'Listar Alumnos',
    'icono': CupertinoIcons.list_bullet,
    'color': const Color(0xFF007AFF),
    'ruta': AppRoutes.alumnos,
  },
  {
    'titulo': 'Perfil',
    'icono': CupertinoIcons.person_fill,
    'color': const Color(0xFF34C759),
    'ruta': AppRoutes.perfil,
  },
  {
    'titulo': 'Logout',
    'icono': CupertinoIcons.square_arrow_right,
    'color': const Color(0xFFFF3B30),
    'ruta': null, // null = cerrar sesión
    'destructivo': true,
  },
];

/// Lista de alumnos (cada alumno es un Map).
final ValueNotifier<List<Map<String, dynamic>>> alumnosNotifier =
    ValueNotifier([
  {'id': 1, 'nombre': 'Ana', 'apellido': 'Torres', 'nota': 18},
  {'id': 2, 'nombre': 'Luis', 'apellido': 'García', 'nota': 12},
  {'id': 3, 'nombre': 'María', 'apellido': 'López', 'nota': 9},
  {'id': 4, 'nombre': 'Carlos', 'apellido': 'Ruiz', 'nota': 15},
]);

int _siguienteId = 5;

/// Nota mínima aprobatoria (escala vigesimal).
bool estaAprobado(int nota) => nota >= 11;

void agregarAlumno(String nombre, String apellido, int nota) {
  alumnosNotifier.value = [
    ...alumnosNotifier.value,
    {
      'id': _siguienteId++,
      'nombre': nombre,
      'apellido': apellido,
      'nota': nota,
    },
  ];
}

void eliminarAlumno(int id) {
  alumnosNotifier.value =
      alumnosNotifier.value.where((a) => a['id'] != id).toList();
}

/// Datos del usuario que inició sesión (un Map).
final ValueNotifier<Map<String, String>> usuarioNotifier = ValueNotifier({
  'nombre': 'María González',
  'email': 'maria.gonzalez@correo.com',
  'telefono': '912345678',
  'rol': 'Docente',
});
