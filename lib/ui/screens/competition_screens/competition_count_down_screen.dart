import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_running_screen.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_test_screens/competition_test_running_screen.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class CompetitionCountDownScreen extends StatelessWidget {
  final Competition competition;
  final AppTeam? team;
  final bool learnAgain;
  final bool isTestYourself;
  final int? questionIndex;

  final appSettings =
      Provider.of<SettingsProvider>(Get.context!, listen: false).appSettings;

  final AudioPlayer player =
      Provider.of<SettingsProvider>(Get.context!, listen: false).player;

  late final CountdownTimerController countDownTimerController;

  CompetitionCountDownScreen({
    Key? key,
    required this.competition,
    this.team,
    this.learnAgain = false,
    this.isTestYourself = false,
    this.questionIndex,
  }) : super(key: key) {
    countDownTimerController = CountdownTimerController(
      endTime:
          DateTime.now().add(const Duration(seconds: 4)).millisecondsSinceEpoch,
      onEnd: onCountDownEnd,
    );
  }

  void onCountDownEnd() {
    Future.delayed(Duration(seconds: 1), () {
      if (isTestYourself) {
        navigateReplacement(CompetitionTestRunningScreen(
          competition: this.competition,
          questionIndex: questionIndex,
        ));
      } else {
        navigateReplacement(CompetitionRunningScreen(
          competition: competition,
          team: team,
          learnAgain: learnAgain,
        ));
      }
    });
  }

  void _playTick() async {
    if (appSettings.isCompetitionTimerSoundEnabled) {
      player.setAsset("assets/sounds/clock_tick.wav");
      player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppStyles.PRIMARY_COLOR_DARK,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
      ),
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: AppStyles.PRIMARY_COLOR,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: Center(
                child: Stack(
                  children: [
                    RippleAnimation(
                        repeat: true,
                        color: AppStyles.INACTIVE_COLOR,
                        minRadius: 90,
                        ripplesCount: 6,
                        child: Container()),
                    Center(
                      child: CountdownTimer(
                        controller: countDownTimerController,
                        widgetBuilder: (_, currentRemainingTime) {
                          _playTick();
                          return AutoSizeText(
                            (currentRemainingTime?.sec == null)
                                ? "ابدأ"
                                : "${currentRemainingTime?.sec ?? 0}",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 124.0,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
