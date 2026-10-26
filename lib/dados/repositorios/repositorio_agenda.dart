import 'package:drift/drift.dart';

import '../../util/datas.dart';
import '../agenda/calculo_agenda.dart';
import '../banco/banco_dados.dart';

/// Tudo o que a tela da agenda precisa, já lido do banco.
class DadosAgenda {
  DadosAgenda({
    required this.clientes,
    required this.regras,
    required this.excecoes,
    required this.avulsos,
    required this.registros,
  });

  final Map<int, Cliente> clientes;
  final List<RegraRecorrencia> regras;
  final List<Excecao> excecoes;
  final List<AtendimentoAvulso> avulsos;
  final List<RegistroDiaria> registros;

  /// Registro de diária desta faxina (se houver).
  RegistroDiaria? registroDe(FaxinaDoDia faxina) {
    final dia = soDia(faxina.data);
    for (final r in registros) {
      if (r.clienteId == faxina.clienteId && mesmoDia(soDia(r.data), dia)) {
        return r;
      }
    }
    return null;
  }

  /// Faxinas de [de] até [ate], já calculadas a partir das regras.
  Map<DateTime, List<FaxinaDoDia>> faxinasEntre(DateTime de, DateTime ate) {
    final agenda = calcularAgenda(
      regras: regras,
      excecoes: excecoes,
      avulsos: avulsos,
      de: de,
      ate: ate,
    );
    for (final lista in agenda.values) {
      lista
        ..removeWhere((f) => !clientes.containsKey(f.clienteId))
        ..sort(
          (x, y) => clientes[x.clienteId]!.nome.toLowerCase().compareTo(
            clientes[y.clienteId]!.nome.toLowerCase(),
          ),
        );
    }
    agenda.removeWhere((_, lista) => lista.isEmpty);
    return agenda;
  }

  /// Valor da faxina: o gravado no registro de diária, na avulsa ou a diária atual.
  int valorDe(FaxinaDoDia faxina) {
    final reg = registroDe(faxina);
    if (reg != null) return reg.valorRecebidoCentavos;
    final avulsoId = faxina.avulsoId;
    if (avulsoId != null) {
      return avulsos.firstWhere((a) => a.id == avulsoId).valorCentavos;
    }
    return clientes[faxina.clienteId]!.valorPadraoCentavos;
  }

  List<FaxinaDoDia> faxinasDoDia(DateTime dia) =>
      faxinasEntre(dia, dia)[soDia(dia)] ?? const [];
}

class RepositorioAgenda {
  RepositorioAgenda(this._banco);

  final BancoDados _banco;

  /// Lê tudo de novo sempre que clientes, regras, exceções, faxinas avulsas ou
  /// diárias registradas mudarem.
  Stream<DadosAgenda> observar() {
    return _banco
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _banco.clientes,
            _banco.regrasRecorrencia,
            _banco.excecoes,
            _banco.atendimentosAvulsos,
            _banco.registrosDiaria,
          },
        )
        .watch()
        .asyncMap((_) => carregar());
  }

  Future<DadosAgenda> carregar() {
    return _banco.transaction(() async {
      final clientes = await _banco.select(_banco.clientes).get();
      return DadosAgenda(
        clientes: {for (final c in clientes) c.id: c},
        regras: await _banco.select(_banco.regrasRecorrencia).get(),
        excecoes: await _banco.select(_banco.excecoes).get(),
        avulsos: await _banco.select(_banco.atendimentosAvulsos).get(),
        registros: await _banco.select(_banco.registrosDiaria).get(),
      );
    });
  }

  /// Faxina FIXA. Grava só a regra; as datas são calculadas depois.
  Future<int> criarFaxinaFixa({
    required int clienteId,
    required List<int> diasSemana,
    required int intervaloSemanas,
    required DateTime dataInicio,
  }) {
    if (diasSemana.isEmpty) {
      throw ArgumentError('Escolha pelo menos um dia da semana');
    }
    return _banco
        .into(_banco.regrasRecorrencia)
        .insert(
          RegrasRecorrenciaCompanion.insert(
            clienteId: clienteId,
            diasSemana: diasSemana,
            intervaloSemanas: Value(intervaloSemanas),
            dataInicio: soDia(dataInicio),
          ),
        );
  }

  /// Faxina SÓ DESTA VEZ, com o valor padrão da diária do cliente.
  Future<int> criarFaxinaAvulsa({
    required int clienteId,
    required DateTime data,
  }) async {
    final cliente = await (_banco.select(
      _banco.clientes,
    )..where((c) => c.id.equals(clienteId))).getSingle();
    return _banco
        .into(_banco.atendimentosAvulsos)
        .insert(
          AtendimentosAvulsosCompanion.insert(
            clienteId: clienteId,
            data: soDia(data),
            valorCentavos: cliente.valorPadraoCentavos,
          ),
        );
  }

  /// Usado pelo "Desfazer" logo depois de criar uma faxina fixa.
  Future<void> excluirRegra(int id) => (_banco.delete(
    _banco.regrasRecorrencia,
  )..where((r) => r.id.equals(id))).go();

  /// Usado pelo "Desfazer" logo depois de criar uma faxina só desta vez.
  Future<void> excluirAvulso(int id) => (_banco.delete(
    _banco.atendimentosAvulsos,
  )..where((a) => a.id.equals(id))).go();

  /// Mover uma faxina para [novaData].
  /// Para faxina fixa, grava uma exceção para a data original sem mexer nas
  /// semanas seguintes. Para faxina avulsa, altera a data do registro avulso.
  Future<int> moverFaxina({
    required FaxinaDoDia faxina,
    required DateTime novaData,
  }) async {
    final destino = soDia(novaData);
    if (faxina.tipo == TipoFaxina.avulsa) {
      final avulsoId = faxina.avulsoId;
      if (avulsoId != null) {
        await (_banco.update(_banco.atendimentosAvulsos)
              ..where((a) => a.id.equals(avulsoId)))
            .write(AtendimentosAvulsosCompanion(data: Value(destino)));
      }
      return 0;
    }

    final regra = faxina.regra;
    if (regra == null) return 0;
    final original = soDia(faxina.dataOriginal ?? faxina.data);

    return _banco.into(_banco.excecoes).insertOnConflictUpdate(
          ExcecoesCompanion.insert(
            regraId: regra.id,
            dataOriginal: original,
            novaData: Value(destino),
          ),
        );
  }

  /// Cancela só esta data da faxina.
  /// Para faxina fixa, cria uma exceção com [novaData] nula.
  /// Para faxina avulsa, exclui o registro avulso.
  Future<void> cancelarFaxina(FaxinaDoDia faxina) async {
    if (faxina.tipo == TipoFaxina.avulsa) {
      final avulsoId = faxina.avulsoId;
      if (avulsoId != null) {
        await excluirAvulso(avulsoId);
      }
      return;
    }

    final regra = faxina.regra;
    if (regra == null) return;
    final original = soDia(faxina.dataOriginal ?? faxina.data);

    await _banco.into(_banco.excecoes).insertOnConflictUpdate(
          ExcecoesCompanion.insert(
            regraId: regra.id,
            dataOriginal: original,
            novaData: const Value(null),
          ),
        );
  }

  /// Encerra uma regra de faxina fixa a partir de [dataFim].
  Future<void> encerrarRegraFixa({
    required int regraId,
    required DateTime dataFim,
  }) async {
    await (_banco.update(_banco.regrasRecorrencia)
          ..where((r) => r.id.equals(regraId)))
        .write(RegrasRecorrenciaCompanion(dataFim: Value(soDia(dataFim))));
  }

  /// Desfaz a exceção de mover ou cancelar uma data de uma regra fixa.
  Future<void> removerExcecao({
    required int regraId,
    required DateTime dataOriginal,
  }) async {
    await (_banco.delete(_banco.excecoes)
          ..where(
            (e) =>
                e.regraId.equals(regraId) &
                e.dataOriginal.equals(soDia(dataOriginal)),
          ))
        .go();
  }

  /// Salva ou atualiza a diária recebida por uma faxina num dia.
  Future<void> salvarRegistroDiaria({
    required int clienteId,
    required DateTime data,
    required int valorRecebidoCentavos,
  }) async {
    final dia = soDia(data);
    final existentes = await (_banco.select(_banco.registrosDiaria)
          ..where((r) => r.clienteId.equals(clienteId) & r.data.equals(dia)))
        .get();

    if (existentes.isNotEmpty) {
      await (_banco.update(_banco.registrosDiaria)
            ..where((r) => r.id.equals(existentes.first.id)))
          .write(
        RegistrosDiariaCompanion(
          valorRecebidoCentavos: Value(valorRecebidoCentavos),
        ),
      );
    } else {
      await _banco.into(_banco.registrosDiaria).insert(
            RegistrosDiariaCompanion.insert(
              clienteId: clienteId,
              data: dia,
              valorRecebidoCentavos: valorRecebidoCentavos,
            ),
          );
    }
  }

  /// Exclui um registro de diária recebida.
  Future<void> excluirRegistroDiaria(int id) =>
      (_banco.delete(_banco.registrosDiaria)..where((r) => r.id.equals(id)))
          .go();
}
