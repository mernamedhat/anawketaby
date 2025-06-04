import 'package:anawketaby/utils/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Function()? onPressed;
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

  AuthButton({
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
  });

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
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextButton(
        onPressed: this.onPressed,
        style: TextButton.styleFrom(
          minimumSize: (this.minWidth != null && this.height != null)
              ? Size(this.minWidth!, this.height! - 5.0)
              : (this.minWidth != null)
                  ? Size.fromWidth(this.minWidth!)
                  : null,
          backgroundColor:
              (this.onPressed == null) ? this.disabledColor : this.color,
          padding: this.padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (this.leadingWidget != null) this.leadingWidget!,
            if (this.leadingWidget != null && this.text != null)
              SizedBox(height: 20.0),
            if (this.text != null)
              AutoSizeText(
                "${this.text}",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: this.style.copyWith(height: 1.6),
              ),
            if (this.trailingWidget != null) SizedBox(height: 20.0),
            if (this.trailingWidget != null) this.trailingWidget!
          ],
        ),
      ),
    );
  }
}
