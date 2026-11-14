import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'theme/ios_scroll_behavior.dart';
import 'widgets/phone_frame.dart';

final _rutaObserver = RutaObserver();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) await _cargarFuenteIOS();
  runApp(const MyApp());
}

/// En el navegador no existe la fuente del iPhone (San Francisco).
/// Registramos Inter (muy parecida) con los nombres que usan internamente
/// los widgets Cupertino, así las alertas y menús también se ven como iOS.
Future<void> _cargarFuenteIOS() async {
  try {
    for (final familia in ['CupertinoSystemText', 'CupertinoSystemDisplay']) {
      final loader = FontLoader(familia);
      for (final peso in [400, 500, 600, 700]) {
        loader.addFont(rootBundle.load('assets/fonts/Inter-$peso.ttf'));
      }
      await loader.load();
    }
  } catch (_) {
    // Si falla, la app sigue funcionando con la fuente por defecto.
  }
}

/// Raíz de la app: usamos CupertinoApp (estilo iOS) en lugar de MaterialApp.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Alumnos',
      debugShowCheckedModeBanner: false,
      // TEMA GLOBAL: todos los widgets Cupertino toman colores y textos de aquí.
      theme: AppTheme.theme,
      // Scroll con rebote como en iPhone.
      scrollBehavior: const IosScrollBehavior(),
      // RUTAS con nombre: cada pantalla se abre con Navigator.pushNamed(...)
      // y CupertinoApp aplica la animación de deslizamiento de iOS.
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      navigatorObservers: [_rutaObserver],
      // En PC muestra la app dentro de un marco de iPhone.
      builder: (context, child) => PhoneFrame(child: child ?? const SizedBox()),
    );
  }
}
