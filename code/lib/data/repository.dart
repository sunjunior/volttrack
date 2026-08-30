import 'package:drift/drift.dart';
import '../core/models/charge.dart';
import 'tables.dart';

class AppRepository {
  final AppDatabase db;
  AppRepository(this.db);

  static Value<T> _v<T>(T? x) => x == null ? const Value.absent() : Value<T>(x);

  Stream<List<ChargeRecord>> watchCharges() => (db.select(db.charges)
        ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
      .watch()
      .map((rows) => rows.map(_toCharge).toList());

  Stream<List<Battery>> watchBatteries() => db.select(db.batteries).watch();

  Stream<Battery?> activeBattery() async* {
    await for (final rows in watchBatteries()) {
      Battery? found;
      for (final r in rows) {
        if (r.active) {
          found = r;
          break;
        }
      }
      yield found;
    }
  }

  Future<int> addCharge({required ChargeRecord c}) => db.into(db.charges).insert(ChargesCompanion.insert(
        batteryId: c.batteryId,
        occurredAt: c.occurredAt,
        mode: c.mode,
        energyKwh: c.energyKwh,
        energySource: c.energySource,
        moneyYuan: _v(c.moneyYuan),
        hours: _v(c.hours),
        chargerPowerW: _v(c.chargerPowerW),
        priceDesc: _v(c.priceDesc),
        socBeforePct: c.socBeforePct == null ? const Value.absent() : Value(c.socBeforePct),
        socAfterPct: c.socAfterPct == null ? const Value.absent() : Value(c.socAfterPct),
        mileageKm: _v(c.mileageKm),
        note: _v(c.note),
      ));

  Future<void> deleteCharge(int id) async {
    await (db.delete(db.charges)..where((t) => t.id.equals(id))).go();
  }

  ChargeRecord _toCharge(Charge row) => ChargeRecord(
        id: row.id, batteryId: row.batteryId, occurredAt: row.occurredAt,
        mode: row.mode, energyKwh: row.energyKwh, energySource: row.energySource,
        moneyYuan: row.moneyYuan, hours: row.hours, chargerPowerW: row.chargerPowerW,
        priceDesc: row.priceDesc, socBeforePct: row.socBeforePct,
        socAfterPct: row.socAfterPct, mileageKm: row.mileageKm, note: row.note,
      );
}
