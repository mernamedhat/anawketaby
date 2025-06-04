import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/screens/my_teams_screens/team_info_screen/team_info_screen_provider.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/challenge_vertical_tile.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/ui/widgets/team_vertical_tile.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TeamInfoScreen extends StatelessWidget {
  final AppTeam team;

  const TeamInfoScreen({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeamInfoScreenProvider(team),
      child: Consumer<TeamInfoScreenProvider>(builder: (_, provider, __) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppStyles.PRIMARY_COLOR_DARK,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
          ),
          child: Scaffold(
            body: DefaultTabController(
              length: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SafeArea(
                      child: AppBar(
                        backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                        toolbarHeight: 75.0,
                        title: AutoSizeText(
                          "${team.name}",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: AppStyles.PRIMARY_COLOR,
                          ),
                        ),
                        centerTitle: true,
                        leading: TextButton(
                          child: Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.pop(context),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              (provider.isLeader) ? "تعديل" : "مغادرة",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: (provider.isLeader)
                                    ? AppStyles.PRIMARY_COLOR_DARK
                                    : AppStyles.SECONDARY_COLOR_DARK,
                              ),
                            ),
                            onPressed: (provider.isLeader)
                                ? provider.editTeam
                                : provider.leaveTeam,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: TabBar(
                        tabs: [
                          Tab(
                            child: Text(
                              "معلومات",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppStyles.PRIMARY_COLOR_DARK,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "مسابقات",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppStyles.PRIMARY_COLOR_DARK,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ListView(
                            padding: const EdgeInsets.all(8.0),
                            children: [
                              TeamVerticalTile(team: team),
                              const SizedBox(height: 32.0),
                              Text(
                                "القائد",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: AppStyles.PRIMARY_COLOR_DARK,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              _memberItem(
                                provider,
                                provider.team.leaderID,
                                showNumber: false,
                              ),
                              const SizedBox(height: 18.0),
                              Text(
                                "أعضاء الفريق",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: AppStyles.PRIMARY_COLOR_DARK,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              ...provider.team.membersIDs
                                  .map((e) => _memberItem(provider, e))
                                  .toList(),
                              const SizedBox(height: 18.0),
                              if (provider.team.description.isNotEmpty) ...[
                                Text(
                                  "صيحة الفريق",
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: AppStyles.PRIMARY_COLOR_DARK,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "${provider.team.description}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: AppStyles.PRIMARY_COLOR_DARK,
                                  ),
                                ),
                                const SizedBox(height: 18.0),
                              ],
                            ],
                          ),
                          FutureBuilder<List<Competition>>(
                            future: CompetitionManagement.instance
                                .getCompetitionsByIDs(
                                    provider.team.participatedCompetitions),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(child: EmptyListLoader());
                              } else {
                                if (snapshot.data!.isEmpty)
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: EmptyListText(
                                        text:
                                            "لا توجد مسابقات تم الاشتراك فيها بهذا الفريق",
                                      ),
                                    ),
                                  );
                                else {
                                  return ListView.separated(
                                      itemCount: snapshot.data!.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(height: scaleHeight(12.0)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: scaleHeight(16.0)),
                                      itemBuilder: (_, index) {
                                        return ChallengeVerticalTile(
                                            competition: snapshot.data![index]);
                                      });
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _memberItem(
    TeamInfoScreenProvider provider,
    String memberID, {
    bool showNumber = true,
  }) {
    int index = provider.team.membersIDs.indexOf(memberID) + 1;
    Map memberMap = provider.team.membersProfiles[memberID];

    return Column(
      children: [
        RoundedContainer(
          backgroundColor: AppStyles.BACKGROUND_COLOR.withAlpha(30),
          child: Row(
            children: [
              if (showNumber) ...[
                RoundedContainer(
                  height: scaleHeight(35.0),
                  width: scaleWidth(35.0),
                  padding: EdgeInsets.symmetric(
                      vertical: scaleHeight(2.0), horizontal: scaleWidth(2.0)),
                  backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                  child: AutoSizeText(
                    "$index",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: scaleWidth(16.0)),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(35.0),
                child: (memberMap["profilePhotoURL"] != null)
                    ? CachedImage(
                        url: "${memberMap["profilePhotoURL"]}",
                        height: scaleHeight(70.0),
                        width: scaleWidth(70.0),
                      )
                    : Container(
                        color: Colors.white,
                        child: Image.asset(
                          "assets/images/default_profile.png",
                          fit: BoxFit.contain,
                          height: scaleHeight(70.0),
                          width: scaleWidth(70.0),
                        ),
                      ),
              ),
              SizedBox(width: scaleWidth(16.0)),
              Expanded(
                child: AutoSizeText(
                  "${memberMap["fullName"]}",
                  maxLines: 1,
                  minFontSize: 6.0,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppStyles.APP_MATERIAL_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppStyles.SELECTION_COLOR_DARK),
      ],
    );
  }
}
