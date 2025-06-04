import 'package:anawketaby/enums/competition_creation_feature.dart';
import 'package:anawketaby/enums/competition_level.dart';
import 'package:anawketaby/enums/competition_type.dart';
import 'package:anawketaby/enums/competition_winner.dart';
import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/admin_new_competition_screen.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/steps/admin_new_competition_conditions_step.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/steps/admin_new_competition_details_step.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/steps/admin_new_competition_more_details_step.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/steps/admin_new_competition_questions_step.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/steps/admin_new_competition_share_step.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AdminNewCompetitionScreenProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final Competition competition;
  final CompetitionSteps? step;
  final AppGroup? group;

  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  // Controls the currently active step. Can be set to any valid value i.e., a value that ranges from 0 to upperBound.
  int activeStep = 0;

  // Must be used to control the upper bound of the activeStep variable. Please see next button below the build() method!
  int upperBound = 4;

  AdminNewCompetitionScreenProvider(this.competition, this.step, this.group) {
    if (group != null) {
      if (competition.groupsIDs == null) {
        competition.groupsIDs = [];
        competition.groupsIDs?.add(group!.id!);
      } else if (!competition.groupsIDs!.contains(group!.id!)) {
        competition.groupsIDs?.add(group!.id!);
      }
    }

    // Check competition creation features and set defaults
    if (this.competition.id == null) {
      competition.canBack = (competition.isFeatureAllowed(
              appUser!, group, CompetitionCreationFeature.canBackOrNot))
          ? null
          : competition.featureDefault(
              appUser!, group, CompetitionCreationFeature.canBackOrNot, true);
      this.competition.competitionType = (competition.isFeatureAllowed(appUser!,
                  group, CompetitionCreationFeature.typeIndividuals) &&
              competition.isFeatureAllowed(
                  appUser!, group, CompetitionCreationFeature.typeTeams))
          ? null
          : (competition.isFeatureAllowed(
                  appUser!, group, CompetitionCreationFeature.typeTeams))
              ? CompetitionType.teams
              : CompetitionType.individual;
      this.competition.competitionLevel = (competition.isFeatureAllowed(
              appUser!, group, CompetitionCreationFeature.level))
          ? null
          : competitionLevelFromString(competition.featureDefault(
              appUser!,
              group,
              CompetitionCreationFeature.level,
              CompetitionLevel.noSpecified));
      this.competition.shuffleQuestions = (competition.isFeatureAllowed(
              appUser!, group, CompetitionCreationFeature.randomQuestions))
          ? null
          : competition.featureDefault(appUser!, group,
              CompetitionCreationFeature.randomQuestions, false);
      this.competition.remainingTimeConsider = (competition.isFeatureAllowed(
              appUser!, group, CompetitionCreationFeature.timeConsideration))
          ? null
          : competition.featureDefault(appUser!, group,
              CompetitionCreationFeature.timeConsideration, false);
      this.competition.competitionWinner = (competition.isFeatureAllowed(
              appUser!, group, CompetitionCreationFeature.winner))
          ? null
          : competitionWinnerFromString(competition.featureDefault(
              appUser!,
              group,
              CompetitionCreationFeature.winner,
              CompetitionWinner.three));
    }

    if (this.step == CompetitionSteps.share) {
      activeStep += upperBound;
      notifyListeners();
    }
  }

   get isNewCompetition => this.competition.competitionCode == null;

  _createNewCompetition() async {
    showLoadingDialog();

    // Ordering questions
    for (CompetitionQuestion? question in this.competition.questions) {
      question!.orderNo = this.competition.questions.indexOf(question) + 1;
    }

    bool successful = await CompetitionManagement.instance.createCompetition(
      this.competition,
      this.appUser!,
      group: this.group,
    );

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم إنشاء المسابقة",
        desc: "تم إنشاء المسابقة بنجاح.",
      );
      activeStep++;
      notifyListeners();
    } else {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "حدث خطأ في اتمام عملية الإنشاء",
      );
    }
  }

  _editCompetition() async {
    if (!this.isEditAvailable) {
      showErrorDialog(
          title: 'غير متاح التعديل',
          desc: 'لا يمكن تعديل المسابقة الان بعد مرور وقت بدأها.');
      return;
    }

    showLoadingDialog();

    // Ordering questions
    for (CompetitionQuestion? question in this.competition.questions) {
      question!.orderNo = this.competition.questions.indexOf(question) + 1;
    }

    bool successful = await CompetitionManagement.instance
        .editCompetition(this.competition, this.appUser);

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم تعديل المسابقة",
        desc: "تم تعديل المسابقة بنجاح.",
      );

      activeStep++;
      notifyListeners();
    } else {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "حدث خطأ في اتمام عملية التعديل",
      );
    }
  }

  nextClick() async {
    switch (activeStep) {
      case 0:
        if (this.competition.name == null || this.competition.name!.isEmpty) {
          showErrorSnackBar(
              title: "خانات فارغة", message: "من فضلك اكتب اسم المسابقة.");
          return;
        } else if (this.competition.durationPerCompetition == null) {
          showErrorSnackBar(
              title: "خانات فارغة", message: "من فضلك اختر مدة عامة للمسابقة.");
          return;
        } else if (this.competition.canBack == null) {
          showErrorSnackBar(
              title: "خانات فارغة",
              message: "من فضلك اختر اتاحية الرجوع للسؤال.");
          return;
        }
        break;

      case 1:
        if (this.competition.questions.length < 3) {
          showErrorSnackBar(
              title: "اسئلة المسابقة",
              message: "من فضلك قم بتحديد 3 اسئلة على الاقل.");
          return;
        }

        if (!this.competition.durationPerCompetition!) {
          for (CompetitionQuestion? question in this.competition.questions) {
            if (question!.durationSeconds == null) {
              showErrorSnackBar(
                  title: "سؤال غير محدد توقيته",
                  message: "من فضلك قم بتحديد توقيت لكل الاسئلة.");
              return;
            }
          }
        }
        break;

      case 2:
        if (this.competition.competitionConditions?.churches != null &&
            this.competition.competitionConditions!.churches!.isEmpty) {
          showErrorSnackBar(
              title: "خانات مطلوبة",
              message: "من فضلك حدد كنيسة واحدة على الاقل.");
          return;
        }
        if (this.competition.competitionConditions?.churchRoles != null &&
            this.competition.competitionConditions!.churchRoles!.isEmpty) {
          showErrorSnackBar(
              title: "خانات مطلوبة",
              message: "من فضلك حدد دور في الكنيسة واحد على الاقل.");
          return;
        }
        break;

      case 3:
        if (this.competition.competitionType == null) {
          showErrorSnackBar(
              title: "خانات فارغة", message: "من فضلك حدد نوع المسابقة.");
          return;
        } else if (this.competition.competitionLevel == null) {
          showErrorSnackBar(
              title: "خانات فارغة", message: "من فضلك حدد مستوى المسابقة.");
          return;
        } else if (this.competition.competitionWinner == null) {
          showErrorSnackBar(
              title: "خانات فارغة", message: "من فضلك حدد فائز المسابقة.");
          return;
        } else if (this
                .competition
                .timeEnd!
                .toDate()
                .difference(this.competition.timeStart!.toDate())
                .inMinutes <
            3) {
          showErrorSnackBar(
              title: "خانات خاطئة",
              message:
                  "من فضلك حدد ميعاد نهاية المسابقة بعد 3 دقائق على الاقل من بداية المسابقة.");
          return;
        } else if (this.competition.closed == null) {
          showErrorSnackBar(
              title: "خانات فارغة",
              message: "من فضلك اختر إغلاق المسابقة بكلمة مرور.");
          return;
        } else if (this.competition.closed! &&
            (this.competition.closedPassword!.isEmpty ||
                this.competition.closedPassword!.length < 3)) {
          showErrorSnackBar(
              title: "خانات فارغة",
              message: "من فضلك اكتب كلمة المرور لا تقل عن 3 احرف او ارقام.");
          return;
        }

        if (this.isNewCompetition)
          await _createNewCompetition();
        else
          await _editCompetition();
        break;

      case 4:
        Navigator.pop(Get.context!);
        break;
    }

    // Increment activeStep, when the next button is tapped. However, check for upper bound.
    if (activeStep != upperBound) {
      activeStep++;
      notifyListeners();
    }
  }

  previousClick() {
    // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
    if (activeStep > 0) {
      activeStep--;
      notifyListeners();
    }
  }

  bool isNextEnabled() {
    if (activeStep <= upperBound) return true;
    return false;
  }

  bool isPreviousEnabled() {
    if (activeStep > 0 && activeStep != upperBound) return true;
    return false;
  }

  void onStepReached(int index) {
    activeStep = index;
    notifyListeners();
  }

  Widget stepContent() {
    switch (activeStep) {
      case 0:
        return AdminNewCompetitionDetailsStep(
          competition: this.competition,
          group: this.group,
        );

      case 1:
        return AdminNewCompetitionQuestionsStep(
          competition: this.competition,
          group: this.group,
        );

      case 2:
        return AdminNewCompetitionConditionsStep(
          competition: this.competition,
          group: this.group,
        );

      case 3:
        return AdminNewCompetitionMoreDetailsStep(
          competition: this.competition,
          group: this.group,
        );

      case 4:
        return AdminNewCompetitionShareStep(
          competition: this.competition,
          group: this.group,
          shareOnly: this.step == CompetitionSteps.share,
        );

      default:
        return AdminNewCompetitionDetailsStep(competition: this.competition);
    }
  }

  bool get isEditAvailable =>
      this.competition.timeStart!.toDate().isAfter(RealTime.instance.now!);
}
