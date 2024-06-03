import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:ledctrl/domain/entity/module_info.dart';
import 'package:ledctrl/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;


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
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: Hero(
            tag: AppBar,
            child: AppBar(
              title: Text((selectedModule == null) ? 'Не подключенно' : '${selectedModule.name}'), // name if not null
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
          ),
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
                    //FIXME: adds white lines for some reason
                    img.Image blankImage = img.Image(width: selectedModule!.size.width, height: selectedModule!.size.height);
                    Uint8List bytes = Uint8List.fromList(img.encodePng(blankImage));


                    final editedImage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageEditor(
                          image: bytes,
                        ),
                      ),
                    );

                    if (editedImage != null) {
                      ImageProvider imageProvider = ResizeImage(MemoryImage(editedImage), width: selectedModule!.size.width, height: selectedModule!.size.height);
                      
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagePage(image: imageProvider)));
                    }
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
                    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                    if (result != null) {
                      File file = File(result.files.single.path!);
                      Uint8List bytes = file.readAsBytesSync();
                      ImageProvider imageProvider = MemoryImage(bytes);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagePage(image: imageProvider)));
                    }
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
              return Hero(
                tag: src,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(child: Image(image: src, fit: BoxFit.fill,), onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePage(image: src)));
                  },)
                ),
              );
            },
        ))
    );
  }
}
