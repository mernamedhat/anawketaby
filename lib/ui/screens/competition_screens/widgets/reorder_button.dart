import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ReorderButton extends StatelessWidget {
  final Function onPressed;
  final double? height;
  final double? minWidth;
  final Color color;
  final Color backgroundColor;
  final Color disabledColor;
  final String? text;
  final TextStyle style;
  final double borderRadius;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final EdgeInsets padding;
  final bool isShaded;

  ReorderButton({
    ValueKey? key,
    required this.onPressed,
    this.color = AppStyles.SECONDARY_COLOR,
    this.backgroundColor = AppStyles.SECONDARY_COLOR_DARK,
    this.disabledColor = Colors.grey,
    this.height,
    this.minWidth,
    this.text,
    this.style = const TextStyle(
      color: AppStyles.TEXT_PRIMARY_COLOR,
      fontSize: 14.0,
    ),
    this.borderRadius = 6.0,
    this.leadingWidget,
    this.trailingWidget,
    this.padding = const EdgeInsets.all(8.0),
    this.isShaded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.minWidth,
      height: this.height,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: this.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
        boxShadow: [
          if (this.isShaded)
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3), // changes position of shadow
            ),
        ],
      ),
      child: TextButton(
        onPressed: this.onPressed as void Function()?,
        /*height: this.height - 5.0,
        minWidth: this.minWidth,
        color: this.color,
        disabledColor: this.disabledColor,
        padding: this.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
        ),*/
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AutoSizeText(
                "${this.text}",
                minFontSize: 6.0,
                textAlign: TextAlign.start,
                style: this.style.copyWith(height: scaleHeight(1.6)),
              ),
            ),
            SizedBox(width: scaleWidth(10.0)),
            Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
