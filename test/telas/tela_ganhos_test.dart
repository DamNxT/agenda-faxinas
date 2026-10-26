import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_agenda.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_clientes.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_doces.dart';
import 'package:agenda_faxinas/telas/ganhos/tela_ganhos.dart';
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
  late RepositorioClientes clientes;
  late RepositorioAgenda agenda;
  late RepositorioDoces doces;

  setUpAll(() => initializeDateFormatting('pt_BR'));
  setUp(() {
    banco = BancoDados(NativeDatabase.memory());
    clientes = RepositorioClientes(banco);
    agenda = RepositorioAgenda(banco);
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
        home: TelaGanhos(banco: banco, hoje: hoje),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
  }

  Future<void> fecharTela(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  testWidgets('mostra resumo e detalhamento de ganhos do mês', (tester) async {
    final clienteId = await clientes.inserir(
      nome: 'Cliente A',
      valorPadraoCentavos: 15000,
    );
    await agenda.salvarRegistroDiaria(
      clienteId: clienteId,
      data: DateTime(2026, 10, 10),
      valorRecebidoCentavos: 15000,
    );
    await doces.registrarVendaDoces(
      data: DateTime(2026, 10, 12),
      quantidadeLevada: 8,
      valorTotalCentavos: 4000,
    );

    await abrirTela(tester);

    expect(find.text('Outubro de 2026'), findsOneWidget);
    expect(find.text('Total geral do mês'), findsOneWidget);
    expect(find.text(formatarReais(19000)), findsOneWidget);
    expect(find.text(formatarReais(15000)), findsWidgets);
    expect(find.text(formatarReais(4000)), findsWidgets);
    expect(find.text('1 realizada'), findsOneWidget);
    expect(find.text('Cliente A'), findsOneWidget);
    expect(find.text('Venda de doces'), findsOneWidget);

    await fecharTela(tester);
  });
}
