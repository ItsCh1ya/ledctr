import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:ledctrl/presentation/settings/bloc/module_info_bloc.dart';

import 'data/local/dao/module_info_dao.dart';
import 'data/local/database.dart';
import 'domain/entity/module_info.dart';
import 'domain/usecase/add_module.dart';
import 'domain/usecase/get_modules.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton<SelectedModule>(SelectedModule(null));
    final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  
  getIt.registerSingleton<AppDatabase>(database);

  // Add more DAO registrations if needed
  getIt.registerSingleton<ModuleInfoDao>(database.moduleInfoDao);

  // UseCases
  getIt.registerSingleton<GetModulesUseCase>(GetModulesUseCase());
  getIt.registerSingleton<AddModuleUseCase>(AddModuleUseCase());

  // Bloc
  getIt.registerFactory<ModuleInfoBloc>(() => ModuleInfoBloc(getIt(), getIt()));

}