import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'conversores.dart';
import 'tabelas.dart';

export 'tabelas.dart';

part 'banco_dados.g.dart';

@DriftDatabase(
  tables: [
    Clientes,
    RegrasRecorrencia,
    Excecoes,
    AtendimentosAvulsos,
    RegistrosDiaria,
    VendasDoces,
  ],
)
class BancoDados extends _$BancoDados {
  /// [executor] só é passado nos testes (banco em memória).
  BancoDados([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'agenda_faxinas'));

  /// Aumente este número sempre que mudar as tabelas (e crie a migração).
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (detalhes) async {
      // Liga a checagem de chaves estrangeiras do SQLite.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
