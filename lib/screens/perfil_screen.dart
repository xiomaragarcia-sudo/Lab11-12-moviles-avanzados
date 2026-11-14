import 'package:flutter/cupertino.dart';

import '../data/datos.dart';
import '../theme/app_theme.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_text_field.dart';
import '../widgets/avatars.dart';
import '../widgets/dialogs.dart';
import '../widgets/fade_slide_in.dart';

/// 5. PERFIL
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  void _editar(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => const _EditarPerfilSheet(),
    );
  }

  Widget _fila(IconData icono, String etiqueta, String valor) {
    return CupertinoListTile(
      leading: Icon(icono, color: AppColors.text, size: 22),
      title: Text(etiqueta, style: const TextStyle(fontSize: 15)),
      additionalInfo: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Text(
          valor,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, color: AppColors.text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: appNavBar(context, title: 'Perfil', showBack: true),
      child: SafeArea(
        child: ValueListenableBuilder<Map<String, String>>(
          valueListenable: usuarioNotifier,
          builder: (context, u, _) => ListView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            children: [
              // Avatar (Hero desde el Menú) + botón lápiz
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const UserAvatar(size: 112),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: GestureDetector(
                        onTap: () => _editar(context),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: CupertinoColors.white, width: 2.5),
                          ),
                          child: const Icon(CupertinoIcons.pencil,
                              size: 16, color: CupertinoColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                delay: const Duration(milliseconds: 80),
                child: Column(
                  children: [
                    Text(
                      u['nombre'] ?? '',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      u['email'] ?? '',
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: CupertinoListSection.insetGrouped(
                  backgroundColor: const Color(0x00000000),
                  children: [
                    _fila(CupertinoIcons.person_fill, 'Nombre', u['nombre'] ?? ''),
                    _fila(CupertinoIcons.mail_solid, 'Email', u['email'] ?? ''),
                    _fila(CupertinoIcons.phone_fill, 'Teléfono',
                        u['telefono'] ?? ''),
                    _fila(CupertinoIcons.gear_alt_fill, 'Roles', u['rol'] ?? ''),
                  ],
                ),
              ),
              FadeSlideIn(
                delay: const Duration(milliseconds: 240),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _editar(context),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        border: Border.all(color: AppColors.primary, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'EDITAR PERFIL',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hoja inferior (modal popup) para editar el perfil.
class _EditarPerfilSheet extends StatefulWidget {
  const _EditarPerfilSheet();

  @override
  State<_EditarPerfilSheet> createState() => _EditarPerfilSheetState();
}

class _EditarPerfilSheetState extends State<_EditarPerfilSheet> {
  late final _nombreCtrl =
      TextEditingController(text: usuarioNotifier.value['nombre']);
  late final _emailCtrl =
      TextEditingController(text: usuarioNotifier.value['email']);
  late final _telefonoCtrl =
      TextEditingController(text: usuarioNotifier.value['telefono']);

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_nombreCtrl.text.trim().isEmpty || !_emailCtrl.text.contains('@')) {
      showInfoDialog(context,
          titulo: 'Datos inválidos',
          mensaje: 'Revisa el nombre y el email.');
      return;
    }
    usuarioNotifier.value = {
      ...usuarioNotifier.value,
      'nombre': _nombreCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'telefono': _telefonoCtrl.text.trim(),
    };
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
        decoration: const BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Editar perfil',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _nombreCtrl,
                placeholder: 'Nombre',
                prefixIcon: CupertinoIcons.person,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _emailCtrl,
                placeholder: 'Email',
                prefixIcon: CupertinoIcons.mail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _telefonoCtrl,
                placeholder: 'Teléfono',
                prefixIcon: CupertinoIcons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                borderRadius: BorderRadius.circular(10),
                onPressed: _guardar,
                child: const Text('Guardar cambios'),
              ),
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
