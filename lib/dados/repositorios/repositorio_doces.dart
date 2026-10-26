import 'package:drift/drift.dart';

import '../../util/datas.dart';
import '../banco/banco_dados.dart';

/// Sumário e lista de vendas de doces num mês.
class DadosDocesMes {
  DadosDocesMes({
    required this.mes,
    required this.vendas,
  });

  final DateTime mes;
  final List<VendaDoces> vendas;

  int get totalDocesLevados =>
      vendas.fold(0, (soma, v) => soma + v.quantidadeLevada);

  int get totalCentavos =>
      vendas.fold(0, (soma, v) => soma + v.valorTotalCentavos);
}

class RepositorioDoces {
  RepositorioDoces(this._banco);

  final BancoDados _banco;

  Stream<DadosDocesMes> observarMes(DateTime mes) {
    return _banco
        .customSelect(
          'SELECT 1',
          readsFrom: {_banco.vendasDoces},
        )
        .watch()
        .asyncMap((_) => carregarMes(mes));
  }

  Future<DadosDocesMes> carregarMes(DateTime mes) async {
    final inicio = DateTime(mes.year, mes.month, 1);
    final fim = DateTime(mes.year, mes.month + 1, 0);

    final vendas = await (_banco.select(_banco.vendasDoces)
          ..where((v) =>
              v.data.isBiggerOrEqualValue(inicio) &
              v.data.isSmallerOrEqualValue(fim))
          ..orderBy([
            (v) => OrderingTerm(expression: v.data, mode: OrderingMode.desc),
            (v) => OrderingTerm(expression: v.id, mode: OrderingMode.desc),
          ]))
        .get();

    return DadosDocesMes(mes: mes, vendas: vendas);
  }

  Future<int> registrarVendaDoces({
    required DateTime data,
    required int quantidadeLevada,
    required int valorTotalCentavos,
  }) {
    return _banco.into(_banco.vendasDoces).insert(
          VendasDocesCompanion.insert(
            data: soDia(data),
            quantidadeLevada: quantidadeLevada,
            valorTotalCentavos: valorTotalCentavos,
          ),
        );
  }

  Future<void> excluirVendaDoces(int id) =>
      (_banco.delete(_banco.vendasDoces)..where((v) => v.id.equals(id))).go();
}
