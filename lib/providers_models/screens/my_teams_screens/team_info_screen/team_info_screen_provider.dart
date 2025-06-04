import 'package:anawketaby/managements/teams_management.dart';
import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/my_teams_screens/new_team_screen/new_team_screen.dart';
import 'package:anawketaby/ui/screens/my_teams_screens/team_info_screen/team_info_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TeamInfoScreenProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final AppTeam team;

  TeamInfoScreenProvider(this.team);

  get isLeader => team.leaderID == appUser!.id;

  Future editTeam() async {
    AppTeam? updatedTeam = await navigateTo(NewTeamScreen(team: team));
    if (updatedTeam != null) {
      await navigateReplacement(TeamInfoScreen(team: updatedTeam));
    }
  }

  Future leaveTeam() async {
    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.question,
      title: 'تأكيد المغادرة',
      desc: 'هل تريد بالتأكيد مغادرة هذا الفريق؟ لا يمكن الرجوع في هذه الخطوة.',
      btnOkText: 'نعم',
      btnOkOnPress: () async {
        await TeamsManagement.instance
            .leaveTeam(team, team.membersProfiles[appUser!.id!]);
        Navigator.pop(Get.context!);
      },
      btnCancelText: 'لا',
      btnCancelOnPress: () {},
    )..show();
  }

  Future removeMember(Map memberMap) async {}
}
