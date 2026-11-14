import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons; // solo para el icono de birrete

import '../theme/app_theme.dart';

/// Avatar del usuario. Usa HERO para "volar" entre Menú y Perfil.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'avatar-perfil',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withAlpha(60), width: 2),
        ),
        child: Icon(
          CupertinoIcons.person_fill,
          size: size * 0.58,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Avatar de alumno con birrete.
class StudentAvatar extends StatelessWidget {
  const StudentAvatar({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.school, size: size * 0.55, color: AppColors.primary),
    );
  }
}
