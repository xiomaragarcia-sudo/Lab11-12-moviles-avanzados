import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../routes/app_routes.dart';

/// Ruta visible actualmente (para saber de qué color pintar la barra de estado).
final ValueNotifier<String?> rutaActual = ValueNotifier(AppRoutes.login);

/// Observa la navegación y actualiza [rutaActual].
class RutaObserver extends NavigatorObserver {
  void _actualizar(Route<dynamic>? route) {
    if (route is! PageRoute) return; // ignorar diálogos y action sheets
    final nombre = route.settings.name;
    scheduleMicrotask(() => rutaActual.value = nombre);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _actualizar(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) _actualizar(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _actualizar(newRoute);
}

/// Muestra la app dentro de un iPhone cuando la pantalla es ancha
/// (navegador de PC). En un celular real no hace nada.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  // Tamaño lógico de un iPhone 15 / 16.
  static const double _ancho = 393;
  static const double _alto = 852;
  static const double _bisel = 12;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    if (mq.size.width < 600) return child;

    final pantalla = SizedBox(
      width: _ancho,
      height: _alto,
      child: MediaQuery(
        // La app "cree" que corre en un iPhone: su tamaño y zonas seguras.
        data: mq.copyWith(
          size: const Size(_ancho, _alto),
          padding: const EdgeInsets.only(top: 54, bottom: 34),
          viewPadding: const EdgeInsets.only(top: 54, bottom: 34),
          viewInsets: EdgeInsets.zero,
        ),
        child: Stack(
          children: [
            Positioned.fill(child: child),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(child: _BarraEstado()),
            ),
            // Dynamic Island
            Positioned(
              top: 11,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    width: 124,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF000000),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            // Indicador de inicio (home indicator)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final telefono = Stack(
      clipBehavior: Clip.none,
      children: [
        // Botones laterales
        const Positioned(left: -4, top: 160, child: _BotonLateral(alto: 30)),
        const Positioned(left: -4, top: 215, child: _BotonLateral(alto: 62)),
        const Positioned(left: -4, top: 290, child: _BotonLateral(alto: 62)),
        const Positioned(right: -4, top: 250, child: _BotonLateral(alto: 100)),
        Container(
          padding: const EdgeInsets.all(_bisel),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1B1F),
            borderRadius: BorderRadius.circular(64),
            border: Border.all(color: const Color(0xFF45454D), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x553B2F8F),
                blurRadius: 60,
                offset: Offset(0, 30),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(52),
            child: pantalla,
          ),
        ),
      ],
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF1EEFF), Color(0xFFD8D1F7)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FittedBox(fit: BoxFit.scaleDown, child: telefono),
        ),
      ),
    );
  }
}

class _BotonLateral extends StatelessWidget {
  const _BotonLateral({required this.alto});

  final double alto;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: alto,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C32),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

/// Barra de estado de iOS: hora, señal, wifi y batería.
/// Texto negro en el Login (fondo blanco) y blanco en las demás (barra morada).
class _BarraEstado extends StatelessWidget {
  const _BarraEstado();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: rutaActual,
      builder: (context, ruta, _) {
        final color = ruta == AppRoutes.login
            ? const Color(0xFF000000)
            : const Color(0xFFFFFFFF);
        return SizedBox(
          height: 54,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(42, 6, 32, 0),
            child: Row(
              children: [
                Text(
                  '9:41',
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                _Senal(color: color),
                const SizedBox(width: 6),
                Icon(CupertinoIcons.wifi, size: 17, color: color),
                const SizedBox(width: 6),
                _Bateria(color: color),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Senal extends StatelessWidget {
  const _Senal({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final h in const [4.0, 6.5, 9.0, 11.5])
          Container(
            width: 3,
            height: h,
            margin: const EdgeInsets.only(left: 1.5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
      ],
    );
  }
}

class _Bateria extends StatelessWidget {
  const _Bateria({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 12,
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            border: Border.all(color: color.withAlpha(120)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 1.5),
        Container(
          width: 1.5,
          height: 4,
          decoration: BoxDecoration(
            color: color.withAlpha(120),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}
