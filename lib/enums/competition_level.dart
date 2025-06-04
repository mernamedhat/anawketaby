/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

enum CompetitionLevel { easy, medium, hard, noSpecified }

extension CompetitionLevelExtension on CompetitionLevel {
  String translate() {
    switch (this) {
      case CompetitionLevel.easy:
        return "سهله";
      case CompetitionLevel.medium:
        return "متوسطة";
      case CompetitionLevel.hard:
        return "صعبة";
      case CompetitionLevel.noSpecified:
        return "غير محدد";
      default:
        return "";
    }
  }
}

CompetitionLevel competitionLevelFromString(String value) {
  return CompetitionLevel.values.firstWhere(
          (status) => status.toString().replaceAll("CompetitionLevel.", "") == value,
      orElse: () => CompetitionLevel.values.first);
}
