import 'package:anawketaby/models/app_config.dart';
import 'package:flutter/material.dart';

Future<Widget> initMain(AppConfig child) async {
  WidgetsFlutterBinding.ensureInitialized();
  return child;
}
