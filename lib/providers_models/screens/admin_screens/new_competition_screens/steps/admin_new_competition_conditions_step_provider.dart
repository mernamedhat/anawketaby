import 'package:anawketaby/enums/church.dart';
import 'package:anawketaby/enums/church_role.dart';
import 'package:anawketaby/enums/gender.dart';
import 'package:anawketaby/managements/topics_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/topic.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/widgets/choices_buttons_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AdminNewCompetitionConditionsStepProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final Competition competition;

  final ChoicesButtonsController churchesChoicesButtonsController =
      ChoicesButtonsController([]);

  final ChoicesButtonsController churchRolesChoicesButtonsController =
      ChoicesButtonsController([]);

  List<Topic>? _loadedTopics;

  AdminNewCompetitionConditionsStepProvider(this.competition) {
    if (competition.id != null) {
      if (competition.competitionConditions?.competitionsIDs != null) {
        _loadTopics();
      }
    }
    if (competition.competitionConditions?.churches != null) {
      churchesChoicesButtonsController.value =
          competition.competitionConditions?.churches ?? [];
    }
    if (competition.competitionConditions?.churchRoles != null) {
      churchRolesChoicesButtonsController.value =
          competition.competitionConditions?.churchRoles ?? [];
    }
  }

  List<Topic>? get loadedTopics => _loadedTopics;

  Future _loadTopics() async {
    if (_loadedTopics != null) {
      return;
    }

    QuerySnapshot snapshot =
        await TopicsManagement.instance.getMyCreationTopics(appUser!).first;

    _loadedTopics = [];
    for (final topicDoc in snapshot.docs) {
      _loadedTopics?.add(Topic.fromDocument(topicDoc));
    }
    notifyListeners();
  }

  void addGenderCondition() {
    this.competition.competitionConditions?.gender = Gender.male;
    notifyListeners();
  }

  void changeGender(Gender gender) {
    this.competition.competitionConditions?.gender = gender;
    notifyListeners();
  }

  void deleteGender() {
    this.competition.competitionConditions?.gender = null;
    notifyListeners();
  }

  void addChurchCondition() {
    this.competition.competitionConditions?.churches = [];
    notifyListeners();
  }

  onChurchesChoiceChanged() {
    this.competition.competitionConditions?.churches =
        List<Church>.from(churchesChoicesButtonsController.value);
    notifyListeners();
  }

  void deleteChurch() {
    churchesChoicesButtonsController.value = [];
    this.competition.competitionConditions?.churches = null;
    notifyListeners();
  }

  void addChurchRoleCondition() {
    this.competition.competitionConditions?.churchRoles = [];
    notifyListeners();
  }

  onChurchRolesChoiceChanged() {
    this.competition.competitionConditions?.churchRoles =
        List<ChurchRole>.from(churchRolesChoicesButtonsController.value);
    notifyListeners();
  }

  void deleteChurchRole() {
    churchRolesChoicesButtonsController.value = [];
    this.competition.competitionConditions?.churchRoles = null;
    notifyListeners();
  }

  void addAgeCondition() {
    this.competition.competitionConditions?.ageFrom =
        Timestamp.fromDate(DateTime(DateTime.now().year - 5));
    this.competition.competitionConditions?.ageTo =
        Timestamp.fromDate(DateTime(DateTime.now().year - 80));
    notifyListeners();
  }

  void changeAgeFrom(int age) {
    this.competition.competitionConditions?.ageFrom =
        Timestamp.fromDate(DateTime(DateTime.now().year - age + 1));
    notifyListeners();
  }

  void changeAgeTo(int age) {
    this.competition.competitionConditions?.ageTo =
        Timestamp.fromDate(DateTime(DateTime.now().year - age));
    notifyListeners();
  }

  void deleteAge() {
    this.competition.competitionConditions?.ageFrom = null;
    this.competition.competitionConditions?.ageTo = null;
    notifyListeners();
  }

  void addCompetitionsIDsCondition() async {
    if (loadedTopics != null) {
      this.competition.competitionConditions?.competitionsIDs =
          _loadedTopics?.first.competitionsIDs;
      notifyListeners();
    } else {
      this.competition.competitionConditions?.competitionsIDs = [];
      notifyListeners();
      await _loadTopics();
      this.competition.competitionConditions?.competitionsIDs =
          _loadedTopics?.first.competitionsIDs;
      notifyListeners();
    }
  }

  void changeCompetitionsIDs(Topic topic) {
    this.competition.competitionConditions?.competitionsIDs =
        topic.competitionsIDs;
    notifyListeners();
  }

  void deleteCompetitionsIDs() {
    this.competition.competitionConditions?.competitionsIDs = null;
    notifyListeners();
  }

  void addFollowersOnlyCondition() {
    this.competition.competitionConditions?.followersOnly = true;
    notifyListeners();
  }

  void deleteFollowersOnly() {
    this.competition.competitionConditions?.followersOnly = false;
    notifyListeners();
  }
}
