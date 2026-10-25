import 'package:drift/drift.dart';

/// Guarda a lista de dias da semana como texto. Ex.: [1, 4] <-> "1,4".
class DiasSemanaConversor extends TypeConverter<List<int>, String> {
  const DiasSemanaConversor();

  @override
  List<int> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return fromDb.split(',').map(int.parse).toList();
  }

  @override
  String toSql(List<int> value) {
    final dias = value.toSet().toList()..sort();
    if (dias.any((d) => d < DateTime.monday || d > DateTime.sunday)) {
      throw ArgumentError('Dia da semana inválido: $value');
    }
    return dias.join(',');
  }
}
