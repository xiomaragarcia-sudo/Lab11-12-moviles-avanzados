import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

/// Barra de navegación morada estilo iOS que usan todas las pantallas.
CupertinoNavigationBar appNavBar(
  BuildContext context, {
  required String title,
  Widget? leading,
  Widget? trailing,
  bool showBack = false,
}) {
  return CupertinoNavigationBar(
    backgroundColor: AppColors.primary,
    // Siempre morada (si no, Flutter la vuelve transparente cuando
    // no hay contenido desplazándose debajo, como en iOS 15+).
    automaticBackgroundVisibility: false,
    border: null,
    brightness: Brightness.dark, // iconos de la barra de estado en blanco
    automaticallyImplyLeading: false,
    leading: leading ??
        (showBack
            ? NavIconButton(
                icon: CupertinoIcons.back,
                onPressed: () => Navigator.of(context).pop(),
              )
            : null),
    middle: Text(title),
    trailing: trailing,
  );
}

/// Botón de icono blanco para la barra de navegación.
class NavIconButton extends StatelessWidget {
  const NavIconButton({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Icon(icon, color: CupertinoColors.white, size: 26),
    );
  }
}
