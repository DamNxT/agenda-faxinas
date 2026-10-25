import 'package:agenda_faxinas/util/dinheiro.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  group('converterParaCentavos', () {
    final casos = {
      '150': 15000,
      '150,00': 15000,
      '150,5': 15050,
      '150,55': 15055,
      ' 150 ': 15000,
      'R\$ 150,00': 15000,
      '1.500,00': 150000,
      '1.500': 150000,
      '150.50': 15050,
      '0': 0,
    };
    casos.forEach((texto, esperado) {
      test('"$texto" -> $esperado', () {
        expect(converterParaCentavos(texto), esperado);
      });
    });

    for (final invalido in ['', 'abc', '150,555', '-10', '1,2,3', '15a']) {
      test('"$invalido" é inválido', () {
        expect(converterParaCentavos(invalido), isNull);
      });
    }
  });

  test('formatarReais', () {
    expect(formatarReais(15000).replaceAll('\u00A0', ' '), 'R\$ 150,00');
    expect(formatarReais(150050).replaceAll('\u00A0', ' '), 'R\$ 1.500,50');
  });

  test('formatarValorParaCampo', () {
    expect(formatarValorParaCampo(15050), '150,50');
    expect(converterParaCentavos(formatarValorParaCampo(150050)), 150050);
  });
}
