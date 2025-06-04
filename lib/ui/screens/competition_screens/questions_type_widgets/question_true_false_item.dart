/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/ui/screens/competition_screens/widgets/check_widget.dart';
import 'package:anawketaby/ui/screens/competition_screens/widgets/question_content.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class QuestionTrueFalseItem extends StatefulWidget {
  final int? questionNo;
  final CompetitionQuestion question;
  final Function() nextQuestionFunction;

  const QuestionTrueFalseItem({
    Key? key,
    required this.questionNo,
    required this.question,
    required this.nextQuestionFunction,
  }) : super(key: key);

  @override
  _QuestionTrueFalseItemState createState() => _QuestionTrueFalseItemState();
}

class _QuestionTrueFalseItemState extends State<QuestionTrueFalseItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AutoSizeText(
          "صح ام خطأ",
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ElevatedButton(
                    onPressed: () => _changeAnswer(true),
                    child: Text(
                      "صح",
                      style: TextStyle(
                        fontSize: 26.0,
                        color: AppStyles.TEXT_PRIMARY_COLOR,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppStyles.TAJAWAL,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: (widget.question.userAnswer!.length > 0 &&
                          widget.question.userAnswer![0] == true)
                          ? AppStyles.SELECTION_COLOR_DARK
                          : AppStyles.PRIMARY_COLOR_DARK, backgroundColor: (widget.question.userAnswer!.length > 0 &&
                          widget.question.userAnswer![0] == true)
                          ? AppStyles.SELECTION_COLOR
                          : AppStyles.PRIMARY_COLOR, minimumSize: Size(double.infinity, scaleHeight(70.0)),
                    ),
                  ),

                  if (widget.question.userAnswer!.length > 0 &&
                      widget.question.userAnswer![0] == true)
                    CheckWidget(),
                ],
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ElevatedButton(
                    onPressed: () => _changeAnswer(false),
                    child: Text(
                      "خطأ",
                      style: TextStyle(
                        fontSize: 26.0,
                        color: AppStyles.TEXT_PRIMARY_COLOR,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppStyles.TAJAWAL,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: (widget.question.userAnswer!.length > 0 &&
                          widget.question.userAnswer![0] == false)
                          ? AppStyles.SELECTION_COLOR_DARK
                          : AppStyles.PRIMARY_COLOR_DARK, backgroundColor: (widget.question.userAnswer!.length > 0 &&
                          widget.question.userAnswer![0] == false)
                          ? AppStyles.SELECTION_COLOR
                          : AppStyles.PRIMARY_COLOR, minimumSize: Size(double.infinity, scaleHeight(70.0)),
                    ),
                  ),

                  if (widget.question.userAnswer!.length > 0 &&
                      widget.question.userAnswer![0] == false)
                    CheckWidget(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _changeAnswer(bool answer) {
    setState(() {
      if (widget.question.userAnswer!.length == 0)
        widget.question.userAnswer!.add(answer);
      else
        widget.question.userAnswer![0] = answer;
    });
    Future.delayed(
        const Duration(milliseconds: 100), widget.nextQuestionFunction);
  }
}
