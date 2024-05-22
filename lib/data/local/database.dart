import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

import '../../domain/entity/module_info.dart';
import 'converter/connection_type_converter.dart';
import 'converter/matrix_size_converter.dart';
import 'dao/module_info_dao.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [ModuleInfo])
abstract class AppDatabase extends FloorDatabase {
  ModuleInfoDao get moduleInfoDao;
}
