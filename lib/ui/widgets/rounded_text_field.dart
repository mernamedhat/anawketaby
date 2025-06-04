/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final Widget textField;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final Widget? icon;
  final Widget? trailingWidget;
  final Color backgroundColor;

  const RoundedTextField({
    Key? key,
    required this.textField,
    this.height,
    this.width,
    this.padding,
    this.icon,
    this.trailingWidget,
    this.backgroundColor = AppStyles.TEXT_FIELD_BACKGROUND_COLOR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      padding: this.padding ?? EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: this.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            this.icon ?? Container(),
            if (this.icon != null) SizedBox(width: scaleWidth(8.0)),
            Expanded(child: this.textField),
            if (this.trailingWidget != null) SizedBox(width: scaleWidth(8.0)),
            this.trailingWidget ?? Container(),
          ],
        ),
      ),
    );
  }
}
