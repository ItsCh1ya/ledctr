part of 'module_info_bloc.dart';

@immutable
sealed class ModuleInfoState {}

final class ModuleInfoInitial extends ModuleInfoState {}

final class ModuleInfoLoading extends ModuleInfoState {}

final class ModuleInfoLoaded extends ModuleInfoState {
  final List<ModuleInfo> modules;
  ModuleInfoLoaded({required this.modules});
}

final class ModuleInfoError extends ModuleInfoState {
  final String message;
  ModuleInfoError({required this.message});
}