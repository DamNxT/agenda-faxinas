import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_doces.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BancoDados banco;
  late RepositorioDoces repoDoces;

  setUp(() {
    banco = BancoDados(NativeDatabase.memory());
    repoDoces = RepositorioDoces(banco);
  });
  tearDown(() => banco.close());

  test('registra e lista vendas de doces do mês', () async {
    final mes = DateTime(2026, 10, 1);
    await repoDoces.registrarVendaDoces(
      data: DateTime(2026, 10, 10),
      quantidadeLevada: 12,
      valorTotalCentavos: 6000,
    );
    await repoDoces.registrarVendaDoces(
      data: DateTime(2026, 10, 20),
      quantidadeLevada: 10,
      valorTotalCentavos: 5000,
    );

    final dados = await repoDoces.carregarMes(mes);
    expect(dados.vendas, hasLength(2));
    expect(dados.totalDocesLevados, 22);
    expect(dados.totalCentavos, 11000);
    expect(dados.vendas.first.quantidadeLevada, 10);
  });

  test('excluir venda remove do banco', () async {
    final mes = DateTime(2026, 10, 1);
    final id = await repoDoces.registrarVendaDoces(
      data: DateTime(2026, 10, 10),
      quantidadeLevada: 12,
      valorTotalCentavos: 6000,
    );

    var dados = await repoDoces.carregarMes(mes);
    expect(dados.vendas, hasLength(1));

    await repoDoces.excluirVendaDoces(id);
    dados = await repoDoces.carregarMes(mes);
    expect(dados.vendas, isEmpty);
  });
}
