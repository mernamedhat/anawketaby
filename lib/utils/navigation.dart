import 'package:anawketaby/managements/groups_management.dart';
import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_info_screen.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_start_screen.dart';
import 'package:anawketaby/ui/screens/profile_screens/profile_screen.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future playNavigationSound() async {
  // await Provider.of<SettingsProvider>(Get.context, listen: false)
  //     .player
  //     .play("sounds/sound_navigation.mp3", mode: PlayerMode.LOW_LATENCY);
}

Future navigateTo(Widget page, {bool mustLogged = false}) async {
  // await playNavigationSound();
  return await Get.to(
    page,
    transition: Transition.fadeIn,
    curve: Curves.easeIn,
    duration: Duration(milliseconds: 400),
  );
}

Future navigateReplacement(Widget page, {bool mustLogged = false}) async {
  // await playNavigationSound();
  return await Get.off(
    page,
    transition: Transition.fadeIn,
    curve: Curves.easeIn,
    duration: Duration(milliseconds: 400),
  );
}

Future navigateRemoveUntil(Widget page, predict,
    {bool mustLogged = false}) async {
  // await playNavigationSound();
  return await Get.offAll(
    page,
    transition: Transition.fadeIn,
    curve: Curves.easeIn,
    duration: Duration(milliseconds: 400),
    predicate: predict,
  );
}

Future<void> navigateToCompetition(Competition competition) async {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  // Admin can see all competition info page directly
  if (appUser?.isAdmin == true) {
    navigateTo(CompetitionInfoScreen(competition: competition));
    return;
  }

  if (competition.groupsIDs != null) {
    bool isUserInAnyGroup = false;
    for (String groupID in competition.groupsIDs!) {
      final AppGroup? group =
          await GroupsManagement.instance.getAppGroupByID(groupID);
      if (group != null) {
        isUserInAnyGroup = group.leaderID == appUser?.id ||
            group.moderatorsIDs.contains(appUser?.id) ||
            group.membersIDs.contains(appUser?.id);
        if (isUserInAnyGroup) break;
      }
    }
    print(competition.groupsIDs);
    print(isUserInAnyGroup);
    if (!isUserInAnyGroup) {
      showErrorDialog(
          title: "غير مسموح",
          desc:
              "غير مسموح لك بالاشتراك في المسابقة لانها خاصة بمجموعة انت لست منضم إليها.");
      return;
    }
  }

  if (competition.timeEnd!.toDate().isBefore(RealTime.instance.now!) &&
      competition.timeCalculateResults!
          .toDate()
          .isAfter(RealTime.instance.now!) &&
      appUser!.firebaseUser!.uid != competition.creatorID) {
    showErrorDialog(
        title: "انتهت المسابقة",
        desc: "لقد انتهت المسابقة، جاري الأن حساب النتائج.");
    return;
  }

  if (competition.timeEnd!.toDate().isAfter(RealTime.instance.now!) &&
      appUser!.firebaseUser!.uid != competition.creatorID) {
    if (!competition.isUserAcceptToEnter(appUser)) {
      showErrorDialog(
          title: "غير مسموح",
          desc:
              "غير مسموح لك بالاشتراك في المسابقة لان حسابك لا ينطبق عليه شروط المسابقة.");
      return;
    }

    if (competition.isUserMustFollow(appUser)) {
      showErrorDialog(
          title: "غير مسموح",
          desc:
              "يجب عليك متابعة صانع المسابقة اولا (${competition.creatorFullName}).");
      return;
    }

    navigateTo(CompetitionStartScreen(competition: competition));
  } else {
    navigateTo(CompetitionInfoScreen(competition: competition));
  }
}

Future navigateToProfile(String? userID) async {
  AppUser profileUser = await UsersManagement.instance.getUserByID(userID);
  navigateTo(ProfileScreen(userProfile: profileUser));
}

void showLoadingDialog() {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: scaleHeight(20.0)),
              Text(
                "جاري التحميل",
                style: TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    },
  );
}

void showCompetitionDoneDialog(bool learnAgain) {
  AwesomeDialog(
    context: Get.context!,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.success,
    title: 'نهاية الاسئلة',
    desc: (learnAgain)
        ? 'تم إنهاء جميع اسئلة المسابقة، قم بالذهاب لصفحة التقرير بالكامل لرؤية الاجابات الصحيحة.'
        : 'تم إنهاء جميع اسئلة المسابقة، انتظر اعلان النتيجة',
    btnOkText: "موافق",
    btnOkOnPress: () =>
        Navigator.of(Get.context!).popUntil((route) => route.isFirst),
    // onDissmissCallback: () {
    //   navigateRemoveUntil(HomeScreen(), (Route<dynamic> route) => false);
    // },
  )..show();
}

void showSuccessDialog(
    {String? title, String? desc, Function? onDismissCallback}) {
  AwesomeDialog(
    context: Get.context!,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.success,
    title: '$title',
    desc: '$desc',
    onDismissCallback: onDismissCallback as dynamic Function(DismissType)?,
  )..show();
}

void showInfoDialog({String? title, String? desc}) {
  AwesomeDialog(
    context: Get.context!,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.info,
    title: '$title',
    desc: '$desc',
  )..show();
}

void showErrorDialog({
  String? title,
  String? desc,
  Function? onDismissCallback,
  Widget? btnOk,
  Widget? btnCancel,
}) {
  AwesomeDialog(
    context: Get.context!,
    animType: AnimType.scale,
    headerAnimationLoop: false,
    dialogType: DialogType.error,
    title: '$title',
    desc: '$desc',
    onDismissCallback: onDismissCallback as dynamic Function(DismissType)?,
    btnOk: btnOk,
    btnCancel: btnCancel,
  )..show();
}

void showErrorSnackBar({title, message}) {
  Get.snackbar(
    "$title",
    "$message",
    snackPosition: SnackPosition.TOP,
    margin: EdgeInsets.symmetric(
        vertical: scaleHeight(30.0), horizontal: scaleWidth(12.0)),
    borderWidth: 2.0,
    borderColor: Color(0xffee1e1e),
    backgroundColor: Colors.red.shade600,
    duration: const Duration(seconds: 4),
    colorText: AppStyles.TEXT_PRIMARY_COLOR,
  );
}

void showSuccessfulSnackBar({title, message}) {
  Get.snackbar(
    "$title",
    "$message",
    snackPosition: SnackPosition.TOP,
    margin: EdgeInsets.symmetric(
        vertical: scaleHeight(30.0), horizontal: scaleWidth(12.0)),
    borderWidth: 2.0,
    borderColor: Color(0xff1eee1e),
    backgroundColor: Colors.green.shade600,
    duration: const Duration(seconds: 4),
    colorText: AppStyles.TEXT_PRIMARY_COLOR,
  );
}
