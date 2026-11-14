import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons; // solo para el icono de birrete
import 'package:flutter/services.dart';

import '../data/datos.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_text_field.dart';
import '../widgets/dialogs.dart';
import '../widgets/estado_badge.dart';
import '../widgets/fade_slide_in.dart';

/// 4. REGISTRAR ALUMNO
class RegistrarAlumnoScreen extends StatefulWidget {
  const RegistrarAlumnoScreen({super.key});

  @override
  State<RegistrarAlumnoScreen> createState() => _RegistrarAlumnoScreenState();
}

class _RegistrarAlumnoScreenState extends State<RegistrarAlumnoScreen> {
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _notaCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _notaCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();
    final nombre = _nombreCtrl.text.trim();
    final apellido = _apellidoCtrl.text.trim();
    final nota = int.tryParse(_notaCtrl.text);

    if (nombre.isEmpty || apellido.isEmpty) {
      return showInfoDialog(context,
          titulo: 'Faltan datos', mensaje: 'Ingresa el nombre y el apellido.');
    }
    if (nota == null || nota < 0 || nota > 20) {
      return showInfoDialog(context,
          titulo: 'Nota inválida', mensaje: 'La nota debe estar entre 0 y 20.');
    }

    agregarAlumno(nombre, apellido, nota);

    final verLista = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('¡Alumno registrado!'),
        content: Text('$nombre $apellido fue registrado correctamente.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Registrar otro'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ver lista'),
          ),
        ],
      ),
    );
    if (!mounted) return;

    if (verLista == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.alumnos,
        ModalRoute.withName(AppRoutes.menu),
      );
    } else {
      _nombreCtrl.clear();
      _apellidoCtrl.clear();
      _notaCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar:
          appNavBar(context, title: 'Registrar Alumno', showBack: true),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const FadeSlideIn(
              child: Text(
                'Completa los datos del alumno',
                style: TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 16),
            FadeSlideIn(
              delay: const Duration(milliseconds: 60),
              child: AppTextField(
                controller: _nombreCtrl,
                placeholder: 'Nombre del alumno',
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 14),
            FadeSlideIn(
              delay: const Duration(milliseconds: 120),
              child: AppTextField(
                controller: _apellidoCtrl,
                placeholder: 'Apellido',
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 14),
            FadeSlideIn(
              delay: const Duration(milliseconds: 180),
              child: AppTextField(
                controller: _notaCtrl,
                placeholder: 'Nota (0 - 20)',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                suffix: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.school, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Vista previa animada del estado según la nota escrita
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _notaCtrl,
              builder: (context, valor, _) {
                final nota = int.tryParse(valor.text);
                final Widget hijo;
                if (valor.text.isEmpty) {
                  hijo = const SizedBox.shrink(key: ValueKey('vacio'));
                } else if (nota == null || nota < 0 || nota > 20) {
                  hijo = const Text(
                    'La nota debe estar entre 0 y 20',
                    key: ValueKey('error'),
                    style: TextStyle(fontSize: 13, color: AppColors.danger),
                  );
                } else {
                  final aprobado = estaAprobado(nota);
                  hijo = Row(
                    key: ValueKey(aprobado),
                    children: [
                      const Text('Estado: ',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textMuted)),
                      EstadoBadge(aprobado: aprobado),
                    ],
                  );
                }
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SizeTransition(
                      sizeFactor: anim,
                      axisAlignment: -1,
                      child: child,
                    ),
                  ),
                  child: hijo,
                );
              },
            ),
            const SizedBox(height: 24),
            FadeSlideIn(
              delay: const Duration(milliseconds: 240),
              child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(10),
                onPressed: _guardar,
                child: const Text(
                  'GUARDAR',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, letterSpacing: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
