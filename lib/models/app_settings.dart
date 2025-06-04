class AppSettings {
  bool isCompetitionMusicEnabled;
  bool isCompetitionTimerSoundEnabled;
  bool isCompetitionClickSoundEnabled;
  double textScaleFactor;

  AppSettings({
    this.isCompetitionMusicEnabled = true,
    this.isCompetitionTimerSoundEnabled = false,
    this.isCompetitionClickSoundEnabled = true,
    this.textScaleFactor = 1.0,
  });
}
