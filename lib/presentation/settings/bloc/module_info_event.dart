part of 'module_info_bloc.dart';

@immutable
sealed class ModuleInfoEvent {}

class ModuleInfoGetAll extends ModuleInfoEvent {
  ModuleInfoGetAll();

  @override
  List<Object> get props => [];
}

class ModuleInfoAddModule extends ModuleInfoEvent {
  ModuleInfoAddModule(this.moduleInfo);

  final ModuleInfo moduleInfo;

  @override
  List<Object> get props => [moduleInfo];
}