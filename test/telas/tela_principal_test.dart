import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_agenda.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_clientes.dart';
import 'package:agenda_faxinas/tema/tema_app.dart';
import 'package:agenda_faxinas/telas/estrutura/tela_principal.dart';
import 'package:agenda_faxinas/util/dinheiro.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// "Hoje" nos testes: segunda-feira, 26/10/2026.
final hoje = DateTime(2026, 10, 26);

void main() {
  late BancoDados banco;

  setUpAll(() => initializeDateFormatting('pt_BR'));
  setUp(() => banco = BancoDados(NativeDatabase.memory()));
  tearDown(() => banco.close());

  Future<void> abrir(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: criarTemaApp(),
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: TelaPrincipal(banco: banco, hoje: hoje),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fechar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  Finder aba(String nome) => find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(nome),
  );

  testWidgets('barra inferior com 4 abas, sempre com ícone e texto', (
    tester,
  ) async {
    await abrir(tester);
    for (final nome in ['Hoje', 'Agenda', 'Ganhos', 'Mais']) {
      expect(aba(nome), findsOneWidget);
    }
    expect(
      find.descendant(
        of: find.byType(NavigationDestination),
        matching: find.byType(Icon),
      ),
      findsNWidgets(4),
    );
    await fechar(tester);
  });

  testWidgets('Hoje sem clientes explica o próximo passo', (tester) async {
    await abrir(tester);
    expect(find.text('Segunda-feira, 26 de outubro de 2026'), findsOneWidget);
    expect(find.text('Vamos começar?'), findsOneWidget);
    await tester.tap(find.text('Cadastrar clientes'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Clientes'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await fechar(tester);
  });

  testWidgets('Hoje mostra cartões com nome, endereço e valor', (tester) async {
    final clientes = RepositorioClientes(banco);
    final agenda = RepositorioAgenda(banco);
    final maria = await clientes.inserir(
      nome: 'Dona Maria',
      endereco: 'Rua das Flores, 10',
      valorPadraoCentavos: 15000,
    );
    final joao = await clientes.inserir(
      nome: 'Seu João',
      valorPadraoCentavos: 18000,
    );
    await agenda.criarFaxinaFixa(
      clienteId: maria,
      diasSemana: [DateTime.monday],
      intervaloSemanas: 1,
      dataInicio: DateTime(2026, 10, 1),
    );
    await agenda.criarFaxinaAvulsa(clienteId: joao, data: hoje);

    await abrir(tester);
    expect(find.text('Você tem 2 faxinas hoje'), findsOneWidget);
    expect(find.text('Dona Maria'), findsOneWidget);
    expect(find.text('Rua das Flores, 10'), findsOneWidget);
    expect(find.text(formatarReais(15000)), findsOneWidget);
    expect(find.text('Seu João'), findsOneWidget);
    expect(find.text(formatarReais(18000)), findsOneWidget);
    expect(find.text('Só desta vez'), findsOneWidget);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await fechar(tester);
  });

  testWidgets('Hoje sem faxina leva para a Agenda', (tester) async {
    await RepositorioClientes(banco)
        .inserir(nome: 'Ana', valorPadraoCentavos: 10000);
    await abrir(tester);
    expect(find.text('Dia livre!'), findsOneWidget);
    await tester.tap(find.text('Abrir agenda'));
    await tester.pumpAndSettle();
    expect(find.text('Hoje você tem:'), findsOneWidget);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await fechar(tester);
  });

  testWidgets('Mais abre Clientes, Doces, Backup e Configurações', (
    tester,
  ) async {
    await abrir(tester);
    await tester.tap(aba('Mais'));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    for (final item in ['Clientes', 'Doces', 'Backup', 'Configurações']) {
      await tester.tap(find.text(item));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, item), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    }
    await fechar(tester);
  });

  testWidgets('Ganhos mostra resumo do mês', (tester) async {
    await abrir(tester);
    await tester.tap(aba('Ganhos'));
    await tester.pumpAndSettle();
    expect(find.text('Total geral do mês'), findsOneWidget);
    expect(find.text('Nenhum ganho neste mês'), findsOneWidget);
    await fechar(tester);
  });
}
