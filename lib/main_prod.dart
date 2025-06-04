import 'package:anawketaby/app.dart';
import 'package:anawketaby/enums/flavor.dart';
import 'package:anawketaby/main_common.dart';
import 'package:anawketaby/models/app_config.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  final configuredApp = AppConfig(
    flavor: Flavor.prod,
    child: MyApp(),
  );

  runApp(await initMain(configuredApp));
}
