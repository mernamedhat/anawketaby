import 'package:anawketaby/enums/competition_creation_feature.dart';
import 'package:anawketaby/enums/question_types.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/questions_types_dialogs/question_join_dialog.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/questions_types_dialogs/question_mcq_multiple_dialog.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/questions_types_dialogs/question_mcq_one_dialog.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/questions_types_dialogs/question_ordering_dialog.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/questions_types_dialogs/question_tf_dialog.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AdminNewCompetitionQuestionsStepProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final Competition competition;
  final AppGroup? group;

  AdminNewCompetitionQuestionsStepProvider(this.competition, this.group);

  addNewQuestion() async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "اختيار نوع السؤال",
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppStyles.PRIMARY_COLOR,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 22.0,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (competition.isFeatureAllowed(appUser!, group,
                    CompetitionCreationFeature.questionTF)) ...[
                  ElevatedButton(
                    onPressed: () => _newQuestionDialog(QuestionTypes.tf),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.PRIMARY_COLOR_DARK, // Button background color
                      minimumSize: Size(double.infinity, scaleHeight(55.0)), // Width and height
                    ),
                    child: Text(
                      "صح / غلط",
                      style: const TextStyle(
                        color: AppStyles.TEXT_PRIMARY_COLOR,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
                if (competition.isFeatureAllowed(appUser!, group,
                    CompetitionCreationFeature.questionMCQOne)) ...[
                  ElevatedButton(
                    onPressed: () => _newQuestionDialog(QuestionTypes.mcq_one),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.PRIMARY_COLOR_DARK, // Button background color
                      minimumSize: Size(double.infinity, scaleHeight(55.0)), // Width and height
                    ),
                    child: Text(
                      "اختيار اجابة واحدة",
                      style: const TextStyle(
                        color: AppStyles.TEXT_PRIMARY_COLOR,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
                if (competition.isFeatureAllowed(appUser!, group,
                    CompetitionCreationFeature.questionMCQMultiple)) ...[
                  ElevatedButton(
                    onPressed: () => _newQuestionDialog(QuestionTypes.mcq_multiple),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.PRIMARY_COLOR_DARK, // Button background color
                      minimumSize: Size(double.infinity, scaleHeight(55.0)), // Width and height
                    ),
                    child: Text(
                      "اختيار متعدد",
                      style: const TextStyle(
                        color: AppStyles.TEXT_PRIMARY_COLOR,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
                if (competition.isFeatureAllowed(appUser!, group,
                    CompetitionCreationFeature.questionOrdering)) ...[
                  ElevatedButton(
                    onPressed: () => _newQuestionDialog(QuestionTypes.ordering),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.PRIMARY_COLOR_DARK,
                      minimumSize: Size(double.infinity, scaleHeight(55.0)),
                    ),
                    child: Text(
                      "ترتيب",
                      style: const TextStyle(
                        color: AppStyles.TEXT_PRIMARY_COLOR,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
                if (competition.isFeatureAllowed(appUser!, group,
                    CompetitionCreationFeature.questionJoin)) ...[
                  ElevatedButton(
                    onPressed: () => _newQuestionDialog(QuestionTypes.join),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.PRIMARY_COLOR_DARK,
                      minimumSize: Size(double.infinity, scaleHeight(55.0)),
                    ),
                    child: Text(
                      "توصيل",
                      style: const TextStyle(
                        color: AppStyles.TEXT_PRIMARY_COLOR,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ],
            ),
          ),
        );
      },
    );

    notifyListeners();
  }


  Future _newQuestionDialog(QuestionTypes questionType) async {
    Navigator.pop(Get.context!);

    late Widget questionTypeScreen;

    switch (questionType) {
      case QuestionTypes.tf:
        questionTypeScreen = QuestionTFDialog(competition: this.competition);
        break;

      case QuestionTypes.mcq_one:
        questionTypeScreen =
            QuestionMCQOneDialog(competition: this.competition);
        break;

      case QuestionTypes.mcq_multiple:
        questionTypeScreen =
            QuestionMCQMultipleDialog(competition: this.competition);
        break;

      case QuestionTypes.ordering:
        questionTypeScreen =
            QuestionOrderingDialog(competition: this.competition);
        break;

      case QuestionTypes.join:
        questionTypeScreen = QuestionJoinDialog(competition: this.competition);
        break;
    }

    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool goBackEnabled = false;
        return WillPopScope(
          onWillPop: () {
            if (goBackEnabled) {
              return Future.value(true);
            } else {
              goBackEnabled = true;
              Future.delayed(
                  const Duration(seconds: 2), () => goBackEnabled = false);
              Fluttertoast.showToast(
                msg: "اضغط مرة أخرى للرجوع",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              return Future.value(false);
            }
          },
          child: Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (goBackEnabled) {
                            Navigator.pop(context);
                          } else {
                            goBackEnabled = true;
                            Future.delayed(const Duration(seconds: 2),
                                () => goBackEnabled = false);
                            Fluttertoast.showToast(
                              msg: "اضغط مرة أخرى للرجوع",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppStyles.PRIMARY_COLOR,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "سؤال جديد",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: AppStyles.PRIMARY_COLOR,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: questionTypeScreen),
              ],
            ),
          ),
        );
      },
    );

    notifyListeners();
  }

  Future showQuestionDialog(CompetitionQuestion question) async {
    late Widget questionTypeScreen;

    switch (question.questionType) {
      case QuestionTypes.tf:
        questionTypeScreen = QuestionTFDialog(
            competition: this.competition, competitionQuestion: question);
        break;

      case QuestionTypes.mcq_one:
        questionTypeScreen = QuestionMCQOneDialog(
            competition: this.competition, competitionQuestion: question);
        break;

      case QuestionTypes.mcq_multiple:
        questionTypeScreen = QuestionMCQMultipleDialog(
            competition: this.competition, competitionQuestion: question);
        break;

      case QuestionTypes.ordering:
        questionTypeScreen = QuestionOrderingDialog(
            competition: this.competition, competitionQuestion: question);
        break;

      case QuestionTypes.join:
        questionTypeScreen = QuestionJoinDialog(
            competition: this.competition, competitionQuestion: question);
        break;
    }

    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool goBackEnabled = false;
        return WillPopScope(
          onWillPop: () {
            if (goBackEnabled) {
              return Future.value(true);
            } else {
              goBackEnabled = true;
              Future.delayed(
                  const Duration(seconds: 2), () => goBackEnabled = false);
              Fluttertoast.showToast(
                msg: "اضغط مرة أخرى للرجوع",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              return Future.value(false);
            }
          },
          child: Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (goBackEnabled) {
                            Navigator.pop(context);
                          } else {
                            goBackEnabled = true;
                            Future.delayed(const Duration(seconds: 2),
                                () => goBackEnabled = false);
                            Fluttertoast.showToast(
                              msg: "اضغط مرة أخرى للرجوع",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppStyles.PRIMARY_COLOR,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "تعديل السؤال",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: AppStyles.PRIMARY_COLOR,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: questionTypeScreen),
              ],
            ),
          ),
        );
      },
    );

    notifyListeners();
  }

  cloneQuestion(CompetitionQuestion question) {
    CompetitionQuestion clonedQuestion = CompetitionQuestion.clone(question);
    this.competition.questions.add(clonedQuestion);
    notifyListeners();
  }

  bool deleteQuestionEnabled = false;
  int deleteQuestionEnabledIndex = -1;

  removeQuestion(CompetitionQuestion question) {
    if (deleteQuestionEnabled &&
        deleteQuestionEnabledIndex ==
            this.competition.questions.indexOf(question)) {
      this.competition.questions.remove(question);
    } else {
      deleteQuestionEnabled = true;
      deleteQuestionEnabledIndex = this.competition.questions.indexOf(question);
      Future.delayed(const Duration(seconds: 2), () {
        deleteQuestionEnabled = false;
        deleteQuestionEnabledIndex = -1;
      });
      Fluttertoast.showToast(
        msg: "اضغط مرة أخرى للحذف",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    notifyListeners();
  }
}
