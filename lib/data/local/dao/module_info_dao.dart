import 'package:floor/floor.dart';
import 'package:ledctrl/domain/entity/module_info.dart';

@dao
abstract class ModuleInfoDao {
  @Query('SELECT * FROM module_info')
  Future<List<ModuleInfo>> findAllModules();

  @Query('SELECT * FROM module_info WHERE name = :name')
  Future<ModuleInfo?> findModuleByName(String name);

  @insert
  Future<void> insertModule(ModuleInfo module);

  @update
  Future<void> updateModule(ModuleInfo module);

  @delete
  Future<void> deleteModule(ModuleInfo module);
}
