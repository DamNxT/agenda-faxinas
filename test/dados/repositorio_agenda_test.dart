import 'package:agenda_faxinas/dados/agenda/calculo_agenda.dart';
import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_agenda.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_clientes.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BancoDados banco;
  late RepositorioAgenda agenda;
  late RepositorioClientes clientes;

  setUp(() {
    banco = BancoDados(NativeDatabase.memory());
    agenda = RepositorioAgenda(banco);
    clientes = RepositorioClientes(banco);
  });
  tearDown(() => banco.close());

  test('faxina fixa grava só a regra; as datas são calculadas', () async {
    final id = await clientes.inserir(
      nome: 'Cliente A',
      valorPadraoCentavos: 15000,
    );
    await agenda.criarFaxinaFixa(
      clienteId: id,
      diasSemana: [DateTime.thursday, DateTime.monday],
      intervaloSemanas: 1,
      dataInicio: DateTime(2026, 10, 5, 15, 30),
    );

    expect(await banco.select(banco.regrasRecorrencia).get(), hasLength(1));
    expect(await banco.select(banco.atendimentosAvulsos).get(), isEmpty);

    final dados = await agenda.carregar();
    expect(dados.regras.single.dataInicio, DateTime(2026, 10, 5));
    final mes = dados.faxinasEntre(
      DateTime(2026, 10, 1),
      DateTime(2026, 10, 31),
    );
    expect(mes, hasLength(8));
    expect(dados.faxinasDoDia(DateTime(2026, 10, 29)).single.clienteId, id);
  });

  test('faxina avulsa usa a diária do cliente', () async {
    final id = await clientes.inserir(nome: 'Ana', valorPadraoCentavos: 12000);
    await agenda.criarFaxinaAvulsa(clienteId: id, data: DateTime(2026, 11, 3));

    final avulso = await banco.select(banco.atendimentosAvulsos).getSingle();
    expect(avulso.valorCentavos, 12000);
    final dia = (await agenda.carregar()).faxinasDoDia(DateTime(2026, 11, 3));
    expect(dia.single.tipo, TipoFaxina.avulsa);
  });

  test('não aceita faxina fixa sem dia da semana', () async {
    final id = await clientes.inserir(nome: 'Ana', valorPadraoCentavos: 1);
    expect(
      () => agenda.criarFaxinaFixa(
        clienteId: id,
        diasSemana: [],
        intervaloSemanas: 1,
        dataInicio: DateTime(2026, 10, 5),
      ),
      throwsArgumentError,
    );
  });

  test('faxinas do dia vêm em ordem alfabética', () async {
    final b = await clientes.inserir(nome: 'beatriz', valorPadraoCentavos: 1);
    final a = await clientes.inserir(nome: 'Ana', valorPadraoCentavos: 1);
    for (final id in [b, a]) {
      await agenda.criarFaxinaFixa(
        clienteId: id,
        diasSemana: [DateTime.wednesday],
        intervaloSemanas: 2,
        dataInicio: DateTime(2026, 10, 7),
      );
    }
    final dados = await agenda.carregar();
    expect(dados.faxinasDoDia(DateTime(2026, 10, 21)).map((f) => f.clienteId), [
      a,
      b,
    ]);
  });

  test('observar avisa quando uma faxina é criada', () async {
    final id = await clientes.inserir(nome: 'Ana', valorPadraoCentavos: 1);
    final emissoes = agenda.observar().map((d) => d.regras.length);
    final esperado = expectLater(emissoes, emitsInOrder([0, 1]));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await agenda.criarFaxinaFixa(
      clienteId: id,
      diasSemana: [DateTime.tuesday],
      intervaloSemanas: 1,
      dataInicio: DateTime(2026, 10, 6),
    );
    await esperado;
  });

  test('excluir o cliente tira as faxinas dele da agenda', () async {
    final id = await clientes.inserir(nome: 'Ana', valorPadraoCentavos: 1);
    await agenda.criarFaxinaFixa(
      clienteId: id,
      diasSemana: [DateTime.tuesday],
      intervaloSemanas: 1,
      dataInicio: DateTime(2026, 10, 6),
    );
    await agenda.criarFaxinaAvulsa(clienteId: id, data: DateTime(2026, 10, 8));
    await clientes.excluir(id);

    final dados = await agenda.carregar();
    expect(
      dados.faxinasEntre(DateTime(2026, 10, 1), DateTime(2026, 10, 31)),
      isEmpty,
    );
  });
}
