import 'package:flutter/material.dart';
import 'about_page.dart';
import 'modules_page.dart';
import 'theme_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            SettingsTile(icon: Icons.extension, title: 'Модули', subtitle: 'Подключение к матрице', page: ModulesSettingsPage()),
            SettingsTile(icon: Icons.light_mode, title: 'Тема', subtitle: 'Настройки темы', page: ThemePage()),
            SettingsTile(icon: Icons.info, title: 'О приложении', subtitle: 'Информация о приложении', page: AboutPage()),
          ]
        ),
      )
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? page;
  const SettingsTile({super.key, required this.icon, required this.title, required this.subtitle, this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (page != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => page!));
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 16),
              child: Icon(icon),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            )
          ]
        ),
      ),
    );
  }
}