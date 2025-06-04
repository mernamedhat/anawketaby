import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/providers_models/screens/my_teams_screens/new_team_screen/new_team_screen_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';

enum TeamSteps { members, details }

class NewTeamScreen extends StatelessWidget {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final AppTeam? team;

  NewTeamScreen({Key? key, this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewTeamScreenProvider(
        this.team ??
            AppTeam(
              creatorID: appUser!.id!,
              creatorFullName: appUser!.fullName!,
              leaderID: appUser!.id!,
              leaderFullName: appUser!.fullName!,
              membersIDs: [appUser!.id!],
              membersFCMTokens: [appUser!.fcmToken!],
              membersProfiles: {
                "${appUser?.id}": NewTeamScreenProvider.memberJSON(appUser!),
              },
              name: '',
              description: '',
              participatedCompetitions: [],
            ),
      ),
      child: Consumer<NewTeamScreenProvider>(builder: (_, provider, __) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppStyles.PRIMARY_COLOR_DARK,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
          ),
          child: Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              color: AppStyles.BACKGROUND_COLOR,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SafeArea(
                    child: AppBar(
                      backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                      toolbarHeight: 75.0,
                      title: AutoSizeText(
                        (provider.isNewTeam) ? "فريق جديد" : "تعديل فريق",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: AppStyles.PRIMARY_COLOR,
                        ),
                      ),
                      centerTitle: true,
                      leading: TextButton(
                        child: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                      actions: [
                        if (!provider.isNewTeam)
                          TextButton(
                            child: Text(
                              "حذف الفريق",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppStyles.PRIMARY_COLOR_DARK,
                              ),
                            ),
                            onPressed: provider.deleteTeam,
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        IconStepper(
                          icons: [
                            Icon(
                              Icons.group,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                            ),
                            Icon(
                              Icons.list_outlined,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                            ),
                          ],
                          // activeStep property set to activeStep variable defined above.
                          activeStep: provider.activeStep,
                          // This ensures step-tapping updates the activeStep.
                          onStepReached: provider.onStepReached,
                          activeStepColor: AppStyles.SELECTION_COLOR,
                          stepColor: AppStyles.TEXT_THIRD_COLOR,
                          lineColor: Colors.white,
                          activeStepBorderColor: Colors.white,
                          enableNextPreviousButtons: false,
                          enableStepTapping: false,
                          steppingEnabled: false,
                          stepRadius: 16.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: scaleWidth(8.0)),
                            child: provider.stepContent(),
                          ),
                        ),
                        Container(
                          height: scaleHeight(74.0),
                          padding: EdgeInsets.symmetric(
                              vertical: scaleHeight(4.0),
                              horizontal: scaleWidth(12.0)),
                          color: AppStyles.PRIMARY_COLOR,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              previousButton(provider),
                              nextButton(provider),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Returns the next button.
  Widget nextButton(NewTeamScreenProvider provider) {
    return ElevatedButton(
      onPressed: provider.isNextEnabled() ? provider.nextClick : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
        backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
        minimumSize: Size(scaleWidth(140.0), scaleHeight(60.0)), // Width & Height
      ),
      child: const Text(
        "التالي",
        style: TextStyle(
          color: AppStyles.TEXT_PRIMARY_COLOR,
          fontSize: 20.0,
        ),
      ),
    )
    ;
  }

  /// Returns the previous button.
  Widget previousButton(NewTeamScreenProvider provider) {
    return ElevatedButton(
      onPressed: provider.isPreviousEnabled() ? provider.previousClick : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
        backgroundColor: AppStyles.SECONDARY_COLOR_DARK, // Button background color
        minimumSize: Size(scaleWidth(140.0), scaleHeight(60.0)), // Width & Height
      ),
      child: const Text(
        "السابق",
        style: TextStyle(
          color: AppStyles.TEXT_PRIMARY_COLOR,
          fontSize: 20.0,
        ),
      ),
    )
    ;
  }
}
