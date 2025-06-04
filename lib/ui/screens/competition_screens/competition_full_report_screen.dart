import 'package:anawketaby/enums/competition_level.dart';
import 'package:anawketaby/enums/competition_winner.dart';
import 'package:anawketaby/enums/question_types.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/bible_util.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CompetitionFullReportScreen extends StatelessWidget {
  final Competition competition;

  const CompetitionFullReportScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppStyles.PRIMARY_COLOR_DARK,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
      ),
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                child: AppBar(
                  backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                  toolbarHeight: 75.0,
                  title: AutoSizeText(
                    "تقرير المسابقة",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: AppStyles.PRIMARY_COLOR,
                    ),
                  ),
                  centerTitle: true,
                  leading: TextButton(
                    child: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoSizeText(
                          "اسم المسابقة",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        AutoSizeText(
                          "${competition.name}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "وصف المسابقة",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        AutoSizeText(
                          "${competition.description}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "القراءات",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        AutoSizeText(
                          (competition.reads!.isEmpty)
                              ? "لم يحدد"
                              : competition.reads!
                                  .map((e) => BibleUtil.readFromKey(e))
                                  .join("، "),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "عدد الاسئلة",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        AutoSizeText(
                          "${this.competitionQuestionsCount}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "مدة المسابقة",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        AutoSizeText(
                          "${this.competitionTime}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "مستوى المسابقة",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        AutoSizeText(
                          "${competition.competitionLevel!.translate()}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "قيمة الاشتراك",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        AutoSizeText(
                          "${competition.participationPoints} نقطة/نقاط",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "جائزة المسابقة",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            AutoSizeText(
                              "${competition.participationPoints! * competition.participantsCount!}",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppStyles.TEXT_SECONDARY_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: scaleWidth(8.0)),
                            AutoSizeText(
                              "لـ${competition.competitionWinner!.translate()}",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppStyles.TEXT_SECONDARY_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "ميعاد بداية المسابقة",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        AutoSizeText(
                          "${_getDateTime(competition.timeStart!.toDate())}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "ميعاد نهاية المسابقة",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        AutoSizeText(
                          "${_getDateTime(competition.timeEnd!.toDate())}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "مغلقة بكلمة مرور",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        AutoSizeText(
                          competition.closed! ? "نعم" : "لا",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        AutoSizeText(
                          "الاسئلة والأجوبة",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        _getQuestionAndAnswers,
                        SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get competitionQuestionsCount {
    int counts = this.competition.questions.length;

    if (counts == 1) return "سؤال";
    if (counts == 2) return "سؤالين";
    if (counts > 10)
      return "$counts سؤال";
    else
      return "$counts اسئلة";
  }

  String get competitionTime {
    int? seconds = 0;
    if (this.competition.durationPerCompetition!) {
      seconds = this.competition.durationCompetitionSeconds;
    } else {
      seconds = this
          .competition
          .questions
          .map((e) => e.durationSeconds)
          .reduce((value, element) => value = value! + element!);
    }

    if (seconds! >= 120) {
      int minutes = (seconds / 60).round();

      if (minutes <= 10)
        return "$minutes دقائق";
      else
        return "$minutes دقيقة";
    } else {
      if (seconds <= 10)
        return "$seconds ثواني";
      else
        return "$seconds ثانية";
    }
  }

  Widget get _getQuestionAndAnswers {
    List<Widget> children = [];

    this.competition.questions.forEach((e) {
      Widget question = AutoSizeText(
        "${e.orderNo}. ${e.content}",
        style: TextStyle(
          fontSize: 16.0,
          color: AppStyles.TEXT_SECONDARY_COLOR,
          fontWeight: FontWeight.bold,
        ),
      );

      Widget choicesTitle = AutoSizeText(
        "الاختيارات:",
        style: TextStyle(
          fontSize: 16.0,
          color: AppStyles.PRIMARY_COLOR,
        ),
      );

      Widget choices;
      if (e.questionType == QuestionTypes.tf) {
        choices = AutoSizeText(
          ["صح", "خطأ"].map((choice) => "• $choice").toList().join("\n"),
          style: TextStyle(
            fontSize: 16.0,
            color: AppStyles.TEXT_SECONDARY_COLOR,
          ),
        );
      } else {
        choices = AutoSizeText(
          e.choices.map((choice) => "• ${choice.content}").toList().join("\n"),
          style: TextStyle(
            fontSize: 16.0,
            color: AppStyles.TEXT_SECONDARY_COLOR,
          ),
        );
      }

      Widget answerTitle = AutoSizeText(
        "الاجابة الصحيحة:",
        style: TextStyle(
          fontSize: 16.0,
          color: AppStyles.TEXT_PRIMARY_COLOR,
        ),
      );

      Widget answer;
      if (e.questionType == QuestionTypes.tf) {
        answer = AutoSizeText(
          "• ${(e.answer!.first) ? "صح" : "خطأ"}",
          style: TextStyle(
            fontSize: 16.0,
            color: AppStyles.TEXT_PRIMARY_COLOR,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (e.questionType == QuestionTypes.mcq_one ||
          e.questionType == QuestionTypes.mcq_multiple) {
        answer = AutoSizeText(
          e.answer!
              .map((answer) =>
                  "• ${e.choices.firstWhere((choice) => choice.no == answer).content}")
              .toList()
              .join("\n"),
          style: TextStyle(
            fontSize: 16.0,
            color: AppStyles.TEXT_PRIMARY_COLOR,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        answer = AutoSizeText(
          e.constantChoices
              .map((constantChoice) =>
                  "• ${constantChoice.content} -> ${e.choices.firstWhere((choice) => choice.no == e.answer![constantChoice.no! - 1]).content}")
              .toList()
              .join("\n"),
          style: TextStyle(
            fontSize: 16.0,
            color: AppStyles.TEXT_PRIMARY_COLOR,
            fontWeight: FontWeight.bold,
          ),
        );
      }

      children.add(question);
      children.add(SizedBox(height: 10.0));
      children.add(Container(
          width: double.infinity,
          color: AppStyles.TEXT_FIELD_BACKGROUND_COLOR,
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              choicesTitle,
              SizedBox(height: 10.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: choices),
            ],
          )));
      children.add(SizedBox(height: 10.0));
      children.add(Container(
          width: double.infinity,
          color: AppStyles.THIRD_COLOR,
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              answerTitle,
              SizedBox(height: 10.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: answer),
            ],
          )));
      children.add(SizedBox(height: 16.0));
    });

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  String _getDateTime(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd - hh:mm a');
    return timeFormatter.format(date);
  }
}
