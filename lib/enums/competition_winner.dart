/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

enum CompetitionWinner { one, three }

extension CompetitionWinnerExtension on CompetitionWinner {
  String translate() {
    switch (this) {
      case CompetitionWinner.one:
        return "فائز واحد";
      case CompetitionWinner.three:
        return "ثلاثة فائزين";
      default:
        return "";
    }
  }
}

CompetitionWinner competitionWinnerFromString(String value) {
  return CompetitionWinner.values.firstWhere(
          (status) => status.toString().replaceAll("CompetitionWinner.", "") == value,
      orElse: () => CompetitionWinner.values.first);
}