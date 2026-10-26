import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_doces.dart';
import 'package:agenda_faxinas/telas/doces/tela_doces.dart';
import 'package:agenda_faxinas/tema/tema_app.dart';
import 'package:agenda_faxinas/util/dinheiro.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

final hoje = DateTime(2026, 10, 26);

void main() {
  late BancoDados banco;
  late RepositorioDoces doces;

  setUpAll(() => initializeDateFormatting('pt_BR'));
  setUp(() {
    banco = BancoDados(NativeDatabase.memory());
    doces = RepositorioDoces(banco);
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
        home: TelaDoces(banco: banco, hoje: hoje),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
  }

  testWidgets('mostra vendas de doces do mês', (tester) async {
    await doces.registrarVendaDoces(
      data: DateTime(2026, 10, 10),
      quantidadeLevada: 10,
      valorTotalCentavos: 5000,
    );

    await abrirTela(tester);

    expect(find.text('Outubro de 2026'), findsOneWidget);
    expect(find.text('10 doces levados ao açougue'), findsOneWidget);
    expect(find.text(formatarReais(5000)), findsWidgets);
  });
}
