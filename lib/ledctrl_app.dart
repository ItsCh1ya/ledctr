import 'package:flutter/material.dart';
import 'package:ledctrl/config/theme.dart';
import 'package:ledctrl/presentation/settings/pages/settings_page.dart';

import 'presentation/home/pages/home_page.dart';

class LedCtrlApp extends StatelessWidget {
  const LedCtrlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes: {
        '/': (context) => const HomePage(),
        'settings': (context) => const SettingsPage(),
      },
    );
  }
}
