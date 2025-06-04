/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:prompt_dialog/prompt_dialog.dart';

class NumberCounterController {
  int? value;

  NumberCounterController({this.value = 0});
}

class NumberCounterButtons extends StatefulWidget {
  final NumberCounterController controller;
  final double width;
  final String? zeroText;
  final String? descriptionText;
  final Function? onChanged;
  final int minNumber;
  final int maxNumber;

  const NumberCounterButtons({
    Key? key,
    required this.controller,
    this.width = 125.0,
    this.zeroText,
    this.descriptionText,
    this.onChanged,
    this.minNumber = 18,
    this.maxNumber = 50,
  }) : super(key: key);

  @override
  _NumberCounterButtonsState createState() => _NumberCounterButtonsState();
}

class _NumberCounterButtonsState extends State<NumberCounterButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: (widget.controller.value! < widget.maxNumber)
                ? () => setState(() {
                      widget.controller.value = widget.controller.value! + 1;
                      if (widget.onChanged != null) widget.onChanged!();
                    })
                : null,
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(
                  Size(scaleWidth(40.0), scaleHeight(35.0))),
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppStyles.SECONDARY_COLOR),
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            ),
            child: Icon(
              Icons.add,
              color: AppStyles.TEXT_PRIMARY_COLOR,
            ),
          ),
          InkWell(
            onTap: _valueOnTap,
            child: Text(
              (widget.zeroText != null && widget.controller.value == 0)
                  ? "${widget.zeroText}"
                  : (widget.descriptionText == null)
                      ? "${widget.controller.value}"
                      : "${widget.controller.value} ${widget.descriptionText}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppStyles.SECONDARY_COLOR,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize:
                    (widget.zeroText != null && widget.controller.value == 0)
                        ? 16.0
                        : 18.0,
                height:
                    (widget.zeroText != null && widget.controller.value == 0)
                        ? 1.5
                        : 1.2,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: (widget.controller.value! > widget.minNumber)
                ? () {
                    setState(() =>
                        widget.controller.value = widget.controller.value! - 1);
                    if (widget.onChanged != null) widget.onChanged!();
                  }
                : null,
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(
                  Size(scaleWidth(40.0), scaleHeight(35.0))),
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppStyles.SECONDARY_COLOR),
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            ),
            child: Icon(
              Icons.remove,
              color: AppStyles.TEXT_PRIMARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  Future _valueOnTap() async {
    widget.controller.value = int.parse(
      await prompt(
            context,
            title: Text("ادخل القيمة"),
            initialValue: '${widget.controller.value}',
            textOK: Text("موافق"),
            textCancel: Text("إلغاء"),
            hintText: "اكتب هنا القيمة",
            keyboardType: TextInputType.number,
            autoFocus: true,
          ) ??
          '',
    );

    if (widget.controller.value! < widget.minNumber)
      widget.controller.value = widget.minNumber;
    else if (widget.controller.value! > widget.maxNumber)
      widget.controller.value = widget.maxNumber;

    if (widget.onChanged != null) widget.onChanged!();
    setState(() {});
  }
}
