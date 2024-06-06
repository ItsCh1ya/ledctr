import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) => setState(() => _packageInfo = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Версия ${_packageInfo?.version}", style: Theme.of(context).textTheme.titleLarge),
            Text("Релиз ${_packageInfo?.buildNumber}", style: Theme.of(context).textTheme.titleLarge),
            Text("Автор Куделин Вадим", style: Theme.of(context).textTheme.titleLarge),
            Text("k.vad2@yandex.ru", style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}