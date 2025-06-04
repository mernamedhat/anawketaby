import 'package:anawketaby/models/topic.dart';
import 'package:anawketaby/ui/screens/admin_screens/groups_screens/admin_groups_screen.dart';
import 'package:anawketaby/ui/screens/admin_screens/my_creation_competitions_screens/admin_my_creation_competitions_screen.dart';
import 'package:anawketaby/ui/screens/admin_screens/my_creation_topics_screens/admin_my_creation_topics_screen.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/admin_new_competition_screen.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_topic_screens/admin_new_topic_screen.dart';
import 'package:anawketaby/ui/screens/admin_screens/requests_screens/admin_requests_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:flutter/material.dart';

class AdminMainScreenProvider extends ChangeNotifier {
  createNewCompetition() {
    navigateTo(AdminNewCompetitionScreen());
  }

  myCreationCompetitions() {
    navigateTo(AdminMyCreationCompetitionsScreen());
  }

  createNewTopic() async {
    navigateTo(AdminNewTopicScreen(topic: Topic()));
  }

  myCreationTopics() async {
    navigateTo(AdminMyCreationTopicsScreen());
  }

  goToRequests() async {
    navigateTo(AdminRequestsScreen());
  }

  goToGroups() async {
    navigateTo(AdminGroupsScreen());
  }
}
