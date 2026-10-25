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
  });

  final Map<int, Cliente> clientes;
  final List<RegraRecorrencia> regras;
  final List<Excecao> excecoes;
  final List<AtendimentoAvulso> avulsos;

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

  /// Valor da faxina: o gravado na avulsa ou a diária atual do cliente.
  int valorDe(FaxinaDoDia faxina) {
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

  /// Lê tudo de novo sempre que clientes, regras, exceções ou faxinas
  /// avulsas mudarem.
  Stream<DadosAgenda> observar() {
    return _banco
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _banco.clientes,
            _banco.regrasRecorrencia,
            _banco.excecoes,
            _banco.atendimentosAvulsos,
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
}
