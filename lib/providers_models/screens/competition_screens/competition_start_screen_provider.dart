// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:anawketaby/enums/competition_level.dart';
import 'package:anawketaby/enums/competition_type.dart';
import 'package:anawketaby/enums/competition_winner.dart';
import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/managements/teams_management.dart';
import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_count_down_screen.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/ui/widgets/team_vertical_tile.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/bible_util.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CompetitionStartScreenProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  Competition competition;
  final bool learnAgain;

  StreamSubscription? _competitionStream;

  CountdownTimerController countDownTimerController =
      CountdownTimerController(endTime: 0);

  CompetitionStartScreenProvider(this.competition, this.learnAgain) {
    _competitionStream = CompetitionManagement.instance
        .getCompetitionStream(this.competition.id)
        .listen((event) {
      if (!event.exists) {
        showErrorDialog(
          title: "تم مسح المسابقة",
          desc: "للاسف، تم مسح المسابقة في الوقت الحالي، يجب الرجوع.",
          onDismissCallback: (DismissType type) {
            Navigator.pop(Get.context!);
          },
        );
        _competitionStream!.cancel();
        _competitionStream = null;
        return;
      }
      // this.competition = Competition.fromJson(event.data());
       this.competition = Competition.fromJson(event.data() as Map<String, dynamic>);
      countDownTimerController = CountdownTimerController(
        endTime: this.competition.timeStart!.toDate().millisecondsSinceEpoch,
        onEnd: onCountDownEnd,
      );
      notifyListeners();
    });
  }

  void onCountDownEnd() {
    Future.delayed(Duration(seconds: 1), () => notifyListeners());
  }

  startCompetition() async {
    if (learnAgain) {
      navigateTo(CompetitionCountDownScreen(
          competition: this.competition, learnAgain: true));
      return;
    }

    if (isStartAvailable) {
      showErrorDialog(
        title: "نهاية المسابقة",
        desc: "لقد انتهت فترة المسابقة، في انتظار المسابقات القادمة.",
      );
      return;
    }

    // Check if password exists and is correct.
    if (!(await competitionPasswordValid())) return;

    if (competition.competitionType == CompetitionType.individual) {
      _participateIndividual();
    } else if (competition.competitionType == CompetitionType.teams) {
      _showUserTeams();
    }
  }

  Future _participateIndividual() async {
    // First participate if he/she not participated before.
    if (!this.appUser!.participatedCompetitions.contains(competition.id))
      await participateIndividualCompetition(
        askPassword: false,
        showResultDialog: false,
      );

    // Second check if he is already finished it
    bool? isFinishedCompetition = await CompetitionManagement.instance
        .checkWhetherParticipantIndividualFinished(
            this.appUser!, this.competition);

    if (isFinishedCompetition != null && isFinishedCompetition) {
      showErrorDialog(
        title: "لقد انهيت المسابقة",
        desc: "لقد انهيت المسابقة بنجاح، يرجى الانتظار اعلان النتيجة.",
      );
      return;
    }

    navigateTo(CompetitionCountDownScreen(competition: this.competition));
  }

  void _showUserTeams() {
    // Ask user which team will be participate.
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "اختيار الفريق",
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppStyles.PRIMARY_COLOR,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 22.0,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  "يرجى اختيار الفريق الخاص بك لكي تستطيع المشاركة في المسابقة",
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 12.0),
                StreamBuilder<QuerySnapshot>(
                  stream: TeamsManagement.instance.getMyTeams(appUser!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: EmptyListLoader());
                    } else {
                      if (snapshot.data!.docs.isEmpty)
                        return Center(
                            child: EmptyListText(text: "لا توجد فرق خاصة بك"));
                      else {
                        return ListView.separated(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) =>
                                SizedBox(height: scaleHeight(12.0)),
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, index) {
                              AppTeam team = AppTeam.fromDocument(
                                  snapshot.data!.docs[index]);
                              return InkWell(
                                onTap: () => _participateTeam(team),
                                child: TeamVerticalTile(
                                  team: team,
                                  fromStartCompetition: true,
                                ),
                              );
                            });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _participateTeam(AppTeam team) async {
    // Check if the user is NOT the leader
    if (team.leaderID != appUser!.id) {
      showErrorDialog(
        title: "لا يمكن الاشتراك",
        desc:
            "ليس مسموح لك بالاشتراك في المسابقة لانك لست قائد الفريق، يمكن لقائد الفريق وحده الاشتراك.",
      );
      return;
    }

    // Check if the team members count
    if (team.membersIDs.length != competition.competitionTeamCount) {
      showErrorDialog(
        title: "لا يمكن الاشتراك",
        desc:
            "ليس مسموح لك بالاشتراك بهذا الفريق لانه لا يناسب عدد اعضاء الفريق الذي محدد في المسابقة.",
      );
      return;
    }

    // Check the rules before going on
    for (final memberMap in team.membersProfiles.values) {
      // Check if one of members doesn't has equivalent points.
      if (memberMap["points"] < competition.participationPoints) {
        showErrorDialog(
          title: "لا يمكن الاشتراك",
          desc:
              "العضو (${memberMap["fullName"]}) لا يمتلك عدد نقاط كافي للاشتراك في المسابقة.",
        );
        return;
      }

      AppUser memberUser = AppUser.fromJson(memberMap, null, null);
      if (!competition.isUserAcceptToEnter(memberUser,
          checkUserWithinTeam: true)) {
        showErrorDialog(
          title: "لا يمكن الاشتراك",
          desc:
              "العضو (${memberMap["fullName"]}) ليس مسموح له بالاشتراك لان حسابه لا ينطبق عليه شروط المسابقة .",
        );
        return;
      }
      if (competition.isUserMustFollow(memberUser)) {
        showErrorDialog(
            title: "لا يمكن الاشتراك",
            desc:
                "العضو (${memberMap["fullName"]}) ليس مسموح له بالاشتراك، يجب عليه متابعة صانع المسابقة اولا (${competition.creatorFullName}).");
        return;
      }
    }

    // Second check if he is already finished it
    bool? isFinishedCompetition = await CompetitionManagement.instance
        .checkWhetherParticipantTeamFinished(team, this.competition);

    // Check if the team members are not participated before in this competition
    if (await CompetitionManagement.instance
            .checkWhetherAnyTeamMemberParticipatedBefore(team, competition) &&
        (isFinishedCompetition == null || isFinishedCompetition == false)) {
      showErrorDialog(
        title: "لا يمكن الاشتراك",
        desc:
            "ليس مسموح لك بالاشتراك بهذا الفريق لان احد اعضاء الفريق اشترك في هذه المسابقة من قبل مع فريق اخر.",
      );
      return;
    }

    // First participate if he/she not participated before.
    if (!this.appUser!.participatedCompetitions.contains(competition.id))
      await participateTeamCompetition(
        team,
        askPassword: false,
        showResultDialog: false,
      );

    if (isFinishedCompetition != null && isFinishedCompetition) {
      showErrorDialog(
        title: "لقد انهيت المسابقة",
        desc: "لقد انهيت المسابقة بنجاح، يرجى الانتظار اعلان النتيجة.",
      );
      return;
    }

    navigateTo(CompetitionCountDownScreen(
      competition: this.competition,
      team: team,
    ));
  }

  String get competitionQuestionsCount {
    int counts = this.competition.questions.length;

    if (counts == 1) return "سؤال";
    if (counts == 2) return "سؤالين";
    if (counts > 10)
      return "$counts سؤال";
    else
      return "$counts اسئلة";
  }

  String get competitionTime {
    int? seconds = 0;
    if (this.competition.durationPerCompetition!) {
      seconds = this.competition.durationCompetitionSeconds;
    } else {
      seconds = this
          .competition
          .questions
          .map((e) => e.durationSeconds)
          .reduce((value, element) => value = value! + element!);
    }

    if (seconds! >= 120) {
      int minutes = (seconds / 60).round();

      if (minutes <= 10)
        return "$minutes دقائق";
      else
        return "$minutes دقيقة";
    } else {
      if (seconds <= 10)
        return "$seconds ثواني";
      else
        return "$seconds ثانية";
    }
  }

  participateIndividualCompetition(
      {askPassword = true, showResultDialog = true}) async {
    if (this.appUser!.points! < this.competition.participationPoints!) {
      showErrorDialog(
        title: "نقاطك قليلة",
        desc: "ليس لديك نقاط كافية للاشترك في هذه المسابقة.",
      );
      return;
    }

    if (askPassword) if (!(await competitionPasswordValid())) return;

    showLoadingDialog();

    bool successful = await CompetitionManagement.instance
        .participateIndividualCompetition(this.appUser!, this.competition);

    Navigator.pop(Get.context!);

    if (successful && showResultDialog) {
      showSuccessDialog(
        title: "تم الاشتراك",
        desc:
            "تم اشتراكك بنجاح في مسابقة ${this.competition.name}، سوف يتم ارسال اشعار لك عند بداية المسابقة.",
      );
    } else if (showResultDialog) {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "لقد حدث خطأ ما في الاشتراك، يرجى اعادة المحاولة مرة اخرى.",
      );
    }

    notifyListeners();
  }

  unParticipateCompetition() async {
    showLoadingDialog();

    bool successful = await CompetitionManagement.instance
        .unParticipateCompetition(this.appUser!, this.competition);

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم إلغاء الاشتراك",
        desc: "تم إلغاء اشتراكك بنجاح في مسابقة ${this.competition.name}.",
      );
    } else {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "لقد حدث خطأ ما في الاشتراك، يرجى اعادة المحاولة مرة اخرى.",
      );
    }

    notifyListeners();
  }

  participateTeamCompetition(AppTeam team,
      {askPassword = true, showResultDialog = true}) async {
    if (askPassword) if (!(await competitionPasswordValid())) return;

    showLoadingDialog();

    bool successful = await CompetitionManagement.instance
        .participateTeamCompetition(team, this.competition);

    Navigator.pop(Get.context!);

    if (successful && showResultDialog) {
      showSuccessDialog(
        title: "تم الاشتراك",
        desc:
            "تم اشتراكك بنجاح في مسابقة ${this.competition.name}، سوف يتم ارسال اشعار لك عند بداية المسابقة.",
      );
    } else if (showResultDialog) {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "لقد حدث خطأ ما في الاشتراك، يرجى اعادة المحاولة مرة اخرى.",
      );
    }

    notifyListeners();
  }

  Future<bool> competitionPasswordValid() async {
    if (this.competition.closed! &&
        !this.appUser!.participatedCompetitions.contains(this.competition.id)) {
      String? password = await prompt(
        Get.context!,
        title: Text("ادخل كلمة السر"),
        initialValue: '',
        textOK: Text("موافق"),
        textCancel: Text("إلغاء"),
        hintText: "اكتب كلمة السر",
        autoFocus: true,
      );

      if (password == null || password != this.competition.closedPassword) {
        showErrorDialog(
          title: "كلمة السر خاطئة",
          desc: "لقد ادخلت كلمة سر خاطئة، يرجى التأكد منها مجدداً.",
        );
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  competitionDetails() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "تفاصيل المسابقة",
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppStyles.PRIMARY_COLOR,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 22.0,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  "اسم المسابقة",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  "${competition.name}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "اسم منشئ المسابقة",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  "${competition.creatorFullName}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "وصف المسابقة",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  "${competition.description}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "القراءات",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  (competition.reads!.isEmpty)
                      ? "لم يحدد"
                      : competition.reads!
                          .map((e) => BibleUtil.readFromKey(e))
                          .join("، "),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "عدد الاسئلة",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  "${this.competitionQuestionsCount}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "مدة المسابقة",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  "${this.competitionTime}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "مستوى المسابقة",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  "${competition.competitionLevel!.translate()}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "قيمة الاشتراك",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  "${competition.participationPoints} نقطة/نقاط",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "جائزة المسابقة",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    AutoSizeText(
                      "${competition.participationPoints! * competition.participantsCount!}",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppStyles.TEXT_SECONDARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: scaleWidth(8.0)),
                    AutoSizeText(
                      "لـ${competition.competitionWinner!.translate()}",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppStyles.TEXT_SECONDARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "ميعاد بداية المسابقة",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  "${_getDateTime(competition.timeStart!.toDate())}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "ميعاد نهاية المسابقة",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  "${_getDateTime(competition.timeEnd!.toDate())}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                AutoSizeText(
                  "مغلقة بكلمة مرور",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: 4.0),
                AutoSizeText(
                  competition.closed! ? "نعم" : "لا",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
              ],
            ),
          ),
        );
      },
    );
  }

  shareCompetition() {
    String text = "مسابقة جديدة: ";
    text += "${competition.name}";
    text += "\n";
    text += "رابط المسابقة: ";
    text += "${competition.url}";
    text += "\n";
    text += "كود المسابقة: ";
    text += "${competition.competitionCode}";
    text += "\n";
    if (competition.closed!) {
      text += "كلمة المرور: ";
      text += "برجاء قم بالتواصل مع منشئ المسابقة للحصول على كلمة المرور.";
      text += "\n";
    }
    if (competition.reads!.isNotEmpty) {
      text += "القراءات: ";
      text +=
          "${competition.reads!.map((e) => BibleUtil.readFromKey(e)).join("، ")}";
      text += "\n";
    } else {
      text += "القراءات: ";
      text += "عام";
      text += "\n";
    }
    text += "بداية المسابقة: ";
    text += "${_getDateTime(competition.timeStart!.toDate())}";
    text += "\n";
    text += "نهاية المسابقة: ";
    text += "${_getDateTime(competition.timeEnd!.toDate())}";
    text += "\n";

    text += "\n";
    text += "تحمس معنا واشترك الآن ❤";

    Share.share(text, subject: 'مسابقة جديدة!');
  }

  String _getDateTime(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd - hh:mm a');
    return timeFormatter.format(date);
  }

  bool get isStartAvailable =>
      this.competition.timeEnd!.toDate().isBefore(RealTime.instance.now!);

  @override
  void dispose() {
    super.dispose();
    _competitionStream!.cancel();
    countDownTimerController.dispose();
  }
}
