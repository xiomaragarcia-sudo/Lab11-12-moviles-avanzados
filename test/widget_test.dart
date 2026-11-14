import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab_11_12/main.dart';

void main() {
  testWidgets('Muestra la pantalla de login', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });

  testWidgets('Flujo: login -> menú -> registrar -> lista -> perfil',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Login
    await tester.enterText(find.byType(CupertinoTextField).at(0), 'maria@correo.com');
    await tester.enterText(find.byType(CupertinoTextField).at(1), '123456');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();
    expect(find.text('Menú'), findsWidgets);

    // Registrar alumno
    await tester.tap(find.text('Registrar Alumnos'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(CupertinoTextField).at(0), 'Rosa');
    await tester.enterText(find.byType(CupertinoTextField).at(1), 'Quispe');
    await tester.enterText(find.byType(CupertinoTextField).at(2), '17');
    await tester.pumpAndSettle();
    expect(find.text('Aprobado'), findsOneWidget);
    await tester.tap(find.text('GUARDAR'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver lista'));
    await tester.pumpAndSettle();

    // Lista con el nuevo alumno
    expect(find.text('Rosa Quispe'), findsOneWidget);
    expect(find.text('Ana Torres'), findsOneWidget);

    // Abrir el menú ☰ (action sheet) e ir al perfil
    await tester.tap(find.byIcon(CupertinoIcons.bars));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('EDITAR PERFIL'), findsOneWidget);
  });
}
