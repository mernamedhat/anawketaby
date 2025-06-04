import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/widgets/choices_buttons_picker.dart';
import 'package:anawketaby/ui/widgets/number_counter_buttons.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';

class AdminNewCompetitionMoreDetailsStepProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final Competition competition;

  final TextEditingController closedPasswordController =
      TextEditingController();

  final NumberCounterController participationPoints =
      NumberCounterController(value: 3);

  final NumberCounterController teamCount = NumberCounterController(value: 3);

  final ChoicesButtonsController competitionTypeChoicesButtonsController =
      ChoicesButtonsController(null);
  final ChoicesButtonsController competitionLevelChoicesButtonsController =
      ChoicesButtonsController(null);
  final ChoicesButtonsController competitionWinnerChoicesButtonsController =
      ChoicesButtonsController(null);

  bool? _shuffleQuestions = false;
  bool? _remainingTimeConsider = true;
  bool? _closed = false;

  var _startDate;
  late var _startTimeOfDay;
  var _endDate;
  late var _endTimeOfDay;

  final TextEditingController startDateTimeController = TextEditingController();
  final TextEditingController endDateTimeController = TextEditingController();

  AdminNewCompetitionMoreDetailsStepProvider(this.competition) {
    // Set real date and time
    NTP.now().then((value) {
      _startDate = value.add(const Duration(minutes: 5));
      _startTimeOfDay = TimeOfDay.fromDateTime(value);
      _endDate = value.add(const Duration(minutes: 15));
      _endTimeOfDay = TimeOfDay.fromDateTime(value);

      participationPoints.value =
          this.competition.participationPoints ?? participationPoints.value;
      teamCount.value =
          this.competition.competitionTeamCount ?? teamCount.value;
      competitionTypeChoicesButtonsController.value =
          this.competition.competitionType;
      competitionLevelChoicesButtonsController.value =
          this.competition.competitionLevel;
      competitionWinnerChoicesButtonsController.value =
          this.competition.competitionWinner;
      _shuffleQuestions =
          this.competition.shuffleQuestions ?? _shuffleQuestions;
      _remainingTimeConsider =
          this.competition.remainingTimeConsider ?? _remainingTimeConsider;
      _closed = this.competition.closed ?? _closed;
      closedPasswordController.text = this.competition.closedPassword ?? "";
      _startDate = (this.competition.timeStart != null)
          ? this.competition.timeStart!.toDate()
          : _startDate;
      _startTimeOfDay = (this.competition.timeStart != null)
          ? TimeOfDay.fromDateTime(this.competition.timeStart!.toDate())
          : TimeOfDay.fromDateTime(_startDate);
      _endDate = (this.competition.timeEnd != null)
          ? this.competition.timeEnd!.toDate()
          : _endDate;
      _endTimeOfDay = (this.competition.timeEnd != null)
          ? TimeOfDay.fromDateTime(this.competition.timeEnd!.toDate())
          : TimeOfDay.fromDateTime(_endDate);
      startDateTimeController.text =
          (_startDate != null) ? _getDateTime(_startDate) : "";
      endDateTimeController.text =
          (_endDate != null) ? _getDateTime(_endDate) : "";

      notifyListeners();
    });
  }

  @override
  void notifyListeners() {
    _setFields();
    super.notifyListeners();
  }

  _setFields() {
    this.competition.participationPoints = participationPoints.value;
    this.competition.competitionTeamCount = teamCount.value;
    this.competition.competitionType =
        competitionTypeChoicesButtonsController.value;
    this.competition.competitionLevel =
        competitionLevelChoicesButtonsController.value;
    this.competition.competitionWinner =
        competitionWinnerChoicesButtonsController.value;
    this.competition.shuffleQuestions = shuffleQuestions;
    this.competition.remainingTimeConsider = remainingTimeConsider;
    this.competition.closed = closed;
    this.competition.closedPassword = closedPasswordController.text.trim();
    this.competition.timeStart = (_startDate != null)
        ? Timestamp.fromDate(DateTime(_startDate.year, _startDate.month,
            _startDate.day, _startTimeOfDay.hour, _startTimeOfDay.minute))
        : null;
    this.competition.timeEnd = (_endDate != null)
        ? Timestamp.fromDate(DateTime(_endDate.year, _endDate.month,
            _endDate.day, _endTimeOfDay.hour, _endTimeOfDay.minute))
        : null;
  }

  Future<void> pickFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
      type: FileType.image,
    );

    if (result != null) {
      this.competition.tempPickedImage = result.files.first;
      notifyListeners();
    }
  }

  Future showStartDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: _startDate,
      firstDate: RealTime.instance.now!,
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    final TimeOfDay? timeOfDay = await showTimePicker(
      context: Get.context!,
      initialTime: _startTimeOfDay,
    );

    if (timeOfDay == null) return;

    _startDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    _startTimeOfDay = timeOfDay;

    startDateTimeController.text = _getDateTime(_startDate);

    notifyListeners();
  }

  Future showEndDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    final TimeOfDay? timeOfDay = await showTimePicker(
      context: Get.context!,
      initialTime: _endTimeOfDay,
    );

    if (timeOfDay == null) return;

    _endDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    _endTimeOfDay = timeOfDay;

    endDateTimeController.text = _getDateTime(_endDate);

    notifyListeners();
  }

  String _getDateTime(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd - hh:mm a');
    return timeFormatter.format(date);
  }

  bool? get closed => _closed;

  set closed(bool? value) {
    _closed = value;
    notifyListeners();
  }

  bool? get shuffleQuestions => _shuffleQuestions;

  set shuffleQuestions(bool? value) {
    _shuffleQuestions = value;
    notifyListeners();
  }

  bool? get remainingTimeConsider => _remainingTimeConsider;

  set remainingTimeConsider(bool? value) {
    _remainingTimeConsider = value;
    notifyListeners();
  }

  textChanged(String value) {
    notifyListeners();
  }

  onNumberChanged() {
    notifyListeners();
  }

  onChoiceChanged() {
    notifyListeners();
  }
}
