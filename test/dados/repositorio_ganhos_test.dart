import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_agenda.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_clientes.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_doces.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_ganhos.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BancoDados banco;
  late RepositorioClientes clientes;
  late RepositorioAgenda agenda;
  late RepositorioDoces doces;
  late RepositorioGanhos ganhos;

  setUp(() {
    banco = BancoDados(NativeDatabase.memory());
    clientes = RepositorioClientes(banco);
    agenda = RepositorioAgenda(banco);
    doces = RepositorioDoces(banco);
    ganhos = RepositorioGanhos(banco);
  });
  tearDown(() => banco.close());

  test('calcula resumo de ganhos do mês de faxinas e doces', () async {
    final clienteId = await clientes.inserir(
      nome: 'Cliente A',
      valorPadraoCentavos: 15000,
    );

    // Registra 2 diárias de faxina em Outubro/2026
    await agenda.salvarRegistroDiaria(
      clienteId: clienteId,
      data: DateTime(2026, 10, 5),
      valorRecebidoCentavos: 15000,
    );
    await agenda.salvarRegistroDiaria(
      clienteId: clienteId,
      data: DateTime(2026, 10, 12),
      valorRecebidoCentavos: 16000,
    );

    // Registra 1 venda de doces em Outubro/2026
    await doces.registrarVendaDoces(
      data: DateTime(2026, 10, 15),
      quantidadeLevada: 10,
      valorTotalCentavos: 5000,
    );

    final mes = DateTime(2026, 10, 1);
    final dados = await ganhos.carregarMes(mes);

    expect(dados.totalGanhosFaxinas, 31000);
    expect(dados.totalGanhosDoces, 5000);
    expect(dados.totalGeral, 36000);
    expect(dados.quantidadeFaxinas, 2);
    expect(dados.itens, hasLength(3));
  });
}
