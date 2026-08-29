import 'package:drift/drift.dart';
import '../core/models/battery.dart';
import '../core/models/charge.dart';

part 'tables.g.dart';

@DriftDatabase(tables: [Vehicles, Batteries, Charges])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}

class Vehicles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  RealColumn get initialMileageKm => real().withDefault(const Constant(0))();
  IntColumn get initialSocPct => integer().nullable()();
  TextColumn get note => text().nullable()();
}

class Batteries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId => integer().references(Vehicles, #id)();
  TextColumn get name => text()();
  TextColumn get type => textEnum<BatteryType>()();
  RealColumn get voltageV => real()();
  RealColumn get capacityAh => real()();
  RealColumn get overrideCapacityKwh => real().nullable()();
  RealColumn get theoreticalRangeKm => real().nullable()();
  DateTimeColumn get installedAt => dateTime()();
  DateTimeColumn get deactivatedAt => dateTime().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class Charges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get batteryId => integer().references(Batteries, #id)();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get mode => textEnum<ChargeMode>()();
  RealColumn get energyKwh => real()();
  TextColumn get energySource => textEnum<EnergySource>()();
  RealColumn get moneyYuan => real().nullable()();
  RealColumn get hours => real().nullable()();
  RealColumn get chargerPowerW => real().nullable()();
  TextColumn get priceDesc => text().nullable()();
  IntColumn get socBeforePct => integer().nullable()();
  IntColumn get socAfterPct => integer().nullable()();
  RealColumn get mileageKm => real().nullable()();
  TextColumn get note => text().nullable()();
}