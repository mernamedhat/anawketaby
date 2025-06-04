import 'package:anawketaby/enums/question_types.dart';
import 'package:anawketaby/models/app_settings.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/screens/competition_screens/competition_test_screens/competition_test_running_screen_provider.dart';
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
import 'package:provider/provider.dart';

class CompetitionTestRunningScreen extends StatefulWidget {
  final Competition competition;
  final int? questionIndex;

  const CompetitionTestRunningScreen({
    Key? key,
    required this.competition,
    this.questionIndex,
  }) : super(key: key);

  @override
  State<CompetitionTestRunningScreen> createState() =>
      _CompetitionTestRunningScreenState();
}

class _CompetitionTestRunningScreenState
    extends State<CompetitionTestRunningScreen> {
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
      create: (_) => CompetitionTestRunningScreenProvider(
          this.widget.competition, this.widget.questionIndex),
      child: Consumer<CompetitionTestRunningScreenProvider>(
          builder: (_, provider, __) {
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
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: scaleHeight(16.0)),
                      child: _questionItem(provider, provider.currentQuestion),
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

  Widget _questionItem(CompetitionTestRunningScreenProvider provider,
      CompetitionQuestion? question) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: scaleHeight(16.0), horizontal: scaleWidth(16.0)),
            child: _questionItemContent(provider, provider.currentQuestion!),
          ),
        ),
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
              Expanded(
                child:ElevatedButton(
                  onPressed: provider.answerQuestion,
                  child: Text(
                    "جاوب",
                    style: const TextStyle(
                      color: AppStyles.TEXT_PRIMARY_COLOR,
                      fontSize: 22.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppStyles.THIRD_COLOR, backgroundColor: AppStyles.THIRD_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(55.0)),
                  ),
                ),

              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _questionItemContent(CompetitionTestRunningScreenProvider provider,
      CompetitionQuestion currentQuestion) {
    switch (currentQuestion.questionType) {
      case QuestionTypes.tf:
        return QuestionTrueFalseItem(
          questionNo: provider.questionNo,
          question: currentQuestion,
          nextQuestionFunction: provider.answerQuestion,
        );
      case QuestionTypes.mcq_one:
        return QuestionMCQOneItem(
          questionNo: provider.questionNo,
          question: currentQuestion,
          nextQuestionFunction: provider.answerQuestion,
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
