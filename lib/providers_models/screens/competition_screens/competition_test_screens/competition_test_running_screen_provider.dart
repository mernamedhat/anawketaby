import 'package:anawketaby/enums/question_types.dart';
import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_settings.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CompetitionTestRunningScreenProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final AppSettings appSettings =
      Provider.of<SettingsProvider>(Get.context!, listen: false).appSettings;
  final Competition competition;
  final int? questionIndex;

  late int _questionNo;
  CompetitionQuestion? _currentQuestion;

  CompetitionTestRunningScreenProvider(this.competition, this.questionIndex) {
    if (this.questionIndex == null) {
      _questionNo = 1;
      _currentQuestion = this.competition.questions.first;
    } else {
      _questionNo = this.questionIndex! + 1;
      _currentQuestion = this.competition.questions[this.questionIndex!];
    }

    CompetitionManagement.instance
        .updateUserCompetitionTestData(
          competition: this.competition,
          questionIndex: questionIndex,
        )
        .then((_) => notifyListeners());
  }

  answerQuestion() async {
    Provider.of<SettingsProvider>(Get.context!, listen: false).playClickSound();

    bool isSorting = _currentQuestion!.questionType == QuestionTypes.tf ||
        _currentQuestion!.questionType == QuestionTypes.mcq_one ||
        _currentQuestion!.questionType == QuestionTypes.mcq_multiple;

    if (arraySimilarity(
        _currentQuestion!.answer!, this._currentQuestion!.userAnswer!,
        sorting: isSorting)) {
      await CompetitionManagement.instance.answerUserCompetitionTestQuestion(
        competition: this.competition,
        questionIndex: _questionNo,
        isRightAnswer: true,
      );

      Provider.of<SettingsProvider>(Get.context!, listen: false)
          .playAnswerSound(true);
      AwesomeDialog(
        context: Get.context!,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        title: 'إجابة صحيحة',
        desc:
        'لقد جاوبت إجابة صحيحة وحصلت على نقطة ستضاف إلى رصيد نقاطك عند الإنتهاء من إجابة جميع الأسئلة.',
        btnOk: ElevatedButton(
          onPressed: nextQuestion,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
            minimumSize: Size(double.infinity, scaleHeight(55.0)), // Width and height
          ),
          child: Text(
            "التالي",
            style: const TextStyle(
              color: AppStyles.TEXT_PRIMARY_COLOR,
              fontSize: 22.0,
            ),
          ),
        ),
      )..show();
    } else {
      String rightAnswer;
      if (_currentQuestion!.questionType == QuestionTypes.tf) {
        rightAnswer = "• ${(_currentQuestion!.answer!.first) ? "صح" : "خطأ"}";
      } else if (_currentQuestion!.questionType == QuestionTypes.mcq_one ||
          _currentQuestion!.questionType == QuestionTypes.mcq_multiple) {
        rightAnswer = _currentQuestion!.answer!
            .map((answer) =>
        "• ${_currentQuestion!.choices.firstWhere((choice) => choice.no == answer).content}")
            .toList()
            .join("\n");
      } else {
        rightAnswer = _currentQuestion!.constantChoices
            .map((constantChoice) =>
        "• ${constantChoice.content} -> ${_currentQuestion!.choices.firstWhere((choice) => choice.no == _currentQuestion!.answer![constantChoice.no! - 1]).content}")
            .toList()
            .join("\n");
      }

      Provider.of<SettingsProvider>(Get.context!, listen: false)
          .playAnswerSound(false);
      AwesomeDialog(
        context: Get.context!,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.error,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        title: 'إجابة خاطئة',
        desc:
        'للأسف لقد أجبت إجابة خاطئة. الإجابة الصحيحة هي:\n\n $rightAnswer.',
        btnOk: ElevatedButton(
          onPressed: () => Navigator.pop(Get.context!),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyles.THIRD_COLOR_DARK,
            minimumSize: Size(double.infinity, scaleHeight(55.0)),
          ),
          child: Text(
            "رجوع",
            style: const TextStyle(
              color: AppStyles.TEXT_PRIMARY_COLOR,
              fontSize: 22.0,
            ),
          ),
        ),
      )..show();
    }
  }

  void nextQuestion() async {
    Navigator.pop(Get.context!);
    if (this.competition.questions.length > _questionNo) {
      _questionNo++;
      _currentQuestion = this.competition.questions[_questionNo - 1];
      notifyListeners();
    } else {
      await CompetitionManagement.instance
          .addUserCompetitionTestPointsToHistory(competition: this.competition);

      AwesomeDialog(
        context: Get.context!,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        title: 'إنتهاء الأسئلة',
        desc: 'لقد أجبت عن كل اسئلة المسابقة، سوف تضاف لك نقاط المسابقة.',
        btnOk: ElevatedButton(
          onPressed: () {
            Navigator.of(Get.context!).popUntil((route) => route.isFirst);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyles.THIRD_COLOR_DARK,
            minimumSize: Size(double.infinity, scaleHeight(55.0)),
          ),
          child: Text(
            "الرجوع",
            style: const TextStyle(
              color: AppStyles.TEXT_PRIMARY_COLOR,
              fontSize: 22.0,
            ),
          ),
        ),
      )..show();
    }
  }


  bool arraySimilarity(List list1, List list2, {required bool sorting}) {
    if (sorting) {
      list1.sort((e, n) => e.compareTo(n));
      list2.sort((e, n) => e.compareTo(n));
    }

    if (list1.join(',') == list2.join(','))
      return true;
    else
      return false;
  }

  CompetitionQuestion? get currentQuestion => _currentQuestion;

  get questionNo => _questionNo;
}
