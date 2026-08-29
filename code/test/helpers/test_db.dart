import 'package:drift/native.dart';
import 'package:volttrack/data/tables.dart';

AppDatabase openNullDatabase() => AppDatabase(NativeDatabase.memory());