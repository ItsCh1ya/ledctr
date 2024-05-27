import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/typed_data.dart';
import 'package:flutter/material.dart';
import 'package:ledctrl/domain/entity/module_info.dart';
import 'package:ledctrl/get_it.dart';
import 'package:path_provider/path_provider.dart';

class ImagePage extends StatefulWidget {
  final ImageProvider image;
  ImagePage({super.key, required this.image});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  bool isHorizontal = true;
  @override
  Widget build(BuildContext context) {
    SelectedModule selectedModule = getIt<SelectedModule>();
    return Scaffold(
        appBar: AppBar(title: const Text('Изображение')),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          widget.image.getBytes(context).then((value) async {
          Directory docsDir = await getApplicationDocumentsDirectory();
          File file = File(docsDir.path + '/modules/' + selectedModule.module!.path.split('/').last);

          ByteData compiled = file.readAsBytesSync().buffer.asByteData();
          final runtime = Runtime(compiled);
          runtime.executeLib('package:module/main.dart', 'sendImage', [
            $Closure((runtime, target, args) {
              final reified = args[0]!.$reified;
              print(reified);
            }),
            $Uint8List.wrap(value!),
          ]);
          });
        }, child: const Icon(Icons.send),),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: double.infinity,
                  child:  (isHorizontal) ? Image(
                    image: widget.image,
                    fit: BoxFit.cover,
                  ) : Transform.rotate(angle: 90 * 3.14 / 180, child: Image(image: widget.image, fit: BoxFit.cover,)),
                ),
              )
            ]),
          ),
        ));
  }
}

extension ImageTool on ImageProvider {
  Future<Uint8List?> getBytes(BuildContext context, {ImageByteFormat format = ImageByteFormat.rawRgba}) async {
    final imageStream = resolve(createLocalImageConfiguration(context));
    final Completer<Uint8List?> completer = Completer<Uint8List?>();
    final ImageStreamListener listener = ImageStreamListener(
      (imageInfo, synchronousCall) async {
        final bytes = await imageInfo.image.toByteData(format: format);
        if (!completer.isCompleted) {
          completer.complete(bytes?.buffer.asUint8List());
        }
      },
    );
    imageStream.addListener(listener);
    final imageBytes = await completer.future;
    imageStream.removeListener(listener);
    return imageBytes;
  }
}