import 'dart:io';

import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/dados/repositorios/repositorio_clientes.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BancoDados banco;
  late RepositorioClientes repositorio;

  setUp(() {
    banco = BancoDados(NativeDatabase.memory());
    repositorio = RepositorioClientes(banco);
  });

  tearDown(() => banco.close());

  test('insere limpando espaços e endereço vazio vira nulo', () async {
    await repositorio.inserir(
      nome: '  Dona Maria ',
      endereco: '   ',
      valorPadraoCentavos: 15000,
    );
    final cliente = (await repositorio.observarTodos().first).single;
    expect(cliente.nome, 'Dona Maria');
    expect(cliente.endereco, isNull);
  });

  test('lista em ordem alfabética, sem diferenciar maiúsculas', () async {
    for (final nome in ['carla', 'Bruno', 'Ana']) {
      await repositorio.inserir(nome: nome, valorPadraoCentavos: 100);
    }
    final nomes = (await repositorio.observarTodos().first).map((c) => c.nome);
    expect(nomes, ['Ana', 'Bruno', 'carla']);
  });

  test('atualiza um cliente', () async {
    final id = await repositorio.inserir(
      nome: 'Ana',
      endereco: 'Rua A',
      valorPadraoCentavos: 100,
    );
    final cliente = (await repositorio.observarTodos().first).single;
    await repositorio.atualizar(
      cliente.copyWith(
        nome: 'Ana Paula',
        endereco: const Value(''),
        valorPadraoCentavos: 20000,
      ),
    );
    final atualizado = (await repositorio.observarTodos().first).single;
    expect(atualizado.id, id);
    expect(atualizado.nome, 'Ana Paula');
    expect(atualizado.endereco, isNull);
    expect(atualizado.valorPadraoCentavos, 20000);
  });

  test('exclui um cliente', () async {
    final id = await repositorio.inserir(nome: 'Ana', valorPadraoCentavos: 1);
    await repositorio.excluir(id);
    expect(await repositorio.observarTodos().first, isEmpty);
  });

  test('não exclui cliente com diárias registradas', () async {
    final id = await repositorio.inserir(nome: 'Ana', valorPadraoCentavos: 1);
    await banco
        .into(banco.registrosDiaria)
        .insert(
          RegistrosDiariaCompanion.insert(
            clienteId: id,
            data: DateTime(2026, 10, 1),
            valorRecebidoCentavos: 15000,
          ),
        );
    expect(
      () => repositorio.excluir(id),
      throwsA(isA<ClienteComHistoricoException>()),
    );
    expect(await repositorio.observarTodos().first, hasLength(1));
  });

  test('dados continuam salvos depois de fechar e abrir o banco', () async {
    final pasta = await Directory.systemTemp.createTemp('agenda_teste');
    addTearDown(() => pasta.delete(recursive: true));
    final arquivo = File('${pasta.path}/banco.sqlite');

    final primeiro = BancoDados(NativeDatabase(arquivo));
    await RepositorioClientes(primeiro)
        .inserir(nome: 'Ana', valorPadraoCentavos: 15000);
    await primeiro.close();

    final segundo = BancoDados(NativeDatabase(arquivo));
    final clientes = await RepositorioClientes(segundo).observarTodos().first;
    await segundo.close();
    expect(clientes.single.nome, 'Ana');
  });
}
