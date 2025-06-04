/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

class FirestorePaths {
  static String configurationsDocument() => "appConfig/configurations";

  static String usersCollections() => "users";

  static String userDocument(String? id) => "users/$id";

  static String competitionsCollections() => "competitions";

  static String competitionsDocument(String? id) => "competitions/$id";

  static String competitionParticipantsIndividualsCollections(
          String? competitionID) =>
      "competitions/$competitionID/participants";

  static String competitionParticipantIndividualsDocument(
          String competitionID, String id) =>
      "competitions/$competitionID/participants/$id";

  static String competitionParticipantsTeamsCollections(
          String? competitionID) =>
      "competitions/$competitionID/teams";

  static String competitionParticipantTeamsDocument(
          String competitionID, String id) =>
      "competitions/$competitionID/teams/$id";

  static String topicsCollections() => "topics";

  static String topicsDocument(String id) => "${topicsCollections()}/$id";

  static String teamsCollections() => "teams";

  static String teamsDocument(String id) => "${teamsCollections()}/$id";

  static String groupsCollections() => "groups";

  static String groupsDocument(String id) => "${groupsCollections()}/$id";

  static String requestsCollections() => "requests";

  static String requestsDocument(String id) => "${requestsCollections()}/$id";
}
