import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BancoDados banco;

  setUp(() {
    banco = BancoDados(NativeDatabase.memory());
  });

  tearDown(() => banco.close());

  Future<int> criarCliente([String nome = 'Cliente A']) {
    return banco
        .into(banco.clientes)
        .insert(
          ClientesCompanion.insert(nome: nome, valorPadraoCentavos: 15000),
        );
  }

  test('cria e lê um cliente', () async {
    await criarCliente();
    final clientes = await banco.select(banco.clientes).get();
    expect(clientes.single.nome, 'Cliente A');
    expect(clientes.single.endereco, isNull);
    expect(clientes.single.valorPadraoCentavos, 15000);
  });

  test('regra guarda vários dias da semana e o intervalo', () async {
    final clienteId = await criarCliente();
    await banco
        .into(banco.regrasRecorrencia)
        .insert(
          RegrasRecorrenciaCompanion.insert(
            clienteId: clienteId,
            diasSemana: [DateTime.thursday, DateTime.monday],
            dataInicio: DateTime(2026, 10, 5),
          ),
        );
    final regra = await banco.select(banco.regrasRecorrencia).getSingle();
    expect(regra.diasSemana, [DateTime.monday, DateTime.thursday]);
    expect(regra.intervaloSemanas, 1);
    expect(regra.dataInicio, DateTime(2026, 10, 5));
    expect(regra.dataFim, isNull);
  });

  test('exceção pode mover ou cancelar uma data', () async {
    final clienteId = await criarCliente();
    final regraId = await banco
        .into(banco.regrasRecorrencia)
        .insert(
          RegrasRecorrenciaCompanion.insert(
            clienteId: clienteId,
            diasSemana: [DateTime.wednesday],
            intervaloSemanas: const Value(2),
            dataInicio: DateTime(2026, 10, 7),
          ),
        );
    await banco
        .into(banco.excecoes)
        .insert(
          ExcecoesCompanion.insert(
            regraId: regraId,
            dataOriginal: DateTime(2026, 10, 21),
            novaData: Value(DateTime(2026, 10, 22)),
          ),
        );
    await banco
        .into(banco.excecoes)
        .insert(
          ExcecoesCompanion.insert(
            regraId: regraId,
            dataOriginal: DateTime(2026, 11, 4),
          ),
        );
    final excecoes = await banco.select(banco.excecoes).get();
    expect(excecoes[0].novaData, DateTime(2026, 10, 22));
    expect(excecoes[1].novaData, isNull, reason: 'nula = cancelada');
  });

  test('não aceita duas exceções para a mesma data da mesma regra', () async {
    final clienteId = await criarCliente();
    final regraId = await banco
        .into(banco.regrasRecorrencia)
        .insert(
          RegrasRecorrenciaCompanion.insert(
            clienteId: clienteId,
            diasSemana: [DateTime.tuesday],
            dataInicio: DateTime(2026, 10, 6),
          ),
        );
    final excecao = ExcecoesCompanion.insert(
      regraId: regraId,
      dataOriginal: DateTime(2026, 10, 13),
    );
    await banco.into(banco.excecoes).insert(excecao);
    expect(
      () => banco.into(banco.excecoes).insert(excecao),
      throwsA(isA<SqliteException>()),
    );
  });

  test('intervalo de semanas precisa ser 1 ou mais', () async {
    final clienteId = await criarCliente();
    expect(
      () => banco
          .into(banco.regrasRecorrencia)
          .insert(
            RegrasRecorrenciaCompanion.insert(
              clienteId: clienteId,
              diasSemana: [DateTime.monday],
              intervaloSemanas: const Value(0),
              dataInicio: DateTime(2026, 10, 5),
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('não aceita regra para cliente que não existe', () async {
    expect(
      () => banco
          .into(banco.regrasRecorrencia)
          .insert(
            RegrasRecorrenciaCompanion.insert(
              clienteId: 999,
              diasSemana: [DateTime.monday],
              dataInicio: DateTime(2026, 10, 5),
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('apagar cliente apaga suas regras, exceções e avulsos', () async {
    final clienteId = await criarCliente();
    final regraId = await banco
        .into(banco.regrasRecorrencia)
        .insert(
          RegrasRecorrenciaCompanion.insert(
            clienteId: clienteId,
            diasSemana: [DateTime.monday],
            dataInicio: DateTime(2026, 10, 5),
          ),
        );
    await banco
        .into(banco.excecoes)
        .insert(
          ExcecoesCompanion.insert(
            regraId: regraId,
            dataOriginal: DateTime(2026, 10, 12),
          ),
        );
    await banco
        .into(banco.atendimentosAvulsos)
        .insert(
          AtendimentosAvulsosCompanion.insert(
            clienteId: clienteId,
            data: DateTime(2026, 10, 10),
            valorCentavos: 20000,
          ),
        );

    await (banco.delete(
      banco.clientes,
    )..where((c) => c.id.equals(clienteId))).go();

    expect(await banco.select(banco.regrasRecorrencia).get(), isEmpty);
    expect(await banco.select(banco.excecoes).get(), isEmpty);
    expect(await banco.select(banco.atendimentosAvulsos).get(), isEmpty);
  });

  test('não apaga cliente que já tem diárias registradas', () async {
    final clienteId = await criarCliente();
    await banco
        .into(banco.registrosDiaria)
        .insert(
          RegistrosDiariaCompanion.insert(
            clienteId: clienteId,
            data: DateTime(2026, 10, 5),
            valorRecebidoCentavos: 15000,
          ),
        );
    expect(
      () => (banco.delete(
        banco.clientes,
      )..where((c) => c.id.equals(clienteId))).go(),
      throwsA(isA<SqliteException>()),
    );
  });

  test('registra venda de doces', () async {
    await banco
        .into(banco.vendasDoces)
        .insert(
          VendasDocesCompanion.insert(
            data: DateTime(2026, 10, 24),
            quantidadeLevada: 30,
            valorTotalCentavos: 9000,
          ),
        );
    final venda = await banco.select(banco.vendasDoces).getSingle();
    expect(venda.quantidadeLevada, 30);
    expect(venda.valorTotalCentavos, 9000);
  });
}
