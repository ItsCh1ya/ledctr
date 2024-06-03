import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  bool darkTheme = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkTheme = prefs.getBool('darkTheme') ?? true;
    });
  }

  Future<void> _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', value);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Тема'),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Темная тема", style: Theme.of(context).textTheme.titleLarge),
                      Spacer(),
                      ThemeSwitcher(
                        clipper: const ThemeSwitcherCircleClipper(),
                        builder: (context) {
                          return Switch(
                            value: darkTheme,
                            onChanged: (value) {
                              setState(() {
                                darkTheme = value;
                              });
                              var theme = darkTheme ? ThemeData.dark() : ThemeData.light();
                              ThemeSwitcher.of(context).changeTheme(theme: theme);
                              _saveThemePreference(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}