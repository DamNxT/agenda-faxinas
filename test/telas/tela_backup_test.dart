import 'dart:io';

import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/telas/backup/tela_backup.dart';
import 'package:agenda_faxinas/tema/tema_app.dart';
import 'package:agenda_faxinas/util/backup.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

class FakeServicoBackup extends ServicoBackup {
  FakeServicoBackup(super.banco);

  bool exportou = false;
  bool restaurou = false;

  @override
  Future<bool> exportarBackup() async {
    exportou = true;
    return true;
  }

  @override
  Future<File?> selecionarArquivoBackup() async {
    final tempDir = Directory.systemTemp.createTempSync();
    return File('${tempDir.path}/test.sqlite')..writeAsBytesSync([1, 2, 3]);
  }

  @override
  Future<bool> restaurarBackup(File arquivoOrigem) async {
    restaurou = true;
    return true;
  }
}

void main() {
  late BancoDados banco;
  late FakeServicoBackup fakeServico;

  setUpAll(() => initializeDateFormatting('pt_BR'));
  setUp(() {
    banco = BancoDados(NativeDatabase.memory());
    fakeServico = FakeServicoBackup(banco);
  });
  tearDown(() => banco.close());

  Future<void> abrirTela(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: criarTemaApp(),
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: TelaBackup(banco: banco, servicoMock: fakeServico),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fecharTela(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  testWidgets('salva cópia dos dados', (tester) async {
    await abrirTela(tester);

    expect(find.text('Cópia de Segurança'), findsOneWidget);
    expect(find.text('Salvar cópia dos dados'), findsOneWidget);

    await tester.tap(find.text('Salvar cópia dos dados'));
    await tester.pumpAndSettle();

    expect(fakeServico.exportou, isTrue);
    expect(find.text('Cópia de dados gerada com sucesso!'), findsOneWidget);

    await fecharTela(tester);
  });

  testWidgets('restaura cópia com confirmação', (tester) async {
    await abrirTela(tester);

    await tester.tap(find.text('Restaurar cópia'));
    await tester.pumpAndSettle();

    expect(find.text('Restaurar cópia dos dados?'), findsOneWidget);
    await tester.tap(find.text('Sim, restaurar'));
    await tester.pumpAndSettle();

    expect(fakeServico.restaurou, isTrue);
    expect(find.text('Dados restaurados com sucesso!'), findsOneWidget);

    await fecharTela(tester);
  });
}
