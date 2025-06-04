import 'package:anawketaby/managements/teams_management.dart';
import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/my_teams_screens/new_team_screen/steps/new_team_details_step.dart';
import 'package:anawketaby/ui/screens/my_teams_screens/new_team_screen/steps/new_team_members_step.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NewTeamScreenProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final AppTeam team;

  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  // Controls the currently active step. Can be set to any valid value i.e., a value that ranges from 0 to upperBound.
  int activeStep = 0;

  // Must be used to control the upper bound of the activeStep variable. Please see next button below the build() method!
  int upperBound = 1;

  NewTeamScreenProvider(this.team);

  get isNewTeam => this.team.id == null;

  _createNewTeam() async {
    showLoadingDialog();

    bool successful =
        await TeamsManagement.instance.createTeam(this.team, this.appUser!);

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم إنشاء الفريق",
        desc: "تم إنشاء الفريق بنجاح.",
        onDismissCallback: (_) => Navigator.pop(Get.context!),
      );
    } else {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "حدث خطأ في اتمام عملية الإنشاء",
      );
    }
  }

  _editTeam() async {
    if (!this.isEditAvailable) {
      showErrorDialog(
          title: 'غير متاح التعديل',
          desc: 'لا يمكن تعديل المسابقة الان بعد مرور وقت بدأها.');
      return;
    }

    showLoadingDialog();

    bool successful =
        await TeamsManagement.instance.editTeam(this.team, this.appUser);

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم تعديل الفريق",
        desc: "تم تعديل الفريق بنجاح.",
        onDismissCallback: (_) => Navigator.pop(Get.context!, team),
      );
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
        if (this.team.membersIDs.length == 1) {
          showErrorSnackBar(
              title: "خانات مطلوبة",
              message: "يجب ان يتكون الفريق اكثر من عضو.");
          return;
        }
        break;

      case 1:
        if (this.team.name.trim().isEmpty || this.team.name.trim().length < 3) {
          showErrorSnackBar(
              title: "خانات مطلوبة",
              message: "من فضلك اكتب اسم الفريق بشكل صحيح.");
          return;
        } else if (this.team.description.trim().isNotEmpty &&
            this.team.description.trim().length < 10) {
          showErrorSnackBar(
              title: "خانات مطلوبة",
              message:
                  "من فضلك اكتب صيحة الفريق اكثر من ١٠ احرف، او اتركها فارغة تماماً.");
          return;
        }

        if (this.isNewTeam)
          await _createNewTeam();
        else
          await _editTeam();
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
    if (activeStep > 0) return true;
    return false;
  }

  void onStepReached(int index) {
    activeStep = index;
    notifyListeners();
  }

  Widget stepContent() {
    switch (activeStep) {
      case 0:
        return NewTeamMembersStep(team: this.team);

      case 1:
        return NewTeamDetailsStep(team: this.team);

      default:
        return NewTeamMembersStep(team: this.team);
    }
  }

  bool get isEditAvailable => true;

  Future deleteTeam() async {
    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.question,
      title: 'تأكيد الحذف',
      desc:
      'هل تريد بالتأكيد حذف هذا الفريق؟ لا يمكن الرجوع في هذه الخطوة.',
      btnOkText: 'نعم',
      btnOkOnPress: () async {
        await TeamsManagement.instance
            .deleteTeam(this.team);
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
      },
      btnCancelText: 'لا',
      btnCancelOnPress: () {},
    )..show();
  }

  static Map memberJSON(AppUser user) {
    return {
      "id": user.id,
      "fullName": user.fullName,
      "fcmToken": user.fcmToken,
      "church": user.church?.name,
      "churchRole": user.churchRole?.name,
      "birthDate": user.birthDate,
      "participatedCompetitions": user.participatedCompetitions,
      "participatedCompetitionsTest": user.participatedCompetitionsTest,
      "gender": user.gender?.name,
      "phone": user.phone,
      "points": user.points,
      "following": user.following,
    };
  }
}
