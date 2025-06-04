import 'package:anawketaby/enums/competition_type.dart';
import 'package:anawketaby/enums/competition_winner.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/screens/competition_screens/competition_start_screen_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:provider/provider.dart';

class CompetitionStartScreen extends StatelessWidget {
  final Competition competition;
  final bool learnAgain;

  const CompetitionStartScreen(
      {Key? key, required this.competition, this.learnAgain = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          CompetitionStartScreenProvider(this.competition, this.learnAgain),
      child:
          Consumer<CompetitionStartScreenProvider>(builder: (_, provider, __) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppStyles.PRIMARY_COLOR_DARK,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
          ),
          child: Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: AppStyles.PRIMARY_COLOR,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints:
                            BoxConstraints(maxHeight: scaleHeight(60.0)),
                        child: AutoSizeText(
                          "${provider.competition.name}",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 48.0,
                            color: AppStyles.TEXT_PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: scaleHeight(12.0)),
                      AutoSizeText(
                        "${provider.competition.creatorFullName}",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: scaleHeight(24.0)),
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              "${provider.competitionQuestionsCount}",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 28.0,
                                color: AppStyles.TEXT_PRIMARY_COLOR,
                              ),
                            ),
                          ),
                          Container(
                            height: scaleHeight(32.0),
                            child: VerticalDivider(
                              width: scaleWidth(8.0),
                              thickness: 2.0,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              "${provider.competitionTime}",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28.0,
                                color: AppStyles.TEXT_PRIMARY_COLOR,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: scaleHeight(22.0)),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                AutoSizeText(
                                  "قيمة الاشتراك",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                  ),
                                ),
                                SizedBox(height: scaleHeight(4.0)),
                                AutoSizeText(
                                  "${provider.competition.participationPoints} نقط",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: scaleHeight(32.0),
                            child: VerticalDivider(
                              width: scaleWidth(8.0),
                              thickness: 2.0,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                AutoSizeText(
                                  "جائزة المسابقة",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                  ),
                                ),
                                SizedBox(height: scaleHeight(4.0)),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AutoSizeText(
                                      "${provider.competition.participationPoints! * provider.competition.participantsCount!}",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: AppStyles.TEXT_PRIMARY_COLOR,
                                      ),
                                    ),
                                    SizedBox(width: scaleWidth(8.0)),
                                    AutoSizeText(
                                      "لـ${provider.competition.competitionWinner!.translate()}",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: AppStyles.TEXT_PRIMARY_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: scaleHeight(22.0)),
                      ElevatedButton(
                        onPressed: provider.competitionDetails,
                        child: Text(
                          "تفاصيل المسابقة",
                          style: TextStyle(
                            color: AppStyles.TEXT_PRIMARY_COLOR,
                            fontSize: 14.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppStyles.THIRD_COLOR_DARK, backgroundColor: AppStyles.THIRD_COLOR, minimumSize: Size(150.0, scaleHeight(55.0)),
                        ),
                      ),
                      SizedBox(height: scaleHeight(10.0)),
                      ElevatedButton(
                        onPressed: provider.shareCompetition,
                        child: Text(
                          "شارك المسابقة",
                          style: TextStyle(
                            color: AppStyles.TEXT_PRIMARY_COLOR,
                            fontSize: 14.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppStyles.THIRD_COLOR_DARK, backgroundColor: AppStyles.THIRD_COLOR, minimumSize: Size(150.0, scaleHeight(55.0)),
                        ),
                      ),

                      SizedBox(height: scaleHeight(64.0)),
                      if (provider.competition.timeStart!
                          .toDate()
                          .isAfter(DateTime.now()))
                        Column(
                          children: [
                            AutoSizeText(
                              "متبقي من الوقت",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: AppStyles.TEXT_PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: scaleHeight(16.0)),
                            CountdownTimer(
                              controller: provider.countDownTimerController,
                              widgetBuilder: (_, currentRemainingTime) {
                                return AutoSizeText(
                                  "${_builderCountdownTimer(currentRemainingTime)}",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: scaleHeight(32.0)),
                          ],
                        ),
                      if (provider.competition.timeStart!
                          .toDate()
                          .isAfter(DateTime.now()) &&
                          !provider.appUser!.participatedCompetitions
                              .contains(provider.competition.id) &&
                          provider.competition.competitionType == CompetitionType.individual)
                        ElevatedButton(
                          onPressed: provider.participateIndividualCompetition,
                          child: Text(
                            "اشترك في المسابقة",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 22.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.THIRD_COLOR_DARK, backgroundColor: AppStyles.THIRD_COLOR, minimumSize: Size(310.0, scaleHeight(55.0)),
                          ),
                        ),
                      if (provider.competition.timeStart!
                          .toDate()
                          .isAfter(DateTime.now()) &&
                          provider.appUser!.participatedCompetitions
                              .contains(provider.competition.id) &&
                          provider.competition.competitionType == CompetitionType.individual)
                        ElevatedButton(
                          onPressed: provider.unParticipateCompetition,
                          child: Text(
                            "إلغاء الاشتراك",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 22.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.SECONDARY_COLOR_DARK, backgroundColor: AppStyles.SECONDARY_COLOR, minimumSize: Size(310.0, scaleHeight(55.0)),
                          ),
                        ),
                      if (provider.competition.timeStart!
                          .toDate()
                          .isBefore(DateTime.now()))
                        ElevatedButton(
                          onPressed: provider.startCompetition,
                          child: Text(
                            "بدأ الأن",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 22.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.THIRD_COLOR_DARK, backgroundColor: AppStyles.THIRD_COLOR, minimumSize: Size(310.0, scaleHeight(55.0)),
                          ),
                        ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  String _builderCountdownTimer(CurrentRemainingTime? time) {
    if (time == null) {
      return "";
    }
    String value = '';
    if (time.days != null) {
      var days = time.days!;
      value = '$value$days يوم ';
    }
    var hours = _getNumberAddZero(time.hours ?? 0);
    value = '$value$hours : ';
    var min = _getNumberAddZero(time.min ?? 0);
    value = '$value$min : ';
    var sec = _getNumberAddZero(time.sec ?? 0);
    value = '$value$sec';
    return value;
  }

  /// 1 -> 01
  String _getNumberAddZero(int? number) {
    assert(number != null);
    if (number! < 10) {
      return "0" + number.toString();
    }
    return number.toString();
  }
}
