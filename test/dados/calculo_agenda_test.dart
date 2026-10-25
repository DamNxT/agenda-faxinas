import 'package:agenda_faxinas/dados/agenda/calculo_agenda.dart';
import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/util/datas.dart';
import 'package:flutter_test/flutter_test.dart';

RegraRecorrencia regra({
  int id = 1,
  int clienteId = 1,
  required List<int> dias,
  int intervalo = 1,
  required DateTime inicio,
  DateTime? fim,
}) => RegraRecorrencia(
  id: id,
  clienteId: clienteId,
  diasSemana: dias,
  intervaloSemanas: intervalo,
  dataInicio: inicio,
  dataFim: fim,
);

DateTime d(int ano, int mes, int dia) => DateTime(ano, mes, dia);

void main() {
  group('Cliente A: segunda e quinta, toda semana', () {
    final a = regra(
      dias: [DateTime.monday, DateTime.thursday],
      inicio: d(2026, 10, 5), // segunda
    );

    test('aparece em todas as segundas e quintas', () {
      expect(datasDaRegra(a, d(2026, 10, 1), d(2026, 10, 31)), [
        d(2026, 10, 5),
        d(2026, 10, 8),
        d(2026, 10, 12),
        d(2026, 10, 15),
        d(2026, 10, 19),
        d(2026, 10, 22),
        d(2026, 10, 26),
        d(2026, 10, 29),
      ]);
    });

    test('todas as datas são segunda ou quinta', () {
      final datas = datasDaRegra(a, d(2026, 10, 5), d(2027, 10, 5));
      expect(
        datas.every(
          (x) => x.weekday == DateTime.monday || x.weekday == DateTime.thursday,
        ),
        isTrue,
      );
      // 2 faxinas por semana, 52 semanas, mais a segunda 05/10/2027.
      expect(datas.length, 105);
    });

    test('continua na virada de mês e de ano', () {
      expect(datasDaRegra(a, d(2026, 12, 28), d(2027, 1, 8)), [
        d(2026, 12, 28),
        d(2026, 12, 31),
        d(2027, 1, 4),
        d(2027, 1, 7),
      ]);
    });

    test('não aparece antes da data de início', () {
      expect(regraOcorreEm(a, d(2026, 10, 1)), isFalse); // quinta antes
      expect(regraOcorreEm(a, d(2026, 9, 28)), isFalse); // segunda antes
    });
  });

  group('Cliente B: terça, toda semana', () {
    final b = regra(dias: [DateTime.tuesday], inicio: d(2026, 10, 6));

    test('aparece em todas as terças', () {
      expect(datasDaRegra(b, d(2026, 10, 1), d(2026, 11, 10)), [
        d(2026, 10, 6),
        d(2026, 10, 13),
        d(2026, 10, 20),
        d(2026, 10, 27),
        d(2026, 11, 3),
        d(2026, 11, 10),
      ]);
    });

    test('não aparece nos outros dias', () {
      for (var dia = 7; dia <= 12; dia++) {
        expect(regraOcorreEm(b, d(2026, 10, dia)), isFalse);
      }
    });

    test('começo numa quinta: a primeira terça é a da semana seguinte', () {
      final b2 = regra(dias: [DateTime.tuesday], inicio: d(2026, 10, 8));
      expect(datasDaRegra(b2, d(2026, 10, 1), d(2026, 10, 20)), [
        d(2026, 10, 13),
        d(2026, 10, 20),
      ]);
    });
  });

  group('Clientes C e D: quarta, a cada 15 dias', () {
    final c = regra(
      dias: [DateTime.wednesday],
      intervalo: 2,
      inicio: d(2026, 10, 7), // quarta
    );

    test('pula uma semana sim e outra não', () {
      expect(datasDaRegra(c, d(2026, 10, 1), d(2026, 10, 31)), [
        d(2026, 10, 7),
        d(2026, 10, 21),
      ]);
      expect(regraOcorreEm(c, d(2026, 10, 14)), isFalse);
      expect(regraOcorreEm(c, d(2026, 10, 28)), isFalse);
    });

    test('na virada de mês (outubro -> novembro -> dezembro)', () {
      expect(datasDaRegra(c, d(2026, 10, 1), d(2026, 12, 31)), [
        d(2026, 10, 7),
        d(2026, 10, 21),
        d(2026, 11, 4),
        d(2026, 11, 18),
        d(2026, 12, 2),
        d(2026, 12, 16),
        d(2026, 12, 30),
      ]);
    });

    test('na virada de ano (2026 -> 2027)', () {
      expect(datasDaRegra(c, d(2026, 12, 1), d(2027, 2, 28)), [
        d(2026, 12, 2),
        d(2026, 12, 16),
        d(2026, 12, 30),
        d(2027, 1, 13),
        d(2027, 1, 27),
        d(2027, 2, 10),
        d(2027, 2, 24),
      ]);
      // Semanas "de folga" na virada:
      expect(regraOcorreEm(c, d(2026, 12, 23)), isFalse);
      expect(regraOcorreEm(c, d(2027, 1, 6)), isFalse);
      expect(regraOcorreEm(c, d(2027, 1, 20)), isFalse);
    });

    test('a distância entre as faxinas é sempre de 14 dias, por 2 anos', () {
      final datas = datasDaRegra(c, d(2026, 10, 1), d(2028, 10, 1));
      for (var i = 1; i < datas.length; i++) {
        expect(
          diasEntre(datas[i - 1], datas[i]),
          14,
          reason: 'entre ${datas[i - 1]} e ${datas[i]}',
        );
      }
      // 07/10/2026 + 51 x 14 dias = 20/09/2028 (a próxima seria 04/10/2028).
      expect(datas.length, 52);
      expect(datas.last, d(2028, 9, 20));
    });

    test('C e D na mesma quarta, mas D começando uma semana depois', () {
      final dRegra = regra(
        id: 2,
        clienteId: 2,
        dias: [DateTime.wednesday],
        intervalo: 2,
        inicio: d(2026, 10, 14),
      );
      expect(datasDaRegra(dRegra, d(2026, 10, 1), d(2026, 11, 30)), [
        d(2026, 10, 14),
        d(2026, 10, 28),
        d(2026, 11, 11),
        d(2026, 11, 25),
      ]);
    });

    test('início numa segunda: a semana do início conta como a 1ª', () {
      final c2 = regra(
        dias: [DateTime.wednesday],
        intervalo: 2,
        inicio: d(2026, 10, 5), // segunda
      );
      expect(datasDaRegra(c2, d(2026, 10, 1), d(2026, 10, 31)), [
        d(2026, 10, 7),
        d(2026, 10, 21),
      ]);
    });
  });

  test('data de fim encerra a regra', () {
    final r = regra(
      dias: [DateTime.tuesday],
      inicio: d(2026, 10, 6),
      fim: d(2026, 10, 20),
    );
    expect(datasDaRegra(r, d(2026, 10, 1), d(2026, 11, 30)), [
      d(2026, 10, 6),
      d(2026, 10, 13),
      d(2026, 10, 20),
    ]);
  });

  group('calcularAgenda', () {
    final a = regra(
      id: 1,
      clienteId: 1,
      dias: [DateTime.monday, DateTime.thursday],
      inicio: d(2026, 10, 5),
    );
    final c = regra(
      id: 2,
      clienteId: 3,
      dias: [DateTime.wednesday],
      intervalo: 2,
      inicio: d(2026, 10, 7),
    );

    test('junta faxinas fixas e avulsas no mesmo dia', () {
      final agenda = calcularAgenda(
        regras: [a, c],
        excecoes: const [],
        avulsos: [
          AtendimentoAvulso(
            id: 9,
            clienteId: 5,
            data: d(2026, 10, 7),
            valorCentavos: 10000,
          ),
        ],
        de: d(2026, 10, 5),
        ate: d(2026, 10, 11),
      );
      expect(agenda.keys.toList()..sort(), [
        d(2026, 10, 5),
        d(2026, 10, 7),
        d(2026, 10, 8),
      ]);
      expect(agenda[d(2026, 10, 7)]!.map((f) => f.clienteId), [3, 5]);
      expect(agenda[d(2026, 10, 7)]!.last.tipo, TipoFaxina.avulsa);
      expect(agenda[d(2026, 10, 5)]!.single.tipo, TipoFaxina.fixa);
    });

    test('exceção cancela ou move só aquela data', () {
      final agenda = calcularAgenda(
        regras: [a],
        excecoes: [
          // Segunda 12/10 cancelada.
          Excecao(id: 1, regraId: 1, dataOriginal: d(2026, 10, 12)),
          // Quinta 15/10 movida para sexta 16/10.
          Excecao(
            id: 2,
            regraId: 1,
            dataOriginal: d(2026, 10, 15),
            novaData: d(2026, 10, 16),
          ),
        ],
        avulsos: const [],
        de: d(2026, 10, 12),
        ate: d(2026, 10, 25),
      );
      expect(agenda.keys.toList()..sort(), [
        d(2026, 10, 16),
        d(2026, 10, 19),
        d(2026, 10, 22),
      ]);
      expect(agenda[d(2026, 10, 16)]!.single.dataOriginal, d(2026, 10, 15));
    });

    test('mover faxina de segunda dia 10 para terça dia 11 deixa a segunda dia 17 normal', () {
      final regraSegunda = regra(
        id: 1,
        clienteId: 1,
        dias: [DateTime.monday],
        inicio: d(2026, 8, 3), // segunda
      );
      final agenda = calcularAgenda(
        regras: [regraSegunda],
        excecoes: [
          // Mover segunda 10/08 para terça 11/08
          Excecao(
            id: 1,
            regraId: 1,
            dataOriginal: d(2026, 8, 10),
            novaData: d(2026, 8, 11),
          ),
        ],
        avulsos: const [],
        de: d(2026, 8, 10),
        ate: d(2026, 8, 23),
      );

      // Segunda 10/08 foi movida (não aparece no dia 10)
      expect(agenda[d(2026, 8, 10)], isNull);

      // Terça 11/08 tem a faxina movida de segunda
      expect(agenda[d(2026, 8, 11)], isNotNull);
      expect(agenda[d(2026, 8, 11)]!.single.dataOriginal, d(2026, 8, 10));

      // Segunda 17/08 continua normal (sem ser afetada)
      expect(agenda[d(2026, 8, 17)], isNotNull);
      expect(agenda[d(2026, 8, 17)]!.single.dataOriginal, isNull);

      // Terça 18/08 não tem faxina
      expect(agenda[d(2026, 8, 18)], isNull);
    });
  });
}
