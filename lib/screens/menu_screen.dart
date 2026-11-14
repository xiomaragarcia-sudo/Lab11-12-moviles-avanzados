import 'package:flutter/cupertino.dart';

import '../data/datos.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/avatars.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/menu_sheet.dart';

/// 2. MENÚ
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _abrir(BuildContext context, Map<String, dynamic> item) {
    final ruta = item['ruta'] as String?;
    if (ruta == null) {
      confirmarLogout(context);
    } else {
      Navigator.pushNamed(context, ruta);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: appNavBar(
        context,
        title: 'Menú',
        leading: NavIconButton(
          icon: CupertinoIcons.bars,
          onPressed: () => showMenuSheet(context, actual: AppRoutes.menu),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            const FadeSlideIn(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _TarjetaSaludo(),
              ),
            ),
            const SizedBox(height: 12),
            const FadeSlideIn(
              delay: Duration(milliseconds: 80),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _Estadisticas(),
              ),
            ),
            // LISTTILES: se generan recorriendo la lista de mapas menuItems
            CupertinoListSection.insetGrouped(
              header: const Text(
                'OPCIONES',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textMuted,
                ),
              ),
              backgroundColor: const Color(0x00000000),
              children: [
                for (var i = 0; i < menuItems.length; i++)
                  FadeSlideIn(
                    delay: Duration(milliseconds: 160 + i * 90),
                    child: _menuTile(context, menuItems[i]),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context, Map<String, dynamic> item) {
    final destructivo = item['destructivo'] == true;
    return CupertinoListTile(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: item['color'] as Color,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(item['icono'] as IconData,
            color: CupertinoColors.white, size: 17),
      ),
      title: Text(
        item['titulo'] as String,
        style: destructivo ? const TextStyle(color: AppColors.danger) : null,
      ),
      trailing: const CupertinoListTileChevron(),
      onTap: () => _abrir(context, item),
    );
  }
}

class _TarjetaSaludo extends StatelessWidget {
  const _TarjetaSaludo();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, String>>(
      valueListenable: usuarioNotifier,
      builder: (context, u, _) {
        final primerNombre = (u['nombre'] ?? '').split(' ').first;
        return AppCard(
          onTap: () => Navigator.pushNamed(context, AppRoutes.perfil),
          child: Row(
            children: [
              const UserAvatar(size: 56),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola, $primerNombre! 👋',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      u['rol'] ?? '',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const Icon(CupertinoIcons.chevron_right,
                  size: 18, color: AppColors.placeholder),
            ],
          ),
        );
      },
    );
  }
}

/// Pequeñas CARDS con estadísticas calculadas de la lista de alumnos.
class _Estadisticas extends StatelessWidget {
  const _Estadisticas();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: alumnosNotifier,
      builder: (context, alumnos, _) {
        final notas = alumnos.map((a) => a['nota'] as int).toList();
        final aprobados = notas.where(estaAprobado).length;
        final promedio = notas.isEmpty
            ? 0.0
            : notas.reduce((a, b) => a + b) / notas.length;
        return Row(
          children: [
            _Stat(valor: '${alumnos.length}', etiqueta: 'Alumnos'),
            const SizedBox(width: 10),
            _Stat(valor: '$aprobados', etiqueta: 'Aprobados'),
            const SizedBox(width: 10),
            _Stat(valor: promedio.toStringAsFixed(1), etiqueta: 'Promedio'),
          ],
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.valor, required this.etiqueta});

  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              valor,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(etiqueta,
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
