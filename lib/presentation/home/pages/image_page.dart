import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/typed_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/options.dart';
import 'package:ledctrl/domain/entity/module_info.dart';
import 'package:ledctrl/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:flutter_image_converter/flutter_image_converter.dart';
import 'package:image/image.dart' as img;

class ImagePage extends StatefulWidget {
  final ImageProvider image;
  ImagePage({super.key, required this.image});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  ImageProvider? image;

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  bool isHorizontal = true;
  @override
  Widget build(BuildContext context) {
    SelectedModule selectedModule = getIt<SelectedModule>();
    return Scaffold(
        appBar: PreferredSize(child: Hero(child: AppBar(title: const Text('Изображение')), tag: AppBar,), preferredSize: AppBar().preferredSize,),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(onPressed: () async {
              final bytes = await image?.getBytes(context);
              final editedImage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    image: bytes,
                    outputFormat: OutputFormat.png,
                  ),
                ),
              );
              img.Image imgimage = (editedImage as Uint8List).imageImageSync;
              imgimage = img.trim(imgimage);
              imgimage = img.copyResize(imgimage, width: selectedModule.module!.size.width, height: selectedModule.module!.size.height);
              setState(() {
                image = imgimage.imageProviderSync;
              });
            }, child: Icon(Icons.edit),),
            SizedBox(width: 10,),
            FloatingActionButton(onPressed: () async {
              image?.getBytes(context).then((value) async {
              Directory docsDir = await getApplicationDocumentsDirectory();
              File file = File(docsDir.path + '/modules/' + selectedModule.module!.path.split('/').last);
            
              ByteData compiled = file.readAsBytesSync().buffer.asByteData();
              final runtime = Runtime(compiled);
              runtime.executeLib('package:module/main.dart', 'sendImage', [
                $Closure((runtime, target, args) {
                  final reified = args[0]!.$reified;
                  Dio dio = Dio();
                  dio.options.connectTimeout = Duration(milliseconds:  reified['timeout']);
                  dio.options.contentType = Headers.jsonContentType;
                  dio.post(reified['url'], data: jsonEncode(reified['body']));
                }),
                $Uint8List.wrap(value!),
              ]);
              });
            }, child: const Icon(Icons.send),),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              (image == Null) ?
              Hero(
                tag: widget.image,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: double.infinity,
                    child:  (isHorizontal) ? Image(
                      image: widget.image,
                      fit: BoxFit.cover,
                    ) : Transform.rotate(angle: 90 * 3.14 / 180, child: Image(image: widget.image, fit: BoxFit.cover,)),
                  ),
                ),
              )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: double.infinity,
                    child:  (isHorizontal) ? Image(
                      image: image!,
                      fit: BoxFit.cover,
                    ) : Transform.rotate(angle: 90 * 3.14 / 180, child: Image(image: image!, fit: BoxFit.cover,)),
                  ),
                )
            ]),
          ),
        ));
  }
}

extension ImageTool on ImageProvider {
  Future<Uint8List?> getBytes(BuildContext context, {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {
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