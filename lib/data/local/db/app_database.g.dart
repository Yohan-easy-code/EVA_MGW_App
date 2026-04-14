// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MapAssetsTable extends MapAssets
    with TableInfo<$MapAssetsTable, MapAsset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MapAssetsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logicalMapNameMeta = const VerificationMeta(
    'logicalMapName',
  );
  @override
  late final GeneratedColumn<String> logicalMapName = GeneratedColumn<String>(
    'logical_map_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _floorNumberMeta = const VerificationMeta(
    'floorNumber',
  );
  @override
  late final GeneratedColumn<int> floorNumber = GeneratedColumn<int>(
    'floor_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("width" >= 1)',
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("height" >= 1)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    logicalMapName,
    floorNumber,
    imagePath,
    width,
    height,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'map_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<MapAsset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('logical_map_name')) {
      context.handle(
        _logicalMapNameMeta,
        logicalMapName.isAcceptableOrUnknown(
          data['logical_map_name']!,
          _logicalMapNameMeta,
        ),
      );
    }
    if (data.containsKey('floor_number')) {
      context.handle(
        _floorNumberMeta,
        floorNumber.isAcceptableOrUnknown(
          data['floor_number']!,
          _floorNumberMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MapAsset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MapAsset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      logicalMapName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logical_map_name'],
      )!,
      floorNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}floor_number'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
    );
  }

  @override
  $MapAssetsTable createAlias(String alias) {
    return $MapAssetsTable(attachedDatabase, alias);
  }
}

class MapAsset extends DataClass implements Insertable<MapAsset> {
  final int id;
  final String name;
  final String logicalMapName;
  final int floorNumber;
  final String imagePath;
  final int width;
  final int height;
  const MapAsset({
    required this.id,
    required this.name,
    required this.logicalMapName,
    required this.floorNumber,
    required this.imagePath,
    required this.width,
    required this.height,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['logical_map_name'] = Variable<String>(logicalMapName);
    map['floor_number'] = Variable<int>(floorNumber);
    map['image_path'] = Variable<String>(imagePath);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    return map;
  }

  MapAssetsCompanion toCompanion(bool nullToAbsent) {
    return MapAssetsCompanion(
      id: Value(id),
      name: Value(name),
      logicalMapName: Value(logicalMapName),
      floorNumber: Value(floorNumber),
      imagePath: Value(imagePath),
      width: Value(width),
      height: Value(height),
    );
  }

  factory MapAsset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MapAsset(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      logicalMapName: serializer.fromJson<String>(json['logicalMapName']),
      floorNumber: serializer.fromJson<int>(json['floorNumber']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'logicalMapName': serializer.toJson<String>(logicalMapName),
      'floorNumber': serializer.toJson<int>(floorNumber),
      'imagePath': serializer.toJson<String>(imagePath),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
    };
  }

  MapAsset copyWith({
    int? id,
    String? name,
    String? logicalMapName,
    int? floorNumber,
    String? imagePath,
    int? width,
    int? height,
  }) => MapAsset(
    id: id ?? this.id,
    name: name ?? this.name,
    logicalMapName: logicalMapName ?? this.logicalMapName,
    floorNumber: floorNumber ?? this.floorNumber,
    imagePath: imagePath ?? this.imagePath,
    width: width ?? this.width,
    height: height ?? this.height,
  );
  MapAsset copyWithCompanion(MapAssetsCompanion data) {
    return MapAsset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      logicalMapName: data.logicalMapName.present
          ? data.logicalMapName.value
          : this.logicalMapName,
      floorNumber: data.floorNumber.present
          ? data.floorNumber.value
          : this.floorNumber,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MapAsset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('logicalMapName: $logicalMapName, ')
          ..write('floorNumber: $floorNumber, ')
          ..write('imagePath: $imagePath, ')
          ..write('width: $width, ')
          ..write('height: $height')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    logicalMapName,
    floorNumber,
    imagePath,
    width,
    height,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MapAsset &&
          other.id == this.id &&
          other.name == this.name &&
          other.logicalMapName == this.logicalMapName &&
          other.floorNumber == this.floorNumber &&
          other.imagePath == this.imagePath &&
          other.width == this.width &&
          other.height == this.height);
}

class MapAssetsCompanion extends UpdateCompanion<MapAsset> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> logicalMapName;
  final Value<int> floorNumber;
  final Value<String> imagePath;
  final Value<int> width;
  final Value<int> height;
  const MapAssetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.logicalMapName = const Value.absent(),
    this.floorNumber = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
  });
  MapAssetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.logicalMapName = const Value.absent(),
    this.floorNumber = const Value.absent(),
    required String imagePath,
    required int width,
    required int height,
  }) : name = Value(name),
       imagePath = Value(imagePath),
       width = Value(width),
       height = Value(height);
  static Insertable<MapAsset> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? logicalMapName,
    Expression<int>? floorNumber,
    Expression<String>? imagePath,
    Expression<int>? width,
    Expression<int>? height,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (logicalMapName != null) 'logical_map_name': logicalMapName,
      if (floorNumber != null) 'floor_number': floorNumber,
      if (imagePath != null) 'image_path': imagePath,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
    });
  }

  MapAssetsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? logicalMapName,
    Value<int>? floorNumber,
    Value<String>? imagePath,
    Value<int>? width,
    Value<int>? height,
  }) {
    return MapAssetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      logicalMapName: logicalMapName ?? this.logicalMapName,
      floorNumber: floorNumber ?? this.floorNumber,
      imagePath: imagePath ?? this.imagePath,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (logicalMapName.present) {
      map['logical_map_name'] = Variable<String>(logicalMapName.value);
    }
    if (floorNumber.present) {
      map['floor_number'] = Variable<int>(floorNumber.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MapAssetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('logicalMapName: $logicalMapName, ')
          ..write('floorNumber: $floorNumber, ')
          ..write('imagePath: $imagePath, ')
          ..write('width: $width, ')
          ..write('height: $height')
          ..write(')'))
        .toString();
  }
}

class $BattlePlansTable extends BattlePlans
    with TableInfo<$BattlePlansTable, BattlePlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BattlePlansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mapIdMeta = const VerificationMeta('mapId');
  @override
  late final GeneratedColumn<int> mapId = GeneratedColumn<int>(
    'map_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES map_assets (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, mapId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'battle_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<BattlePlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('map_id')) {
      context.handle(
        _mapIdMeta,
        mapId.isAcceptableOrUnknown(data['map_id']!, _mapIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mapIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BattlePlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BattlePlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mapId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}map_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BattlePlansTable createAlias(String alias) {
    return $BattlePlansTable(attachedDatabase, alias);
  }
}

class BattlePlan extends DataClass implements Insertable<BattlePlan> {
  final int id;
  final String name;
  final int mapId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BattlePlan({
    required this.id,
    required this.name,
    required this.mapId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['map_id'] = Variable<int>(mapId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BattlePlansCompanion toCompanion(bool nullToAbsent) {
    return BattlePlansCompanion(
      id: Value(id),
      name: Value(name),
      mapId: Value(mapId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BattlePlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BattlePlan(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mapId: serializer.fromJson<int>(json['mapId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'mapId': serializer.toJson<int>(mapId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BattlePlan copyWith({
    int? id,
    String? name,
    int? mapId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BattlePlan(
    id: id ?? this.id,
    name: name ?? this.name,
    mapId: mapId ?? this.mapId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BattlePlan copyWithCompanion(BattlePlansCompanion data) {
    return BattlePlan(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mapId: data.mapId.present ? data.mapId.value : this.mapId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BattlePlan(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mapId: $mapId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, mapId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattlePlan &&
          other.id == this.id &&
          other.name == this.name &&
          other.mapId == this.mapId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BattlePlansCompanion extends UpdateCompanion<BattlePlan> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> mapId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BattlePlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mapId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BattlePlansCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int mapId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       mapId = Value(mapId);
  static Insertable<BattlePlan> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? mapId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mapId != null) 'map_id': mapId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BattlePlansCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? mapId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BattlePlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mapId: mapId ?? this.mapId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mapId.present) {
      map['map_id'] = Variable<int>(mapId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BattlePlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mapId: $mapId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BattlePlanStepsTable extends BattlePlanSteps
    with TableInfo<$BattlePlanStepsTable, BattlePlanStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BattlePlanStepsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _battlePlanIdMeta = const VerificationMeta(
    'battlePlanId',
  );
  @override
  late final GeneratedColumn<int> battlePlanId = GeneratedColumn<int>(
    'battle_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES battle_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("order_index" >= 0)',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    battlePlanId,
    title,
    orderIndex,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'battle_plan_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<BattlePlanStep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('battle_plan_id')) {
      context.handle(
        _battlePlanIdMeta,
        battlePlanId.isAcceptableOrUnknown(
          data['battle_plan_id']!,
          _battlePlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_battlePlanIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BattlePlanStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BattlePlanStep(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      battlePlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}battle_plan_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BattlePlanStepsTable createAlias(String alias) {
    return $BattlePlanStepsTable(attachedDatabase, alias);
  }
}

class BattlePlanStep extends DataClass implements Insertable<BattlePlanStep> {
  final int id;
  final int battlePlanId;
  final String title;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BattlePlanStep({
    required this.id,
    required this.battlePlanId,
    required this.title,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['battle_plan_id'] = Variable<int>(battlePlanId);
    map['title'] = Variable<String>(title);
    map['order_index'] = Variable<int>(orderIndex);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BattlePlanStepsCompanion toCompanion(bool nullToAbsent) {
    return BattlePlanStepsCompanion(
      id: Value(id),
      battlePlanId: Value(battlePlanId),
      title: Value(title),
      orderIndex: Value(orderIndex),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BattlePlanStep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BattlePlanStep(
      id: serializer.fromJson<int>(json['id']),
      battlePlanId: serializer.fromJson<int>(json['battlePlanId']),
      title: serializer.fromJson<String>(json['title']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'battlePlanId': serializer.toJson<int>(battlePlanId),
      'title': serializer.toJson<String>(title),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BattlePlanStep copyWith({
    int? id,
    int? battlePlanId,
    String? title,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BattlePlanStep(
    id: id ?? this.id,
    battlePlanId: battlePlanId ?? this.battlePlanId,
    title: title ?? this.title,
    orderIndex: orderIndex ?? this.orderIndex,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BattlePlanStep copyWithCompanion(BattlePlanStepsCompanion data) {
    return BattlePlanStep(
      id: data.id.present ? data.id.value : this.id,
      battlePlanId: data.battlePlanId.present
          ? data.battlePlanId.value
          : this.battlePlanId,
      title: data.title.present ? data.title.value : this.title,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BattlePlanStep(')
          ..write('id: $id, ')
          ..write('battlePlanId: $battlePlanId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, battlePlanId, title, orderIndex, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattlePlanStep &&
          other.id == this.id &&
          other.battlePlanId == this.battlePlanId &&
          other.title == this.title &&
          other.orderIndex == this.orderIndex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BattlePlanStepsCompanion extends UpdateCompanion<BattlePlanStep> {
  final Value<int> id;
  final Value<int> battlePlanId;
  final Value<String> title;
  final Value<int> orderIndex;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BattlePlanStepsCompanion({
    this.id = const Value.absent(),
    this.battlePlanId = const Value.absent(),
    this.title = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BattlePlanStepsCompanion.insert({
    this.id = const Value.absent(),
    required int battlePlanId,
    required String title,
    required int orderIndex,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : battlePlanId = Value(battlePlanId),
       title = Value(title),
       orderIndex = Value(orderIndex);
  static Insertable<BattlePlanStep> custom({
    Expression<int>? id,
    Expression<int>? battlePlanId,
    Expression<String>? title,
    Expression<int>? orderIndex,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (battlePlanId != null) 'battle_plan_id': battlePlanId,
      if (title != null) 'title': title,
      if (orderIndex != null) 'order_index': orderIndex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BattlePlanStepsCompanion copyWith({
    Value<int>? id,
    Value<int>? battlePlanId,
    Value<String>? title,
    Value<int>? orderIndex,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BattlePlanStepsCompanion(
      id: id ?? this.id,
      battlePlanId: battlePlanId ?? this.battlePlanId,
      title: title ?? this.title,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (battlePlanId.present) {
      map['battle_plan_id'] = Variable<int>(battlePlanId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BattlePlanStepsCompanion(')
          ..write('id: $id, ')
          ..write('battlePlanId: $battlePlanId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PlanElementsTable extends PlanElements
    with TableInfo<$PlanElementsTable, PlanElement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanElementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _battlePlanIdMeta = const VerificationMeta(
    'battlePlanId',
  );
  @override
  late final GeneratedColumn<int> battlePlanId = GeneratedColumn<int>(
    'battle_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES battle_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<double> width = GeneratedColumn<double>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("width" >= 0)',
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("height" >= 0)',
  );
  static const VerificationMeta _rotationMeta = const VerificationMeta(
    'rotation',
  );
  @override
  late final GeneratedColumn<double> rotation = GeneratedColumn<double>(
    'rotation',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extraJsonMeta = const VerificationMeta(
    'extraJson',
  );
  @override
  late final GeneratedColumn<String> extraJson = GeneratedColumn<String>(
    'extra_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    battlePlanId,
    type,
    x,
    y,
    width,
    height,
    rotation,
    color,
    label,
    extraJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_elements';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanElement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('battle_plan_id')) {
      context.handle(
        _battlePlanIdMeta,
        battlePlanId.isAcceptableOrUnknown(
          data['battle_plan_id']!,
          _battlePlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_battlePlanIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('rotation')) {
      context.handle(
        _rotationMeta,
        rotation.isAcceptableOrUnknown(data['rotation']!, _rotationMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('extra_json')) {
      context.handle(
        _extraJsonMeta,
        extraJson.isAcceptableOrUnknown(data['extra_json']!, _extraJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanElement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanElement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      battlePlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}battle_plan_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}y'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      )!,
      rotation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rotation'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      extraJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_json'],
      ),
    );
  }

  @override
  $PlanElementsTable createAlias(String alias) {
    return $PlanElementsTable(attachedDatabase, alias);
  }
}

class PlanElement extends DataClass implements Insertable<PlanElement> {
  final int id;
  final int battlePlanId;
  final String type;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final int color;
  final String? label;
  final String? extraJson;
  const PlanElement({
    required this.id,
    required this.battlePlanId,
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rotation,
    required this.color,
    this.label,
    this.extraJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['battle_plan_id'] = Variable<int>(battlePlanId);
    map['type'] = Variable<String>(type);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['width'] = Variable<double>(width);
    map['height'] = Variable<double>(height);
    map['rotation'] = Variable<double>(rotation);
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || extraJson != null) {
      map['extra_json'] = Variable<String>(extraJson);
    }
    return map;
  }

  PlanElementsCompanion toCompanion(bool nullToAbsent) {
    return PlanElementsCompanion(
      id: Value(id),
      battlePlanId: Value(battlePlanId),
      type: Value(type),
      x: Value(x),
      y: Value(y),
      width: Value(width),
      height: Value(height),
      rotation: Value(rotation),
      color: Value(color),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      extraJson: extraJson == null && nullToAbsent
          ? const Value.absent()
          : Value(extraJson),
    );
  }

  factory PlanElement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanElement(
      id: serializer.fromJson<int>(json['id']),
      battlePlanId: serializer.fromJson<int>(json['battlePlanId']),
      type: serializer.fromJson<String>(json['type']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      width: serializer.fromJson<double>(json['width']),
      height: serializer.fromJson<double>(json['height']),
      rotation: serializer.fromJson<double>(json['rotation']),
      color: serializer.fromJson<int>(json['color']),
      label: serializer.fromJson<String?>(json['label']),
      extraJson: serializer.fromJson<String?>(json['extraJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'battlePlanId': serializer.toJson<int>(battlePlanId),
      'type': serializer.toJson<String>(type),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'width': serializer.toJson<double>(width),
      'height': serializer.toJson<double>(height),
      'rotation': serializer.toJson<double>(rotation),
      'color': serializer.toJson<int>(color),
      'label': serializer.toJson<String?>(label),
      'extraJson': serializer.toJson<String?>(extraJson),
    };
  }

  PlanElement copyWith({
    int? id,
    int? battlePlanId,
    String? type,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    int? color,
    Value<String?> label = const Value.absent(),
    Value<String?> extraJson = const Value.absent(),
  }) => PlanElement(
    id: id ?? this.id,
    battlePlanId: battlePlanId ?? this.battlePlanId,
    type: type ?? this.type,
    x: x ?? this.x,
    y: y ?? this.y,
    width: width ?? this.width,
    height: height ?? this.height,
    rotation: rotation ?? this.rotation,
    color: color ?? this.color,
    label: label.present ? label.value : this.label,
    extraJson: extraJson.present ? extraJson.value : this.extraJson,
  );
  PlanElement copyWithCompanion(PlanElementsCompanion data) {
    return PlanElement(
      id: data.id.present ? data.id.value : this.id,
      battlePlanId: data.battlePlanId.present
          ? data.battlePlanId.value
          : this.battlePlanId,
      type: data.type.present ? data.type.value : this.type,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      rotation: data.rotation.present ? data.rotation.value : this.rotation,
      color: data.color.present ? data.color.value : this.color,
      label: data.label.present ? data.label.value : this.label,
      extraJson: data.extraJson.present ? data.extraJson.value : this.extraJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanElement(')
          ..write('id: $id, ')
          ..write('battlePlanId: $battlePlanId, ')
          ..write('type: $type, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rotation: $rotation, ')
          ..write('color: $color, ')
          ..write('label: $label, ')
          ..write('extraJson: $extraJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    battlePlanId,
    type,
    x,
    y,
    width,
    height,
    rotation,
    color,
    label,
    extraJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanElement &&
          other.id == this.id &&
          other.battlePlanId == this.battlePlanId &&
          other.type == this.type &&
          other.x == this.x &&
          other.y == this.y &&
          other.width == this.width &&
          other.height == this.height &&
          other.rotation == this.rotation &&
          other.color == this.color &&
          other.label == this.label &&
          other.extraJson == this.extraJson);
}

class PlanElementsCompanion extends UpdateCompanion<PlanElement> {
  final Value<int> id;
  final Value<int> battlePlanId;
  final Value<String> type;
  final Value<double> x;
  final Value<double> y;
  final Value<double> width;
  final Value<double> height;
  final Value<double> rotation;
  final Value<int> color;
  final Value<String?> label;
  final Value<String?> extraJson;
  const PlanElementsCompanion({
    this.id = const Value.absent(),
    this.battlePlanId = const Value.absent(),
    this.type = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rotation = const Value.absent(),
    this.color = const Value.absent(),
    this.label = const Value.absent(),
    this.extraJson = const Value.absent(),
  });
  PlanElementsCompanion.insert({
    this.id = const Value.absent(),
    required int battlePlanId,
    required String type,
    required double x,
    required double y,
    required double width,
    required double height,
    this.rotation = const Value.absent(),
    required int color,
    this.label = const Value.absent(),
    this.extraJson = const Value.absent(),
  }) : battlePlanId = Value(battlePlanId),
       type = Value(type),
       x = Value(x),
       y = Value(y),
       width = Value(width),
       height = Value(height),
       color = Value(color);
  static Insertable<PlanElement> custom({
    Expression<int>? id,
    Expression<int>? battlePlanId,
    Expression<String>? type,
    Expression<double>? x,
    Expression<double>? y,
    Expression<double>? width,
    Expression<double>? height,
    Expression<double>? rotation,
    Expression<int>? color,
    Expression<String>? label,
    Expression<String>? extraJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (battlePlanId != null) 'battle_plan_id': battlePlanId,
      if (type != null) 'type': type,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (rotation != null) 'rotation': rotation,
      if (color != null) 'color': color,
      if (label != null) 'label': label,
      if (extraJson != null) 'extra_json': extraJson,
    });
  }

  PlanElementsCompanion copyWith({
    Value<int>? id,
    Value<int>? battlePlanId,
    Value<String>? type,
    Value<double>? x,
    Value<double>? y,
    Value<double>? width,
    Value<double>? height,
    Value<double>? rotation,
    Value<int>? color,
    Value<String?>? label,
    Value<String?>? extraJson,
  }) {
    return PlanElementsCompanion(
      id: id ?? this.id,
      battlePlanId: battlePlanId ?? this.battlePlanId,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      color: color ?? this.color,
      label: label ?? this.label,
      extraJson: extraJson ?? this.extraJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (battlePlanId.present) {
      map['battle_plan_id'] = Variable<int>(battlePlanId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (rotation.present) {
      map['rotation'] = Variable<double>(rotation.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (extraJson.present) {
      map['extra_json'] = Variable<String>(extraJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanElementsCompanion(')
          ..write('id: $id, ')
          ..write('battlePlanId: $battlePlanId, ')
          ..write('type: $type, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rotation: $rotation, ')
          ..write('color: $color, ')
          ..write('label: $label, ')
          ..write('extraJson: $extraJson')
          ..write(')'))
        .toString();
  }
}

class $BattlePlanStepElementStatesTable extends BattlePlanStepElementStates
    with
        TableInfo<
          $BattlePlanStepElementStatesTable,
          BattlePlanStepElementState
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BattlePlanStepElementStatesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _stepIdMeta = const VerificationMeta('stepId');
  @override
  late final GeneratedColumn<int> stepId = GeneratedColumn<int>(
    'step_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES battle_plan_steps (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _planElementIdMeta = const VerificationMeta(
    'planElementId',
  );
  @override
  late final GeneratedColumn<int> planElementId = GeneratedColumn<int>(
    'plan_element_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plan_elements (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<double> width = GeneratedColumn<double>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("width" >= 0)',
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("height" >= 0)',
  );
  static const VerificationMeta _rotationMeta = const VerificationMeta(
    'rotation',
  );
  @override
  late final GeneratedColumn<double> rotation = GeneratedColumn<double>(
    'rotation',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVisibleMeta = const VerificationMeta(
    'isVisible',
  );
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
    'is_visible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_visible" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stepId,
    planElementId,
    x,
    y,
    width,
    height,
    rotation,
    color,
    label,
    isVisible,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'battle_plan_step_element_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<BattlePlanStepElementState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('step_id')) {
      context.handle(
        _stepIdMeta,
        stepId.isAcceptableOrUnknown(data['step_id']!, _stepIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stepIdMeta);
    }
    if (data.containsKey('plan_element_id')) {
      context.handle(
        _planElementIdMeta,
        planElementId.isAcceptableOrUnknown(
          data['plan_element_id']!,
          _planElementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_planElementIdMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('rotation')) {
      context.handle(
        _rotationMeta,
        rotation.isAcceptableOrUnknown(data['rotation']!, _rotationMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('is_visible')) {
      context.handle(
        _isVisibleMeta,
        isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {stepId, planElementId},
  ];
  @override
  BattlePlanStepElementState map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BattlePlanStepElementState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      stepId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_id'],
      )!,
      planElementId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_element_id'],
      )!,
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}y'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      )!,
      rotation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rotation'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      isVisible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_visible'],
      )!,
    );
  }

  @override
  $BattlePlanStepElementStatesTable createAlias(String alias) {
    return $BattlePlanStepElementStatesTable(attachedDatabase, alias);
  }
}

class BattlePlanStepElementState extends DataClass
    implements Insertable<BattlePlanStepElementState> {
  final int id;
  final int stepId;
  final int planElementId;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final int color;
  final String? label;
  final bool isVisible;
  const BattlePlanStepElementState({
    required this.id,
    required this.stepId,
    required this.planElementId,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rotation,
    required this.color,
    this.label,
    required this.isVisible,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['step_id'] = Variable<int>(stepId);
    map['plan_element_id'] = Variable<int>(planElementId);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['width'] = Variable<double>(width);
    map['height'] = Variable<double>(height);
    map['rotation'] = Variable<double>(rotation);
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['is_visible'] = Variable<bool>(isVisible);
    return map;
  }

  BattlePlanStepElementStatesCompanion toCompanion(bool nullToAbsent) {
    return BattlePlanStepElementStatesCompanion(
      id: Value(id),
      stepId: Value(stepId),
      planElementId: Value(planElementId),
      x: Value(x),
      y: Value(y),
      width: Value(width),
      height: Value(height),
      rotation: Value(rotation),
      color: Value(color),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      isVisible: Value(isVisible),
    );
  }

  factory BattlePlanStepElementState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BattlePlanStepElementState(
      id: serializer.fromJson<int>(json['id']),
      stepId: serializer.fromJson<int>(json['stepId']),
      planElementId: serializer.fromJson<int>(json['planElementId']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      width: serializer.fromJson<double>(json['width']),
      height: serializer.fromJson<double>(json['height']),
      rotation: serializer.fromJson<double>(json['rotation']),
      color: serializer.fromJson<int>(json['color']),
      label: serializer.fromJson<String?>(json['label']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'stepId': serializer.toJson<int>(stepId),
      'planElementId': serializer.toJson<int>(planElementId),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'width': serializer.toJson<double>(width),
      'height': serializer.toJson<double>(height),
      'rotation': serializer.toJson<double>(rotation),
      'color': serializer.toJson<int>(color),
      'label': serializer.toJson<String?>(label),
      'isVisible': serializer.toJson<bool>(isVisible),
    };
  }

  BattlePlanStepElementState copyWith({
    int? id,
    int? stepId,
    int? planElementId,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    int? color,
    Value<String?> label = const Value.absent(),
    bool? isVisible,
  }) => BattlePlanStepElementState(
    id: id ?? this.id,
    stepId: stepId ?? this.stepId,
    planElementId: planElementId ?? this.planElementId,
    x: x ?? this.x,
    y: y ?? this.y,
    width: width ?? this.width,
    height: height ?? this.height,
    rotation: rotation ?? this.rotation,
    color: color ?? this.color,
    label: label.present ? label.value : this.label,
    isVisible: isVisible ?? this.isVisible,
  );
  BattlePlanStepElementState copyWithCompanion(
    BattlePlanStepElementStatesCompanion data,
  ) {
    return BattlePlanStepElementState(
      id: data.id.present ? data.id.value : this.id,
      stepId: data.stepId.present ? data.stepId.value : this.stepId,
      planElementId: data.planElementId.present
          ? data.planElementId.value
          : this.planElementId,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      rotation: data.rotation.present ? data.rotation.value : this.rotation,
      color: data.color.present ? data.color.value : this.color,
      label: data.label.present ? data.label.value : this.label,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BattlePlanStepElementState(')
          ..write('id: $id, ')
          ..write('stepId: $stepId, ')
          ..write('planElementId: $planElementId, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rotation: $rotation, ')
          ..write('color: $color, ')
          ..write('label: $label, ')
          ..write('isVisible: $isVisible')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    stepId,
    planElementId,
    x,
    y,
    width,
    height,
    rotation,
    color,
    label,
    isVisible,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattlePlanStepElementState &&
          other.id == this.id &&
          other.stepId == this.stepId &&
          other.planElementId == this.planElementId &&
          other.x == this.x &&
          other.y == this.y &&
          other.width == this.width &&
          other.height == this.height &&
          other.rotation == this.rotation &&
          other.color == this.color &&
          other.label == this.label &&
          other.isVisible == this.isVisible);
}

class BattlePlanStepElementStatesCompanion
    extends UpdateCompanion<BattlePlanStepElementState> {
  final Value<int> id;
  final Value<int> stepId;
  final Value<int> planElementId;
  final Value<double> x;
  final Value<double> y;
  final Value<double> width;
  final Value<double> height;
  final Value<double> rotation;
  final Value<int> color;
  final Value<String?> label;
  final Value<bool> isVisible;
  const BattlePlanStepElementStatesCompanion({
    this.id = const Value.absent(),
    this.stepId = const Value.absent(),
    this.planElementId = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rotation = const Value.absent(),
    this.color = const Value.absent(),
    this.label = const Value.absent(),
    this.isVisible = const Value.absent(),
  });
  BattlePlanStepElementStatesCompanion.insert({
    this.id = const Value.absent(),
    required int stepId,
    required int planElementId,
    required double x,
    required double y,
    required double width,
    required double height,
    this.rotation = const Value.absent(),
    required int color,
    this.label = const Value.absent(),
    this.isVisible = const Value.absent(),
  }) : stepId = Value(stepId),
       planElementId = Value(planElementId),
       x = Value(x),
       y = Value(y),
       width = Value(width),
       height = Value(height),
       color = Value(color);
  static Insertable<BattlePlanStepElementState> custom({
    Expression<int>? id,
    Expression<int>? stepId,
    Expression<int>? planElementId,
    Expression<double>? x,
    Expression<double>? y,
    Expression<double>? width,
    Expression<double>? height,
    Expression<double>? rotation,
    Expression<int>? color,
    Expression<String>? label,
    Expression<bool>? isVisible,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stepId != null) 'step_id': stepId,
      if (planElementId != null) 'plan_element_id': planElementId,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (rotation != null) 'rotation': rotation,
      if (color != null) 'color': color,
      if (label != null) 'label': label,
      if (isVisible != null) 'is_visible': isVisible,
    });
  }

  BattlePlanStepElementStatesCompanion copyWith({
    Value<int>? id,
    Value<int>? stepId,
    Value<int>? planElementId,
    Value<double>? x,
    Value<double>? y,
    Value<double>? width,
    Value<double>? height,
    Value<double>? rotation,
    Value<int>? color,
    Value<String?>? label,
    Value<bool>? isVisible,
  }) {
    return BattlePlanStepElementStatesCompanion(
      id: id ?? this.id,
      stepId: stepId ?? this.stepId,
      planElementId: planElementId ?? this.planElementId,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      color: color ?? this.color,
      label: label ?? this.label,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (stepId.present) {
      map['step_id'] = Variable<int>(stepId.value);
    }
    if (planElementId.present) {
      map['plan_element_id'] = Variable<int>(planElementId.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (rotation.present) {
      map['rotation'] = Variable<double>(rotation.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BattlePlanStepElementStatesCompanion(')
          ..write('id: $id, ')
          ..write('stepId: $stepId, ')
          ..write('planElementId: $planElementId, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rotation: $rotation, ')
          ..write('color: $color, ')
          ..write('label: $label, ')
          ..write('isVisible: $isVisible')
          ..write(')'))
        .toString();
  }
}

class $WeaponsTable extends Weapons with TableInfo<$WeaponsTable, Weapon> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeaponsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _damageMeta = const VerificationMeta('damage');
  @override
  late final GeneratedColumn<int> damage = GeneratedColumn<int>(
    'damage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("damage" >= 0)',
  );
  static const VerificationMeta _fireRateMeta = const VerificationMeta(
    'fireRate',
  );
  @override
  late final GeneratedColumn<double> fireRate = GeneratedColumn<double>(
    'fire_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("fire_rate" >= 0)',
  );
  static const VerificationMeta _ammoMeta = const VerificationMeta('ammo');
  @override
  late final GeneratedColumn<int> ammo = GeneratedColumn<int>(
    'ammo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("ammo" >= 0)',
  );
  static const VerificationMeta _reloadTimeMeta = const VerificationMeta(
    'reloadTime',
  );
  @override
  late final GeneratedColumn<double> reloadTime = GeneratedColumn<double>(
    'reload_time',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("reload_time" >= 0)',
  );
  static const VerificationMeta _rangeMeta = const VerificationMeta('range');
  @override
  late final GeneratedColumn<double> range = GeneratedColumn<double>(
    'range',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("range" >= 0)',
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 4000,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    imagePath,
    damage,
    fireRate,
    ammo,
    reloadTime,
    range,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weapons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Weapon> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('damage')) {
      context.handle(
        _damageMeta,
        damage.isAcceptableOrUnknown(data['damage']!, _damageMeta),
      );
    } else if (isInserting) {
      context.missing(_damageMeta);
    }
    if (data.containsKey('fire_rate')) {
      context.handle(
        _fireRateMeta,
        fireRate.isAcceptableOrUnknown(data['fire_rate']!, _fireRateMeta),
      );
    } else if (isInserting) {
      context.missing(_fireRateMeta);
    }
    if (data.containsKey('ammo')) {
      context.handle(
        _ammoMeta,
        ammo.isAcceptableOrUnknown(data['ammo']!, _ammoMeta),
      );
    } else if (isInserting) {
      context.missing(_ammoMeta);
    }
    if (data.containsKey('reload_time')) {
      context.handle(
        _reloadTimeMeta,
        reloadTime.isAcceptableOrUnknown(data['reload_time']!, _reloadTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_reloadTimeMeta);
    }
    if (data.containsKey('range')) {
      context.handle(
        _rangeMeta,
        range.isAcceptableOrUnknown(data['range']!, _rangeMeta),
      );
    } else if (isInserting) {
      context.missing(_rangeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Weapon map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Weapon(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      damage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damage'],
      )!,
      fireRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fire_rate'],
      )!,
      ammo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ammo'],
      )!,
      reloadTime: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reload_time'],
      )!,
      range: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}range'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $WeaponsTable createAlias(String alias) {
    return $WeaponsTable(attachedDatabase, alias);
  }
}

class Weapon extends DataClass implements Insertable<Weapon> {
  final int id;
  final String name;
  final String category;
  final String imagePath;
  final int damage;
  final double fireRate;
  final int ammo;
  final double reloadTime;
  final double range;
  final String description;
  const Weapon({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.damage,
    required this.fireRate,
    required this.ammo,
    required this.reloadTime,
    required this.range,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['image_path'] = Variable<String>(imagePath);
    map['damage'] = Variable<int>(damage);
    map['fire_rate'] = Variable<double>(fireRate);
    map['ammo'] = Variable<int>(ammo);
    map['reload_time'] = Variable<double>(reloadTime);
    map['range'] = Variable<double>(range);
    map['description'] = Variable<String>(description);
    return map;
  }

  WeaponsCompanion toCompanion(bool nullToAbsent) {
    return WeaponsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      imagePath: Value(imagePath),
      damage: Value(damage),
      fireRate: Value(fireRate),
      ammo: Value(ammo),
      reloadTime: Value(reloadTime),
      range: Value(range),
      description: Value(description),
    );
  }

  factory Weapon.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Weapon(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      damage: serializer.fromJson<int>(json['damage']),
      fireRate: serializer.fromJson<double>(json['fireRate']),
      ammo: serializer.fromJson<int>(json['ammo']),
      reloadTime: serializer.fromJson<double>(json['reloadTime']),
      range: serializer.fromJson<double>(json['range']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'imagePath': serializer.toJson<String>(imagePath),
      'damage': serializer.toJson<int>(damage),
      'fireRate': serializer.toJson<double>(fireRate),
      'ammo': serializer.toJson<int>(ammo),
      'reloadTime': serializer.toJson<double>(reloadTime),
      'range': serializer.toJson<double>(range),
      'description': serializer.toJson<String>(description),
    };
  }

  Weapon copyWith({
    int? id,
    String? name,
    String? category,
    String? imagePath,
    int? damage,
    double? fireRate,
    int? ammo,
    double? reloadTime,
    double? range,
    String? description,
  }) => Weapon(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    imagePath: imagePath ?? this.imagePath,
    damage: damage ?? this.damage,
    fireRate: fireRate ?? this.fireRate,
    ammo: ammo ?? this.ammo,
    reloadTime: reloadTime ?? this.reloadTime,
    range: range ?? this.range,
    description: description ?? this.description,
  );
  Weapon copyWithCompanion(WeaponsCompanion data) {
    return Weapon(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      damage: data.damage.present ? data.damage.value : this.damage,
      fireRate: data.fireRate.present ? data.fireRate.value : this.fireRate,
      ammo: data.ammo.present ? data.ammo.value : this.ammo,
      reloadTime: data.reloadTime.present
          ? data.reloadTime.value
          : this.reloadTime,
      range: data.range.present ? data.range.value : this.range,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Weapon(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('imagePath: $imagePath, ')
          ..write('damage: $damage, ')
          ..write('fireRate: $fireRate, ')
          ..write('ammo: $ammo, ')
          ..write('reloadTime: $reloadTime, ')
          ..write('range: $range, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    imagePath,
    damage,
    fireRate,
    ammo,
    reloadTime,
    range,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Weapon &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.imagePath == this.imagePath &&
          other.damage == this.damage &&
          other.fireRate == this.fireRate &&
          other.ammo == this.ammo &&
          other.reloadTime == this.reloadTime &&
          other.range == this.range &&
          other.description == this.description);
}

class WeaponsCompanion extends UpdateCompanion<Weapon> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String> imagePath;
  final Value<int> damage;
  final Value<double> fireRate;
  final Value<int> ammo;
  final Value<double> reloadTime;
  final Value<double> range;
  final Value<String> description;
  const WeaponsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.damage = const Value.absent(),
    this.fireRate = const Value.absent(),
    this.ammo = const Value.absent(),
    this.reloadTime = const Value.absent(),
    this.range = const Value.absent(),
    this.description = const Value.absent(),
  });
  WeaponsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    required String imagePath,
    required int damage,
    required double fireRate,
    required int ammo,
    required double reloadTime,
    required double range,
    required String description,
  }) : name = Value(name),
       category = Value(category),
       imagePath = Value(imagePath),
       damage = Value(damage),
       fireRate = Value(fireRate),
       ammo = Value(ammo),
       reloadTime = Value(reloadTime),
       range = Value(range),
       description = Value(description);
  static Insertable<Weapon> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? imagePath,
    Expression<int>? damage,
    Expression<double>? fireRate,
    Expression<int>? ammo,
    Expression<double>? reloadTime,
    Expression<double>? range,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (imagePath != null) 'image_path': imagePath,
      if (damage != null) 'damage': damage,
      if (fireRate != null) 'fire_rate': fireRate,
      if (ammo != null) 'ammo': ammo,
      if (reloadTime != null) 'reload_time': reloadTime,
      if (range != null) 'range': range,
      if (description != null) 'description': description,
    });
  }

  WeaponsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String>? imagePath,
    Value<int>? damage,
    Value<double>? fireRate,
    Value<int>? ammo,
    Value<double>? reloadTime,
    Value<double>? range,
    Value<String>? description,
  }) {
    return WeaponsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      damage: damage ?? this.damage,
      fireRate: fireRate ?? this.fireRate,
      ammo: ammo ?? this.ammo,
      reloadTime: reloadTime ?? this.reloadTime,
      range: range ?? this.range,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (damage.present) {
      map['damage'] = Variable<int>(damage.value);
    }
    if (fireRate.present) {
      map['fire_rate'] = Variable<double>(fireRate.value);
    }
    if (ammo.present) {
      map['ammo'] = Variable<int>(ammo.value);
    }
    if (reloadTime.present) {
      map['reload_time'] = Variable<double>(reloadTime.value);
    }
    if (range.present) {
      map['range'] = Variable<double>(range.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeaponsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('imagePath: $imagePath, ')
          ..write('damage: $damage, ')
          ..write('fireRate: $fireRate, ')
          ..write('ammo: $ammo, ')
          ..write('reloadTime: $reloadTime, ')
          ..write('range: $range, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $WeaponAdvancedStatsTable extends WeaponAdvancedStats
    with TableInfo<$WeaponAdvancedStatsTable, WeaponAdvancedStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeaponAdvancedStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _weaponIdMeta = const VerificationMeta(
    'weaponId',
  );
  @override
  late final GeneratedColumn<int> weaponId = GeneratedColumn<int>(
    'weapon_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES weapons (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _headDamageMeta = const VerificationMeta(
    'headDamage',
  );
  @override
  late final GeneratedColumn<int> headDamage = GeneratedColumn<int>(
    'head_damage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("head_damage" >= 0)',
  );
  static const VerificationMeta _bodyDamageMeta = const VerificationMeta(
    'bodyDamage',
  );
  @override
  late final GeneratedColumn<int> bodyDamage = GeneratedColumn<int>(
    'body_damage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("body_damage" >= 0)',
  );
  static const VerificationMeta _limbDamageMeta = const VerificationMeta(
    'limbDamage',
  );
  @override
  late final GeneratedColumn<int> limbDamage = GeneratedColumn<int>(
    'limb_damage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("limb_damage" >= 0)',
  );
  static const VerificationMeta _preciseHeadDamageMeta = const VerificationMeta(
    'preciseHeadDamage',
  );
  @override
  late final GeneratedColumn<double> preciseHeadDamage =
      GeneratedColumn<double>(
        'precise_head_damage',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _preciseBodyDamageMeta = const VerificationMeta(
    'preciseBodyDamage',
  );
  @override
  late final GeneratedColumn<double> preciseBodyDamage =
      GeneratedColumn<double>(
        'precise_body_damage',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _preciseLimbDamageMeta = const VerificationMeta(
    'preciseLimbDamage',
  );
  @override
  late final GeneratedColumn<double> preciseLimbDamage =
      GeneratedColumn<double>(
        'precise_limb_damage',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _averageDamageMeta = const VerificationMeta(
    'averageDamage',
  );
  @override
  late final GeneratedColumn<double> averageDamage = GeneratedColumn<double>(
    'average_damage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("average_damage" >= 0)',
  );
  static const VerificationMeta _bulletSpreadDegreesMeta =
      const VerificationMeta('bulletSpreadDegrees');
  @override
  late final GeneratedColumn<double> bulletSpreadDegrees =
      GeneratedColumn<double>(
        'bullet_spread_degrees',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL CHECK ("bullet_spread_degrees" >= 0)',
      );
  static const VerificationMeta _bulletVelocityMeta = const VerificationMeta(
    'bulletVelocity',
  );
  @override
  late final GeneratedColumn<double> bulletVelocity = GeneratedColumn<double>(
    'bullet_velocity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("bullet_velocity" >= 0)',
  );
  static const VerificationMeta _equipTimeMeta = const VerificationMeta(
    'equipTime',
  );
  @override
  late final GeneratedColumn<double> equipTime = GeneratedColumn<double>(
    'equip_time',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("equip_time" >= 0)',
  );
  static const VerificationMeta _rangeMinLabelMeta = const VerificationMeta(
    'rangeMinLabel',
  );
  @override
  late final GeneratedColumn<String> rangeMinLabel = GeneratedColumn<String>(
    'range_min_label',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rangeMaxLabelMeta = const VerificationMeta(
    'rangeMaxLabel',
  );
  @override
  late final GeneratedColumn<String> rangeMaxLabel = GeneratedColumn<String>(
    'range_max_label',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mobilityMeta = const VerificationMeta(
    'mobility',
  );
  @override
  late final GeneratedColumn<double> mobility = GeneratedColumn<double>(
    'mobility',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    weaponId,
    headDamage,
    bodyDamage,
    limbDamage,
    preciseHeadDamage,
    preciseBodyDamage,
    preciseLimbDamage,
    averageDamage,
    bulletSpreadDegrees,
    bulletVelocity,
    equipTime,
    rangeMinLabel,
    rangeMaxLabel,
    accuracy,
    mobility,
    tagsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weapon_advanced_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeaponAdvancedStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('weapon_id')) {
      context.handle(
        _weaponIdMeta,
        weaponId.isAcceptableOrUnknown(data['weapon_id']!, _weaponIdMeta),
      );
    }
    if (data.containsKey('head_damage')) {
      context.handle(
        _headDamageMeta,
        headDamage.isAcceptableOrUnknown(data['head_damage']!, _headDamageMeta),
      );
    } else if (isInserting) {
      context.missing(_headDamageMeta);
    }
    if (data.containsKey('body_damage')) {
      context.handle(
        _bodyDamageMeta,
        bodyDamage.isAcceptableOrUnknown(data['body_damage']!, _bodyDamageMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyDamageMeta);
    }
    if (data.containsKey('limb_damage')) {
      context.handle(
        _limbDamageMeta,
        limbDamage.isAcceptableOrUnknown(data['limb_damage']!, _limbDamageMeta),
      );
    } else if (isInserting) {
      context.missing(_limbDamageMeta);
    }
    if (data.containsKey('precise_head_damage')) {
      context.handle(
        _preciseHeadDamageMeta,
        preciseHeadDamage.isAcceptableOrUnknown(
          data['precise_head_damage']!,
          _preciseHeadDamageMeta,
        ),
      );
    }
    if (data.containsKey('precise_body_damage')) {
      context.handle(
        _preciseBodyDamageMeta,
        preciseBodyDamage.isAcceptableOrUnknown(
          data['precise_body_damage']!,
          _preciseBodyDamageMeta,
        ),
      );
    }
    if (data.containsKey('precise_limb_damage')) {
      context.handle(
        _preciseLimbDamageMeta,
        preciseLimbDamage.isAcceptableOrUnknown(
          data['precise_limb_damage']!,
          _preciseLimbDamageMeta,
        ),
      );
    }
    if (data.containsKey('average_damage')) {
      context.handle(
        _averageDamageMeta,
        averageDamage.isAcceptableOrUnknown(
          data['average_damage']!,
          _averageDamageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_averageDamageMeta);
    }
    if (data.containsKey('bullet_spread_degrees')) {
      context.handle(
        _bulletSpreadDegreesMeta,
        bulletSpreadDegrees.isAcceptableOrUnknown(
          data['bullet_spread_degrees']!,
          _bulletSpreadDegreesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bulletSpreadDegreesMeta);
    }
    if (data.containsKey('bullet_velocity')) {
      context.handle(
        _bulletVelocityMeta,
        bulletVelocity.isAcceptableOrUnknown(
          data['bullet_velocity']!,
          _bulletVelocityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bulletVelocityMeta);
    }
    if (data.containsKey('equip_time')) {
      context.handle(
        _equipTimeMeta,
        equipTime.isAcceptableOrUnknown(data['equip_time']!, _equipTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_equipTimeMeta);
    }
    if (data.containsKey('range_min_label')) {
      context.handle(
        _rangeMinLabelMeta,
        rangeMinLabel.isAcceptableOrUnknown(
          data['range_min_label']!,
          _rangeMinLabelMeta,
        ),
      );
    }
    if (data.containsKey('range_max_label')) {
      context.handle(
        _rangeMaxLabelMeta,
        rangeMaxLabel.isAcceptableOrUnknown(
          data['range_max_label']!,
          _rangeMaxLabelMeta,
        ),
      );
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    }
    if (data.containsKey('mobility')) {
      context.handle(
        _mobilityMeta,
        mobility.isAcceptableOrUnknown(data['mobility']!, _mobilityMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {weaponId};
  @override
  WeaponAdvancedStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeaponAdvancedStat(
      weaponId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weapon_id'],
      )!,
      headDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}head_damage'],
      )!,
      bodyDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}body_damage'],
      )!,
      limbDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limb_damage'],
      )!,
      preciseHeadDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precise_head_damage'],
      ),
      preciseBodyDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precise_body_damage'],
      ),
      preciseLimbDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precise_limb_damage'],
      ),
      averageDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_damage'],
      )!,
      bulletSpreadDegrees: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bullet_spread_degrees'],
      )!,
      bulletVelocity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bullet_velocity'],
      )!,
      equipTime: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}equip_time'],
      )!,
      rangeMinLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}range_min_label'],
      ),
      rangeMaxLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}range_max_label'],
      ),
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy'],
      ),
      mobility: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mobility'],
      ),
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      ),
    );
  }

  @override
  $WeaponAdvancedStatsTable createAlias(String alias) {
    return $WeaponAdvancedStatsTable(attachedDatabase, alias);
  }
}

class WeaponAdvancedStat extends DataClass
    implements Insertable<WeaponAdvancedStat> {
  final int weaponId;
  final int headDamage;
  final int bodyDamage;
  final int limbDamage;
  final double? preciseHeadDamage;
  final double? preciseBodyDamage;
  final double? preciseLimbDamage;
  final double averageDamage;
  final double bulletSpreadDegrees;
  final double bulletVelocity;
  final double equipTime;
  final String? rangeMinLabel;
  final String? rangeMaxLabel;
  final double? accuracy;
  final double? mobility;
  final String? tagsJson;
  const WeaponAdvancedStat({
    required this.weaponId,
    required this.headDamage,
    required this.bodyDamage,
    required this.limbDamage,
    this.preciseHeadDamage,
    this.preciseBodyDamage,
    this.preciseLimbDamage,
    required this.averageDamage,
    required this.bulletSpreadDegrees,
    required this.bulletVelocity,
    required this.equipTime,
    this.rangeMinLabel,
    this.rangeMaxLabel,
    this.accuracy,
    this.mobility,
    this.tagsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['weapon_id'] = Variable<int>(weaponId);
    map['head_damage'] = Variable<int>(headDamage);
    map['body_damage'] = Variable<int>(bodyDamage);
    map['limb_damage'] = Variable<int>(limbDamage);
    if (!nullToAbsent || preciseHeadDamage != null) {
      map['precise_head_damage'] = Variable<double>(preciseHeadDamage);
    }
    if (!nullToAbsent || preciseBodyDamage != null) {
      map['precise_body_damage'] = Variable<double>(preciseBodyDamage);
    }
    if (!nullToAbsent || preciseLimbDamage != null) {
      map['precise_limb_damage'] = Variable<double>(preciseLimbDamage);
    }
    map['average_damage'] = Variable<double>(averageDamage);
    map['bullet_spread_degrees'] = Variable<double>(bulletSpreadDegrees);
    map['bullet_velocity'] = Variable<double>(bulletVelocity);
    map['equip_time'] = Variable<double>(equipTime);
    if (!nullToAbsent || rangeMinLabel != null) {
      map['range_min_label'] = Variable<String>(rangeMinLabel);
    }
    if (!nullToAbsent || rangeMaxLabel != null) {
      map['range_max_label'] = Variable<String>(rangeMaxLabel);
    }
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    if (!nullToAbsent || mobility != null) {
      map['mobility'] = Variable<double>(mobility);
    }
    if (!nullToAbsent || tagsJson != null) {
      map['tags_json'] = Variable<String>(tagsJson);
    }
    return map;
  }

  WeaponAdvancedStatsCompanion toCompanion(bool nullToAbsent) {
    return WeaponAdvancedStatsCompanion(
      weaponId: Value(weaponId),
      headDamage: Value(headDamage),
      bodyDamage: Value(bodyDamage),
      limbDamage: Value(limbDamage),
      preciseHeadDamage: preciseHeadDamage == null && nullToAbsent
          ? const Value.absent()
          : Value(preciseHeadDamage),
      preciseBodyDamage: preciseBodyDamage == null && nullToAbsent
          ? const Value.absent()
          : Value(preciseBodyDamage),
      preciseLimbDamage: preciseLimbDamage == null && nullToAbsent
          ? const Value.absent()
          : Value(preciseLimbDamage),
      averageDamage: Value(averageDamage),
      bulletSpreadDegrees: Value(bulletSpreadDegrees),
      bulletVelocity: Value(bulletVelocity),
      equipTime: Value(equipTime),
      rangeMinLabel: rangeMinLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(rangeMinLabel),
      rangeMaxLabel: rangeMaxLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(rangeMaxLabel),
      accuracy: accuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracy),
      mobility: mobility == null && nullToAbsent
          ? const Value.absent()
          : Value(mobility),
      tagsJson: tagsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(tagsJson),
    );
  }

  factory WeaponAdvancedStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeaponAdvancedStat(
      weaponId: serializer.fromJson<int>(json['weaponId']),
      headDamage: serializer.fromJson<int>(json['headDamage']),
      bodyDamage: serializer.fromJson<int>(json['bodyDamage']),
      limbDamage: serializer.fromJson<int>(json['limbDamage']),
      preciseHeadDamage: serializer.fromJson<double?>(
        json['preciseHeadDamage'],
      ),
      preciseBodyDamage: serializer.fromJson<double?>(
        json['preciseBodyDamage'],
      ),
      preciseLimbDamage: serializer.fromJson<double?>(
        json['preciseLimbDamage'],
      ),
      averageDamage: serializer.fromJson<double>(json['averageDamage']),
      bulletSpreadDegrees: serializer.fromJson<double>(
        json['bulletSpreadDegrees'],
      ),
      bulletVelocity: serializer.fromJson<double>(json['bulletVelocity']),
      equipTime: serializer.fromJson<double>(json['equipTime']),
      rangeMinLabel: serializer.fromJson<String?>(json['rangeMinLabel']),
      rangeMaxLabel: serializer.fromJson<String?>(json['rangeMaxLabel']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      mobility: serializer.fromJson<double?>(json['mobility']),
      tagsJson: serializer.fromJson<String?>(json['tagsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'weaponId': serializer.toJson<int>(weaponId),
      'headDamage': serializer.toJson<int>(headDamage),
      'bodyDamage': serializer.toJson<int>(bodyDamage),
      'limbDamage': serializer.toJson<int>(limbDamage),
      'preciseHeadDamage': serializer.toJson<double?>(preciseHeadDamage),
      'preciseBodyDamage': serializer.toJson<double?>(preciseBodyDamage),
      'preciseLimbDamage': serializer.toJson<double?>(preciseLimbDamage),
      'averageDamage': serializer.toJson<double>(averageDamage),
      'bulletSpreadDegrees': serializer.toJson<double>(bulletSpreadDegrees),
      'bulletVelocity': serializer.toJson<double>(bulletVelocity),
      'equipTime': serializer.toJson<double>(equipTime),
      'rangeMinLabel': serializer.toJson<String?>(rangeMinLabel),
      'rangeMaxLabel': serializer.toJson<String?>(rangeMaxLabel),
      'accuracy': serializer.toJson<double?>(accuracy),
      'mobility': serializer.toJson<double?>(mobility),
      'tagsJson': serializer.toJson<String?>(tagsJson),
    };
  }

  WeaponAdvancedStat copyWith({
    int? weaponId,
    int? headDamage,
    int? bodyDamage,
    int? limbDamage,
    Value<double?> preciseHeadDamage = const Value.absent(),
    Value<double?> preciseBodyDamage = const Value.absent(),
    Value<double?> preciseLimbDamage = const Value.absent(),
    double? averageDamage,
    double? bulletSpreadDegrees,
    double? bulletVelocity,
    double? equipTime,
    Value<String?> rangeMinLabel = const Value.absent(),
    Value<String?> rangeMaxLabel = const Value.absent(),
    Value<double?> accuracy = const Value.absent(),
    Value<double?> mobility = const Value.absent(),
    Value<String?> tagsJson = const Value.absent(),
  }) => WeaponAdvancedStat(
    weaponId: weaponId ?? this.weaponId,
    headDamage: headDamage ?? this.headDamage,
    bodyDamage: bodyDamage ?? this.bodyDamage,
    limbDamage: limbDamage ?? this.limbDamage,
    preciseHeadDamage: preciseHeadDamage.present
        ? preciseHeadDamage.value
        : this.preciseHeadDamage,
    preciseBodyDamage: preciseBodyDamage.present
        ? preciseBodyDamage.value
        : this.preciseBodyDamage,
    preciseLimbDamage: preciseLimbDamage.present
        ? preciseLimbDamage.value
        : this.preciseLimbDamage,
    averageDamage: averageDamage ?? this.averageDamage,
    bulletSpreadDegrees: bulletSpreadDegrees ?? this.bulletSpreadDegrees,
    bulletVelocity: bulletVelocity ?? this.bulletVelocity,
    equipTime: equipTime ?? this.equipTime,
    rangeMinLabel: rangeMinLabel.present
        ? rangeMinLabel.value
        : this.rangeMinLabel,
    rangeMaxLabel: rangeMaxLabel.present
        ? rangeMaxLabel.value
        : this.rangeMaxLabel,
    accuracy: accuracy.present ? accuracy.value : this.accuracy,
    mobility: mobility.present ? mobility.value : this.mobility,
    tagsJson: tagsJson.present ? tagsJson.value : this.tagsJson,
  );
  WeaponAdvancedStat copyWithCompanion(WeaponAdvancedStatsCompanion data) {
    return WeaponAdvancedStat(
      weaponId: data.weaponId.present ? data.weaponId.value : this.weaponId,
      headDamage: data.headDamage.present
          ? data.headDamage.value
          : this.headDamage,
      bodyDamage: data.bodyDamage.present
          ? data.bodyDamage.value
          : this.bodyDamage,
      limbDamage: data.limbDamage.present
          ? data.limbDamage.value
          : this.limbDamage,
      preciseHeadDamage: data.preciseHeadDamage.present
          ? data.preciseHeadDamage.value
          : this.preciseHeadDamage,
      preciseBodyDamage: data.preciseBodyDamage.present
          ? data.preciseBodyDamage.value
          : this.preciseBodyDamage,
      preciseLimbDamage: data.preciseLimbDamage.present
          ? data.preciseLimbDamage.value
          : this.preciseLimbDamage,
      averageDamage: data.averageDamage.present
          ? data.averageDamage.value
          : this.averageDamage,
      bulletSpreadDegrees: data.bulletSpreadDegrees.present
          ? data.bulletSpreadDegrees.value
          : this.bulletSpreadDegrees,
      bulletVelocity: data.bulletVelocity.present
          ? data.bulletVelocity.value
          : this.bulletVelocity,
      equipTime: data.equipTime.present ? data.equipTime.value : this.equipTime,
      rangeMinLabel: data.rangeMinLabel.present
          ? data.rangeMinLabel.value
          : this.rangeMinLabel,
      rangeMaxLabel: data.rangeMaxLabel.present
          ? data.rangeMaxLabel.value
          : this.rangeMaxLabel,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      mobility: data.mobility.present ? data.mobility.value : this.mobility,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeaponAdvancedStat(')
          ..write('weaponId: $weaponId, ')
          ..write('headDamage: $headDamage, ')
          ..write('bodyDamage: $bodyDamage, ')
          ..write('limbDamage: $limbDamage, ')
          ..write('preciseHeadDamage: $preciseHeadDamage, ')
          ..write('preciseBodyDamage: $preciseBodyDamage, ')
          ..write('preciseLimbDamage: $preciseLimbDamage, ')
          ..write('averageDamage: $averageDamage, ')
          ..write('bulletSpreadDegrees: $bulletSpreadDegrees, ')
          ..write('bulletVelocity: $bulletVelocity, ')
          ..write('equipTime: $equipTime, ')
          ..write('rangeMinLabel: $rangeMinLabel, ')
          ..write('rangeMaxLabel: $rangeMaxLabel, ')
          ..write('accuracy: $accuracy, ')
          ..write('mobility: $mobility, ')
          ..write('tagsJson: $tagsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    weaponId,
    headDamage,
    bodyDamage,
    limbDamage,
    preciseHeadDamage,
    preciseBodyDamage,
    preciseLimbDamage,
    averageDamage,
    bulletSpreadDegrees,
    bulletVelocity,
    equipTime,
    rangeMinLabel,
    rangeMaxLabel,
    accuracy,
    mobility,
    tagsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeaponAdvancedStat &&
          other.weaponId == this.weaponId &&
          other.headDamage == this.headDamage &&
          other.bodyDamage == this.bodyDamage &&
          other.limbDamage == this.limbDamage &&
          other.preciseHeadDamage == this.preciseHeadDamage &&
          other.preciseBodyDamage == this.preciseBodyDamage &&
          other.preciseLimbDamage == this.preciseLimbDamage &&
          other.averageDamage == this.averageDamage &&
          other.bulletSpreadDegrees == this.bulletSpreadDegrees &&
          other.bulletVelocity == this.bulletVelocity &&
          other.equipTime == this.equipTime &&
          other.rangeMinLabel == this.rangeMinLabel &&
          other.rangeMaxLabel == this.rangeMaxLabel &&
          other.accuracy == this.accuracy &&
          other.mobility == this.mobility &&
          other.tagsJson == this.tagsJson);
}

class WeaponAdvancedStatsCompanion extends UpdateCompanion<WeaponAdvancedStat> {
  final Value<int> weaponId;
  final Value<int> headDamage;
  final Value<int> bodyDamage;
  final Value<int> limbDamage;
  final Value<double?> preciseHeadDamage;
  final Value<double?> preciseBodyDamage;
  final Value<double?> preciseLimbDamage;
  final Value<double> averageDamage;
  final Value<double> bulletSpreadDegrees;
  final Value<double> bulletVelocity;
  final Value<double> equipTime;
  final Value<String?> rangeMinLabel;
  final Value<String?> rangeMaxLabel;
  final Value<double?> accuracy;
  final Value<double?> mobility;
  final Value<String?> tagsJson;
  const WeaponAdvancedStatsCompanion({
    this.weaponId = const Value.absent(),
    this.headDamage = const Value.absent(),
    this.bodyDamage = const Value.absent(),
    this.limbDamage = const Value.absent(),
    this.preciseHeadDamage = const Value.absent(),
    this.preciseBodyDamage = const Value.absent(),
    this.preciseLimbDamage = const Value.absent(),
    this.averageDamage = const Value.absent(),
    this.bulletSpreadDegrees = const Value.absent(),
    this.bulletVelocity = const Value.absent(),
    this.equipTime = const Value.absent(),
    this.rangeMinLabel = const Value.absent(),
    this.rangeMaxLabel = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.mobility = const Value.absent(),
    this.tagsJson = const Value.absent(),
  });
  WeaponAdvancedStatsCompanion.insert({
    this.weaponId = const Value.absent(),
    required int headDamage,
    required int bodyDamage,
    required int limbDamage,
    this.preciseHeadDamage = const Value.absent(),
    this.preciseBodyDamage = const Value.absent(),
    this.preciseLimbDamage = const Value.absent(),
    required double averageDamage,
    required double bulletSpreadDegrees,
    required double bulletVelocity,
    required double equipTime,
    this.rangeMinLabel = const Value.absent(),
    this.rangeMaxLabel = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.mobility = const Value.absent(),
    this.tagsJson = const Value.absent(),
  }) : headDamage = Value(headDamage),
       bodyDamage = Value(bodyDamage),
       limbDamage = Value(limbDamage),
       averageDamage = Value(averageDamage),
       bulletSpreadDegrees = Value(bulletSpreadDegrees),
       bulletVelocity = Value(bulletVelocity),
       equipTime = Value(equipTime);
  static Insertable<WeaponAdvancedStat> custom({
    Expression<int>? weaponId,
    Expression<int>? headDamage,
    Expression<int>? bodyDamage,
    Expression<int>? limbDamage,
    Expression<double>? preciseHeadDamage,
    Expression<double>? preciseBodyDamage,
    Expression<double>? preciseLimbDamage,
    Expression<double>? averageDamage,
    Expression<double>? bulletSpreadDegrees,
    Expression<double>? bulletVelocity,
    Expression<double>? equipTime,
    Expression<String>? rangeMinLabel,
    Expression<String>? rangeMaxLabel,
    Expression<double>? accuracy,
    Expression<double>? mobility,
    Expression<String>? tagsJson,
  }) {
    return RawValuesInsertable({
      if (weaponId != null) 'weapon_id': weaponId,
      if (headDamage != null) 'head_damage': headDamage,
      if (bodyDamage != null) 'body_damage': bodyDamage,
      if (limbDamage != null) 'limb_damage': limbDamage,
      if (preciseHeadDamage != null) 'precise_head_damage': preciseHeadDamage,
      if (preciseBodyDamage != null) 'precise_body_damage': preciseBodyDamage,
      if (preciseLimbDamage != null) 'precise_limb_damage': preciseLimbDamage,
      if (averageDamage != null) 'average_damage': averageDamage,
      if (bulletSpreadDegrees != null)
        'bullet_spread_degrees': bulletSpreadDegrees,
      if (bulletVelocity != null) 'bullet_velocity': bulletVelocity,
      if (equipTime != null) 'equip_time': equipTime,
      if (rangeMinLabel != null) 'range_min_label': rangeMinLabel,
      if (rangeMaxLabel != null) 'range_max_label': rangeMaxLabel,
      if (accuracy != null) 'accuracy': accuracy,
      if (mobility != null) 'mobility': mobility,
      if (tagsJson != null) 'tags_json': tagsJson,
    });
  }

  WeaponAdvancedStatsCompanion copyWith({
    Value<int>? weaponId,
    Value<int>? headDamage,
    Value<int>? bodyDamage,
    Value<int>? limbDamage,
    Value<double?>? preciseHeadDamage,
    Value<double?>? preciseBodyDamage,
    Value<double?>? preciseLimbDamage,
    Value<double>? averageDamage,
    Value<double>? bulletSpreadDegrees,
    Value<double>? bulletVelocity,
    Value<double>? equipTime,
    Value<String?>? rangeMinLabel,
    Value<String?>? rangeMaxLabel,
    Value<double?>? accuracy,
    Value<double?>? mobility,
    Value<String?>? tagsJson,
  }) {
    return WeaponAdvancedStatsCompanion(
      weaponId: weaponId ?? this.weaponId,
      headDamage: headDamage ?? this.headDamage,
      bodyDamage: bodyDamage ?? this.bodyDamage,
      limbDamage: limbDamage ?? this.limbDamage,
      preciseHeadDamage: preciseHeadDamage ?? this.preciseHeadDamage,
      preciseBodyDamage: preciseBodyDamage ?? this.preciseBodyDamage,
      preciseLimbDamage: preciseLimbDamage ?? this.preciseLimbDamage,
      averageDamage: averageDamage ?? this.averageDamage,
      bulletSpreadDegrees: bulletSpreadDegrees ?? this.bulletSpreadDegrees,
      bulletVelocity: bulletVelocity ?? this.bulletVelocity,
      equipTime: equipTime ?? this.equipTime,
      rangeMinLabel: rangeMinLabel ?? this.rangeMinLabel,
      rangeMaxLabel: rangeMaxLabel ?? this.rangeMaxLabel,
      accuracy: accuracy ?? this.accuracy,
      mobility: mobility ?? this.mobility,
      tagsJson: tagsJson ?? this.tagsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (weaponId.present) {
      map['weapon_id'] = Variable<int>(weaponId.value);
    }
    if (headDamage.present) {
      map['head_damage'] = Variable<int>(headDamage.value);
    }
    if (bodyDamage.present) {
      map['body_damage'] = Variable<int>(bodyDamage.value);
    }
    if (limbDamage.present) {
      map['limb_damage'] = Variable<int>(limbDamage.value);
    }
    if (preciseHeadDamage.present) {
      map['precise_head_damage'] = Variable<double>(preciseHeadDamage.value);
    }
    if (preciseBodyDamage.present) {
      map['precise_body_damage'] = Variable<double>(preciseBodyDamage.value);
    }
    if (preciseLimbDamage.present) {
      map['precise_limb_damage'] = Variable<double>(preciseLimbDamage.value);
    }
    if (averageDamage.present) {
      map['average_damage'] = Variable<double>(averageDamage.value);
    }
    if (bulletSpreadDegrees.present) {
      map['bullet_spread_degrees'] = Variable<double>(
        bulletSpreadDegrees.value,
      );
    }
    if (bulletVelocity.present) {
      map['bullet_velocity'] = Variable<double>(bulletVelocity.value);
    }
    if (equipTime.present) {
      map['equip_time'] = Variable<double>(equipTime.value);
    }
    if (rangeMinLabel.present) {
      map['range_min_label'] = Variable<String>(rangeMinLabel.value);
    }
    if (rangeMaxLabel.present) {
      map['range_max_label'] = Variable<String>(rangeMaxLabel.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (mobility.present) {
      map['mobility'] = Variable<double>(mobility.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeaponAdvancedStatsCompanion(')
          ..write('weaponId: $weaponId, ')
          ..write('headDamage: $headDamage, ')
          ..write('bodyDamage: $bodyDamage, ')
          ..write('limbDamage: $limbDamage, ')
          ..write('preciseHeadDamage: $preciseHeadDamage, ')
          ..write('preciseBodyDamage: $preciseBodyDamage, ')
          ..write('preciseLimbDamage: $preciseLimbDamage, ')
          ..write('averageDamage: $averageDamage, ')
          ..write('bulletSpreadDegrees: $bulletSpreadDegrees, ')
          ..write('bulletVelocity: $bulletVelocity, ')
          ..write('equipTime: $equipTime, ')
          ..write('rangeMinLabel: $rangeMinLabel, ')
          ..write('rangeMaxLabel: $rangeMaxLabel, ')
          ..write('accuracy: $accuracy, ')
          ..write('mobility: $mobility, ')
          ..write('tagsJson: $tagsJson')
          ..write(')'))
        .toString();
  }
}

class $WeaponDistanceProfilesTable extends WeaponDistanceProfiles
    with TableInfo<$WeaponDistanceProfilesTable, WeaponDistanceProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeaponDistanceProfilesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _weaponIdMeta = const VerificationMeta(
    'weaponId',
  );
  @override
  late final GeneratedColumn<int> weaponId = GeneratedColumn<int>(
    'weapon_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES weapons (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _distanceLabelMeta = const VerificationMeta(
    'distanceLabel',
  );
  @override
  late final GeneratedColumn<String> distanceLabel = GeneratedColumn<String>(
    'distance_label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _damageMultiplierMeta = const VerificationMeta(
    'damageMultiplier',
  );
  @override
  late final GeneratedColumn<double> damageMultiplier = GeneratedColumn<double>(
    'damage_multiplier',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK ("damage_multiplier" >= 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weaponId,
    distanceLabel,
    damageMultiplier,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weapon_distance_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeaponDistanceProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weapon_id')) {
      context.handle(
        _weaponIdMeta,
        weaponId.isAcceptableOrUnknown(data['weapon_id']!, _weaponIdMeta),
      );
    } else if (isInserting) {
      context.missing(_weaponIdMeta);
    }
    if (data.containsKey('distance_label')) {
      context.handle(
        _distanceLabelMeta,
        distanceLabel.isAcceptableOrUnknown(
          data['distance_label']!,
          _distanceLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanceLabelMeta);
    }
    if (data.containsKey('damage_multiplier')) {
      context.handle(
        _damageMultiplierMeta,
        damageMultiplier.isAcceptableOrUnknown(
          data['damage_multiplier']!,
          _damageMultiplierMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_damageMultiplierMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeaponDistanceProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeaponDistanceProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weaponId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weapon_id'],
      )!,
      distanceLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distance_label'],
      )!,
      damageMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}damage_multiplier'],
      )!,
    );
  }

  @override
  $WeaponDistanceProfilesTable createAlias(String alias) {
    return $WeaponDistanceProfilesTable(attachedDatabase, alias);
  }
}

class WeaponDistanceProfile extends DataClass
    implements Insertable<WeaponDistanceProfile> {
  final int id;
  final int weaponId;
  final String distanceLabel;
  final double damageMultiplier;
  const WeaponDistanceProfile({
    required this.id,
    required this.weaponId,
    required this.distanceLabel,
    required this.damageMultiplier,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['weapon_id'] = Variable<int>(weaponId);
    map['distance_label'] = Variable<String>(distanceLabel);
    map['damage_multiplier'] = Variable<double>(damageMultiplier);
    return map;
  }

  WeaponDistanceProfilesCompanion toCompanion(bool nullToAbsent) {
    return WeaponDistanceProfilesCompanion(
      id: Value(id),
      weaponId: Value(weaponId),
      distanceLabel: Value(distanceLabel),
      damageMultiplier: Value(damageMultiplier),
    );
  }

  factory WeaponDistanceProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeaponDistanceProfile(
      id: serializer.fromJson<int>(json['id']),
      weaponId: serializer.fromJson<int>(json['weaponId']),
      distanceLabel: serializer.fromJson<String>(json['distanceLabel']),
      damageMultiplier: serializer.fromJson<double>(json['damageMultiplier']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weaponId': serializer.toJson<int>(weaponId),
      'distanceLabel': serializer.toJson<String>(distanceLabel),
      'damageMultiplier': serializer.toJson<double>(damageMultiplier),
    };
  }

  WeaponDistanceProfile copyWith({
    int? id,
    int? weaponId,
    String? distanceLabel,
    double? damageMultiplier,
  }) => WeaponDistanceProfile(
    id: id ?? this.id,
    weaponId: weaponId ?? this.weaponId,
    distanceLabel: distanceLabel ?? this.distanceLabel,
    damageMultiplier: damageMultiplier ?? this.damageMultiplier,
  );
  WeaponDistanceProfile copyWithCompanion(
    WeaponDistanceProfilesCompanion data,
  ) {
    return WeaponDistanceProfile(
      id: data.id.present ? data.id.value : this.id,
      weaponId: data.weaponId.present ? data.weaponId.value : this.weaponId,
      distanceLabel: data.distanceLabel.present
          ? data.distanceLabel.value
          : this.distanceLabel,
      damageMultiplier: data.damageMultiplier.present
          ? data.damageMultiplier.value
          : this.damageMultiplier,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeaponDistanceProfile(')
          ..write('id: $id, ')
          ..write('weaponId: $weaponId, ')
          ..write('distanceLabel: $distanceLabel, ')
          ..write('damageMultiplier: $damageMultiplier')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, weaponId, distanceLabel, damageMultiplier);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeaponDistanceProfile &&
          other.id == this.id &&
          other.weaponId == this.weaponId &&
          other.distanceLabel == this.distanceLabel &&
          other.damageMultiplier == this.damageMultiplier);
}

class WeaponDistanceProfilesCompanion
    extends UpdateCompanion<WeaponDistanceProfile> {
  final Value<int> id;
  final Value<int> weaponId;
  final Value<String> distanceLabel;
  final Value<double> damageMultiplier;
  const WeaponDistanceProfilesCompanion({
    this.id = const Value.absent(),
    this.weaponId = const Value.absent(),
    this.distanceLabel = const Value.absent(),
    this.damageMultiplier = const Value.absent(),
  });
  WeaponDistanceProfilesCompanion.insert({
    this.id = const Value.absent(),
    required int weaponId,
    required String distanceLabel,
    required double damageMultiplier,
  }) : weaponId = Value(weaponId),
       distanceLabel = Value(distanceLabel),
       damageMultiplier = Value(damageMultiplier);
  static Insertable<WeaponDistanceProfile> custom({
    Expression<int>? id,
    Expression<int>? weaponId,
    Expression<String>? distanceLabel,
    Expression<double>? damageMultiplier,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weaponId != null) 'weapon_id': weaponId,
      if (distanceLabel != null) 'distance_label': distanceLabel,
      if (damageMultiplier != null) 'damage_multiplier': damageMultiplier,
    });
  }

  WeaponDistanceProfilesCompanion copyWith({
    Value<int>? id,
    Value<int>? weaponId,
    Value<String>? distanceLabel,
    Value<double>? damageMultiplier,
  }) {
    return WeaponDistanceProfilesCompanion(
      id: id ?? this.id,
      weaponId: weaponId ?? this.weaponId,
      distanceLabel: distanceLabel ?? this.distanceLabel,
      damageMultiplier: damageMultiplier ?? this.damageMultiplier,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weaponId.present) {
      map['weapon_id'] = Variable<int>(weaponId.value);
    }
    if (distanceLabel.present) {
      map['distance_label'] = Variable<String>(distanceLabel.value);
    }
    if (damageMultiplier.present) {
      map['damage_multiplier'] = Variable<double>(damageMultiplier.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeaponDistanceProfilesCompanion(')
          ..write('id: $id, ')
          ..write('weaponId: $weaponId, ')
          ..write('distanceLabel: $distanceLabel, ')
          ..write('damageMultiplier: $damageMultiplier')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MapAssetsTable mapAssets = $MapAssetsTable(this);
  late final $BattlePlansTable battlePlans = $BattlePlansTable(this);
  late final $BattlePlanStepsTable battlePlanSteps = $BattlePlanStepsTable(
    this,
  );
  late final $PlanElementsTable planElements = $PlanElementsTable(this);
  late final $BattlePlanStepElementStatesTable battlePlanStepElementStates =
      $BattlePlanStepElementStatesTable(this);
  late final $WeaponsTable weapons = $WeaponsTable(this);
  late final $WeaponAdvancedStatsTable weaponAdvancedStats =
      $WeaponAdvancedStatsTable(this);
  late final $WeaponDistanceProfilesTable weaponDistanceProfiles =
      $WeaponDistanceProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    mapAssets,
    battlePlans,
    battlePlanSteps,
    planElements,
    battlePlanStepElementStates,
    weapons,
    weaponAdvancedStats,
    weaponDistanceProfiles,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'battle_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('battle_plan_steps', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'battle_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('plan_elements', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'battle_plan_steps',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('battle_plan_step_element_states', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plan_elements',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('battle_plan_step_element_states', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'weapons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('weapon_advanced_stats', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'weapons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('weapon_distance_profiles', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$MapAssetsTableCreateCompanionBuilder =
    MapAssetsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> logicalMapName,
      Value<int> floorNumber,
      required String imagePath,
      required int width,
      required int height,
    });
typedef $$MapAssetsTableUpdateCompanionBuilder =
    MapAssetsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> logicalMapName,
      Value<int> floorNumber,
      Value<String> imagePath,
      Value<int> width,
      Value<int> height,
    });

final class $$MapAssetsTableReferences
    extends BaseReferences<_$AppDatabase, $MapAssetsTable, MapAsset> {
  $$MapAssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BattlePlansTable, List<BattlePlan>>
  _battlePlansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.battlePlans,
    aliasName: $_aliasNameGenerator(db.mapAssets.id, db.battlePlans.mapId),
  );

  $$BattlePlansTableProcessedTableManager get battlePlansRefs {
    final manager = $$BattlePlansTableTableManager(
      $_db,
      $_db.battlePlans,
    ).filter((f) => f.mapId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_battlePlansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MapAssetsTableFilterComposer
    extends Composer<_$AppDatabase, $MapAssetsTable> {
  $$MapAssetsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logicalMapName => $composableBuilder(
    column: $table.logicalMapName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get floorNumber => $composableBuilder(
    column: $table.floorNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> battlePlansRefs(
    Expression<bool> Function($$BattlePlansTableFilterComposer f) f,
  ) {
    final $$BattlePlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.battlePlans,
      getReferencedColumn: (t) => t.mapId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlansTableFilterComposer(
            $db: $db,
            $table: $db.battlePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MapAssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $MapAssetsTable> {
  $$MapAssetsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logicalMapName => $composableBuilder(
    column: $table.logicalMapName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get floorNumber => $composableBuilder(
    column: $table.floorNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MapAssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MapAssetsTable> {
  $$MapAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get logicalMapName => $composableBuilder(
    column: $table.logicalMapName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get floorNumber => $composableBuilder(
    column: $table.floorNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  Expression<T> battlePlansRefs<T extends Object>(
    Expression<T> Function($$BattlePlansTableAnnotationComposer a) f,
  ) {
    final $$BattlePlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.battlePlans,
      getReferencedColumn: (t) => t.mapId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlansTableAnnotationComposer(
            $db: $db,
            $table: $db.battlePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MapAssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MapAssetsTable,
          MapAsset,
          $$MapAssetsTableFilterComposer,
          $$MapAssetsTableOrderingComposer,
          $$MapAssetsTableAnnotationComposer,
          $$MapAssetsTableCreateCompanionBuilder,
          $$MapAssetsTableUpdateCompanionBuilder,
          (MapAsset, $$MapAssetsTableReferences),
          MapAsset,
          PrefetchHooks Function({bool battlePlansRefs})
        > {
  $$MapAssetsTableTableManager(_$AppDatabase db, $MapAssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MapAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MapAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MapAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> logicalMapName = const Value.absent(),
                Value<int> floorNumber = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
              }) => MapAssetsCompanion(
                id: id,
                name: name,
                logicalMapName: logicalMapName,
                floorNumber: floorNumber,
                imagePath: imagePath,
                width: width,
                height: height,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> logicalMapName = const Value.absent(),
                Value<int> floorNumber = const Value.absent(),
                required String imagePath,
                required int width,
                required int height,
              }) => MapAssetsCompanion.insert(
                id: id,
                name: name,
                logicalMapName: logicalMapName,
                floorNumber: floorNumber,
                imagePath: imagePath,
                width: width,
                height: height,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MapAssetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({battlePlansRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (battlePlansRefs) db.battlePlans],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (battlePlansRefs)
                    await $_getPrefetchedData<
                      MapAsset,
                      $MapAssetsTable,
                      BattlePlan
                    >(
                      currentTable: table,
                      referencedTable: $$MapAssetsTableReferences
                          ._battlePlansRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MapAssetsTableReferences(
                            db,
                            table,
                            p0,
                          ).battlePlansRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.mapId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MapAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MapAssetsTable,
      MapAsset,
      $$MapAssetsTableFilterComposer,
      $$MapAssetsTableOrderingComposer,
      $$MapAssetsTableAnnotationComposer,
      $$MapAssetsTableCreateCompanionBuilder,
      $$MapAssetsTableUpdateCompanionBuilder,
      (MapAsset, $$MapAssetsTableReferences),
      MapAsset,
      PrefetchHooks Function({bool battlePlansRefs})
    >;
typedef $$BattlePlansTableCreateCompanionBuilder =
    BattlePlansCompanion Function({
      Value<int> id,
      required String name,
      required int mapId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$BattlePlansTableUpdateCompanionBuilder =
    BattlePlansCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> mapId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$BattlePlansTableReferences
    extends BaseReferences<_$AppDatabase, $BattlePlansTable, BattlePlan> {
  $$BattlePlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MapAssetsTable _mapIdTable(_$AppDatabase db) => db.mapAssets
      .createAlias($_aliasNameGenerator(db.battlePlans.mapId, db.mapAssets.id));

  $$MapAssetsTableProcessedTableManager get mapId {
    final $_column = $_itemColumn<int>('map_id')!;

    final manager = $$MapAssetsTableTableManager(
      $_db,
      $_db.mapAssets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mapIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BattlePlanStepsTable, List<BattlePlanStep>>
  _battlePlanStepsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.battlePlanSteps,
    aliasName: $_aliasNameGenerator(
      db.battlePlans.id,
      db.battlePlanSteps.battlePlanId,
    ),
  );

  $$BattlePlanStepsTableProcessedTableManager get battlePlanStepsRefs {
    final manager = $$BattlePlanStepsTableTableManager(
      $_db,
      $_db.battlePlanSteps,
    ).filter((f) => f.battlePlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _battlePlanStepsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlanElementsTable, List<PlanElement>>
  _planElementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planElements,
    aliasName: $_aliasNameGenerator(
      db.battlePlans.id,
      db.planElements.battlePlanId,
    ),
  );

  $$PlanElementsTableProcessedTableManager get planElementsRefs {
    final manager = $$PlanElementsTableTableManager(
      $_db,
      $_db.planElements,
    ).filter((f) => f.battlePlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_planElementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BattlePlansTableFilterComposer
    extends Composer<_$AppDatabase, $BattlePlansTable> {
  $$BattlePlansTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MapAssetsTableFilterComposer get mapId {
    final $$MapAssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mapId,
      referencedTable: $db.mapAssets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MapAssetsTableFilterComposer(
            $db: $db,
            $table: $db.mapAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> battlePlanStepsRefs(
    Expression<bool> Function($$BattlePlanStepsTableFilterComposer f) f,
  ) {
    final $$BattlePlanStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.battlePlanSteps,
      getReferencedColumn: (t) => t.battlePlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlanStepsTableFilterComposer(
            $db: $db,
            $table: $db.battlePlanSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> planElementsRefs(
    Expression<bool> Function($$PlanElementsTableFilterComposer f) f,
  ) {
    final $$PlanElementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planElements,
      getReferencedColumn: (t) => t.battlePlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanElementsTableFilterComposer(
            $db: $db,
            $table: $db.planElements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BattlePlansTableOrderingComposer
    extends Composer<_$AppDatabase, $BattlePlansTable> {
  $$BattlePlansTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MapAssetsTableOrderingComposer get mapId {
    final $$MapAssetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mapId,
      referencedTable: $db.mapAssets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MapAssetsTableOrderingComposer(
            $db: $db,
            $table: $db.mapAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BattlePlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $BattlePlansTable> {
  $$BattlePlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MapAssetsTableAnnotationComposer get mapId {
    final $$MapAssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mapId,
      referencedTable: $db.mapAssets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MapAssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.mapAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> battlePlanStepsRefs<T extends Object>(
    Expression<T> Function($$BattlePlanStepsTableAnnotationComposer a) f,
  ) {
    final $$BattlePlanStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.battlePlanSteps,
      getReferencedColumn: (t) => t.battlePlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlanStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.battlePlanSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> planElementsRefs<T extends Object>(
    Expression<T> Function($$PlanElementsTableAnnotationComposer a) f,
  ) {
    final $$PlanElementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planElements,
      getReferencedColumn: (t) => t.battlePlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanElementsTableAnnotationComposer(
            $db: $db,
            $table: $db.planElements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BattlePlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BattlePlansTable,
          BattlePlan,
          $$BattlePlansTableFilterComposer,
          $$BattlePlansTableOrderingComposer,
          $$BattlePlansTableAnnotationComposer,
          $$BattlePlansTableCreateCompanionBuilder,
          $$BattlePlansTableUpdateCompanionBuilder,
          (BattlePlan, $$BattlePlansTableReferences),
          BattlePlan,
          PrefetchHooks Function({
            bool mapId,
            bool battlePlanStepsRefs,
            bool planElementsRefs,
          })
        > {
  $$BattlePlansTableTableManager(_$AppDatabase db, $BattlePlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BattlePlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BattlePlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BattlePlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> mapId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BattlePlansCompanion(
                id: id,
                name: name,
                mapId: mapId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int mapId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BattlePlansCompanion.insert(
                id: id,
                name: name,
                mapId: mapId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BattlePlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                mapId = false,
                battlePlanStepsRefs = false,
                planElementsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (battlePlanStepsRefs) db.battlePlanSteps,
                    if (planElementsRefs) db.planElements,
                  ],
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
                        if (mapId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.mapId,
                                    referencedTable:
                                        $$BattlePlansTableReferences
                                            ._mapIdTable(db),
                                    referencedColumn:
                                        $$BattlePlansTableReferences
                                            ._mapIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (battlePlanStepsRefs)
                        await $_getPrefetchedData<
                          BattlePlan,
                          $BattlePlansTable,
                          BattlePlanStep
                        >(
                          currentTable: table,
                          referencedTable: $$BattlePlansTableReferences
                              ._battlePlanStepsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BattlePlansTableReferences(
                                db,
                                table,
                                p0,
                              ).battlePlanStepsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.battlePlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (planElementsRefs)
                        await $_getPrefetchedData<
                          BattlePlan,
                          $BattlePlansTable,
                          PlanElement
                        >(
                          currentTable: table,
                          referencedTable: $$BattlePlansTableReferences
                              ._planElementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BattlePlansTableReferences(
                                db,
                                table,
                                p0,
                              ).planElementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.battlePlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BattlePlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BattlePlansTable,
      BattlePlan,
      $$BattlePlansTableFilterComposer,
      $$BattlePlansTableOrderingComposer,
      $$BattlePlansTableAnnotationComposer,
      $$BattlePlansTableCreateCompanionBuilder,
      $$BattlePlansTableUpdateCompanionBuilder,
      (BattlePlan, $$BattlePlansTableReferences),
      BattlePlan,
      PrefetchHooks Function({
        bool mapId,
        bool battlePlanStepsRefs,
        bool planElementsRefs,
      })
    >;
typedef $$BattlePlanStepsTableCreateCompanionBuilder =
    BattlePlanStepsCompanion Function({
      Value<int> id,
      required int battlePlanId,
      required String title,
      required int orderIndex,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$BattlePlanStepsTableUpdateCompanionBuilder =
    BattlePlanStepsCompanion Function({
      Value<int> id,
      Value<int> battlePlanId,
      Value<String> title,
      Value<int> orderIndex,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$BattlePlanStepsTableReferences
    extends
        BaseReferences<_$AppDatabase, $BattlePlanStepsTable, BattlePlanStep> {
  $$BattlePlanStepsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BattlePlansTable _battlePlanIdTable(_$AppDatabase db) =>
      db.battlePlans.createAlias(
        $_aliasNameGenerator(
          db.battlePlanSteps.battlePlanId,
          db.battlePlans.id,
        ),
      );

  $$BattlePlansTableProcessedTableManager get battlePlanId {
    final $_column = $_itemColumn<int>('battle_plan_id')!;

    final manager = $$BattlePlansTableTableManager(
      $_db,
      $_db.battlePlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_battlePlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $BattlePlanStepElementStatesTable,
    List<BattlePlanStepElementState>
  >
  _battlePlanStepElementStatesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.battlePlanStepElementStates,
        aliasName: $_aliasNameGenerator(
          db.battlePlanSteps.id,
          db.battlePlanStepElementStates.stepId,
        ),
      );

  $$BattlePlanStepElementStatesTableProcessedTableManager
  get battlePlanStepElementStatesRefs {
    final manager = $$BattlePlanStepElementStatesTableTableManager(
      $_db,
      $_db.battlePlanStepElementStates,
    ).filter((f) => f.stepId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _battlePlanStepElementStatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BattlePlanStepsTableFilterComposer
    extends Composer<_$AppDatabase, $BattlePlanStepsTable> {
  $$BattlePlanStepsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BattlePlansTableFilterComposer get battlePlanId {
    final $$BattlePlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.battlePlanId,
      referencedTable: $db.battlePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlansTableFilterComposer(
            $db: $db,
            $table: $db.battlePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> battlePlanStepElementStatesRefs(
    Expression<bool> Function(
      $$BattlePlanStepElementStatesTableFilterComposer f,
    )
    f,
  ) {
    final $$BattlePlanStepElementStatesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.battlePlanStepElementStates,
          getReferencedColumn: (t) => t.stepId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BattlePlanStepElementStatesTableFilterComposer(
                $db: $db,
                $table: $db.battlePlanStepElementStates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BattlePlanStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $BattlePlanStepsTable> {
  $$BattlePlanStepsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BattlePlansTableOrderingComposer get battlePlanId {
    final $$BattlePlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.battlePlanId,
      referencedTable: $db.battlePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlansTableOrderingComposer(
            $db: $db,
            $table: $db.battlePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BattlePlanStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BattlePlanStepsTable> {
  $$BattlePlanStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BattlePlansTableAnnotationComposer get battlePlanId {
    final $$BattlePlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.battlePlanId,
      referencedTable: $db.battlePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlansTableAnnotationComposer(
            $db: $db,
            $table: $db.battlePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> battlePlanStepElementStatesRefs<T extends Object>(
    Expression<T> Function(
      $$BattlePlanStepElementStatesTableAnnotationComposer a,
    )
    f,
  ) {
    final $$BattlePlanStepElementStatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.battlePlanStepElementStates,
          getReferencedColumn: (t) => t.stepId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BattlePlanStepElementStatesTableAnnotationComposer(
                $db: $db,
                $table: $db.battlePlanStepElementStates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BattlePlanStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BattlePlanStepsTable,
          BattlePlanStep,
          $$BattlePlanStepsTableFilterComposer,
          $$BattlePlanStepsTableOrderingComposer,
          $$BattlePlanStepsTableAnnotationComposer,
          $$BattlePlanStepsTableCreateCompanionBuilder,
          $$BattlePlanStepsTableUpdateCompanionBuilder,
          (BattlePlanStep, $$BattlePlanStepsTableReferences),
          BattlePlanStep,
          PrefetchHooks Function({
            bool battlePlanId,
            bool battlePlanStepElementStatesRefs,
          })
        > {
  $$BattlePlanStepsTableTableManager(
    _$AppDatabase db,
    $BattlePlanStepsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BattlePlanStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BattlePlanStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BattlePlanStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> battlePlanId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BattlePlanStepsCompanion(
                id: id,
                battlePlanId: battlePlanId,
                title: title,
                orderIndex: orderIndex,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int battlePlanId,
                required String title,
                required int orderIndex,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BattlePlanStepsCompanion.insert(
                id: id,
                battlePlanId: battlePlanId,
                title: title,
                orderIndex: orderIndex,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BattlePlanStepsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                battlePlanId = false,
                battlePlanStepElementStatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (battlePlanStepElementStatesRefs)
                      db.battlePlanStepElementStates,
                  ],
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
                        if (battlePlanId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.battlePlanId,
                                    referencedTable:
                                        $$BattlePlanStepsTableReferences
                                            ._battlePlanIdTable(db),
                                    referencedColumn:
                                        $$BattlePlanStepsTableReferences
                                            ._battlePlanIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (battlePlanStepElementStatesRefs)
                        await $_getPrefetchedData<
                          BattlePlanStep,
                          $BattlePlanStepsTable,
                          BattlePlanStepElementState
                        >(
                          currentTable: table,
                          referencedTable: $$BattlePlanStepsTableReferences
                              ._battlePlanStepElementStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BattlePlanStepsTableReferences(
                                db,
                                table,
                                p0,
                              ).battlePlanStepElementStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.stepId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BattlePlanStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BattlePlanStepsTable,
      BattlePlanStep,
      $$BattlePlanStepsTableFilterComposer,
      $$BattlePlanStepsTableOrderingComposer,
      $$BattlePlanStepsTableAnnotationComposer,
      $$BattlePlanStepsTableCreateCompanionBuilder,
      $$BattlePlanStepsTableUpdateCompanionBuilder,
      (BattlePlanStep, $$BattlePlanStepsTableReferences),
      BattlePlanStep,
      PrefetchHooks Function({
        bool battlePlanId,
        bool battlePlanStepElementStatesRefs,
      })
    >;
typedef $$PlanElementsTableCreateCompanionBuilder =
    PlanElementsCompanion Function({
      Value<int> id,
      required int battlePlanId,
      required String type,
      required double x,
      required double y,
      required double width,
      required double height,
      Value<double> rotation,
      required int color,
      Value<String?> label,
      Value<String?> extraJson,
    });
typedef $$PlanElementsTableUpdateCompanionBuilder =
    PlanElementsCompanion Function({
      Value<int> id,
      Value<int> battlePlanId,
      Value<String> type,
      Value<double> x,
      Value<double> y,
      Value<double> width,
      Value<double> height,
      Value<double> rotation,
      Value<int> color,
      Value<String?> label,
      Value<String?> extraJson,
    });

final class $$PlanElementsTableReferences
    extends BaseReferences<_$AppDatabase, $PlanElementsTable, PlanElement> {
  $$PlanElementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BattlePlansTable _battlePlanIdTable(_$AppDatabase db) =>
      db.battlePlans.createAlias(
        $_aliasNameGenerator(db.planElements.battlePlanId, db.battlePlans.id),
      );

  $$BattlePlansTableProcessedTableManager get battlePlanId {
    final $_column = $_itemColumn<int>('battle_plan_id')!;

    final manager = $$BattlePlansTableTableManager(
      $_db,
      $_db.battlePlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_battlePlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $BattlePlanStepElementStatesTable,
    List<BattlePlanStepElementState>
  >
  _battlePlanStepElementStatesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.battlePlanStepElementStates,
        aliasName: $_aliasNameGenerator(
          db.planElements.id,
          db.battlePlanStepElementStates.planElementId,
        ),
      );

  $$BattlePlanStepElementStatesTableProcessedTableManager
  get battlePlanStepElementStatesRefs {
    final manager = $$BattlePlanStepElementStatesTableTableManager(
      $_db,
      $_db.battlePlanStepElementStates,
    ).filter((f) => f.planElementId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _battlePlanStepElementStatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlanElementsTableFilterComposer
    extends Composer<_$AppDatabase, $PlanElementsTable> {
  $$PlanElementsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraJson => $composableBuilder(
    column: $table.extraJson,
    builder: (column) => ColumnFilters(column),
  );

  $$BattlePlansTableFilterComposer get battlePlanId {
    final $$BattlePlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.battlePlanId,
      referencedTable: $db.battlePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlansTableFilterComposer(
            $db: $db,
            $table: $db.battlePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> battlePlanStepElementStatesRefs(
    Expression<bool> Function(
      $$BattlePlanStepElementStatesTableFilterComposer f,
    )
    f,
  ) {
    final $$BattlePlanStepElementStatesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.battlePlanStepElementStates,
          getReferencedColumn: (t) => t.planElementId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BattlePlanStepElementStatesTableFilterComposer(
                $db: $db,
                $table: $db.battlePlanStepElementStates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PlanElementsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanElementsTable> {
  $$PlanElementsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraJson => $composableBuilder(
    column: $table.extraJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$BattlePlansTableOrderingComposer get battlePlanId {
    final $$BattlePlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.battlePlanId,
      referencedTable: $db.battlePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlansTableOrderingComposer(
            $db: $db,
            $table: $db.battlePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanElementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanElementsTable> {
  $$PlanElementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get rotation =>
      $composableBuilder(column: $table.rotation, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get extraJson =>
      $composableBuilder(column: $table.extraJson, builder: (column) => column);

  $$BattlePlansTableAnnotationComposer get battlePlanId {
    final $$BattlePlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.battlePlanId,
      referencedTable: $db.battlePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlansTableAnnotationComposer(
            $db: $db,
            $table: $db.battlePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> battlePlanStepElementStatesRefs<T extends Object>(
    Expression<T> Function(
      $$BattlePlanStepElementStatesTableAnnotationComposer a,
    )
    f,
  ) {
    final $$BattlePlanStepElementStatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.battlePlanStepElementStates,
          getReferencedColumn: (t) => t.planElementId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BattlePlanStepElementStatesTableAnnotationComposer(
                $db: $db,
                $table: $db.battlePlanStepElementStates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PlanElementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanElementsTable,
          PlanElement,
          $$PlanElementsTableFilterComposer,
          $$PlanElementsTableOrderingComposer,
          $$PlanElementsTableAnnotationComposer,
          $$PlanElementsTableCreateCompanionBuilder,
          $$PlanElementsTableUpdateCompanionBuilder,
          (PlanElement, $$PlanElementsTableReferences),
          PlanElement,
          PrefetchHooks Function({
            bool battlePlanId,
            bool battlePlanStepElementStatesRefs,
          })
        > {
  $$PlanElementsTableTableManager(_$AppDatabase db, $PlanElementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanElementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanElementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanElementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> battlePlanId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> x = const Value.absent(),
                Value<double> y = const Value.absent(),
                Value<double> width = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<double> rotation = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String?> extraJson = const Value.absent(),
              }) => PlanElementsCompanion(
                id: id,
                battlePlanId: battlePlanId,
                type: type,
                x: x,
                y: y,
                width: width,
                height: height,
                rotation: rotation,
                color: color,
                label: label,
                extraJson: extraJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int battlePlanId,
                required String type,
                required double x,
                required double y,
                required double width,
                required double height,
                Value<double> rotation = const Value.absent(),
                required int color,
                Value<String?> label = const Value.absent(),
                Value<String?> extraJson = const Value.absent(),
              }) => PlanElementsCompanion.insert(
                id: id,
                battlePlanId: battlePlanId,
                type: type,
                x: x,
                y: y,
                width: width,
                height: height,
                rotation: rotation,
                color: color,
                label: label,
                extraJson: extraJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlanElementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                battlePlanId = false,
                battlePlanStepElementStatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (battlePlanStepElementStatesRefs)
                      db.battlePlanStepElementStates,
                  ],
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
                        if (battlePlanId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.battlePlanId,
                                    referencedTable:
                                        $$PlanElementsTableReferences
                                            ._battlePlanIdTable(db),
                                    referencedColumn:
                                        $$PlanElementsTableReferences
                                            ._battlePlanIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (battlePlanStepElementStatesRefs)
                        await $_getPrefetchedData<
                          PlanElement,
                          $PlanElementsTable,
                          BattlePlanStepElementState
                        >(
                          currentTable: table,
                          referencedTable: $$PlanElementsTableReferences
                              ._battlePlanStepElementStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlanElementsTableReferences(
                                db,
                                table,
                                p0,
                              ).battlePlanStepElementStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.planElementId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlanElementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanElementsTable,
      PlanElement,
      $$PlanElementsTableFilterComposer,
      $$PlanElementsTableOrderingComposer,
      $$PlanElementsTableAnnotationComposer,
      $$PlanElementsTableCreateCompanionBuilder,
      $$PlanElementsTableUpdateCompanionBuilder,
      (PlanElement, $$PlanElementsTableReferences),
      PlanElement,
      PrefetchHooks Function({
        bool battlePlanId,
        bool battlePlanStepElementStatesRefs,
      })
    >;
typedef $$BattlePlanStepElementStatesTableCreateCompanionBuilder =
    BattlePlanStepElementStatesCompanion Function({
      Value<int> id,
      required int stepId,
      required int planElementId,
      required double x,
      required double y,
      required double width,
      required double height,
      Value<double> rotation,
      required int color,
      Value<String?> label,
      Value<bool> isVisible,
    });
typedef $$BattlePlanStepElementStatesTableUpdateCompanionBuilder =
    BattlePlanStepElementStatesCompanion Function({
      Value<int> id,
      Value<int> stepId,
      Value<int> planElementId,
      Value<double> x,
      Value<double> y,
      Value<double> width,
      Value<double> height,
      Value<double> rotation,
      Value<int> color,
      Value<String?> label,
      Value<bool> isVisible,
    });

final class $$BattlePlanStepElementStatesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BattlePlanStepElementStatesTable,
          BattlePlanStepElementState
        > {
  $$BattlePlanStepElementStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BattlePlanStepsTable _stepIdTable(_$AppDatabase db) =>
      db.battlePlanSteps.createAlias(
        $_aliasNameGenerator(
          db.battlePlanStepElementStates.stepId,
          db.battlePlanSteps.id,
        ),
      );

  $$BattlePlanStepsTableProcessedTableManager get stepId {
    final $_column = $_itemColumn<int>('step_id')!;

    final manager = $$BattlePlanStepsTableTableManager(
      $_db,
      $_db.battlePlanSteps,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stepIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlanElementsTable _planElementIdTable(_$AppDatabase db) =>
      db.planElements.createAlias(
        $_aliasNameGenerator(
          db.battlePlanStepElementStates.planElementId,
          db.planElements.id,
        ),
      );

  $$PlanElementsTableProcessedTableManager get planElementId {
    final $_column = $_itemColumn<int>('plan_element_id')!;

    final manager = $$PlanElementsTableTableManager(
      $_db,
      $_db.planElements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planElementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BattlePlanStepElementStatesTableFilterComposer
    extends Composer<_$AppDatabase, $BattlePlanStepElementStatesTable> {
  $$BattlePlanStepElementStatesTableFilterComposer({
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

  ColumnFilters<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnFilters(column),
  );

  $$BattlePlanStepsTableFilterComposer get stepId {
    final $$BattlePlanStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepId,
      referencedTable: $db.battlePlanSteps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlanStepsTableFilterComposer(
            $db: $db,
            $table: $db.battlePlanSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanElementsTableFilterComposer get planElementId {
    final $$PlanElementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planElementId,
      referencedTable: $db.planElements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanElementsTableFilterComposer(
            $db: $db,
            $table: $db.planElements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BattlePlanStepElementStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $BattlePlanStepElementStatesTable> {
  $$BattlePlanStepElementStatesTableOrderingComposer({
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

  ColumnOrderings<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnOrderings(column),
  );

  $$BattlePlanStepsTableOrderingComposer get stepId {
    final $$BattlePlanStepsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepId,
      referencedTable: $db.battlePlanSteps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlanStepsTableOrderingComposer(
            $db: $db,
            $table: $db.battlePlanSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanElementsTableOrderingComposer get planElementId {
    final $$PlanElementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planElementId,
      referencedTable: $db.planElements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanElementsTableOrderingComposer(
            $db: $db,
            $table: $db.planElements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BattlePlanStepElementStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BattlePlanStepElementStatesTable> {
  $$BattlePlanStepElementStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get rotation =>
      $composableBuilder(column: $table.rotation, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get isVisible =>
      $composableBuilder(column: $table.isVisible, builder: (column) => column);

  $$BattlePlanStepsTableAnnotationComposer get stepId {
    final $$BattlePlanStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepId,
      referencedTable: $db.battlePlanSteps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattlePlanStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.battlePlanSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanElementsTableAnnotationComposer get planElementId {
    final $$PlanElementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planElementId,
      referencedTable: $db.planElements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanElementsTableAnnotationComposer(
            $db: $db,
            $table: $db.planElements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BattlePlanStepElementStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BattlePlanStepElementStatesTable,
          BattlePlanStepElementState,
          $$BattlePlanStepElementStatesTableFilterComposer,
          $$BattlePlanStepElementStatesTableOrderingComposer,
          $$BattlePlanStepElementStatesTableAnnotationComposer,
          $$BattlePlanStepElementStatesTableCreateCompanionBuilder,
          $$BattlePlanStepElementStatesTableUpdateCompanionBuilder,
          (
            BattlePlanStepElementState,
            $$BattlePlanStepElementStatesTableReferences,
          ),
          BattlePlanStepElementState,
          PrefetchHooks Function({bool stepId, bool planElementId})
        > {
  $$BattlePlanStepElementStatesTableTableManager(
    _$AppDatabase db,
    $BattlePlanStepElementStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BattlePlanStepElementStatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BattlePlanStepElementStatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BattlePlanStepElementStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> stepId = const Value.absent(),
                Value<int> planElementId = const Value.absent(),
                Value<double> x = const Value.absent(),
                Value<double> y = const Value.absent(),
                Value<double> width = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<double> rotation = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<bool> isVisible = const Value.absent(),
              }) => BattlePlanStepElementStatesCompanion(
                id: id,
                stepId: stepId,
                planElementId: planElementId,
                x: x,
                y: y,
                width: width,
                height: height,
                rotation: rotation,
                color: color,
                label: label,
                isVisible: isVisible,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int stepId,
                required int planElementId,
                required double x,
                required double y,
                required double width,
                required double height,
                Value<double> rotation = const Value.absent(),
                required int color,
                Value<String?> label = const Value.absent(),
                Value<bool> isVisible = const Value.absent(),
              }) => BattlePlanStepElementStatesCompanion.insert(
                id: id,
                stepId: stepId,
                planElementId: planElementId,
                x: x,
                y: y,
                width: width,
                height: height,
                rotation: rotation,
                color: color,
                label: label,
                isVisible: isVisible,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BattlePlanStepElementStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({stepId = false, planElementId = false}) {
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
                    if (stepId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.stepId,
                                referencedTable:
                                    $$BattlePlanStepElementStatesTableReferences
                                        ._stepIdTable(db),
                                referencedColumn:
                                    $$BattlePlanStepElementStatesTableReferences
                                        ._stepIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (planElementId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planElementId,
                                referencedTable:
                                    $$BattlePlanStepElementStatesTableReferences
                                        ._planElementIdTable(db),
                                referencedColumn:
                                    $$BattlePlanStepElementStatesTableReferences
                                        ._planElementIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$BattlePlanStepElementStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BattlePlanStepElementStatesTable,
      BattlePlanStepElementState,
      $$BattlePlanStepElementStatesTableFilterComposer,
      $$BattlePlanStepElementStatesTableOrderingComposer,
      $$BattlePlanStepElementStatesTableAnnotationComposer,
      $$BattlePlanStepElementStatesTableCreateCompanionBuilder,
      $$BattlePlanStepElementStatesTableUpdateCompanionBuilder,
      (
        BattlePlanStepElementState,
        $$BattlePlanStepElementStatesTableReferences,
      ),
      BattlePlanStepElementState,
      PrefetchHooks Function({bool stepId, bool planElementId})
    >;
typedef $$WeaponsTableCreateCompanionBuilder =
    WeaponsCompanion Function({
      Value<int> id,
      required String name,
      required String category,
      required String imagePath,
      required int damage,
      required double fireRate,
      required int ammo,
      required double reloadTime,
      required double range,
      required String description,
    });
typedef $$WeaponsTableUpdateCompanionBuilder =
    WeaponsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> category,
      Value<String> imagePath,
      Value<int> damage,
      Value<double> fireRate,
      Value<int> ammo,
      Value<double> reloadTime,
      Value<double> range,
      Value<String> description,
    });

final class $$WeaponsTableReferences
    extends BaseReferences<_$AppDatabase, $WeaponsTable, Weapon> {
  $$WeaponsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $WeaponAdvancedStatsTable,
    List<WeaponAdvancedStat>
  >
  _weaponAdvancedStatsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weaponAdvancedStats,
        aliasName: $_aliasNameGenerator(
          db.weapons.id,
          db.weaponAdvancedStats.weaponId,
        ),
      );

  $$WeaponAdvancedStatsTableProcessedTableManager get weaponAdvancedStatsRefs {
    final manager = $$WeaponAdvancedStatsTableTableManager(
      $_db,
      $_db.weaponAdvancedStats,
    ).filter((f) => f.weaponId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weaponAdvancedStatsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $WeaponDistanceProfilesTable,
    List<WeaponDistanceProfile>
  >
  _weaponDistanceProfilesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weaponDistanceProfiles,
        aliasName: $_aliasNameGenerator(
          db.weapons.id,
          db.weaponDistanceProfiles.weaponId,
        ),
      );

  $$WeaponDistanceProfilesTableProcessedTableManager
  get weaponDistanceProfilesRefs {
    final manager = $$WeaponDistanceProfilesTableTableManager(
      $_db,
      $_db.weaponDistanceProfiles,
    ).filter((f) => f.weaponId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weaponDistanceProfilesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WeaponsTableFilterComposer
    extends Composer<_$AppDatabase, $WeaponsTable> {
  $$WeaponsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damage => $composableBuilder(
    column: $table.damage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fireRate => $composableBuilder(
    column: $table.fireRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ammo => $composableBuilder(
    column: $table.ammo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reloadTime => $composableBuilder(
    column: $table.reloadTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> weaponAdvancedStatsRefs(
    Expression<bool> Function($$WeaponAdvancedStatsTableFilterComposer f) f,
  ) {
    final $$WeaponAdvancedStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weaponAdvancedStats,
      getReferencedColumn: (t) => t.weaponId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponAdvancedStatsTableFilterComposer(
            $db: $db,
            $table: $db.weaponAdvancedStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weaponDistanceProfilesRefs(
    Expression<bool> Function($$WeaponDistanceProfilesTableFilterComposer f) f,
  ) {
    final $$WeaponDistanceProfilesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weaponDistanceProfiles,
          getReferencedColumn: (t) => t.weaponId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeaponDistanceProfilesTableFilterComposer(
                $db: $db,
                $table: $db.weaponDistanceProfiles,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WeaponsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeaponsTable> {
  $$WeaponsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damage => $composableBuilder(
    column: $table.damage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fireRate => $composableBuilder(
    column: $table.fireRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ammo => $composableBuilder(
    column: $table.ammo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reloadTime => $composableBuilder(
    column: $table.reloadTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeaponsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeaponsTable> {
  $$WeaponsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get damage =>
      $composableBuilder(column: $table.damage, builder: (column) => column);

  GeneratedColumn<double> get fireRate =>
      $composableBuilder(column: $table.fireRate, builder: (column) => column);

  GeneratedColumn<int> get ammo =>
      $composableBuilder(column: $table.ammo, builder: (column) => column);

  GeneratedColumn<double> get reloadTime => $composableBuilder(
    column: $table.reloadTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get range =>
      $composableBuilder(column: $table.range, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> weaponAdvancedStatsRefs<T extends Object>(
    Expression<T> Function($$WeaponAdvancedStatsTableAnnotationComposer a) f,
  ) {
    final $$WeaponAdvancedStatsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weaponAdvancedStats,
          getReferencedColumn: (t) => t.weaponId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeaponAdvancedStatsTableAnnotationComposer(
                $db: $db,
                $table: $db.weaponAdvancedStats,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> weaponDistanceProfilesRefs<T extends Object>(
    Expression<T> Function($$WeaponDistanceProfilesTableAnnotationComposer a) f,
  ) {
    final $$WeaponDistanceProfilesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weaponDistanceProfiles,
          getReferencedColumn: (t) => t.weaponId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeaponDistanceProfilesTableAnnotationComposer(
                $db: $db,
                $table: $db.weaponDistanceProfiles,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WeaponsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeaponsTable,
          Weapon,
          $$WeaponsTableFilterComposer,
          $$WeaponsTableOrderingComposer,
          $$WeaponsTableAnnotationComposer,
          $$WeaponsTableCreateCompanionBuilder,
          $$WeaponsTableUpdateCompanionBuilder,
          (Weapon, $$WeaponsTableReferences),
          Weapon,
          PrefetchHooks Function({
            bool weaponAdvancedStatsRefs,
            bool weaponDistanceProfilesRefs,
          })
        > {
  $$WeaponsTableTableManager(_$AppDatabase db, $WeaponsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeaponsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeaponsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeaponsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<int> damage = const Value.absent(),
                Value<double> fireRate = const Value.absent(),
                Value<int> ammo = const Value.absent(),
                Value<double> reloadTime = const Value.absent(),
                Value<double> range = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => WeaponsCompanion(
                id: id,
                name: name,
                category: category,
                imagePath: imagePath,
                damage: damage,
                fireRate: fireRate,
                ammo: ammo,
                reloadTime: reloadTime,
                range: range,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String category,
                required String imagePath,
                required int damage,
                required double fireRate,
                required int ammo,
                required double reloadTime,
                required double range,
                required String description,
              }) => WeaponsCompanion.insert(
                id: id,
                name: name,
                category: category,
                imagePath: imagePath,
                damage: damage,
                fireRate: fireRate,
                ammo: ammo,
                reloadTime: reloadTime,
                range: range,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeaponsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                weaponAdvancedStatsRefs = false,
                weaponDistanceProfilesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (weaponAdvancedStatsRefs) db.weaponAdvancedStats,
                    if (weaponDistanceProfilesRefs) db.weaponDistanceProfiles,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (weaponAdvancedStatsRefs)
                        await $_getPrefetchedData<
                          Weapon,
                          $WeaponsTable,
                          WeaponAdvancedStat
                        >(
                          currentTable: table,
                          referencedTable: $$WeaponsTableReferences
                              ._weaponAdvancedStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeaponsTableReferences(
                                db,
                                table,
                                p0,
                              ).weaponAdvancedStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weaponId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weaponDistanceProfilesRefs)
                        await $_getPrefetchedData<
                          Weapon,
                          $WeaponsTable,
                          WeaponDistanceProfile
                        >(
                          currentTable: table,
                          referencedTable: $$WeaponsTableReferences
                              ._weaponDistanceProfilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeaponsTableReferences(
                                db,
                                table,
                                p0,
                              ).weaponDistanceProfilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weaponId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WeaponsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeaponsTable,
      Weapon,
      $$WeaponsTableFilterComposer,
      $$WeaponsTableOrderingComposer,
      $$WeaponsTableAnnotationComposer,
      $$WeaponsTableCreateCompanionBuilder,
      $$WeaponsTableUpdateCompanionBuilder,
      (Weapon, $$WeaponsTableReferences),
      Weapon,
      PrefetchHooks Function({
        bool weaponAdvancedStatsRefs,
        bool weaponDistanceProfilesRefs,
      })
    >;
typedef $$WeaponAdvancedStatsTableCreateCompanionBuilder =
    WeaponAdvancedStatsCompanion Function({
      Value<int> weaponId,
      required int headDamage,
      required int bodyDamage,
      required int limbDamage,
      Value<double?> preciseHeadDamage,
      Value<double?> preciseBodyDamage,
      Value<double?> preciseLimbDamage,
      required double averageDamage,
      required double bulletSpreadDegrees,
      required double bulletVelocity,
      required double equipTime,
      Value<String?> rangeMinLabel,
      Value<String?> rangeMaxLabel,
      Value<double?> accuracy,
      Value<double?> mobility,
      Value<String?> tagsJson,
    });
typedef $$WeaponAdvancedStatsTableUpdateCompanionBuilder =
    WeaponAdvancedStatsCompanion Function({
      Value<int> weaponId,
      Value<int> headDamage,
      Value<int> bodyDamage,
      Value<int> limbDamage,
      Value<double?> preciseHeadDamage,
      Value<double?> preciseBodyDamage,
      Value<double?> preciseLimbDamage,
      Value<double> averageDamage,
      Value<double> bulletSpreadDegrees,
      Value<double> bulletVelocity,
      Value<double> equipTime,
      Value<String?> rangeMinLabel,
      Value<String?> rangeMaxLabel,
      Value<double?> accuracy,
      Value<double?> mobility,
      Value<String?> tagsJson,
    });

final class $$WeaponAdvancedStatsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeaponAdvancedStatsTable,
          WeaponAdvancedStat
        > {
  $$WeaponAdvancedStatsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeaponsTable _weaponIdTable(_$AppDatabase db) =>
      db.weapons.createAlias(
        $_aliasNameGenerator(db.weaponAdvancedStats.weaponId, db.weapons.id),
      );

  $$WeaponsTableProcessedTableManager get weaponId {
    final $_column = $_itemColumn<int>('weapon_id')!;

    final manager = $$WeaponsTableTableManager(
      $_db,
      $_db.weapons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weaponIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeaponAdvancedStatsTableFilterComposer
    extends Composer<_$AppDatabase, $WeaponAdvancedStatsTable> {
  $$WeaponAdvancedStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get headDamage => $composableBuilder(
    column: $table.headDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bodyDamage => $composableBuilder(
    column: $table.bodyDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limbDamage => $composableBuilder(
    column: $table.limbDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get preciseHeadDamage => $composableBuilder(
    column: $table.preciseHeadDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get preciseBodyDamage => $composableBuilder(
    column: $table.preciseBodyDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get preciseLimbDamage => $composableBuilder(
    column: $table.preciseLimbDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageDamage => $composableBuilder(
    column: $table.averageDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bulletSpreadDegrees => $composableBuilder(
    column: $table.bulletSpreadDegrees,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bulletVelocity => $composableBuilder(
    column: $table.bulletVelocity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get equipTime => $composableBuilder(
    column: $table.equipTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rangeMinLabel => $composableBuilder(
    column: $table.rangeMinLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rangeMaxLabel => $composableBuilder(
    column: $table.rangeMaxLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mobility => $composableBuilder(
    column: $table.mobility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$WeaponsTableFilterComposer get weaponId {
    final $$WeaponsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weaponId,
      referencedTable: $db.weapons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponsTableFilterComposer(
            $db: $db,
            $table: $db.weapons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponAdvancedStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeaponAdvancedStatsTable> {
  $$WeaponAdvancedStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get headDamage => $composableBuilder(
    column: $table.headDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bodyDamage => $composableBuilder(
    column: $table.bodyDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limbDamage => $composableBuilder(
    column: $table.limbDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get preciseHeadDamage => $composableBuilder(
    column: $table.preciseHeadDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get preciseBodyDamage => $composableBuilder(
    column: $table.preciseBodyDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get preciseLimbDamage => $composableBuilder(
    column: $table.preciseLimbDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageDamage => $composableBuilder(
    column: $table.averageDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bulletSpreadDegrees => $composableBuilder(
    column: $table.bulletSpreadDegrees,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bulletVelocity => $composableBuilder(
    column: $table.bulletVelocity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get equipTime => $composableBuilder(
    column: $table.equipTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rangeMinLabel => $composableBuilder(
    column: $table.rangeMinLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rangeMaxLabel => $composableBuilder(
    column: $table.rangeMaxLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mobility => $composableBuilder(
    column: $table.mobility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeaponsTableOrderingComposer get weaponId {
    final $$WeaponsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weaponId,
      referencedTable: $db.weapons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponsTableOrderingComposer(
            $db: $db,
            $table: $db.weapons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponAdvancedStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeaponAdvancedStatsTable> {
  $$WeaponAdvancedStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get headDamage => $composableBuilder(
    column: $table.headDamage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bodyDamage => $composableBuilder(
    column: $table.bodyDamage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get limbDamage => $composableBuilder(
    column: $table.limbDamage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get preciseHeadDamage => $composableBuilder(
    column: $table.preciseHeadDamage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get preciseBodyDamage => $composableBuilder(
    column: $table.preciseBodyDamage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get preciseLimbDamage => $composableBuilder(
    column: $table.preciseLimbDamage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averageDamage => $composableBuilder(
    column: $table.averageDamage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bulletSpreadDegrees => $composableBuilder(
    column: $table.bulletSpreadDegrees,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bulletVelocity => $composableBuilder(
    column: $table.bulletVelocity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get equipTime =>
      $composableBuilder(column: $table.equipTime, builder: (column) => column);

  GeneratedColumn<String> get rangeMinLabel => $composableBuilder(
    column: $table.rangeMinLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rangeMaxLabel => $composableBuilder(
    column: $table.rangeMaxLabel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get mobility =>
      $composableBuilder(column: $table.mobility, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  $$WeaponsTableAnnotationComposer get weaponId {
    final $$WeaponsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weaponId,
      referencedTable: $db.weapons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponsTableAnnotationComposer(
            $db: $db,
            $table: $db.weapons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponAdvancedStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeaponAdvancedStatsTable,
          WeaponAdvancedStat,
          $$WeaponAdvancedStatsTableFilterComposer,
          $$WeaponAdvancedStatsTableOrderingComposer,
          $$WeaponAdvancedStatsTableAnnotationComposer,
          $$WeaponAdvancedStatsTableCreateCompanionBuilder,
          $$WeaponAdvancedStatsTableUpdateCompanionBuilder,
          (WeaponAdvancedStat, $$WeaponAdvancedStatsTableReferences),
          WeaponAdvancedStat,
          PrefetchHooks Function({bool weaponId})
        > {
  $$WeaponAdvancedStatsTableTableManager(
    _$AppDatabase db,
    $WeaponAdvancedStatsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeaponAdvancedStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeaponAdvancedStatsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeaponAdvancedStatsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> weaponId = const Value.absent(),
                Value<int> headDamage = const Value.absent(),
                Value<int> bodyDamage = const Value.absent(),
                Value<int> limbDamage = const Value.absent(),
                Value<double?> preciseHeadDamage = const Value.absent(),
                Value<double?> preciseBodyDamage = const Value.absent(),
                Value<double?> preciseLimbDamage = const Value.absent(),
                Value<double> averageDamage = const Value.absent(),
                Value<double> bulletSpreadDegrees = const Value.absent(),
                Value<double> bulletVelocity = const Value.absent(),
                Value<double> equipTime = const Value.absent(),
                Value<String?> rangeMinLabel = const Value.absent(),
                Value<String?> rangeMaxLabel = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<double?> mobility = const Value.absent(),
                Value<String?> tagsJson = const Value.absent(),
              }) => WeaponAdvancedStatsCompanion(
                weaponId: weaponId,
                headDamage: headDamage,
                bodyDamage: bodyDamage,
                limbDamage: limbDamage,
                preciseHeadDamage: preciseHeadDamage,
                preciseBodyDamage: preciseBodyDamage,
                preciseLimbDamage: preciseLimbDamage,
                averageDamage: averageDamage,
                bulletSpreadDegrees: bulletSpreadDegrees,
                bulletVelocity: bulletVelocity,
                equipTime: equipTime,
                rangeMinLabel: rangeMinLabel,
                rangeMaxLabel: rangeMaxLabel,
                accuracy: accuracy,
                mobility: mobility,
                tagsJson: tagsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> weaponId = const Value.absent(),
                required int headDamage,
                required int bodyDamage,
                required int limbDamage,
                Value<double?> preciseHeadDamage = const Value.absent(),
                Value<double?> preciseBodyDamage = const Value.absent(),
                Value<double?> preciseLimbDamage = const Value.absent(),
                required double averageDamage,
                required double bulletSpreadDegrees,
                required double bulletVelocity,
                required double equipTime,
                Value<String?> rangeMinLabel = const Value.absent(),
                Value<String?> rangeMaxLabel = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<double?> mobility = const Value.absent(),
                Value<String?> tagsJson = const Value.absent(),
              }) => WeaponAdvancedStatsCompanion.insert(
                weaponId: weaponId,
                headDamage: headDamage,
                bodyDamage: bodyDamage,
                limbDamage: limbDamage,
                preciseHeadDamage: preciseHeadDamage,
                preciseBodyDamage: preciseBodyDamage,
                preciseLimbDamage: preciseLimbDamage,
                averageDamage: averageDamage,
                bulletSpreadDegrees: bulletSpreadDegrees,
                bulletVelocity: bulletVelocity,
                equipTime: equipTime,
                rangeMinLabel: rangeMinLabel,
                rangeMaxLabel: rangeMaxLabel,
                accuracy: accuracy,
                mobility: mobility,
                tagsJson: tagsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeaponAdvancedStatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weaponId = false}) {
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
                    if (weaponId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.weaponId,
                                referencedTable:
                                    $$WeaponAdvancedStatsTableReferences
                                        ._weaponIdTable(db),
                                referencedColumn:
                                    $$WeaponAdvancedStatsTableReferences
                                        ._weaponIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$WeaponAdvancedStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeaponAdvancedStatsTable,
      WeaponAdvancedStat,
      $$WeaponAdvancedStatsTableFilterComposer,
      $$WeaponAdvancedStatsTableOrderingComposer,
      $$WeaponAdvancedStatsTableAnnotationComposer,
      $$WeaponAdvancedStatsTableCreateCompanionBuilder,
      $$WeaponAdvancedStatsTableUpdateCompanionBuilder,
      (WeaponAdvancedStat, $$WeaponAdvancedStatsTableReferences),
      WeaponAdvancedStat,
      PrefetchHooks Function({bool weaponId})
    >;
typedef $$WeaponDistanceProfilesTableCreateCompanionBuilder =
    WeaponDistanceProfilesCompanion Function({
      Value<int> id,
      required int weaponId,
      required String distanceLabel,
      required double damageMultiplier,
    });
typedef $$WeaponDistanceProfilesTableUpdateCompanionBuilder =
    WeaponDistanceProfilesCompanion Function({
      Value<int> id,
      Value<int> weaponId,
      Value<String> distanceLabel,
      Value<double> damageMultiplier,
    });

final class $$WeaponDistanceProfilesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeaponDistanceProfilesTable,
          WeaponDistanceProfile
        > {
  $$WeaponDistanceProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeaponsTable _weaponIdTable(_$AppDatabase db) =>
      db.weapons.createAlias(
        $_aliasNameGenerator(db.weaponDistanceProfiles.weaponId, db.weapons.id),
      );

  $$WeaponsTableProcessedTableManager get weaponId {
    final $_column = $_itemColumn<int>('weapon_id')!;

    final manager = $$WeaponsTableTableManager(
      $_db,
      $_db.weapons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weaponIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeaponDistanceProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $WeaponDistanceProfilesTable> {
  $$WeaponDistanceProfilesTableFilterComposer({
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

  ColumnFilters<String> get distanceLabel => $composableBuilder(
    column: $table.distanceLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get damageMultiplier => $composableBuilder(
    column: $table.damageMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  $$WeaponsTableFilterComposer get weaponId {
    final $$WeaponsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weaponId,
      referencedTable: $db.weapons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponsTableFilterComposer(
            $db: $db,
            $table: $db.weapons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponDistanceProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeaponDistanceProfilesTable> {
  $$WeaponDistanceProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get distanceLabel => $composableBuilder(
    column: $table.distanceLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get damageMultiplier => $composableBuilder(
    column: $table.damageMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeaponsTableOrderingComposer get weaponId {
    final $$WeaponsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weaponId,
      referencedTable: $db.weapons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponsTableOrderingComposer(
            $db: $db,
            $table: $db.weapons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponDistanceProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeaponDistanceProfilesTable> {
  $$WeaponDistanceProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get distanceLabel => $composableBuilder(
    column: $table.distanceLabel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get damageMultiplier => $composableBuilder(
    column: $table.damageMultiplier,
    builder: (column) => column,
  );

  $$WeaponsTableAnnotationComposer get weaponId {
    final $$WeaponsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weaponId,
      referencedTable: $db.weapons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponsTableAnnotationComposer(
            $db: $db,
            $table: $db.weapons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponDistanceProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeaponDistanceProfilesTable,
          WeaponDistanceProfile,
          $$WeaponDistanceProfilesTableFilterComposer,
          $$WeaponDistanceProfilesTableOrderingComposer,
          $$WeaponDistanceProfilesTableAnnotationComposer,
          $$WeaponDistanceProfilesTableCreateCompanionBuilder,
          $$WeaponDistanceProfilesTableUpdateCompanionBuilder,
          (WeaponDistanceProfile, $$WeaponDistanceProfilesTableReferences),
          WeaponDistanceProfile,
          PrefetchHooks Function({bool weaponId})
        > {
  $$WeaponDistanceProfilesTableTableManager(
    _$AppDatabase db,
    $WeaponDistanceProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeaponDistanceProfilesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WeaponDistanceProfilesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeaponDistanceProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> weaponId = const Value.absent(),
                Value<String> distanceLabel = const Value.absent(),
                Value<double> damageMultiplier = const Value.absent(),
              }) => WeaponDistanceProfilesCompanion(
                id: id,
                weaponId: weaponId,
                distanceLabel: distanceLabel,
                damageMultiplier: damageMultiplier,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int weaponId,
                required String distanceLabel,
                required double damageMultiplier,
              }) => WeaponDistanceProfilesCompanion.insert(
                id: id,
                weaponId: weaponId,
                distanceLabel: distanceLabel,
                damageMultiplier: damageMultiplier,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeaponDistanceProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weaponId = false}) {
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
                    if (weaponId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.weaponId,
                                referencedTable:
                                    $$WeaponDistanceProfilesTableReferences
                                        ._weaponIdTable(db),
                                referencedColumn:
                                    $$WeaponDistanceProfilesTableReferences
                                        ._weaponIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$WeaponDistanceProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeaponDistanceProfilesTable,
      WeaponDistanceProfile,
      $$WeaponDistanceProfilesTableFilterComposer,
      $$WeaponDistanceProfilesTableOrderingComposer,
      $$WeaponDistanceProfilesTableAnnotationComposer,
      $$WeaponDistanceProfilesTableCreateCompanionBuilder,
      $$WeaponDistanceProfilesTableUpdateCompanionBuilder,
      (WeaponDistanceProfile, $$WeaponDistanceProfilesTableReferences),
      WeaponDistanceProfile,
      PrefetchHooks Function({bool weaponId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MapAssetsTableTableManager get mapAssets =>
      $$MapAssetsTableTableManager(_db, _db.mapAssets);
  $$BattlePlansTableTableManager get battlePlans =>
      $$BattlePlansTableTableManager(_db, _db.battlePlans);
  $$BattlePlanStepsTableTableManager get battlePlanSteps =>
      $$BattlePlanStepsTableTableManager(_db, _db.battlePlanSteps);
  $$PlanElementsTableTableManager get planElements =>
      $$PlanElementsTableTableManager(_db, _db.planElements);
  $$BattlePlanStepElementStatesTableTableManager
  get battlePlanStepElementStates =>
      $$BattlePlanStepElementStatesTableTableManager(
        _db,
        _db.battlePlanStepElementStates,
      );
  $$WeaponsTableTableManager get weapons =>
      $$WeaponsTableTableManager(_db, _db.weapons);
  $$WeaponAdvancedStatsTableTableManager get weaponAdvancedStats =>
      $$WeaponAdvancedStatsTableTableManager(_db, _db.weaponAdvancedStats);
  $$WeaponDistanceProfilesTableTableManager get weaponDistanceProfiles =>
      $$WeaponDistanceProfilesTableTableManager(
        _db,
        _db.weaponDistanceProfiles,
      );
}
