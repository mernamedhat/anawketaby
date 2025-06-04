import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveSize {
  static double screenPadding = 20.0;

  static double getWidth(BuildContext context, double px) {
    return MediaQuery.of(context).size.width * px;
  }

  static double getHeight(BuildContext context, double px) {
    return MediaQuery.of(context).size.height * px;
  }
}

scaleWidth(double width) {
  double designWidth = 375.0;
  return width / designWidth * MediaQuery.of(Get.context!).size.width;
}

scaleHeight(double height) {
  double designHeight = 812.0;
  return height / designHeight * MediaQuery.of(Get.context!).size.height;
}
