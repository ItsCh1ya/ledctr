import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:ledctrl/config/theme.dart';
import 'package:ledctrl/presentation/settings/pages/settings_page.dart';

import 'presentation/home/pages/home_page.dart';
import 'presentation/settings/pages/modules_page.dart';

class LedCtrlApp extends StatelessWidget {
  const LedCtrlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: theme,
      builder: (p0, mytheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: mytheme,
          routes: {
            '/': (context) => const HomePage(),
            'settings': (context) => const SettingsPage(),
            'settings/modules': (context) => const ModulesSettingsPage(),
          },
        );
      },
    );
  }
}
