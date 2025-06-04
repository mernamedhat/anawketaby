import 'package:anawketaby/managements/groups_management.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/my_groups_screens/new_group_screen/steps/new_group_details_step.dart';
import 'package:anawketaby/ui/screens/my_groups_screens/new_group_screen/steps/new_group_members_step.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NewGroupScreenProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final AppGroup group;

  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  // Controls the currently active step. Can be set to any valid value i.e., a value that ranges from 0 to upperBound.
  int activeStep = 0;

  // Must be used to control the upper bound of the activeStep variable. Please see next button below the build() method!
  int upperBound = 1;

  NewGroupScreenProvider(this.group);

  get isNewGroup => this.group.id == null;

  _createNewGroup() async {
    showLoadingDialog();

    if (this.group.name.isEmpty) {
      showErrorSnackBar(
          title: "خانات فارغة", message: "من فضلك اكتب اسم المجموعة.");
      Navigator.pop(Get.context!);
      return;
    }

    final myGroups =
        await GroupsManagement.instance.getMyGroupsFuture(appUser!);

    List myGroupsNames = myGroups.docs
        .where((e) =>
            (e.data() as Map<String, dynamic>)["leaderID"] ==
            appUser?.firebaseUser?.uid)
        .map((e) => (e.data() as Map<String, dynamic>)["name"].toLowerCase())
        .toList();

    if (myGroupsNames.contains(this.group.name)) {
      showErrorSnackBar(
          title: "خانات غير صحيحة", message: "اسم المجموعة متكرر لديك، من فضلك اكتب اسم مجموعة مختلف.");
      Navigator.pop(Get.context!);
      return;
    }

    bool successful =
        await GroupsManagement.instance.createGroup(this.group, this.appUser!);

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم إنشاء المجموعة",
        desc: "تم إنشاء المجموعة بنجاح.",
        onDismissCallback: (_) => Navigator.pop(Get.context!),
      );
    } else {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "حدث خطأ في اتمام عملية الإنشاء",
      );
    }
  }

  _editGroup() async {
    if (!this.isEditAvailable) {
      showErrorDialog(
          title: 'غير متاح التعديل',
          desc: 'لا يمكن تعديل المجموعة الان بعد مرور وقت بدأها.');
      return;
    }

    showLoadingDialog();

    bool successful =
        await GroupsManagement.instance.editGroup(this.group, this.appUser);

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم تعديل المجموعة",
        desc: "تم تعديل المجموعة بنجاح.",
        onDismissCallback: (_) => Navigator.pop(Get.context!, group),
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
        if (this.group.membersIDs.length == 1) {
          showErrorSnackBar(
              title: "خانات مطلوبة",
              message: "يجب ان تتكون المجموعة اكثر من عضو.");
          return;
        }
        break;

      case 1:
        if (this.group.name.trim().isEmpty ||
            this.group.name.trim().length < 3) {
          showErrorSnackBar(
              title: "خانات مطلوبة",
              message: "من فضلك اكتب اسم المجموعة بشكل صحيح.");
          return;
        } else if (this.group.description.trim().isNotEmpty &&
            this.group.description.trim().length < 10) {
          showErrorSnackBar(
              title: "خانات مطلوبة",
              message:
                  "من فضلك اكتب وصف المجموعة اكثر من ١٠ احرف، او اتركها فارغة تماماً.");
          return;
        }

        if (this.isNewGroup)
          await _createNewGroup();
        else
          await _editGroup();
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
        return NewGroupMembersStep(group: this.group);

      case 1:
        return NewGroupDetailsStep(group: this.group);

      default:
        return NewGroupMembersStep(group: this.group);
    }
  }

  bool get isEditAvailable => true;

  Future deleteGroup() async {
    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.question,
      title: 'تأكيد الحذف',
      desc: 'هل تريد بالتأكيد حذف هذه المجموعة؟ لا يمكن الرجوع في هذه الخطوة.',
      btnOkText: 'نعم',
      btnOkOnPress: () async {
        await GroupsManagement.instance.deleteGroup(this.group);
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
