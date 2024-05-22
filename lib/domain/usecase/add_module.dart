import 'package:ledctrl/get_it.dart';

import '../../data/local/dao/module_info_dao.dart';
import '../entity/module_info.dart';

class AddModuleUseCase {
  Future<void> execute(ModuleInfo moduleInfo) async {
    final dao = getIt.get<ModuleInfoDao>();
    await dao.insertModule(moduleInfo);
  }
}