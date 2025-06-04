import 'package:anawketaby/enums/competition_type.dart';
import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_participant_individual.dart';
import 'package:anawketaby/models/competition_participant_team.dart';
import 'package:anawketaby/providers_models/screens/competition_screens/competition_info_screen_provider.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_leaderboard_screen.dart';
import 'package:anawketaby/ui/screens/competition_screens/widgets/participant_individual_item.dart';
import 'package:anawketaby/ui/screens/competition_screens/widgets/participant_team_item.dart';
import 'package:anawketaby/ui/widgets/bottom_nav_bar.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CompetitionInfoScreen extends StatelessWidget {
  final Competition competition;

  CompetitionInfoScreen({Key? key, required this.competition})
      : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (competition.timeResultPublished != null && RealTime.instance.now!.difference(competition.timeResultPublished!.toDate()).inDays <= 3) {
        navigateTo(CompetitionLeaderboardScreen(competition: competition));
        print("objectjjjj");
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("ggg");
    return ChangeNotifierProvider(
      create: (_) => CompetitionInfoScreenProvider(this.competition),
      child:
          Consumer<CompetitionInfoScreenProvider>(builder: (_, provider, __) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppStyles.PRIMARY_COLOR_DARK,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
          ),
          child: Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SafeArea(
                    child: AppBar(
                      backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                      toolbarHeight: 75.0,
                      title: Image.asset(
                        "assets/images/logo.png",
                        height: scaleHeight(100.0),
                      ),
                      centerTitle: true,
                      leading: TextButton(
                        child: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(Get.context!),
                      ),
                      actions: [
                        if (provider.isPreviewAvailable)
                          TextButton(
                            child: Text(
                              "تجربة",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppStyles.PRIMARY_COLOR_DARK,
                              ),
                            ),
                            onPressed: provider.previewCompetition,
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 6), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              CachedImage(
                                url: this.competition.imageURL ??
                                    provider.defaultCompetitionImage,
                                height: scaleHeight(200.0),
                              ),
                              RoundedContainer(
                                height: null,
                                width: MediaQuery.of(context).size.width / 1.5,
                                backgroundColor: Colors.black.withOpacity(0.4),
                                child: Text(
                                  "${this.competition.name}",
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0.0,
                                right: 0.0,
                                child: InkWell(
                                  onTap: provider.shareCompetition,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: AppStyles.SECONDARY_COLOR,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(7.0)),
                                    ),
                                    child: Text(
                                      "مشاركة المسابقة",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: AppStyles.TEXT_PRIMARY_COLOR,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (provider.isDeleteAvailable)
                                Positioned(
                                  top: 0.0,
                                  left: 0.0,
                                  child: InkWell(
                                    onTap: provider.deleteCompetition,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: AppStyles.SECONDARY_COLOR,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(7.0)),
                                      ),
                                      child: Text(
                                        "حذف المسابقة",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (provider.isArchiveAvailable)
                                Positioned(
                                  top: 0.0,
                                  left: 0.0,
                                  child: InkWell(
                                    onTap: provider.archiveCompetition,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: AppStyles.SECONDARY_COLOR,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(7.0)),
                                      ),
                                      child: Text(
                                        "أرشفة المسابقة",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (provider.isCompetitionFinished)
                                Positioned(
                                  top: 0.0,
                                  bottom: (provider.isCompetitionCreator)
                                      ? 0.0
                                      : null,
                                  left: 0.0,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        navigateTo(CompetitionLeaderboardScreen(
                                            competition: competition));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: AppStyles.SECONDARY_COLOR,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(7.0)),
                                        ),
                                        child: Text(
                                          "منصة الفائزين",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppStyles.TEXT_PRIMARY_COLOR,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (provider.isUnArchiveAvailable)
                                Positioned(
                                  top: 0.0,
                                  left: 0.0,
                                  child: InkWell(
                                    onTap: provider.unArchiveCompetition,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: AppStyles.SECONDARY_COLOR,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(7.0)),
                                      ),
                                      child: Text(
                                        "عدم أرشفة المسابقة",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (provider.isCompetitionCreator)
                                Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  child: InkWell(
                                    onTap: provider.fullCompetitionReport,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: AppStyles.SECONDARY_COLOR,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(7.0)),
                                      ),
                                      child: Text(
                                        "التقرير بالكامل",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (!provider.isCompetitionCreator &&
                                  provider.isTestYourselfAvailable)
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  child: InkWell(
                                    onTap: provider.testYourself,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: AppStyles.SECONDARY_COLOR,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(7.0)),
                                      ),
                                      child: Text(
                                        "اختبر نفسك",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (!provider.isCompetitionCreator &&
                                  !provider.isTestYourselfAvailable)
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  child: InkWell(
                                    onTap: provider.learnAgain,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: AppStyles.SECONDARY_COLOR,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(7.0)),
                                      ),
                                      child: Text(
                                        "تعلم من جديد",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (provider.isCompetitionCreator &&
                                  provider.isEditAvailable)
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  child: InkWell(
                                    onTap: provider.editCompetition,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: AppStyles.SECONDARY_COLOR,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(7.0)),
                                      ),
                                      child: Text(
                                        "تعديل المسابقة",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (provider.isCompetitionCreator &&
                                  !provider.isEditAvailable)
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  child: InkWell(
                                    onTap: provider.duplicateCompetition,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: AppStyles.SECONDARY_COLOR,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(7.0)),
                                      ),
                                      child: Text(
                                        "تكرار المسابقة",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          height: scaleHeight(140.0),
                          padding: EdgeInsets.symmetric(
                              vertical: scaleHeight(16.0),
                              horizontal: scaleWidth(16.0)),
                          child: GridView.count(
                            padding: EdgeInsets.zero,
                            crossAxisCount: 2,
                            crossAxisSpacing: scaleWidth(16.0),
                            mainAxisSpacing: scaleHeight(16.0),
                            childAspectRatio: 3.8,
                            controller: ScrollController(),
                            children: [
                              _detailsItem(
                                  icon: Icon(Icons.calendar_today_sharp),
                                  text: provider.getDateTime(
                                      provider.competition.timeEnd!.toDate())),
                              _detailsItem(
                                  icon: Icon(Icons.group_rounded),
                                  text: provider.competition.participantsCount
                                      .toString()),
                              _detailsItem(
                                  icon: Icon(Icons.person_outline),
                                  text:
                                      "${provider.competition.creatorFullName}",
                                  textOnTap: () => navigateToProfile(
                                      provider.competition.creatorID)),
                              _detailsItem(
                                  icon: Icon(Icons.card_giftcard),
                                  text: "${provider.prizePoints}"),
                            ],
                          ),
                        ),
                        _leaderBoard(),
                      ],
                    ),
                  ),
                  BottomNavBar(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _detailsItem({required Icon icon, String? text, Function? textOnTap}) {
    return Row(
      children: [
        icon,
        SizedBox(width: scaleWidth(16.0)),
        Expanded(
          child: RoundedContainer(
            height: scaleHeight(40.0),
            backgroundColor: AppStyles.SELECTION_COLOR_DARK,
            child: InkWell(
              onTap: textOnTap as void Function()?,
              child: AutoSizeText(
                "$text",
                maxLines: 2,
                minFontSize: 6.0,
                style: TextStyle(
                  fontSize: 20.0,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _leaderBoard() {
    return Container(
      color: AppStyles.PRIMARY_COLOR_DARK,
      padding: EdgeInsets.symmetric(
          vertical: scaleHeight(16.0), horizontal: scaleWidth(16.0)),
      child: StreamBuilder<QuerySnapshot>(
          stream:
              CompetitionManagement.instance.getParticipants(this.competition),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: EmptyListLoader());
            else if (snapshot.data!.docs.isEmpty)
              return Container();
            else {
              List docs = snapshot.data!.docs;
              return Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.leaderboard,
                        color: AppStyles.TEXT_PRIMARY_COLOR,
                      ),
                      SizedBox(width: scaleWidth(16.0)),
                      Expanded(
                        child: Text(
                          "الترتيب",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: AppStyles.TEXT_PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: scaleHeight(16.0)),
                  Column(
                    children: docs
                        .map<Widget>((participant) => (competition
                                    .competitionType ==
                                CompetitionType.individual)
                            ? ParticipantIndividualItem(
                                competition: this.competition,
                                index: docs.indexOf(participant) + 1,
                                participant: CompetitionParticipantIndividual
                                    .fromDocument(participant),
                              )
                            : ParticipantTeamItem(
                                competition: this.competition,
                                index: docs.indexOf(participant) + 1,
                                participant:
                                    CompetitionParticipantTeam.fromDocument(
                                        participant),
                              ))
                        .toList(),
                  ),
                ],
              );
            }
          }),
    );
  }
}
