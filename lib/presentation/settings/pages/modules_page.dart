import 'dart:io';
import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledctrl/domain/entity/module_info.dart';
import 'package:ledctrl/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../bloc/module_info_bloc.dart';

class ModulesSettingsPage extends StatefulWidget {
  const ModulesSettingsPage({super.key});

  @override
  State<ModulesSettingsPage> createState() => _ModulesSettingsPageState();
}

class _ModulesSettingsPageState extends State<ModulesSettingsPage> {
  Directory? _directory;
  List<FileSystemEntity>? _modulesFilePaths;
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Модули'),
          centerTitle: true,
        ),
        body: BlocProvider(
                create: (context) => getIt<ModuleInfoBloc>()..add(ModuleInfoGetAll()),
                child: BlocBuilder<ModuleInfoBloc, ModuleInfoState>(
                  builder: (context, state) {
                    //fetch modules
                    if (state is ModuleInfoLoaded && state.modules.isNotEmpty) {
                      return Column(
                        children: [
                          Flexible(
                            child: ListView.builder(
                              itemCount: state.modules.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    getIt<SelectedModule>().module = state.modules[index];
                                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                                  },
                                  child: Ink(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(state.modules[index].name, style: Theme.of(context).textTheme.titleLarge),
                                            Text(state.modules[index].description, style: Theme.of(context).textTheme.bodyMedium),
                                          ],
                                        ),
                                        Text("${state.modules[index].size.height}x${state.modules[index].size.width}", style: Theme.of(context).textTheme.titleLarge,),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          OutlinedButton(
                              onPressed: () async {
                                await pickModule(context);
                              },
                              child: Text('Открыть из памяти устройства')),
                          ElevatedButton( // TODO: implement download from internet
                              onPressed: () {},
                              child: Text('Загрузить из интернета')),
                          SizedBox(height: 20),
                        ],
                      );
                    } else if (state is ModuleInfoLoaded && state.modules.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Модули не найдены',
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          OutlinedButton(
                              onPressed: () async {
                                await pickModule(context);
                              },
                              child: Text('Открыть из памяти устройства')),
                          ElevatedButton( // TODO: implement download from internet
                              onPressed: () {},
                              child: Text('Загрузить из интернета'))
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
    );
  }

  Future<void> pickModule(BuildContext context) async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      final compiler = Compiler();
      final program = compiler.compile({
        'module': {'main.dart': file.readAsStringSync()}
      });
      final runtime = Runtime.ofProgram(program);
      runtime.executeLib('package:module/main.dart', 'getInfo', [
        $Closure((runtime, target, args) {
          final Map reified = args[0]!.$reified;
          ModuleInfo modul = ModuleInfo(
              name: reified['name'],
              description: reified['description'],
              version: reified['version'],
              author: reified['author'],
              colorDeph: reified['colorDeph'],
              size: MatrixSize(
                  reified['size']['width'], reified['size']['height']),
              connection: switch (reified['connection']) {
                "wifi" => ConnectionType.wifi,
                "bluetooth" => ConnectionType.bluetooth,
                "usb" => ConnectionType.serial,
                _ => ConnectionType.wifi,
              },
              path: "${docsDir.path}/modules/${file.uri.pathSegments.last}");
          final bytecode = program.write();
          
          getIt<ModuleInfoBloc>()..add(ModuleInfoAddModule(modul));
          // write to file in docs
          var fil = File(modul.path);
          fil.writeAsBytesSync(bytecode);
          return null;
        })
      ]);
    }
  }
}
