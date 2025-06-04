import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class QuestionContent extends StatelessWidget {
  final int? questionNo;
  final CompetitionQuestion? question;

  const QuestionContent({Key? key, this.questionNo, this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: scaleHeight(4.0)),
        Container(
          constraints: BoxConstraints(maxHeight: scaleHeight(120.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedContainer(
                height: scaleHeight(35.0),
                width: scaleWidth(35.0),
                padding: EdgeInsets.symmetric(
                    vertical: scaleHeight(2.0), horizontal: scaleWidth(2.0)),
                backgroundColor: AppStyles.PRIMARY_COLOR,
                child: AutoSizeText(
                  "$questionNo",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 26.0,
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: scaleWidth(8.0)),
              Expanded(
                child: AutoSizeText(
                  "${question!.content!.replaceAll('\n', ' ')}",
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  maxFontSize: 26.0,
                  minFontSize: 8.0,
                  style: TextStyle(
                    fontSize: 26.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppStyles.TAJAWAL,
                    height: scaleHeight(1.6),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: scaleHeight(4.0)),
      ],
    );
  }
}
