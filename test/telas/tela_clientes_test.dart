import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_clientes.dart';
import 'package:agenda_faxinas/tema/tema_app.dart';
import 'package:agenda_faxinas/telas/clientes/tela_clientes.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  late BancoDados banco;

  setUpAll(() => initializeDateFormatting('pt_BR'));
  setUp(() => banco = BancoDados(NativeDatabase.memory()));
  tearDown(() => banco.close());

  Future<void> abrirTela(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: criarTemaApp(),
        home: TelaClientes(banco: banco),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Desmonta a tela para o drift encerrar as consultas antes do fim.
  Future<void> fecharTela(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  Finder campo(String rotulo) => find.descendant(
    of: find
        .ancestor(of: find.text(rotulo), matching: find.byType(Column))
        .first,
    matching: find.byType(TextFormField),
  );

  testWidgets('cadastra um cliente novo', (tester) async {
    await abrirTela(tester);
    expect(find.textContaining('Nenhum cliente'), findsOneWidget);

    await tester.tap(find.text('Novo cliente'));
    await tester.pumpAndSettle();
    await tester.enterText(campo('Nome'), 'Dona Maria');
    await tester.enterText(campo('Endereço (opcional)'), 'Rua das Flores, 10');
    await tester.enterText(campo('Valor da diária'), '150');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Dona Maria'), findsOneWidget);
    expect(find.textContaining('150,00'), findsOneWidget);
    expect(find.text('Rua das Flores, 10'), findsOneWidget);
    expect(find.text('Cliente salvo!'), findsOneWidget);
    await fecharTela(tester);
  });

  testWidgets('não salva sem nome e com valor inválido', (tester) async {
    await abrirTela(tester);
    await tester.tap(find.text('Novo cliente'));
    await tester.pumpAndSettle();
    await tester.enterText(campo('Valor da diária'), '1,2,3');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Digite o nome do cliente'), findsOneWidget);
    expect(find.textContaining('Valor errado'), findsOneWidget);
    expect(await banco.select(banco.clientes).get(), isEmpty);
    await fecharTela(tester);
  });

  testWidgets('edita um cliente', (tester) async {
    await RepositorioClientes(banco)
        .inserir(nome: 'Ana', valorPadraoCentavos: 10000);
    await abrirTela(tester);

    await tester.tap(find.text('Ana'));
    await tester.pumpAndSettle();
    expect(find.text('Editar cliente'), findsOneWidget);
    expect(find.text('100,00'), findsOneWidget);

    await tester.enterText(campo('Nome'), 'Ana Paula');
    await tester.enterText(campo('Valor da diária'), '180,50');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Ana Paula'), findsOneWidget);
    expect(find.textContaining('180,50'), findsOneWidget);
    await fecharTela(tester);
  });

  testWidgets('pede confirmação antes de excluir', (tester) async {
    await RepositorioClientes(banco)
        .inserir(nome: 'Ana', valorPadraoCentavos: 10000);
    await abrirTela(tester);

    await tester.tap(find.text('Ana'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir cliente'));
    await tester.pumpAndSettle();
    expect(find.text('Excluir cliente?'), findsOneWidget);

    await tester.tap(find.text('Não, voltar'));
    await tester.pumpAndSettle();
    expect(await banco.select(banco.clientes).get(), hasLength(1));

    await tester.tap(find.text('Excluir cliente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sim, excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Cliente excluído.'), findsOneWidget);
    expect(find.textContaining('Nenhum cliente'), findsOneWidget);
    expect(await banco.select(banco.clientes).get(), isEmpty);
    await fecharTela(tester);
  });
}
