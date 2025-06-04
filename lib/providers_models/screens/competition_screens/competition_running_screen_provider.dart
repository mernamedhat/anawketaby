import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_settings.dart';
import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_participant.dart';
import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_questions_summary_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';

class CompetitionRunningScreenProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final AppTeam? team;
  final AppSettings appSettings =
      Provider.of<SettingsProvider>(Get.context!, listen: false).appSettings;
  final Competition competition;
  final int? questionIndex;
  final bool learnAgain;
  final DateTime? _learnAgainTimeStarted = RealTime.instance.now;

  CompetitionParticipant? participant;

  int? _questionNo;
  CompetitionQuestion? _currentQuestion;

  final AudioPlayer player =
      Provider.of<SettingsProvider>(Get.context!, listen: false).player;

  final CountdownController countdownController =
      CountdownController(autoStart: true);

  int remainingSeconds = 0;

  CompetitionRunningScreenProvider(
      this.competition, this.team, this.questionIndex, this.learnAgain) {
    if (this.learnAgain) {
      if (this.questionIndex == null) {
        _questionNo = 1;
        _currentQuestion = this.competition.questions.first;
      } else {
        _questionNo = this.questionIndex! + 1;
        _currentQuestion = this.competition.questions[this.questionIndex!];
      }
      notifyListeners();
      return;
    }

    CompetitionManagement.instance
        .startedParticipantCompetition(this.competition,
            appUser: (team == null) ? this.appUser! : null, team: team)
        .then((values) {
      bool isStartedBefore = values[0];
      this.participant = values[1];

      // Check if competition duration time has passed the current time
      // after the timeStarted of participant.
      if (this.competition.durationPerCompetition!) {
        DateTime lastSecondAvailable = this
            .participant!
            .timeStarted!
            .toDate()
            .add(Duration(
                seconds: this.competition.durationCompetitionSeconds!));
        if (RealTime.instance.now!.isAfter(lastSecondAvailable)) {
          showErrorDialog(
            title: "تجاوزت الوقت المسموح",
            desc:
                "لقد تجاوزت الوقت المسموح لانهاء المسابقة، انتظر اعلان النتيجة بعد قليل.",
            onDismissCallback: (type) => Navigator.pop(Get.context!),
          );
          return;
        }
      }

      if (competition.shuffleQuestions != null &&
          competition.shuffleQuestions == true) {
        final Map<int, CompetitionQuestion> mappings = {
          for (int i = 0; i < participant!.questionsOrder!.length; i++)
            participant!.questionsOrder![i]: competition.questions[i]
        };

        participant!.questionsOrder!.sort();

        competition.questions = [
          for (int number in participant!.questionsOrder!) mappings[number]!
        ];

        _questionNo = 1;
        _currentQuestion = this.competition.questions.first;
      }

      // Load stored answers.
      if (isStartedBefore) {
        List answers = participant!.answers!;
        for (Map answer in answers) {
          int? answerOrderNo = int.tryParse(answer.keys.first);
          CompetitionQuestion question = this
              .competition
              .questions
              .firstWhere((e) => e.orderNo == answerOrderNo);
          question.userAnswer = answer[answer.keys.first]["answer"];
        }

        // Set question to first non answered yet.
        var lastNonAnsweredQuestion = answers.firstWhere(
            (e) => e[e.keys.first]["answer"].isEmpty,
            orElse: () => null);
        if (lastNonAnsweredQuestion != null) {
          _questionNo = answers.indexOf(lastNonAnsweredQuestion) + 1;
          _currentQuestion = this.competition.questions[_questionNo! - 1];
        } else if (this.competition.canBack!) {
          goSummary();
        }
      }
      notifyListeners();
    });

    if (this.questionIndex == null) {
      _questionNo = 1;
      _currentQuestion = this.competition.questions.first;
    } else {
      _questionNo = this.questionIndex! + 1;
      _currentQuestion = this.competition.questions[this.questionIndex!];
    }
  }

  int get competitionRemainingTime => (!this.learnAgain)
      ? this
          .participant!
          .timeStarted!
          .toDate()
          .add(Duration(seconds: this.competition.durationCompetitionSeconds!))
          .difference(RealTime.instance.now!)
          .inSeconds
      : _learnAgainTimeStarted!
          .add(Duration(seconds: this.competition.durationCompetitionSeconds!))
          .difference(RealTime.instance.now!)
          .inSeconds;

  String getTimeString(int seconds) {
    if (seconds > 60) {
      int min = (seconds / 60).floor();
      int secondsInMin = seconds - (min * 60);
      return "$min:$secondsInMin";
    } else {
      _playSound(seconds <= 10);
      return "$seconds";
    }
  }

  void _playSound(double) async {
    if (appSettings.isCompetitionTimerSoundEnabled) {
      await player.setAsset("assets/sounds/clock_tick.wav");
      player.play();
      if (double)
        await Future.delayed(Duration(milliseconds: 500), () async {
          await player.setAsset("assets/sounds/clock_tick.wav");
          await player.play();
        });
    }
  }

  nextQuestion() async {
    Provider.of<SettingsProvider>(Get.context!, listen: false).playClickSound();
    if (!this.competition.durationPerCompetition!) {
      this.competition.questions[_questionNo! - 1].userAnswerRemainingSeconds =
          this.remainingSeconds;
    }

    if (this.competition.questions.length > _questionNo!) {
      // Update participant answer.
      if (!learnAgain)
        CompetitionManagement.instance.updateParticipantAnswers(
            this.competition,
            appUser: (team == null) ? this.appUser! : null,
            team: team);

      if (_questionNo != null) {
        _questionNo = _questionNo! + 1;
      }

      _currentQuestion = this.competition.questions[_questionNo! - 1];
      notifyListeners();
      if (!this.competition.durationPerCompetition!)
        Future.delayed(Duration(milliseconds: 50), () {
          countdownController.restart();
        });
    } else {
      if (this.competition.canBack!) {
        // Update participant answer.
        if (!learnAgain)
          CompetitionManagement.instance.updateParticipantAnswers(
              this.competition,
              appUser: (team == null) ? this.appUser! : null,
              team: team);

        this.competition.landSummary = true;
        _questionNo = await navigateTo(CompetitionQuestionsSummaryScreen(
            competition: competition, team: this.team, learnAgain: learnAgain));
        if (_questionNo != null) {
          _currentQuestion = this.competition.questions[_questionNo! - 1];
          notifyListeners();
        }
      } else {
        showLoadingDialog();

        // Finished participant competition.
        if (!learnAgain)
          await CompetitionManagement.instance.finishedParticipantCompetition(
              this.competition,
              appUser: (team == null) ? this.appUser! : null,
              team: team);

        Navigator.pop(Get.context!);
        countdownController.pause();
        showCompetitionDoneDialog(learnAgain);
      }
    }
  }

  backQuestion() {
    Provider.of<SettingsProvider>(Get.context!, listen: false).playClickSound();
    if (_questionNo! > 1) {
      if (_questionNo != null) {
        _questionNo = _questionNo! - 1;
      }
      _currentQuestion = this.competition.questions[_questionNo! - 1];
      notifyListeners();
    }
  }

  Future goSummary() async {
    _questionNo = await navigateTo(CompetitionQuestionsSummaryScreen(
        competition: competition, team: this.team, learnAgain: learnAgain));
    if (_questionNo != null) {
      _currentQuestion = this.competition.questions[_questionNo! - 1];
      notifyListeners();
    }
  }

  CompetitionQuestion? get currentQuestion => _currentQuestion;

  get questionNo => _questionNo;

  onTimerFinished() async {
    if (this.competition.durationPerCompetition!) {
      showLoadingDialog();

      // Finished participant competition.
      if (!learnAgain)
        await CompetitionManagement.instance.finishedParticipantCompetition(
            this.competition,
            appUser: (team == null) ? this.appUser! : null,
            team: team);

      Navigator.pop(Get.context!);
      countdownController.pause();
      showCompetitionDoneDialog(learnAgain);

      if (!learnAgain)
        showInfoDialog(
          title: "انتهى الوقت",
          desc:
              "تم انتهاء الوقت وتم تسجيل جميع الاجابات، سوف يتم اعلامك بالنتيجة فور ظهورها.",
        );
    } else {
      nextQuestion();
    }
  }
}
