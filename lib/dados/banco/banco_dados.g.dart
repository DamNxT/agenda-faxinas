// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banco_dados.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enderecoMeta = const VerificationMeta(
    'endereco',
  );
  @override
  late final GeneratedColumn<String> endereco = GeneratedColumn<String>(
    'endereco',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valorPadraoCentavosMeta =
      const VerificationMeta('valorPadraoCentavos');
  @override
  late final GeneratedColumn<int> valorPadraoCentavos = GeneratedColumn<int>(
    'valor_padrao_centavos',
    aliasedName,
    false,
    check: () => ComparableExpr(valorPadraoCentavos).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    endereco,
    valorPadraoCentavos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('endereco')) {
      context.handle(
        _enderecoMeta,
        endereco.isAcceptableOrUnknown(data['endereco']!, _enderecoMeta),
      );
    }
    if (data.containsKey('valor_padrao_centavos')) {
      context.handle(
        _valorPadraoCentavosMeta,
        valorPadraoCentavos.isAcceptableOrUnknown(
          data['valor_padrao_centavos']!,
          _valorPadraoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorPadraoCentavosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      endereco: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endereco'],
      ),
      valorPadraoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_padrao_centavos'],
      )!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final int id;
  final String nome;
  final String? endereco;
  final int valorPadraoCentavos;
  const Cliente({
    required this.id,
    required this.nome,
    this.endereco,
    required this.valorPadraoCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || endereco != null) {
      map['endereco'] = Variable<String>(endereco);
    }
    map['valor_padrao_centavos'] = Variable<int>(valorPadraoCentavos);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nome: Value(nome),
      endereco: endereco == null && nullToAbsent
          ? const Value.absent()
          : Value(endereco),
      valorPadraoCentavos: Value(valorPadraoCentavos),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      endereco: serializer.fromJson<String?>(json['endereco']),
      valorPadraoCentavos: serializer.fromJson<int>(
        json['valorPadraoCentavos'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'endereco': serializer.toJson<String?>(endereco),
      'valorPadraoCentavos': serializer.toJson<int>(valorPadraoCentavos),
    };
  }

  Cliente copyWith({
    int? id,
    String? nome,
    Value<String?> endereco = const Value.absent(),
    int? valorPadraoCentavos,
  }) => Cliente(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    endereco: endereco.present ? endereco.value : this.endereco,
    valorPadraoCentavos: valorPadraoCentavos ?? this.valorPadraoCentavos,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      endereco: data.endereco.present ? data.endereco.value : this.endereco,
      valorPadraoCentavos: data.valorPadraoCentavos.present
          ? data.valorPadraoCentavos.value
          : this.valorPadraoCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('endereco: $endereco, ')
          ..write('valorPadraoCentavos: $valorPadraoCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, endereco, valorPadraoCentavos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.endereco == this.endereco &&
          other.valorPadraoCentavos == this.valorPadraoCentavos);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String?> endereco;
  final Value<int> valorPadraoCentavos;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.endereco = const Value.absent(),
    this.valorPadraoCentavos = const Value.absent(),
  });
  ClientesCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.endereco = const Value.absent(),
    required int valorPadraoCentavos,
  }) : nome = Value(nome),
       valorPadraoCentavos = Value(valorPadraoCentavos);
  static Insertable<Cliente> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? endereco,
    Expression<int>? valorPadraoCentavos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (endereco != null) 'endereco': endereco,
      if (valorPadraoCentavos != null)
        'valor_padrao_centavos': valorPadraoCentavos,
    });
  }

  ClientesCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String?>? endereco,
    Value<int>? valorPadraoCentavos,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      endereco: endereco ?? this.endereco,
      valorPadraoCentavos: valorPadraoCentavos ?? this.valorPadraoCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (endereco.present) {
      map['endereco'] = Variable<String>(endereco.value);
    }
    if (valorPadraoCentavos.present) {
      map['valor_padrao_centavos'] = Variable<int>(valorPadraoCentavos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('endereco: $endereco, ')
          ..write('valorPadraoCentavos: $valorPadraoCentavos')
          ..write(')'))
        .toString();
  }
}

class $RegrasRecorrenciaTable extends RegrasRecorrencia
    with TableInfo<$RegrasRecorrenciaTable, RegraRecorrencia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegrasRecorrenciaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> diasSemana =
      GeneratedColumn<String>(
        'dias_semana',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<int>>($RegrasRecorrenciaTable.$converterdiasSemana);
  static const VerificationMeta _intervaloSemanasMeta = const VerificationMeta(
    'intervaloSemanas',
  );
  @override
  late final GeneratedColumn<int> intervaloSemanas = GeneratedColumn<int>(
    'intervalo_semanas',
    aliasedName,
    false,
    check: () => ComparableExpr(intervaloSemanas).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dataInicioMeta = const VerificationMeta(
    'dataInicio',
  );
  @override
  late final GeneratedColumn<DateTime> dataInicio = GeneratedColumn<DateTime>(
    'data_inicio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataFimMeta = const VerificationMeta(
    'dataFim',
  );
  @override
  late final GeneratedColumn<DateTime> dataFim = GeneratedColumn<DateTime>(
    'data_fim',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    diasSemana,
    intervaloSemanas,
    dataInicio,
    dataFim,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'regras_recorrencia';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegraRecorrencia> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('intervalo_semanas')) {
      context.handle(
        _intervaloSemanasMeta,
        intervaloSemanas.isAcceptableOrUnknown(
          data['intervalo_semanas']!,
          _intervaloSemanasMeta,
        ),
      );
    }
    if (data.containsKey('data_inicio')) {
      context.handle(
        _dataInicioMeta,
        dataInicio.isAcceptableOrUnknown(data['data_inicio']!, _dataInicioMeta),
      );
    } else if (isInserting) {
      context.missing(_dataInicioMeta);
    }
    if (data.containsKey('data_fim')) {
      context.handle(
        _dataFimMeta,
        dataFim.isAcceptableOrUnknown(data['data_fim']!, _dataFimMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegraRecorrencia map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegraRecorrencia(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      diasSemana: $RegrasRecorrenciaTable.$converterdiasSemana.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}dias_semana'],
        )!,
      ),
      intervaloSemanas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intervalo_semanas'],
      )!,
      dataInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_inicio'],
      )!,
      dataFim: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_fim'],
      ),
    );
  }

  @override
  $RegrasRecorrenciaTable createAlias(String alias) {
    return $RegrasRecorrenciaTable(attachedDatabase, alias);
  }

  static TypeConverter<List<int>, String> $converterdiasSemana =
      const DiasSemanaConversor();
}

class RegraRecorrencia extends DataClass
    implements Insertable<RegraRecorrencia> {
  final int id;
  final int clienteId;

  /// Dias da semana: 1 = segunda ... 7 = domingo (padrão do Dart).
  final List<int> diasSemana;

  /// 1 = toda semana, 2 = a cada 15 dias, e assim por diante.
  final int intervaloSemanas;
  final DateTime dataInicio;
  final DateTime? dataFim;
  const RegraRecorrencia({
    required this.id,
    required this.clienteId,
    required this.diasSemana,
    required this.intervaloSemanas,
    required this.dataInicio,
    this.dataFim,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    {
      map['dias_semana'] = Variable<String>(
        $RegrasRecorrenciaTable.$converterdiasSemana.toSql(diasSemana),
      );
    }
    map['intervalo_semanas'] = Variable<int>(intervaloSemanas);
    map['data_inicio'] = Variable<DateTime>(dataInicio);
    if (!nullToAbsent || dataFim != null) {
      map['data_fim'] = Variable<DateTime>(dataFim);
    }
    return map;
  }

  RegrasRecorrenciaCompanion toCompanion(bool nullToAbsent) {
    return RegrasRecorrenciaCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      diasSemana: Value(diasSemana),
      intervaloSemanas: Value(intervaloSemanas),
      dataInicio: Value(dataInicio),
      dataFim: dataFim == null && nullToAbsent
          ? const Value.absent()
          : Value(dataFim),
    );
  }

  factory RegraRecorrencia.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegraRecorrencia(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      diasSemana: serializer.fromJson<List<int>>(json['diasSemana']),
      intervaloSemanas: serializer.fromJson<int>(json['intervaloSemanas']),
      dataInicio: serializer.fromJson<DateTime>(json['dataInicio']),
      dataFim: serializer.fromJson<DateTime?>(json['dataFim']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clienteId': serializer.toJson<int>(clienteId),
      'diasSemana': serializer.toJson<List<int>>(diasSemana),
      'intervaloSemanas': serializer.toJson<int>(intervaloSemanas),
      'dataInicio': serializer.toJson<DateTime>(dataInicio),
      'dataFim': serializer.toJson<DateTime?>(dataFim),
    };
  }

  RegraRecorrencia copyWith({
    int? id,
    int? clienteId,
    List<int>? diasSemana,
    int? intervaloSemanas,
    DateTime? dataInicio,
    Value<DateTime?> dataFim = const Value.absent(),
  }) => RegraRecorrencia(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    diasSemana: diasSemana ?? this.diasSemana,
    intervaloSemanas: intervaloSemanas ?? this.intervaloSemanas,
    dataInicio: dataInicio ?? this.dataInicio,
    dataFim: dataFim.present ? dataFim.value : this.dataFim,
  );
  RegraRecorrencia copyWithCompanion(RegrasRecorrenciaCompanion data) {
    return RegraRecorrencia(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      diasSemana: data.diasSemana.present
          ? data.diasSemana.value
          : this.diasSemana,
      intervaloSemanas: data.intervaloSemanas.present
          ? data.intervaloSemanas.value
          : this.intervaloSemanas,
      dataInicio: data.dataInicio.present
          ? data.dataInicio.value
          : this.dataInicio,
      dataFim: data.dataFim.present ? data.dataFim.value : this.dataFim,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegraRecorrencia(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('diasSemana: $diasSemana, ')
          ..write('intervaloSemanas: $intervaloSemanas, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clienteId,
    diasSemana,
    intervaloSemanas,
    dataInicio,
    dataFim,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegraRecorrencia &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.diasSemana == this.diasSemana &&
          other.intervaloSemanas == this.intervaloSemanas &&
          other.dataInicio == this.dataInicio &&
          other.dataFim == this.dataFim);
}

class RegrasRecorrenciaCompanion extends UpdateCompanion<RegraRecorrencia> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<List<int>> diasSemana;
  final Value<int> intervaloSemanas;
  final Value<DateTime> dataInicio;
  final Value<DateTime?> dataFim;
  const RegrasRecorrenciaCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.diasSemana = const Value.absent(),
    this.intervaloSemanas = const Value.absent(),
    this.dataInicio = const Value.absent(),
    this.dataFim = const Value.absent(),
  });
  RegrasRecorrenciaCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    required List<int> diasSemana,
    this.intervaloSemanas = const Value.absent(),
    required DateTime dataInicio,
    this.dataFim = const Value.absent(),
  }) : clienteId = Value(clienteId),
       diasSemana = Value(diasSemana),
       dataInicio = Value(dataInicio);
  static Insertable<RegraRecorrencia> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<String>? diasSemana,
    Expression<int>? intervaloSemanas,
    Expression<DateTime>? dataInicio,
    Expression<DateTime>? dataFim,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (diasSemana != null) 'dias_semana': diasSemana,
      if (intervaloSemanas != null) 'intervalo_semanas': intervaloSemanas,
      if (dataInicio != null) 'data_inicio': dataInicio,
      if (dataFim != null) 'data_fim': dataFim,
    });
  }

  RegrasRecorrenciaCompanion copyWith({
    Value<int>? id,
    Value<int>? clienteId,
    Value<List<int>>? diasSemana,
    Value<int>? intervaloSemanas,
    Value<DateTime>? dataInicio,
    Value<DateTime?>? dataFim,
  }) {
    return RegrasRecorrenciaCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      diasSemana: diasSemana ?? this.diasSemana,
      intervaloSemanas: intervaloSemanas ?? this.intervaloSemanas,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (diasSemana.present) {
      map['dias_semana'] = Variable<String>(
        $RegrasRecorrenciaTable.$converterdiasSemana.toSql(diasSemana.value),
      );
    }
    if (intervaloSemanas.present) {
      map['intervalo_semanas'] = Variable<int>(intervaloSemanas.value);
    }
    if (dataInicio.present) {
      map['data_inicio'] = Variable<DateTime>(dataInicio.value);
    }
    if (dataFim.present) {
      map['data_fim'] = Variable<DateTime>(dataFim.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegrasRecorrenciaCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('diasSemana: $diasSemana, ')
          ..write('intervaloSemanas: $intervaloSemanas, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim')
          ..write(')'))
        .toString();
  }
}

class $ExcecoesTable extends Excecoes with TableInfo<$ExcecoesTable, Excecao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExcecoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _regraIdMeta = const VerificationMeta(
    'regraId',
  );
  @override
  late final GeneratedColumn<int> regraId = GeneratedColumn<int>(
    'regra_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES regras_recorrencia (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dataOriginalMeta = const VerificationMeta(
    'dataOriginal',
  );
  @override
  late final GeneratedColumn<DateTime> dataOriginal = GeneratedColumn<DateTime>(
    'data_original',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _novaDataMeta = const VerificationMeta(
    'novaData',
  );
  @override
  late final GeneratedColumn<DateTime> novaData = GeneratedColumn<DateTime>(
    'nova_data',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, regraId, dataOriginal, novaData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'excecoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Excecao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('regra_id')) {
      context.handle(
        _regraIdMeta,
        regraId.isAcceptableOrUnknown(data['regra_id']!, _regraIdMeta),
      );
    } else if (isInserting) {
      context.missing(_regraIdMeta);
    }
    if (data.containsKey('data_original')) {
      context.handle(
        _dataOriginalMeta,
        dataOriginal.isAcceptableOrUnknown(
          data['data_original']!,
          _dataOriginalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataOriginalMeta);
    }
    if (data.containsKey('nova_data')) {
      context.handle(
        _novaDataMeta,
        novaData.isAcceptableOrUnknown(data['nova_data']!, _novaDataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {regraId, dataOriginal},
  ];
  @override
  Excecao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Excecao(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      regraId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}regra_id'],
      )!,
      dataOriginal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_original'],
      )!,
      novaData: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}nova_data'],
      ),
    );
  }

  @override
  $ExcecoesTable createAlias(String alias) {
    return $ExcecoesTable(attachedDatabase, alias);
  }
}

class Excecao extends DataClass implements Insertable<Excecao> {
  final int id;
  final int regraId;
  final DateTime dataOriginal;
  final DateTime? novaData;
  const Excecao({
    required this.id,
    required this.regraId,
    required this.dataOriginal,
    this.novaData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['regra_id'] = Variable<int>(regraId);
    map['data_original'] = Variable<DateTime>(dataOriginal);
    if (!nullToAbsent || novaData != null) {
      map['nova_data'] = Variable<DateTime>(novaData);
    }
    return map;
  }

  ExcecoesCompanion toCompanion(bool nullToAbsent) {
    return ExcecoesCompanion(
      id: Value(id),
      regraId: Value(regraId),
      dataOriginal: Value(dataOriginal),
      novaData: novaData == null && nullToAbsent
          ? const Value.absent()
          : Value(novaData),
    );
  }

  factory Excecao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Excecao(
      id: serializer.fromJson<int>(json['id']),
      regraId: serializer.fromJson<int>(json['regraId']),
      dataOriginal: serializer.fromJson<DateTime>(json['dataOriginal']),
      novaData: serializer.fromJson<DateTime?>(json['novaData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'regraId': serializer.toJson<int>(regraId),
      'dataOriginal': serializer.toJson<DateTime>(dataOriginal),
      'novaData': serializer.toJson<DateTime?>(novaData),
    };
  }

  Excecao copyWith({
    int? id,
    int? regraId,
    DateTime? dataOriginal,
    Value<DateTime?> novaData = const Value.absent(),
  }) => Excecao(
    id: id ?? this.id,
    regraId: regraId ?? this.regraId,
    dataOriginal: dataOriginal ?? this.dataOriginal,
    novaData: novaData.present ? novaData.value : this.novaData,
  );
  Excecao copyWithCompanion(ExcecoesCompanion data) {
    return Excecao(
      id: data.id.present ? data.id.value : this.id,
      regraId: data.regraId.present ? data.regraId.value : this.regraId,
      dataOriginal: data.dataOriginal.present
          ? data.dataOriginal.value
          : this.dataOriginal,
      novaData: data.novaData.present ? data.novaData.value : this.novaData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Excecao(')
          ..write('id: $id, ')
          ..write('regraId: $regraId, ')
          ..write('dataOriginal: $dataOriginal, ')
          ..write('novaData: $novaData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, regraId, dataOriginal, novaData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Excecao &&
          other.id == this.id &&
          other.regraId == this.regraId &&
          other.dataOriginal == this.dataOriginal &&
          other.novaData == this.novaData);
}

class ExcecoesCompanion extends UpdateCompanion<Excecao> {
  final Value<int> id;
  final Value<int> regraId;
  final Value<DateTime> dataOriginal;
  final Value<DateTime?> novaData;
  const ExcecoesCompanion({
    this.id = const Value.absent(),
    this.regraId = const Value.absent(),
    this.dataOriginal = const Value.absent(),
    this.novaData = const Value.absent(),
  });
  ExcecoesCompanion.insert({
    this.id = const Value.absent(),
    required int regraId,
    required DateTime dataOriginal,
    this.novaData = const Value.absent(),
  }) : regraId = Value(regraId),
       dataOriginal = Value(dataOriginal);
  static Insertable<Excecao> custom({
    Expression<int>? id,
    Expression<int>? regraId,
    Expression<DateTime>? dataOriginal,
    Expression<DateTime>? novaData,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (regraId != null) 'regra_id': regraId,
      if (dataOriginal != null) 'data_original': dataOriginal,
      if (novaData != null) 'nova_data': novaData,
    });
  }

  ExcecoesCompanion copyWith({
    Value<int>? id,
    Value<int>? regraId,
    Value<DateTime>? dataOriginal,
    Value<DateTime?>? novaData,
  }) {
    return ExcecoesCompanion(
      id: id ?? this.id,
      regraId: regraId ?? this.regraId,
      dataOriginal: dataOriginal ?? this.dataOriginal,
      novaData: novaData ?? this.novaData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (regraId.present) {
      map['regra_id'] = Variable<int>(regraId.value);
    }
    if (dataOriginal.present) {
      map['data_original'] = Variable<DateTime>(dataOriginal.value);
    }
    if (novaData.present) {
      map['nova_data'] = Variable<DateTime>(novaData.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExcecoesCompanion(')
          ..write('id: $id, ')
          ..write('regraId: $regraId, ')
          ..write('dataOriginal: $dataOriginal, ')
          ..write('novaData: $novaData')
          ..write(')'))
        .toString();
  }
}

class $AtendimentosAvulsosTable extends AtendimentosAvulsos
    with TableInfo<$AtendimentosAvulsosTable, AtendimentoAvulso> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AtendimentosAvulsosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorCentavosMeta = const VerificationMeta(
    'valorCentavos',
  );
  @override
  late final GeneratedColumn<int> valorCentavos = GeneratedColumn<int>(
    'valor_centavos',
    aliasedName,
    false,
    check: () => ComparableExpr(valorCentavos).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, clienteId, data, valorCentavos];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'atendimentos_avulsos';
  @override
  VerificationContext validateIntegrity(
    Insertable<AtendimentoAvulso> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('valor_centavos')) {
      context.handle(
        _valorCentavosMeta,
        valorCentavos.isAcceptableOrUnknown(
          data['valor_centavos']!,
          _valorCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorCentavosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AtendimentoAvulso map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AtendimentoAvulso(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      )!,
      valorCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_centavos'],
      )!,
    );
  }

  @override
  $AtendimentosAvulsosTable createAlias(String alias) {
    return $AtendimentosAvulsosTable(attachedDatabase, alias);
  }
}

class AtendimentoAvulso extends DataClass
    implements Insertable<AtendimentoAvulso> {
  final int id;
  final int clienteId;
  final DateTime data;
  final int valorCentavos;
  const AtendimentoAvulso({
    required this.id,
    required this.clienteId,
    required this.data,
    required this.valorCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    map['data'] = Variable<DateTime>(data);
    map['valor_centavos'] = Variable<int>(valorCentavos);
    return map;
  }

  AtendimentosAvulsosCompanion toCompanion(bool nullToAbsent) {
    return AtendimentosAvulsosCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      data: Value(data),
      valorCentavos: Value(valorCentavos),
    );
  }

  factory AtendimentoAvulso.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AtendimentoAvulso(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      data: serializer.fromJson<DateTime>(json['data']),
      valorCentavos: serializer.fromJson<int>(json['valorCentavos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clienteId': serializer.toJson<int>(clienteId),
      'data': serializer.toJson<DateTime>(data),
      'valorCentavos': serializer.toJson<int>(valorCentavos),
    };
  }

  AtendimentoAvulso copyWith({
    int? id,
    int? clienteId,
    DateTime? data,
    int? valorCentavos,
  }) => AtendimentoAvulso(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    data: data ?? this.data,
    valorCentavos: valorCentavos ?? this.valorCentavos,
  );
  AtendimentoAvulso copyWithCompanion(AtendimentosAvulsosCompanion data) {
    return AtendimentoAvulso(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      data: data.data.present ? data.data.value : this.data,
      valorCentavos: data.valorCentavos.present
          ? data.valorCentavos.value
          : this.valorCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AtendimentoAvulso(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('data: $data, ')
          ..write('valorCentavos: $valorCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clienteId, data, valorCentavos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AtendimentoAvulso &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.data == this.data &&
          other.valorCentavos == this.valorCentavos);
}

class AtendimentosAvulsosCompanion extends UpdateCompanion<AtendimentoAvulso> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<DateTime> data;
  final Value<int> valorCentavos;
  const AtendimentosAvulsosCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.data = const Value.absent(),
    this.valorCentavos = const Value.absent(),
  });
  AtendimentosAvulsosCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    required DateTime data,
    required int valorCentavos,
  }) : clienteId = Value(clienteId),
       data = Value(data),
       valorCentavos = Value(valorCentavos);
  static Insertable<AtendimentoAvulso> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<DateTime>? data,
    Expression<int>? valorCentavos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (data != null) 'data': data,
      if (valorCentavos != null) 'valor_centavos': valorCentavos,
    });
  }

  AtendimentosAvulsosCompanion copyWith({
    Value<int>? id,
    Value<int>? clienteId,
    Value<DateTime>? data,
    Value<int>? valorCentavos,
  }) {
    return AtendimentosAvulsosCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      data: data ?? this.data,
      valorCentavos: valorCentavos ?? this.valorCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (valorCentavos.present) {
      map['valor_centavos'] = Variable<int>(valorCentavos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AtendimentosAvulsosCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('data: $data, ')
          ..write('valorCentavos: $valorCentavos')
          ..write(')'))
        .toString();
  }
}

class $RegistrosDiariaTable extends RegistrosDiaria
    with TableInfo<$RegistrosDiariaTable, RegistroDiaria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistrosDiariaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorRecebidoCentavosMeta =
      const VerificationMeta('valorRecebidoCentavos');
  @override
  late final GeneratedColumn<int> valorRecebidoCentavos = GeneratedColumn<int>(
    'valor_recebido_centavos',
    aliasedName,
    false,
    check: () => ComparableExpr(valorRecebidoCentavos).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    data,
    valorRecebidoCentavos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registros_diaria';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegistroDiaria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('valor_recebido_centavos')) {
      context.handle(
        _valorRecebidoCentavosMeta,
        valorRecebidoCentavos.isAcceptableOrUnknown(
          data['valor_recebido_centavos']!,
          _valorRecebidoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorRecebidoCentavosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegistroDiaria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegistroDiaria(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      )!,
      valorRecebidoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_recebido_centavos'],
      )!,
    );
  }

  @override
  $RegistrosDiariaTable createAlias(String alias) {
    return $RegistrosDiariaTable(attachedDatabase, alias);
  }
}

class RegistroDiaria extends DataClass implements Insertable<RegistroDiaria> {
  final int id;
  final int clienteId;
  final DateTime data;
  final int valorRecebidoCentavos;
  const RegistroDiaria({
    required this.id,
    required this.clienteId,
    required this.data,
    required this.valorRecebidoCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    map['data'] = Variable<DateTime>(data);
    map['valor_recebido_centavos'] = Variable<int>(valorRecebidoCentavos);
    return map;
  }

  RegistrosDiariaCompanion toCompanion(bool nullToAbsent) {
    return RegistrosDiariaCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      data: Value(data),
      valorRecebidoCentavos: Value(valorRecebidoCentavos),
    );
  }

  factory RegistroDiaria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegistroDiaria(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      data: serializer.fromJson<DateTime>(json['data']),
      valorRecebidoCentavos: serializer.fromJson<int>(
        json['valorRecebidoCentavos'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clienteId': serializer.toJson<int>(clienteId),
      'data': serializer.toJson<DateTime>(data),
      'valorRecebidoCentavos': serializer.toJson<int>(valorRecebidoCentavos),
    };
  }

  RegistroDiaria copyWith({
    int? id,
    int? clienteId,
    DateTime? data,
    int? valorRecebidoCentavos,
  }) => RegistroDiaria(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    data: data ?? this.data,
    valorRecebidoCentavos: valorRecebidoCentavos ?? this.valorRecebidoCentavos,
  );
  RegistroDiaria copyWithCompanion(RegistrosDiariaCompanion data) {
    return RegistroDiaria(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      data: data.data.present ? data.data.value : this.data,
      valorRecebidoCentavos: data.valorRecebidoCentavos.present
          ? data.valorRecebidoCentavos.value
          : this.valorRecebidoCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegistroDiaria(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('data: $data, ')
          ..write('valorRecebidoCentavos: $valorRecebidoCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clienteId, data, valorRecebidoCentavos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegistroDiaria &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.data == this.data &&
          other.valorRecebidoCentavos == this.valorRecebidoCentavos);
}

class RegistrosDiariaCompanion extends UpdateCompanion<RegistroDiaria> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<DateTime> data;
  final Value<int> valorRecebidoCentavos;
  const RegistrosDiariaCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.data = const Value.absent(),
    this.valorRecebidoCentavos = const Value.absent(),
  });
  RegistrosDiariaCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    required DateTime data,
    required int valorRecebidoCentavos,
  }) : clienteId = Value(clienteId),
       data = Value(data),
       valorRecebidoCentavos = Value(valorRecebidoCentavos);
  static Insertable<RegistroDiaria> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<DateTime>? data,
    Expression<int>? valorRecebidoCentavos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (data != null) 'data': data,
      if (valorRecebidoCentavos != null)
        'valor_recebido_centavos': valorRecebidoCentavos,
    });
  }

  RegistrosDiariaCompanion copyWith({
    Value<int>? id,
    Value<int>? clienteId,
    Value<DateTime>? data,
    Value<int>? valorRecebidoCentavos,
  }) {
    return RegistrosDiariaCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      data: data ?? this.data,
      valorRecebidoCentavos:
          valorRecebidoCentavos ?? this.valorRecebidoCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (valorRecebidoCentavos.present) {
      map['valor_recebido_centavos'] = Variable<int>(
        valorRecebidoCentavos.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistrosDiariaCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('data: $data, ')
          ..write('valorRecebidoCentavos: $valorRecebidoCentavos')
          ..write(')'))
        .toString();
  }
}

class $VendasDocesTable extends VendasDoces
    with TableInfo<$VendasDocesTable, VendaDoces> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VendasDocesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantidadeLevadaMeta = const VerificationMeta(
    'quantidadeLevada',
  );
  @override
  late final GeneratedColumn<int> quantidadeLevada = GeneratedColumn<int>(
    'quantidade_levada',
    aliasedName,
    false,
    check: () => ComparableExpr(quantidadeLevada).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorTotalCentavosMeta =
      const VerificationMeta('valorTotalCentavos');
  @override
  late final GeneratedColumn<int> valorTotalCentavos = GeneratedColumn<int>(
    'valor_total_centavos',
    aliasedName,
    false,
    check: () => ComparableExpr(valorTotalCentavos).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    data,
    quantidadeLevada,
    valorTotalCentavos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vendas_doces';
  @override
  VerificationContext validateIntegrity(
    Insertable<VendaDoces> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('quantidade_levada')) {
      context.handle(
        _quantidadeLevadaMeta,
        quantidadeLevada.isAcceptableOrUnknown(
          data['quantidade_levada']!,
          _quantidadeLevadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantidadeLevadaMeta);
    }
    if (data.containsKey('valor_total_centavos')) {
      context.handle(
        _valorTotalCentavosMeta,
        valorTotalCentavos.isAcceptableOrUnknown(
          data['valor_total_centavos']!,
          _valorTotalCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorTotalCentavosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VendaDoces map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VendaDoces(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      )!,
      quantidadeLevada: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantidade_levada'],
      )!,
      valorTotalCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_total_centavos'],
      )!,
    );
  }

  @override
  $VendasDocesTable createAlias(String alias) {
    return $VendasDocesTable(attachedDatabase, alias);
  }
}

class VendaDoces extends DataClass implements Insertable<VendaDoces> {
  final int id;
  final DateTime data;
  final int quantidadeLevada;
  final int valorTotalCentavos;
  const VendaDoces({
    required this.id,
    required this.data,
    required this.quantidadeLevada,
    required this.valorTotalCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data'] = Variable<DateTime>(data);
    map['quantidade_levada'] = Variable<int>(quantidadeLevada);
    map['valor_total_centavos'] = Variable<int>(valorTotalCentavos);
    return map;
  }

  VendasDocesCompanion toCompanion(bool nullToAbsent) {
    return VendasDocesCompanion(
      id: Value(id),
      data: Value(data),
      quantidadeLevada: Value(quantidadeLevada),
      valorTotalCentavos: Value(valorTotalCentavos),
    );
  }

  factory VendaDoces.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VendaDoces(
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<DateTime>(json['data']),
      quantidadeLevada: serializer.fromJson<int>(json['quantidadeLevada']),
      valorTotalCentavos: serializer.fromJson<int>(json['valorTotalCentavos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<DateTime>(data),
      'quantidadeLevada': serializer.toJson<int>(quantidadeLevada),
      'valorTotalCentavos': serializer.toJson<int>(valorTotalCentavos),
    };
  }

  VendaDoces copyWith({
    int? id,
    DateTime? data,
    int? quantidadeLevada,
    int? valorTotalCentavos,
  }) => VendaDoces(
    id: id ?? this.id,
    data: data ?? this.data,
    quantidadeLevada: quantidadeLevada ?? this.quantidadeLevada,
    valorTotalCentavos: valorTotalCentavos ?? this.valorTotalCentavos,
  );
  VendaDoces copyWithCompanion(VendasDocesCompanion data) {
    return VendaDoces(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
      quantidadeLevada: data.quantidadeLevada.present
          ? data.quantidadeLevada.value
          : this.quantidadeLevada,
      valorTotalCentavos: data.valorTotalCentavos.present
          ? data.valorTotalCentavos.value
          : this.valorTotalCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VendaDoces(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('quantidadeLevada: $quantidadeLevada, ')
          ..write('valorTotalCentavos: $valorTotalCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, data, quantidadeLevada, valorTotalCentavos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VendaDoces &&
          other.id == this.id &&
          other.data == this.data &&
          other.quantidadeLevada == this.quantidadeLevada &&
          other.valorTotalCentavos == this.valorTotalCentavos);
}

class VendasDocesCompanion extends UpdateCompanion<VendaDoces> {
  final Value<int> id;
  final Value<DateTime> data;
  final Value<int> quantidadeLevada;
  final Value<int> valorTotalCentavos;
  const VendasDocesCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.quantidadeLevada = const Value.absent(),
    this.valorTotalCentavos = const Value.absent(),
  });
  VendasDocesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime data,
    required int quantidadeLevada,
    required int valorTotalCentavos,
  }) : data = Value(data),
       quantidadeLevada = Value(quantidadeLevada),
       valorTotalCentavos = Value(valorTotalCentavos);
  static Insertable<VendaDoces> custom({
    Expression<int>? id,
    Expression<DateTime>? data,
    Expression<int>? quantidadeLevada,
    Expression<int>? valorTotalCentavos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (quantidadeLevada != null) 'quantidade_levada': quantidadeLevada,
      if (valorTotalCentavos != null)
        'valor_total_centavos': valorTotalCentavos,
    });
  }

  VendasDocesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? data,
    Value<int>? quantidadeLevada,
    Value<int>? valorTotalCentavos,
  }) {
    return VendasDocesCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      quantidadeLevada: quantidadeLevada ?? this.quantidadeLevada,
      valorTotalCentavos: valorTotalCentavos ?? this.valorTotalCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (quantidadeLevada.present) {
      map['quantidade_levada'] = Variable<int>(quantidadeLevada.value);
    }
    if (valorTotalCentavos.present) {
      map['valor_total_centavos'] = Variable<int>(valorTotalCentavos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VendasDocesCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('quantidadeLevada: $quantidadeLevada, ')
          ..write('valorTotalCentavos: $valorTotalCentavos')
          ..write(')'))
        .toString();
  }
}

abstract class _$BancoDados extends GeneratedDatabase {
  _$BancoDados(QueryExecutor e) : super(e);
  $BancoDadosManager get managers => $BancoDadosManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $RegrasRecorrenciaTable regrasRecorrencia =
      $RegrasRecorrenciaTable(this);
  late final $ExcecoesTable excecoes = $ExcecoesTable(this);
  late final $AtendimentosAvulsosTable atendimentosAvulsos =
      $AtendimentosAvulsosTable(this);
  late final $RegistrosDiariaTable registrosDiaria = $RegistrosDiariaTable(
    this,
  );
  late final $VendasDocesTable vendasDoces = $VendasDocesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clientes,
    regrasRecorrencia,
    excecoes,
    atendimentosAvulsos,
    registrosDiaria,
    vendasDoces,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clientes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('regras_recorrencia', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'regras_recorrencia',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('excecoes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clientes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('atendimentos_avulsos', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ClientesTableCreateCompanionBuilder = ClientesCompanion Function({
  Value<int> id,
  required String nome,
  Value<String?> endereco,
  required int valorPadraoCentavos,
});
typedef $$ClientesTableUpdateCompanionBuilder = ClientesCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String?> endereco,
  Value<int> valorPadraoCentavos,
});

final class $$ClientesTableReferences
    extends BaseReferences<_$BancoDados, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RegrasRecorrenciaTable, List<RegraRecorrencia>>
  _regrasRecorrenciaRefsTable(_$BancoDados db) => MultiTypedResultKey.fromTable(
    db.regrasRecorrencia,
    aliasName: 'clientes__id__regras_recorrencia__cliente_id',
  );

  $$RegrasRecorrenciaTableProcessedTableManager get regrasRecorrenciaRefs {
    final manager = $$RegrasRecorrenciaTableTableManager(
      $_db,
      $_db.regrasRecorrencia,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _regrasRecorrenciaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AtendimentosAvulsosTable, List<AtendimentoAvulso>>
  _atendimentosAvulsosRefsTable(_$BancoDados db) =>
      MultiTypedResultKey.fromTable(
        db.atendimentosAvulsos,
        aliasName: 'clientes__id__atendimentos_avulsos__cliente_id',
      );

  $$AtendimentosAvulsosTableProcessedTableManager get atendimentosAvulsosRefs {
    final manager = $$AtendimentosAvulsosTableTableManager(
      $_db,
      $_db.atendimentosAvulsos,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _atendimentosAvulsosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RegistrosDiariaTable, List<RegistroDiaria>>
  _registrosDiariaRefsTable(_$BancoDados db) => MultiTypedResultKey.fromTable(
    db.registrosDiaria,
    aliasName: 'clientes__id__registros_diaria__cliente_id',
  );

  $$RegistrosDiariaTableProcessedTableManager get registrosDiariaRefs {
    final manager = $$RegistrosDiariaTableTableManager(
      $_db,
      $_db.registrosDiaria,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _registrosDiariaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$BancoDados, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endereco => $composableBuilder(
    column: $table.endereco,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorPadraoCentavos => $composableBuilder(
    column: $table.valorPadraoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> regrasRecorrenciaRefs(
    Expression<bool> Function($$RegrasRecorrenciaTableFilterComposer f) f,
  ) {
    final $$RegrasRecorrenciaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.regrasRecorrencia,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegrasRecorrenciaTableFilterComposer(
            $db: $db,
            $table: $db.regrasRecorrencia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> atendimentosAvulsosRefs(
    Expression<bool> Function($$AtendimentosAvulsosTableFilterComposer f) f,
  ) {
    final $$AtendimentosAvulsosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.atendimentosAvulsos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AtendimentosAvulsosTableFilterComposer(
            $db: $db,
            $table: $db.atendimentosAvulsos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> registrosDiariaRefs(
    Expression<bool> Function($$RegistrosDiariaTableFilterComposer f) f,
  ) {
    final $$RegistrosDiariaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.registrosDiaria,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosDiariaTableFilterComposer(
            $db: $db,
            $table: $db.registrosDiaria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$BancoDados, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endereco => $composableBuilder(
    column: $table.endereco,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorPadraoCentavos => $composableBuilder(
    column: $table.valorPadraoCentavos,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$BancoDados, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get endereco =>
      $composableBuilder(column: $table.endereco, builder: (column) => column);

  GeneratedColumn<int> get valorPadraoCentavos => $composableBuilder(
    column: $table.valorPadraoCentavos,
    builder: (column) => column,
  );

  Expression<T> regrasRecorrenciaRefs<T extends Object>(
    Expression<T> Function($$RegrasRecorrenciaTableAnnotationComposer a) f,
  ) {
    final $$RegrasRecorrenciaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.regrasRecorrencia,
          getReferencedColumn: (t) => t.clienteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RegrasRecorrenciaTableAnnotationComposer(
                $db: $db,
                $table: $db.regrasRecorrencia,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> atendimentosAvulsosRefs<T extends Object>(
    Expression<T> Function($$AtendimentosAvulsosTableAnnotationComposer a) f,
  ) {
    final $$AtendimentosAvulsosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.atendimentosAvulsos,
          getReferencedColumn: (t) => t.clienteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AtendimentosAvulsosTableAnnotationComposer(
                $db: $db,
                $table: $db.atendimentosAvulsos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> registrosDiariaRefs<T extends Object>(
    Expression<T> Function($$RegistrosDiariaTableAnnotationComposer a) f,
  ) {
    final $$RegistrosDiariaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.registrosDiaria,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosDiariaTableAnnotationComposer(
            $db: $db,
            $table: $db.registrosDiaria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$BancoDados,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, $$ClientesTableReferences),
          Cliente,
          PrefetchHooks Function({
            bool regrasRecorrenciaRefs,
            bool atendimentosAvulsosRefs,
            bool registrosDiariaRefs,
          })
        > {
  $$ClientesTableTableManager(_$BancoDados db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> endereco = const Value.absent(),
                Value<int> valorPadraoCentavos = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                nome: nome,
                endereco: endereco,
                valorPadraoCentavos: valorPadraoCentavos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                Value<String?> endereco = const Value.absent(),
                required int valorPadraoCentavos,
              }) => ClientesCompanion.insert(
                id: id,
                nome: nome,
                endereco: endereco,
                valorPadraoCentavos: valorPadraoCentavos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClientesTable, Cliente>(table),
                  $$ClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                regrasRecorrenciaRefs = false,
                atendimentosAvulsosRefs = false,
                registrosDiariaRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (regrasRecorrenciaRefs) db.regrasRecorrencia,
                    if (atendimentosAvulsosRefs) db.atendimentosAvulsos,
                    if (registrosDiariaRefs) db.registrosDiaria,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (regrasRecorrenciaRefs)
                        await $_getPrefetchedDataByColumns<
                          Cliente,
                          $ClientesTable,
                          RegraRecorrencia,
                          $RegrasRecorrenciaTable
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._regrasRecorrenciaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).regrasRecorrenciaRefs,
                          currentColumn: 'id',
                          referencedColumn: 'cliente_id',
                          typedResults: items,
                        ),
                      if (atendimentosAvulsosRefs)
                        await $_getPrefetchedDataByColumns<
                          Cliente,
                          $ClientesTable,
                          AtendimentoAvulso,
                          $AtendimentosAvulsosTable
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._atendimentosAvulsosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).atendimentosAvulsosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'cliente_id',
                          typedResults: items,
                        ),
                      if (registrosDiariaRefs)
                        await $_getPrefetchedDataByColumns<
                          Cliente,
                          $ClientesTable,
                          RegistroDiaria,
                          $RegistrosDiariaTable
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._registrosDiariaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).registrosDiariaRefs,
                          currentColumn: 'id',
                          referencedColumn: 'cliente_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDados,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, $$ClientesTableReferences),
      Cliente,
      PrefetchHooks Function({
        bool regrasRecorrenciaRefs,
        bool atendimentosAvulsosRefs,
        bool registrosDiariaRefs,
      })
    >;
typedef $$RegrasRecorrenciaTableCreateCompanionBuilder =
    RegrasRecorrenciaCompanion Function({
      Value<int> id,
      required int clienteId,
      required List<int> diasSemana,
      Value<int> intervaloSemanas,
      required DateTime dataInicio,
      Value<DateTime?> dataFim,
    });
typedef $$RegrasRecorrenciaTableUpdateCompanionBuilder =
    RegrasRecorrenciaCompanion Function({
      Value<int> id,
      Value<int> clienteId,
      Value<List<int>> diasSemana,
      Value<int> intervaloSemanas,
      Value<DateTime> dataInicio,
      Value<DateTime?> dataFim,
    });

final class $$RegrasRecorrenciaTableReferences
    extends
        BaseReferences<
          _$BancoDados,
          $RegrasRecorrenciaTable,
          RegraRecorrencia
        > {
  $$RegrasRecorrenciaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ClientesTable _clienteIdTable(_$BancoDados db) =>
      db.clientes.createAlias('regras_recorrencia__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExcecoesTable, List<Excecao>> _excecoesRefsTable(
    _$BancoDados db,
  ) => MultiTypedResultKey.fromTable(
    db.excecoes,
    aliasName: 'regras_recorrencia__id__excecoes__regra_id',
  );

  $$ExcecoesTableProcessedTableManager get excecoesRefs {
    final manager = $$ExcecoesTableTableManager(
      $_db,
      $_db.excecoes,
    ).filter((f) => f.regraId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_excecoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RegrasRecorrenciaTableFilterComposer
    extends Composer<_$BancoDados, $RegrasRecorrenciaTable> {
  $$RegrasRecorrenciaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get diasSemana =>
      $composableBuilder(
        column: $table.diasSemana,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get intervaloSemanas => $composableBuilder(
    column: $table.intervaloSemanas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataInicio => $composableBuilder(
    column: $table.dataInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataFim => $composableBuilder(
    column: $table.dataFim,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> excecoesRefs(
    Expression<bool> Function($$ExcecoesTableFilterComposer f) f,
  ) {
    final $$ExcecoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.excecoes,
      getReferencedColumn: (t) => t.regraId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExcecoesTableFilterComposer(
            $db: $db,
            $table: $db.excecoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RegrasRecorrenciaTableOrderingComposer
    extends Composer<_$BancoDados, $RegrasRecorrenciaTable> {
  $$RegrasRecorrenciaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diasSemana => $composableBuilder(
    column: $table.diasSemana,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervaloSemanas => $composableBuilder(
    column: $table.intervaloSemanas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataInicio => $composableBuilder(
    column: $table.dataInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataFim => $composableBuilder(
    column: $table.dataFim,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegrasRecorrenciaTableAnnotationComposer
    extends Composer<_$BancoDados, $RegrasRecorrenciaTable> {
  $$RegrasRecorrenciaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get diasSemana =>
      $composableBuilder(
        column: $table.diasSemana,
        builder: (column) => column,
      );

  GeneratedColumn<int> get intervaloSemanas => $composableBuilder(
    column: $table.intervaloSemanas,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataInicio => $composableBuilder(
    column: $table.dataInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataFim =>
      $composableBuilder(column: $table.dataFim, builder: (column) => column);

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> excecoesRefs<T extends Object>(
    Expression<T> Function($$ExcecoesTableAnnotationComposer a) f,
  ) {
    final $$ExcecoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.excecoes,
      getReferencedColumn: (t) => t.regraId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExcecoesTableAnnotationComposer(
            $db: $db,
            $table: $db.excecoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RegrasRecorrenciaTableTableManager
    extends
        RootTableManager<
          _$BancoDados,
          $RegrasRecorrenciaTable,
          RegraRecorrencia,
          $$RegrasRecorrenciaTableFilterComposer,
          $$RegrasRecorrenciaTableOrderingComposer,
          $$RegrasRecorrenciaTableAnnotationComposer,
          $$RegrasRecorrenciaTableCreateCompanionBuilder,
          $$RegrasRecorrenciaTableUpdateCompanionBuilder,
          (RegraRecorrencia, $$RegrasRecorrenciaTableReferences),
          RegraRecorrencia,
          PrefetchHooks Function({bool clienteId, bool excecoesRefs})
        > {
  $$RegrasRecorrenciaTableTableManager(
    _$BancoDados db,
    $RegrasRecorrenciaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegrasRecorrenciaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegrasRecorrenciaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegrasRecorrenciaTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<List<int>> diasSemana = const Value.absent(),
                Value<int> intervaloSemanas = const Value.absent(),
                Value<DateTime> dataInicio = const Value.absent(),
                Value<DateTime?> dataFim = const Value.absent(),
              }) => RegrasRecorrenciaCompanion(
                id: id,
                clienteId: clienteId,
                diasSemana: diasSemana,
                intervaloSemanas: intervaloSemanas,
                dataInicio: dataInicio,
                dataFim: dataFim,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clienteId,
                required List<int> diasSemana,
                Value<int> intervaloSemanas = const Value.absent(),
                required DateTime dataInicio,
                Value<DateTime?> dataFim = const Value.absent(),
              }) => RegrasRecorrenciaCompanion.insert(
                id: id,
                clienteId: clienteId,
                diasSemana: diasSemana,
                intervaloSemanas: intervaloSemanas,
                dataInicio: dataInicio,
                dataFim: dataFim,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RegrasRecorrenciaTable, RegraRecorrencia>(table),
                  $$RegrasRecorrenciaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clienteId = false, excecoesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (excecoesRefs) db.excecoes],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clienteId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clienteId,
                        referencedTable: $$RegrasRecorrenciaTableReferences
                            ._clienteIdTable(db),
                        referencedColumn: $$RegrasRecorrenciaTableReferences
                            ._clienteIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (excecoesRefs)
                    await $_getPrefetchedDataByColumns<
                      RegraRecorrencia,
                      $RegrasRecorrenciaTable,
                      Excecao,
                      $ExcecoesTable
                    >(
                      currentTable: table,
                      referencedTable: $$RegrasRecorrenciaTableReferences
                          ._excecoesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RegrasRecorrenciaTableReferences(
                            db,
                            table,
                            p0,
                          ).excecoesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'regra_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RegrasRecorrenciaTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDados,
      $RegrasRecorrenciaTable,
      RegraRecorrencia,
      $$RegrasRecorrenciaTableFilterComposer,
      $$RegrasRecorrenciaTableOrderingComposer,
      $$RegrasRecorrenciaTableAnnotationComposer,
      $$RegrasRecorrenciaTableCreateCompanionBuilder,
      $$RegrasRecorrenciaTableUpdateCompanionBuilder,
      (RegraRecorrencia, $$RegrasRecorrenciaTableReferences),
      RegraRecorrencia,
      PrefetchHooks Function({bool clienteId, bool excecoesRefs})
    >;
typedef $$ExcecoesTableCreateCompanionBuilder = ExcecoesCompanion Function({
  Value<int> id,
  required int regraId,
  required DateTime dataOriginal,
  Value<DateTime?> novaData,
});
typedef $$ExcecoesTableUpdateCompanionBuilder = ExcecoesCompanion Function({
  Value<int> id,
  Value<int> regraId,
  Value<DateTime> dataOriginal,
  Value<DateTime?> novaData,
});

final class $$ExcecoesTableReferences
    extends BaseReferences<_$BancoDados, $ExcecoesTable, Excecao> {
  $$ExcecoesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RegrasRecorrenciaTable _regraIdTable(_$BancoDados db) => db
      .regrasRecorrencia
      .createAlias('excecoes__regra_id__regras_recorrencia__id');

  $$RegrasRecorrenciaTableProcessedTableManager get regraId {
    final $_column = $_itemColumn<int>('regra_id')!;

    final manager = $$RegrasRecorrenciaTableTableManager(
      $_db,
      $_db.regrasRecorrencia,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_regraIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExcecoesTableFilterComposer
    extends Composer<_$BancoDados, $ExcecoesTable> {
  $$ExcecoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataOriginal => $composableBuilder(
    column: $table.dataOriginal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get novaData => $composableBuilder(
    column: $table.novaData,
    builder: (column) => ColumnFilters(column),
  );

  $$RegrasRecorrenciaTableFilterComposer get regraId {
    final $$RegrasRecorrenciaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regraId,
      referencedTable: $db.regrasRecorrencia,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegrasRecorrenciaTableFilterComposer(
            $db: $db,
            $table: $db.regrasRecorrencia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExcecoesTableOrderingComposer
    extends Composer<_$BancoDados, $ExcecoesTable> {
  $$ExcecoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataOriginal => $composableBuilder(
    column: $table.dataOriginal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get novaData => $composableBuilder(
    column: $table.novaData,
    builder: (column) => ColumnOrderings(column),
  );

  $$RegrasRecorrenciaTableOrderingComposer get regraId {
    final $$RegrasRecorrenciaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regraId,
      referencedTable: $db.regrasRecorrencia,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegrasRecorrenciaTableOrderingComposer(
            $db: $db,
            $table: $db.regrasRecorrencia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExcecoesTableAnnotationComposer
    extends Composer<_$BancoDados, $ExcecoesTable> {
  $$ExcecoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataOriginal => $composableBuilder(
    column: $table.dataOriginal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get novaData =>
      $composableBuilder(column: $table.novaData, builder: (column) => column);

  $$RegrasRecorrenciaTableAnnotationComposer get regraId {
    final $$RegrasRecorrenciaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.regraId,
          referencedTable: $db.regrasRecorrencia,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RegrasRecorrenciaTableAnnotationComposer(
                $db: $db,
                $table: $db.regrasRecorrencia,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ExcecoesTableTableManager
    extends
        RootTableManager<
          _$BancoDados,
          $ExcecoesTable,
          Excecao,
          $$ExcecoesTableFilterComposer,
          $$ExcecoesTableOrderingComposer,
          $$ExcecoesTableAnnotationComposer,
          $$ExcecoesTableCreateCompanionBuilder,
          $$ExcecoesTableUpdateCompanionBuilder,
          (Excecao, $$ExcecoesTableReferences),
          Excecao,
          PrefetchHooks Function({bool regraId})
        > {
  $$ExcecoesTableTableManager(_$BancoDados db, $ExcecoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExcecoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExcecoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExcecoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> regraId = const Value.absent(),
                Value<DateTime> dataOriginal = const Value.absent(),
                Value<DateTime?> novaData = const Value.absent(),
              }) => ExcecoesCompanion(
                id: id,
                regraId: regraId,
                dataOriginal: dataOriginal,
                novaData: novaData,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int regraId,
                required DateTime dataOriginal,
                Value<DateTime?> novaData = const Value.absent(),
              }) => ExcecoesCompanion.insert(
                id: id,
                regraId: regraId,
                dataOriginal: dataOriginal,
                novaData: novaData,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExcecoesTable, Excecao>(table),
                  $$ExcecoesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({regraId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (regraId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.regraId,
                        referencedTable: $$ExcecoesTableReferences
                            ._regraIdTable(db),
                        referencedColumn: $$ExcecoesTableReferences
                            ._regraIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExcecoesTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDados,
      $ExcecoesTable,
      Excecao,
      $$ExcecoesTableFilterComposer,
      $$ExcecoesTableOrderingComposer,
      $$ExcecoesTableAnnotationComposer,
      $$ExcecoesTableCreateCompanionBuilder,
      $$ExcecoesTableUpdateCompanionBuilder,
      (Excecao, $$ExcecoesTableReferences),
      Excecao,
      PrefetchHooks Function({bool regraId})
    >;
typedef $$AtendimentosAvulsosTableCreateCompanionBuilder =
    AtendimentosAvulsosCompanion Function({
      Value<int> id,
      required int clienteId,
      required DateTime data,
      required int valorCentavos,
    });
typedef $$AtendimentosAvulsosTableUpdateCompanionBuilder =
    AtendimentosAvulsosCompanion Function({
      Value<int> id,
      Value<int> clienteId,
      Value<DateTime> data,
      Value<int> valorCentavos,
    });

final class $$AtendimentosAvulsosTableReferences
    extends
        BaseReferences<
          _$BancoDados,
          $AtendimentosAvulsosTable,
          AtendimentoAvulso
        > {
  $$AtendimentosAvulsosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ClientesTable _clienteIdTable(_$BancoDados db) =>
      db.clientes.createAlias('atendimentos_avulsos__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AtendimentosAvulsosTableFilterComposer
    extends Composer<_$BancoDados, $AtendimentosAvulsosTable> {
  $$AtendimentosAvulsosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AtendimentosAvulsosTableOrderingComposer
    extends Composer<_$BancoDados, $AtendimentosAvulsosTable> {
  $$AtendimentosAvulsosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AtendimentosAvulsosTableAnnotationComposer
    extends Composer<_$BancoDados, $AtendimentosAvulsosTable> {
  $$AtendimentosAvulsosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AtendimentosAvulsosTableTableManager
    extends
        RootTableManager<
          _$BancoDados,
          $AtendimentosAvulsosTable,
          AtendimentoAvulso,
          $$AtendimentosAvulsosTableFilterComposer,
          $$AtendimentosAvulsosTableOrderingComposer,
          $$AtendimentosAvulsosTableAnnotationComposer,
          $$AtendimentosAvulsosTableCreateCompanionBuilder,
          $$AtendimentosAvulsosTableUpdateCompanionBuilder,
          (AtendimentoAvulso, $$AtendimentosAvulsosTableReferences),
          AtendimentoAvulso,
          PrefetchHooks Function({bool clienteId})
        > {
  $$AtendimentosAvulsosTableTableManager(
    _$BancoDados db,
    $AtendimentosAvulsosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AtendimentosAvulsosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AtendimentosAvulsosTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AtendimentosAvulsosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<DateTime> data = const Value.absent(),
                Value<int> valorCentavos = const Value.absent(),
              }) => AtendimentosAvulsosCompanion(
                id: id,
                clienteId: clienteId,
                data: data,
                valorCentavos: valorCentavos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clienteId,
                required DateTime data,
                required int valorCentavos,
              }) => AtendimentosAvulsosCompanion.insert(
                id: id,
                clienteId: clienteId,
                data: data,
                valorCentavos: valorCentavos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AtendimentosAvulsosTable, AtendimentoAvulso>(
                    table,
                  ),
                  $$AtendimentosAvulsosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clienteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clienteId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clienteId,
                        referencedTable: $$AtendimentosAvulsosTableReferences
                            ._clienteIdTable(db),
                        referencedColumn: $$AtendimentosAvulsosTableReferences
                            ._clienteIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AtendimentosAvulsosTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDados,
      $AtendimentosAvulsosTable,
      AtendimentoAvulso,
      $$AtendimentosAvulsosTableFilterComposer,
      $$AtendimentosAvulsosTableOrderingComposer,
      $$AtendimentosAvulsosTableAnnotationComposer,
      $$AtendimentosAvulsosTableCreateCompanionBuilder,
      $$AtendimentosAvulsosTableUpdateCompanionBuilder,
      (AtendimentoAvulso, $$AtendimentosAvulsosTableReferences),
      AtendimentoAvulso,
      PrefetchHooks Function({bool clienteId})
    >;
typedef $$RegistrosDiariaTableCreateCompanionBuilder =
    RegistrosDiariaCompanion Function({
      Value<int> id,
      required int clienteId,
      required DateTime data,
      required int valorRecebidoCentavos,
    });
typedef $$RegistrosDiariaTableUpdateCompanionBuilder =
    RegistrosDiariaCompanion Function({
      Value<int> id,
      Value<int> clienteId,
      Value<DateTime> data,
      Value<int> valorRecebidoCentavos,
    });

final class $$RegistrosDiariaTableReferences
    extends
        BaseReferences<_$BancoDados, $RegistrosDiariaTable, RegistroDiaria> {
  $$RegistrosDiariaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ClientesTable _clienteIdTable(_$BancoDados db) =>
      db.clientes.createAlias('registros_diaria__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RegistrosDiariaTableFilterComposer
    extends Composer<_$BancoDados, $RegistrosDiariaTable> {
  $$RegistrosDiariaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorRecebidoCentavos => $composableBuilder(
    column: $table.valorRecebidoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegistrosDiariaTableOrderingComposer
    extends Composer<_$BancoDados, $RegistrosDiariaTable> {
  $$RegistrosDiariaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorRecebidoCentavos => $composableBuilder(
    column: $table.valorRecebidoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegistrosDiariaTableAnnotationComposer
    extends Composer<_$BancoDados, $RegistrosDiariaTable> {
  $$RegistrosDiariaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<int> get valorRecebidoCentavos => $composableBuilder(
    column: $table.valorRecebidoCentavos,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegistrosDiariaTableTableManager
    extends
        RootTableManager<
          _$BancoDados,
          $RegistrosDiariaTable,
          RegistroDiaria,
          $$RegistrosDiariaTableFilterComposer,
          $$RegistrosDiariaTableOrderingComposer,
          $$RegistrosDiariaTableAnnotationComposer,
          $$RegistrosDiariaTableCreateCompanionBuilder,
          $$RegistrosDiariaTableUpdateCompanionBuilder,
          (RegistroDiaria, $$RegistrosDiariaTableReferences),
          RegistroDiaria,
          PrefetchHooks Function({bool clienteId})
        > {
  $$RegistrosDiariaTableTableManager(
    _$BancoDados db,
    $RegistrosDiariaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegistrosDiariaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegistrosDiariaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegistrosDiariaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<DateTime> data = const Value.absent(),
                Value<int> valorRecebidoCentavos = const Value.absent(),
              }) => RegistrosDiariaCompanion(
                id: id,
                clienteId: clienteId,
                data: data,
                valorRecebidoCentavos: valorRecebidoCentavos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clienteId,
                required DateTime data,
                required int valorRecebidoCentavos,
              }) => RegistrosDiariaCompanion.insert(
                id: id,
                clienteId: clienteId,
                data: data,
                valorRecebidoCentavos: valorRecebidoCentavos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RegistrosDiariaTable, RegistroDiaria>(table),
                  $$RegistrosDiariaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clienteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clienteId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clienteId,
                        referencedTable: $$RegistrosDiariaTableReferences
                            ._clienteIdTable(db),
                        referencedColumn: $$RegistrosDiariaTableReferences
                            ._clienteIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RegistrosDiariaTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDados,
      $RegistrosDiariaTable,
      RegistroDiaria,
      $$RegistrosDiariaTableFilterComposer,
      $$RegistrosDiariaTableOrderingComposer,
      $$RegistrosDiariaTableAnnotationComposer,
      $$RegistrosDiariaTableCreateCompanionBuilder,
      $$RegistrosDiariaTableUpdateCompanionBuilder,
      (RegistroDiaria, $$RegistrosDiariaTableReferences),
      RegistroDiaria,
      PrefetchHooks Function({bool clienteId})
    >;
typedef $$VendasDocesTableCreateCompanionBuilder =
    VendasDocesCompanion Function({
      Value<int> id,
      required DateTime data,
      required int quantidadeLevada,
      required int valorTotalCentavos,
    });
typedef $$VendasDocesTableUpdateCompanionBuilder =
    VendasDocesCompanion Function({
      Value<int> id,
      Value<DateTime> data,
      Value<int> quantidadeLevada,
      Value<int> valorTotalCentavos,
    });

class $$VendasDocesTableFilterComposer
    extends Composer<_$BancoDados, $VendasDocesTable> {
  $$VendasDocesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantidadeLevada => $composableBuilder(
    column: $table.quantidadeLevada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorTotalCentavos => $composableBuilder(
    column: $table.valorTotalCentavos,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VendasDocesTableOrderingComposer
    extends Composer<_$BancoDados, $VendasDocesTable> {
  $$VendasDocesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantidadeLevada => $composableBuilder(
    column: $table.quantidadeLevada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorTotalCentavos => $composableBuilder(
    column: $table.valorTotalCentavos,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VendasDocesTableAnnotationComposer
    extends Composer<_$BancoDados, $VendasDocesTable> {
  $$VendasDocesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<int> get quantidadeLevada => $composableBuilder(
    column: $table.quantidadeLevada,
    builder: (column) => column,
  );

  GeneratedColumn<int> get valorTotalCentavos => $composableBuilder(
    column: $table.valorTotalCentavos,
    builder: (column) => column,
  );
}

class $$VendasDocesTableTableManager
    extends
        RootTableManager<
          _$BancoDados,
          $VendasDocesTable,
          VendaDoces,
          $$VendasDocesTableFilterComposer,
          $$VendasDocesTableOrderingComposer,
          $$VendasDocesTableAnnotationComposer,
          $$VendasDocesTableCreateCompanionBuilder,
          $$VendasDocesTableUpdateCompanionBuilder,
          (
            VendaDoces,
            BaseReferences<_$BancoDados, $VendasDocesTable, VendaDoces>,
          ),
          VendaDoces,
          PrefetchHooks Function()
        > {
  $$VendasDocesTableTableManager(_$BancoDados db, $VendasDocesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VendasDocesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VendasDocesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VendasDocesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> data = const Value.absent(),
                Value<int> quantidadeLevada = const Value.absent(),
                Value<int> valorTotalCentavos = const Value.absent(),
              }) => VendasDocesCompanion(
                id: id,
                data: data,
                quantidadeLevada: quantidadeLevada,
                valorTotalCentavos: valorTotalCentavos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime data,
                required int quantidadeLevada,
                required int valorTotalCentavos,
              }) => VendasDocesCompanion.insert(
                id: id,
                data: data,
                quantidadeLevada: quantidadeLevada,
                valorTotalCentavos: valorTotalCentavos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VendasDocesTable, VendaDoces>(table),
                  BaseReferences<_$BancoDados, $VendasDocesTable, VendaDoces>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VendasDocesTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDados,
      $VendasDocesTable,
      VendaDoces,
      $$VendasDocesTableFilterComposer,
      $$VendasDocesTableOrderingComposer,
      $$VendasDocesTableAnnotationComposer,
      $$VendasDocesTableCreateCompanionBuilder,
      $$VendasDocesTableUpdateCompanionBuilder,
      (VendaDoces, BaseReferences<_$BancoDados, $VendasDocesTable, VendaDoces>),
      VendaDoces,
      PrefetchHooks Function()
    >;

class $BancoDadosManager {
  final _$BancoDados _db;
  $BancoDadosManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$RegrasRecorrenciaTableTableManager get regrasRecorrencia =>
      $$RegrasRecorrenciaTableTableManager(_db, _db.regrasRecorrencia);
  $$ExcecoesTableTableManager get excecoes =>
      $$ExcecoesTableTableManager(_db, _db.excecoes);
  $$AtendimentosAvulsosTableTableManager get atendimentosAvulsos =>
      $$AtendimentosAvulsosTableTableManager(_db, _db.atendimentosAvulsos);
  $$RegistrosDiariaTableTableManager get registrosDiaria =>
      $$RegistrosDiariaTableTableManager(_db, _db.registrosDiaria);
  $$VendasDocesTableTableManager get vendasDoces =>
      $$VendasDocesTableTableManager(_db, _db.vendasDoces);
}
