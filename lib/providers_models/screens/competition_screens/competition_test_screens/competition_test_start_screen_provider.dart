import 'package:anawketaby/enums/competition_level.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_count_down_screen.dart';
import 'package:anawketaby/utils/bible_util.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CompetitionTestStartScreenProvider extends ChangeNotifier {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  Competition competition;

  CompetitionTestStartScreenProvider(this.competition);

  startCompetition() async {
    appUser = Provider.of<UserProvider>(Get.context!, listen: false).appUser;

    int? questionIndex;
    if (this.appUser!.participatedCompetitionsTest[this.competition.id!] !=
        null) {
      questionIndex =
          this.appUser!.participatedCompetitionsTest[this.competition.id!]
              ["questionsAnswered"];
    }

    this.competition.questions.forEach((e) => e.userAnswer = []);

    navigateTo(CompetitionCountDownScreen(
      competition: this.competition,
      isTestYourself: true,
      questionIndex: questionIndex,
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

  String get competitionReads {
    String reads = (competition.reads!.isEmpty)
        ? "لم يحدد"
        : competition.reads!.map((e) => BibleUtil.readFromKey(e)).join("، ");
    return "القراءات: " + reads;
  }

  String get competitionLevel {
    return "المستوى: " + "${competition.competitionLevel!.translate()}";
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
}
