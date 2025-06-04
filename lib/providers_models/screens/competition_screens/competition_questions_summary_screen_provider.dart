import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CompetitionQuestionsSummaryScreenProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final AppTeam? team;
  final Competition competition;
  final bool learnAgain;

  CompetitionQuestionsSummaryScreenProvider(
      this.competition, this.team, this.learnAgain);

  void navigateLastQuestion() {
    Navigator.pop(Get.context!, this.competition.questions.length);
  }

  finishCompetition() {
    showLoadingDialog();

    // Finished participant competition.
    if (!learnAgain)
      CompetitionManagement.instance.finishedParticipantCompetition(
          this.competition,
          appUser: (team == null) ? this.appUser! : null,
          team: team);

    Navigator.pop(Get.context!);
    showCompetitionDoneDialog(learnAgain);
  }

  navigateQuestion(int index) {
    Navigator.pop(Get.context!, index + 1);
  }
}
