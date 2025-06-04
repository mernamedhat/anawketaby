import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class CheckWidget extends StatelessWidget {
  final double scale;
  final Color color;
  final bool isTopRightPositioned;

  const CheckWidget({
    Key? key,
    this.scale = 1,
    this.color = Colors.green,
    this.isTopRightPositioned = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isTopRightPositioned)
      return Positioned(
        right: scaleWidth(-10.0 * this.scale),
        top: scaleHeight(-10.0 * this.scale),
        child: _checkContainer(),
      );
    else
      return _checkContainer();
  }

  Widget _checkContainer() {
    return Container(
      width: scaleWidth(30.0 * this.scale),
      height: scaleHeight(30.0 * this.scale),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: this.color,
        border: Border.all(
          color: Colors.white,
          width: scaleWidth(2.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 24.0 * this.scale,
      ),
    );
  }
}
