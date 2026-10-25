import 'package:drift/drift.dart';

import '../banco/banco_dados.dart';

/// Lançada quando o cliente não pode ser excluído porque já tem diárias
/// registradas (para não perder o histórico de ganhos).
class ClienteComHistoricoException implements Exception {
  const ClienteComHistoricoException();
}

/// Reúne as operações de banco de dados dos clientes.
class RepositorioClientes {
  RepositorioClientes(this._banco);

  final BancoDados _banco;

  /// Lista de clientes em ordem alfabética, atualizada automaticamente.
  Stream<List<Cliente>> observarTodos() {
    return (_banco.select(_banco.clientes)
          ..orderBy([(c) => OrderingTerm.asc(c.nome.collate(Collate.noCase))]))
        .watch();
  }

  Future<List<Cliente>> listarTodos() {
    return (_banco.select(_banco.clientes)
          ..orderBy([(c) => OrderingTerm.asc(c.nome.collate(Collate.noCase))]))
        .get();
  }

  Future<int> inserir({
    required String nome,
    String? endereco,
    required int valorPadraoCentavos,
  }) {
    return _banco
        .into(_banco.clientes)
        .insert(
          ClientesCompanion.insert(
            nome: nome.trim(),
            endereco: Value(_textoOuNulo(endereco)),
            valorPadraoCentavos: valorPadraoCentavos,
          ),
        );
  }

  Future<void> atualizar(Cliente cliente) async {
    await _banco
        .update(_banco.clientes)
        .replace(
          cliente.copyWith(
            nome: cliente.nome.trim(),
            endereco: Value(_textoOuNulo(cliente.endereco)),
          ),
        );
  }

  /// Exclui o cliente. Lança [ClienteComHistoricoException] se ele já tiver
  /// diárias registradas.
  Future<void> excluir(int id) async {
    final registros =
        await (_banco.select(_banco.registrosDiaria)
              ..where((r) => r.clienteId.equals(id))
              ..limit(1))
            .get();
    if (registros.isNotEmpty) throw const ClienteComHistoricoException();

    await (_banco.delete(_banco.clientes)..where((c) => c.id.equals(id))).go();
  }

  static String? _textoOuNulo(String? texto) {
    final limpo = texto?.trim() ?? '';
    return limpo.isEmpty ? null : limpo;
  }
}
