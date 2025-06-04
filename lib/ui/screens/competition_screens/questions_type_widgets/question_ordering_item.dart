/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/ui/screens/competition_screens/widgets/question_content.dart';
import 'package:anawketaby/ui/screens/competition_screens/widgets/reorder_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class QuestionOrderingItem extends StatefulWidget {
  final int? questionNo;
  final CompetitionQuestion question;

  const QuestionOrderingItem(
      {Key? key, required this.questionNo, required this.question})
      : super(key: key);

  @override
  _QuestionOrderingItemState createState() => _QuestionOrderingItemState();
}

class _QuestionOrderingItemState extends State<QuestionOrderingItem> {
  late List<Widget> _constantChoices;
  late List<Widget> _choices;

  @override
  void initState() {
    super.initState();
    _choices = List<Widget>.generate(
      widget.question.choices.length,
      (int index) => Column(
        key: ValueKey(widget.question.choices[index].no),
        children: [
          ReorderButton(
            height: scaleHeight(60.0),
            minWidth: double.infinity,
            onPressed: () {},
            text: '${widget.question.choices[index].content}',
            style: TextStyle(
              color: AppStyles.TEXT_PRIMARY_COLOR,
              fontSize: 22.0,
            ),
            color: AppStyles.PRIMARY_COLOR,
            backgroundColor: AppStyles.PRIMARY_COLOR_DARK,
            isShaded: false,
          ),
          SizedBox(height: scaleHeight(8.0)),
        ],
      ),
    );
    _constantChoices = List<Widget>.generate(
      widget.question.choices.length,
      (int index) => Column(
        children: [
          RoundedContainer(
            height: scaleHeight(60.0),
            width: scaleWidth(45.0),
            backgroundColor: Colors.white,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Text(
              '${widget.question.constantChoices[index].content}',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          SizedBox(height: scaleHeight(8.0)),
        ],
      ),
    );

    if (widget.question.userAnswer!.isEmpty) {
      widget.question.userAnswer =
          widget.question.choices.map((e) => e.no).toList();
    } else {
      List<Widget> temp = [];
      for (int? order in widget.question.userAnswer as Iterable<int?>) {
        temp.add(_choices.firstWhere((e) => e.key == ValueKey(order)));
      }
      _choices = temp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AutoSizeText(
          "ترتيب",
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
          child: SingleChildScrollView(
            child: Row(
              children: [
                RoundedContainer(
                  height: null,
                  padding: EdgeInsets.symmetric(
                      vertical: scaleHeight(4.0), horizontal: scaleWidth(4.0)),
                  backgroundColor: AppStyles.PRIMARY_COLOR_DARK,
                  child: Column(
                    children: _constantChoices,
                  ),
                ),
                SizedBox(width: scaleWidth(4.0)),
                Expanded(
                  child: ReorderableColumn(
                    scrollController: ScrollController(),
                    padding: EdgeInsets.symmetric(
                        vertical: scaleHeight(4.0),
                        horizontal: scaleWidth(4.0)),
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _choices,
                    onReorder: _onReorder,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      Widget row = _choices.removeAt(oldIndex);
      _choices.insert(newIndex, row);
    });
    _changeAnswer(oldIndex, newIndex);
  }

  _changeAnswer(int oldIndex, int newIndex) {
    int? row = widget.question.userAnswer!.removeAt(oldIndex);
    widget.question.userAnswer!.insert(newIndex, row);
  }
}
