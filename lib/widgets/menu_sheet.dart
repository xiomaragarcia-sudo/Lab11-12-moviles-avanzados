import 'package:flutter/cupertino.dart';

import '../data/datos.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import 'dialogs.dart';

/// Cierra sesión (con confirmación) y vuelve al Login borrando el historial.
Future<void> confirmarLogout(BuildContext context) async {
  final ok = await showConfirmDialog(
    context,
    titulo: 'Cerrar sesión',
    mensaje: '¿Seguro que deseas salir?',
    textoConfirmar: 'Salir',
    destructivo: true,
  );
  if (ok && context.mounted) {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }
}

/// El botón ☰ abre este menú tipo iOS (CupertinoActionSheet),
/// construido recorriendo la lista de mapas [menuItems].
void showMenuSheet(BuildContext context, {String? actual}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (ctx) => CupertinoActionSheet(
      title: const Text('Menú'),
      message: const Text('¿A dónde quieres ir?'),
      actions: [
        for (final item in menuItems)
          CupertinoActionSheetAction(
            isDestructiveAction: item['destructivo'] == true,
            onPressed: () {
              Navigator.pop(ctx);
              final ruta = item['ruta'] as String?;
              if (ruta == null) {
                confirmarLogout(context);
              } else if (ruta != actual) {
                Navigator.pushNamed(context, ruta);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icono'] as IconData,
                  size: 20,
                  color: item['destructivo'] == true
                      ? CupertinoColors.destructiveRed
                      : AppColors.primary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    item['titulo'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: item['destructivo'] == true
                        ? null
                        : const TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.pop(ctx),
        child: const Text('Cancelar'),
      ),
    ),
  );
}
