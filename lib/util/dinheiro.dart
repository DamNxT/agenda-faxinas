import 'package:intl/intl.dart';

final _formatoReais = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
final _formatoSemSimbolo = NumberFormat.currency(locale: 'pt_BR', symbol: '');

/// 15000 -> "R$ 150,00"
String formatarReais(int centavos) => _formatoReais.format(centavos / 100);

/// 15000 -> "150,00" (para preencher campos de texto).
String formatarValorParaCampo(int centavos) =>
    _formatoSemSimbolo.format(centavos / 100).trim();

/// Converte o texto digitado em centavos. Aceita "150", "150,50",
/// "1.500,00", "R$ 150,00" e "150.50". Retorna null se o texto for inválido.
int? converterParaCentavos(String texto) {
  var limpo = texto.replaceAll('R\$', '').replaceAll(RegExp(r'\s'), '');
  if (limpo.isEmpty) return null;

  if (limpo.contains(',')) {
    // Padrão brasileiro: ponto separa milhar, vírgula separa centavos.
    limpo = limpo.replaceAll('.', '').replaceAll(',', '.');
  } else if (!RegExp(r'^\d+\.\d{1,2}$').hasMatch(limpo)) {
    // "1.500" = mil e quinhentos; "150.5" (acima) = cento e cinquenta e meio.
    limpo = limpo.replaceAll('.', '');
  }

  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(limpo)) return null;
  final partes = limpo.split('.');
  final reais = int.parse(partes[0]);
  final centavos = partes.length > 1
      ? int.parse(partes[1].padRight(2, '0'))
      : 0;
  return reais * 100 + centavos;
}
