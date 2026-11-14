import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

/// Etiqueta "Aprobado" (verde) o "Desaprobado" (rojo).
class EstadoBadge extends StatelessWidget {
  const EstadoBadge({super.key, required this.aprobado});

  final bool aprobado;

  @override
  Widget build(BuildContext context) {
    final fg = aprobado ? AppColors.success : AppColors.danger;
    final bg = aprobado ? AppColors.successBg : AppColors.dangerBg;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withAlpha(110)),
      ),
      child: Text(
        aprobado ? 'Aprobado' : 'Desaprobado',
        style: TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
