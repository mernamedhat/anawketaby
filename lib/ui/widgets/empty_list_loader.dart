import 'dart:math' as math;

import 'package:anawketaby/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyListLoader extends StatefulWidget {
  final double? width;
  final double height;
  final Color menuColor;
  final Color loaderColor;

  const EmptyListLoader({
    this.width,
    this.height = 80.0,
    this.menuColor = Colors.grey,
    this.loaderColor = AppStyles.SELECTION_COLOR_DARK,
  });

  @override
  _EmptyListLoaderState createState() => _EmptyListLoaderState();
}

class _EmptyListLoaderState extends State<EmptyListLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "assets/images/icons/empty_logo.svg",
            width: this.widget.width,
            height: this.widget.height,
            color: this.widget.menuColor,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _controller.value * math.pi * 2,
                  child: child,
                );
              },
              child: Icon(
                Icons.refresh,
                color: this.widget.loaderColor,
                size: 45.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}
