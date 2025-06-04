import 'package:anawketaby/enums/flavor.dart';
import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final Flavor flavor;

  static AppConfig? instance;

  AppConfig({
    Key? key,
    required this.flavor,
    required Widget child,
  }) : super(child: child, key: key) {
    instance = this;
  }

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(aspect: AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
