import '../../util/datas.dart';
import '../banco/banco_dados.dart';

/// Cálculo da agenda. As datas das faxinas fixas NÃO ficam gravadas no banco:
/// elas são calculadas aqui a partir das regras de recorrência, aplicando as
/// exceções por cima e somando as faxinas avulsas.

enum TipoFaxina { fixa, avulsa }

/// Uma faxina num dia da agenda.
class FaxinaDoDia {
  const FaxinaDoDia({
    required this.data,
    required this.clienteId,
    required this.tipo,
    this.regra,
    this.avulsoId,
    this.dataOriginal,
  });

  final DateTime data;
  final int clienteId;
  final TipoFaxina tipo;

  /// Regra de onde veio (só para faxina fixa).
  final RegraRecorrencia? regra;

  /// Id do atendimento avulso (só para faxina avulsa).
  final int? avulsoId;

  /// Se a faxina fixa foi movida por uma exceção, o dia em que ela seria.
  final DateTime? dataOriginal;
}

/// Diz se a regra cai no [dia].
///
/// A conta do "a cada 15 dias" é feita por semanas: conta-se quantas semanas
/// existem entre a semana da data de início e a semana do dia. Se o número for
/// múltiplo do intervalo (2 = a cada 15 dias), a faxina acontece.
bool regraOcorreEm(RegraRecorrencia regra, DateTime dia) {
  final d = soDia(dia);
  final inicio = soDia(regra.dataInicio);
  if (d.isBefore(inicio)) return false;
  final fim = regra.dataFim;
  if (fim != null && d.isAfter(soDia(fim))) return false;
  if (!regra.diasSemana.contains(d.weekday)) return false;

  final semanas = diasEntre(segundaDaSemana(inicio), segundaDaSemana(d)) ~/ 7;
  return semanas % regra.intervaloSemanas == 0;
}

/// Datas em que a regra cai, de [de] até [ate] (os dois inclusive), sem
/// aplicar exceções.
List<DateTime> datasDaRegra(RegraRecorrencia regra, DateTime de, DateTime ate) {
  final datas = <DateTime>[];
  final ultimo = soDia(ate);
  for (var dia = soDia(de); !dia.isAfter(ultimo); dia = somarDias(dia, 1)) {
    if (regraOcorreEm(regra, dia)) datas.add(dia);
  }
  return datas;
}

/// Monta a agenda de [de] até [ate] (inclusive). A chave do mapa é o dia
/// (meia-noite); dias sem faxina não aparecem no mapa.
Map<DateTime, List<FaxinaDoDia>> calcularAgenda({
  required List<RegraRecorrencia> regras,
  required List<Excecao> excecoes,
  required List<AtendimentoAvulso> avulsos,
  required DateTime de,
  required DateTime ate,
}) {
  final inicio = soDia(de);
  final fim = soDia(ate);
  bool noPeriodo(DateTime d) => !d.isBefore(inicio) && !d.isAfter(fim);

  final agenda = <DateTime, List<FaxinaDoDia>>{};
  void adicionar(FaxinaDoDia faxina) =>
      agenda.putIfAbsent(faxina.data, () => []).add(faxina);

  for (final regra in regras) {
    final excecoesDaRegra = {
      for (final e in excecoes.where((e) => e.regraId == regra.id))
        soDia(e.dataOriginal): e,
    };

    for (final dia in datasDaRegra(regra, inicio, fim)) {
      // Data movida ou cancelada: não aparece no dia original.
      if (excecoesDaRegra.containsKey(dia)) continue;
      adicionar(
        FaxinaDoDia(
          data: dia,
          clienteId: regra.clienteId,
          tipo: TipoFaxina.fixa,
          regra: regra,
        ),
      );
    }

    for (final excecao in excecoesDaRegra.values) {
      final novaData = excecao.novaData;
      if (novaData == null) continue;
      final original = soDia(excecao.dataOriginal);
      final destino = soDia(novaData);
      if (!noPeriodo(destino) || !regraOcorreEm(regra, original)) continue;
      adicionar(
        FaxinaDoDia(
          data: destino,
          clienteId: regra.clienteId,
          tipo: TipoFaxina.fixa,
          regra: regra,
          dataOriginal: original,
        ),
      );
    }
  }

  for (final avulso in avulsos) {
    final dia = soDia(avulso.data);
    if (!noPeriodo(dia)) continue;
    adicionar(
      FaxinaDoDia(
        data: dia,
        clienteId: avulso.clienteId,
        tipo: TipoFaxina.avulsa,
        avulsoId: avulso.id,
      ),
    );
  }

  return agenda;
}
