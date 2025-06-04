import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/screens/my_teams_screens/new_team_screen/new_team_screen_provider.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:flutter/material.dart';

class NewTeamMembersStepProvider extends ChangeNotifier {
  final AppTeam team;

  final TextEditingController phoneController = TextEditingController();

  String? countryCode = "+20";

  bool _isLoading = false;

  NewTeamMembersStepProvider(this.team);

  Future addMember() async {
    isLoading = true;

    if (countryCode == "+20" && phoneController.text.trim().startsWith("0")) {
      phoneController.text = phoneController.text.trim().substring(1);
    }

    String phone = "$countryCode${phoneController.text.trim()}";

    for (final memberID in team.membersIDs) {
      if (team.membersProfiles[memberID]["phone"] == phone) {
        isLoading = false;
        showErrorSnackBar(
            title: "عضو موجود مسبقاً", message: "هذا العضو بالفعل في الفريق.");
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

    team.membersIDs.add(member.id!);
    if (member.fcmToken != null) team.membersFCMTokens.add(member.fcmToken!);
    team.membersProfiles[member.id!] = NewTeamScreenProvider.memberJSON(member);

    phoneController.text = "";

    showSuccessfulSnackBar(
        title: "تمت الاضافة", message: "تمت اضافة عضو جديد في الفريق.");

    isLoading = false;
  }

  removeMember(Map memberMap) {
    team.membersIDs.remove(memberMap["id"]);
    team.membersFCMTokens.remove(memberMap["fcmToken"]);
    team.membersProfiles.remove(memberMap["id"]);
    notifyListeners();
  }

  makeLeader(Map memberMap) {
    team.leaderID = memberMap["id"];
    team.leaderFullName = memberMap["fullName"];
    notifyListeners();
  }

  @override
  void notifyListeners() {
    _setFields();
    super.notifyListeners();
  }

  _setFields() {
    // this.team.name = nameController.text.trim();
    // this.team.description = descriptionController.text.trim();
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
