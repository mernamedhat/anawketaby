class CompetitionCategory {
  final String key;
  final String title;
  final Stream streamLimited;
  final Stream streamUnlimited;
  final Function moreOnTap;

  CompetitionCategory({
   required this.key,
    required this.title,
    required this.streamLimited,
    required this.streamUnlimited,
    required this.moreOnTap,
  });
}
