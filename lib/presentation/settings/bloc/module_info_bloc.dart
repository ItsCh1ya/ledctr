import 'package:bloc/bloc.dart';
import 'package:ledctrl/domain/entity/module_info.dart';
import 'package:ledctrl/domain/usecase/add_module.dart';
import 'package:ledctrl/domain/usecase/get_modules.dart';
import 'package:meta/meta.dart';

part 'module_info_event.dart';
part 'module_info_state.dart';

class ModuleInfoBloc extends Bloc<ModuleInfoEvent, ModuleInfoState> {
  final GetModulesUseCase getModulesUseCase;
  final AddModuleUseCase addModuleUseCase;
  ModuleInfoBloc(this.getModulesUseCase, this.addModuleUseCase) : super(ModuleInfoInitial()) {
    on<ModuleInfoGetAll>((event, emit) async {
      emit(ModuleInfoLoading());
      List<ModuleInfo> modules = await getModulesUseCase.execute();
      emit(ModuleInfoLoaded(modules: modules));
    });
    on<ModuleInfoAddModule>((event, emit) async {
      emit(ModuleInfoLoading());
      await addModuleUseCase.execute(event.moduleInfo);
      List<ModuleInfo> modules = await getModulesUseCase.execute();
      emit(ModuleInfoLoaded(modules: modules));
    });
  }
}
