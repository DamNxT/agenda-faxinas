import 'package:agenda_faxinas/tema/tema_app.dart';
import 'package:agenda_faxinas/util/dinheiro.dart';
import 'package:agenda_faxinas/widgets/avatar_cliente.dart';
import 'package:agenda_faxinas/widgets/avisos.dart';
import 'package:agenda_faxinas/widgets/botao_principal.dart';
import 'package:agenda_faxinas/widgets/campo_valor.dart';
import 'package:agenda_faxinas/widgets/cartao_faxina.dart';
import 'package:agenda_faxinas/widgets/estado_vazio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget filho) => MaterialApp(
  theme: criarTemaApp(),
  home: Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: filho,
    ),
  ),
);

void main() {
  group('AvatarCliente', () {
    test('inicial e cor fixa por nome', () {
      expect(inicialDoNome('maria'), 'M');
      expect(inicialDoNome('  ana '), 'A');
      expect(inicialDoNome(''), '?');
      expect(corDoCliente('Maria'), corDoCliente('maria '));
      expect(CoresApp.avatares, contains(corDoCliente('Qualquer')));
    });

    testWidgets('mostra a inicial num círculo', (tester) async {
      await tester.pumpWidget(_app(const AvatarCliente(nome: 'dona Rosa')));
      expect(find.text('D'), findsOneWidget);
    });
  });

  testWidgets('CartaoFaxina mostra nome, endereço, valor e situação', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const Column(
          children: [
            CartaoFaxina(
              nome: 'Dona Maria',
              endereco: 'Rua das Flores, 10',
              valorCentavos: 15000,
              detalhe: 'Fixa: toda semana',
              destacarHoje: true,
            ),
            CartaoFaxina(
              nome: 'Seu João',
              valorCentavos: 18000,
              situacao: SituacaoFaxina.recebida,
            ),
            CartaoFaxina(nome: 'Ana', situacao: SituacaoFaxina.cancelada),
          ],
        ),
      ),
    );
    expect(find.text('Dona Maria'), findsOneWidget);
    expect(find.text('Rua das Flores, 10'), findsOneWidget);
    expect(find.text(formatarReais(15000)), findsOneWidget);
    expect(find.text('Fixa: toda semana'), findsOneWidget);
    expect(find.text('Recebido'), findsOneWidget);
    expect(find.text('Cancelada'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
  });

  group('CampoValor', () {
    test('validarValor', () {
      expect(validarValor('150'), isNull);
      expect(validarValor('1.500,00'), isNull);
      expect(validarValor(''), 'Digite o valor');
      expect(validarValor('', obrigatorio: false), isNull);
      expect(validarValor('1,2,3'), contains('Valor errado'));
    });

    testWidgets('mostra R\$, aceita só números e valida', (tester) async {
      final controlador = TextEditingController();
      final formulario = GlobalKey<FormState>();
      await tester.pumpWidget(
        _app(
          Form(
            key: formulario,
            child: CampoValor(controlador: controlador, rotulo: 'Valor'),
          ),
        ),
      );
      expect(find.text('Valor'), findsOneWidget);
      expect(find.text('R\$ '), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'abc150,5x');
      expect(controlador.text, '150,5');
      expect(formulario.currentState!.validate(), isTrue);

      await tester.enterText(find.byType(TextFormField), '');
      expect(formulario.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Digite o valor'), findsOneWidget);
    });
  });

  testWidgets('EstadoVazio explica e oferece o próximo passo', (tester) async {
    var tocou = false;
    await tester.pumpWidget(
      _app(
        EstadoVazio(
          icone: Icons.people,
          titulo: 'Nenhum cliente',
          explicacao: 'Toque abaixo para cadastrar.',
          textoBotao: 'Novo cliente',
          aoTocarBotao: () => tocou = true,
        ),
      ),
    );
    expect(find.text('Nenhum cliente'), findsOneWidget);
    expect(find.text('Toque abaixo para cadastrar.'), findsOneWidget);
    await tester.tap(find.text('Novo cliente'));
    expect(tocou, isTrue);
  });

  testWidgets('BotaoPrincipal é grande (pelo menos 48 de altura)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Column(
          children: [
            BotaoPrincipal(texto: 'Salvar', icone: Icons.check, aoTocar: () {}),
            BotaoPrincipal(
              texto: 'Fechar',
              tipo: TipoBotao.secundario,
              aoTocar: () {},
            ),
          ],
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(ElevatedButton)).height,
      greaterThanOrEqualTo(MedidasApp.alturaBotaoPrincipal),
    );
    expect(
      tester.getSize(find.byType(OutlinedButton)).height,
      greaterThanOrEqualTo(48),
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  });

  testWidgets('confirmarAcao só confirma no "Sim"', (tester) async {
    bool? resposta;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => resposta = await confirmarAcao(
              context,
              titulo: 'Excluir?',
              mensagem: 'Tem certeza?',
              textoConfirmar: 'Sim, excluir',
            ),
            child: const Text('abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Não, voltar'));
    await tester.pumpAndSettle();
    expect(resposta, isFalse);

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sim, excluir'));
    await tester.pumpAndSettle();
    expect(resposta, isTrue);
  });

  testWidgets('mostrarAviso com "Desfazer"', (tester) async {
    var desfez = false;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => mostrarAviso(
              context,
              'Faxina salva!',
              aoDesfazer: () => desfez = true,
            ),
            child: const Text('salvar'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Faxina salva!'), findsOneWidget);
    await tester.tap(find.text('Desfazer'));
    await tester.pumpAndSettle();
    expect(desfez, isTrue);
  });
}
