/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

enum CompetitionType { individual, teams }

extension CompetitionTypeExtension on CompetitionType {
  String translate() {
    switch (this) {
      case CompetitionType.individual:
        return "فردي";
      case CompetitionType.teams:
        return "فرق";
      default:
        return "";
    }
  }
}

CompetitionType competitionTypeFromString(String value) {
  return CompetitionType.values.firstWhere(
      (status) => status.toString().replaceAll("CompetitionType.", "") == value,
      orElse: () => CompetitionType.values.first);
}
