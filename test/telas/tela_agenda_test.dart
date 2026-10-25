import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_agenda.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_clientes.dart';
import 'package:agenda_faxinas/tema/tema_app.dart';
import 'package:agenda_faxinas/telas/agenda/calendario.dart';
import 'package:agenda_faxinas/telas/agenda/tela_agenda.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// "Hoje" nos testes: segunda-feira, 26/10/2026.
final hoje = DateTime(2026, 10, 26);

void main() {
  late BancoDados banco;
  late RepositorioClientes clientes;
  late RepositorioAgenda agenda;

  setUpAll(() => initializeDateFormatting('pt_BR'));
  setUp(() {
    banco = BancoDados(NativeDatabase.memory());
    clientes = RepositorioClientes(banco);
    agenda = RepositorioAgenda(banco);
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
        home: TelaAgenda(banco: banco, hoje: hoje),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fecharTela(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  Future<void> tocar(WidgetTester tester, Finder alvo) async {
    await tester.ensureVisible(alvo);
    await tester.pumpAndSettle();
    await tester.tap(alvo);
    await tester.pumpAndSettle();
  }

  Finder dia(int ano, int mes, int d) =>
      find.byKey(chaveDia(DateTime(ano, mes, d)));

  Future<int> criarClienteA() async {
    final id = await clientes.inserir(
      nome: 'Cliente A',
      endereco: 'Rua das Flores, 10',
      valorPadraoCentavos: 15000,
    );
    await agenda.criarFaxinaFixa(
      clienteId: id,
      diasSemana: [DateTime.monday, DateTime.thursday],
      intervaloSemanas: 1,
      dataInicio: DateTime(2026, 10, 5),
    );
    return id;
  }

  testWidgets('"Hoje você tem" mostra nome e endereço', (tester) async {
    await criarClienteA();
    await abrirTela(tester);

    expect(find.text('Segunda-feira, 26 de outubro'), findsOneWidget);
    expect(find.text('Hoje você tem:'), findsOneWidget);
    expect(find.text('Cliente A'), findsWidgets);
    expect(find.text('Rua das Flores, 10'), findsOneWidget);
    await fecharTela(tester);
  });

  testWidgets('dia sem faxina e sem clientes', (tester) async {
    await abrirTela(tester);
    expect(find.text('Nenhuma faxina. Dia livre!'), findsOneWidget);
    expect(find.text('Sem faxina'), findsNWidgets(7));

    await tocar(tester, find.text('Nova faxina'));
    expect(
      find.textContaining('Você ainda não cadastrou nenhum cliente.'),
      findsOneWidget,
    );
    await fecharTela(tester);
  });

  testWidgets('semana marca os dias e tocar no dia mostra os clientes', (
    tester,
  ) async {
    await criarClienteA();
    await abrirTela(tester);

    expect(find.text('26 de outubro a 1 de novembro'), findsOneWidget);
    // Segunda (26) e quinta (29) têm faxina; o resto não.
    expect(find.text('Sem faxina'), findsNWidgets(5));
    expect(
      find.descendant(of: dia(2026, 10, 29), matching: find.text('Cliente A')),
      findsOneWidget,
    );

    await tocar(tester, dia(2026, 10, 29));
    expect(find.text('Quinta-feira, 29 de outubro'), findsOneWidget);
    expect(find.text('Fixa: toda semana'), findsOneWidget);
    await tocar(tester, find.text('Fechar'));

    await tocar(tester, dia(2026, 10, 27));
    expect(find.text('Nenhuma faxina neste dia.'), findsOneWidget);
    await tocar(tester, find.text('Fechar'));

    await tocar(tester, find.byTooltip('Próxima semana'));
    expect(find.text('2 a 8 de novembro'), findsOneWidget);
    expect(find.text('Voltar para hoje'), findsOneWidget);
    await tocar(tester, find.text('Voltar para hoje'));
    expect(find.text('26 de outubro a 1 de novembro'), findsOneWidget);
    await fecharTela(tester);
  });

  testWidgets('mês: dias com faxina ficam verdes', (tester) async {
    await criarClienteA();
    await abrirTela(tester);
    await tocar(tester, find.text('Mês'));
    expect(find.text('Outubro de 2026'), findsOneWidget);

    Color corDoDia(int d) => tester
        .widget<Material>(
          find
              .ancestor(of: dia(2026, 10, d), matching: find.byType(Material))
              .first,
        )
        .color!;
    expect(corDoDia(29), CoresApp.principal);
    expect(corDoDia(28), CoresApp.superficie);
    // Antes da data de início não tem faxina.
    expect(corDoDia(1), CoresApp.superficie);

    await tocar(tester, dia(2026, 10, 22));
    expect(find.text('Quinta-feira, 22 de outubro'), findsOneWidget);
    await tocar(tester, find.text('Fechar'));

    await tocar(tester, find.byTooltip('Próximo mês'));
    expect(find.text('Novembro de 2026'), findsOneWidget);
    expect(dia(2026, 11, 2), findsOneWidget);
    await fecharTela(tester);
  });

  testWidgets('cria faxina fixa a cada 15 dias', (tester) async {
    await clientes.inserir(nome: 'Cliente C', valorPadraoCentavos: 10000);
    await clientes.inserir(nome: 'Cliente D', valorPadraoCentavos: 10000);
    await abrirTela(tester);

    await tocar(tester, find.text('Nova faxina'));
    expect(find.text('Que tipo de faxina?'), findsOneWidget);
    await tocar(tester, find.text('Faxina FIXA'));

    // Salvar sem preencher mostra os avisos.
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Escolha o cliente'), findsOneWidget);
    expect(find.text('Escolha pelo menos um dia da semana'), findsOneWidget);

    await tocar(tester, find.text('Toque para escolher'));
    await tester.tap(find.text('Cliente C').last);
    await tester.pumpAndSettle();
    await tocar(tester, find.text('Quarta'));
    await tocar(tester, find.text('A cada 15 dias'));

    // Começa hoje (segunda 26/10): a 1ª quarta é 28/10, depois de 15 em 15.
    expect(find.text('• Quarta, 28/10/2026'), findsOneWidget);
    expect(find.text('• Quarta, 11/11/2026'), findsOneWidget);
    expect(find.text('• Quarta, 25/11/2026'), findsOneWidget);
    expect(find.text('• Quarta, 04/11/2026'), findsNothing);

    await tocar(tester, find.text('Salvar'));
    expect(find.text('Faxina fixa salva!'), findsOneWidget);
    expect(
      find.descendant(of: dia(2026, 10, 28), matching: find.text('Cliente C')),
      findsOneWidget,
    );

    await tocar(tester, find.byTooltip('Próxima semana'));
    expect(find.text('Cliente C'), findsNothing);
    await tocar(tester, find.byTooltip('Próxima semana'));
    expect(
      find.descendant(of: dia(2026, 11, 11), matching: find.text('Cliente C')),
      findsOneWidget,
    );

    final regra = await banco.select(banco.regrasRecorrencia).getSingle();
    expect(regra.diasSemana, [DateTime.wednesday]);
    expect(regra.intervaloSemanas, 2);
    expect(regra.dataInicio, hoje);
    await fecharTela(tester);
  });

  testWidgets('cria faxina só desta vez em outro dia', (tester) async {
    await clientes.inserir(nome: 'Ana', valorPadraoCentavos: 12000);
    await abrirTela(tester);

    await tocar(tester, find.text('Nova faxina'));
    await tocar(tester, find.text('Faxina SÓ DESTA VEZ'));
    // Com um só cliente, ele já vem escolhido.
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Segunda, 26/10/2026'), findsOneWidget);

    await tocar(tester, find.text('Segunda, 26/10/2026'));
    await tester.tap(find.text('30'));
    await tester.pumpAndSettle();
    await tocar(tester, find.text('OK'));
    expect(find.text('Sexta, 30/10/2026'), findsOneWidget);

    await tocar(tester, find.text('Salvar'));
    expect(find.text('Faxina salva!'), findsOneWidget);
    expect(find.text('Desfazer'), findsOneWidget);
    expect(
      find.descendant(of: dia(2026, 10, 30), matching: find.text('Ana')),
      findsOneWidget,
    );
    await tocar(tester, dia(2026, 10, 30));
    expect(find.text('Só desta vez'), findsOneWidget);
    await tocar(tester, find.text('Fechar'));

    // Não repete na semana seguinte.
    await tocar(tester, find.byTooltip('Próxima semana'));
    expect(find.text('Ana'), findsNothing);
    await fecharTela(tester);
  });

  testWidgets('"Desfazer" apaga a faxina que acabou de ser criada', (
    tester,
  ) async {
    await clientes.inserir(nome: 'Ana', valorPadraoCentavos: 12000);
    await abrirTela(tester);

    await tocar(tester, find.text('Nova faxina'));
    await tocar(tester, find.text('Faxina SÓ DESTA VEZ'));
    await tocar(tester, find.text('Salvar'));
    expect(
      find.descendant(of: dia(2026, 10, 26), matching: find.text('Ana')),
      findsOneWidget,
    );

    await tester.tap(find.text('Desfazer'));
    await tester.pumpAndSettle();
    expect(find.text('Pronto, a faxina foi apagada.'), findsOneWidget);
    expect(
      find.descendant(of: dia(2026, 10, 26), matching: find.text('Ana')),
      findsNothing,
    );
    expect(await banco.select(banco.atendimentosAvulsos).get(), isEmpty);
    await fecharTela(tester);
  });
}
