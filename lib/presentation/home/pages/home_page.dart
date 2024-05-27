import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:ledctrl/domain/entity/module_info.dart';
import 'package:ledctrl/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'image_page.dart';

class HomePage extends StatefulWidget {
  final SelectedModule? selectedModule;
  const HomePage({super.key, this.selectedModule});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SelectedModule? selectedModule = getIt<SelectedModule>();

  @override
  Widget build(BuildContext context) {
    ModuleInfo? selectedModule = getIt<SelectedModule>().module;
    return Scaffold(
        appBar: AppBar(
          title: Text((selectedModule == null) ? 'Не подключенно' : '${selectedModule!.name}'), // name if not null
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                final value = await Navigator.of(context).pushNamed('settings');
                setState(() {
                  selectedModule = getIt<SelectedModule>().module;
                });
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: (selectedModule == null) ? Center(child: Text("Подключитесь к модулю в настройках")) :
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    Uint8List bytes = (await NetworkAssetBundle(Uri.parse('https://loremflickr.com/200/300'))
                      .load('https://loremflickr.com/200/300'))
                      .buffer
                      .asUint8List();

                    final editedImage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageEditor(
                          image: bytes,
                        ),
                      ),
                    );
                  },
                  child: Ink(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondaryContainer, size: 50,),
                  ),
                );
              } else if (index == 1) {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    Directory docsDir = await getApplicationDocumentsDirectory();
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                  },
                  child: Ink(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    child: Icon(Icons.add_photo_alternate, color: Theme.of(context).colorScheme.onSecondaryContainer, size: 50,),
                  ),
                );
              }
              int height = selectedModule!.size.height;
              int width = selectedModule!.size.width;
              ImageProvider src = NetworkImage((index % 2 == 0) ? "https://loremflickr.com/$width/$height?id=$index" : "https://loremflickr.com/$height/$width?id=$index");
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GestureDetector(child: Image(image: src, fit: BoxFit.fill,), onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePage(image: src)));
                },)
              );
            },
        ))
    );
  }
}
