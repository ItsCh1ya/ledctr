import 'package:ledctrl/get_it.dart';

import '../../data/local/dao/module_info_dao.dart';
import '../entity/module_info.dart';

class GetModulesUseCase {
  Future<List<ModuleInfo>> execute() async {
    final dao = getIt.get<ModuleInfoDao>();
    return await dao.findAllModules();
  }
}