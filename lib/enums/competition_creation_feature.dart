/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

enum CompetitionCreationFeature {
  canBackOrNot,
  questionTF,
  questionMCQOne,
  questionMCQMultiple,
  questionJoin,
  questionOrdering,
  conditionGender,
  conditionChurch,
  conditionRole,
  conditionAge,
  conditionTopic,
  conditionFollowing,
  pointsFree,
  typeIndividuals,
  typeTeams,
  level,
  randomQuestions,
  timeConsideration,
  winner,
  passwordLock,
}

CompetitionCreationFeature competitionCreationFeatureFromString(String value) {
  return CompetitionCreationFeature.values.firstWhere(
      (status) =>
          status.toString().replaceAll("CompetitionCreationFeature.", "") ==
          value,
      orElse: () => CompetitionCreationFeature.values.first);
}
