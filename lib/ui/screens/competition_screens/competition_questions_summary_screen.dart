import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/providers_models/screens/competition_screens/competition_questions_summary_screen_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CompetitionQuestionsSummaryScreen extends StatelessWidget {
  final Competition competition;
  final AppTeam? team;
  final bool learnAgain;

  const CompetitionQuestionsSummaryScreen({
    Key? key,
    required this.competition,
    this.team,
    this.learnAgain = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompetitionQuestionsSummaryScreenProvider(
          this.competition, this.team, this.learnAgain),
      child: Consumer<CompetitionQuestionsSummaryScreenProvider>(
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
              if (competition.canBack!) provider.navigateLastQuestion();
              return Future.value(false);
            },
            child: Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: scaleHeight(16.0),
                            horizontal: scaleWidth(8.0)),
                        child: Column(
                          children: [
                            Text(
                              "لقد انتهت الاسئلة",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: AppStyles.PRIMARY_COLOR,
                              ),
                            ),
                            SizedBox(height: scaleHeight(8.0)),
                            Expanded(
                              child: ListView.separated(
                                itemCount: competition.questions.length,
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                itemBuilder: (context, index) {
                                  CompetitionQuestion question =
                                      competition.questions[index];

                                  return InkWell(
                                    onTap: competition.canBack!
                                        ? () => provider.navigateQuestion(index)
                                        : null,
                                    child: ListTile(
                                      leading: RoundedContainer(
                                        height: scaleHeight(35.0),
                                        width: scaleWidth(35.0),
                                        padding: EdgeInsets.symmetric(
                                            vertical: scaleHeight(2.0),
                                            horizontal: scaleWidth(2.0)),
                                        backgroundColor:
                                            AppStyles.PRIMARY_COLOR,
                                        child: AutoSizeText(
                                          "${index + 1}",
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: AppStyles.TEXT_PRIMARY_COLOR,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      title: Text('${question.content}'),
                                      trailing: competition.canBack!
                                          ? Icon(Icons.navigate_next)
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
                      child: ElevatedButton(
                        onPressed: provider.finishCompetition,
                        child: Text(
                          "إنهاء",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: AppStyles.TEXT_PRIMARY_COLOR,
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
            ),
          ),
        );
      }),
    );
  }
}
