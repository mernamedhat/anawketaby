import 'package:anawketaby/enums/question_types.dart';
import 'package:anawketaby/models/app_settings.dart';
import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/screens/competition_screens/competition_running_screen_provider.dart';
import 'package:anawketaby/ui/screens/competition_screens/questions_type_widgets/question_join_item.dart';
import 'package:anawketaby/ui/screens/competition_screens/questions_type_widgets/question_mcq_multiple_item.dart';
import 'package:anawketaby/ui/screens/competition_screens/questions_type_widgets/question_mcq_one_item.dart';
import 'package:anawketaby/ui/screens/competition_screens/questions_type_widgets/question_ordering_item.dart';
import 'package:anawketaby/ui/screens/competition_screens/questions_type_widgets/question_true_false_item.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CompetitionRunningScreen extends StatefulWidget {
  final Competition competition;
  final AppTeam? team;
  final int? questionIndex;
  final bool learnAgain;

  CompetitionRunningScreen({
    Key? key,
    required this.competition,
    this.team,
    this.questionIndex,
    this.learnAgain = false,
  }) : super(key: key);

  @override
  State<CompetitionRunningScreen> createState() =>
      _CompetitionRunningScreenState();
}

class _CompetitionRunningScreenState extends State<CompetitionRunningScreen> {
  final AppSettings appSettings =
      Provider.of<SettingsProvider>(Get.context!, listen: false).appSettings;

  final AudioPlayer playerMusic =
      Provider.of<SettingsProvider>(Get.context!, listen: false).playerMusic;

  @override
  void initState() {
    super.initState();
    _playMusic();
  }

  @override
  void dispose() {
    playerMusic.stop();
    super.dispose();
  }

  void _playMusic() async {
    if (appSettings.isCompetitionMusicEnabled) {
      await playerMusic.setAsset("assets/sounds/competition_music.mp3");
      playerMusic.setLoopMode(LoopMode.one);
      playerMusic.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompetitionRunningScreenProvider(this.widget.competition,
          this.widget.team, this.widget.questionIndex, this.widget.learnAgain),
      child: Consumer<CompetitionRunningScreenProvider>(
          builder: (_, provider, __) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppStyles.PRIMARY_COLOR_DARK,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
          ),
          child: WillPopScope(
            onWillPop: () {
              if (provider.learnAgain) return Future.value(true);
              if (widget.competition.canBack!) provider.backQuestion();
              return Future.value(false);
            },
            child: Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SafeArea(
                      child: AppBar(
                          backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                          toolbarHeight: 75.0,
                          title: AutoSizeText(
                            "${provider.competition.name}",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: AppStyles.PRIMARY_COLOR,
                            ),
                          ),
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          actions: [
                            if (this.widget.competition.landSummary)
                              TextButton(
                                onPressed: provider.goSummary,
                                // minWidth: scaleWidth(20.0),
                                style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size.fromWidth(scaleWidth(20.0)))),
                                child: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                ),
                              ),
                          ]),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: scaleHeight(16.0)),
                        child:
                            _questionItem(provider, provider.currentQuestion),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _questionItem(CompetitionRunningScreenProvider provider,
      CompetitionQuestion? question) {
    if (provider.participant == null && !widget.learnAgain)
      return Center(child: CircularProgressIndicator());
    return Column(
      children: [
        Countdown(
          controller: provider.countdownController,
          seconds: (provider.competition.durationPerCompetition!)
              ? provider.competitionRemainingTime
              : question!.durationSeconds ?? provider.competitionRemainingTime,
          interval: Duration(milliseconds: 1000),
          onFinished: provider.onTimerFinished,
          build: (BuildContext context, double time) {
            provider.remainingSeconds = time.round();
            double progress = (time.isNegative)
                ? 0
                : time /
                    ((provider.competition.durationPerCompetition!)
                        ? provider.competition.durationCompetitionSeconds!
                        : question?.durationSeconds ??
                            provider.competition.durationCompetitionSeconds!);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: scaleHeight(4.0),
                    left: scaleWidth(16.0),
                    right: scaleWidth(16.0),
                  ),
                  child: LinearPercentIndicator(
                    lineHeight: 12.0,
                    percent: progress,
                    isRTL: true,
                    progressColor: AppStyles.SECONDARY_COLOR,
                  ),
                ),
                Positioned(
                  right: scaleWidth(16.0) + scaleWidth(300.0 * progress),
                  top: scaleHeight(-16),
                  child: AutoSizeText(
                    "${provider.getTimeString(time.round())}",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: AppStyles.SECONDARY_COLOR,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: scaleHeight(16.0), horizontal: scaleWidth(16.0)),
            child: _questionItemContent(provider, provider.currentQuestion!),
          ),
        ),
        if (widget.competition.canBack! ||
            (widget.competition.canBack! == false &&
                provider.currentQuestion!.questionType != QuestionTypes.tf &&
                provider.currentQuestion!.questionType !=
                    QuestionTypes.mcq_one))
          Container(
            height: scaleHeight(80.0),
            color: AppStyles.PRIMARY_COLOR,
            padding: EdgeInsets.only(
              top: scaleHeight(8.0),
              left: scaleWidth(12.0),
              right: scaleWidth(12.0),
              bottom: scaleHeight(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.competition.canBack!)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: provider.backQuestion,
                      child: Text(
                        "السابق",
                        style: TextStyle(
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontSize: 22.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.THIRD_COLOR_DARK, backgroundColor: AppStyles.THIRD_COLOR, minimumSize: Size(double.infinity, scaleHeight(55.0)),
                      ),
                    ),
                  ),
                if (widget.competition.canBack!)
                  SizedBox(width: scaleWidth(6.0)),
                if (widget.competition.canBack! ||
                    (widget.competition.canBack! == false &&
                        provider.currentQuestion!.questionType != QuestionTypes.tf &&
                        provider.currentQuestion!.questionType != QuestionTypes.mcq_one))
                  Expanded(
                    child: ElevatedButton(
                      onPressed: provider.nextQuestion,
                      child: Text(
                        "التالي",
                        style: TextStyle(
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontSize: 22.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.THIRD_COLOR_DARK, backgroundColor: AppStyles.THIRD_COLOR, minimumSize: Size(double.infinity, scaleHeight(55.0)),
                      ),
                    ),
                  ),
              ],
            ),

          ),
      ],
    );
  }

  Widget _questionItemContent(CompetitionRunningScreenProvider provider,
      CompetitionQuestion currentQuestion) {
    switch (currentQuestion.questionType) {
      case QuestionTypes.tf:
        return QuestionTrueFalseItem(
          questionNo: provider.questionNo,
          question: currentQuestion,
          nextQuestionFunction: provider.nextQuestion,
        );
      case QuestionTypes.mcq_one:
        return QuestionMCQOneItem(
          questionNo: provider.questionNo,
          question: currentQuestion,
          nextQuestionFunction: provider.nextQuestion,
        );
      case QuestionTypes.mcq_multiple:
        return QuestionMCQMultipleItem(
            questionNo: provider.questionNo, question: currentQuestion);
      case QuestionTypes.ordering:
        return QuestionOrderingItem(
            questionNo: provider.questionNo, question: currentQuestion);
      case QuestionTypes.join:
        return QuestionJoinItem(
            questionNo: provider.questionNo, question: currentQuestion);
      default:
        return Container();
    }
  }
}
