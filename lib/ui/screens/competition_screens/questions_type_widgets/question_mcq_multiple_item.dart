/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/models/question_choice.dart';
import 'package:anawketaby/ui/screens/competition_screens/widgets/check_widget.dart';
import 'package:anawketaby/ui/screens/competition_screens/widgets/question_content.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class QuestionMCQMultipleItem extends StatefulWidget {
  final int? questionNo;
  final CompetitionQuestion question;

  const QuestionMCQMultipleItem(
      {Key? key, required this.questionNo, required this.question})
      : super(key: key);

  @override
  _QuestionMCQMultipleItemState createState() =>
      _QuestionMCQMultipleItemState();
}

class _QuestionMCQMultipleItemState extends State<QuestionMCQMultipleItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AutoSizeText(
          "اختر اجابات متعددة",
          maxLines: 1,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18.0,
            color: AppStyles.TEXT_SECONDARY_COLOR,
            fontWeight: FontWeight.w500,
            fontFamily: AppStyles.TAJAWAL,
          ),
        ),
        QuestionContent(
            questionNo: widget.questionNo, question: widget.question),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.0,
                  mainAxisSpacing: 14.0,
                  childAspectRatio: scaleHeight(0.9),
                  padding: EdgeInsets.only(
                      top: scaleHeight(16.0),
                      left: scaleWidth(16.0),
                      right: scaleWidth(16.0)),
                  children: widget.question.choices
                      .map((e) => _choiceItem(e))
                      .toList(),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      if (widget.question.userAnswer!.length ==
                          widget.question.choices.length) {
                        widget.question.userAnswer!.clear();
                      } else if (widget.question.userAnswer!.length !=
                          widget.question.choices.length) {
                        widget.question.userAnswer!.clear();
                        widget.question.choices
                            .forEach((e) => _changeAnswer(e.no));
                      }
                      setState(() {});
                    },
                    child: CheckWidget(
                      scale: 2.0,
                      color: (widget.question.userAnswer!.length ==
                              widget.question.choices.length)
                          ? Colors.green
                          : Colors.grey,
                      isTopRightPositioned: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _choiceItem(QuestionChoice choice) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ElevatedButton(
          onPressed: () => _changeAnswer(choice.no),
          child: Flexible(
            child: AutoSizeText(
              "${choice.content}",
              textAlign: TextAlign.center,
              minFontSize: 8.0,
              style: TextStyle(
                fontSize: 26.0,
                color: AppStyles.TEXT_PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
                fontFamily: AppStyles.TAJAWAL,
                height: scaleHeight(1.6),
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: (widget.question.userAnswer!.length > 0 &&
                widget.question.userAnswer!.contains(choice.no))
                ? AppStyles.SELECTION_COLOR_DARK
                : AppStyles.PRIMARY_COLOR_DARK, backgroundColor: (widget.question.userAnswer!.length > 0 &&
                widget.question.userAnswer!.contains(choice.no))
                ? AppStyles.SELECTION_COLOR
                : AppStyles.PRIMARY_COLOR, minimumSize: Size(double.infinity, double.infinity),
          ),
        ),

        if (widget.question.userAnswer!.length > 0 &&
            widget.question.userAnswer!.contains(choice.no))
          CheckWidget(),
      ],
    );
  }

  _changeAnswer(int? answer) {
    setState(() {
      if (widget.question.userAnswer!.contains(answer))
        widget.question.userAnswer!.remove(answer);
      else
        widget.question.userAnswer!.add(answer);
    });
  }
}
