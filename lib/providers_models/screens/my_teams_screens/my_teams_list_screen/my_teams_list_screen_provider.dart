import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/my_teams_screens/new_team_screen/new_team_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyTeamsListScreenProvider extends ChangeNotifier {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  void createNewTeam() {
    navigateTo(NewTeamScreen());
  }
}
