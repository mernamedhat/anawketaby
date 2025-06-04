import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Color backgroundColor;
  final List<BoxShadow> boxShadow;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final Widget? child;
  final BorderRadius borderRadius;
  final Alignment alignment;

  const RoundedContainer({
    Key? key,
    this.height = 100,
    this.width,
    this.backgroundColor = Colors.white,
    this.boxShadow = const [
      BoxShadow(
        color: Color.fromARGB(26, 168, 177, 219),
        offset: Offset(0, 3),
        blurRadius: 6.0,
      ),
    ],
    this.margin,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      margin: this.margin,
      padding: this.padding,
      alignment: this.alignment,
      decoration: BoxDecoration(
        color: this.backgroundColor,
        boxShadow: this.boxShadow,
        borderRadius: borderRadius,
      ),
      child: this.child,
    );
  }
}
