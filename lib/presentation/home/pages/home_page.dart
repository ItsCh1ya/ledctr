import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:ledctrl/domain/entity/module_info.dart';
import 'package:ledctrl/get_it.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedModule = getIt<SelectedModule>().module;
    return Scaffold(
        appBar: AppBar(
          title: Text((selectedModule == null) ? 'Не подключенно' : '${selectedModule!.name}'), // name if not null
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed('settings');
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MasonryGridView.count(
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
                  onTap: () {
                    
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
              int height = (index % 2 == 0) ? 200 : 300;
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "https://loremflickr.com/200/$height?id=$index",
                ),
              );
            },
          ),
        ));
  }
}
