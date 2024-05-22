import 'package:flutter/material.dart';
import 'package:ledctrl/get_it.dart';
import 'package:ledctrl/ledctrl_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(LedCtrlApp());
}