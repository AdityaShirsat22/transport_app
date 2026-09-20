// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalVehiclesTable extends LocalVehicles
    with TableInfo<$LocalVehiclesTable, LocalVehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleNumberMeta = const VerificationMeta(
    'vehicleNumber',
  );
  @override
  late final GeneratedColumn<String> vehicleNumber = GeneratedColumn<String>(
    'vehicle_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleTypeMeta = const VerificationMeta(
    'vehicleType',
  );
  @override
  late final GeneratedColumn<String> vehicleType = GeneratedColumn<String>(
    'vehicle_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<String> capacity = GeneratedColumn<String>(
    'capacity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('AVAILABLE'),
  );
  static const VerificationMeta _assignedDriverIdMeta = const VerificationMeta(
    'assignedDriverId',
  );
  @override
  late final GeneratedColumn<String> assignedDriverId = GeneratedColumn<String>(
    'assigned_driver_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignedDriverNameMeta =
      const VerificationMeta('assignedDriverName');
  @override
  late final GeneratedColumn<String> assignedDriverName =
      GeneratedColumn<String>(
        'assigned_driver_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: true,
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
    vehicleNumber,
    vehicleType,
    capacity,
    status,
    assignedDriverId,
    assignedDriverName,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_number')) {
      context.handle(
        _vehicleNumberMeta,
        vehicleNumber.isAcceptableOrUnknown(
          data['vehicle_number']!,
          _vehicleNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vehicleNumberMeta);
    }
    if (data.containsKey('vehicle_type')) {
      context.handle(
        _vehicleTypeMeta,
        vehicleType.isAcceptableOrUnknown(
          data['vehicle_type']!,
          _vehicleTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vehicleTypeMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    } else if (isInserting) {
      context.missing(_capacityMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('assigned_driver_id')) {
      context.handle(
        _assignedDriverIdMeta,
        assignedDriverId.isAcceptableOrUnknown(
          data['assigned_driver_id']!,
          _assignedDriverIdMeta,
        ),
      );
    }
    if (data.containsKey('assigned_driver_name')) {
      context.handle(
        _assignedDriverNameMeta,
        assignedDriverName.isAcceptableOrUnknown(
          data['assigned_driver_name']!,
          _assignedDriverNameMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  LocalVehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_number'],
      )!,
      vehicleType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_type'],
      )!,
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}capacity'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      assignedDriverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_driver_id'],
      ),
      assignedDriverName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_driver_name'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  $LocalVehiclesTable createAlias(String alias) {
    return $LocalVehiclesTable(attachedDatabase, alias);
  }
}

class LocalVehicle extends DataClass implements Insertable<LocalVehicle> {
  final String id;
  final String vehicleNumber;
  final String vehicleType;
  final String capacity;
  final String status;
  final String? assignedDriverId;
  final String? assignedDriverName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocalVehicle({
    required this.id,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.capacity,
    required this.status,
    this.assignedDriverId,
    this.assignedDriverName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_number'] = Variable<String>(vehicleNumber);
    map['vehicle_type'] = Variable<String>(vehicleType);
    map['capacity'] = Variable<String>(capacity);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || assignedDriverId != null) {
      map['assigned_driver_id'] = Variable<String>(assignedDriverId);
    }
    if (!nullToAbsent || assignedDriverName != null) {
      map['assigned_driver_name'] = Variable<String>(assignedDriverName);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalVehiclesCompanion toCompanion(bool nullToAbsent) {
    return LocalVehiclesCompanion(
      id: Value(id),
      vehicleNumber: Value(vehicleNumber),
      vehicleType: Value(vehicleType),
      capacity: Value(capacity),
      status: Value(status),
      assignedDriverId: assignedDriverId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedDriverId),
      assignedDriverName: assignedDriverName == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedDriverName),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalVehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVehicle(
      id: serializer.fromJson<String>(json['id']),
      vehicleNumber: serializer.fromJson<String>(json['vehicleNumber']),
      vehicleType: serializer.fromJson<String>(json['vehicleType']),
      capacity: serializer.fromJson<String>(json['capacity']),
      status: serializer.fromJson<String>(json['status']),
      assignedDriverId: serializer.fromJson<String?>(json['assignedDriverId']),
      assignedDriverName: serializer.fromJson<String?>(
        json['assignedDriverName'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleNumber': serializer.toJson<String>(vehicleNumber),
      'vehicleType': serializer.toJson<String>(vehicleType),
      'capacity': serializer.toJson<String>(capacity),
      'status': serializer.toJson<String>(status),
      'assignedDriverId': serializer.toJson<String?>(assignedDriverId),
      'assignedDriverName': serializer.toJson<String?>(assignedDriverName),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalVehicle copyWith({
    String? id,
    String? vehicleNumber,
    String? vehicleType,
    String? capacity,
    String? status,
    Value<String?> assignedDriverId = const Value.absent(),
    Value<String?> assignedDriverName = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocalVehicle(
    id: id ?? this.id,
    vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    vehicleType: vehicleType ?? this.vehicleType,
    capacity: capacity ?? this.capacity,
    status: status ?? this.status,
    assignedDriverId: assignedDriverId.present
        ? assignedDriverId.value
        : this.assignedDriverId,
    assignedDriverName: assignedDriverName.present
        ? assignedDriverName.value
        : this.assignedDriverName,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalVehicle copyWithCompanion(LocalVehiclesCompanion data) {
    return LocalVehicle(
      id: data.id.present ? data.id.value : this.id,
      vehicleNumber: data.vehicleNumber.present
          ? data.vehicleNumber.value
          : this.vehicleNumber,
      vehicleType: data.vehicleType.present
          ? data.vehicleType.value
          : this.vehicleType,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      status: data.status.present ? data.status.value : this.status,
      assignedDriverId: data.assignedDriverId.present
          ? data.assignedDriverId.value
          : this.assignedDriverId,
      assignedDriverName: data.assignedDriverName.present
          ? data.assignedDriverName.value
          : this.assignedDriverName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVehicle(')
          ..write('id: $id, ')
          ..write('vehicleNumber: $vehicleNumber, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('assignedDriverId: $assignedDriverId, ')
          ..write('assignedDriverName: $assignedDriverName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleNumber,
    vehicleType,
    capacity,
    status,
    assignedDriverId,
    assignedDriverName,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVehicle &&
          other.id == this.id &&
          other.vehicleNumber == this.vehicleNumber &&
          other.vehicleType == this.vehicleType &&
          other.capacity == this.capacity &&
          other.status == this.status &&
          other.assignedDriverId == this.assignedDriverId &&
          other.assignedDriverName == this.assignedDriverName &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalVehiclesCompanion extends UpdateCompanion<LocalVehicle> {
  final Value<String> id;
  final Value<String> vehicleNumber;
  final Value<String> vehicleType;
  final Value<String> capacity;
  final Value<String> status;
  final Value<String?> assignedDriverId;
  final Value<String?> assignedDriverName;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalVehiclesCompanion({
    this.id = const Value.absent(),
    this.vehicleNumber = const Value.absent(),
    this.vehicleType = const Value.absent(),
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.assignedDriverId = const Value.absent(),
    this.assignedDriverName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVehiclesCompanion.insert({
    required String id,
    required String vehicleNumber,
    required String vehicleType,
    required String capacity,
    this.status = const Value.absent(),
    this.assignedDriverId = const Value.absent(),
    this.assignedDriverName = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleNumber = Value(vehicleNumber),
       vehicleType = Value(vehicleType),
       capacity = Value(capacity),
       createdAt = Value(createdAt);
  static Insertable<LocalVehicle> custom({
    Expression<String>? id,
    Expression<String>? vehicleNumber,
    Expression<String>? vehicleType,
    Expression<String>? capacity,
    Expression<String>? status,
    Expression<String>? assignedDriverId,
    Expression<String>? assignedDriverName,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleNumber != null) 'vehicle_number': vehicleNumber,
      if (vehicleType != null) 'vehicle_type': vehicleType,
      if (capacity != null) 'capacity': capacity,
      if (status != null) 'status': status,
      if (assignedDriverId != null) 'assigned_driver_id': assignedDriverId,
      if (assignedDriverName != null)
        'assigned_driver_name': assignedDriverName,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVehiclesCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleNumber,
    Value<String>? vehicleType,
    Value<String>? capacity,
    Value<String>? status,
    Value<String?>? assignedDriverId,
    Value<String?>? assignedDriverName,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalVehiclesCompanion(
      id: id ?? this.id,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      assignedDriverId: assignedDriverId ?? this.assignedDriverId,
      assignedDriverName: assignedDriverName ?? this.assignedDriverName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleNumber.present) {
      map['vehicle_number'] = Variable<String>(vehicleNumber.value);
    }
    if (vehicleType.present) {
      map['vehicle_type'] = Variable<String>(vehicleType.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<String>(capacity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (assignedDriverId.present) {
      map['assigned_driver_id'] = Variable<String>(assignedDriverId.value);
    }
    if (assignedDriverName.present) {
      map['assigned_driver_name'] = Variable<String>(assignedDriverName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVehiclesCompanion(')
          ..write('id: $id, ')
          ..write('vehicleNumber: $vehicleNumber, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('assignedDriverId: $assignedDriverId, ')
          ..write('assignedDriverName: $assignedDriverName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDriversTable extends LocalDrivers
    with TableInfo<$LocalDriversTable, LocalDriver> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDriversTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _mobileNumberMeta = const VerificationMeta(
    'mobileNumber',
  );
  @override
  late final GeneratedColumn<String> mobileNumber = GeneratedColumn<String>(
    'mobile_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('AVAILABLE'),
  );
  static const VerificationMeta _currentVehicleIdMeta = const VerificationMeta(
    'currentVehicleId',
  );
  @override
  late final GeneratedColumn<String> currentVehicleId = GeneratedColumn<String>(
    'current_vehicle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentVehicleNumberMeta =
      const VerificationMeta('currentVehicleNumber');
  @override
  late final GeneratedColumn<String> currentVehicleNumber =
      GeneratedColumn<String>(
        'current_vehicle_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: true,
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
    name,
    mobileNumber,
    status,
    currentVehicleId,
    currentVehicleNumber,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_drivers';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalDriver> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mobile_number')) {
      context.handle(
        _mobileNumberMeta,
        mobileNumber.isAcceptableOrUnknown(
          data['mobile_number']!,
          _mobileNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mobileNumberMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('current_vehicle_id')) {
      context.handle(
        _currentVehicleIdMeta,
        currentVehicleId.isAcceptableOrUnknown(
          data['current_vehicle_id']!,
          _currentVehicleIdMeta,
        ),
      );
    }
    if (data.containsKey('current_vehicle_number')) {
      context.handle(
        _currentVehicleNumberMeta,
        currentVehicleNumber.isAcceptableOrUnknown(
          data['current_vehicle_number']!,
          _currentVehicleNumberMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  LocalDriver map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDriver(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mobileNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile_number'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      currentVehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_vehicle_id'],
      ),
      currentVehicleNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_vehicle_number'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  $LocalDriversTable createAlias(String alias) {
    return $LocalDriversTable(attachedDatabase, alias);
  }
}

class LocalDriver extends DataClass implements Insertable<LocalDriver> {
  final String id;
  final String name;
  final String mobileNumber;
  final String status;
  final String? currentVehicleId;
  final String? currentVehicleNumber;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocalDriver({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.status,
    this.currentVehicleId,
    this.currentVehicleNumber,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['mobile_number'] = Variable<String>(mobileNumber);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || currentVehicleId != null) {
      map['current_vehicle_id'] = Variable<String>(currentVehicleId);
    }
    if (!nullToAbsent || currentVehicleNumber != null) {
      map['current_vehicle_number'] = Variable<String>(currentVehicleNumber);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalDriversCompanion toCompanion(bool nullToAbsent) {
    return LocalDriversCompanion(
      id: Value(id),
      name: Value(name),
      mobileNumber: Value(mobileNumber),
      status: Value(status),
      currentVehicleId: currentVehicleId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentVehicleId),
      currentVehicleNumber: currentVehicleNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(currentVehicleNumber),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalDriver.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDriver(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mobileNumber: serializer.fromJson<String>(json['mobileNumber']),
      status: serializer.fromJson<String>(json['status']),
      currentVehicleId: serializer.fromJson<String?>(json['currentVehicleId']),
      currentVehicleNumber: serializer.fromJson<String?>(
        json['currentVehicleNumber'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'mobileNumber': serializer.toJson<String>(mobileNumber),
      'status': serializer.toJson<String>(status),
      'currentVehicleId': serializer.toJson<String?>(currentVehicleId),
      'currentVehicleNumber': serializer.toJson<String?>(currentVehicleNumber),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalDriver copyWith({
    String? id,
    String? name,
    String? mobileNumber,
    String? status,
    Value<String?> currentVehicleId = const Value.absent(),
    Value<String?> currentVehicleNumber = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocalDriver(
    id: id ?? this.id,
    name: name ?? this.name,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    status: status ?? this.status,
    currentVehicleId: currentVehicleId.present
        ? currentVehicleId.value
        : this.currentVehicleId,
    currentVehicleNumber: currentVehicleNumber.present
        ? currentVehicleNumber.value
        : this.currentVehicleNumber,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalDriver copyWithCompanion(LocalDriversCompanion data) {
    return LocalDriver(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mobileNumber: data.mobileNumber.present
          ? data.mobileNumber.value
          : this.mobileNumber,
      status: data.status.present ? data.status.value : this.status,
      currentVehicleId: data.currentVehicleId.present
          ? data.currentVehicleId.value
          : this.currentVehicleId,
      currentVehicleNumber: data.currentVehicleNumber.present
          ? data.currentVehicleNumber.value
          : this.currentVehicleNumber,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDriver(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('status: $status, ')
          ..write('currentVehicleId: $currentVehicleId, ')
          ..write('currentVehicleNumber: $currentVehicleNumber, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    mobileNumber,
    status,
    currentVehicleId,
    currentVehicleNumber,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDriver &&
          other.id == this.id &&
          other.name == this.name &&
          other.mobileNumber == this.mobileNumber &&
          other.status == this.status &&
          other.currentVehicleId == this.currentVehicleId &&
          other.currentVehicleNumber == this.currentVehicleNumber &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalDriversCompanion extends UpdateCompanion<LocalDriver> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> mobileNumber;
  final Value<String> status;
  final Value<String?> currentVehicleId;
  final Value<String?> currentVehicleNumber;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalDriversCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mobileNumber = const Value.absent(),
    this.status = const Value.absent(),
    this.currentVehicleId = const Value.absent(),
    this.currentVehicleNumber = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDriversCompanion.insert({
    required String id,
    required String name,
    required String mobileNumber,
    this.status = const Value.absent(),
    this.currentVehicleId = const Value.absent(),
    this.currentVehicleNumber = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       mobileNumber = Value(mobileNumber),
       createdAt = Value(createdAt);
  static Insertable<LocalDriver> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? mobileNumber,
    Expression<String>? status,
    Expression<String>? currentVehicleId,
    Expression<String>? currentVehicleNumber,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mobileNumber != null) 'mobile_number': mobileNumber,
      if (status != null) 'status': status,
      if (currentVehicleId != null) 'current_vehicle_id': currentVehicleId,
      if (currentVehicleNumber != null)
        'current_vehicle_number': currentVehicleNumber,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDriversCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? mobileNumber,
    Value<String>? status,
    Value<String?>? currentVehicleId,
    Value<String?>? currentVehicleNumber,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalDriversCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      status: status ?? this.status,
      currentVehicleId: currentVehicleId ?? this.currentVehicleId,
      currentVehicleNumber: currentVehicleNumber ?? this.currentVehicleNumber,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mobileNumber.present) {
      map['mobile_number'] = Variable<String>(mobileNumber.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (currentVehicleId.present) {
      map['current_vehicle_id'] = Variable<String>(currentVehicleId.value);
    }
    if (currentVehicleNumber.present) {
      map['current_vehicle_number'] = Variable<String>(
        currentVehicleNumber.value,
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDriversCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('status: $status, ')
          ..write('currentVehicleId: $currentVehicleId, ')
          ..write('currentVehicleNumber: $currentVehicleNumber, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPartiesTable extends LocalParties
    with TableInfo<$LocalPartiesTable, LocalParty> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPartiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyNameMeta = const VerificationMeta(
    'partyName',
  );
  @override
  late final GeneratedColumn<String> partyName = GeneratedColumn<String>(
    'party_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerMobileMeta = const VerificationMeta(
    'customerMobile',
  );
  @override
  late final GeneratedColumn<String> customerMobile = GeneratedColumn<String>(
    'customer_mobile',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: true,
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
    partyName,
    customerMobile,
    email,
    city,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_parties';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalParty> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('party_name')) {
      context.handle(
        _partyNameMeta,
        partyName.isAcceptableOrUnknown(data['party_name']!, _partyNameMeta),
      );
    } else if (isInserting) {
      context.missing(_partyNameMeta);
    }
    if (data.containsKey('customer_mobile')) {
      context.handle(
        _customerMobileMeta,
        customerMobile.isAcceptableOrUnknown(
          data['customer_mobile']!,
          _customerMobileMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerMobileMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  LocalParty map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalParty(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      partyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_name'],
      )!,
      customerMobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_mobile'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  $LocalPartiesTable createAlias(String alias) {
    return $LocalPartiesTable(attachedDatabase, alias);
  }
}

class LocalParty extends DataClass implements Insertable<LocalParty> {
  final String id;
  final String partyName;
  final String customerMobile;
  final String email;
  final String city;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocalParty({
    required this.id,
    required this.partyName,
    required this.customerMobile,
    required this.email,
    required this.city,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['party_name'] = Variable<String>(partyName);
    map['customer_mobile'] = Variable<String>(customerMobile);
    map['email'] = Variable<String>(email);
    map['city'] = Variable<String>(city);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalPartiesCompanion toCompanion(bool nullToAbsent) {
    return LocalPartiesCompanion(
      id: Value(id),
      partyName: Value(partyName),
      customerMobile: Value(customerMobile),
      email: Value(email),
      city: Value(city),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalParty.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalParty(
      id: serializer.fromJson<String>(json['id']),
      partyName: serializer.fromJson<String>(json['partyName']),
      customerMobile: serializer.fromJson<String>(json['customerMobile']),
      email: serializer.fromJson<String>(json['email']),
      city: serializer.fromJson<String>(json['city']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'partyName': serializer.toJson<String>(partyName),
      'customerMobile': serializer.toJson<String>(customerMobile),
      'email': serializer.toJson<String>(email),
      'city': serializer.toJson<String>(city),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalParty copyWith({
    String? id,
    String? partyName,
    String? customerMobile,
    String? email,
    String? city,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocalParty(
    id: id ?? this.id,
    partyName: partyName ?? this.partyName,
    customerMobile: customerMobile ?? this.customerMobile,
    email: email ?? this.email,
    city: city ?? this.city,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalParty copyWithCompanion(LocalPartiesCompanion data) {
    return LocalParty(
      id: data.id.present ? data.id.value : this.id,
      partyName: data.partyName.present ? data.partyName.value : this.partyName,
      customerMobile: data.customerMobile.present
          ? data.customerMobile.value
          : this.customerMobile,
      email: data.email.present ? data.email.value : this.email,
      city: data.city.present ? data.city.value : this.city,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalParty(')
          ..write('id: $id, ')
          ..write('partyName: $partyName, ')
          ..write('customerMobile: $customerMobile, ')
          ..write('email: $email, ')
          ..write('city: $city, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    partyName,
    customerMobile,
    email,
    city,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalParty &&
          other.id == this.id &&
          other.partyName == this.partyName &&
          other.customerMobile == this.customerMobile &&
          other.email == this.email &&
          other.city == this.city &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalPartiesCompanion extends UpdateCompanion<LocalParty> {
  final Value<String> id;
  final Value<String> partyName;
  final Value<String> customerMobile;
  final Value<String> email;
  final Value<String> city;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalPartiesCompanion({
    this.id = const Value.absent(),
    this.partyName = const Value.absent(),
    this.customerMobile = const Value.absent(),
    this.email = const Value.absent(),
    this.city = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPartiesCompanion.insert({
    required String id,
    required String partyName,
    required String customerMobile,
    this.email = const Value.absent(),
    this.city = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       partyName = Value(partyName),
       customerMobile = Value(customerMobile),
       createdAt = Value(createdAt);
  static Insertable<LocalParty> custom({
    Expression<String>? id,
    Expression<String>? partyName,
    Expression<String>? customerMobile,
    Expression<String>? email,
    Expression<String>? city,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partyName != null) 'party_name': partyName,
      if (customerMobile != null) 'customer_mobile': customerMobile,
      if (email != null) 'email': email,
      if (city != null) 'city': city,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPartiesCompanion copyWith({
    Value<String>? id,
    Value<String>? partyName,
    Value<String>? customerMobile,
    Value<String>? email,
    Value<String>? city,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalPartiesCompanion(
      id: id ?? this.id,
      partyName: partyName ?? this.partyName,
      customerMobile: customerMobile ?? this.customerMobile,
      email: email ?? this.email,
      city: city ?? this.city,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (partyName.present) {
      map['party_name'] = Variable<String>(partyName.value);
    }
    if (customerMobile.present) {
      map['customer_mobile'] = Variable<String>(customerMobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPartiesCompanion(')
          ..write('id: $id, ')
          ..write('partyName: $partyName, ')
          ..write('customerMobile: $customerMobile, ')
          ..write('email: $email, ')
          ..write('city: $city, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalShippingLinesTable extends LocalShippingLines
    with TableInfo<$LocalShippingLinesTable, LocalShippingLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalShippingLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: true,
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
    name,
    code,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_shipping_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalShippingLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  LocalShippingLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalShippingLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  $LocalShippingLinesTable createAlias(String alias) {
    return $LocalShippingLinesTable(attachedDatabase, alias);
  }
}

class LocalShippingLine extends DataClass
    implements Insertable<LocalShippingLine> {
  final String id;
  final String name;
  final String code;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocalShippingLine({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalShippingLinesCompanion toCompanion(bool nullToAbsent) {
    return LocalShippingLinesCompanion(
      id: Value(id),
      name: Value(name),
      code: Value(code),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalShippingLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalShippingLine(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalShippingLine copyWith({
    String? id,
    String? name,
    String? code,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocalShippingLine(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code ?? this.code,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalShippingLine copyWithCompanion(LocalShippingLinesCompanion data) {
    return LocalShippingLine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalShippingLine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, code, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalShippingLine &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalShippingLinesCompanion extends UpdateCompanion<LocalShippingLine> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> code;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalShippingLinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalShippingLinesCompanion.insert({
    required String id,
    required String name,
    required String code,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       code = Value(code),
       createdAt = Value(createdAt);
  static Insertable<LocalShippingLine> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalShippingLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? code,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalShippingLinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalShippingLinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLocationsTable extends LocalLocations
    with TableInfo<$LocalLocationsTable, LocalLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _locationTypeMeta = const VerificationMeta(
    'locationType',
  );
  @override
  late final GeneratedColumn<String> locationType = GeneratedColumn<String>(
    'location_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: true,
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
    name,
    locationType,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location_type')) {
      context.handle(
        _locationTypeMeta,
        locationType.isAcceptableOrUnknown(
          data['location_type']!,
          _locationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_locationTypeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  LocalLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      locationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_type'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  $LocalLocationsTable createAlias(String alias) {
    return $LocalLocationsTable(attachedDatabase, alias);
  }
}

class LocalLocation extends DataClass implements Insertable<LocalLocation> {
  final String id;
  final String name;
  final String locationType;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocalLocation({
    required this.id,
    required this.name,
    required this.locationType,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['location_type'] = Variable<String>(locationType);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalLocationsCompanion toCompanion(bool nullToAbsent) {
    return LocalLocationsCompanion(
      id: Value(id),
      name: Value(name),
      locationType: Value(locationType),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalLocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLocation(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      locationType: serializer.fromJson<String>(json['locationType']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'locationType': serializer.toJson<String>(locationType),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalLocation copyWith({
    String? id,
    String? name,
    String? locationType,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocalLocation(
    id: id ?? this.id,
    name: name ?? this.name,
    locationType: locationType ?? this.locationType,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalLocation copyWithCompanion(LocalLocationsCompanion data) {
    return LocalLocation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      locationType: data.locationType.present
          ? data.locationType.value
          : this.locationType,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLocation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('locationType: $locationType, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, locationType, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLocation &&
          other.id == this.id &&
          other.name == this.name &&
          other.locationType == this.locationType &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalLocationsCompanion extends UpdateCompanion<LocalLocation> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> locationType;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalLocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.locationType = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLocationsCompanion.insert({
    required String id,
    required String name,
    required String locationType,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       locationType = Value(locationType),
       createdAt = Value(createdAt);
  static Insertable<LocalLocation> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? locationType,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (locationType != null) 'location_type': locationType,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? locationType,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalLocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      locationType: locationType ?? this.locationType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (locationType.present) {
      map['location_type'] = Variable<String>(locationType.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('locationType: $locationType, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPortsCfsTable extends LocalPortsCfs
    with TableInfo<$LocalPortsCfsTable, LocalPortsCf> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPortsCfsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: true,
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
    name,
    type,
    location,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_ports_cfs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPortsCf> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  LocalPortsCf map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPortsCf(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  $LocalPortsCfsTable createAlias(String alias) {
    return $LocalPortsCfsTable(attachedDatabase, alias);
  }
}

class LocalPortsCf extends DataClass implements Insertable<LocalPortsCf> {
  final String id;
  final String name;
  final String type;
  final String location;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocalPortsCf({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['location'] = Variable<String>(location);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalPortsCfsCompanion toCompanion(bool nullToAbsent) {
    return LocalPortsCfsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      location: Value(location),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalPortsCf.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPortsCf(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      location: serializer.fromJson<String>(json['location']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'location': serializer.toJson<String>(location),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalPortsCf copyWith({
    String? id,
    String? name,
    String? type,
    String? location,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocalPortsCf(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    location: location ?? this.location,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalPortsCf copyWithCompanion(LocalPortsCfsCompanion data) {
    return LocalPortsCf(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      location: data.location.present ? data.location.value : this.location,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPortsCf(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('location: $location, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, location, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPortsCf &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.location == this.location &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalPortsCfsCompanion extends UpdateCompanion<LocalPortsCf> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> location;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalPortsCfsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.location = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPortsCfsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String location,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       location = Value(location),
       createdAt = Value(createdAt);
  static Insertable<LocalPortsCf> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? location,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (location != null) 'location': location,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPortsCfsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? location,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalPortsCfsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPortsCfsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('location: $location, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalTransportsTable extends LocalTransports
    with TableInfo<$LocalTransportsTable, LocalTransport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTransportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportNumberMeta = const VerificationMeta(
    'transportNumber',
  );
  @override
  late final GeneratedColumn<String> transportNumber = GeneratedColumn<String>(
    'transport_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookingNumberMeta = const VerificationMeta(
    'bookingNumber',
  );
  @override
  late final GeneratedColumn<String> bookingNumber = GeneratedColumn<String>(
    'booking_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _containerNumberMeta = const VerificationMeta(
    'containerNumber',
  );
  @override
  late final GeneratedColumn<String> containerNumber = GeneratedColumn<String>(
    'container_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sealNumberMeta = const VerificationMeta(
    'sealNumber',
  );
  @override
  late final GeneratedColumn<String> sealNumber = GeneratedColumn<String>(
    'seal_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _containerSizeMeta = const VerificationMeta(
    'containerSize',
  );
  @override
  late final GeneratedColumn<String> containerSize = GeneratedColumn<String>(
    'container_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shipmentTypeMeta = const VerificationMeta(
    'shipmentType',
  );
  @override
  late final GeneratedColumn<String> shipmentType = GeneratedColumn<String>(
    'shipment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyIdMeta = const VerificationMeta(
    'partyId',
  );
  @override
  late final GeneratedColumn<String> partyId = GeneratedColumn<String>(
    'party_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyNameMeta = const VerificationMeta(
    'partyName',
  );
  @override
  late final GeneratedColumn<String> partyName = GeneratedColumn<String>(
    'party_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyMobileMeta = const VerificationMeta(
    'partyMobile',
  );
  @override
  late final GeneratedColumn<String> partyMobile = GeneratedColumn<String>(
    'party_mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookingPartyIdMeta = const VerificationMeta(
    'bookingPartyId',
  );
  @override
  late final GeneratedColumn<String> bookingPartyId = GeneratedColumn<String>(
    'booking_party_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookingPartyNameMeta = const VerificationMeta(
    'bookingPartyName',
  );
  @override
  late final GeneratedColumn<String> bookingPartyName = GeneratedColumn<String>(
    'booking_party_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shippingLineIdMeta = const VerificationMeta(
    'shippingLineId',
  );
  @override
  late final GeneratedColumn<String> shippingLineId = GeneratedColumn<String>(
    'shipping_line_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shippingLineNameMeta = const VerificationMeta(
    'shippingLineName',
  );
  @override
  late final GeneratedColumn<String> shippingLineName = GeneratedColumn<String>(
    'shipping_line_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromLocationIdMeta = const VerificationMeta(
    'fromLocationId',
  );
  @override
  late final GeneratedColumn<String> fromLocationId = GeneratedColumn<String>(
    'from_location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromLocationNameMeta = const VerificationMeta(
    'fromLocationName',
  );
  @override
  late final GeneratedColumn<String> fromLocationName = GeneratedColumn<String>(
    'from_location_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toLocationIdMeta = const VerificationMeta(
    'toLocationId',
  );
  @override
  late final GeneratedColumn<String> toLocationId = GeneratedColumn<String>(
    'to_location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toLocationNameMeta = const VerificationMeta(
    'toLocationName',
  );
  @override
  late final GeneratedColumn<String> toLocationName = GeneratedColumn<String>(
    'to_location_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portCfsIdMeta = const VerificationMeta(
    'portCfsId',
  );
  @override
  late final GeneratedColumn<String> portCfsId = GeneratedColumn<String>(
    'port_cfs_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portCfsNameMeta = const VerificationMeta(
    'portCfsName',
  );
  @override
  late final GeneratedColumn<String> portCfsName = GeneratedColumn<String>(
    'port_cfs_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleNumberMeta = const VerificationMeta(
    'vehicleNumber',
  );
  @override
  late final GeneratedColumn<String> vehicleNumber = GeneratedColumn<String>(
    'vehicle_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _driverIdMeta = const VerificationMeta(
    'driverId',
  );
  @override
  late final GeneratedColumn<String> driverId = GeneratedColumn<String>(
    'driver_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _driverNameMeta = const VerificationMeta(
    'driverName',
  );
  @override
  late final GeneratedColumn<String> driverName = GeneratedColumn<String>(
    'driver_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _driverMobileMeta = const VerificationMeta(
    'driverMobile',
  );
  @override
  late final GeneratedColumn<String> driverMobile = GeneratedColumn<String>(
    'driver_mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('NEW'),
  );
  static const VerificationMeta _exceptionReasonMeta = const VerificationMeta(
    'exceptionReason',
  );
  @override
  late final GeneratedColumn<String> exceptionReason = GeneratedColumn<String>(
    'exception_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleReportedAtMeta = const VerificationMeta(
    'vehicleReportedAt',
  );
  @override
  late final GeneratedColumn<DateTime> vehicleReportedAt =
      GeneratedColumn<DateTime>(
        'vehicle_reported_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _containerPickedUpAtMeta =
      const VerificationMeta('containerPickedUpAt');
  @override
  late final GeneratedColumn<DateTime> containerPickedUpAt =
      GeneratedColumn<DateTime>(
        'container_picked_up_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _inTransitAtMeta = const VerificationMeta(
    'inTransitAt',
  );
  @override
  late final GeneratedColumn<DateTime> inTransitAt = GeneratedColumn<DateTime>(
    'in_transit_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _atPortCfsAtMeta = const VerificationMeta(
    'atPortCfsAt',
  );
  @override
  late final GeneratedColumn<DateTime> atPortCfsAt = GeneratedColumn<DateTime>(
    'at_port_cfs_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _containerDeliveredAtMeta =
      const VerificationMeta('containerDeliveredAt');
  @override
  late final GeneratedColumn<DateTime> containerDeliveredAt =
      GeneratedColumn<DateTime>(
        'container_delivered_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _podReceivedAtMeta = const VerificationMeta(
    'podReceivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> podReceivedAt =
      GeneratedColumn<DateTime>(
        'pod_received_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
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
    transportNumber,
    bookingNumber,
    containerNumber,
    sealNumber,
    containerSize,
    shipmentType,
    partyId,
    partyName,
    partyMobile,
    bookingPartyId,
    bookingPartyName,
    shippingLineId,
    shippingLineName,
    fromLocationId,
    fromLocationName,
    toLocationId,
    toLocationName,
    portCfsId,
    portCfsName,
    vehicleId,
    vehicleNumber,
    driverId,
    driverName,
    driverMobile,
    status,
    exceptionReason,
    vehicleReportedAt,
    containerPickedUpAt,
    inTransitAt,
    atPortCfsAt,
    containerDeliveredAt,
    podReceivedAt,
    completedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_transports';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTransport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transport_number')) {
      context.handle(
        _transportNumberMeta,
        transportNumber.isAcceptableOrUnknown(
          data['transport_number']!,
          _transportNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transportNumberMeta);
    }
    if (data.containsKey('booking_number')) {
      context.handle(
        _bookingNumberMeta,
        bookingNumber.isAcceptableOrUnknown(
          data['booking_number']!,
          _bookingNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bookingNumberMeta);
    }
    if (data.containsKey('container_number')) {
      context.handle(
        _containerNumberMeta,
        containerNumber.isAcceptableOrUnknown(
          data['container_number']!,
          _containerNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_containerNumberMeta);
    }
    if (data.containsKey('seal_number')) {
      context.handle(
        _sealNumberMeta,
        sealNumber.isAcceptableOrUnknown(data['seal_number']!, _sealNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_sealNumberMeta);
    }
    if (data.containsKey('container_size')) {
      context.handle(
        _containerSizeMeta,
        containerSize.isAcceptableOrUnknown(
          data['container_size']!,
          _containerSizeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_containerSizeMeta);
    }
    if (data.containsKey('shipment_type')) {
      context.handle(
        _shipmentTypeMeta,
        shipmentType.isAcceptableOrUnknown(
          data['shipment_type']!,
          _shipmentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shipmentTypeMeta);
    }
    if (data.containsKey('party_id')) {
      context.handle(
        _partyIdMeta,
        partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partyIdMeta);
    }
    if (data.containsKey('party_name')) {
      context.handle(
        _partyNameMeta,
        partyName.isAcceptableOrUnknown(data['party_name']!, _partyNameMeta),
      );
    } else if (isInserting) {
      context.missing(_partyNameMeta);
    }
    if (data.containsKey('party_mobile')) {
      context.handle(
        _partyMobileMeta,
        partyMobile.isAcceptableOrUnknown(
          data['party_mobile']!,
          _partyMobileMeta,
        ),
      );
    }
    if (data.containsKey('booking_party_id')) {
      context.handle(
        _bookingPartyIdMeta,
        bookingPartyId.isAcceptableOrUnknown(
          data['booking_party_id']!,
          _bookingPartyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bookingPartyIdMeta);
    }
    if (data.containsKey('booking_party_name')) {
      context.handle(
        _bookingPartyNameMeta,
        bookingPartyName.isAcceptableOrUnknown(
          data['booking_party_name']!,
          _bookingPartyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bookingPartyNameMeta);
    }
    if (data.containsKey('shipping_line_id')) {
      context.handle(
        _shippingLineIdMeta,
        shippingLineId.isAcceptableOrUnknown(
          data['shipping_line_id']!,
          _shippingLineIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shippingLineIdMeta);
    }
    if (data.containsKey('shipping_line_name')) {
      context.handle(
        _shippingLineNameMeta,
        shippingLineName.isAcceptableOrUnknown(
          data['shipping_line_name']!,
          _shippingLineNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shippingLineNameMeta);
    }
    if (data.containsKey('from_location_id')) {
      context.handle(
        _fromLocationIdMeta,
        fromLocationId.isAcceptableOrUnknown(
          data['from_location_id']!,
          _fromLocationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromLocationIdMeta);
    }
    if (data.containsKey('from_location_name')) {
      context.handle(
        _fromLocationNameMeta,
        fromLocationName.isAcceptableOrUnknown(
          data['from_location_name']!,
          _fromLocationNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromLocationNameMeta);
    }
    if (data.containsKey('to_location_id')) {
      context.handle(
        _toLocationIdMeta,
        toLocationId.isAcceptableOrUnknown(
          data['to_location_id']!,
          _toLocationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toLocationIdMeta);
    }
    if (data.containsKey('to_location_name')) {
      context.handle(
        _toLocationNameMeta,
        toLocationName.isAcceptableOrUnknown(
          data['to_location_name']!,
          _toLocationNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toLocationNameMeta);
    }
    if (data.containsKey('port_cfs_id')) {
      context.handle(
        _portCfsIdMeta,
        portCfsId.isAcceptableOrUnknown(data['port_cfs_id']!, _portCfsIdMeta),
      );
    } else if (isInserting) {
      context.missing(_portCfsIdMeta);
    }
    if (data.containsKey('port_cfs_name')) {
      context.handle(
        _portCfsNameMeta,
        portCfsName.isAcceptableOrUnknown(
          data['port_cfs_name']!,
          _portCfsNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_portCfsNameMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    }
    if (data.containsKey('vehicle_number')) {
      context.handle(
        _vehicleNumberMeta,
        vehicleNumber.isAcceptableOrUnknown(
          data['vehicle_number']!,
          _vehicleNumberMeta,
        ),
      );
    }
    if (data.containsKey('driver_id')) {
      context.handle(
        _driverIdMeta,
        driverId.isAcceptableOrUnknown(data['driver_id']!, _driverIdMeta),
      );
    }
    if (data.containsKey('driver_name')) {
      context.handle(
        _driverNameMeta,
        driverName.isAcceptableOrUnknown(data['driver_name']!, _driverNameMeta),
      );
    }
    if (data.containsKey('driver_mobile')) {
      context.handle(
        _driverMobileMeta,
        driverMobile.isAcceptableOrUnknown(
          data['driver_mobile']!,
          _driverMobileMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('exception_reason')) {
      context.handle(
        _exceptionReasonMeta,
        exceptionReason.isAcceptableOrUnknown(
          data['exception_reason']!,
          _exceptionReasonMeta,
        ),
      );
    }
    if (data.containsKey('vehicle_reported_at')) {
      context.handle(
        _vehicleReportedAtMeta,
        vehicleReportedAt.isAcceptableOrUnknown(
          data['vehicle_reported_at']!,
          _vehicleReportedAtMeta,
        ),
      );
    }
    if (data.containsKey('container_picked_up_at')) {
      context.handle(
        _containerPickedUpAtMeta,
        containerPickedUpAt.isAcceptableOrUnknown(
          data['container_picked_up_at']!,
          _containerPickedUpAtMeta,
        ),
      );
    }
    if (data.containsKey('in_transit_at')) {
      context.handle(
        _inTransitAtMeta,
        inTransitAt.isAcceptableOrUnknown(
          data['in_transit_at']!,
          _inTransitAtMeta,
        ),
      );
    }
    if (data.containsKey('at_port_cfs_at')) {
      context.handle(
        _atPortCfsAtMeta,
        atPortCfsAt.isAcceptableOrUnknown(
          data['at_port_cfs_at']!,
          _atPortCfsAtMeta,
        ),
      );
    }
    if (data.containsKey('container_delivered_at')) {
      context.handle(
        _containerDeliveredAtMeta,
        containerDeliveredAt.isAcceptableOrUnknown(
          data['container_delivered_at']!,
          _containerDeliveredAtMeta,
        ),
      );
    }
    if (data.containsKey('pod_received_at')) {
      context.handle(
        _podReceivedAtMeta,
        podReceivedAt.isAcceptableOrUnknown(
          data['pod_received_at']!,
          _podReceivedAtMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  LocalTransport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTransport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transportNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport_number'],
      )!,
      bookingNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_number'],
      )!,
      containerNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}container_number'],
      )!,
      sealNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seal_number'],
      )!,
      containerSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}container_size'],
      )!,
      shipmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shipment_type'],
      )!,
      partyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_id'],
      )!,
      partyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_name'],
      )!,
      partyMobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_mobile'],
      ),
      bookingPartyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_party_id'],
      )!,
      bookingPartyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_party_name'],
      )!,
      shippingLineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shipping_line_id'],
      )!,
      shippingLineName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shipping_line_name'],
      )!,
      fromLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_location_id'],
      )!,
      fromLocationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_location_name'],
      )!,
      toLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_location_id'],
      )!,
      toLocationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_location_name'],
      )!,
      portCfsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}port_cfs_id'],
      )!,
      portCfsName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}port_cfs_name'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      ),
      vehicleNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_number'],
      ),
      driverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver_id'],
      ),
      driverName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver_name'],
      ),
      driverMobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver_mobile'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      exceptionReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exception_reason'],
      ),
      vehicleReportedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}vehicle_reported_at'],
      ),
      containerPickedUpAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}container_picked_up_at'],
      ),
      inTransitAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}in_transit_at'],
      ),
      atPortCfsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at_port_cfs_at'],
      ),
      containerDeliveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}container_delivered_at'],
      ),
      podReceivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pod_received_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
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
  $LocalTransportsTable createAlias(String alias) {
    return $LocalTransportsTable(attachedDatabase, alias);
  }
}

class LocalTransport extends DataClass implements Insertable<LocalTransport> {
  final String id;
  final String transportNumber;
  final String bookingNumber;
  final String containerNumber;
  final String sealNumber;
  final String containerSize;
  final String shipmentType;
  final String partyId;
  final String partyName;
  final String? partyMobile;
  final String bookingPartyId;
  final String bookingPartyName;
  final String shippingLineId;
  final String shippingLineName;
  final String fromLocationId;
  final String fromLocationName;
  final String toLocationId;
  final String toLocationName;
  final String portCfsId;
  final String portCfsName;
  final String? vehicleId;
  final String? vehicleNumber;
  final String? driverId;
  final String? driverName;
  final String? driverMobile;
  final String status;
  final String? exceptionReason;
  final DateTime? vehicleReportedAt;
  final DateTime? containerPickedUpAt;
  final DateTime? inTransitAt;
  final DateTime? atPortCfsAt;
  final DateTime? containerDeliveredAt;
  final DateTime? podReceivedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocalTransport({
    required this.id,
    required this.transportNumber,
    required this.bookingNumber,
    required this.containerNumber,
    required this.sealNumber,
    required this.containerSize,
    required this.shipmentType,
    required this.partyId,
    required this.partyName,
    this.partyMobile,
    required this.bookingPartyId,
    required this.bookingPartyName,
    required this.shippingLineId,
    required this.shippingLineName,
    required this.fromLocationId,
    required this.fromLocationName,
    required this.toLocationId,
    required this.toLocationName,
    required this.portCfsId,
    required this.portCfsName,
    this.vehicleId,
    this.vehicleNumber,
    this.driverId,
    this.driverName,
    this.driverMobile,
    required this.status,
    this.exceptionReason,
    this.vehicleReportedAt,
    this.containerPickedUpAt,
    this.inTransitAt,
    this.atPortCfsAt,
    this.containerDeliveredAt,
    this.podReceivedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transport_number'] = Variable<String>(transportNumber);
    map['booking_number'] = Variable<String>(bookingNumber);
    map['container_number'] = Variable<String>(containerNumber);
    map['seal_number'] = Variable<String>(sealNumber);
    map['container_size'] = Variable<String>(containerSize);
    map['shipment_type'] = Variable<String>(shipmentType);
    map['party_id'] = Variable<String>(partyId);
    map['party_name'] = Variable<String>(partyName);
    if (!nullToAbsent || partyMobile != null) {
      map['party_mobile'] = Variable<String>(partyMobile);
    }
    map['booking_party_id'] = Variable<String>(bookingPartyId);
    map['booking_party_name'] = Variable<String>(bookingPartyName);
    map['shipping_line_id'] = Variable<String>(shippingLineId);
    map['shipping_line_name'] = Variable<String>(shippingLineName);
    map['from_location_id'] = Variable<String>(fromLocationId);
    map['from_location_name'] = Variable<String>(fromLocationName);
    map['to_location_id'] = Variable<String>(toLocationId);
    map['to_location_name'] = Variable<String>(toLocationName);
    map['port_cfs_id'] = Variable<String>(portCfsId);
    map['port_cfs_name'] = Variable<String>(portCfsName);
    if (!nullToAbsent || vehicleId != null) {
      map['vehicle_id'] = Variable<String>(vehicleId);
    }
    if (!nullToAbsent || vehicleNumber != null) {
      map['vehicle_number'] = Variable<String>(vehicleNumber);
    }
    if (!nullToAbsent || driverId != null) {
      map['driver_id'] = Variable<String>(driverId);
    }
    if (!nullToAbsent || driverName != null) {
      map['driver_name'] = Variable<String>(driverName);
    }
    if (!nullToAbsent || driverMobile != null) {
      map['driver_mobile'] = Variable<String>(driverMobile);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || exceptionReason != null) {
      map['exception_reason'] = Variable<String>(exceptionReason);
    }
    if (!nullToAbsent || vehicleReportedAt != null) {
      map['vehicle_reported_at'] = Variable<DateTime>(vehicleReportedAt);
    }
    if (!nullToAbsent || containerPickedUpAt != null) {
      map['container_picked_up_at'] = Variable<DateTime>(containerPickedUpAt);
    }
    if (!nullToAbsent || inTransitAt != null) {
      map['in_transit_at'] = Variable<DateTime>(inTransitAt);
    }
    if (!nullToAbsent || atPortCfsAt != null) {
      map['at_port_cfs_at'] = Variable<DateTime>(atPortCfsAt);
    }
    if (!nullToAbsent || containerDeliveredAt != null) {
      map['container_delivered_at'] = Variable<DateTime>(containerDeliveredAt);
    }
    if (!nullToAbsent || podReceivedAt != null) {
      map['pod_received_at'] = Variable<DateTime>(podReceivedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalTransportsCompanion toCompanion(bool nullToAbsent) {
    return LocalTransportsCompanion(
      id: Value(id),
      transportNumber: Value(transportNumber),
      bookingNumber: Value(bookingNumber),
      containerNumber: Value(containerNumber),
      sealNumber: Value(sealNumber),
      containerSize: Value(containerSize),
      shipmentType: Value(shipmentType),
      partyId: Value(partyId),
      partyName: Value(partyName),
      partyMobile: partyMobile == null && nullToAbsent
          ? const Value.absent()
          : Value(partyMobile),
      bookingPartyId: Value(bookingPartyId),
      bookingPartyName: Value(bookingPartyName),
      shippingLineId: Value(shippingLineId),
      shippingLineName: Value(shippingLineName),
      fromLocationId: Value(fromLocationId),
      fromLocationName: Value(fromLocationName),
      toLocationId: Value(toLocationId),
      toLocationName: Value(toLocationName),
      portCfsId: Value(portCfsId),
      portCfsName: Value(portCfsName),
      vehicleId: vehicleId == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleId),
      vehicleNumber: vehicleNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleNumber),
      driverId: driverId == null && nullToAbsent
          ? const Value.absent()
          : Value(driverId),
      driverName: driverName == null && nullToAbsent
          ? const Value.absent()
          : Value(driverName),
      driverMobile: driverMobile == null && nullToAbsent
          ? const Value.absent()
          : Value(driverMobile),
      status: Value(status),
      exceptionReason: exceptionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(exceptionReason),
      vehicleReportedAt: vehicleReportedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleReportedAt),
      containerPickedUpAt: containerPickedUpAt == null && nullToAbsent
          ? const Value.absent()
          : Value(containerPickedUpAt),
      inTransitAt: inTransitAt == null && nullToAbsent
          ? const Value.absent()
          : Value(inTransitAt),
      atPortCfsAt: atPortCfsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(atPortCfsAt),
      containerDeliveredAt: containerDeliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(containerDeliveredAt),
      podReceivedAt: podReceivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(podReceivedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalTransport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTransport(
      id: serializer.fromJson<String>(json['id']),
      transportNumber: serializer.fromJson<String>(json['transportNumber']),
      bookingNumber: serializer.fromJson<String>(json['bookingNumber']),
      containerNumber: serializer.fromJson<String>(json['containerNumber']),
      sealNumber: serializer.fromJson<String>(json['sealNumber']),
      containerSize: serializer.fromJson<String>(json['containerSize']),
      shipmentType: serializer.fromJson<String>(json['shipmentType']),
      partyId: serializer.fromJson<String>(json['partyId']),
      partyName: serializer.fromJson<String>(json['partyName']),
      partyMobile: serializer.fromJson<String?>(json['partyMobile']),
      bookingPartyId: serializer.fromJson<String>(json['bookingPartyId']),
      bookingPartyName: serializer.fromJson<String>(json['bookingPartyName']),
      shippingLineId: serializer.fromJson<String>(json['shippingLineId']),
      shippingLineName: serializer.fromJson<String>(json['shippingLineName']),
      fromLocationId: serializer.fromJson<String>(json['fromLocationId']),
      fromLocationName: serializer.fromJson<String>(json['fromLocationName']),
      toLocationId: serializer.fromJson<String>(json['toLocationId']),
      toLocationName: serializer.fromJson<String>(json['toLocationName']),
      portCfsId: serializer.fromJson<String>(json['portCfsId']),
      portCfsName: serializer.fromJson<String>(json['portCfsName']),
      vehicleId: serializer.fromJson<String?>(json['vehicleId']),
      vehicleNumber: serializer.fromJson<String?>(json['vehicleNumber']),
      driverId: serializer.fromJson<String?>(json['driverId']),
      driverName: serializer.fromJson<String?>(json['driverName']),
      driverMobile: serializer.fromJson<String?>(json['driverMobile']),
      status: serializer.fromJson<String>(json['status']),
      exceptionReason: serializer.fromJson<String?>(json['exceptionReason']),
      vehicleReportedAt: serializer.fromJson<DateTime?>(
        json['vehicleReportedAt'],
      ),
      containerPickedUpAt: serializer.fromJson<DateTime?>(
        json['containerPickedUpAt'],
      ),
      inTransitAt: serializer.fromJson<DateTime?>(json['inTransitAt']),
      atPortCfsAt: serializer.fromJson<DateTime?>(json['atPortCfsAt']),
      containerDeliveredAt: serializer.fromJson<DateTime?>(
        json['containerDeliveredAt'],
      ),
      podReceivedAt: serializer.fromJson<DateTime?>(json['podReceivedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transportNumber': serializer.toJson<String>(transportNumber),
      'bookingNumber': serializer.toJson<String>(bookingNumber),
      'containerNumber': serializer.toJson<String>(containerNumber),
      'sealNumber': serializer.toJson<String>(sealNumber),
      'containerSize': serializer.toJson<String>(containerSize),
      'shipmentType': serializer.toJson<String>(shipmentType),
      'partyId': serializer.toJson<String>(partyId),
      'partyName': serializer.toJson<String>(partyName),
      'partyMobile': serializer.toJson<String?>(partyMobile),
      'bookingPartyId': serializer.toJson<String>(bookingPartyId),
      'bookingPartyName': serializer.toJson<String>(bookingPartyName),
      'shippingLineId': serializer.toJson<String>(shippingLineId),
      'shippingLineName': serializer.toJson<String>(shippingLineName),
      'fromLocationId': serializer.toJson<String>(fromLocationId),
      'fromLocationName': serializer.toJson<String>(fromLocationName),
      'toLocationId': serializer.toJson<String>(toLocationId),
      'toLocationName': serializer.toJson<String>(toLocationName),
      'portCfsId': serializer.toJson<String>(portCfsId),
      'portCfsName': serializer.toJson<String>(portCfsName),
      'vehicleId': serializer.toJson<String?>(vehicleId),
      'vehicleNumber': serializer.toJson<String?>(vehicleNumber),
      'driverId': serializer.toJson<String?>(driverId),
      'driverName': serializer.toJson<String?>(driverName),
      'driverMobile': serializer.toJson<String?>(driverMobile),
      'status': serializer.toJson<String>(status),
      'exceptionReason': serializer.toJson<String?>(exceptionReason),
      'vehicleReportedAt': serializer.toJson<DateTime?>(vehicleReportedAt),
      'containerPickedUpAt': serializer.toJson<DateTime?>(containerPickedUpAt),
      'inTransitAt': serializer.toJson<DateTime?>(inTransitAt),
      'atPortCfsAt': serializer.toJson<DateTime?>(atPortCfsAt),
      'containerDeliveredAt': serializer.toJson<DateTime?>(
        containerDeliveredAt,
      ),
      'podReceivedAt': serializer.toJson<DateTime?>(podReceivedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalTransport copyWith({
    String? id,
    String? transportNumber,
    String? bookingNumber,
    String? containerNumber,
    String? sealNumber,
    String? containerSize,
    String? shipmentType,
    String? partyId,
    String? partyName,
    Value<String?> partyMobile = const Value.absent(),
    String? bookingPartyId,
    String? bookingPartyName,
    String? shippingLineId,
    String? shippingLineName,
    String? fromLocationId,
    String? fromLocationName,
    String? toLocationId,
    String? toLocationName,
    String? portCfsId,
    String? portCfsName,
    Value<String?> vehicleId = const Value.absent(),
    Value<String?> vehicleNumber = const Value.absent(),
    Value<String?> driverId = const Value.absent(),
    Value<String?> driverName = const Value.absent(),
    Value<String?> driverMobile = const Value.absent(),
    String? status,
    Value<String?> exceptionReason = const Value.absent(),
    Value<DateTime?> vehicleReportedAt = const Value.absent(),
    Value<DateTime?> containerPickedUpAt = const Value.absent(),
    Value<DateTime?> inTransitAt = const Value.absent(),
    Value<DateTime?> atPortCfsAt = const Value.absent(),
    Value<DateTime?> containerDeliveredAt = const Value.absent(),
    Value<DateTime?> podReceivedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocalTransport(
    id: id ?? this.id,
    transportNumber: transportNumber ?? this.transportNumber,
    bookingNumber: bookingNumber ?? this.bookingNumber,
    containerNumber: containerNumber ?? this.containerNumber,
    sealNumber: sealNumber ?? this.sealNumber,
    containerSize: containerSize ?? this.containerSize,
    shipmentType: shipmentType ?? this.shipmentType,
    partyId: partyId ?? this.partyId,
    partyName: partyName ?? this.partyName,
    partyMobile: partyMobile.present ? partyMobile.value : this.partyMobile,
    bookingPartyId: bookingPartyId ?? this.bookingPartyId,
    bookingPartyName: bookingPartyName ?? this.bookingPartyName,
    shippingLineId: shippingLineId ?? this.shippingLineId,
    shippingLineName: shippingLineName ?? this.shippingLineName,
    fromLocationId: fromLocationId ?? this.fromLocationId,
    fromLocationName: fromLocationName ?? this.fromLocationName,
    toLocationId: toLocationId ?? this.toLocationId,
    toLocationName: toLocationName ?? this.toLocationName,
    portCfsId: portCfsId ?? this.portCfsId,
    portCfsName: portCfsName ?? this.portCfsName,
    vehicleId: vehicleId.present ? vehicleId.value : this.vehicleId,
    vehicleNumber: vehicleNumber.present
        ? vehicleNumber.value
        : this.vehicleNumber,
    driverId: driverId.present ? driverId.value : this.driverId,
    driverName: driverName.present ? driverName.value : this.driverName,
    driverMobile: driverMobile.present ? driverMobile.value : this.driverMobile,
    status: status ?? this.status,
    exceptionReason: exceptionReason.present
        ? exceptionReason.value
        : this.exceptionReason,
    vehicleReportedAt: vehicleReportedAt.present
        ? vehicleReportedAt.value
        : this.vehicleReportedAt,
    containerPickedUpAt: containerPickedUpAt.present
        ? containerPickedUpAt.value
        : this.containerPickedUpAt,
    inTransitAt: inTransitAt.present ? inTransitAt.value : this.inTransitAt,
    atPortCfsAt: atPortCfsAt.present ? atPortCfsAt.value : this.atPortCfsAt,
    containerDeliveredAt: containerDeliveredAt.present
        ? containerDeliveredAt.value
        : this.containerDeliveredAt,
    podReceivedAt: podReceivedAt.present
        ? podReceivedAt.value
        : this.podReceivedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalTransport copyWithCompanion(LocalTransportsCompanion data) {
    return LocalTransport(
      id: data.id.present ? data.id.value : this.id,
      transportNumber: data.transportNumber.present
          ? data.transportNumber.value
          : this.transportNumber,
      bookingNumber: data.bookingNumber.present
          ? data.bookingNumber.value
          : this.bookingNumber,
      containerNumber: data.containerNumber.present
          ? data.containerNumber.value
          : this.containerNumber,
      sealNumber: data.sealNumber.present
          ? data.sealNumber.value
          : this.sealNumber,
      containerSize: data.containerSize.present
          ? data.containerSize.value
          : this.containerSize,
      shipmentType: data.shipmentType.present
          ? data.shipmentType.value
          : this.shipmentType,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      partyName: data.partyName.present ? data.partyName.value : this.partyName,
      partyMobile: data.partyMobile.present
          ? data.partyMobile.value
          : this.partyMobile,
      bookingPartyId: data.bookingPartyId.present
          ? data.bookingPartyId.value
          : this.bookingPartyId,
      bookingPartyName: data.bookingPartyName.present
          ? data.bookingPartyName.value
          : this.bookingPartyName,
      shippingLineId: data.shippingLineId.present
          ? data.shippingLineId.value
          : this.shippingLineId,
      shippingLineName: data.shippingLineName.present
          ? data.shippingLineName.value
          : this.shippingLineName,
      fromLocationId: data.fromLocationId.present
          ? data.fromLocationId.value
          : this.fromLocationId,
      fromLocationName: data.fromLocationName.present
          ? data.fromLocationName.value
          : this.fromLocationName,
      toLocationId: data.toLocationId.present
          ? data.toLocationId.value
          : this.toLocationId,
      toLocationName: data.toLocationName.present
          ? data.toLocationName.value
          : this.toLocationName,
      portCfsId: data.portCfsId.present ? data.portCfsId.value : this.portCfsId,
      portCfsName: data.portCfsName.present
          ? data.portCfsName.value
          : this.portCfsName,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      vehicleNumber: data.vehicleNumber.present
          ? data.vehicleNumber.value
          : this.vehicleNumber,
      driverId: data.driverId.present ? data.driverId.value : this.driverId,
      driverName: data.driverName.present
          ? data.driverName.value
          : this.driverName,
      driverMobile: data.driverMobile.present
          ? data.driverMobile.value
          : this.driverMobile,
      status: data.status.present ? data.status.value : this.status,
      exceptionReason: data.exceptionReason.present
          ? data.exceptionReason.value
          : this.exceptionReason,
      vehicleReportedAt: data.vehicleReportedAt.present
          ? data.vehicleReportedAt.value
          : this.vehicleReportedAt,
      containerPickedUpAt: data.containerPickedUpAt.present
          ? data.containerPickedUpAt.value
          : this.containerPickedUpAt,
      inTransitAt: data.inTransitAt.present
          ? data.inTransitAt.value
          : this.inTransitAt,
      atPortCfsAt: data.atPortCfsAt.present
          ? data.atPortCfsAt.value
          : this.atPortCfsAt,
      containerDeliveredAt: data.containerDeliveredAt.present
          ? data.containerDeliveredAt.value
          : this.containerDeliveredAt,
      podReceivedAt: data.podReceivedAt.present
          ? data.podReceivedAt.value
          : this.podReceivedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransport(')
          ..write('id: $id, ')
          ..write('transportNumber: $transportNumber, ')
          ..write('bookingNumber: $bookingNumber, ')
          ..write('containerNumber: $containerNumber, ')
          ..write('sealNumber: $sealNumber, ')
          ..write('containerSize: $containerSize, ')
          ..write('shipmentType: $shipmentType, ')
          ..write('partyId: $partyId, ')
          ..write('partyName: $partyName, ')
          ..write('partyMobile: $partyMobile, ')
          ..write('bookingPartyId: $bookingPartyId, ')
          ..write('bookingPartyName: $bookingPartyName, ')
          ..write('shippingLineId: $shippingLineId, ')
          ..write('shippingLineName: $shippingLineName, ')
          ..write('fromLocationId: $fromLocationId, ')
          ..write('fromLocationName: $fromLocationName, ')
          ..write('toLocationId: $toLocationId, ')
          ..write('toLocationName: $toLocationName, ')
          ..write('portCfsId: $portCfsId, ')
          ..write('portCfsName: $portCfsName, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('vehicleNumber: $vehicleNumber, ')
          ..write('driverId: $driverId, ')
          ..write('driverName: $driverName, ')
          ..write('driverMobile: $driverMobile, ')
          ..write('status: $status, ')
          ..write('exceptionReason: $exceptionReason, ')
          ..write('vehicleReportedAt: $vehicleReportedAt, ')
          ..write('containerPickedUpAt: $containerPickedUpAt, ')
          ..write('inTransitAt: $inTransitAt, ')
          ..write('atPortCfsAt: $atPortCfsAt, ')
          ..write('containerDeliveredAt: $containerDeliveredAt, ')
          ..write('podReceivedAt: $podReceivedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    transportNumber,
    bookingNumber,
    containerNumber,
    sealNumber,
    containerSize,
    shipmentType,
    partyId,
    partyName,
    partyMobile,
    bookingPartyId,
    bookingPartyName,
    shippingLineId,
    shippingLineName,
    fromLocationId,
    fromLocationName,
    toLocationId,
    toLocationName,
    portCfsId,
    portCfsName,
    vehicleId,
    vehicleNumber,
    driverId,
    driverName,
    driverMobile,
    status,
    exceptionReason,
    vehicleReportedAt,
    containerPickedUpAt,
    inTransitAt,
    atPortCfsAt,
    containerDeliveredAt,
    podReceivedAt,
    completedAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTransport &&
          other.id == this.id &&
          other.transportNumber == this.transportNumber &&
          other.bookingNumber == this.bookingNumber &&
          other.containerNumber == this.containerNumber &&
          other.sealNumber == this.sealNumber &&
          other.containerSize == this.containerSize &&
          other.shipmentType == this.shipmentType &&
          other.partyId == this.partyId &&
          other.partyName == this.partyName &&
          other.partyMobile == this.partyMobile &&
          other.bookingPartyId == this.bookingPartyId &&
          other.bookingPartyName == this.bookingPartyName &&
          other.shippingLineId == this.shippingLineId &&
          other.shippingLineName == this.shippingLineName &&
          other.fromLocationId == this.fromLocationId &&
          other.fromLocationName == this.fromLocationName &&
          other.toLocationId == this.toLocationId &&
          other.toLocationName == this.toLocationName &&
          other.portCfsId == this.portCfsId &&
          other.portCfsName == this.portCfsName &&
          other.vehicleId == this.vehicleId &&
          other.vehicleNumber == this.vehicleNumber &&
          other.driverId == this.driverId &&
          other.driverName == this.driverName &&
          other.driverMobile == this.driverMobile &&
          other.status == this.status &&
          other.exceptionReason == this.exceptionReason &&
          other.vehicleReportedAt == this.vehicleReportedAt &&
          other.containerPickedUpAt == this.containerPickedUpAt &&
          other.inTransitAt == this.inTransitAt &&
          other.atPortCfsAt == this.atPortCfsAt &&
          other.containerDeliveredAt == this.containerDeliveredAt &&
          other.podReceivedAt == this.podReceivedAt &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalTransportsCompanion extends UpdateCompanion<LocalTransport> {
  final Value<String> id;
  final Value<String> transportNumber;
  final Value<String> bookingNumber;
  final Value<String> containerNumber;
  final Value<String> sealNumber;
  final Value<String> containerSize;
  final Value<String> shipmentType;
  final Value<String> partyId;
  final Value<String> partyName;
  final Value<String?> partyMobile;
  final Value<String> bookingPartyId;
  final Value<String> bookingPartyName;
  final Value<String> shippingLineId;
  final Value<String> shippingLineName;
  final Value<String> fromLocationId;
  final Value<String> fromLocationName;
  final Value<String> toLocationId;
  final Value<String> toLocationName;
  final Value<String> portCfsId;
  final Value<String> portCfsName;
  final Value<String?> vehicleId;
  final Value<String?> vehicleNumber;
  final Value<String?> driverId;
  final Value<String?> driverName;
  final Value<String?> driverMobile;
  final Value<String> status;
  final Value<String?> exceptionReason;
  final Value<DateTime?> vehicleReportedAt;
  final Value<DateTime?> containerPickedUpAt;
  final Value<DateTime?> inTransitAt;
  final Value<DateTime?> atPortCfsAt;
  final Value<DateTime?> containerDeliveredAt;
  final Value<DateTime?> podReceivedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalTransportsCompanion({
    this.id = const Value.absent(),
    this.transportNumber = const Value.absent(),
    this.bookingNumber = const Value.absent(),
    this.containerNumber = const Value.absent(),
    this.sealNumber = const Value.absent(),
    this.containerSize = const Value.absent(),
    this.shipmentType = const Value.absent(),
    this.partyId = const Value.absent(),
    this.partyName = const Value.absent(),
    this.partyMobile = const Value.absent(),
    this.bookingPartyId = const Value.absent(),
    this.bookingPartyName = const Value.absent(),
    this.shippingLineId = const Value.absent(),
    this.shippingLineName = const Value.absent(),
    this.fromLocationId = const Value.absent(),
    this.fromLocationName = const Value.absent(),
    this.toLocationId = const Value.absent(),
    this.toLocationName = const Value.absent(),
    this.portCfsId = const Value.absent(),
    this.portCfsName = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.vehicleNumber = const Value.absent(),
    this.driverId = const Value.absent(),
    this.driverName = const Value.absent(),
    this.driverMobile = const Value.absent(),
    this.status = const Value.absent(),
    this.exceptionReason = const Value.absent(),
    this.vehicleReportedAt = const Value.absent(),
    this.containerPickedUpAt = const Value.absent(),
    this.inTransitAt = const Value.absent(),
    this.atPortCfsAt = const Value.absent(),
    this.containerDeliveredAt = const Value.absent(),
    this.podReceivedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTransportsCompanion.insert({
    required String id,
    required String transportNumber,
    required String bookingNumber,
    required String containerNumber,
    required String sealNumber,
    required String containerSize,
    required String shipmentType,
    required String partyId,
    required String partyName,
    this.partyMobile = const Value.absent(),
    required String bookingPartyId,
    required String bookingPartyName,
    required String shippingLineId,
    required String shippingLineName,
    required String fromLocationId,
    required String fromLocationName,
    required String toLocationId,
    required String toLocationName,
    required String portCfsId,
    required String portCfsName,
    this.vehicleId = const Value.absent(),
    this.vehicleNumber = const Value.absent(),
    this.driverId = const Value.absent(),
    this.driverName = const Value.absent(),
    this.driverMobile = const Value.absent(),
    this.status = const Value.absent(),
    this.exceptionReason = const Value.absent(),
    this.vehicleReportedAt = const Value.absent(),
    this.containerPickedUpAt = const Value.absent(),
    this.inTransitAt = const Value.absent(),
    this.atPortCfsAt = const Value.absent(),
    this.containerDeliveredAt = const Value.absent(),
    this.podReceivedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transportNumber = Value(transportNumber),
       bookingNumber = Value(bookingNumber),
       containerNumber = Value(containerNumber),
       sealNumber = Value(sealNumber),
       containerSize = Value(containerSize),
       shipmentType = Value(shipmentType),
       partyId = Value(partyId),
       partyName = Value(partyName),
       bookingPartyId = Value(bookingPartyId),
       bookingPartyName = Value(bookingPartyName),
       shippingLineId = Value(shippingLineId),
       shippingLineName = Value(shippingLineName),
       fromLocationId = Value(fromLocationId),
       fromLocationName = Value(fromLocationName),
       toLocationId = Value(toLocationId),
       toLocationName = Value(toLocationName),
       portCfsId = Value(portCfsId),
       portCfsName = Value(portCfsName),
       createdAt = Value(createdAt);
  static Insertable<LocalTransport> custom({
    Expression<String>? id,
    Expression<String>? transportNumber,
    Expression<String>? bookingNumber,
    Expression<String>? containerNumber,
    Expression<String>? sealNumber,
    Expression<String>? containerSize,
    Expression<String>? shipmentType,
    Expression<String>? partyId,
    Expression<String>? partyName,
    Expression<String>? partyMobile,
    Expression<String>? bookingPartyId,
    Expression<String>? bookingPartyName,
    Expression<String>? shippingLineId,
    Expression<String>? shippingLineName,
    Expression<String>? fromLocationId,
    Expression<String>? fromLocationName,
    Expression<String>? toLocationId,
    Expression<String>? toLocationName,
    Expression<String>? portCfsId,
    Expression<String>? portCfsName,
    Expression<String>? vehicleId,
    Expression<String>? vehicleNumber,
    Expression<String>? driverId,
    Expression<String>? driverName,
    Expression<String>? driverMobile,
    Expression<String>? status,
    Expression<String>? exceptionReason,
    Expression<DateTime>? vehicleReportedAt,
    Expression<DateTime>? containerPickedUpAt,
    Expression<DateTime>? inTransitAt,
    Expression<DateTime>? atPortCfsAt,
    Expression<DateTime>? containerDeliveredAt,
    Expression<DateTime>? podReceivedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transportNumber != null) 'transport_number': transportNumber,
      if (bookingNumber != null) 'booking_number': bookingNumber,
      if (containerNumber != null) 'container_number': containerNumber,
      if (sealNumber != null) 'seal_number': sealNumber,
      if (containerSize != null) 'container_size': containerSize,
      if (shipmentType != null) 'shipment_type': shipmentType,
      if (partyId != null) 'party_id': partyId,
      if (partyName != null) 'party_name': partyName,
      if (partyMobile != null) 'party_mobile': partyMobile,
      if (bookingPartyId != null) 'booking_party_id': bookingPartyId,
      if (bookingPartyName != null) 'booking_party_name': bookingPartyName,
      if (shippingLineId != null) 'shipping_line_id': shippingLineId,
      if (shippingLineName != null) 'shipping_line_name': shippingLineName,
      if (fromLocationId != null) 'from_location_id': fromLocationId,
      if (fromLocationName != null) 'from_location_name': fromLocationName,
      if (toLocationId != null) 'to_location_id': toLocationId,
      if (toLocationName != null) 'to_location_name': toLocationName,
      if (portCfsId != null) 'port_cfs_id': portCfsId,
      if (portCfsName != null) 'port_cfs_name': portCfsName,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (vehicleNumber != null) 'vehicle_number': vehicleNumber,
      if (driverId != null) 'driver_id': driverId,
      if (driverName != null) 'driver_name': driverName,
      if (driverMobile != null) 'driver_mobile': driverMobile,
      if (status != null) 'status': status,
      if (exceptionReason != null) 'exception_reason': exceptionReason,
      if (vehicleReportedAt != null) 'vehicle_reported_at': vehicleReportedAt,
      if (containerPickedUpAt != null)
        'container_picked_up_at': containerPickedUpAt,
      if (inTransitAt != null) 'in_transit_at': inTransitAt,
      if (atPortCfsAt != null) 'at_port_cfs_at': atPortCfsAt,
      if (containerDeliveredAt != null)
        'container_delivered_at': containerDeliveredAt,
      if (podReceivedAt != null) 'pod_received_at': podReceivedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTransportsCompanion copyWith({
    Value<String>? id,
    Value<String>? transportNumber,
    Value<String>? bookingNumber,
    Value<String>? containerNumber,
    Value<String>? sealNumber,
    Value<String>? containerSize,
    Value<String>? shipmentType,
    Value<String>? partyId,
    Value<String>? partyName,
    Value<String?>? partyMobile,
    Value<String>? bookingPartyId,
    Value<String>? bookingPartyName,
    Value<String>? shippingLineId,
    Value<String>? shippingLineName,
    Value<String>? fromLocationId,
    Value<String>? fromLocationName,
    Value<String>? toLocationId,
    Value<String>? toLocationName,
    Value<String>? portCfsId,
    Value<String>? portCfsName,
    Value<String?>? vehicleId,
    Value<String?>? vehicleNumber,
    Value<String?>? driverId,
    Value<String?>? driverName,
    Value<String?>? driverMobile,
    Value<String>? status,
    Value<String?>? exceptionReason,
    Value<DateTime?>? vehicleReportedAt,
    Value<DateTime?>? containerPickedUpAt,
    Value<DateTime?>? inTransitAt,
    Value<DateTime?>? atPortCfsAt,
    Value<DateTime?>? containerDeliveredAt,
    Value<DateTime?>? podReceivedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalTransportsCompanion(
      id: id ?? this.id,
      transportNumber: transportNumber ?? this.transportNumber,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      containerNumber: containerNumber ?? this.containerNumber,
      sealNumber: sealNumber ?? this.sealNumber,
      containerSize: containerSize ?? this.containerSize,
      shipmentType: shipmentType ?? this.shipmentType,
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      partyMobile: partyMobile ?? this.partyMobile,
      bookingPartyId: bookingPartyId ?? this.bookingPartyId,
      bookingPartyName: bookingPartyName ?? this.bookingPartyName,
      shippingLineId: shippingLineId ?? this.shippingLineId,
      shippingLineName: shippingLineName ?? this.shippingLineName,
      fromLocationId: fromLocationId ?? this.fromLocationId,
      fromLocationName: fromLocationName ?? this.fromLocationName,
      toLocationId: toLocationId ?? this.toLocationId,
      toLocationName: toLocationName ?? this.toLocationName,
      portCfsId: portCfsId ?? this.portCfsId,
      portCfsName: portCfsName ?? this.portCfsName,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverMobile: driverMobile ?? this.driverMobile,
      status: status ?? this.status,
      exceptionReason: exceptionReason ?? this.exceptionReason,
      vehicleReportedAt: vehicleReportedAt ?? this.vehicleReportedAt,
      containerPickedUpAt: containerPickedUpAt ?? this.containerPickedUpAt,
      inTransitAt: inTransitAt ?? this.inTransitAt,
      atPortCfsAt: atPortCfsAt ?? this.atPortCfsAt,
      containerDeliveredAt: containerDeliveredAt ?? this.containerDeliveredAt,
      podReceivedAt: podReceivedAt ?? this.podReceivedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transportNumber.present) {
      map['transport_number'] = Variable<String>(transportNumber.value);
    }
    if (bookingNumber.present) {
      map['booking_number'] = Variable<String>(bookingNumber.value);
    }
    if (containerNumber.present) {
      map['container_number'] = Variable<String>(containerNumber.value);
    }
    if (sealNumber.present) {
      map['seal_number'] = Variable<String>(sealNumber.value);
    }
    if (containerSize.present) {
      map['container_size'] = Variable<String>(containerSize.value);
    }
    if (shipmentType.present) {
      map['shipment_type'] = Variable<String>(shipmentType.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<String>(partyId.value);
    }
    if (partyName.present) {
      map['party_name'] = Variable<String>(partyName.value);
    }
    if (partyMobile.present) {
      map['party_mobile'] = Variable<String>(partyMobile.value);
    }
    if (bookingPartyId.present) {
      map['booking_party_id'] = Variable<String>(bookingPartyId.value);
    }
    if (bookingPartyName.present) {
      map['booking_party_name'] = Variable<String>(bookingPartyName.value);
    }
    if (shippingLineId.present) {
      map['shipping_line_id'] = Variable<String>(shippingLineId.value);
    }
    if (shippingLineName.present) {
      map['shipping_line_name'] = Variable<String>(shippingLineName.value);
    }
    if (fromLocationId.present) {
      map['from_location_id'] = Variable<String>(fromLocationId.value);
    }
    if (fromLocationName.present) {
      map['from_location_name'] = Variable<String>(fromLocationName.value);
    }
    if (toLocationId.present) {
      map['to_location_id'] = Variable<String>(toLocationId.value);
    }
    if (toLocationName.present) {
      map['to_location_name'] = Variable<String>(toLocationName.value);
    }
    if (portCfsId.present) {
      map['port_cfs_id'] = Variable<String>(portCfsId.value);
    }
    if (portCfsName.present) {
      map['port_cfs_name'] = Variable<String>(portCfsName.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (vehicleNumber.present) {
      map['vehicle_number'] = Variable<String>(vehicleNumber.value);
    }
    if (driverId.present) {
      map['driver_id'] = Variable<String>(driverId.value);
    }
    if (driverName.present) {
      map['driver_name'] = Variable<String>(driverName.value);
    }
    if (driverMobile.present) {
      map['driver_mobile'] = Variable<String>(driverMobile.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (exceptionReason.present) {
      map['exception_reason'] = Variable<String>(exceptionReason.value);
    }
    if (vehicleReportedAt.present) {
      map['vehicle_reported_at'] = Variable<DateTime>(vehicleReportedAt.value);
    }
    if (containerPickedUpAt.present) {
      map['container_picked_up_at'] = Variable<DateTime>(
        containerPickedUpAt.value,
      );
    }
    if (inTransitAt.present) {
      map['in_transit_at'] = Variable<DateTime>(inTransitAt.value);
    }
    if (atPortCfsAt.present) {
      map['at_port_cfs_at'] = Variable<DateTime>(atPortCfsAt.value);
    }
    if (containerDeliveredAt.present) {
      map['container_delivered_at'] = Variable<DateTime>(
        containerDeliveredAt.value,
      );
    }
    if (podReceivedAt.present) {
      map['pod_received_at'] = Variable<DateTime>(podReceivedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransportsCompanion(')
          ..write('id: $id, ')
          ..write('transportNumber: $transportNumber, ')
          ..write('bookingNumber: $bookingNumber, ')
          ..write('containerNumber: $containerNumber, ')
          ..write('sealNumber: $sealNumber, ')
          ..write('containerSize: $containerSize, ')
          ..write('shipmentType: $shipmentType, ')
          ..write('partyId: $partyId, ')
          ..write('partyName: $partyName, ')
          ..write('partyMobile: $partyMobile, ')
          ..write('bookingPartyId: $bookingPartyId, ')
          ..write('bookingPartyName: $bookingPartyName, ')
          ..write('shippingLineId: $shippingLineId, ')
          ..write('shippingLineName: $shippingLineName, ')
          ..write('fromLocationId: $fromLocationId, ')
          ..write('fromLocationName: $fromLocationName, ')
          ..write('toLocationId: $toLocationId, ')
          ..write('toLocationName: $toLocationName, ')
          ..write('portCfsId: $portCfsId, ')
          ..write('portCfsName: $portCfsName, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('vehicleNumber: $vehicleNumber, ')
          ..write('driverId: $driverId, ')
          ..write('driverName: $driverName, ')
          ..write('driverMobile: $driverMobile, ')
          ..write('status: $status, ')
          ..write('exceptionReason: $exceptionReason, ')
          ..write('vehicleReportedAt: $vehicleReportedAt, ')
          ..write('containerPickedUpAt: $containerPickedUpAt, ')
          ..write('inTransitAt: $inTransitAt, ')
          ..write('atPortCfsAt: $atPortCfsAt, ')
          ..write('containerDeliveredAt: $containerDeliveredAt, ')
          ..write('podReceivedAt: $podReceivedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalTransportStatusHistoryTable extends LocalTransportStatusHistory
    with
        TableInfo<
          $LocalTransportStatusHistoryTable,
          LocalTransportStatusHistoryData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTransportStatusHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportIdMeta = const VerificationMeta(
    'transportId',
  );
  @override
  late final GeneratedColumn<String> transportId = GeneratedColumn<String>(
    'transport_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changedByMeta = const VerificationMeta(
    'changedBy',
  );
  @override
  late final GeneratedColumn<String> changedBy = GeneratedColumn<String>(
    'changed_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Super Admin'),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transportId,
    status,
    remarks,
    changedBy,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_transport_status_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTransportStatusHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transport_id')) {
      context.handle(
        _transportIdMeta,
        transportId.isAcceptableOrUnknown(
          data['transport_id']!,
          _transportIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transportIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    if (data.containsKey('changed_by')) {
      context.handle(
        _changedByMeta,
        changedBy.isAcceptableOrUnknown(data['changed_by']!, _changedByMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalTransportStatusHistoryData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTransportStatusHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
      changedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changed_by'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalTransportStatusHistoryTable createAlias(String alias) {
    return $LocalTransportStatusHistoryTable(attachedDatabase, alias);
  }
}

class LocalTransportStatusHistoryData extends DataClass
    implements Insertable<LocalTransportStatusHistoryData> {
  final String id;
  final String transportId;
  final String status;
  final String? remarks;
  final String changedBy;
  final DateTime createdAt;
  const LocalTransportStatusHistoryData({
    required this.id,
    required this.transportId,
    required this.status,
    this.remarks,
    required this.changedBy,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transport_id'] = Variable<String>(transportId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['changed_by'] = Variable<String>(changedBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalTransportStatusHistoryCompanion toCompanion(bool nullToAbsent) {
    return LocalTransportStatusHistoryCompanion(
      id: Value(id),
      transportId: Value(transportId),
      status: Value(status),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      changedBy: Value(changedBy),
      createdAt: Value(createdAt),
    );
  }

  factory LocalTransportStatusHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTransportStatusHistoryData(
      id: serializer.fromJson<String>(json['id']),
      transportId: serializer.fromJson<String>(json['transportId']),
      status: serializer.fromJson<String>(json['status']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      changedBy: serializer.fromJson<String>(json['changedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transportId': serializer.toJson<String>(transportId),
      'status': serializer.toJson<String>(status),
      'remarks': serializer.toJson<String?>(remarks),
      'changedBy': serializer.toJson<String>(changedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalTransportStatusHistoryData copyWith({
    String? id,
    String? transportId,
    String? status,
    Value<String?> remarks = const Value.absent(),
    String? changedBy,
    DateTime? createdAt,
  }) => LocalTransportStatusHistoryData(
    id: id ?? this.id,
    transportId: transportId ?? this.transportId,
    status: status ?? this.status,
    remarks: remarks.present ? remarks.value : this.remarks,
    changedBy: changedBy ?? this.changedBy,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalTransportStatusHistoryData copyWithCompanion(
    LocalTransportStatusHistoryCompanion data,
  ) {
    return LocalTransportStatusHistoryData(
      id: data.id.present ? data.id.value : this.id,
      transportId: data.transportId.present
          ? data.transportId.value
          : this.transportId,
      status: data.status.present ? data.status.value : this.status,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      changedBy: data.changedBy.present ? data.changedBy.value : this.changedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransportStatusHistoryData(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('status: $status, ')
          ..write('remarks: $remarks, ')
          ..write('changedBy: $changedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, transportId, status, remarks, changedBy, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTransportStatusHistoryData &&
          other.id == this.id &&
          other.transportId == this.transportId &&
          other.status == this.status &&
          other.remarks == this.remarks &&
          other.changedBy == this.changedBy &&
          other.createdAt == this.createdAt);
}

class LocalTransportStatusHistoryCompanion
    extends UpdateCompanion<LocalTransportStatusHistoryData> {
  final Value<String> id;
  final Value<String> transportId;
  final Value<String> status;
  final Value<String?> remarks;
  final Value<String> changedBy;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalTransportStatusHistoryCompanion({
    this.id = const Value.absent(),
    this.transportId = const Value.absent(),
    this.status = const Value.absent(),
    this.remarks = const Value.absent(),
    this.changedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTransportStatusHistoryCompanion.insert({
    required String id,
    required String transportId,
    required String status,
    this.remarks = const Value.absent(),
    this.changedBy = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transportId = Value(transportId),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<LocalTransportStatusHistoryData> custom({
    Expression<String>? id,
    Expression<String>? transportId,
    Expression<String>? status,
    Expression<String>? remarks,
    Expression<String>? changedBy,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transportId != null) 'transport_id': transportId,
      if (status != null) 'status': status,
      if (remarks != null) 'remarks': remarks,
      if (changedBy != null) 'changed_by': changedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTransportStatusHistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? transportId,
    Value<String>? status,
    Value<String?>? remarks,
    Value<String>? changedBy,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalTransportStatusHistoryCompanion(
      id: id ?? this.id,
      transportId: transportId ?? this.transportId,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      changedBy: changedBy ?? this.changedBy,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transportId.present) {
      map['transport_id'] = Variable<String>(transportId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (changedBy.present) {
      map['changed_by'] = Variable<String>(changedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransportStatusHistoryCompanion(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('status: $status, ')
          ..write('remarks: $remarks, ')
          ..write('changedBy: $changedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalVehicleAssignmentsTable extends LocalVehicleAssignments
    with TableInfo<$LocalVehicleAssignmentsTable, LocalVehicleAssignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVehicleAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportIdMeta = const VerificationMeta(
    'transportId',
  );
  @override
  late final GeneratedColumn<String> transportId = GeneratedColumn<String>(
    'transport_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignedAtMeta = const VerificationMeta(
    'assignedAt',
  );
  @override
  late final GeneratedColumn<DateTime> assignedAt = GeneratedColumn<DateTime>(
    'assigned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignedByMeta = const VerificationMeta(
    'assignedBy',
  );
  @override
  late final GeneratedColumn<String> assignedBy = GeneratedColumn<String>(
    'assigned_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Super Admin'),
  );
  static const VerificationMeta _releasedAtMeta = const VerificationMeta(
    'releasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> releasedAt = GeneratedColumn<DateTime>(
    'released_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transportId,
    vehicleId,
    assignedAt,
    assignedBy,
    releasedAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_vehicle_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVehicleAssignment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transport_id')) {
      context.handle(
        _transportIdMeta,
        transportId.isAcceptableOrUnknown(
          data['transport_id']!,
          _transportIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transportIdMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('assigned_at')) {
      context.handle(
        _assignedAtMeta,
        assignedAt.isAcceptableOrUnknown(data['assigned_at']!, _assignedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_assignedAtMeta);
    }
    if (data.containsKey('assigned_by')) {
      context.handle(
        _assignedByMeta,
        assignedBy.isAcceptableOrUnknown(data['assigned_by']!, _assignedByMeta),
      );
    }
    if (data.containsKey('released_at')) {
      context.handle(
        _releasedAtMeta,
        releasedAt.isAcceptableOrUnknown(data['released_at']!, _releasedAtMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalVehicleAssignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVehicleAssignment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport_id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      assignedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}assigned_at'],
      )!,
      assignedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_by'],
      )!,
      releasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}released_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $LocalVehicleAssignmentsTable createAlias(String alias) {
    return $LocalVehicleAssignmentsTable(attachedDatabase, alias);
  }
}

class LocalVehicleAssignment extends DataClass
    implements Insertable<LocalVehicleAssignment> {
  final String id;
  final String transportId;
  final String vehicleId;
  final DateTime assignedAt;
  final String assignedBy;
  final DateTime? releasedAt;
  final bool isActive;
  const LocalVehicleAssignment({
    required this.id,
    required this.transportId,
    required this.vehicleId,
    required this.assignedAt,
    required this.assignedBy,
    this.releasedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transport_id'] = Variable<String>(transportId);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['assigned_at'] = Variable<DateTime>(assignedAt);
    map['assigned_by'] = Variable<String>(assignedBy);
    if (!nullToAbsent || releasedAt != null) {
      map['released_at'] = Variable<DateTime>(releasedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  LocalVehicleAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return LocalVehicleAssignmentsCompanion(
      id: Value(id),
      transportId: Value(transportId),
      vehicleId: Value(vehicleId),
      assignedAt: Value(assignedAt),
      assignedBy: Value(assignedBy),
      releasedAt: releasedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(releasedAt),
      isActive: Value(isActive),
    );
  }

  factory LocalVehicleAssignment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVehicleAssignment(
      id: serializer.fromJson<String>(json['id']),
      transportId: serializer.fromJson<String>(json['transportId']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      assignedAt: serializer.fromJson<DateTime>(json['assignedAt']),
      assignedBy: serializer.fromJson<String>(json['assignedBy']),
      releasedAt: serializer.fromJson<DateTime?>(json['releasedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transportId': serializer.toJson<String>(transportId),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'assignedAt': serializer.toJson<DateTime>(assignedAt),
      'assignedBy': serializer.toJson<String>(assignedBy),
      'releasedAt': serializer.toJson<DateTime?>(releasedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  LocalVehicleAssignment copyWith({
    String? id,
    String? transportId,
    String? vehicleId,
    DateTime? assignedAt,
    String? assignedBy,
    Value<DateTime?> releasedAt = const Value.absent(),
    bool? isActive,
  }) => LocalVehicleAssignment(
    id: id ?? this.id,
    transportId: transportId ?? this.transportId,
    vehicleId: vehicleId ?? this.vehicleId,
    assignedAt: assignedAt ?? this.assignedAt,
    assignedBy: assignedBy ?? this.assignedBy,
    releasedAt: releasedAt.present ? releasedAt.value : this.releasedAt,
    isActive: isActive ?? this.isActive,
  );
  LocalVehicleAssignment copyWithCompanion(
    LocalVehicleAssignmentsCompanion data,
  ) {
    return LocalVehicleAssignment(
      id: data.id.present ? data.id.value : this.id,
      transportId: data.transportId.present
          ? data.transportId.value
          : this.transportId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      assignedAt: data.assignedAt.present
          ? data.assignedAt.value
          : this.assignedAt,
      assignedBy: data.assignedBy.present
          ? data.assignedBy.value
          : this.assignedBy,
      releasedAt: data.releasedAt.present
          ? data.releasedAt.value
          : this.releasedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVehicleAssignment(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('assignedAt: $assignedAt, ')
          ..write('assignedBy: $assignedBy, ')
          ..write('releasedAt: $releasedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transportId,
    vehicleId,
    assignedAt,
    assignedBy,
    releasedAt,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVehicleAssignment &&
          other.id == this.id &&
          other.transportId == this.transportId &&
          other.vehicleId == this.vehicleId &&
          other.assignedAt == this.assignedAt &&
          other.assignedBy == this.assignedBy &&
          other.releasedAt == this.releasedAt &&
          other.isActive == this.isActive);
}

class LocalVehicleAssignmentsCompanion
    extends UpdateCompanion<LocalVehicleAssignment> {
  final Value<String> id;
  final Value<String> transportId;
  final Value<String> vehicleId;
  final Value<DateTime> assignedAt;
  final Value<String> assignedBy;
  final Value<DateTime?> releasedAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const LocalVehicleAssignmentsCompanion({
    this.id = const Value.absent(),
    this.transportId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.assignedAt = const Value.absent(),
    this.assignedBy = const Value.absent(),
    this.releasedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVehicleAssignmentsCompanion.insert({
    required String id,
    required String transportId,
    required String vehicleId,
    required DateTime assignedAt,
    this.assignedBy = const Value.absent(),
    this.releasedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transportId = Value(transportId),
       vehicleId = Value(vehicleId),
       assignedAt = Value(assignedAt);
  static Insertable<LocalVehicleAssignment> custom({
    Expression<String>? id,
    Expression<String>? transportId,
    Expression<String>? vehicleId,
    Expression<DateTime>? assignedAt,
    Expression<String>? assignedBy,
    Expression<DateTime>? releasedAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transportId != null) 'transport_id': transportId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (assignedAt != null) 'assigned_at': assignedAt,
      if (assignedBy != null) 'assigned_by': assignedBy,
      if (releasedAt != null) 'released_at': releasedAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVehicleAssignmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? transportId,
    Value<String>? vehicleId,
    Value<DateTime>? assignedAt,
    Value<String>? assignedBy,
    Value<DateTime?>? releasedAt,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return LocalVehicleAssignmentsCompanion(
      id: id ?? this.id,
      transportId: transportId ?? this.transportId,
      vehicleId: vehicleId ?? this.vehicleId,
      assignedAt: assignedAt ?? this.assignedAt,
      assignedBy: assignedBy ?? this.assignedBy,
      releasedAt: releasedAt ?? this.releasedAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transportId.present) {
      map['transport_id'] = Variable<String>(transportId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (assignedAt.present) {
      map['assigned_at'] = Variable<DateTime>(assignedAt.value);
    }
    if (assignedBy.present) {
      map['assigned_by'] = Variable<String>(assignedBy.value);
    }
    if (releasedAt.present) {
      map['released_at'] = Variable<DateTime>(releasedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVehicleAssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('assignedAt: $assignedAt, ')
          ..write('assignedBy: $assignedBy, ')
          ..write('releasedAt: $releasedAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDriverAssignmentsTable extends LocalDriverAssignments
    with TableInfo<$LocalDriverAssignmentsTable, LocalDriverAssignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDriverAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportIdMeta = const VerificationMeta(
    'transportId',
  );
  @override
  late final GeneratedColumn<String> transportId = GeneratedColumn<String>(
    'transport_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _driverIdMeta = const VerificationMeta(
    'driverId',
  );
  @override
  late final GeneratedColumn<String> driverId = GeneratedColumn<String>(
    'driver_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignedAtMeta = const VerificationMeta(
    'assignedAt',
  );
  @override
  late final GeneratedColumn<DateTime> assignedAt = GeneratedColumn<DateTime>(
    'assigned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignedByMeta = const VerificationMeta(
    'assignedBy',
  );
  @override
  late final GeneratedColumn<String> assignedBy = GeneratedColumn<String>(
    'assigned_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Super Admin'),
  );
  static const VerificationMeta _releasedAtMeta = const VerificationMeta(
    'releasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> releasedAt = GeneratedColumn<DateTime>(
    'released_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transportId,
    driverId,
    assignedAt,
    assignedBy,
    releasedAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_driver_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalDriverAssignment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transport_id')) {
      context.handle(
        _transportIdMeta,
        transportId.isAcceptableOrUnknown(
          data['transport_id']!,
          _transportIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transportIdMeta);
    }
    if (data.containsKey('driver_id')) {
      context.handle(
        _driverIdMeta,
        driverId.isAcceptableOrUnknown(data['driver_id']!, _driverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_driverIdMeta);
    }
    if (data.containsKey('assigned_at')) {
      context.handle(
        _assignedAtMeta,
        assignedAt.isAcceptableOrUnknown(data['assigned_at']!, _assignedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_assignedAtMeta);
    }
    if (data.containsKey('assigned_by')) {
      context.handle(
        _assignedByMeta,
        assignedBy.isAcceptableOrUnknown(data['assigned_by']!, _assignedByMeta),
      );
    }
    if (data.containsKey('released_at')) {
      context.handle(
        _releasedAtMeta,
        releasedAt.isAcceptableOrUnknown(data['released_at']!, _releasedAtMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalDriverAssignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDriverAssignment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport_id'],
      )!,
      driverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver_id'],
      )!,
      assignedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}assigned_at'],
      )!,
      assignedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_by'],
      )!,
      releasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}released_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $LocalDriverAssignmentsTable createAlias(String alias) {
    return $LocalDriverAssignmentsTable(attachedDatabase, alias);
  }
}

class LocalDriverAssignment extends DataClass
    implements Insertable<LocalDriverAssignment> {
  final String id;
  final String transportId;
  final String driverId;
  final DateTime assignedAt;
  final String assignedBy;
  final DateTime? releasedAt;
  final bool isActive;
  const LocalDriverAssignment({
    required this.id,
    required this.transportId,
    required this.driverId,
    required this.assignedAt,
    required this.assignedBy,
    this.releasedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transport_id'] = Variable<String>(transportId);
    map['driver_id'] = Variable<String>(driverId);
    map['assigned_at'] = Variable<DateTime>(assignedAt);
    map['assigned_by'] = Variable<String>(assignedBy);
    if (!nullToAbsent || releasedAt != null) {
      map['released_at'] = Variable<DateTime>(releasedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  LocalDriverAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return LocalDriverAssignmentsCompanion(
      id: Value(id),
      transportId: Value(transportId),
      driverId: Value(driverId),
      assignedAt: Value(assignedAt),
      assignedBy: Value(assignedBy),
      releasedAt: releasedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(releasedAt),
      isActive: Value(isActive),
    );
  }

  factory LocalDriverAssignment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDriverAssignment(
      id: serializer.fromJson<String>(json['id']),
      transportId: serializer.fromJson<String>(json['transportId']),
      driverId: serializer.fromJson<String>(json['driverId']),
      assignedAt: serializer.fromJson<DateTime>(json['assignedAt']),
      assignedBy: serializer.fromJson<String>(json['assignedBy']),
      releasedAt: serializer.fromJson<DateTime?>(json['releasedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transportId': serializer.toJson<String>(transportId),
      'driverId': serializer.toJson<String>(driverId),
      'assignedAt': serializer.toJson<DateTime>(assignedAt),
      'assignedBy': serializer.toJson<String>(assignedBy),
      'releasedAt': serializer.toJson<DateTime?>(releasedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  LocalDriverAssignment copyWith({
    String? id,
    String? transportId,
    String? driverId,
    DateTime? assignedAt,
    String? assignedBy,
    Value<DateTime?> releasedAt = const Value.absent(),
    bool? isActive,
  }) => LocalDriverAssignment(
    id: id ?? this.id,
    transportId: transportId ?? this.transportId,
    driverId: driverId ?? this.driverId,
    assignedAt: assignedAt ?? this.assignedAt,
    assignedBy: assignedBy ?? this.assignedBy,
    releasedAt: releasedAt.present ? releasedAt.value : this.releasedAt,
    isActive: isActive ?? this.isActive,
  );
  LocalDriverAssignment copyWithCompanion(
    LocalDriverAssignmentsCompanion data,
  ) {
    return LocalDriverAssignment(
      id: data.id.present ? data.id.value : this.id,
      transportId: data.transportId.present
          ? data.transportId.value
          : this.transportId,
      driverId: data.driverId.present ? data.driverId.value : this.driverId,
      assignedAt: data.assignedAt.present
          ? data.assignedAt.value
          : this.assignedAt,
      assignedBy: data.assignedBy.present
          ? data.assignedBy.value
          : this.assignedBy,
      releasedAt: data.releasedAt.present
          ? data.releasedAt.value
          : this.releasedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDriverAssignment(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('driverId: $driverId, ')
          ..write('assignedAt: $assignedAt, ')
          ..write('assignedBy: $assignedBy, ')
          ..write('releasedAt: $releasedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transportId,
    driverId,
    assignedAt,
    assignedBy,
    releasedAt,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDriverAssignment &&
          other.id == this.id &&
          other.transportId == this.transportId &&
          other.driverId == this.driverId &&
          other.assignedAt == this.assignedAt &&
          other.assignedBy == this.assignedBy &&
          other.releasedAt == this.releasedAt &&
          other.isActive == this.isActive);
}

class LocalDriverAssignmentsCompanion
    extends UpdateCompanion<LocalDriverAssignment> {
  final Value<String> id;
  final Value<String> transportId;
  final Value<String> driverId;
  final Value<DateTime> assignedAt;
  final Value<String> assignedBy;
  final Value<DateTime?> releasedAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const LocalDriverAssignmentsCompanion({
    this.id = const Value.absent(),
    this.transportId = const Value.absent(),
    this.driverId = const Value.absent(),
    this.assignedAt = const Value.absent(),
    this.assignedBy = const Value.absent(),
    this.releasedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDriverAssignmentsCompanion.insert({
    required String id,
    required String transportId,
    required String driverId,
    required DateTime assignedAt,
    this.assignedBy = const Value.absent(),
    this.releasedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transportId = Value(transportId),
       driverId = Value(driverId),
       assignedAt = Value(assignedAt);
  static Insertable<LocalDriverAssignment> custom({
    Expression<String>? id,
    Expression<String>? transportId,
    Expression<String>? driverId,
    Expression<DateTime>? assignedAt,
    Expression<String>? assignedBy,
    Expression<DateTime>? releasedAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transportId != null) 'transport_id': transportId,
      if (driverId != null) 'driver_id': driverId,
      if (assignedAt != null) 'assigned_at': assignedAt,
      if (assignedBy != null) 'assigned_by': assignedBy,
      if (releasedAt != null) 'released_at': releasedAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDriverAssignmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? transportId,
    Value<String>? driverId,
    Value<DateTime>? assignedAt,
    Value<String>? assignedBy,
    Value<DateTime?>? releasedAt,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return LocalDriverAssignmentsCompanion(
      id: id ?? this.id,
      transportId: transportId ?? this.transportId,
      driverId: driverId ?? this.driverId,
      assignedAt: assignedAt ?? this.assignedAt,
      assignedBy: assignedBy ?? this.assignedBy,
      releasedAt: releasedAt ?? this.releasedAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transportId.present) {
      map['transport_id'] = Variable<String>(transportId.value);
    }
    if (driverId.present) {
      map['driver_id'] = Variable<String>(driverId.value);
    }
    if (assignedAt.present) {
      map['assigned_at'] = Variable<DateTime>(assignedAt.value);
    }
    if (assignedBy.present) {
      map['assigned_by'] = Variable<String>(assignedBy.value);
    }
    if (releasedAt.present) {
      map['released_at'] = Variable<DateTime>(releasedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDriverAssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('driverId: $driverId, ')
          ..write('assignedAt: $assignedAt, ')
          ..write('assignedBy: $assignedBy, ')
          ..write('releasedAt: $releasedAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalNotificationLogsTable extends LocalNotificationLogs
    with TableInfo<$LocalNotificationLogsTable, LocalNotificationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalNotificationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportIdMeta = const VerificationMeta(
    'transportId',
  );
  @override
  late final GeneratedColumn<String> transportId = GeneratedColumn<String>(
    'transport_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyIdMeta = const VerificationMeta(
    'partyId',
  );
  @override
  late final GeneratedColumn<String> partyId = GeneratedColumn<String>(
    'party_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recipientNameMeta = const VerificationMeta(
    'recipientName',
  );
  @override
  late final GeneratedColumn<String> recipientName = GeneratedColumn<String>(
    'recipient_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipientMobileMeta = const VerificationMeta(
    'recipientMobile',
  );
  @override
  late final GeneratedColumn<String> recipientMobile = GeneratedColumn<String>(
    'recipient_mobile',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelMeta = const VerificationMeta(
    'channel',
  );
  @override
  late final GeneratedColumn<String> channel = GeneratedColumn<String>(
    'channel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('WhatsApp'),
  );
  static const VerificationMeta _messageBodyMeta = const VerificationMeta(
    'messageBody',
  );
  @override
  late final GeneratedColumn<String> messageBody = GeneratedColumn<String>(
    'message_body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('READY'),
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transportId,
    partyId,
    recipientName,
    recipientMobile,
    channel,
    messageBody,
    status,
    sentAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_notification_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalNotificationLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transport_id')) {
      context.handle(
        _transportIdMeta,
        transportId.isAcceptableOrUnknown(
          data['transport_id']!,
          _transportIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transportIdMeta);
    }
    if (data.containsKey('party_id')) {
      context.handle(
        _partyIdMeta,
        partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta),
      );
    }
    if (data.containsKey('recipient_name')) {
      context.handle(
        _recipientNameMeta,
        recipientName.isAcceptableOrUnknown(
          data['recipient_name']!,
          _recipientNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientNameMeta);
    }
    if (data.containsKey('recipient_mobile')) {
      context.handle(
        _recipientMobileMeta,
        recipientMobile.isAcceptableOrUnknown(
          data['recipient_mobile']!,
          _recipientMobileMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientMobileMeta);
    }
    if (data.containsKey('channel')) {
      context.handle(
        _channelMeta,
        channel.isAcceptableOrUnknown(data['channel']!, _channelMeta),
      );
    }
    if (data.containsKey('message_body')) {
      context.handle(
        _messageBodyMeta,
        messageBody.isAcceptableOrUnknown(
          data['message_body']!,
          _messageBodyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_messageBodyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalNotificationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalNotificationLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport_id'],
      )!,
      partyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_id'],
      ),
      recipientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_name'],
      )!,
      recipientMobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_mobile'],
      )!,
      channel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel'],
      )!,
      messageBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_body'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalNotificationLogsTable createAlias(String alias) {
    return $LocalNotificationLogsTable(attachedDatabase, alias);
  }
}

class LocalNotificationLog extends DataClass
    implements Insertable<LocalNotificationLog> {
  final String id;
  final String transportId;
  final String? partyId;
  final String recipientName;
  final String recipientMobile;
  final String channel;
  final String messageBody;
  final String status;
  final DateTime sentAt;
  final DateTime createdAt;
  const LocalNotificationLog({
    required this.id,
    required this.transportId,
    this.partyId,
    required this.recipientName,
    required this.recipientMobile,
    required this.channel,
    required this.messageBody,
    required this.status,
    required this.sentAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transport_id'] = Variable<String>(transportId);
    if (!nullToAbsent || partyId != null) {
      map['party_id'] = Variable<String>(partyId);
    }
    map['recipient_name'] = Variable<String>(recipientName);
    map['recipient_mobile'] = Variable<String>(recipientMobile);
    map['channel'] = Variable<String>(channel);
    map['message_body'] = Variable<String>(messageBody);
    map['status'] = Variable<String>(status);
    map['sent_at'] = Variable<DateTime>(sentAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalNotificationLogsCompanion toCompanion(bool nullToAbsent) {
    return LocalNotificationLogsCompanion(
      id: Value(id),
      transportId: Value(transportId),
      partyId: partyId == null && nullToAbsent
          ? const Value.absent()
          : Value(partyId),
      recipientName: Value(recipientName),
      recipientMobile: Value(recipientMobile),
      channel: Value(channel),
      messageBody: Value(messageBody),
      status: Value(status),
      sentAt: Value(sentAt),
      createdAt: Value(createdAt),
    );
  }

  factory LocalNotificationLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalNotificationLog(
      id: serializer.fromJson<String>(json['id']),
      transportId: serializer.fromJson<String>(json['transportId']),
      partyId: serializer.fromJson<String?>(json['partyId']),
      recipientName: serializer.fromJson<String>(json['recipientName']),
      recipientMobile: serializer.fromJson<String>(json['recipientMobile']),
      channel: serializer.fromJson<String>(json['channel']),
      messageBody: serializer.fromJson<String>(json['messageBody']),
      status: serializer.fromJson<String>(json['status']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transportId': serializer.toJson<String>(transportId),
      'partyId': serializer.toJson<String?>(partyId),
      'recipientName': serializer.toJson<String>(recipientName),
      'recipientMobile': serializer.toJson<String>(recipientMobile),
      'channel': serializer.toJson<String>(channel),
      'messageBody': serializer.toJson<String>(messageBody),
      'status': serializer.toJson<String>(status),
      'sentAt': serializer.toJson<DateTime>(sentAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalNotificationLog copyWith({
    String? id,
    String? transportId,
    Value<String?> partyId = const Value.absent(),
    String? recipientName,
    String? recipientMobile,
    String? channel,
    String? messageBody,
    String? status,
    DateTime? sentAt,
    DateTime? createdAt,
  }) => LocalNotificationLog(
    id: id ?? this.id,
    transportId: transportId ?? this.transportId,
    partyId: partyId.present ? partyId.value : this.partyId,
    recipientName: recipientName ?? this.recipientName,
    recipientMobile: recipientMobile ?? this.recipientMobile,
    channel: channel ?? this.channel,
    messageBody: messageBody ?? this.messageBody,
    status: status ?? this.status,
    sentAt: sentAt ?? this.sentAt,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalNotificationLog copyWithCompanion(LocalNotificationLogsCompanion data) {
    return LocalNotificationLog(
      id: data.id.present ? data.id.value : this.id,
      transportId: data.transportId.present
          ? data.transportId.value
          : this.transportId,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      recipientName: data.recipientName.present
          ? data.recipientName.value
          : this.recipientName,
      recipientMobile: data.recipientMobile.present
          ? data.recipientMobile.value
          : this.recipientMobile,
      channel: data.channel.present ? data.channel.value : this.channel,
      messageBody: data.messageBody.present
          ? data.messageBody.value
          : this.messageBody,
      status: data.status.present ? data.status.value : this.status,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalNotificationLog(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('partyId: $partyId, ')
          ..write('recipientName: $recipientName, ')
          ..write('recipientMobile: $recipientMobile, ')
          ..write('channel: $channel, ')
          ..write('messageBody: $messageBody, ')
          ..write('status: $status, ')
          ..write('sentAt: $sentAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transportId,
    partyId,
    recipientName,
    recipientMobile,
    channel,
    messageBody,
    status,
    sentAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalNotificationLog &&
          other.id == this.id &&
          other.transportId == this.transportId &&
          other.partyId == this.partyId &&
          other.recipientName == this.recipientName &&
          other.recipientMobile == this.recipientMobile &&
          other.channel == this.channel &&
          other.messageBody == this.messageBody &&
          other.status == this.status &&
          other.sentAt == this.sentAt &&
          other.createdAt == this.createdAt);
}

class LocalNotificationLogsCompanion
    extends UpdateCompanion<LocalNotificationLog> {
  final Value<String> id;
  final Value<String> transportId;
  final Value<String?> partyId;
  final Value<String> recipientName;
  final Value<String> recipientMobile;
  final Value<String> channel;
  final Value<String> messageBody;
  final Value<String> status;
  final Value<DateTime> sentAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalNotificationLogsCompanion({
    this.id = const Value.absent(),
    this.transportId = const Value.absent(),
    this.partyId = const Value.absent(),
    this.recipientName = const Value.absent(),
    this.recipientMobile = const Value.absent(),
    this.channel = const Value.absent(),
    this.messageBody = const Value.absent(),
    this.status = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalNotificationLogsCompanion.insert({
    required String id,
    required String transportId,
    this.partyId = const Value.absent(),
    required String recipientName,
    required String recipientMobile,
    this.channel = const Value.absent(),
    required String messageBody,
    this.status = const Value.absent(),
    required DateTime sentAt,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transportId = Value(transportId),
       recipientName = Value(recipientName),
       recipientMobile = Value(recipientMobile),
       messageBody = Value(messageBody),
       sentAt = Value(sentAt);
  static Insertable<LocalNotificationLog> custom({
    Expression<String>? id,
    Expression<String>? transportId,
    Expression<String>? partyId,
    Expression<String>? recipientName,
    Expression<String>? recipientMobile,
    Expression<String>? channel,
    Expression<String>? messageBody,
    Expression<String>? status,
    Expression<DateTime>? sentAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transportId != null) 'transport_id': transportId,
      if (partyId != null) 'party_id': partyId,
      if (recipientName != null) 'recipient_name': recipientName,
      if (recipientMobile != null) 'recipient_mobile': recipientMobile,
      if (channel != null) 'channel': channel,
      if (messageBody != null) 'message_body': messageBody,
      if (status != null) 'status': status,
      if (sentAt != null) 'sent_at': sentAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalNotificationLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? transportId,
    Value<String?>? partyId,
    Value<String>? recipientName,
    Value<String>? recipientMobile,
    Value<String>? channel,
    Value<String>? messageBody,
    Value<String>? status,
    Value<DateTime>? sentAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalNotificationLogsCompanion(
      id: id ?? this.id,
      transportId: transportId ?? this.transportId,
      partyId: partyId ?? this.partyId,
      recipientName: recipientName ?? this.recipientName,
      recipientMobile: recipientMobile ?? this.recipientMobile,
      channel: channel ?? this.channel,
      messageBody: messageBody ?? this.messageBody,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transportId.present) {
      map['transport_id'] = Variable<String>(transportId.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<String>(partyId.value);
    }
    if (recipientName.present) {
      map['recipient_name'] = Variable<String>(recipientName.value);
    }
    if (recipientMobile.present) {
      map['recipient_mobile'] = Variable<String>(recipientMobile.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(channel.value);
    }
    if (messageBody.present) {
      map['message_body'] = Variable<String>(messageBody.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalNotificationLogsCompanion(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('partyId: $partyId, ')
          ..write('recipientName: $recipientName, ')
          ..write('recipientMobile: $recipientMobile, ')
          ..write('channel: $channel, ')
          ..write('messageBody: $messageBody, ')
          ..write('status: $status, ')
          ..write('sentAt: $sentAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPodDocumentsTable extends LocalPodDocuments
    with TableInfo<$LocalPodDocumentsTable, LocalPodDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPodDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportIdMeta = const VerificationMeta(
    'transportId',
  );
  @override
  late final GeneratedColumn<String> transportId = GeneratedColumn<String>(
    'transport_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storagePathMeta = const VerificationMeta(
    'storagePath',
  );
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
    'storage_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<BigInt> fileSize = GeneratedColumn<BigInt>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedByMeta = const VerificationMeta(
    'uploadedBy',
  );
  @override
  late final GeneratedColumn<String> uploadedBy = GeneratedColumn<String>(
    'uploaded_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Super Admin'),
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
    'uploaded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileUrlMeta = const VerificationMeta(
    'fileUrl',
  );
  @override
  late final GeneratedColumn<String> fileUrl = GeneratedColumn<String>(
    'file_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localFilePathMeta = const VerificationMeta(
    'localFilePath',
  );
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transportId,
    fileName,
    storagePath,
    fileType,
    fileSize,
    uploadedBy,
    uploadedAt,
    fileUrl,
    localFilePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_pod_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPodDocument> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transport_id')) {
      context.handle(
        _transportIdMeta,
        transportId.isAcceptableOrUnknown(
          data['transport_id']!,
          _transportIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transportIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('storage_path')) {
      context.handle(
        _storagePathMeta,
        storagePath.isAcceptableOrUnknown(
          data['storage_path']!,
          _storagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_storagePathMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('uploaded_by')) {
      context.handle(
        _uploadedByMeta,
        uploadedBy.isAcceptableOrUnknown(data['uploaded_by']!, _uploadedByMeta),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_uploadedAtMeta);
    }
    if (data.containsKey('file_url')) {
      context.handle(
        _fileUrlMeta,
        fileUrl.isAcceptableOrUnknown(data['file_url']!, _fileUrlMeta),
      );
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _localFilePathMeta,
        localFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _localFilePathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPodDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPodDocument(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport_id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      storagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_path'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}file_size'],
      )!,
      uploadedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uploaded_by'],
      )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}uploaded_at'],
      )!,
      fileUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_url'],
      ),
      localFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      ),
    );
  }

  @override
  $LocalPodDocumentsTable createAlias(String alias) {
    return $LocalPodDocumentsTable(attachedDatabase, alias);
  }
}

class LocalPodDocument extends DataClass
    implements Insertable<LocalPodDocument> {
  final String id;
  final String transportId;
  final String fileName;
  final String storagePath;
  final String fileType;
  final BigInt fileSize;
  final String uploadedBy;
  final DateTime uploadedAt;
  final String? fileUrl;
  final String? localFilePath;
  const LocalPodDocument({
    required this.id,
    required this.transportId,
    required this.fileName,
    required this.storagePath,
    required this.fileType,
    required this.fileSize,
    required this.uploadedBy,
    required this.uploadedAt,
    this.fileUrl,
    this.localFilePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transport_id'] = Variable<String>(transportId);
    map['file_name'] = Variable<String>(fileName);
    map['storage_path'] = Variable<String>(storagePath);
    map['file_type'] = Variable<String>(fileType);
    map['file_size'] = Variable<BigInt>(fileSize);
    map['uploaded_by'] = Variable<String>(uploadedBy);
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    if (!nullToAbsent || fileUrl != null) {
      map['file_url'] = Variable<String>(fileUrl);
    }
    if (!nullToAbsent || localFilePath != null) {
      map['local_file_path'] = Variable<String>(localFilePath);
    }
    return map;
  }

  LocalPodDocumentsCompanion toCompanion(bool nullToAbsent) {
    return LocalPodDocumentsCompanion(
      id: Value(id),
      transportId: Value(transportId),
      fileName: Value(fileName),
      storagePath: Value(storagePath),
      fileType: Value(fileType),
      fileSize: Value(fileSize),
      uploadedBy: Value(uploadedBy),
      uploadedAt: Value(uploadedAt),
      fileUrl: fileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fileUrl),
      localFilePath: localFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(localFilePath),
    );
  }

  factory LocalPodDocument.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPodDocument(
      id: serializer.fromJson<String>(json['id']),
      transportId: serializer.fromJson<String>(json['transportId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      storagePath: serializer.fromJson<String>(json['storagePath']),
      fileType: serializer.fromJson<String>(json['fileType']),
      fileSize: serializer.fromJson<BigInt>(json['fileSize']),
      uploadedBy: serializer.fromJson<String>(json['uploadedBy']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
      fileUrl: serializer.fromJson<String?>(json['fileUrl']),
      localFilePath: serializer.fromJson<String?>(json['localFilePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transportId': serializer.toJson<String>(transportId),
      'fileName': serializer.toJson<String>(fileName),
      'storagePath': serializer.toJson<String>(storagePath),
      'fileType': serializer.toJson<String>(fileType),
      'fileSize': serializer.toJson<BigInt>(fileSize),
      'uploadedBy': serializer.toJson<String>(uploadedBy),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
      'fileUrl': serializer.toJson<String?>(fileUrl),
      'localFilePath': serializer.toJson<String?>(localFilePath),
    };
  }

  LocalPodDocument copyWith({
    String? id,
    String? transportId,
    String? fileName,
    String? storagePath,
    String? fileType,
    BigInt? fileSize,
    String? uploadedBy,
    DateTime? uploadedAt,
    Value<String?> fileUrl = const Value.absent(),
    Value<String?> localFilePath = const Value.absent(),
  }) => LocalPodDocument(
    id: id ?? this.id,
    transportId: transportId ?? this.transportId,
    fileName: fileName ?? this.fileName,
    storagePath: storagePath ?? this.storagePath,
    fileType: fileType ?? this.fileType,
    fileSize: fileSize ?? this.fileSize,
    uploadedBy: uploadedBy ?? this.uploadedBy,
    uploadedAt: uploadedAt ?? this.uploadedAt,
    fileUrl: fileUrl.present ? fileUrl.value : this.fileUrl,
    localFilePath: localFilePath.present
        ? localFilePath.value
        : this.localFilePath,
  );
  LocalPodDocument copyWithCompanion(LocalPodDocumentsCompanion data) {
    return LocalPodDocument(
      id: data.id.present ? data.id.value : this.id,
      transportId: data.transportId.present
          ? data.transportId.value
          : this.transportId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      storagePath: data.storagePath.present
          ? data.storagePath.value
          : this.storagePath,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      uploadedBy: data.uploadedBy.present
          ? data.uploadedBy.value
          : this.uploadedBy,
      uploadedAt: data.uploadedAt.present
          ? data.uploadedAt.value
          : this.uploadedAt,
      fileUrl: data.fileUrl.present ? data.fileUrl.value : this.fileUrl,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPodDocument(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('fileName: $fileName, ')
          ..write('storagePath: $storagePath, ')
          ..write('fileType: $fileType, ')
          ..write('fileSize: $fileSize, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('localFilePath: $localFilePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transportId,
    fileName,
    storagePath,
    fileType,
    fileSize,
    uploadedBy,
    uploadedAt,
    fileUrl,
    localFilePath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPodDocument &&
          other.id == this.id &&
          other.transportId == this.transportId &&
          other.fileName == this.fileName &&
          other.storagePath == this.storagePath &&
          other.fileType == this.fileType &&
          other.fileSize == this.fileSize &&
          other.uploadedBy == this.uploadedBy &&
          other.uploadedAt == this.uploadedAt &&
          other.fileUrl == this.fileUrl &&
          other.localFilePath == this.localFilePath);
}

class LocalPodDocumentsCompanion extends UpdateCompanion<LocalPodDocument> {
  final Value<String> id;
  final Value<String> transportId;
  final Value<String> fileName;
  final Value<String> storagePath;
  final Value<String> fileType;
  final Value<BigInt> fileSize;
  final Value<String> uploadedBy;
  final Value<DateTime> uploadedAt;
  final Value<String?> fileUrl;
  final Value<String?> localFilePath;
  final Value<int> rowid;
  const LocalPodDocumentsCompanion({
    this.id = const Value.absent(),
    this.transportId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.fileType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.uploadedBy = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPodDocumentsCompanion.insert({
    required String id,
    required String transportId,
    required String fileName,
    required String storagePath,
    required String fileType,
    required BigInt fileSize,
    this.uploadedBy = const Value.absent(),
    required DateTime uploadedAt,
    this.fileUrl = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transportId = Value(transportId),
       fileName = Value(fileName),
       storagePath = Value(storagePath),
       fileType = Value(fileType),
       fileSize = Value(fileSize),
       uploadedAt = Value(uploadedAt);
  static Insertable<LocalPodDocument> custom({
    Expression<String>? id,
    Expression<String>? transportId,
    Expression<String>? fileName,
    Expression<String>? storagePath,
    Expression<String>? fileType,
    Expression<BigInt>? fileSize,
    Expression<String>? uploadedBy,
    Expression<DateTime>? uploadedAt,
    Expression<String>? fileUrl,
    Expression<String>? localFilePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transportId != null) 'transport_id': transportId,
      if (fileName != null) 'file_name': fileName,
      if (storagePath != null) 'storage_path': storagePath,
      if (fileType != null) 'file_type': fileType,
      if (fileSize != null) 'file_size': fileSize,
      if (uploadedBy != null) 'uploaded_by': uploadedBy,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (fileUrl != null) 'file_url': fileUrl,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPodDocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? transportId,
    Value<String>? fileName,
    Value<String>? storagePath,
    Value<String>? fileType,
    Value<BigInt>? fileSize,
    Value<String>? uploadedBy,
    Value<DateTime>? uploadedAt,
    Value<String?>? fileUrl,
    Value<String?>? localFilePath,
    Value<int>? rowid,
  }) {
    return LocalPodDocumentsCompanion(
      id: id ?? this.id,
      transportId: transportId ?? this.transportId,
      fileName: fileName ?? this.fileName,
      storagePath: storagePath ?? this.storagePath,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      fileUrl: fileUrl ?? this.fileUrl,
      localFilePath: localFilePath ?? this.localFilePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transportId.present) {
      map['transport_id'] = Variable<String>(transportId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<BigInt>(fileSize.value);
    }
    if (uploadedBy.present) {
      map['uploaded_by'] = Variable<String>(uploadedBy.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    if (fileUrl.present) {
      map['file_url'] = Variable<String>(fileUrl.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPodDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('fileName: $fileName, ')
          ..write('storagePath: $storagePath, ')
          ..write('fileType: $fileType, ')
          ..write('fileSize: $fileSize, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalActivityLogsTable extends LocalActivityLogs
    with TableInfo<$LocalActivityLogsTable, LocalActivityLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalActivityLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportIdMeta = const VerificationMeta(
    'transportId',
  );
  @override
  late final GeneratedColumn<String> transportId = GeneratedColumn<String>(
    'transport_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transportId,
    userId,
    action,
    description,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_activity_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalActivityLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transport_id')) {
      context.handle(
        _transportIdMeta,
        transportId.isAcceptableOrUnknown(
          data['transport_id']!,
          _transportIdMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalActivityLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalActivityLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport_id'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalActivityLogsTable createAlias(String alias) {
    return $LocalActivityLogsTable(attachedDatabase, alias);
  }
}

class LocalActivityLog extends DataClass
    implements Insertable<LocalActivityLog> {
  final String id;
  final String? transportId;
  final String? userId;
  final String action;
  final String description;
  final DateTime createdAt;
  const LocalActivityLog({
    required this.id,
    this.transportId,
    this.userId,
    required this.action,
    required this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || transportId != null) {
      map['transport_id'] = Variable<String>(transportId);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['action'] = Variable<String>(action);
    map['description'] = Variable<String>(description);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalActivityLogsCompanion toCompanion(bool nullToAbsent) {
    return LocalActivityLogsCompanion(
      id: Value(id),
      transportId: transportId == null && nullToAbsent
          ? const Value.absent()
          : Value(transportId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      action: Value(action),
      description: Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory LocalActivityLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalActivityLog(
      id: serializer.fromJson<String>(json['id']),
      transportId: serializer.fromJson<String?>(json['transportId']),
      userId: serializer.fromJson<String?>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transportId': serializer.toJson<String?>(transportId),
      'userId': serializer.toJson<String?>(userId),
      'action': serializer.toJson<String>(action),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalActivityLog copyWith({
    String? id,
    Value<String?> transportId = const Value.absent(),
    Value<String?> userId = const Value.absent(),
    String? action,
    String? description,
    DateTime? createdAt,
  }) => LocalActivityLog(
    id: id ?? this.id,
    transportId: transportId.present ? transportId.value : this.transportId,
    userId: userId.present ? userId.value : this.userId,
    action: action ?? this.action,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalActivityLog copyWithCompanion(LocalActivityLogsCompanion data) {
    return LocalActivityLog(
      id: data.id.present ? data.id.value : this.id,
      transportId: data.transportId.present
          ? data.transportId.value
          : this.transportId,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalActivityLog(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, transportId, userId, action, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalActivityLog &&
          other.id == this.id &&
          other.transportId == this.transportId &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class LocalActivityLogsCompanion extends UpdateCompanion<LocalActivityLog> {
  final Value<String> id;
  final Value<String?> transportId;
  final Value<String?> userId;
  final Value<String> action;
  final Value<String> description;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalActivityLogsCompanion({
    this.id = const Value.absent(),
    this.transportId = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalActivityLogsCompanion.insert({
    required String id,
    this.transportId = const Value.absent(),
    this.userId = const Value.absent(),
    required String action,
    required String description,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       action = Value(action),
       description = Value(description),
       createdAt = Value(createdAt);
  static Insertable<LocalActivityLog> custom({
    Expression<String>? id,
    Expression<String>? transportId,
    Expression<String>? userId,
    Expression<String>? action,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transportId != null) 'transport_id': transportId,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalActivityLogsCompanion copyWith({
    Value<String>? id,
    Value<String?>? transportId,
    Value<String?>? userId,
    Value<String>? action,
    Value<String>? description,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalActivityLogsCompanion(
      id: id ?? this.id,
      transportId: transportId ?? this.transportId,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transportId.present) {
      map['transport_id'] = Variable<String>(transportId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalActivityLogsCompanion(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSyncQueueTable extends LocalSyncQueue
    with TableInfo<$LocalSyncQueueTable, LocalSyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payload,
    createdAt,
    retryCount,
    lastError,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $LocalSyncQueueTable createAlias(String alias) {
    return $LocalSyncQueueTable(attachedDatabase, alias);
  }
}

class LocalSyncQueueData extends DataClass
    implements Insertable<LocalSyncQueueData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;
  final String syncStatus;
  const LocalSyncQueueData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    required this.retryCount,
    this.lastError,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  LocalSyncQueueCompanion toCompanion(bool nullToAbsent) {
    return LocalSyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      syncStatus: Value(syncStatus),
    );
  }

  factory LocalSyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  LocalSyncQueueData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payload,
    DateTime? createdAt,
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
    String? syncStatus,
  }) => LocalSyncQueueData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  LocalSyncQueueData copyWithCompanion(LocalSyncQueueCompanion data) {
    return LocalSyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payload,
    createdAt,
    retryCount,
    lastError,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.syncStatus == this.syncStatus);
}

class LocalSyncQueueCompanion extends UpdateCompanion<LocalSyncQueueData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const LocalSyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSyncQueueCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<LocalSyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return LocalSyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalTransportAllocationsTable extends LocalTransportAllocations
    with TableInfo<$LocalTransportAllocationsTable, LocalTransportAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTransportAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportIdMeta = const VerificationMeta(
    'transportId',
  );
  @override
  late final GeneratedColumn<String> transportId = GeneratedColumn<String>(
    'transport_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotIndexMeta = const VerificationMeta(
    'slotIndex',
  );
  @override
  late final GeneratedColumn<int> slotIndex = GeneratedColumn<int>(
    'slot_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleNumberMeta = const VerificationMeta(
    'vehicleNumber',
  );
  @override
  late final GeneratedColumn<String> vehicleNumber = GeneratedColumn<String>(
    'vehicle_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _driverIdMeta = const VerificationMeta(
    'driverId',
  );
  @override
  late final GeneratedColumn<String> driverId = GeneratedColumn<String>(
    'driver_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _driverNameMeta = const VerificationMeta(
    'driverName',
  );
  @override
  late final GeneratedColumn<String> driverName = GeneratedColumn<String>(
    'driver_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _driverMobileMeta = const VerificationMeta(
    'driverMobile',
  );
  @override
  late final GeneratedColumn<String> driverMobile = GeneratedColumn<String>(
    'driver_mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignedAtMeta = const VerificationMeta(
    'assignedAt',
  );
  @override
  late final GeneratedColumn<DateTime> assignedAt = GeneratedColumn<DateTime>(
    'assigned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transportId,
    slotIndex,
    vehicleId,
    vehicleNumber,
    driverId,
    driverName,
    driverMobile,
    assignedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_transport_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTransportAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transport_id')) {
      context.handle(
        _transportIdMeta,
        transportId.isAcceptableOrUnknown(
          data['transport_id']!,
          _transportIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transportIdMeta);
    }
    if (data.containsKey('slot_index')) {
      context.handle(
        _slotIndexMeta,
        slotIndex.isAcceptableOrUnknown(data['slot_index']!, _slotIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_slotIndexMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('vehicle_number')) {
      context.handle(
        _vehicleNumberMeta,
        vehicleNumber.isAcceptableOrUnknown(
          data['vehicle_number']!,
          _vehicleNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vehicleNumberMeta);
    }
    if (data.containsKey('driver_id')) {
      context.handle(
        _driverIdMeta,
        driverId.isAcceptableOrUnknown(data['driver_id']!, _driverIdMeta),
      );
    }
    if (data.containsKey('driver_name')) {
      context.handle(
        _driverNameMeta,
        driverName.isAcceptableOrUnknown(data['driver_name']!, _driverNameMeta),
      );
    }
    if (data.containsKey('driver_mobile')) {
      context.handle(
        _driverMobileMeta,
        driverMobile.isAcceptableOrUnknown(
          data['driver_mobile']!,
          _driverMobileMeta,
        ),
      );
    }
    if (data.containsKey('assigned_at')) {
      context.handle(
        _assignedAtMeta,
        assignedAt.isAcceptableOrUnknown(data['assigned_at']!, _assignedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_assignedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalTransportAllocation map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTransportAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport_id'],
      )!,
      slotIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot_index'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      vehicleNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_number'],
      )!,
      driverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver_id'],
      ),
      driverName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver_name'],
      ),
      driverMobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver_mobile'],
      ),
      assignedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}assigned_at'],
      )!,
    );
  }

  @override
  $LocalTransportAllocationsTable createAlias(String alias) {
    return $LocalTransportAllocationsTable(attachedDatabase, alias);
  }
}

class LocalTransportAllocation extends DataClass
    implements Insertable<LocalTransportAllocation> {
  final String id;
  final String transportId;
  final int slotIndex;
  final String vehicleId;
  final String vehicleNumber;
  final String? driverId;
  final String? driverName;
  final String? driverMobile;
  final DateTime assignedAt;
  const LocalTransportAllocation({
    required this.id,
    required this.transportId,
    required this.slotIndex,
    required this.vehicleId,
    required this.vehicleNumber,
    this.driverId,
    this.driverName,
    this.driverMobile,
    required this.assignedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transport_id'] = Variable<String>(transportId);
    map['slot_index'] = Variable<int>(slotIndex);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['vehicle_number'] = Variable<String>(vehicleNumber);
    if (!nullToAbsent || driverId != null) {
      map['driver_id'] = Variable<String>(driverId);
    }
    if (!nullToAbsent || driverName != null) {
      map['driver_name'] = Variable<String>(driverName);
    }
    if (!nullToAbsent || driverMobile != null) {
      map['driver_mobile'] = Variable<String>(driverMobile);
    }
    map['assigned_at'] = Variable<DateTime>(assignedAt);
    return map;
  }

  LocalTransportAllocationsCompanion toCompanion(bool nullToAbsent) {
    return LocalTransportAllocationsCompanion(
      id: Value(id),
      transportId: Value(transportId),
      slotIndex: Value(slotIndex),
      vehicleId: Value(vehicleId),
      vehicleNumber: Value(vehicleNumber),
      driverId: driverId == null && nullToAbsent
          ? const Value.absent()
          : Value(driverId),
      driverName: driverName == null && nullToAbsent
          ? const Value.absent()
          : Value(driverName),
      driverMobile: driverMobile == null && nullToAbsent
          ? const Value.absent()
          : Value(driverMobile),
      assignedAt: Value(assignedAt),
    );
  }

  factory LocalTransportAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTransportAllocation(
      id: serializer.fromJson<String>(json['id']),
      transportId: serializer.fromJson<String>(json['transportId']),
      slotIndex: serializer.fromJson<int>(json['slotIndex']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      vehicleNumber: serializer.fromJson<String>(json['vehicleNumber']),
      driverId: serializer.fromJson<String?>(json['driverId']),
      driverName: serializer.fromJson<String?>(json['driverName']),
      driverMobile: serializer.fromJson<String?>(json['driverMobile']),
      assignedAt: serializer.fromJson<DateTime>(json['assignedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transportId': serializer.toJson<String>(transportId),
      'slotIndex': serializer.toJson<int>(slotIndex),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'vehicleNumber': serializer.toJson<String>(vehicleNumber),
      'driverId': serializer.toJson<String?>(driverId),
      'driverName': serializer.toJson<String?>(driverName),
      'driverMobile': serializer.toJson<String?>(driverMobile),
      'assignedAt': serializer.toJson<DateTime>(assignedAt),
    };
  }

  LocalTransportAllocation copyWith({
    String? id,
    String? transportId,
    int? slotIndex,
    String? vehicleId,
    String? vehicleNumber,
    Value<String?> driverId = const Value.absent(),
    Value<String?> driverName = const Value.absent(),
    Value<String?> driverMobile = const Value.absent(),
    DateTime? assignedAt,
  }) => LocalTransportAllocation(
    id: id ?? this.id,
    transportId: transportId ?? this.transportId,
    slotIndex: slotIndex ?? this.slotIndex,
    vehicleId: vehicleId ?? this.vehicleId,
    vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    driverId: driverId.present ? driverId.value : this.driverId,
    driverName: driverName.present ? driverName.value : this.driverName,
    driverMobile: driverMobile.present ? driverMobile.value : this.driverMobile,
    assignedAt: assignedAt ?? this.assignedAt,
  );
  LocalTransportAllocation copyWithCompanion(
    LocalTransportAllocationsCompanion data,
  ) {
    return LocalTransportAllocation(
      id: data.id.present ? data.id.value : this.id,
      transportId: data.transportId.present
          ? data.transportId.value
          : this.transportId,
      slotIndex: data.slotIndex.present ? data.slotIndex.value : this.slotIndex,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      vehicleNumber: data.vehicleNumber.present
          ? data.vehicleNumber.value
          : this.vehicleNumber,
      driverId: data.driverId.present ? data.driverId.value : this.driverId,
      driverName: data.driverName.present
          ? data.driverName.value
          : this.driverName,
      driverMobile: data.driverMobile.present
          ? data.driverMobile.value
          : this.driverMobile,
      assignedAt: data.assignedAt.present
          ? data.assignedAt.value
          : this.assignedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransportAllocation(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('slotIndex: $slotIndex, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('vehicleNumber: $vehicleNumber, ')
          ..write('driverId: $driverId, ')
          ..write('driverName: $driverName, ')
          ..write('driverMobile: $driverMobile, ')
          ..write('assignedAt: $assignedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transportId,
    slotIndex,
    vehicleId,
    vehicleNumber,
    driverId,
    driverName,
    driverMobile,
    assignedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTransportAllocation &&
          other.id == this.id &&
          other.transportId == this.transportId &&
          other.slotIndex == this.slotIndex &&
          other.vehicleId == this.vehicleId &&
          other.vehicleNumber == this.vehicleNumber &&
          other.driverId == this.driverId &&
          other.driverName == this.driverName &&
          other.driverMobile == this.driverMobile &&
          other.assignedAt == this.assignedAt);
}

class LocalTransportAllocationsCompanion
    extends UpdateCompanion<LocalTransportAllocation> {
  final Value<String> id;
  final Value<String> transportId;
  final Value<int> slotIndex;
  final Value<String> vehicleId;
  final Value<String> vehicleNumber;
  final Value<String?> driverId;
  final Value<String?> driverName;
  final Value<String?> driverMobile;
  final Value<DateTime> assignedAt;
  final Value<int> rowid;
  const LocalTransportAllocationsCompanion({
    this.id = const Value.absent(),
    this.transportId = const Value.absent(),
    this.slotIndex = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.vehicleNumber = const Value.absent(),
    this.driverId = const Value.absent(),
    this.driverName = const Value.absent(),
    this.driverMobile = const Value.absent(),
    this.assignedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTransportAllocationsCompanion.insert({
    required String id,
    required String transportId,
    required int slotIndex,
    required String vehicleId,
    required String vehicleNumber,
    this.driverId = const Value.absent(),
    this.driverName = const Value.absent(),
    this.driverMobile = const Value.absent(),
    required DateTime assignedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transportId = Value(transportId),
       slotIndex = Value(slotIndex),
       vehicleId = Value(vehicleId),
       vehicleNumber = Value(vehicleNumber),
       assignedAt = Value(assignedAt);
  static Insertable<LocalTransportAllocation> custom({
    Expression<String>? id,
    Expression<String>? transportId,
    Expression<int>? slotIndex,
    Expression<String>? vehicleId,
    Expression<String>? vehicleNumber,
    Expression<String>? driverId,
    Expression<String>? driverName,
    Expression<String>? driverMobile,
    Expression<DateTime>? assignedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transportId != null) 'transport_id': transportId,
      if (slotIndex != null) 'slot_index': slotIndex,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (vehicleNumber != null) 'vehicle_number': vehicleNumber,
      if (driverId != null) 'driver_id': driverId,
      if (driverName != null) 'driver_name': driverName,
      if (driverMobile != null) 'driver_mobile': driverMobile,
      if (assignedAt != null) 'assigned_at': assignedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTransportAllocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? transportId,
    Value<int>? slotIndex,
    Value<String>? vehicleId,
    Value<String>? vehicleNumber,
    Value<String?>? driverId,
    Value<String?>? driverName,
    Value<String?>? driverMobile,
    Value<DateTime>? assignedAt,
    Value<int>? rowid,
  }) {
    return LocalTransportAllocationsCompanion(
      id: id ?? this.id,
      transportId: transportId ?? this.transportId,
      slotIndex: slotIndex ?? this.slotIndex,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverMobile: driverMobile ?? this.driverMobile,
      assignedAt: assignedAt ?? this.assignedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transportId.present) {
      map['transport_id'] = Variable<String>(transportId.value);
    }
    if (slotIndex.present) {
      map['slot_index'] = Variable<int>(slotIndex.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (vehicleNumber.present) {
      map['vehicle_number'] = Variable<String>(vehicleNumber.value);
    }
    if (driverId.present) {
      map['driver_id'] = Variable<String>(driverId.value);
    }
    if (driverName.present) {
      map['driver_name'] = Variable<String>(driverName.value);
    }
    if (driverMobile.present) {
      map['driver_mobile'] = Variable<String>(driverMobile.value);
    }
    if (assignedAt.present) {
      map['assigned_at'] = Variable<DateTime>(assignedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransportAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('transportId: $transportId, ')
          ..write('slotIndex: $slotIndex, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('vehicleNumber: $vehicleNumber, ')
          ..write('driverId: $driverId, ')
          ..write('driverName: $driverName, ')
          ..write('driverMobile: $driverMobile, ')
          ..write('assignedAt: $assignedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalVehiclesTable localVehicles = $LocalVehiclesTable(this);
  late final $LocalDriversTable localDrivers = $LocalDriversTable(this);
  late final $LocalPartiesTable localParties = $LocalPartiesTable(this);
  late final $LocalShippingLinesTable localShippingLines =
      $LocalShippingLinesTable(this);
  late final $LocalLocationsTable localLocations = $LocalLocationsTable(this);
  late final $LocalPortsCfsTable localPortsCfs = $LocalPortsCfsTable(this);
  late final $LocalTransportsTable localTransports = $LocalTransportsTable(
    this,
  );
  late final $LocalTransportStatusHistoryTable localTransportStatusHistory =
      $LocalTransportStatusHistoryTable(this);
  late final $LocalVehicleAssignmentsTable localVehicleAssignments =
      $LocalVehicleAssignmentsTable(this);
  late final $LocalDriverAssignmentsTable localDriverAssignments =
      $LocalDriverAssignmentsTable(this);
  late final $LocalNotificationLogsTable localNotificationLogs =
      $LocalNotificationLogsTable(this);
  late final $LocalPodDocumentsTable localPodDocuments =
      $LocalPodDocumentsTable(this);
  late final $LocalActivityLogsTable localActivityLogs =
      $LocalActivityLogsTable(this);
  late final $LocalSyncQueueTable localSyncQueue = $LocalSyncQueueTable(this);
  late final $LocalTransportAllocationsTable localTransportAllocations =
      $LocalTransportAllocationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localVehicles,
    localDrivers,
    localParties,
    localShippingLines,
    localLocations,
    localPortsCfs,
    localTransports,
    localTransportStatusHistory,
    localVehicleAssignments,
    localDriverAssignments,
    localNotificationLogs,
    localPodDocuments,
    localActivityLogs,
    localSyncQueue,
    localTransportAllocations,
  ];
}

typedef $$LocalVehiclesTableCreateCompanionBuilder =
    LocalVehiclesCompanion Function({
      required String id,
      required String vehicleNumber,
      required String vehicleType,
      required String capacity,
      Value<String> status,
      Value<String?> assignedDriverId,
      Value<String?> assignedDriverName,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalVehiclesTableUpdateCompanionBuilder =
    LocalVehiclesCompanion Function({
      Value<String> id,
      Value<String> vehicleNumber,
      Value<String> vehicleType,
      Value<String> capacity,
      Value<String> status,
      Value<String?> assignedDriverId,
      Value<String?> assignedDriverName,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalVehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVehiclesTable> {
  $$LocalVehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedDriverId => $composableBuilder(
    column: $table.assignedDriverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedDriverName => $composableBuilder(
    column: $table.assignedDriverName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalVehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVehiclesTable> {
  $$LocalVehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedDriverId => $composableBuilder(
    column: $table.assignedDriverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedDriverName => $composableBuilder(
    column: $table.assignedDriverName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalVehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVehiclesTable> {
  $$LocalVehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get assignedDriverId => $composableBuilder(
    column: $table.assignedDriverId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assignedDriverName => $composableBuilder(
    column: $table.assignedDriverName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalVehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVehiclesTable,
          LocalVehicle,
          $$LocalVehiclesTableFilterComposer,
          $$LocalVehiclesTableOrderingComposer,
          $$LocalVehiclesTableAnnotationComposer,
          $$LocalVehiclesTableCreateCompanionBuilder,
          $$LocalVehiclesTableUpdateCompanionBuilder,
          (
            LocalVehicle,
            BaseReferences<_$AppDatabase, $LocalVehiclesTable, LocalVehicle>,
          ),
          LocalVehicle,
          PrefetchHooks Function()
        > {
  $$LocalVehiclesTableTableManager(_$AppDatabase db, $LocalVehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalVehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalVehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleNumber = const Value.absent(),
                Value<String> vehicleType = const Value.absent(),
                Value<String> capacity = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> assignedDriverId = const Value.absent(),
                Value<String?> assignedDriverName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVehiclesCompanion(
                id: id,
                vehicleNumber: vehicleNumber,
                vehicleType: vehicleType,
                capacity: capacity,
                status: status,
                assignedDriverId: assignedDriverId,
                assignedDriverName: assignedDriverName,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleNumber,
                required String vehicleType,
                required String capacity,
                Value<String> status = const Value.absent(),
                Value<String?> assignedDriverId = const Value.absent(),
                Value<String?> assignedDriverName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVehiclesCompanion.insert(
                id: id,
                vehicleNumber: vehicleNumber,
                vehicleType: vehicleType,
                capacity: capacity,
                status: status,
                assignedDriverId: assignedDriverId,
                assignedDriverName: assignedDriverName,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalVehiclesTable, LocalVehicle>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalVehiclesTable,
                    LocalVehicle
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVehiclesTable,
      LocalVehicle,
      $$LocalVehiclesTableFilterComposer,
      $$LocalVehiclesTableOrderingComposer,
      $$LocalVehiclesTableAnnotationComposer,
      $$LocalVehiclesTableCreateCompanionBuilder,
      $$LocalVehiclesTableUpdateCompanionBuilder,
      (
        LocalVehicle,
        BaseReferences<_$AppDatabase, $LocalVehiclesTable, LocalVehicle>,
      ),
      LocalVehicle,
      PrefetchHooks Function()
    >;
typedef $$LocalDriversTableCreateCompanionBuilder =
    LocalDriversCompanion Function({
      required String id,
      required String name,
      required String mobileNumber,
      Value<String> status,
      Value<String?> currentVehicleId,
      Value<String?> currentVehicleNumber,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalDriversTableUpdateCompanionBuilder =
    LocalDriversCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> mobileNumber,
      Value<String> status,
      Value<String?> currentVehicleId,
      Value<String?> currentVehicleNumber,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalDriversTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDriversTable> {
  $$LocalDriversTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentVehicleId => $composableBuilder(
    column: $table.currentVehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentVehicleNumber => $composableBuilder(
    column: $table.currentVehicleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalDriversTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDriversTable> {
  $$LocalDriversTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentVehicleId => $composableBuilder(
    column: $table.currentVehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentVehicleNumber => $composableBuilder(
    column: $table.currentVehicleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalDriversTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDriversTable> {
  $$LocalDriversTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get currentVehicleId => $composableBuilder(
    column: $table.currentVehicleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentVehicleNumber => $composableBuilder(
    column: $table.currentVehicleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalDriversTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalDriversTable,
          LocalDriver,
          $$LocalDriversTableFilterComposer,
          $$LocalDriversTableOrderingComposer,
          $$LocalDriversTableAnnotationComposer,
          $$LocalDriversTableCreateCompanionBuilder,
          $$LocalDriversTableUpdateCompanionBuilder,
          (
            LocalDriver,
            BaseReferences<_$AppDatabase, $LocalDriversTable, LocalDriver>,
          ),
          LocalDriver,
          PrefetchHooks Function()
        > {
  $$LocalDriversTableTableManager(_$AppDatabase db, $LocalDriversTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDriversTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDriversTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDriversTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> mobileNumber = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> currentVehicleId = const Value.absent(),
                Value<String?> currentVehicleNumber = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDriversCompanion(
                id: id,
                name: name,
                mobileNumber: mobileNumber,
                status: status,
                currentVehicleId: currentVehicleId,
                currentVehicleNumber: currentVehicleNumber,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String mobileNumber,
                Value<String> status = const Value.absent(),
                Value<String?> currentVehicleId = const Value.absent(),
                Value<String?> currentVehicleNumber = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDriversCompanion.insert(
                id: id,
                name: name,
                mobileNumber: mobileNumber,
                status: status,
                currentVehicleId: currentVehicleId,
                currentVehicleNumber: currentVehicleNumber,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalDriversTable, LocalDriver>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalDriversTable,
                    LocalDriver
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalDriversTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalDriversTable,
      LocalDriver,
      $$LocalDriversTableFilterComposer,
      $$LocalDriversTableOrderingComposer,
      $$LocalDriversTableAnnotationComposer,
      $$LocalDriversTableCreateCompanionBuilder,
      $$LocalDriversTableUpdateCompanionBuilder,
      (
        LocalDriver,
        BaseReferences<_$AppDatabase, $LocalDriversTable, LocalDriver>,
      ),
      LocalDriver,
      PrefetchHooks Function()
    >;
typedef $$LocalPartiesTableCreateCompanionBuilder =
    LocalPartiesCompanion Function({
      required String id,
      required String partyName,
      required String customerMobile,
      Value<String> email,
      Value<String> city,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalPartiesTableUpdateCompanionBuilder =
    LocalPartiesCompanion Function({
      Value<String> id,
      Value<String> partyName,
      Value<String> customerMobile,
      Value<String> email,
      Value<String> city,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalPartiesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPartiesTable> {
  $$LocalPartiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partyName => $composableBuilder(
    column: $table.partyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerMobile => $composableBuilder(
    column: $table.customerMobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalPartiesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPartiesTable> {
  $$LocalPartiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partyName => $composableBuilder(
    column: $table.partyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerMobile => $composableBuilder(
    column: $table.customerMobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalPartiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPartiesTable> {
  $$LocalPartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get partyName =>
      $composableBuilder(column: $table.partyName, builder: (column) => column);

  GeneratedColumn<String> get customerMobile => $composableBuilder(
    column: $table.customerMobile,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalPartiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPartiesTable,
          LocalParty,
          $$LocalPartiesTableFilterComposer,
          $$LocalPartiesTableOrderingComposer,
          $$LocalPartiesTableAnnotationComposer,
          $$LocalPartiesTableCreateCompanionBuilder,
          $$LocalPartiesTableUpdateCompanionBuilder,
          (
            LocalParty,
            BaseReferences<_$AppDatabase, $LocalPartiesTable, LocalParty>,
          ),
          LocalParty,
          PrefetchHooks Function()
        > {
  $$LocalPartiesTableTableManager(_$AppDatabase db, $LocalPartiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalPartiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> partyName = const Value.absent(),
                Value<String> customerMobile = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPartiesCompanion(
                id: id,
                partyName: partyName,
                customerMobile: customerMobile,
                email: email,
                city: city,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String partyName,
                required String customerMobile,
                Value<String> email = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPartiesCompanion.insert(
                id: id,
                partyName: partyName,
                customerMobile: customerMobile,
                email: email,
                city: city,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalPartiesTable, LocalParty>(table),
                  BaseReferences<_$AppDatabase, $LocalPartiesTable, LocalParty>(
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

typedef $$LocalPartiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPartiesTable,
      LocalParty,
      $$LocalPartiesTableFilterComposer,
      $$LocalPartiesTableOrderingComposer,
      $$LocalPartiesTableAnnotationComposer,
      $$LocalPartiesTableCreateCompanionBuilder,
      $$LocalPartiesTableUpdateCompanionBuilder,
      (
        LocalParty,
        BaseReferences<_$AppDatabase, $LocalPartiesTable, LocalParty>,
      ),
      LocalParty,
      PrefetchHooks Function()
    >;
typedef $$LocalShippingLinesTableCreateCompanionBuilder =
    LocalShippingLinesCompanion Function({
      required String id,
      required String name,
      required String code,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalShippingLinesTableUpdateCompanionBuilder =
    LocalShippingLinesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> code,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalShippingLinesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalShippingLinesTable> {
  $$LocalShippingLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalShippingLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalShippingLinesTable> {
  $$LocalShippingLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalShippingLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalShippingLinesTable> {
  $$LocalShippingLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalShippingLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalShippingLinesTable,
          LocalShippingLine,
          $$LocalShippingLinesTableFilterComposer,
          $$LocalShippingLinesTableOrderingComposer,
          $$LocalShippingLinesTableAnnotationComposer,
          $$LocalShippingLinesTableCreateCompanionBuilder,
          $$LocalShippingLinesTableUpdateCompanionBuilder,
          (
            LocalShippingLine,
            BaseReferences<
              _$AppDatabase,
              $LocalShippingLinesTable,
              LocalShippingLine
            >,
          ),
          LocalShippingLine,
          PrefetchHooks Function()
        > {
  $$LocalShippingLinesTableTableManager(
    _$AppDatabase db,
    $LocalShippingLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalShippingLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalShippingLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalShippingLinesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalShippingLinesCompanion(
                id: id,
                name: name,
                code: code,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String code,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalShippingLinesCompanion.insert(
                id: id,
                name: name,
                code: code,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalShippingLinesTable, LocalShippingLine>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalShippingLinesTable,
                    LocalShippingLine
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalShippingLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalShippingLinesTable,
      LocalShippingLine,
      $$LocalShippingLinesTableFilterComposer,
      $$LocalShippingLinesTableOrderingComposer,
      $$LocalShippingLinesTableAnnotationComposer,
      $$LocalShippingLinesTableCreateCompanionBuilder,
      $$LocalShippingLinesTableUpdateCompanionBuilder,
      (
        LocalShippingLine,
        BaseReferences<
          _$AppDatabase,
          $LocalShippingLinesTable,
          LocalShippingLine
        >,
      ),
      LocalShippingLine,
      PrefetchHooks Function()
    >;
typedef $$LocalLocationsTableCreateCompanionBuilder =
    LocalLocationsCompanion Function({
      required String id,
      required String name,
      required String locationType,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalLocationsTableUpdateCompanionBuilder =
    LocalLocationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> locationType,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLocationsTable> {
  $$LocalLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLocationsTable> {
  $$LocalLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLocationsTable> {
  $$LocalLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLocationsTable,
          LocalLocation,
          $$LocalLocationsTableFilterComposer,
          $$LocalLocationsTableOrderingComposer,
          $$LocalLocationsTableAnnotationComposer,
          $$LocalLocationsTableCreateCompanionBuilder,
          $$LocalLocationsTableUpdateCompanionBuilder,
          (
            LocalLocation,
            BaseReferences<_$AppDatabase, $LocalLocationsTable, LocalLocation>,
          ),
          LocalLocation,
          PrefetchHooks Function()
        > {
  $$LocalLocationsTableTableManager(
    _$AppDatabase db,
    $LocalLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> locationType = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLocationsCompanion(
                id: id,
                name: name,
                locationType: locationType,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String locationType,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLocationsCompanion.insert(
                id: id,
                name: name,
                locationType: locationType,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalLocationsTable, LocalLocation>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalLocationsTable,
                    LocalLocation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLocationsTable,
      LocalLocation,
      $$LocalLocationsTableFilterComposer,
      $$LocalLocationsTableOrderingComposer,
      $$LocalLocationsTableAnnotationComposer,
      $$LocalLocationsTableCreateCompanionBuilder,
      $$LocalLocationsTableUpdateCompanionBuilder,
      (
        LocalLocation,
        BaseReferences<_$AppDatabase, $LocalLocationsTable, LocalLocation>,
      ),
      LocalLocation,
      PrefetchHooks Function()
    >;
typedef $$LocalPortsCfsTableCreateCompanionBuilder =
    LocalPortsCfsCompanion Function({
      required String id,
      required String name,
      required String type,
      required String location,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalPortsCfsTableUpdateCompanionBuilder =
    LocalPortsCfsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String> location,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalPortsCfsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPortsCfsTable> {
  $$LocalPortsCfsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalPortsCfsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPortsCfsTable> {
  $$LocalPortsCfsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
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

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocalPortsCfsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPortsCfsTable> {
  $$LocalPortsCfsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalPortsCfsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPortsCfsTable,
          LocalPortsCf,
          $$LocalPortsCfsTableFilterComposer,
          $$LocalPortsCfsTableOrderingComposer,
          $$LocalPortsCfsTableAnnotationComposer,
          $$LocalPortsCfsTableCreateCompanionBuilder,
          $$LocalPortsCfsTableUpdateCompanionBuilder,
          (
            LocalPortsCf,
            BaseReferences<_$AppDatabase, $LocalPortsCfsTable, LocalPortsCf>,
          ),
          LocalPortsCf,
          PrefetchHooks Function()
        > {
  $$LocalPortsCfsTableTableManager(_$AppDatabase db, $LocalPortsCfsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPortsCfsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPortsCfsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalPortsCfsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPortsCfsCompanion(
                id: id,
                name: name,
                type: type,
                location: location,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required String location,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPortsCfsCompanion.insert(
                id: id,
                name: name,
                type: type,
                location: location,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalPortsCfsTable, LocalPortsCf>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalPortsCfsTable,
                    LocalPortsCf
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPortsCfsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPortsCfsTable,
      LocalPortsCf,
      $$LocalPortsCfsTableFilterComposer,
      $$LocalPortsCfsTableOrderingComposer,
      $$LocalPortsCfsTableAnnotationComposer,
      $$LocalPortsCfsTableCreateCompanionBuilder,
      $$LocalPortsCfsTableUpdateCompanionBuilder,
      (
        LocalPortsCf,
        BaseReferences<_$AppDatabase, $LocalPortsCfsTable, LocalPortsCf>,
      ),
      LocalPortsCf,
      PrefetchHooks Function()
    >;
typedef $$LocalTransportsTableCreateCompanionBuilder =
    LocalTransportsCompanion Function({
      required String id,
      required String transportNumber,
      required String bookingNumber,
      required String containerNumber,
      required String sealNumber,
      required String containerSize,
      required String shipmentType,
      required String partyId,
      required String partyName,
      Value<String?> partyMobile,
      required String bookingPartyId,
      required String bookingPartyName,
      required String shippingLineId,
      required String shippingLineName,
      required String fromLocationId,
      required String fromLocationName,
      required String toLocationId,
      required String toLocationName,
      required String portCfsId,
      required String portCfsName,
      Value<String?> vehicleId,
      Value<String?> vehicleNumber,
      Value<String?> driverId,
      Value<String?> driverName,
      Value<String?> driverMobile,
      Value<String> status,
      Value<String?> exceptionReason,
      Value<DateTime?> vehicleReportedAt,
      Value<DateTime?> containerPickedUpAt,
      Value<DateTime?> inTransitAt,
      Value<DateTime?> atPortCfsAt,
      Value<DateTime?> containerDeliveredAt,
      Value<DateTime?> podReceivedAt,
      Value<DateTime?> completedAt,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalTransportsTableUpdateCompanionBuilder =
    LocalTransportsCompanion Function({
      Value<String> id,
      Value<String> transportNumber,
      Value<String> bookingNumber,
      Value<String> containerNumber,
      Value<String> sealNumber,
      Value<String> containerSize,
      Value<String> shipmentType,
      Value<String> partyId,
      Value<String> partyName,
      Value<String?> partyMobile,
      Value<String> bookingPartyId,
      Value<String> bookingPartyName,
      Value<String> shippingLineId,
      Value<String> shippingLineName,
      Value<String> fromLocationId,
      Value<String> fromLocationName,
      Value<String> toLocationId,
      Value<String> toLocationName,
      Value<String> portCfsId,
      Value<String> portCfsName,
      Value<String?> vehicleId,
      Value<String?> vehicleNumber,
      Value<String?> driverId,
      Value<String?> driverName,
      Value<String?> driverMobile,
      Value<String> status,
      Value<String?> exceptionReason,
      Value<DateTime?> vehicleReportedAt,
      Value<DateTime?> containerPickedUpAt,
      Value<DateTime?> inTransitAt,
      Value<DateTime?> atPortCfsAt,
      Value<DateTime?> containerDeliveredAt,
      Value<DateTime?> podReceivedAt,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalTransportsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalTransportsTable> {
  $$LocalTransportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportNumber => $composableBuilder(
    column: $table.transportNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookingNumber => $composableBuilder(
    column: $table.bookingNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get containerNumber => $composableBuilder(
    column: $table.containerNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sealNumber => $composableBuilder(
    column: $table.sealNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get containerSize => $composableBuilder(
    column: $table.containerSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shipmentType => $composableBuilder(
    column: $table.shipmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partyId => $composableBuilder(
    column: $table.partyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partyName => $composableBuilder(
    column: $table.partyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partyMobile => $composableBuilder(
    column: $table.partyMobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookingPartyId => $composableBuilder(
    column: $table.bookingPartyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookingPartyName => $composableBuilder(
    column: $table.bookingPartyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shippingLineId => $composableBuilder(
    column: $table.shippingLineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shippingLineName => $composableBuilder(
    column: $table.shippingLineName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromLocationId => $composableBuilder(
    column: $table.fromLocationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromLocationName => $composableBuilder(
    column: $table.fromLocationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toLocationId => $composableBuilder(
    column: $table.toLocationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toLocationName => $composableBuilder(
    column: $table.toLocationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portCfsId => $composableBuilder(
    column: $table.portCfsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portCfsName => $composableBuilder(
    column: $table.portCfsName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driverId => $composableBuilder(
    column: $table.driverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driverName => $composableBuilder(
    column: $table.driverName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driverMobile => $composableBuilder(
    column: $table.driverMobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exceptionReason => $composableBuilder(
    column: $table.exceptionReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get vehicleReportedAt => $composableBuilder(
    column: $table.vehicleReportedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get containerPickedUpAt => $composableBuilder(
    column: $table.containerPickedUpAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get inTransitAt => $composableBuilder(
    column: $table.inTransitAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atPortCfsAt => $composableBuilder(
    column: $table.atPortCfsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get containerDeliveredAt => $composableBuilder(
    column: $table.containerDeliveredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get podReceivedAt => $composableBuilder(
    column: $table.podReceivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
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
}

class $$LocalTransportsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalTransportsTable> {
  $$LocalTransportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportNumber => $composableBuilder(
    column: $table.transportNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookingNumber => $composableBuilder(
    column: $table.bookingNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get containerNumber => $composableBuilder(
    column: $table.containerNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sealNumber => $composableBuilder(
    column: $table.sealNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get containerSize => $composableBuilder(
    column: $table.containerSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shipmentType => $composableBuilder(
    column: $table.shipmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partyId => $composableBuilder(
    column: $table.partyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partyName => $composableBuilder(
    column: $table.partyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partyMobile => $composableBuilder(
    column: $table.partyMobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookingPartyId => $composableBuilder(
    column: $table.bookingPartyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookingPartyName => $composableBuilder(
    column: $table.bookingPartyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shippingLineId => $composableBuilder(
    column: $table.shippingLineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shippingLineName => $composableBuilder(
    column: $table.shippingLineName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromLocationId => $composableBuilder(
    column: $table.fromLocationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromLocationName => $composableBuilder(
    column: $table.fromLocationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toLocationId => $composableBuilder(
    column: $table.toLocationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toLocationName => $composableBuilder(
    column: $table.toLocationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portCfsId => $composableBuilder(
    column: $table.portCfsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portCfsName => $composableBuilder(
    column: $table.portCfsName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driverId => $composableBuilder(
    column: $table.driverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driverName => $composableBuilder(
    column: $table.driverName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driverMobile => $composableBuilder(
    column: $table.driverMobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exceptionReason => $composableBuilder(
    column: $table.exceptionReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get vehicleReportedAt => $composableBuilder(
    column: $table.vehicleReportedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get containerPickedUpAt => $composableBuilder(
    column: $table.containerPickedUpAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get inTransitAt => $composableBuilder(
    column: $table.inTransitAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atPortCfsAt => $composableBuilder(
    column: $table.atPortCfsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get containerDeliveredAt => $composableBuilder(
    column: $table.containerDeliveredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get podReceivedAt => $composableBuilder(
    column: $table.podReceivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
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
}

class $$LocalTransportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalTransportsTable> {
  $$LocalTransportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transportNumber => $composableBuilder(
    column: $table.transportNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bookingNumber => $composableBuilder(
    column: $table.bookingNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get containerNumber => $composableBuilder(
    column: $table.containerNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sealNumber => $composableBuilder(
    column: $table.sealNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get containerSize => $composableBuilder(
    column: $table.containerSize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shipmentType => $composableBuilder(
    column: $table.shipmentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get partyId =>
      $composableBuilder(column: $table.partyId, builder: (column) => column);

  GeneratedColumn<String> get partyName =>
      $composableBuilder(column: $table.partyName, builder: (column) => column);

  GeneratedColumn<String> get partyMobile => $composableBuilder(
    column: $table.partyMobile,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bookingPartyId => $composableBuilder(
    column: $table.bookingPartyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bookingPartyName => $composableBuilder(
    column: $table.bookingPartyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shippingLineId => $composableBuilder(
    column: $table.shippingLineId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shippingLineName => $composableBuilder(
    column: $table.shippingLineName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromLocationId => $composableBuilder(
    column: $table.fromLocationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromLocationName => $composableBuilder(
    column: $table.fromLocationName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toLocationId => $composableBuilder(
    column: $table.toLocationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toLocationName => $composableBuilder(
    column: $table.toLocationName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get portCfsId =>
      $composableBuilder(column: $table.portCfsId, builder: (column) => column);

  GeneratedColumn<String> get portCfsName => $composableBuilder(
    column: $table.portCfsName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driverId =>
      $composableBuilder(column: $table.driverId, builder: (column) => column);

  GeneratedColumn<String> get driverName => $composableBuilder(
    column: $table.driverName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driverMobile => $composableBuilder(
    column: $table.driverMobile,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get exceptionReason => $composableBuilder(
    column: $table.exceptionReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get vehicleReportedAt => $composableBuilder(
    column: $table.vehicleReportedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get containerPickedUpAt => $composableBuilder(
    column: $table.containerPickedUpAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get inTransitAt => $composableBuilder(
    column: $table.inTransitAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get atPortCfsAt => $composableBuilder(
    column: $table.atPortCfsAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get containerDeliveredAt => $composableBuilder(
    column: $table.containerDeliveredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get podReceivedAt => $composableBuilder(
    column: $table.podReceivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalTransportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalTransportsTable,
          LocalTransport,
          $$LocalTransportsTableFilterComposer,
          $$LocalTransportsTableOrderingComposer,
          $$LocalTransportsTableAnnotationComposer,
          $$LocalTransportsTableCreateCompanionBuilder,
          $$LocalTransportsTableUpdateCompanionBuilder,
          (
            LocalTransport,
            BaseReferences<
              _$AppDatabase,
              $LocalTransportsTable,
              LocalTransport
            >,
          ),
          LocalTransport,
          PrefetchHooks Function()
        > {
  $$LocalTransportsTableTableManager(
    _$AppDatabase db,
    $LocalTransportsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTransportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTransportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTransportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transportNumber = const Value.absent(),
                Value<String> bookingNumber = const Value.absent(),
                Value<String> containerNumber = const Value.absent(),
                Value<String> sealNumber = const Value.absent(),
                Value<String> containerSize = const Value.absent(),
                Value<String> shipmentType = const Value.absent(),
                Value<String> partyId = const Value.absent(),
                Value<String> partyName = const Value.absent(),
                Value<String?> partyMobile = const Value.absent(),
                Value<String> bookingPartyId = const Value.absent(),
                Value<String> bookingPartyName = const Value.absent(),
                Value<String> shippingLineId = const Value.absent(),
                Value<String> shippingLineName = const Value.absent(),
                Value<String> fromLocationId = const Value.absent(),
                Value<String> fromLocationName = const Value.absent(),
                Value<String> toLocationId = const Value.absent(),
                Value<String> toLocationName = const Value.absent(),
                Value<String> portCfsId = const Value.absent(),
                Value<String> portCfsName = const Value.absent(),
                Value<String?> vehicleId = const Value.absent(),
                Value<String?> vehicleNumber = const Value.absent(),
                Value<String?> driverId = const Value.absent(),
                Value<String?> driverName = const Value.absent(),
                Value<String?> driverMobile = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> exceptionReason = const Value.absent(),
                Value<DateTime?> vehicleReportedAt = const Value.absent(),
                Value<DateTime?> containerPickedUpAt = const Value.absent(),
                Value<DateTime?> inTransitAt = const Value.absent(),
                Value<DateTime?> atPortCfsAt = const Value.absent(),
                Value<DateTime?> containerDeliveredAt = const Value.absent(),
                Value<DateTime?> podReceivedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTransportsCompanion(
                id: id,
                transportNumber: transportNumber,
                bookingNumber: bookingNumber,
                containerNumber: containerNumber,
                sealNumber: sealNumber,
                containerSize: containerSize,
                shipmentType: shipmentType,
                partyId: partyId,
                partyName: partyName,
                partyMobile: partyMobile,
                bookingPartyId: bookingPartyId,
                bookingPartyName: bookingPartyName,
                shippingLineId: shippingLineId,
                shippingLineName: shippingLineName,
                fromLocationId: fromLocationId,
                fromLocationName: fromLocationName,
                toLocationId: toLocationId,
                toLocationName: toLocationName,
                portCfsId: portCfsId,
                portCfsName: portCfsName,
                vehicleId: vehicleId,
                vehicleNumber: vehicleNumber,
                driverId: driverId,
                driverName: driverName,
                driverMobile: driverMobile,
                status: status,
                exceptionReason: exceptionReason,
                vehicleReportedAt: vehicleReportedAt,
                containerPickedUpAt: containerPickedUpAt,
                inTransitAt: inTransitAt,
                atPortCfsAt: atPortCfsAt,
                containerDeliveredAt: containerDeliveredAt,
                podReceivedAt: podReceivedAt,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transportNumber,
                required String bookingNumber,
                required String containerNumber,
                required String sealNumber,
                required String containerSize,
                required String shipmentType,
                required String partyId,
                required String partyName,
                Value<String?> partyMobile = const Value.absent(),
                required String bookingPartyId,
                required String bookingPartyName,
                required String shippingLineId,
                required String shippingLineName,
                required String fromLocationId,
                required String fromLocationName,
                required String toLocationId,
                required String toLocationName,
                required String portCfsId,
                required String portCfsName,
                Value<String?> vehicleId = const Value.absent(),
                Value<String?> vehicleNumber = const Value.absent(),
                Value<String?> driverId = const Value.absent(),
                Value<String?> driverName = const Value.absent(),
                Value<String?> driverMobile = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> exceptionReason = const Value.absent(),
                Value<DateTime?> vehicleReportedAt = const Value.absent(),
                Value<DateTime?> containerPickedUpAt = const Value.absent(),
                Value<DateTime?> inTransitAt = const Value.absent(),
                Value<DateTime?> atPortCfsAt = const Value.absent(),
                Value<DateTime?> containerDeliveredAt = const Value.absent(),
                Value<DateTime?> podReceivedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTransportsCompanion.insert(
                id: id,
                transportNumber: transportNumber,
                bookingNumber: bookingNumber,
                containerNumber: containerNumber,
                sealNumber: sealNumber,
                containerSize: containerSize,
                shipmentType: shipmentType,
                partyId: partyId,
                partyName: partyName,
                partyMobile: partyMobile,
                bookingPartyId: bookingPartyId,
                bookingPartyName: bookingPartyName,
                shippingLineId: shippingLineId,
                shippingLineName: shippingLineName,
                fromLocationId: fromLocationId,
                fromLocationName: fromLocationName,
                toLocationId: toLocationId,
                toLocationName: toLocationName,
                portCfsId: portCfsId,
                portCfsName: portCfsName,
                vehicleId: vehicleId,
                vehicleNumber: vehicleNumber,
                driverId: driverId,
                driverName: driverName,
                driverMobile: driverMobile,
                status: status,
                exceptionReason: exceptionReason,
                vehicleReportedAt: vehicleReportedAt,
                containerPickedUpAt: containerPickedUpAt,
                inTransitAt: inTransitAt,
                atPortCfsAt: atPortCfsAt,
                containerDeliveredAt: containerDeliveredAt,
                podReceivedAt: podReceivedAt,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalTransportsTable, LocalTransport>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalTransportsTable,
                    LocalTransport
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTransportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalTransportsTable,
      LocalTransport,
      $$LocalTransportsTableFilterComposer,
      $$LocalTransportsTableOrderingComposer,
      $$LocalTransportsTableAnnotationComposer,
      $$LocalTransportsTableCreateCompanionBuilder,
      $$LocalTransportsTableUpdateCompanionBuilder,
      (
        LocalTransport,
        BaseReferences<_$AppDatabase, $LocalTransportsTable, LocalTransport>,
      ),
      LocalTransport,
      PrefetchHooks Function()
    >;
typedef $$LocalTransportStatusHistoryTableCreateCompanionBuilder =
    LocalTransportStatusHistoryCompanion Function({
      required String id,
      required String transportId,
      required String status,
      Value<String?> remarks,
      Value<String> changedBy,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LocalTransportStatusHistoryTableUpdateCompanionBuilder =
    LocalTransportStatusHistoryCompanion Function({
      Value<String> id,
      Value<String> transportId,
      Value<String> status,
      Value<String?> remarks,
      Value<String> changedBy,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalTransportStatusHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $LocalTransportStatusHistoryTable> {
  $$LocalTransportStatusHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changedBy => $composableBuilder(
    column: $table.changedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTransportStatusHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalTransportStatusHistoryTable> {
  $$LocalTransportStatusHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changedBy => $composableBuilder(
    column: $table.changedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTransportStatusHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalTransportStatusHistoryTable> {
  $$LocalTransportStatusHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<String> get changedBy =>
      $composableBuilder(column: $table.changedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalTransportStatusHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalTransportStatusHistoryTable,
          LocalTransportStatusHistoryData,
          $$LocalTransportStatusHistoryTableFilterComposer,
          $$LocalTransportStatusHistoryTableOrderingComposer,
          $$LocalTransportStatusHistoryTableAnnotationComposer,
          $$LocalTransportStatusHistoryTableCreateCompanionBuilder,
          $$LocalTransportStatusHistoryTableUpdateCompanionBuilder,
          (
            LocalTransportStatusHistoryData,
            BaseReferences<
              _$AppDatabase,
              $LocalTransportStatusHistoryTable,
              LocalTransportStatusHistoryData
            >,
          ),
          LocalTransportStatusHistoryData,
          PrefetchHooks Function()
        > {
  $$LocalTransportStatusHistoryTableTableManager(
    _$AppDatabase db,
    $LocalTransportStatusHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTransportStatusHistoryTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalTransportStatusHistoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalTransportStatusHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transportId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<String> changedBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTransportStatusHistoryCompanion(
                id: id,
                transportId: transportId,
                status: status,
                remarks: remarks,
                changedBy: changedBy,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transportId,
                required String status,
                Value<String?> remarks = const Value.absent(),
                Value<String> changedBy = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalTransportStatusHistoryCompanion.insert(
                id: id,
                transportId: transportId,
                status: status,
                remarks: remarks,
                changedBy: changedBy,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $LocalTransportStatusHistoryTable,
                    LocalTransportStatusHistoryData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalTransportStatusHistoryTable,
                    LocalTransportStatusHistoryData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTransportStatusHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalTransportStatusHistoryTable,
      LocalTransportStatusHistoryData,
      $$LocalTransportStatusHistoryTableFilterComposer,
      $$LocalTransportStatusHistoryTableOrderingComposer,
      $$LocalTransportStatusHistoryTableAnnotationComposer,
      $$LocalTransportStatusHistoryTableCreateCompanionBuilder,
      $$LocalTransportStatusHistoryTableUpdateCompanionBuilder,
      (
        LocalTransportStatusHistoryData,
        BaseReferences<
          _$AppDatabase,
          $LocalTransportStatusHistoryTable,
          LocalTransportStatusHistoryData
        >,
      ),
      LocalTransportStatusHistoryData,
      PrefetchHooks Function()
    >;
typedef $$LocalVehicleAssignmentsTableCreateCompanionBuilder =
    LocalVehicleAssignmentsCompanion Function({
      required String id,
      required String transportId,
      required String vehicleId,
      required DateTime assignedAt,
      Value<String> assignedBy,
      Value<DateTime?> releasedAt,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$LocalVehicleAssignmentsTableUpdateCompanionBuilder =
    LocalVehicleAssignmentsCompanion Function({
      Value<String> id,
      Value<String> transportId,
      Value<String> vehicleId,
      Value<DateTime> assignedAt,
      Value<String> assignedBy,
      Value<DateTime?> releasedAt,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$LocalVehicleAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVehicleAssignmentsTable> {
  $$LocalVehicleAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedBy => $composableBuilder(
    column: $table.assignedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVehicleAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVehicleAssignmentsTable> {
  $$LocalVehicleAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedBy => $composableBuilder(
    column: $table.assignedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVehicleAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVehicleAssignmentsTable> {
  $$LocalVehicleAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assignedBy => $composableBuilder(
    column: $table.assignedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$LocalVehicleAssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVehicleAssignmentsTable,
          LocalVehicleAssignment,
          $$LocalVehicleAssignmentsTableFilterComposer,
          $$LocalVehicleAssignmentsTableOrderingComposer,
          $$LocalVehicleAssignmentsTableAnnotationComposer,
          $$LocalVehicleAssignmentsTableCreateCompanionBuilder,
          $$LocalVehicleAssignmentsTableUpdateCompanionBuilder,
          (
            LocalVehicleAssignment,
            BaseReferences<
              _$AppDatabase,
              $LocalVehicleAssignmentsTable,
              LocalVehicleAssignment
            >,
          ),
          LocalVehicleAssignment,
          PrefetchHooks Function()
        > {
  $$LocalVehicleAssignmentsTableTableManager(
    _$AppDatabase db,
    $LocalVehicleAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVehicleAssignmentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalVehicleAssignmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalVehicleAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transportId = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<DateTime> assignedAt = const Value.absent(),
                Value<String> assignedBy = const Value.absent(),
                Value<DateTime?> releasedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVehicleAssignmentsCompanion(
                id: id,
                transportId: transportId,
                vehicleId: vehicleId,
                assignedAt: assignedAt,
                assignedBy: assignedBy,
                releasedAt: releasedAt,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transportId,
                required String vehicleId,
                required DateTime assignedAt,
                Value<String> assignedBy = const Value.absent(),
                Value<DateTime?> releasedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVehicleAssignmentsCompanion.insert(
                id: id,
                transportId: transportId,
                vehicleId: vehicleId,
                assignedAt: assignedAt,
                assignedBy: assignedBy,
                releasedAt: releasedAt,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $LocalVehicleAssignmentsTable,
                    LocalVehicleAssignment
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalVehicleAssignmentsTable,
                    LocalVehicleAssignment
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVehicleAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVehicleAssignmentsTable,
      LocalVehicleAssignment,
      $$LocalVehicleAssignmentsTableFilterComposer,
      $$LocalVehicleAssignmentsTableOrderingComposer,
      $$LocalVehicleAssignmentsTableAnnotationComposer,
      $$LocalVehicleAssignmentsTableCreateCompanionBuilder,
      $$LocalVehicleAssignmentsTableUpdateCompanionBuilder,
      (
        LocalVehicleAssignment,
        BaseReferences<
          _$AppDatabase,
          $LocalVehicleAssignmentsTable,
          LocalVehicleAssignment
        >,
      ),
      LocalVehicleAssignment,
      PrefetchHooks Function()
    >;
typedef $$LocalDriverAssignmentsTableCreateCompanionBuilder =
    LocalDriverAssignmentsCompanion Function({
      required String id,
      required String transportId,
      required String driverId,
      required DateTime assignedAt,
      Value<String> assignedBy,
      Value<DateTime?> releasedAt,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$LocalDriverAssignmentsTableUpdateCompanionBuilder =
    LocalDriverAssignmentsCompanion Function({
      Value<String> id,
      Value<String> transportId,
      Value<String> driverId,
      Value<DateTime> assignedAt,
      Value<String> assignedBy,
      Value<DateTime?> releasedAt,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$LocalDriverAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDriverAssignmentsTable> {
  $$LocalDriverAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driverId => $composableBuilder(
    column: $table.driverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedBy => $composableBuilder(
    column: $table.assignedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalDriverAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDriverAssignmentsTable> {
  $$LocalDriverAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driverId => $composableBuilder(
    column: $table.driverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedBy => $composableBuilder(
    column: $table.assignedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalDriverAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDriverAssignmentsTable> {
  $$LocalDriverAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driverId =>
      $composableBuilder(column: $table.driverId, builder: (column) => column);

  GeneratedColumn<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assignedBy => $composableBuilder(
    column: $table.assignedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get releasedAt => $composableBuilder(
    column: $table.releasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$LocalDriverAssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalDriverAssignmentsTable,
          LocalDriverAssignment,
          $$LocalDriverAssignmentsTableFilterComposer,
          $$LocalDriverAssignmentsTableOrderingComposer,
          $$LocalDriverAssignmentsTableAnnotationComposer,
          $$LocalDriverAssignmentsTableCreateCompanionBuilder,
          $$LocalDriverAssignmentsTableUpdateCompanionBuilder,
          (
            LocalDriverAssignment,
            BaseReferences<
              _$AppDatabase,
              $LocalDriverAssignmentsTable,
              LocalDriverAssignment
            >,
          ),
          LocalDriverAssignment,
          PrefetchHooks Function()
        > {
  $$LocalDriverAssignmentsTableTableManager(
    _$AppDatabase db,
    $LocalDriverAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDriverAssignmentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalDriverAssignmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalDriverAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transportId = const Value.absent(),
                Value<String> driverId = const Value.absent(),
                Value<DateTime> assignedAt = const Value.absent(),
                Value<String> assignedBy = const Value.absent(),
                Value<DateTime?> releasedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDriverAssignmentsCompanion(
                id: id,
                transportId: transportId,
                driverId: driverId,
                assignedAt: assignedAt,
                assignedBy: assignedBy,
                releasedAt: releasedAt,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transportId,
                required String driverId,
                required DateTime assignedAt,
                Value<String> assignedBy = const Value.absent(),
                Value<DateTime?> releasedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDriverAssignmentsCompanion.insert(
                id: id,
                transportId: transportId,
                driverId: driverId,
                assignedAt: assignedAt,
                assignedBy: assignedBy,
                releasedAt: releasedAt,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $LocalDriverAssignmentsTable,
                    LocalDriverAssignment
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalDriverAssignmentsTable,
                    LocalDriverAssignment
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalDriverAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalDriverAssignmentsTable,
      LocalDriverAssignment,
      $$LocalDriverAssignmentsTableFilterComposer,
      $$LocalDriverAssignmentsTableOrderingComposer,
      $$LocalDriverAssignmentsTableAnnotationComposer,
      $$LocalDriverAssignmentsTableCreateCompanionBuilder,
      $$LocalDriverAssignmentsTableUpdateCompanionBuilder,
      (
        LocalDriverAssignment,
        BaseReferences<
          _$AppDatabase,
          $LocalDriverAssignmentsTable,
          LocalDriverAssignment
        >,
      ),
      LocalDriverAssignment,
      PrefetchHooks Function()
    >;
typedef $$LocalNotificationLogsTableCreateCompanionBuilder =
    LocalNotificationLogsCompanion Function({
      required String id,
      required String transportId,
      Value<String?> partyId,
      required String recipientName,
      required String recipientMobile,
      Value<String> channel,
      required String messageBody,
      Value<String> status,
      required DateTime sentAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$LocalNotificationLogsTableUpdateCompanionBuilder =
    LocalNotificationLogsCompanion Function({
      Value<String> id,
      Value<String> transportId,
      Value<String?> partyId,
      Value<String> recipientName,
      Value<String> recipientMobile,
      Value<String> channel,
      Value<String> messageBody,
      Value<String> status,
      Value<DateTime> sentAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalNotificationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalNotificationLogsTable> {
  $$LocalNotificationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partyId => $composableBuilder(
    column: $table.partyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientName => $composableBuilder(
    column: $table.recipientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientMobile => $composableBuilder(
    column: $table.recipientMobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageBody => $composableBuilder(
    column: $table.messageBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalNotificationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalNotificationLogsTable> {
  $$LocalNotificationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partyId => $composableBuilder(
    column: $table.partyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientName => $composableBuilder(
    column: $table.recipientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientMobile => $composableBuilder(
    column: $table.recipientMobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageBody => $composableBuilder(
    column: $table.messageBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalNotificationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalNotificationLogsTable> {
  $$LocalNotificationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get partyId =>
      $composableBuilder(column: $table.partyId, builder: (column) => column);

  GeneratedColumn<String> get recipientName => $composableBuilder(
    column: $table.recipientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recipientMobile => $composableBuilder(
    column: $table.recipientMobile,
    builder: (column) => column,
  );

  GeneratedColumn<String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<String> get messageBody => $composableBuilder(
    column: $table.messageBody,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalNotificationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalNotificationLogsTable,
          LocalNotificationLog,
          $$LocalNotificationLogsTableFilterComposer,
          $$LocalNotificationLogsTableOrderingComposer,
          $$LocalNotificationLogsTableAnnotationComposer,
          $$LocalNotificationLogsTableCreateCompanionBuilder,
          $$LocalNotificationLogsTableUpdateCompanionBuilder,
          (
            LocalNotificationLog,
            BaseReferences<
              _$AppDatabase,
              $LocalNotificationLogsTable,
              LocalNotificationLog
            >,
          ),
          LocalNotificationLog,
          PrefetchHooks Function()
        > {
  $$LocalNotificationLogsTableTableManager(
    _$AppDatabase db,
    $LocalNotificationLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalNotificationLogsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalNotificationLogsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalNotificationLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transportId = const Value.absent(),
                Value<String?> partyId = const Value.absent(),
                Value<String> recipientName = const Value.absent(),
                Value<String> recipientMobile = const Value.absent(),
                Value<String> channel = const Value.absent(),
                Value<String> messageBody = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> sentAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalNotificationLogsCompanion(
                id: id,
                transportId: transportId,
                partyId: partyId,
                recipientName: recipientName,
                recipientMobile: recipientMobile,
                channel: channel,
                messageBody: messageBody,
                status: status,
                sentAt: sentAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transportId,
                Value<String?> partyId = const Value.absent(),
                required String recipientName,
                required String recipientMobile,
                Value<String> channel = const Value.absent(),
                required String messageBody,
                Value<String> status = const Value.absent(),
                required DateTime sentAt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalNotificationLogsCompanion.insert(
                id: id,
                transportId: transportId,
                partyId: partyId,
                recipientName: recipientName,
                recipientMobile: recipientMobile,
                channel: channel,
                messageBody: messageBody,
                status: status,
                sentAt: sentAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $LocalNotificationLogsTable,
                    LocalNotificationLog
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalNotificationLogsTable,
                    LocalNotificationLog
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalNotificationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalNotificationLogsTable,
      LocalNotificationLog,
      $$LocalNotificationLogsTableFilterComposer,
      $$LocalNotificationLogsTableOrderingComposer,
      $$LocalNotificationLogsTableAnnotationComposer,
      $$LocalNotificationLogsTableCreateCompanionBuilder,
      $$LocalNotificationLogsTableUpdateCompanionBuilder,
      (
        LocalNotificationLog,
        BaseReferences<
          _$AppDatabase,
          $LocalNotificationLogsTable,
          LocalNotificationLog
        >,
      ),
      LocalNotificationLog,
      PrefetchHooks Function()
    >;
typedef $$LocalPodDocumentsTableCreateCompanionBuilder =
    LocalPodDocumentsCompanion Function({
      required String id,
      required String transportId,
      required String fileName,
      required String storagePath,
      required String fileType,
      required BigInt fileSize,
      Value<String> uploadedBy,
      required DateTime uploadedAt,
      Value<String?> fileUrl,
      Value<String?> localFilePath,
      Value<int> rowid,
    });
typedef $$LocalPodDocumentsTableUpdateCompanionBuilder =
    LocalPodDocumentsCompanion Function({
      Value<String> id,
      Value<String> transportId,
      Value<String> fileName,
      Value<String> storagePath,
      Value<String> fileType,
      Value<BigInt> fileSize,
      Value<String> uploadedBy,
      Value<DateTime> uploadedAt,
      Value<String?> fileUrl,
      Value<String?> localFilePath,
      Value<int> rowid,
    });

class $$LocalPodDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPodDocumentsTable> {
  $$LocalPodDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<BigInt> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadedBy => $composableBuilder(
    column: $table.uploadedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileUrl => $composableBuilder(
    column: $table.fileUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPodDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPodDocumentsTable> {
  $$LocalPodDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<BigInt> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadedBy => $composableBuilder(
    column: $table.uploadedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileUrl => $composableBuilder(
    column: $table.fileUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPodDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPodDocumentsTable> {
  $$LocalPodDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<BigInt> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get uploadedBy => $composableBuilder(
    column: $table.uploadedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileUrl =>
      $composableBuilder(column: $table.fileUrl, builder: (column) => column);

  GeneratedColumn<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => column,
  );
}

class $$LocalPodDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPodDocumentsTable,
          LocalPodDocument,
          $$LocalPodDocumentsTableFilterComposer,
          $$LocalPodDocumentsTableOrderingComposer,
          $$LocalPodDocumentsTableAnnotationComposer,
          $$LocalPodDocumentsTableCreateCompanionBuilder,
          $$LocalPodDocumentsTableUpdateCompanionBuilder,
          (
            LocalPodDocument,
            BaseReferences<
              _$AppDatabase,
              $LocalPodDocumentsTable,
              LocalPodDocument
            >,
          ),
          LocalPodDocument,
          PrefetchHooks Function()
        > {
  $$LocalPodDocumentsTableTableManager(
    _$AppDatabase db,
    $LocalPodDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPodDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPodDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalPodDocumentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transportId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> storagePath = const Value.absent(),
                Value<String> fileType = const Value.absent(),
                Value<BigInt> fileSize = const Value.absent(),
                Value<String> uploadedBy = const Value.absent(),
                Value<DateTime> uploadedAt = const Value.absent(),
                Value<String?> fileUrl = const Value.absent(),
                Value<String?> localFilePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPodDocumentsCompanion(
                id: id,
                transportId: transportId,
                fileName: fileName,
                storagePath: storagePath,
                fileType: fileType,
                fileSize: fileSize,
                uploadedBy: uploadedBy,
                uploadedAt: uploadedAt,
                fileUrl: fileUrl,
                localFilePath: localFilePath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transportId,
                required String fileName,
                required String storagePath,
                required String fileType,
                required BigInt fileSize,
                Value<String> uploadedBy = const Value.absent(),
                required DateTime uploadedAt,
                Value<String?> fileUrl = const Value.absent(),
                Value<String?> localFilePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPodDocumentsCompanion.insert(
                id: id,
                transportId: transportId,
                fileName: fileName,
                storagePath: storagePath,
                fileType: fileType,
                fileSize: fileSize,
                uploadedBy: uploadedBy,
                uploadedAt: uploadedAt,
                fileUrl: fileUrl,
                localFilePath: localFilePath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalPodDocumentsTable, LocalPodDocument>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalPodDocumentsTable,
                    LocalPodDocument
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPodDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPodDocumentsTable,
      LocalPodDocument,
      $$LocalPodDocumentsTableFilterComposer,
      $$LocalPodDocumentsTableOrderingComposer,
      $$LocalPodDocumentsTableAnnotationComposer,
      $$LocalPodDocumentsTableCreateCompanionBuilder,
      $$LocalPodDocumentsTableUpdateCompanionBuilder,
      (
        LocalPodDocument,
        BaseReferences<
          _$AppDatabase,
          $LocalPodDocumentsTable,
          LocalPodDocument
        >,
      ),
      LocalPodDocument,
      PrefetchHooks Function()
    >;
typedef $$LocalActivityLogsTableCreateCompanionBuilder =
    LocalActivityLogsCompanion Function({
      required String id,
      Value<String?> transportId,
      Value<String?> userId,
      required String action,
      required String description,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LocalActivityLogsTableUpdateCompanionBuilder =
    LocalActivityLogsCompanion Function({
      Value<String> id,
      Value<String?> transportId,
      Value<String?> userId,
      Value<String> action,
      Value<String> description,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalActivityLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalActivityLogsTable> {
  $$LocalActivityLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalActivityLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalActivityLogsTable> {
  $$LocalActivityLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalActivityLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalActivityLogsTable> {
  $$LocalActivityLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalActivityLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalActivityLogsTable,
          LocalActivityLog,
          $$LocalActivityLogsTableFilterComposer,
          $$LocalActivityLogsTableOrderingComposer,
          $$LocalActivityLogsTableAnnotationComposer,
          $$LocalActivityLogsTableCreateCompanionBuilder,
          $$LocalActivityLogsTableUpdateCompanionBuilder,
          (
            LocalActivityLog,
            BaseReferences<
              _$AppDatabase,
              $LocalActivityLogsTable,
              LocalActivityLog
            >,
          ),
          LocalActivityLog,
          PrefetchHooks Function()
        > {
  $$LocalActivityLogsTableTableManager(
    _$AppDatabase db,
    $LocalActivityLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalActivityLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalActivityLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalActivityLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> transportId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalActivityLogsCompanion(
                id: id,
                transportId: transportId,
                userId: userId,
                action: action,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> transportId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                required String action,
                required String description,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalActivityLogsCompanion.insert(
                id: id,
                transportId: transportId,
                userId: userId,
                action: action,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalActivityLogsTable, LocalActivityLog>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalActivityLogsTable,
                    LocalActivityLog
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalActivityLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalActivityLogsTable,
      LocalActivityLog,
      $$LocalActivityLogsTableFilterComposer,
      $$LocalActivityLogsTableOrderingComposer,
      $$LocalActivityLogsTableAnnotationComposer,
      $$LocalActivityLogsTableCreateCompanionBuilder,
      $$LocalActivityLogsTableUpdateCompanionBuilder,
      (
        LocalActivityLog,
        BaseReferences<
          _$AppDatabase,
          $LocalActivityLogsTable,
          LocalActivityLog
        >,
      ),
      LocalActivityLog,
      PrefetchHooks Function()
    >;
typedef $$LocalSyncQueueTableCreateCompanionBuilder =
    LocalSyncQueueCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String operation,
      required String payload,
      required DateTime createdAt,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$LocalSyncQueueTableUpdateCompanionBuilder =
    LocalSyncQueueCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$LocalSyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSyncQueueTable> {
  $$LocalSyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSyncQueueTable> {
  $$LocalSyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSyncQueueTable> {
  $$LocalSyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$LocalSyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSyncQueueTable,
          LocalSyncQueueData,
          $$LocalSyncQueueTableFilterComposer,
          $$LocalSyncQueueTableOrderingComposer,
          $$LocalSyncQueueTableAnnotationComposer,
          $$LocalSyncQueueTableCreateCompanionBuilder,
          $$LocalSyncQueueTableUpdateCompanionBuilder,
          (
            LocalSyncQueueData,
            BaseReferences<
              _$AppDatabase,
              $LocalSyncQueueTable,
              LocalSyncQueueData
            >,
          ),
          LocalSyncQueueData,
          PrefetchHooks Function()
        > {
  $$LocalSyncQueueTableTableManager(
    _$AppDatabase db,
    $LocalSyncQueueTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSyncQueueCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                retryCount: retryCount,
                lastError: lastError,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operation,
                required String payload,
                required DateTime createdAt,
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSyncQueueCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                retryCount: retryCount,
                lastError: lastError,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSyncQueueTable, LocalSyncQueueData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalSyncQueueTable,
                    LocalSyncQueueData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSyncQueueTable,
      LocalSyncQueueData,
      $$LocalSyncQueueTableFilterComposer,
      $$LocalSyncQueueTableOrderingComposer,
      $$LocalSyncQueueTableAnnotationComposer,
      $$LocalSyncQueueTableCreateCompanionBuilder,
      $$LocalSyncQueueTableUpdateCompanionBuilder,
      (
        LocalSyncQueueData,
        BaseReferences<_$AppDatabase, $LocalSyncQueueTable, LocalSyncQueueData>,
      ),
      LocalSyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$LocalTransportAllocationsTableCreateCompanionBuilder =
    LocalTransportAllocationsCompanion Function({
      required String id,
      required String transportId,
      required int slotIndex,
      required String vehicleId,
      required String vehicleNumber,
      Value<String?> driverId,
      Value<String?> driverName,
      Value<String?> driverMobile,
      required DateTime assignedAt,
      Value<int> rowid,
    });
typedef $$LocalTransportAllocationsTableUpdateCompanionBuilder =
    LocalTransportAllocationsCompanion Function({
      Value<String> id,
      Value<String> transportId,
      Value<int> slotIndex,
      Value<String> vehicleId,
      Value<String> vehicleNumber,
      Value<String?> driverId,
      Value<String?> driverName,
      Value<String?> driverMobile,
      Value<DateTime> assignedAt,
      Value<int> rowid,
    });

class $$LocalTransportAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalTransportAllocationsTable> {
  $$LocalTransportAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slotIndex => $composableBuilder(
    column: $table.slotIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driverId => $composableBuilder(
    column: $table.driverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driverName => $composableBuilder(
    column: $table.driverName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driverMobile => $composableBuilder(
    column: $table.driverMobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTransportAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalTransportAllocationsTable> {
  $$LocalTransportAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slotIndex => $composableBuilder(
    column: $table.slotIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driverId => $composableBuilder(
    column: $table.driverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driverName => $composableBuilder(
    column: $table.driverName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driverMobile => $composableBuilder(
    column: $table.driverMobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTransportAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalTransportAllocationsTable> {
  $$LocalTransportAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transportId => $composableBuilder(
    column: $table.transportId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get slotIndex =>
      $composableBuilder(column: $table.slotIndex, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driverId =>
      $composableBuilder(column: $table.driverId, builder: (column) => column);

  GeneratedColumn<String> get driverName => $composableBuilder(
    column: $table.driverName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driverMobile => $composableBuilder(
    column: $table.driverMobile,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => column,
  );
}

class $$LocalTransportAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalTransportAllocationsTable,
          LocalTransportAllocation,
          $$LocalTransportAllocationsTableFilterComposer,
          $$LocalTransportAllocationsTableOrderingComposer,
          $$LocalTransportAllocationsTableAnnotationComposer,
          $$LocalTransportAllocationsTableCreateCompanionBuilder,
          $$LocalTransportAllocationsTableUpdateCompanionBuilder,
          (
            LocalTransportAllocation,
            BaseReferences<
              _$AppDatabase,
              $LocalTransportAllocationsTable,
              LocalTransportAllocation
            >,
          ),
          LocalTransportAllocation,
          PrefetchHooks Function()
        > {
  $$LocalTransportAllocationsTableTableManager(
    _$AppDatabase db,
    $LocalTransportAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTransportAllocationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalTransportAllocationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalTransportAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transportId = const Value.absent(),
                Value<int> slotIndex = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> vehicleNumber = const Value.absent(),
                Value<String?> driverId = const Value.absent(),
                Value<String?> driverName = const Value.absent(),
                Value<String?> driverMobile = const Value.absent(),
                Value<DateTime> assignedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTransportAllocationsCompanion(
                id: id,
                transportId: transportId,
                slotIndex: slotIndex,
                vehicleId: vehicleId,
                vehicleNumber: vehicleNumber,
                driverId: driverId,
                driverName: driverName,
                driverMobile: driverMobile,
                assignedAt: assignedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transportId,
                required int slotIndex,
                required String vehicleId,
                required String vehicleNumber,
                Value<String?> driverId = const Value.absent(),
                Value<String?> driverName = const Value.absent(),
                Value<String?> driverMobile = const Value.absent(),
                required DateTime assignedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalTransportAllocationsCompanion.insert(
                id: id,
                transportId: transportId,
                slotIndex: slotIndex,
                vehicleId: vehicleId,
                vehicleNumber: vehicleNumber,
                driverId: driverId,
                driverName: driverName,
                driverMobile: driverMobile,
                assignedAt: assignedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $LocalTransportAllocationsTable,
                    LocalTransportAllocation
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalTransportAllocationsTable,
                    LocalTransportAllocation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTransportAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalTransportAllocationsTable,
      LocalTransportAllocation,
      $$LocalTransportAllocationsTableFilterComposer,
      $$LocalTransportAllocationsTableOrderingComposer,
      $$LocalTransportAllocationsTableAnnotationComposer,
      $$LocalTransportAllocationsTableCreateCompanionBuilder,
      $$LocalTransportAllocationsTableUpdateCompanionBuilder,
      (
        LocalTransportAllocation,
        BaseReferences<
          _$AppDatabase,
          $LocalTransportAllocationsTable,
          LocalTransportAllocation
        >,
      ),
      LocalTransportAllocation,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalVehiclesTableTableManager get localVehicles =>
      $$LocalVehiclesTableTableManager(_db, _db.localVehicles);
  $$LocalDriversTableTableManager get localDrivers =>
      $$LocalDriversTableTableManager(_db, _db.localDrivers);
  $$LocalPartiesTableTableManager get localParties =>
      $$LocalPartiesTableTableManager(_db, _db.localParties);
  $$LocalShippingLinesTableTableManager get localShippingLines =>
      $$LocalShippingLinesTableTableManager(_db, _db.localShippingLines);
  $$LocalLocationsTableTableManager get localLocations =>
      $$LocalLocationsTableTableManager(_db, _db.localLocations);
  $$LocalPortsCfsTableTableManager get localPortsCfs =>
      $$LocalPortsCfsTableTableManager(_db, _db.localPortsCfs);
  $$LocalTransportsTableTableManager get localTransports =>
      $$LocalTransportsTableTableManager(_db, _db.localTransports);
  $$LocalTransportStatusHistoryTableTableManager
  get localTransportStatusHistory =>
      $$LocalTransportStatusHistoryTableTableManager(
        _db,
        _db.localTransportStatusHistory,
      );
  $$LocalVehicleAssignmentsTableTableManager get localVehicleAssignments =>
      $$LocalVehicleAssignmentsTableTableManager(
        _db,
        _db.localVehicleAssignments,
      );
  $$LocalDriverAssignmentsTableTableManager get localDriverAssignments =>
      $$LocalDriverAssignmentsTableTableManager(
        _db,
        _db.localDriverAssignments,
      );
  $$LocalNotificationLogsTableTableManager get localNotificationLogs =>
      $$LocalNotificationLogsTableTableManager(_db, _db.localNotificationLogs);
  $$LocalPodDocumentsTableTableManager get localPodDocuments =>
      $$LocalPodDocumentsTableTableManager(_db, _db.localPodDocuments);
  $$LocalActivityLogsTableTableManager get localActivityLogs =>
      $$LocalActivityLogsTableTableManager(_db, _db.localActivityLogs);
  $$LocalSyncQueueTableTableManager get localSyncQueue =>
      $$LocalSyncQueueTableTableManager(_db, _db.localSyncQueue);
  $$LocalTransportAllocationsTableTableManager get localTransportAllocations =>
      $$LocalTransportAllocationsTableTableManager(
        _db,
        _db.localTransportAllocations,
      );
}
