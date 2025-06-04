import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class ChoicesButtonsController {
  var value;

  ChoicesButtonsController(this.value);
}

class ChoicesButtonsPicker extends StatefulWidget {
  final ChoicesButtonsController controller;
  final List<String?> buttonsText;
  final EdgeInsets padding;
  final double borderRadius;
  final Function? onChoiceClick;
  final Color selectedButtonColor;
  final List<Color>? buttonsColor;
  final double buttonsHeight;
  final List? values;
  final bool isMultiple;

  ChoicesButtonsPicker({
    Key? key,
    required this.controller,
    required this.buttonsText,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 8.0,
    this.onChoiceClick,
    this.selectedButtonColor = AppStyles.PRIMARY_COLOR,
    this.buttonsColor,
    this.buttonsHeight = 35.0,
    this.values,
    this.isMultiple = false,
  })  : assert(
          values == null || values.length == buttonsText.length,
          "The values length must equals buttonsText length.",
        ),
        super(key: key);

  @override
  _ChoicesButtonsPickerState createState() => _ChoicesButtonsPickerState();
}

class _ChoicesButtonsPickerState extends State<ChoicesButtonsPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.buttonsHeight + scaleHeight(10.0),
      width: double.infinity,
      child: ListView(
        padding: widget.padding,
        scrollDirection: Axis.horizontal,
        children: widget.buttonsText.map((buttonText) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  print("buttonText"+buttonText.toString());
                  setState(() => _changeSelection(buttonText));
                  if (widget.onChoiceClick != null) {
                    await widget.onChoiceClick!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: _isSelectedButton(buttonText)!
                      ? AppStyles.TEXT_PRIMARY_COLOR
                      : AppStyles.TEXT_SECONDARY_COLOR,
                  backgroundColor: _isSelectedButton(buttonText)!
                      ? widget.selectedButtonColor
                      : AppStyles.INACTIVE_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  minimumSize: Size(0, widget.buttonsHeight), // Fix is here
                ),
                child: Text(
                  buttonText!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
              ),
              SizedBox(width: scaleWidth(10.0)),
            ],
          );

        }).toList(),
      ),
    );
  }
  @override
  void initState() {
    super.initState();

    if (widget.isMultiple && widget.controller.value == null) {
      widget.controller.value = [];
    }
  }
  bool? _isSelectedButton(buttonText) {
    print("object"+buttonText.toString());
    if (widget.controller.value == null) return false;

    if (widget.isMultiple) {
      if (widget.values == null)
        return (widget.controller.value as List).contains(buttonText);
      else
        return (widget.controller.value as List).contains(
            widget.values![widget.buttonsText.indexOf(buttonText)]);
    } else {
      if (widget.values == null)
        return widget.controller.value ==
            widget.buttonsText.indexOf(buttonText);
      else
        return widget.controller.value ==
            widget.values![widget.buttonsText.indexOf(buttonText)];
    }
  }
  // void _changeSelection(buttonText) {
  //   print("object1"+buttonText.toString());
  //   if (widget.isMultiple) {
  //
  //     if (widget.values == null) {
  //
  //       if (!widget.controller.value.contains(buttonText)) {
  //
  //         widget.controller.value.add(buttonText);
  //       }else {
  //
  //         widget.controller.value.remove(buttonText);
  //       }
  //
  //     } else {
  //
  //       if (!widget.controller.value
  //           .contains(widget.values![widget.buttonsText.indexOf(buttonText)])) {
  //
  //         widget.controller.value
  //             .add(widget.values![widget.buttonsText.indexOf(buttonText)]);
  //       }else {
  //
  //         widget.controller.value
  //             .remove(widget.values![widget.buttonsText.indexOf(buttonText)]);
  //       }
  //     }
  //   } else {
  //
  //     if (widget.values == null) {
  //
  //       widget.controller.value = widget.buttonsText.indexOf(buttonText);
  //     }else {
  //
  //       widget.controller.value =
  //       widget.values![widget.buttonsText.indexOf(buttonText)];
  //     }
  //   }
  // }
  void _changeSelection(buttonText) {
    print("object1" + buttonText.toString());

    // Ensure value is initialized as a List for multiple selection
    if (widget.isMultiple && widget.controller.value == null) {
      widget.controller.value = <dynamic>[]; // or <String>[] depending on type
    }

    if (widget.isMultiple) {
      final valueList = widget.controller.value as List;

      if (widget.values == null) {
        if (!valueList.contains(buttonText)) {
          valueList.add(buttonText);
        } else {
          valueList.remove(buttonText);
        }
      } else {
        final value = widget.values![widget.buttonsText.indexOf(buttonText)];
        if (!valueList.contains(value)) {
          valueList.add(value);
        } else {
          valueList.remove(value);
        }
      }


    } else {
      if (widget.values == null) {
        widget.controller.value = widget.buttonsText.indexOf(buttonText);
      } else {
        widget.controller.value =
        widget.values![widget.buttonsText.indexOf(buttonText)];
      }
    }
  }

  // bool? _isSelectedButton(buttonText) {
  //   if (widget.isMultiple) {
  //     if (widget.values == null)
  //       return widget.controller.value.contains(buttonText);
  //     else
  //       return widget.controller.value
  //           .contains(widget.values![widget.buttonsText.indexOf(buttonText)]);
  //   } else {
  //     if (widget.values == null)
  //       return widget.controller.value ==
  //           widget.buttonsText.indexOf(buttonText);
  //     else
  //       return widget.controller.value ==
  //           widget.values![widget.buttonsText.indexOf(buttonText)];
  //   }
  // }
  //
  // void _changeSelection(buttonText) {
  //   if (widget.isMultiple) {
  //
  //     if (widget.values == null) {
  //
  //       if (!widget.controller.value.contains(buttonText)) {
  //
  //         widget.controller.value.add(buttonText);
  //       }else {
  //
  //         widget.controller.value.remove(buttonText);
  //       }
  //
  //     } else {
  //
  //       if (!widget.controller.value
  //           .contains(widget.values![widget.buttonsText.indexOf(buttonText)])) {
  //
  //         widget.controller.value
  //             .add(widget.values![widget.buttonsText.indexOf(buttonText)]);
  //       }else {
  //
  //         widget.controller.value
  //             .remove(widget.values![widget.buttonsText.indexOf(buttonText)]);
  //       }
  //     }
  //   } else {
  //
  //     if (widget.values == null) {
  //
  //       widget.controller.value = widget.buttonsText.indexOf(buttonText);
  //     }else {
  //
  //       widget.controller.value =
  //       widget.values![widget.buttonsText.indexOf(buttonText)];
  //     }
  //   }
  // }
}
