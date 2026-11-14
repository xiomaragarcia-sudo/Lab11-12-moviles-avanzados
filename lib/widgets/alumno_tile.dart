import 'package:flutter/cupertino.dart';

import '../data/datos.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';
import 'avatars.dart';
import 'estado_badge.dart';

/// LISTTILE de un alumno: CupertinoListTile dentro de una AppCard.
class AlumnoTile extends StatelessWidget {
  const AlumnoTile({
    super.key,
    required this.alumno,
    this.onTap,
    this.onOpciones,
  });

  final Map<String, dynamic> alumno;
  final VoidCallback? onTap;
  final VoidCallback? onOpciones;

  @override
  Widget build(BuildContext context) {
    final nota = alumno['nota'] as int;
    return AppCard(
      padding: EdgeInsets.zero,
      child: CupertinoListTile(
        padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
        leadingSize: 44,
        leading: const StudentAvatar(),
        title: Text(
          '${alumno['nombre']} ${alumno['apellido']}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Nota: ${nota.toString().padLeft(2, '0')}'),
        additionalInfo: EstadoBadge(aprobado: estaAprobado(nota)),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onOpciones,
          child: const Icon(
            CupertinoIcons.ellipsis_vertical,
            color: AppColors.textMuted,
            size: 20,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
