import 'package:drift/drift.dart';

import '../../util/datas.dart';
import '../banco/banco_dados.dart';

/// Item de ganho num dia (faxina ou doces).
sealed class ItemGanho {
  const ItemGanho({required this.data, required this.valorCentavos});

  final DateTime data;
  final int valorCentavos;
}

class GanhoFaxina extends ItemGanho {
  const GanhoFaxina({
    required super.data,
    required super.valorCentavos,
    required this.clienteNome,
    required this.registroId,
  });

  final String clienteNome;
  final int registroId;
}

class GanhoDoces extends ItemGanho {
  const GanhoDoces({
    required super.data,
    required super.valorCentavos,
    required this.quantidadeLevada,
    required this.vendaId,
  });

  final int quantidadeLevada;
  final int vendaId;
}

/// Resumo completo de ganhos de um mês.
class DadosGanhosMes {
  DadosGanhosMes({
    required this.mes,
    required this.totalGanhosFaxinas,
    required this.totalGanhosDoces,
    required this.quantidadeFaxinas,
    required this.itens,
  });

  final DateTime mes;
  final int totalGanhosFaxinas;
  final int totalGanhosDoces;
  final int quantidadeFaxinas;
  final List<ItemGanho> itens;

  int get totalGeral => totalGanhosFaxinas + totalGanhosDoces;
}

class RepositorioGanhos {
  RepositorioGanhos(this._banco);

  final BancoDados _banco;

  Stream<DadosGanhosMes> observarMes(DateTime mes) {
    return _banco
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _banco.registrosDiaria,
            _banco.vendasDoces,
            _banco.clientes,
          },
        )
        .watch()
        .asyncMap((_) => carregarMes(mes));
  }

  Future<DadosGanhosMes> carregarMes(DateTime mes) async {
    final inicio = DateTime(mes.year, mes.month, 1);
    final fim = DateTime(mes.year, mes.month + 1, 0);

    // Registros de diária no mês
    final queryDiarias = _banco.select(_banco.registrosDiaria).join([
      innerJoin(
        _banco.clientes,
        _banco.clientes.id.equalsExp(_banco.registrosDiaria.clienteId),
      ),
    ])
      ..where(
        _banco.registrosDiaria.data.isBiggerOrEqualValue(inicio) &
            _banco.registrosDiaria.data.isSmallerOrEqualValue(fim),
      );

    final resultadosDiarias = await queryDiarias.get();

    final itensFaxinas = <GanhoFaxina>[];
    var totalFaxinas = 0;

    for (final row in resultadosDiarias) {
      final reg = row.readTable(_banco.registrosDiaria);
      final cli = row.readTable(_banco.clientes);
      totalFaxinas += reg.valorRecebidoCentavos;
      itensFaxinas.add(
        GanhoFaxina(
          data: reg.data,
          valorCentavos: reg.valorRecebidoCentavos,
          clienteNome: cli.nome,
          registroId: reg.id,
        ),
      );
    }

    // Vendas de doces no mês
    final vendas = await (_banco.select(_banco.vendasDoces)
          ..where((v) =>
              v.data.isBiggerOrEqualValue(inicio) &
              v.data.isSmallerOrEqualValue(fim)))
        .get();

    final itensDoces = <GanhoDoces>[];
    var totalDoces = 0;

    for (final v in vendas) {
      totalDoces += v.valorTotalCentavos;
      itensDoces.add(
        GanhoDoces(
          data: v.data,
          valorCentavos: v.valorTotalCentavos,
          quantidadeLevada: v.quantidadeLevada,
          vendaId: v.id,
        ),
      );
    }

    final todosItens = <ItemGanho>[...itensFaxinas, ...itensDoces]
      ..sort((a, b) {
        final compData = b.data.compareTo(a.data);
        if (compData != 0) return compData;
        return a.hashCode.compareTo(b.hashCode);
      });

    return DadosGanhosMes(
      mes: mes,
      totalGanhosFaxinas: totalFaxinas,
      totalGanhosDoces: totalDoces,
      quantidadeFaxinas: itensFaxinas.length,
      itens: todosItens,
    );
  }
}
