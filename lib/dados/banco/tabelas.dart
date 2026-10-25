// O drift usa getters que se referem a si mesmos nos checks (check()).
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import 'conversores.dart';

// Valores em dinheiro são guardados em CENTAVOS (número inteiro) para evitar
// erros de arredondamento. Ex.: R$ 150,00 = 15000.
//
// Datas são guardadas sempre à meia-noite (só o dia importa).

/// Clientes da faxina.
@DataClassName('Cliente')
class Clientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text().withLength(min: 1, max: 100)();
  TextColumn get endereco => text().nullable()();
  IntColumn get valorPadraoCentavos =>
      integer().check(valorPadraoCentavos.isBiggerOrEqualValue(0))();
}

/// Regra de faxina fixa (recorrente). As datas NÃO são gravadas: elas são
/// calculadas a partir desta regra.
///
/// Exemplo: "quarta-feira, a cada 15 dias a partir de 07/10/2026"
///   diasSemana = [3], intervaloSemanas = 2, dataInicio = 2026-10-07.
@DataClassName('RegraRecorrencia')
class RegrasRecorrencia extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId =>
      integer().references(Clientes, #id, onDelete: KeyAction.cascade)();

  /// Dias da semana: 1 = segunda ... 7 = domingo (padrão do Dart).
  TextColumn get diasSemana => text().map(const DiasSemanaConversor())();

  /// 1 = toda semana, 2 = a cada 15 dias, e assim por diante.
  IntColumn get intervaloSemanas => integer()
      .withDefault(const Constant(1))
      .check(intervaloSemanas.isBiggerOrEqualValue(1))();

  DateTimeColumn get dataInicio => dateTime()();
  DateTimeColumn get dataFim => dateTime().nullable()();
}

/// Exceção a uma regra: move ou cancela UMA data, sem mexer nas outras.
/// Se [novaData] for nula, a faxina daquele dia foi cancelada.
@DataClassName('Excecao')
class Excecoes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get regraId => integer().references(
    RegrasRecorrencia,
    #id,
    onDelete: KeyAction.cascade,
  )();
  DateTimeColumn get dataOriginal => dateTime()();
  DateTimeColumn get novaData => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {regraId, dataOriginal},
  ];
}

/// Faxina única, que não segue nenhuma regra.
@DataClassName('AtendimentoAvulso')
class AtendimentosAvulsos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId =>
      integer().references(Clientes, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get data => dateTime()();
  IntColumn get valorCentavos =>
      integer().check(valorCentavos.isBiggerOrEqualValue(0))();
}

/// Quanto foi realmente recebido por uma diária.
/// Não deixa apagar o cliente se houver registros, para não perder o
/// histórico de ganhos.
@DataClassName('RegistroDiaria')
class RegistrosDiaria extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId =>
      integer().references(Clientes, #id, onDelete: KeyAction.restrict)();
  DateTimeColumn get data => dateTime()();
  IntColumn get valorRecebidoCentavos =>
      integer().check(valorRecebidoCentavos.isBiggerOrEqualValue(0))();
}

/// Venda de doces de um dia.
@DataClassName('VendaDoces')
class VendasDoces extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get data => dateTime()();
  IntColumn get quantidadeLevada =>
      integer().check(quantidadeLevada.isBiggerOrEqualValue(0))();
  IntColumn get valorTotalCentavos =>
      integer().check(valorTotalCentavos.isBiggerOrEqualValue(0))();
}
