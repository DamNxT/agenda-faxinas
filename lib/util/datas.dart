import 'package:intl/intl.dart';

/// Funções de datas. Na agenda só o DIA importa, então as datas são sempre
/// usadas à meia-noite (horário local).

DateTime soDia(DateTime data) => DateTime(data.year, data.month, data.day);

/// Soma dias sem erro de horário de verão (o Dart ajusta o dia sozinho).
DateTime somarDias(DateTime data, int dias) =>
    DateTime(data.year, data.month, data.day + dias);

/// Quantos dias existem de [de] até [ate] (negativo se [ate] vier antes).
int diasEntre(DateTime de, DateTime ate) => DateTime.utc(
  ate.year,
  ate.month,
  ate.day,
).difference(DateTime.utc(de.year, de.month, de.day)).inDays;

/// Segunda-feira da semana de [data].
DateTime segundaDaSemana(DateTime data) =>
    somarDias(data, -(data.weekday - DateTime.monday));

bool mesmoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// 1 = segunda ... 7 = domingo (padrão do Dart).
const nomesDiasSemana = {
  DateTime.monday: 'Segunda',
  DateTime.tuesday: 'Terça',
  DateTime.wednesday: 'Quarta',
  DateTime.thursday: 'Quinta',
  DateTime.friday: 'Sexta',
  DateTime.saturday: 'Sábado',
  DateTime.sunday: 'Domingo',
};

const abreviaturasDiasSemana = {
  DateTime.monday: 'Seg',
  DateTime.tuesday: 'Ter',
  DateTime.wednesday: 'Qua',
  DateTime.thursday: 'Qui',
  DateTime.friday: 'Sex',
  DateTime.saturday: 'Sáb',
  DateTime.sunday: 'Dom',
};

String _maiuscula(String texto) =>
    texto.isEmpty ? texto : texto[0].toUpperCase() + texto.substring(1);

/// Ex.: "Sábado, 24 de outubro".
String formatarDiaCompleto(DateTime data) =>
    _maiuscula(DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(data));

/// Ex.: "Segunda, 26/10/2026".
/// Ex.: "Sábado, 24 de outubro de 2026".
String formatarDataPorExtenso(DateTime data) =>
    _maiuscula(DateFormat("EEEE, d 'de' MMMM 'de' y", 'pt_BR').format(data));

String formatarDiaCurto(DateTime data) =>
    '${nomesDiasSemana[data.weekday]}, ${DateFormat('dd/MM/yyyy').format(data)}';

/// Ex.: "Outubro de 2026".
String formatarMesAno(DateTime data) =>
    _maiuscula(DateFormat("MMMM 'de' y", 'pt_BR').format(data));

/// Ex.: "19 a 25 de outubro" ou "26 de outubro a 1 de novembro".
String formatarSemana(DateTime segunda) {
  final domingo = somarDias(segunda, 6);
  final mes = DateFormat('MMMM', 'pt_BR');
  if (segunda.month == domingo.month) {
    return '${segunda.day} a ${domingo.day} de ${mes.format(domingo)}';
  }
  return '${segunda.day} de ${mes.format(segunda)} '
      'a ${domingo.day} de ${mes.format(domingo)}';
}
