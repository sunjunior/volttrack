// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialMileageKmMeta = const VerificationMeta(
    'initialMileageKm',
  );
  @override
  late final GeneratedColumn<double> initialMileageKm = GeneratedColumn<double>(
    'initial_mileage_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _initialSocPctMeta = const VerificationMeta(
    'initialSocPct',
  );
  @override
  late final GeneratedColumn<int> initialSocPct = GeneratedColumn<int>(
    'initial_soc_pct',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brand,
    model,
    purchaseDate,
    initialMileageKm,
    initialSocPct,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('initial_mileage_km')) {
      context.handle(
        _initialMileageKmMeta,
        initialMileageKm.isAcceptableOrUnknown(
          data['initial_mileage_km']!,
          _initialMileageKmMeta,
        ),
      );
    }
    if (data.containsKey('initial_soc_pct')) {
      context.handle(
        _initialSocPctMeta,
        initialSocPct.isAcceptableOrUnknown(
          data['initial_soc_pct']!,
          _initialSocPctMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      ),
      initialMileageKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_mileage_km'],
      )!,
      initialSocPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_soc_pct'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final int id;
  final String brand;
  final String model;
  final DateTime? purchaseDate;
  final double initialMileageKm;
  final int? initialSocPct;
  final String? note;
  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    this.purchaseDate,
    required this.initialMileageKm,
    this.initialSocPct,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    map['initial_mileage_km'] = Variable<double>(initialMileageKm);
    if (!nullToAbsent || initialSocPct != null) {
      map['initial_soc_pct'] = Variable<int>(initialSocPct);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      brand: Value(brand),
      model: Value(model),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      initialMileageKm: Value(initialMileageKm),
      initialSocPct: initialSocPct == null && nullToAbsent
          ? const Value.absent()
          : Value(initialSocPct),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<int>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      initialMileageKm: serializer.fromJson<double>(json['initialMileageKm']),
      initialSocPct: serializer.fromJson<int?>(json['initialSocPct']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'initialMileageKm': serializer.toJson<double>(initialMileageKm),
      'initialSocPct': serializer.toJson<int?>(initialSocPct),
      'note': serializer.toJson<String?>(note),
    };
  }

  Vehicle copyWith({
    int? id,
    String? brand,
    String? model,
    Value<DateTime?> purchaseDate = const Value.absent(),
    double? initialMileageKm,
    Value<int?> initialSocPct = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Vehicle(
    id: id ?? this.id,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    initialMileageKm: initialMileageKm ?? this.initialMileageKm,
    initialSocPct: initialSocPct.present
        ? initialSocPct.value
        : this.initialSocPct,
    note: note.present ? note.value : this.note,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      initialMileageKm: data.initialMileageKm.present
          ? data.initialMileageKm.value
          : this.initialMileageKm,
      initialSocPct: data.initialSocPct.present
          ? data.initialSocPct.value
          : this.initialSocPct,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('initialMileageKm: $initialMileageKm, ')
          ..write('initialSocPct: $initialSocPct, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brand,
    model,
    purchaseDate,
    initialMileageKm,
    initialSocPct,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.purchaseDate == this.purchaseDate &&
          other.initialMileageKm == this.initialMileageKm &&
          other.initialSocPct == this.initialSocPct &&
          other.note == this.note);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<int> id;
  final Value<String> brand;
  final Value<String> model;
  final Value<DateTime?> purchaseDate;
  final Value<double> initialMileageKm;
  final Value<int?> initialSocPct;
  final Value<String?> note;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.initialMileageKm = const Value.absent(),
    this.initialSocPct = const Value.absent(),
    this.note = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    required String brand,
    required String model,
    this.purchaseDate = const Value.absent(),
    this.initialMileageKm = const Value.absent(),
    this.initialSocPct = const Value.absent(),
    this.note = const Value.absent(),
  }) : brand = Value(brand),
       model = Value(model);
  static Insertable<Vehicle> custom({
    Expression<int>? id,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<DateTime>? purchaseDate,
    Expression<double>? initialMileageKm,
    Expression<int>? initialSocPct,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (initialMileageKm != null) 'initial_mileage_km': initialMileageKm,
      if (initialSocPct != null) 'initial_soc_pct': initialSocPct,
      if (note != null) 'note': note,
    });
  }

  VehiclesCompanion copyWith({
    Value<int>? id,
    Value<String>? brand,
    Value<String>? model,
    Value<DateTime?>? purchaseDate,
    Value<double>? initialMileageKm,
    Value<int?>? initialSocPct,
    Value<String?>? note,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      initialMileageKm: initialMileageKm ?? this.initialMileageKm,
      initialSocPct: initialSocPct ?? this.initialSocPct,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (initialMileageKm.present) {
      map['initial_mileage_km'] = Variable<double>(initialMileageKm.value);
    }
    if (initialSocPct.present) {
      map['initial_soc_pct'] = Variable<int>(initialSocPct.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('initialMileageKm: $initialMileageKm, ')
          ..write('initialSocPct: $initialSocPct, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $BatteriesTable extends Batteries
    with TableInfo<$BatteriesTable, Battery> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatteriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BatteryType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BatteryType>($BatteriesTable.$convertertype);
  static const VerificationMeta _voltageVMeta = const VerificationMeta(
    'voltageV',
  );
  @override
  late final GeneratedColumn<double> voltageV = GeneratedColumn<double>(
    'voltage_v',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacityAhMeta = const VerificationMeta(
    'capacityAh',
  );
  @override
  late final GeneratedColumn<double> capacityAh = GeneratedColumn<double>(
    'capacity_ah',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overrideCapacityKwhMeta =
      const VerificationMeta('overrideCapacityKwh');
  @override
  late final GeneratedColumn<double> overrideCapacityKwh =
      GeneratedColumn<double>(
        'override_capacity_kwh',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _theoreticalRangeKmMeta =
      const VerificationMeta('theoreticalRangeKm');
  @override
  late final GeneratedColumn<double> theoreticalRangeKm =
      GeneratedColumn<double>(
        'theoretical_range_km',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deactivatedAtMeta = const VerificationMeta(
    'deactivatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deactivatedAt =
      GeneratedColumn<DateTime>(
        'deactivated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    name,
    type,
    voltageV,
    capacityAh,
    overrideCapacityKwh,
    theoreticalRangeKm,
    installedAt,
    deactivatedAt,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batteries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Battery> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('voltage_v')) {
      context.handle(
        _voltageVMeta,
        voltageV.isAcceptableOrUnknown(data['voltage_v']!, _voltageVMeta),
      );
    } else if (isInserting) {
      context.missing(_voltageVMeta);
    }
    if (data.containsKey('capacity_ah')) {
      context.handle(
        _capacityAhMeta,
        capacityAh.isAcceptableOrUnknown(data['capacity_ah']!, _capacityAhMeta),
      );
    } else if (isInserting) {
      context.missing(_capacityAhMeta);
    }
    if (data.containsKey('override_capacity_kwh')) {
      context.handle(
        _overrideCapacityKwhMeta,
        overrideCapacityKwh.isAcceptableOrUnknown(
          data['override_capacity_kwh']!,
          _overrideCapacityKwhMeta,
        ),
      );
    }
    if (data.containsKey('theoretical_range_km')) {
      context.handle(
        _theoreticalRangeKmMeta,
        theoreticalRangeKm.isAcceptableOrUnknown(
          data['theoretical_range_km']!,
          _theoreticalRangeKmMeta,
        ),
      );
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    if (data.containsKey('deactivated_at')) {
      context.handle(
        _deactivatedAtMeta,
        deactivatedAt.isAcceptableOrUnknown(
          data['deactivated_at']!,
          _deactivatedAtMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Battery map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Battery(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $BatteriesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      voltageV: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}voltage_v'],
      )!,
      capacityAh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}capacity_ah'],
      )!,
      overrideCapacityKwh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}override_capacity_kwh'],
      ),
      theoreticalRangeKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}theoretical_range_km'],
      ),
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      )!,
      deactivatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deactivated_at'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $BatteriesTable createAlias(String alias) {
    return $BatteriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BatteryType, String, String> $convertertype =
      const EnumNameConverter<BatteryType>(BatteryType.values);
}

class Battery extends DataClass implements Insertable<Battery> {
  final int id;
  final int vehicleId;
  final String name;
  final BatteryType type;
  final double voltageV;
  final double capacityAh;
  final double? overrideCapacityKwh;
  final double? theoreticalRangeKm;
  final DateTime installedAt;
  final DateTime? deactivatedAt;
  final bool active;
  const Battery({
    required this.id,
    required this.vehicleId,
    required this.name,
    required this.type,
    required this.voltageV,
    required this.capacityAh,
    this.overrideCapacityKwh,
    this.theoreticalRangeKm,
    required this.installedAt,
    this.deactivatedAt,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>(
        $BatteriesTable.$convertertype.toSql(type),
      );
    }
    map['voltage_v'] = Variable<double>(voltageV);
    map['capacity_ah'] = Variable<double>(capacityAh);
    if (!nullToAbsent || overrideCapacityKwh != null) {
      map['override_capacity_kwh'] = Variable<double>(overrideCapacityKwh);
    }
    if (!nullToAbsent || theoreticalRangeKm != null) {
      map['theoretical_range_km'] = Variable<double>(theoreticalRangeKm);
    }
    map['installed_at'] = Variable<DateTime>(installedAt);
    if (!nullToAbsent || deactivatedAt != null) {
      map['deactivated_at'] = Variable<DateTime>(deactivatedAt);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  BatteriesCompanion toCompanion(bool nullToAbsent) {
    return BatteriesCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      name: Value(name),
      type: Value(type),
      voltageV: Value(voltageV),
      capacityAh: Value(capacityAh),
      overrideCapacityKwh: overrideCapacityKwh == null && nullToAbsent
          ? const Value.absent()
          : Value(overrideCapacityKwh),
      theoreticalRangeKm: theoreticalRangeKm == null && nullToAbsent
          ? const Value.absent()
          : Value(theoreticalRangeKm),
      installedAt: Value(installedAt),
      deactivatedAt: deactivatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deactivatedAt),
      active: Value(active),
    );
  }

  factory Battery.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Battery(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      name: serializer.fromJson<String>(json['name']),
      type: $BatteriesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      voltageV: serializer.fromJson<double>(json['voltageV']),
      capacityAh: serializer.fromJson<double>(json['capacityAh']),
      overrideCapacityKwh: serializer.fromJson<double?>(
        json['overrideCapacityKwh'],
      ),
      theoreticalRangeKm: serializer.fromJson<double?>(
        json['theoreticalRangeKm'],
      ),
      installedAt: serializer.fromJson<DateTime>(json['installedAt']),
      deactivatedAt: serializer.fromJson<DateTime?>(json['deactivatedAt']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $BatteriesTable.$convertertype.toJson(type),
      ),
      'voltageV': serializer.toJson<double>(voltageV),
      'capacityAh': serializer.toJson<double>(capacityAh),
      'overrideCapacityKwh': serializer.toJson<double?>(overrideCapacityKwh),
      'theoreticalRangeKm': serializer.toJson<double?>(theoreticalRangeKm),
      'installedAt': serializer.toJson<DateTime>(installedAt),
      'deactivatedAt': serializer.toJson<DateTime?>(deactivatedAt),
      'active': serializer.toJson<bool>(active),
    };
  }

  Battery copyWith({
    int? id,
    int? vehicleId,
    String? name,
    BatteryType? type,
    double? voltageV,
    double? capacityAh,
    Value<double?> overrideCapacityKwh = const Value.absent(),
    Value<double?> theoreticalRangeKm = const Value.absent(),
    DateTime? installedAt,
    Value<DateTime?> deactivatedAt = const Value.absent(),
    bool? active,
  }) => Battery(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    name: name ?? this.name,
    type: type ?? this.type,
    voltageV: voltageV ?? this.voltageV,
    capacityAh: capacityAh ?? this.capacityAh,
    overrideCapacityKwh: overrideCapacityKwh.present
        ? overrideCapacityKwh.value
        : this.overrideCapacityKwh,
    theoreticalRangeKm: theoreticalRangeKm.present
        ? theoreticalRangeKm.value
        : this.theoreticalRangeKm,
    installedAt: installedAt ?? this.installedAt,
    deactivatedAt: deactivatedAt.present
        ? deactivatedAt.value
        : this.deactivatedAt,
    active: active ?? this.active,
  );
  Battery copyWithCompanion(BatteriesCompanion data) {
    return Battery(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      voltageV: data.voltageV.present ? data.voltageV.value : this.voltageV,
      capacityAh: data.capacityAh.present
          ? data.capacityAh.value
          : this.capacityAh,
      overrideCapacityKwh: data.overrideCapacityKwh.present
          ? data.overrideCapacityKwh.value
          : this.overrideCapacityKwh,
      theoreticalRangeKm: data.theoreticalRangeKm.present
          ? data.theoreticalRangeKm.value
          : this.theoreticalRangeKm,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
      deactivatedAt: data.deactivatedAt.present
          ? data.deactivatedAt.value
          : this.deactivatedAt,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Battery(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('voltageV: $voltageV, ')
          ..write('capacityAh: $capacityAh, ')
          ..write('overrideCapacityKwh: $overrideCapacityKwh, ')
          ..write('theoreticalRangeKm: $theoreticalRangeKm, ')
          ..write('installedAt: $installedAt, ')
          ..write('deactivatedAt: $deactivatedAt, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    name,
    type,
    voltageV,
    capacityAh,
    overrideCapacityKwh,
    theoreticalRangeKm,
    installedAt,
    deactivatedAt,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Battery &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.name == this.name &&
          other.type == this.type &&
          other.voltageV == this.voltageV &&
          other.capacityAh == this.capacityAh &&
          other.overrideCapacityKwh == this.overrideCapacityKwh &&
          other.theoreticalRangeKm == this.theoreticalRangeKm &&
          other.installedAt == this.installedAt &&
          other.deactivatedAt == this.deactivatedAt &&
          other.active == this.active);
}

class BatteriesCompanion extends UpdateCompanion<Battery> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<String> name;
  final Value<BatteryType> type;
  final Value<double> voltageV;
  final Value<double> capacityAh;
  final Value<double?> overrideCapacityKwh;
  final Value<double?> theoreticalRangeKm;
  final Value<DateTime> installedAt;
  final Value<DateTime?> deactivatedAt;
  final Value<bool> active;
  const BatteriesCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.voltageV = const Value.absent(),
    this.capacityAh = const Value.absent(),
    this.overrideCapacityKwh = const Value.absent(),
    this.theoreticalRangeKm = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.deactivatedAt = const Value.absent(),
    this.active = const Value.absent(),
  });
  BatteriesCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required String name,
    required BatteryType type,
    required double voltageV,
    required double capacityAh,
    this.overrideCapacityKwh = const Value.absent(),
    this.theoreticalRangeKm = const Value.absent(),
    required DateTime installedAt,
    this.deactivatedAt = const Value.absent(),
    this.active = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       name = Value(name),
       type = Value(type),
       voltageV = Value(voltageV),
       capacityAh = Value(capacityAh),
       installedAt = Value(installedAt);
  static Insertable<Battery> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? voltageV,
    Expression<double>? capacityAh,
    Expression<double>? overrideCapacityKwh,
    Expression<double>? theoreticalRangeKm,
    Expression<DateTime>? installedAt,
    Expression<DateTime>? deactivatedAt,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (voltageV != null) 'voltage_v': voltageV,
      if (capacityAh != null) 'capacity_ah': capacityAh,
      if (overrideCapacityKwh != null)
        'override_capacity_kwh': overrideCapacityKwh,
      if (theoreticalRangeKm != null)
        'theoretical_range_km': theoreticalRangeKm,
      if (installedAt != null) 'installed_at': installedAt,
      if (deactivatedAt != null) 'deactivated_at': deactivatedAt,
      if (active != null) 'active': active,
    });
  }

  BatteriesCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<String>? name,
    Value<BatteryType>? type,
    Value<double>? voltageV,
    Value<double>? capacityAh,
    Value<double?>? overrideCapacityKwh,
    Value<double?>? theoreticalRangeKm,
    Value<DateTime>? installedAt,
    Value<DateTime?>? deactivatedAt,
    Value<bool>? active,
  }) {
    return BatteriesCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      name: name ?? this.name,
      type: type ?? this.type,
      voltageV: voltageV ?? this.voltageV,
      capacityAh: capacityAh ?? this.capacityAh,
      overrideCapacityKwh: overrideCapacityKwh ?? this.overrideCapacityKwh,
      theoreticalRangeKm: theoreticalRangeKm ?? this.theoreticalRangeKm,
      installedAt: installedAt ?? this.installedAt,
      deactivatedAt: deactivatedAt ?? this.deactivatedAt,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $BatteriesTable.$convertertype.toSql(type.value),
      );
    }
    if (voltageV.present) {
      map['voltage_v'] = Variable<double>(voltageV.value);
    }
    if (capacityAh.present) {
      map['capacity_ah'] = Variable<double>(capacityAh.value);
    }
    if (overrideCapacityKwh.present) {
      map['override_capacity_kwh'] = Variable<double>(
        overrideCapacityKwh.value,
      );
    }
    if (theoreticalRangeKm.present) {
      map['theoretical_range_km'] = Variable<double>(theoreticalRangeKm.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (deactivatedAt.present) {
      map['deactivated_at'] = Variable<DateTime>(deactivatedAt.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatteriesCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('voltageV: $voltageV, ')
          ..write('capacityAh: $capacityAh, ')
          ..write('overrideCapacityKwh: $overrideCapacityKwh, ')
          ..write('theoreticalRangeKm: $theoreticalRangeKm, ')
          ..write('installedAt: $installedAt, ')
          ..write('deactivatedAt: $deactivatedAt, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $ChargesTable extends Charges with TableInfo<$ChargesTable, Charge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChargesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _batteryIdMeta = const VerificationMeta(
    'batteryId',
  );
  @override
  late final GeneratedColumn<int> batteryId = GeneratedColumn<int>(
    'battery_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES batteries (id)',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ChargeMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ChargeMode>($ChargesTable.$convertermode);
  static const VerificationMeta _energyKwhMeta = const VerificationMeta(
    'energyKwh',
  );
  @override
  late final GeneratedColumn<double> energyKwh = GeneratedColumn<double>(
    'energy_kwh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EnergySource, String>
  energySource = GeneratedColumn<String>(
    'energy_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<EnergySource>($ChargesTable.$converterenergySource);
  static const VerificationMeta _moneyYuanMeta = const VerificationMeta(
    'moneyYuan',
  );
  @override
  late final GeneratedColumn<double> moneyYuan = GeneratedColumn<double>(
    'money_yuan',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  @override
  late final GeneratedColumn<double> hours = GeneratedColumn<double>(
    'hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chargerPowerWMeta = const VerificationMeta(
    'chargerPowerW',
  );
  @override
  late final GeneratedColumn<double> chargerPowerW = GeneratedColumn<double>(
    'charger_power_w',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceDescMeta = const VerificationMeta(
    'priceDesc',
  );
  @override
  late final GeneratedColumn<String> priceDesc = GeneratedColumn<String>(
    'price_desc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _socBeforePctMeta = const VerificationMeta(
    'socBeforePct',
  );
  @override
  late final GeneratedColumn<int> socBeforePct = GeneratedColumn<int>(
    'soc_before_pct',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _socAfterPctMeta = const VerificationMeta(
    'socAfterPct',
  );
  @override
  late final GeneratedColumn<int> socAfterPct = GeneratedColumn<int>(
    'soc_after_pct',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mileageKmMeta = const VerificationMeta(
    'mileageKm',
  );
  @override
  late final GeneratedColumn<double> mileageKm = GeneratedColumn<double>(
    'mileage_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    batteryId,
    occurredAt,
    mode,
    energyKwh,
    energySource,
    moneyYuan,
    hours,
    chargerPowerW,
    priceDesc,
    socBeforePct,
    socAfterPct,
    mileageKm,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'charges';
  @override
  VerificationContext validateIntegrity(
    Insertable<Charge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('battery_id')) {
      context.handle(
        _batteryIdMeta,
        batteryId.isAcceptableOrUnknown(data['battery_id']!, _batteryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batteryIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('energy_kwh')) {
      context.handle(
        _energyKwhMeta,
        energyKwh.isAcceptableOrUnknown(data['energy_kwh']!, _energyKwhMeta),
      );
    } else if (isInserting) {
      context.missing(_energyKwhMeta);
    }
    if (data.containsKey('money_yuan')) {
      context.handle(
        _moneyYuanMeta,
        moneyYuan.isAcceptableOrUnknown(data['money_yuan']!, _moneyYuanMeta),
      );
    }
    if (data.containsKey('hours')) {
      context.handle(
        _hoursMeta,
        hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta),
      );
    }
    if (data.containsKey('charger_power_w')) {
      context.handle(
        _chargerPowerWMeta,
        chargerPowerW.isAcceptableOrUnknown(
          data['charger_power_w']!,
          _chargerPowerWMeta,
        ),
      );
    }
    if (data.containsKey('price_desc')) {
      context.handle(
        _priceDescMeta,
        priceDesc.isAcceptableOrUnknown(data['price_desc']!, _priceDescMeta),
      );
    }
    if (data.containsKey('soc_before_pct')) {
      context.handle(
        _socBeforePctMeta,
        socBeforePct.isAcceptableOrUnknown(
          data['soc_before_pct']!,
          _socBeforePctMeta,
        ),
      );
    }
    if (data.containsKey('soc_after_pct')) {
      context.handle(
        _socAfterPctMeta,
        socAfterPct.isAcceptableOrUnknown(
          data['soc_after_pct']!,
          _socAfterPctMeta,
        ),
      );
    }
    if (data.containsKey('mileage_km')) {
      context.handle(
        _mileageKmMeta,
        mileageKm.isAcceptableOrUnknown(data['mileage_km']!, _mileageKmMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Charge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Charge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      batteryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}battery_id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      mode: $ChargesTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
      energyKwh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}energy_kwh'],
      )!,
      energySource: $ChargesTable.$converterenergySource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}energy_source'],
        )!,
      ),
      moneyYuan: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}money_yuan'],
      ),
      hours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hours'],
      ),
      chargerPowerW: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}charger_power_w'],
      ),
      priceDesc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_desc'],
      ),
      socBeforePct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}soc_before_pct'],
      ),
      socAfterPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}soc_after_pct'],
      ),
      mileageKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mileage_km'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ChargesTable createAlias(String alias) {
    return $ChargesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ChargeMode, String, String> $convertermode =
      const EnumNameConverter<ChargeMode>(ChargeMode.values);
  static JsonTypeConverter2<EnergySource, String, String>
  $converterenergySource = const EnumNameConverter<EnergySource>(
    EnergySource.values,
  );
}

class Charge extends DataClass implements Insertable<Charge> {
  final int id;
  final int batteryId;
  final DateTime occurredAt;
  final ChargeMode mode;
  final double energyKwh;
  final EnergySource energySource;
  final double? moneyYuan;
  final double? hours;
  final double? chargerPowerW;
  final String? priceDesc;
  final int? socBeforePct;
  final int? socAfterPct;
  final double? mileageKm;
  final String? note;
  const Charge({
    required this.id,
    required this.batteryId,
    required this.occurredAt,
    required this.mode,
    required this.energyKwh,
    required this.energySource,
    this.moneyYuan,
    this.hours,
    this.chargerPowerW,
    this.priceDesc,
    this.socBeforePct,
    this.socAfterPct,
    this.mileageKm,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['battery_id'] = Variable<int>(batteryId);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    {
      map['mode'] = Variable<String>($ChargesTable.$convertermode.toSql(mode));
    }
    map['energy_kwh'] = Variable<double>(energyKwh);
    {
      map['energy_source'] = Variable<String>(
        $ChargesTable.$converterenergySource.toSql(energySource),
      );
    }
    if (!nullToAbsent || moneyYuan != null) {
      map['money_yuan'] = Variable<double>(moneyYuan);
    }
    if (!nullToAbsent || hours != null) {
      map['hours'] = Variable<double>(hours);
    }
    if (!nullToAbsent || chargerPowerW != null) {
      map['charger_power_w'] = Variable<double>(chargerPowerW);
    }
    if (!nullToAbsent || priceDesc != null) {
      map['price_desc'] = Variable<String>(priceDesc);
    }
    if (!nullToAbsent || socBeforePct != null) {
      map['soc_before_pct'] = Variable<int>(socBeforePct);
    }
    if (!nullToAbsent || socAfterPct != null) {
      map['soc_after_pct'] = Variable<int>(socAfterPct);
    }
    if (!nullToAbsent || mileageKm != null) {
      map['mileage_km'] = Variable<double>(mileageKm);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ChargesCompanion toCompanion(bool nullToAbsent) {
    return ChargesCompanion(
      id: Value(id),
      batteryId: Value(batteryId),
      occurredAt: Value(occurredAt),
      mode: Value(mode),
      energyKwh: Value(energyKwh),
      energySource: Value(energySource),
      moneyYuan: moneyYuan == null && nullToAbsent
          ? const Value.absent()
          : Value(moneyYuan),
      hours: hours == null && nullToAbsent
          ? const Value.absent()
          : Value(hours),
      chargerPowerW: chargerPowerW == null && nullToAbsent
          ? const Value.absent()
          : Value(chargerPowerW),
      priceDesc: priceDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(priceDesc),
      socBeforePct: socBeforePct == null && nullToAbsent
          ? const Value.absent()
          : Value(socBeforePct),
      socAfterPct: socAfterPct == null && nullToAbsent
          ? const Value.absent()
          : Value(socAfterPct),
      mileageKm: mileageKm == null && nullToAbsent
          ? const Value.absent()
          : Value(mileageKm),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Charge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Charge(
      id: serializer.fromJson<int>(json['id']),
      batteryId: serializer.fromJson<int>(json['batteryId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      mode: $ChargesTable.$convertermode.fromJson(
        serializer.fromJson<String>(json['mode']),
      ),
      energyKwh: serializer.fromJson<double>(json['energyKwh']),
      energySource: $ChargesTable.$converterenergySource.fromJson(
        serializer.fromJson<String>(json['energySource']),
      ),
      moneyYuan: serializer.fromJson<double?>(json['moneyYuan']),
      hours: serializer.fromJson<double?>(json['hours']),
      chargerPowerW: serializer.fromJson<double?>(json['chargerPowerW']),
      priceDesc: serializer.fromJson<String?>(json['priceDesc']),
      socBeforePct: serializer.fromJson<int?>(json['socBeforePct']),
      socAfterPct: serializer.fromJson<int?>(json['socAfterPct']),
      mileageKm: serializer.fromJson<double?>(json['mileageKm']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'batteryId': serializer.toJson<int>(batteryId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'mode': serializer.toJson<String>(
        $ChargesTable.$convertermode.toJson(mode),
      ),
      'energyKwh': serializer.toJson<double>(energyKwh),
      'energySource': serializer.toJson<String>(
        $ChargesTable.$converterenergySource.toJson(energySource),
      ),
      'moneyYuan': serializer.toJson<double?>(moneyYuan),
      'hours': serializer.toJson<double?>(hours),
      'chargerPowerW': serializer.toJson<double?>(chargerPowerW),
      'priceDesc': serializer.toJson<String?>(priceDesc),
      'socBeforePct': serializer.toJson<int?>(socBeforePct),
      'socAfterPct': serializer.toJson<int?>(socAfterPct),
      'mileageKm': serializer.toJson<double?>(mileageKm),
      'note': serializer.toJson<String?>(note),
    };
  }

  Charge copyWith({
    int? id,
    int? batteryId,
    DateTime? occurredAt,
    ChargeMode? mode,
    double? energyKwh,
    EnergySource? energySource,
    Value<double?> moneyYuan = const Value.absent(),
    Value<double?> hours = const Value.absent(),
    Value<double?> chargerPowerW = const Value.absent(),
    Value<String?> priceDesc = const Value.absent(),
    Value<int?> socBeforePct = const Value.absent(),
    Value<int?> socAfterPct = const Value.absent(),
    Value<double?> mileageKm = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Charge(
    id: id ?? this.id,
    batteryId: batteryId ?? this.batteryId,
    occurredAt: occurredAt ?? this.occurredAt,
    mode: mode ?? this.mode,
    energyKwh: energyKwh ?? this.energyKwh,
    energySource: energySource ?? this.energySource,
    moneyYuan: moneyYuan.present ? moneyYuan.value : this.moneyYuan,
    hours: hours.present ? hours.value : this.hours,
    chargerPowerW: chargerPowerW.present
        ? chargerPowerW.value
        : this.chargerPowerW,
    priceDesc: priceDesc.present ? priceDesc.value : this.priceDesc,
    socBeforePct: socBeforePct.present ? socBeforePct.value : this.socBeforePct,
    socAfterPct: socAfterPct.present ? socAfterPct.value : this.socAfterPct,
    mileageKm: mileageKm.present ? mileageKm.value : this.mileageKm,
    note: note.present ? note.value : this.note,
  );
  Charge copyWithCompanion(ChargesCompanion data) {
    return Charge(
      id: data.id.present ? data.id.value : this.id,
      batteryId: data.batteryId.present ? data.batteryId.value : this.batteryId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      mode: data.mode.present ? data.mode.value : this.mode,
      energyKwh: data.energyKwh.present ? data.energyKwh.value : this.energyKwh,
      energySource: data.energySource.present
          ? data.energySource.value
          : this.energySource,
      moneyYuan: data.moneyYuan.present ? data.moneyYuan.value : this.moneyYuan,
      hours: data.hours.present ? data.hours.value : this.hours,
      chargerPowerW: data.chargerPowerW.present
          ? data.chargerPowerW.value
          : this.chargerPowerW,
      priceDesc: data.priceDesc.present ? data.priceDesc.value : this.priceDesc,
      socBeforePct: data.socBeforePct.present
          ? data.socBeforePct.value
          : this.socBeforePct,
      socAfterPct: data.socAfterPct.present
          ? data.socAfterPct.value
          : this.socAfterPct,
      mileageKm: data.mileageKm.present ? data.mileageKm.value : this.mileageKm,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Charge(')
          ..write('id: $id, ')
          ..write('batteryId: $batteryId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('mode: $mode, ')
          ..write('energyKwh: $energyKwh, ')
          ..write('energySource: $energySource, ')
          ..write('moneyYuan: $moneyYuan, ')
          ..write('hours: $hours, ')
          ..write('chargerPowerW: $chargerPowerW, ')
          ..write('priceDesc: $priceDesc, ')
          ..write('socBeforePct: $socBeforePct, ')
          ..write('socAfterPct: $socAfterPct, ')
          ..write('mileageKm: $mileageKm, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    batteryId,
    occurredAt,
    mode,
    energyKwh,
    energySource,
    moneyYuan,
    hours,
    chargerPowerW,
    priceDesc,
    socBeforePct,
    socAfterPct,
    mileageKm,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Charge &&
          other.id == this.id &&
          other.batteryId == this.batteryId &&
          other.occurredAt == this.occurredAt &&
          other.mode == this.mode &&
          other.energyKwh == this.energyKwh &&
          other.energySource == this.energySource &&
          other.moneyYuan == this.moneyYuan &&
          other.hours == this.hours &&
          other.chargerPowerW == this.chargerPowerW &&
          other.priceDesc == this.priceDesc &&
          other.socBeforePct == this.socBeforePct &&
          other.socAfterPct == this.socAfterPct &&
          other.mileageKm == this.mileageKm &&
          other.note == this.note);
}

class ChargesCompanion extends UpdateCompanion<Charge> {
  final Value<int> id;
  final Value<int> batteryId;
  final Value<DateTime> occurredAt;
  final Value<ChargeMode> mode;
  final Value<double> energyKwh;
  final Value<EnergySource> energySource;
  final Value<double?> moneyYuan;
  final Value<double?> hours;
  final Value<double?> chargerPowerW;
  final Value<String?> priceDesc;
  final Value<int?> socBeforePct;
  final Value<int?> socAfterPct;
  final Value<double?> mileageKm;
  final Value<String?> note;
  const ChargesCompanion({
    this.id = const Value.absent(),
    this.batteryId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.mode = const Value.absent(),
    this.energyKwh = const Value.absent(),
    this.energySource = const Value.absent(),
    this.moneyYuan = const Value.absent(),
    this.hours = const Value.absent(),
    this.chargerPowerW = const Value.absent(),
    this.priceDesc = const Value.absent(),
    this.socBeforePct = const Value.absent(),
    this.socAfterPct = const Value.absent(),
    this.mileageKm = const Value.absent(),
    this.note = const Value.absent(),
  });
  ChargesCompanion.insert({
    this.id = const Value.absent(),
    required int batteryId,
    required DateTime occurredAt,
    required ChargeMode mode,
    required double energyKwh,
    required EnergySource energySource,
    this.moneyYuan = const Value.absent(),
    this.hours = const Value.absent(),
    this.chargerPowerW = const Value.absent(),
    this.priceDesc = const Value.absent(),
    this.socBeforePct = const Value.absent(),
    this.socAfterPct = const Value.absent(),
    this.mileageKm = const Value.absent(),
    this.note = const Value.absent(),
  }) : batteryId = Value(batteryId),
       occurredAt = Value(occurredAt),
       mode = Value(mode),
       energyKwh = Value(energyKwh),
       energySource = Value(energySource);
  static Insertable<Charge> custom({
    Expression<int>? id,
    Expression<int>? batteryId,
    Expression<DateTime>? occurredAt,
    Expression<String>? mode,
    Expression<double>? energyKwh,
    Expression<String>? energySource,
    Expression<double>? moneyYuan,
    Expression<double>? hours,
    Expression<double>? chargerPowerW,
    Expression<String>? priceDesc,
    Expression<int>? socBeforePct,
    Expression<int>? socAfterPct,
    Expression<double>? mileageKm,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (batteryId != null) 'battery_id': batteryId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (mode != null) 'mode': mode,
      if (energyKwh != null) 'energy_kwh': energyKwh,
      if (energySource != null) 'energy_source': energySource,
      if (moneyYuan != null) 'money_yuan': moneyYuan,
      if (hours != null) 'hours': hours,
      if (chargerPowerW != null) 'charger_power_w': chargerPowerW,
      if (priceDesc != null) 'price_desc': priceDesc,
      if (socBeforePct != null) 'soc_before_pct': socBeforePct,
      if (socAfterPct != null) 'soc_after_pct': socAfterPct,
      if (mileageKm != null) 'mileage_km': mileageKm,
      if (note != null) 'note': note,
    });
  }

  ChargesCompanion copyWith({
    Value<int>? id,
    Value<int>? batteryId,
    Value<DateTime>? occurredAt,
    Value<ChargeMode>? mode,
    Value<double>? energyKwh,
    Value<EnergySource>? energySource,
    Value<double?>? moneyYuan,
    Value<double?>? hours,
    Value<double?>? chargerPowerW,
    Value<String?>? priceDesc,
    Value<int?>? socBeforePct,
    Value<int?>? socAfterPct,
    Value<double?>? mileageKm,
    Value<String?>? note,
  }) {
    return ChargesCompanion(
      id: id ?? this.id,
      batteryId: batteryId ?? this.batteryId,
      occurredAt: occurredAt ?? this.occurredAt,
      mode: mode ?? this.mode,
      energyKwh: energyKwh ?? this.energyKwh,
      energySource: energySource ?? this.energySource,
      moneyYuan: moneyYuan ?? this.moneyYuan,
      hours: hours ?? this.hours,
      chargerPowerW: chargerPowerW ?? this.chargerPowerW,
      priceDesc: priceDesc ?? this.priceDesc,
      socBeforePct: socBeforePct ?? this.socBeforePct,
      socAfterPct: socAfterPct ?? this.socAfterPct,
      mileageKm: mileageKm ?? this.mileageKm,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (batteryId.present) {
      map['battery_id'] = Variable<int>(batteryId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $ChargesTable.$convertermode.toSql(mode.value),
      );
    }
    if (energyKwh.present) {
      map['energy_kwh'] = Variable<double>(energyKwh.value);
    }
    if (energySource.present) {
      map['energy_source'] = Variable<String>(
        $ChargesTable.$converterenergySource.toSql(energySource.value),
      );
    }
    if (moneyYuan.present) {
      map['money_yuan'] = Variable<double>(moneyYuan.value);
    }
    if (hours.present) {
      map['hours'] = Variable<double>(hours.value);
    }
    if (chargerPowerW.present) {
      map['charger_power_w'] = Variable<double>(chargerPowerW.value);
    }
    if (priceDesc.present) {
      map['price_desc'] = Variable<String>(priceDesc.value);
    }
    if (socBeforePct.present) {
      map['soc_before_pct'] = Variable<int>(socBeforePct.value);
    }
    if (socAfterPct.present) {
      map['soc_after_pct'] = Variable<int>(socAfterPct.value);
    }
    if (mileageKm.present) {
      map['mileage_km'] = Variable<double>(mileageKm.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChargesCompanion(')
          ..write('id: $id, ')
          ..write('batteryId: $batteryId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('mode: $mode, ')
          ..write('energyKwh: $energyKwh, ')
          ..write('energySource: $energySource, ')
          ..write('moneyYuan: $moneyYuan, ')
          ..write('hours: $hours, ')
          ..write('chargerPowerW: $chargerPowerW, ')
          ..write('priceDesc: $priceDesc, ')
          ..write('socBeforePct: $socBeforePct, ')
          ..write('socAfterPct: $socAfterPct, ')
          ..write('mileageKm: $mileageKm, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $BatteriesTable batteries = $BatteriesTable(this);
  late final $ChargesTable charges = $ChargesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    batteries,
    charges,
  ];
}

typedef $$VehiclesTableCreateCompanionBuilder = VehiclesCompanion Function({
  Value<int> id,
  required String brand,
  required String model,
  Value<DateTime?> purchaseDate,
  Value<double> initialMileageKm,
  Value<int?> initialSocPct,
  Value<String?> note,
});
typedef $$VehiclesTableUpdateCompanionBuilder = VehiclesCompanion Function({
  Value<int> id,
  Value<String> brand,
  Value<String> model,
  Value<DateTime?> purchaseDate,
  Value<double> initialMileageKm,
  Value<int?> initialSocPct,
  Value<String?> note,
});

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BatteriesTable, List<Battery>>
  _batteriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.batteries,
    aliasName: 'vehicles__id__batteries__vehicle_id',
  );

  $$BatteriesTableProcessedTableManager get batteriesRefs {
    final manager = $$BatteriesTableTableManager(
      $_db,
      $_db.batteries,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_batteriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
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

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialMileageKm => $composableBuilder(
    column: $table.initialMileageKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialSocPct => $composableBuilder(
    column: $table.initialSocPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> batteriesRefs(
    Expression<bool> Function($$BatteriesTableFilterComposer f) f,
  ) {
    final $$BatteriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.batteries,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatteriesTableFilterComposer(
            $db: $db,
            $table: $db.batteries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
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

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialMileageKm => $composableBuilder(
    column: $table.initialMileageKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialSocPct => $composableBuilder(
    column: $table.initialSocPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get initialMileageKm => $composableBuilder(
    column: $table.initialMileageKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get initialSocPct => $composableBuilder(
    column: $table.initialSocPct,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  Expression<T> batteriesRefs<T extends Object>(
    Expression<T> Function($$BatteriesTableAnnotationComposer a) f,
  ) {
    final $$BatteriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.batteries,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatteriesTableAnnotationComposer(
            $db: $db,
            $table: $db.batteries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          Vehicle,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (Vehicle, $$VehiclesTableReferences),
          Vehicle,
          PrefetchHooks Function({bool batteriesRefs})
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<double> initialMileageKm = const Value.absent(),
                Value<int?> initialSocPct = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                brand: brand,
                model: model,
                purchaseDate: purchaseDate,
                initialMileageKm: initialMileageKm,
                initialSocPct: initialSocPct,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String brand,
                required String model,
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<double> initialMileageKm = const Value.absent(),
                Value<int?> initialSocPct = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                brand: brand,
                model: model,
                purchaseDate: purchaseDate,
                initialMileageKm: initialMileageKm,
                initialSocPct: initialSocPct,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({batteriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (batteriesRefs) db.batteries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (batteriesRefs)
                    await $_getPrefetchedData<Vehicle, $VehiclesTable, Battery>(
                      currentTable: table,
                      referencedTable: $$VehiclesTableReferences
                          ._batteriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$VehiclesTableReferences(
                        db,
                        table,
                        p0,
                      ).batteriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.vehicleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      Vehicle,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (Vehicle, $$VehiclesTableReferences),
      Vehicle,
      PrefetchHooks Function({bool batteriesRefs})
    >;
typedef $$BatteriesTableCreateCompanionBuilder = BatteriesCompanion Function({
  Value<int> id,
  required int vehicleId,
  required String name,
  required BatteryType type,
  required double voltageV,
  required double capacityAh,
  Value<double?> overrideCapacityKwh,
  Value<double?> theoreticalRangeKm,
  required DateTime installedAt,
  Value<DateTime?> deactivatedAt,
  Value<bool> active,
});
typedef $$BatteriesTableUpdateCompanionBuilder = BatteriesCompanion Function({
  Value<int> id,
  Value<int> vehicleId,
  Value<String> name,
  Value<BatteryType> type,
  Value<double> voltageV,
  Value<double> capacityAh,
  Value<double?> overrideCapacityKwh,
  Value<double?> theoreticalRangeKm,
  Value<DateTime> installedAt,
  Value<DateTime?> deactivatedAt,
  Value<bool> active,
});

final class $$BatteriesTableReferences
    extends BaseReferences<_$AppDatabase, $BatteriesTable, Battery> {
  $$BatteriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('batteries__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChargesTable, List<Charge>> _chargesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.charges,
    aliasName: 'batteries__id__charges__battery_id',
  );

  $$ChargesTableProcessedTableManager get chargesRefs {
    final manager = $$ChargesTableTableManager(
      $_db,
      $_db.charges,
    ).filter((f) => f.batteryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chargesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BatteriesTableFilterComposer
    extends Composer<_$AppDatabase, $BatteriesTable> {
  $$BatteriesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<BatteryType, BatteryType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get voltageV => $composableBuilder(
    column: $table.voltageV,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get capacityAh => $composableBuilder(
    column: $table.capacityAh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overrideCapacityKwh => $composableBuilder(
    column: $table.overrideCapacityKwh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get theoreticalRangeKm => $composableBuilder(
    column: $table.theoreticalRangeKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deactivatedAt => $composableBuilder(
    column: $table.deactivatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> chargesRefs(
    Expression<bool> Function($$ChargesTableFilterComposer f) f,
  ) {
    final $$ChargesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charges,
      getReferencedColumn: (t) => t.batteryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChargesTableFilterComposer(
            $db: $db,
            $table: $db.charges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BatteriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BatteriesTable> {
  $$BatteriesTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get voltageV => $composableBuilder(
    column: $table.voltageV,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get capacityAh => $composableBuilder(
    column: $table.capacityAh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overrideCapacityKwh => $composableBuilder(
    column: $table.overrideCapacityKwh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get theoreticalRangeKm => $composableBuilder(
    column: $table.theoreticalRangeKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deactivatedAt => $composableBuilder(
    column: $table.deactivatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BatteriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatteriesTable> {
  $$BatteriesTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<BatteryType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get voltageV =>
      $composableBuilder(column: $table.voltageV, builder: (column) => column);

  GeneratedColumn<double> get capacityAh => $composableBuilder(
    column: $table.capacityAh,
    builder: (column) => column,
  );

  GeneratedColumn<double> get overrideCapacityKwh => $composableBuilder(
    column: $table.overrideCapacityKwh,
    builder: (column) => column,
  );

  GeneratedColumn<double> get theoreticalRangeKm => $composableBuilder(
    column: $table.theoreticalRangeKm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deactivatedAt => $composableBuilder(
    column: $table.deactivatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> chargesRefs<T extends Object>(
    Expression<T> Function($$ChargesTableAnnotationComposer a) f,
  ) {
    final $$ChargesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charges,
      getReferencedColumn: (t) => t.batteryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChargesTableAnnotationComposer(
            $db: $db,
            $table: $db.charges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BatteriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BatteriesTable,
          Battery,
          $$BatteriesTableFilterComposer,
          $$BatteriesTableOrderingComposer,
          $$BatteriesTableAnnotationComposer,
          $$BatteriesTableCreateCompanionBuilder,
          $$BatteriesTableUpdateCompanionBuilder,
          (Battery, $$BatteriesTableReferences),
          Battery,
          PrefetchHooks Function({bool vehicleId, bool chargesRefs})
        > {
  $$BatteriesTableTableManager(_$AppDatabase db, $BatteriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatteriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatteriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatteriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<BatteryType> type = const Value.absent(),
                Value<double> voltageV = const Value.absent(),
                Value<double> capacityAh = const Value.absent(),
                Value<double?> overrideCapacityKwh = const Value.absent(),
                Value<double?> theoreticalRangeKm = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
                Value<DateTime?> deactivatedAt = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => BatteriesCompanion(
                id: id,
                vehicleId: vehicleId,
                name: name,
                type: type,
                voltageV: voltageV,
                capacityAh: capacityAh,
                overrideCapacityKwh: overrideCapacityKwh,
                theoreticalRangeKm: theoreticalRangeKm,
                installedAt: installedAt,
                deactivatedAt: deactivatedAt,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required String name,
                required BatteryType type,
                required double voltageV,
                required double capacityAh,
                Value<double?> overrideCapacityKwh = const Value.absent(),
                Value<double?> theoreticalRangeKm = const Value.absent(),
                required DateTime installedAt,
                Value<DateTime?> deactivatedAt = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => BatteriesCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                name: name,
                type: type,
                voltageV: voltageV,
                capacityAh: capacityAh,
                overrideCapacityKwh: overrideCapacityKwh,
                theoreticalRangeKm: theoreticalRangeKm,
                installedAt: installedAt,
                deactivatedAt: deactivatedAt,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BatteriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false, chargesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chargesRefs) db.charges],
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
                    if (vehicleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.vehicleId,
                        referencedTable: $$BatteriesTableReferences
                            ._vehicleIdTable(db),
                        referencedColumn: $$BatteriesTableReferences
                            ._vehicleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chargesRefs)
                    await $_getPrefetchedData<Battery, $BatteriesTable, Charge>(
                      currentTable: table,
                      referencedTable: $$BatteriesTableReferences
                          ._chargesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BatteriesTableReferences(db, table, p0).chargesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.batteryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BatteriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BatteriesTable,
      Battery,
      $$BatteriesTableFilterComposer,
      $$BatteriesTableOrderingComposer,
      $$BatteriesTableAnnotationComposer,
      $$BatteriesTableCreateCompanionBuilder,
      $$BatteriesTableUpdateCompanionBuilder,
      (Battery, $$BatteriesTableReferences),
      Battery,
      PrefetchHooks Function({bool vehicleId, bool chargesRefs})
    >;
typedef $$ChargesTableCreateCompanionBuilder = ChargesCompanion Function({
  Value<int> id,
  required int batteryId,
  required DateTime occurredAt,
  required ChargeMode mode,
  required double energyKwh,
  required EnergySource energySource,
  Value<double?> moneyYuan,
  Value<double?> hours,
  Value<double?> chargerPowerW,
  Value<String?> priceDesc,
  Value<int?> socBeforePct,
  Value<int?> socAfterPct,
  Value<double?> mileageKm,
  Value<String?> note,
});
typedef $$ChargesTableUpdateCompanionBuilder = ChargesCompanion Function({
  Value<int> id,
  Value<int> batteryId,
  Value<DateTime> occurredAt,
  Value<ChargeMode> mode,
  Value<double> energyKwh,
  Value<EnergySource> energySource,
  Value<double?> moneyYuan,
  Value<double?> hours,
  Value<double?> chargerPowerW,
  Value<String?> priceDesc,
  Value<int?> socBeforePct,
  Value<int?> socAfterPct,
  Value<double?> mileageKm,
  Value<String?> note,
});

final class $$ChargesTableReferences
    extends BaseReferences<_$AppDatabase, $ChargesTable, Charge> {
  $$ChargesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BatteriesTable _batteryIdTable(_$AppDatabase db) =>
      db.batteries.createAlias('charges__battery_id__batteries__id');

  $$BatteriesTableProcessedTableManager get batteryId {
    final $_column = $_itemColumn<int>('battery_id')!;

    final manager = $$BatteriesTableTableManager(
      $_db,
      $_db.batteries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batteryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChargesTableFilterComposer
    extends Composer<_$AppDatabase, $ChargesTable> {
  $$ChargesTableFilterComposer({
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

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ChargeMode, ChargeMode, String> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get energyKwh => $composableBuilder(
    column: $table.energyKwh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EnergySource, EnergySource, String>
  get energySource => $composableBuilder(
    column: $table.energySource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get moneyYuan => $composableBuilder(
    column: $table.moneyYuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chargerPowerW => $composableBuilder(
    column: $table.chargerPowerW,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceDesc => $composableBuilder(
    column: $table.priceDesc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get socBeforePct => $composableBuilder(
    column: $table.socBeforePct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get socAfterPct => $composableBuilder(
    column: $table.socAfterPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mileageKm => $composableBuilder(
    column: $table.mileageKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$BatteriesTableFilterComposer get batteryId {
    final $$BatteriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batteryId,
      referencedTable: $db.batteries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatteriesTableFilterComposer(
            $db: $db,
            $table: $db.batteries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChargesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChargesTable> {
  $$ChargesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get energyKwh => $composableBuilder(
    column: $table.energyKwh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get energySource => $composableBuilder(
    column: $table.energySource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get moneyYuan => $composableBuilder(
    column: $table.moneyYuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chargerPowerW => $composableBuilder(
    column: $table.chargerPowerW,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceDesc => $composableBuilder(
    column: $table.priceDesc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get socBeforePct => $composableBuilder(
    column: $table.socBeforePct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get socAfterPct => $composableBuilder(
    column: $table.socAfterPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mileageKm => $composableBuilder(
    column: $table.mileageKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$BatteriesTableOrderingComposer get batteryId {
    final $$BatteriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batteryId,
      referencedTable: $db.batteries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatteriesTableOrderingComposer(
            $db: $db,
            $table: $db.batteries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChargesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChargesTable> {
  $$ChargesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ChargeMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<double> get energyKwh =>
      $composableBuilder(column: $table.energyKwh, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EnergySource, String> get energySource =>
      $composableBuilder(
        column: $table.energySource,
        builder: (column) => column,
      );

  GeneratedColumn<double> get moneyYuan =>
      $composableBuilder(column: $table.moneyYuan, builder: (column) => column);

  GeneratedColumn<double> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => column);

  GeneratedColumn<double> get chargerPowerW => $composableBuilder(
    column: $table.chargerPowerW,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priceDesc =>
      $composableBuilder(column: $table.priceDesc, builder: (column) => column);

  GeneratedColumn<int> get socBeforePct => $composableBuilder(
    column: $table.socBeforePct,
    builder: (column) => column,
  );

  GeneratedColumn<int> get socAfterPct => $composableBuilder(
    column: $table.socAfterPct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get mileageKm =>
      $composableBuilder(column: $table.mileageKm, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$BatteriesTableAnnotationComposer get batteryId {
    final $$BatteriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batteryId,
      referencedTable: $db.batteries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatteriesTableAnnotationComposer(
            $db: $db,
            $table: $db.batteries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChargesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChargesTable,
          Charge,
          $$ChargesTableFilterComposer,
          $$ChargesTableOrderingComposer,
          $$ChargesTableAnnotationComposer,
          $$ChargesTableCreateCompanionBuilder,
          $$ChargesTableUpdateCompanionBuilder,
          (Charge, $$ChargesTableReferences),
          Charge,
          PrefetchHooks Function({bool batteryId})
        > {
  $$ChargesTableTableManager(_$AppDatabase db, $ChargesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChargesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChargesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChargesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> batteryId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<ChargeMode> mode = const Value.absent(),
                Value<double> energyKwh = const Value.absent(),
                Value<EnergySource> energySource = const Value.absent(),
                Value<double?> moneyYuan = const Value.absent(),
                Value<double?> hours = const Value.absent(),
                Value<double?> chargerPowerW = const Value.absent(),
                Value<String?> priceDesc = const Value.absent(),
                Value<int?> socBeforePct = const Value.absent(),
                Value<int?> socAfterPct = const Value.absent(),
                Value<double?> mileageKm = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => ChargesCompanion(
                id: id,
                batteryId: batteryId,
                occurredAt: occurredAt,
                mode: mode,
                energyKwh: energyKwh,
                energySource: energySource,
                moneyYuan: moneyYuan,
                hours: hours,
                chargerPowerW: chargerPowerW,
                priceDesc: priceDesc,
                socBeforePct: socBeforePct,
                socAfterPct: socAfterPct,
                mileageKm: mileageKm,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int batteryId,
                required DateTime occurredAt,
                required ChargeMode mode,
                required double energyKwh,
                required EnergySource energySource,
                Value<double?> moneyYuan = const Value.absent(),
                Value<double?> hours = const Value.absent(),
                Value<double?> chargerPowerW = const Value.absent(),
                Value<String?> priceDesc = const Value.absent(),
                Value<int?> socBeforePct = const Value.absent(),
                Value<int?> socAfterPct = const Value.absent(),
                Value<double?> mileageKm = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => ChargesCompanion.insert(
                id: id,
                batteryId: batteryId,
                occurredAt: occurredAt,
                mode: mode,
                energyKwh: energyKwh,
                energySource: energySource,
                moneyYuan: moneyYuan,
                hours: hours,
                chargerPowerW: chargerPowerW,
                priceDesc: priceDesc,
                socBeforePct: socBeforePct,
                socAfterPct: socAfterPct,
                mileageKm: mileageKm,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChargesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({batteryId = false}) {
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
                    if (batteryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.batteryId,
                        referencedTable: $$ChargesTableReferences
                            ._batteryIdTable(db),
                        referencedColumn: $$ChargesTableReferences
                            ._batteryIdTable(db)
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

typedef $$ChargesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChargesTable,
      Charge,
      $$ChargesTableFilterComposer,
      $$ChargesTableOrderingComposer,
      $$ChargesTableAnnotationComposer,
      $$ChargesTableCreateCompanionBuilder,
      $$ChargesTableUpdateCompanionBuilder,
      (Charge, $$ChargesTableReferences),
      Charge,
      PrefetchHooks Function({bool batteryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$BatteriesTableTableManager get batteries =>
      $$BatteriesTableTableManager(_db, _db.batteries);
  $$ChargesTableTableManager get charges =>
      $$ChargesTableTableManager(_db, _db.charges);
}
