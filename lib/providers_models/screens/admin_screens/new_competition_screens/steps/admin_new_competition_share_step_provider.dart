// import 'dart:async';
//
// import 'package:anawketaby/managements/competitions_management.dart';
// import 'package:anawketaby/models/app_user.dart';
// import 'package:anawketaby/models/competition.dart';
// import 'package:anawketaby/providers_models/main/user_provider.dart';
// import 'package:anawketaby/utils/bible_util.dart';
// import 'package:anawketaby/utils/navigation.dart';
// import 'package:anawketaby/utils/real_time.dart';
// import 'package:clipboard/clipboard.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
//
// class AdminNewCompetitionShareStepProvider extends ChangeNotifier {
//   final AppUser? appUser =
//       Provider.of<UserProvider>(Get.context!, listen: false).appUser;
//   Competition competition;
//
//   bool? _isPublishBeforeStartTime = false;
//   bool? _isTestYourself = false;
//
//   var _publishDate = DateTime.now();
//   var _publishTimeOfDay = TimeOfDay.now();
//
//   var _calculateDate = DateTime.now();
//
//   final TextEditingController publishDateTimeController =
//       TextEditingController();
//   final TextEditingController calculateDateTimeController =
//       TextEditingController();
//
//   late StreamSubscription _competitionStream;
//
//   AdminNewCompetitionShareStepProvider(this.competition) {
//     _isPublishBeforeStartTime =
//         this.competition.isPublishBeforeStartTime ?? false;
//     _isTestYourself = this.competition.isTestYourself ?? false;
//     publishDateTimeController.text = _getDateTime(_publishDate);
//     calculateDateTimeController.text = _getDateTime(_calculateDate);
// print(this.competition.id.toString()+"ffff");
//     _competitionStream = CompetitionManagement.instance
//         .getCompetitionStream(this.competition.id)
//         .listen((event) {
//       this.competition = Competition.fromJson(event.data());
//       _calculateDate = this.competition.timeCalculateResults!.toDate();
//       calculateDateTimeController.text = _getDateTime(_calculateDate);
//       notifyListeners();
//     });
//   }
//
//   get isNewCompetition => this.competition.timeLastEdit == null;
//
//   bool get isCompetitionCreator =>
//       this.competition.creatorID == this.appUser!.firebaseUser!.uid;
//
//   copy(String text) async {
//     await FlutterClipboard.copy(text);
//     showSuccessfulSnackBar(title: "تم النسخ", message: "تم النسخ النص بنجاح");
//   }
//
//   shareCompetition() async {
//     String text = "مسابقة جديدة: ";
//     text += "${competition.name}";
//     text += "\n";
//     text += "رابط المسابقة: ";
//     text += "${competition.url}";
//     text += "\n";
//     text += "كود المسابقة: ";
//     text += "${competition.competitionCode}";
//     text += "\n";
//     if (competition.closed!) {
//       text += "كلمة المرور: ";
//       text += "${competition.closedPassword}";
//       text += "\n";
//     }
//     if (competition.reads!.isNotEmpty) {
//       text += "القراءات: ";
//       text +=
//           "${competition.reads!.map((e) => BibleUtil.readFromKey(e)).join("، ")}";
//       text += "\n";
//     } else {
//       text += "القراءات: ";
//       text += "عام";
//       text += "\n";
//     }
//     text += "بداية المسابقة: ";
//     text += "${_getDateTime(competition.timeStart!.toDate())}";
//     text += "\n";
//     text += "نهاية المسابقة: ";
//     text += "${_getDateTime(competition.timeEnd!.toDate())}";
//     text += "\n";
//
//     text += "\n";
//     text += "تحمس معنا واشترك الآن ❤";
//
//     Share.share(text, subject: 'مسابقة جديدة!');
//   }
//
//   Future showPublishDateTimePicker() async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: Get.context!,
//       initialDate: _publishDate,
//       firstDate: RealTime.instance.now!,
//       lastDate: DateTime(2030),
//     );
//
//     if (pickedDate == null) return;
//
//     final TimeOfDay? timeOfDay = await showTimePicker(
//       context: Get.context!,
//       initialTime: _publishTimeOfDay,
//     );
//
//     if (timeOfDay == null) return;
//
//     _publishDate = DateTime(
//       pickedDate.year,
//       pickedDate.month,
//       pickedDate.day,
//       timeOfDay.hour,
//       timeOfDay.minute,
//     );
//     _publishTimeOfDay = timeOfDay;
//
//     publishDateTimeController.text = _getDateTime(_publishDate);
//     this.competition.timePublished = Timestamp.fromDate(_publishDate);
//
//     if (this.competition.timeStart!.toDate().isBefore(_publishDate)) {
//       showErrorSnackBar(
//           title: "خانات خاطئة",
//           message:
//               "من فضلك حدد ميعاد نشر المسابقة قبل دقيقة على الاقل من بداية المسابقة.");
//
//       _publishDate =
//           this.competition.timeStart!.toDate().add(Duration(minutes: -1));
//       publishDateTimeController.text = _getDateTime(_publishDate);
//       this.competition.timePublished = Timestamp.fromDate(_publishDate);
//     }
//
//     CompetitionManagement.instance
//         .editCompetition(this.competition, this.appUser, shareOnly: true);
//
//     notifyListeners();
//   }
//
//   String _getDateTime(DateTime date) {
//     Intl.defaultLocale = Get.locale!.languageCode;
//     var timeFormatter = DateFormat('yyyy/MM/dd - hh:mm a');
//     return timeFormatter.format(date);
//   }
//
//   bool? get isPublishBeforeStartTime => _isPublishBeforeStartTime;
//
//   set isPublishBeforeStartTime(bool? value) {
//     _isPublishBeforeStartTime = value;
//     this.competition.isPublishBeforeStartTime = _isPublishBeforeStartTime;
//     _publishDate =
//         this.competition.timeStart!.toDate().add(Duration(minutes: -1));
//     this.competition.timePublished = Timestamp.fromDate(_publishDate);
//     publishDateTimeController.text = _getDateTime(_publishDate);
//     CompetitionManagement.instance
//         .editCompetition(this.competition, this.appUser, shareOnly: true);
//     notifyListeners();
//   }
//
//   bool? get isTestYourself => _isTestYourself;
//
//   set isTestYourself(bool? value) {
//     _isTestYourself = value;
//     this.competition.isTestYourself = _isTestYourself;
//     CompetitionManagement.instance
//         .editCompetition(this.competition, this.appUser, shareOnly: true);
//     notifyListeners();
//   }
//
//   Future showCalculateDateTimePicker() async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: Get.context!,
//       initialDate: this.competition.timeCalculateResults!.toDate(),
//       firstDate: this.competition.timeCalculateResults!.toDate(),
//       lastDate: DateTime(2030),
//     );
//
//     if (pickedDate == null) return;
//
//     final TimeOfDay? timeOfDay = await showTimePicker(
//       context: Get.context!,
//       initialTime: TimeOfDay.fromDateTime(
//           this.competition.timeCalculateResults!.toDate()),
//     );
//
//     if (timeOfDay == null) return;
//
//     _calculateDate = DateTime(
//       pickedDate.year,
//       pickedDate.month,
//       pickedDate.day,
//       timeOfDay.hour,
//       timeOfDay.minute,
//     );
//
//     if (_calculateDate.isBefore(this.competition.timeEnd!.toDate().add(Duration(
//         seconds: this.competition.durationCompetitionSeconds! + 120)))) {
//       showErrorSnackBar(
//         title: "خانات خاطئة",
//         message:
//             "من فضلك حدد ميعاد حساب نتيجة المسابقة بعد دقيقيتين على الاقل من نهاية المسابقة والوقت الإجمالي للمسابقة.",
//       );
//       return;
//     }
//
//     calculateDateTimeController.text = _getDateTime(_calculateDate);
//     this.competition.timeCalculateResults = Timestamp.fromDate(_calculateDate);
//
//     await CompetitionManagement.instance
//         .editCompetition(this.competition, this.appUser, shareOnly: true);
//
//     notifyListeners();
//   }
//
//   bool get isEditAvailable =>
//       this.competition.timeStart!.toDate().isAfter(RealTime.instance.now!);
//
//   @override
//   void dispose() {
//     super.dispose();
//     _competitionStream.cancel();
//   }
// }
import 'dart:async';

import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/utils/bible_util.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class AdminNewCompetitionShareStepProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  Competition competition;
  bool _isCompetitionCodeLoading = false;
  String? _errorMessage;

  bool? _isPublishBeforeStartTime = false;
  bool? _isTestYourself = false;

  var _publishDate = DateTime.now();
  var _publishTimeOfDay = TimeOfDay.now();

  var _calculateDate = DateTime.now();

  final TextEditingController publishDateTimeController =
  TextEditingController();
  final TextEditingController calculateDateTimeController =
  TextEditingController();

  late StreamSubscription _competitionStream;

  AdminNewCompetitionShareStepProvider(this.competition) {
    _isPublishBeforeStartTime =
        this.competition.isPublishBeforeStartTime ?? false;
    _isTestYourself = this.competition.isTestYourself ?? false;
    publishDateTimeController.text = _getDateTime(_publishDate);
    calculateDateTimeController.text = _getDateTime(_calculateDate);
    print(this.competition.id.toString() + "ffff");
    _initializeCompetition();
  }

  Future<void> _initializeCompetition() async {
    // Check if competitionCode or url is null (unlikely now due to createCompetition changes)
    if ((competition.competitionCode == null || competition.url == null) &&
        competition.id != null) {
      try {
        _isCompetitionCodeLoading = true;
        notifyListeners();
        Competition? updatedCompetition =
        await CompetitionManagement.instance.getCompetition(competition.id!);
        if (updatedCompetition != null) {
          competition = updatedCompetition;
        } else {
          _errorMessage = "فشل في جلب بيانات المسابقة.";
        }
      } catch (e) {
        _errorMessage = "حدث خطأ أثناء جلب البيانات: $e";
      } finally {
        _isCompetitionCodeLoading = false;
        notifyListeners();
      }
    }

    // Set up stream for subsequent updates
    _competitionStream = CompetitionManagement.instance
        .getCompetitionStream(this.competition.id)
        .listen((event) {
      if (event.exists && event.data() != null) {
        // this.competition = Competition.fromJson(event.data());
         this.competition = Competition.fromJson(event.data() as Map<String, dynamic>);
         if (this.competition.timeCalculateResults != null) {
           _calculateDate = this.competition.timeCalculateResults!.toDate();
         } else {

           _calculateDate = DateTime.now();
         }
        calculateDateTimeController.text = _getDateTime(_calculateDate);
        notifyListeners();
      } else {
        _errorMessage = "بيانات المسابقة غير متاحة.";
        notifyListeners();
      }
    }, onError: (e) {
      _errorMessage = "حدث خطأ في تحديث البيانات: $e";
      notifyListeners();
    });
  }

  get isNewCompetition => this.competition.timeLastEdit == null;

  bool get isCompetitionCreator =>
      this.competition.creatorID == this.appUser!.firebaseUser!.uid;

  bool get isCompetitionCodeLoading => _isCompetitionCodeLoading;

  String? get errorMessage => _errorMessage;

  copy(String text) async {
    await FlutterClipboard.copy(text);
    showSuccessfulSnackBar(title: "تم النسخ", message: "تم النسخ النص بنجاح");
  }

  shareCompetition() async {
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
      text += "${competition.closedPassword}";
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

  Future showPublishDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: _publishDate,
      firstDate: RealTime.instance.now!,
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    final TimeOfDay? timeOfDay = await showTimePicker(
      context: Get.context!,
      initialTime: _publishTimeOfDay,
    );

    if (timeOfDay == null) return;

    _publishDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    _publishTimeOfDay = timeOfDay;

    publishDateTimeController.text = _getDateTime(_publishDate);
    this.competition.timePublished = Timestamp.fromDate(_publishDate);

    if (this.competition.timeStart!.toDate().isBefore(_publishDate)) {
      showErrorSnackBar(
          title: "خانات خاطئة",
          message:
          "من فضلك حدد ميعاد نشر المسابقة قبل دقيقة على الاقل من بداية المسابقة.");

      _publishDate =
          this.competition.timeStart!.toDate().add(Duration(minutes: -1));
      publishDateTimeController.text = _getDateTime(_publishDate);
      this.competition.timePublished = Timestamp.fromDate(_publishDate);
    }

    CompetitionManagement.instance
        .editCompetition(this.competition, this.appUser, shareOnly: true);

    notifyListeners();
  }

  String _getDateTime(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd - hh:mm a');
    return timeFormatter.format(date);
  }

  bool? get isPublishBeforeStartTime => _isPublishBeforeStartTime;

  set isPublishBeforeStartTime(bool? value) {
    _isPublishBeforeStartTime = value;
    this.competition.isPublishBeforeStartTime = _isPublishBeforeStartTime;
    _publishDate =
        this.competition.timeStart!.toDate().add(Duration(minutes: -1));
    this.competition.timePublished = Timestamp.fromDate(_publishDate);
    publishDateTimeController.text = _getDateTime(_publishDate);
    CompetitionManagement.instance
        .editCompetition(this.competition, this.appUser, shareOnly: true);
    notifyListeners();
  }

  bool? get isTestYourself => _isTestYourself;

  set isTestYourself(bool? value) {
    _isTestYourself = value;
    this.competition.isTestYourself = _isTestYourself;
    CompetitionManagement.instance
        .editCompetition(this.competition, this.appUser, shareOnly: true);
    notifyListeners();
  }

  Future showCalculateDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: this.competition.timeCalculateResults!.toDate(),
      firstDate: this.competition.timeCalculateResults!.toDate(),
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    final TimeOfDay? timeOfDay = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.fromDateTime(
          this.competition.timeCalculateResults!.toDate()),
    );

    if (timeOfDay == null) return;

    _calculateDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    if (_calculateDate.isBefore(this.competition.timeEnd!.toDate().add(Duration(
        seconds: this.competition.durationCompetitionSeconds! + 120)))) {
      showErrorSnackBar(
        title: "خانات خاطئة",
        message:
        "من فضلك حدد ميعاد حساب نتيجة المسابقة بعد دقيقيتين على الاقل من نهاية المسابقة والوقت الإجمالي للمسابقة.",
      );
      return;
    }

    calculateDateTimeController.text = _getDateTime(_calculateDate);
    this.competition.timeCalculateResults = Timestamp.fromDate(_calculateDate);

    await CompetitionManagement.instance
        .editCompetition(this.competition, this.appUser, shareOnly: true);

    notifyListeners();
  }

  bool get isEditAvailable =>
      this.competition.timeStart!.toDate().isAfter(RealTime.instance.now!);

  @override
  void dispose() {
    super.dispose();
    _competitionStream.cancel();
  }
}