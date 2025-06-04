import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/screens/my_groups_screens/new_group_screen/new_group_screen_provider.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewGroupMembersStepProvider extends ChangeNotifier {
  final AppGroup group;

  final TextEditingController phoneController = TextEditingController();

  String? countryCode = "+20";

  bool _isLoading = false;

  NewGroupMembersStepProvider(this.group);

  Future addMember() async {
    // Exclude moderators and leader him/her-self
    if (group.membersIDs.length - group.moderatorsIDs.length - 1 >=
        group.groupFeature.membersLimit) {
      showErrorSnackBar(
          title: "عدد الأعضاء مكتمل",
          message:
              "لا يمكن إضافة اعضاء اكثر من ${group.groupFeature.membersLimit}");
      return;
    }

    isLoading = true;

    if (countryCode == "+20" && phoneController.text.trim().startsWith("0")) {
      phoneController.text = phoneController.text.trim().substring(1);
    }

    String phone = "$countryCode${phoneController.text.trim()}";

    for (final memberID in group.membersIDs) {
      if (group.membersProfiles[memberID]["phone"] == phone) {
        isLoading = false;
        showErrorSnackBar(
            title: "عضو موجود مسبقاً",
            message: "هذا العضو بالفعل في المجموعة.");
        return;
      }
    }

    AppUser? member = await UsersManagement.instance.getUserByPhone(phone);

    if (member == null) {
      isLoading = false;
      showErrorSnackBar(
          title: "رقم موبايل خطأ",
          message: "من فضلك تأكد من رقم الموبايل للعضو.");
      return;
    }

    group.membersIDs.add(member.id!);
    if (member.fcmToken != null) group.membersFCMTokens.add(member.fcmToken!);
    group.membersProfiles[member.id!] =
        NewGroupScreenProvider.memberJSON(member);

    phoneController.text = "";

    showSuccessfulSnackBar(
        title: "تمت الاضافة", message: "تمت اضافة عضو جديد في المجموعة.");

    isLoading = false;
  }

  removeMember(Map memberMap) {
    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.question,
      title: 'تأكيد الحذف',
      desc: 'هل تريد بالتأكيد حذف هذا العضو؟ لا يمكن الرجوع في هذه الخطوة.',
      btnOkText: 'نعم',
      btnOkOnPress: () async {
        group.membersIDs.remove(memberMap["id"]);
        group.membersFCMTokens.remove(memberMap["fcmToken"]);
        group.membersProfiles.remove(memberMap["id"]);
        if (group.moderatorsIDs.contains(memberMap["id"])) {
          group.moderatorsIDs.remove(memberMap["id"]);
        }
        notifyListeners();
      },
      btnCancelText: 'لا',
      btnCancelOnPress: () {},
    )..show();
  }

  makeModerator(Map memberMap) {
    if (group.moderatorsIDs.length < group.groupFeature.moderatorsLimit) {
      group.moderatorsIDs.add(memberMap["id"]);
      notifyListeners();
    } else {
      showErrorSnackBar(
          title: "عدد الإشراف مكتمل",
          message:
              "لا يمكن إضافة مشرفين اكثر من ${group.groupFeature.moderatorsLimit}");
    }
  }

  removeModerator(Map memberMap) {
    group.moderatorsIDs.remove(memberMap["id"]);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    _setFields();
    super.notifyListeners();
  }

  _setFields() {
    // this.group.name = nameController.text.trim();
    // this.group.description = descriptionController.text.trim();
  }

  textChanged(String value) {
    notifyListeners();
  }

  onNumberChanged() {
    notifyListeners();
  }

  onChoiceChanged() {
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
