import 'package:anawketaby/utils/app_styles.dart';
import 'package:flutter/material.dart';

class EmptyListText extends StatelessWidget {
  final String text;

  const EmptyListText({Key? key, this.text = "نأسف، لا يوجد نتائج."})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "${this.text}",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppStyles.SECONDARY_COLOR,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
