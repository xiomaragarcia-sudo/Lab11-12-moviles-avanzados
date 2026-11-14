import 'package:flutter/cupertino.dart';

import '../data/datos.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/alumno_tile.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/dialogs.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/menu_sheet.dart';

/// 3. LISTAR ALUMNOS
class ListarAlumnosScreen extends StatefulWidget {
  const ListarAlumnosScreen({super.key});

  @override
  State<ListarAlumnosScreen> createState() => _ListarAlumnosScreenState();
}

class _ListarAlumnosScreenState extends State<ListarAlumnosScreen> {
  String _busqueda = '';
  int _filtro = 0; // 0 = Todos, 1 = Aprobados, 2 = Desaprobados

  List<Map<String, dynamic>> _filtrar(List<Map<String, dynamic>> alumnos) {
    final q = _busqueda.toLowerCase();
    return alumnos.where((a) {
      final nombre = '${a['nombre']} ${a['apellido']}'.toLowerCase();
      final aprobado = estaAprobado(a['nota'] as int);
      final pasaFiltro = _filtro == 0 ||
          (_filtro == 1 && aprobado) ||
          (_filtro == 2 && !aprobado);
      return nombre.contains(q) && pasaFiltro;
    }).toList();
  }

  String _nombreCompleto(Map<String, dynamic> a) =>
      '${a['nombre']} ${a['apellido']}';

  Future<bool> _confirmarEliminar(Map<String, dynamic> a) {
    return showConfirmDialog(
      context,
      titulo: 'Eliminar alumno',
      mensaje: '¿Deseas eliminar a ${_nombreCompleto(a)}?',
      textoConfirmar: 'Eliminar',
      destructivo: true,
    );
  }

  void _verDetalle(Map<String, dynamic> a) {
    final nota = a['nota'] as int;
    showInfoDialog(
      context,
      titulo: _nombreCompleto(a),
      mensaje: 'Nota: $nota\nEstado: '
          '${estaAprobado(nota) ? 'Aprobado ✅' : 'Desaprobado ❌'}',
    );
  }

  /// Botón ⋮ -> hoja de acciones estilo iOS.
  void _opciones(Map<String, dynamic> a) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(_nombreCompleto(a)),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              _verDetalle(a);
            },
            child: const Text('Ver detalle'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(ctx);
              if (await _confirmarEliminar(a)) eliminarAlumno(a['id'] as int);
            },
            child: const Text('Eliminar'),
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: appNavBar(
        context,
        title: 'Alumnos',
        leading: NavIconButton(
          icon: CupertinoIcons.bars,
          onPressed: () => showMenuSheet(context, actual: AppRoutes.alumnos),
        ),
        trailing: NavIconButton(
          icon: CupertinoIcons.add,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.registrar),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: CupertinoSearchTextField(
                placeholder: 'Buscar alumno...',
                onChanged: (v) => setState(() => _busqueda = v),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: _filtro,
                  onValueChanged: (v) => setState(() => _filtro = v ?? 0),
                  children: const {
                    0: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text('Todos', style: TextStyle(fontSize: 13)),
                    ),
                    1: Text('Aprobados', style: TextStyle(fontSize: 13)),
                    2: Text('Desaprobados', style: TextStyle(fontSize: 13)),
                  },
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: alumnosNotifier,
                builder: (context, alumnos, _) {
                  final lista = _filtrar(alumnos);
                  if (lista.isEmpty) return const _ListaVacia();

                  // LISTVIEW: se construye con los datos de la lista de mapas
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: lista.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final a = lista[i];
                      final id = a['id'] as int;
                      return FadeSlideIn(
                        key: ValueKey('anim$id'),
                        delay: Duration(milliseconds: 70 * (i < 8 ? i : 8)),
                        // Deslizar a la izquierda para eliminar
                        child: Dismissible(
                          key: ValueKey('alumno$id'),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) => _confirmarEliminar(a),
                          onDismissed: (_) => eliminarAlumno(id),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 22),
                            decoration: BoxDecoration(
                              color: AppColors.danger,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radius),
                            ),
                            child: const Icon(CupertinoIcons.trash,
                                color: CupertinoColors.white),
                          ),
                          child: AlumnoTile(
                            alumno: a,
                            onTap: () => _verDetalle(a),
                            onOpciones: () => _opciones(a),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaVacia extends StatelessWidget {
  const _ListaVacia();

  @override
  Widget build(BuildContext context) {
    return const FadeSlideIn(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.person_3, size: 64, color: AppColors.placeholder),
            SizedBox(height: 8),
            Text('No se encontraron alumnos',
                style: TextStyle(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
