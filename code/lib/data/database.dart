import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';

AppDatabase openDatabase() => AppDatabase(driftDatabase(name: 'volttrack'));