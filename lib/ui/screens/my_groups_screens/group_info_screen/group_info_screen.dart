// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/screens/my_groups_screens/group_info_screen/group_info_screen_provider.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/admin_new_competition_screen.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/challenge_vertical_tile.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/ui/widgets/group_vertical_tile.dart';
import 'package:anawketaby/ui/widgets/rounded_text_field.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupInfoScreen extends StatelessWidget {
  final AppGroup group;
  final bool isFromAdmin;

  const GroupInfoScreen({
    Key? key,
    required this.group,
    this.isFromAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupInfoScreenProvider(group),
      child: Consumer<GroupInfoScreenProvider>(builder: (_, provider, __) {
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
                          "${group.name}",
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
                              (provider.appUser?.isAdmin == true && isFromAdmin)
                                  ? (group.isActivated)
                                      ? "تعطيل"
                                      : "تفعيل"
                                  : (group.isLeaderOrModerator(
                                          provider.appUser!))
                                      ? "تعديل"
                                      : "مغادرة",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: (provider.appUser?.isAdmin == true &&
                                        isFromAdmin)
                                    ? (group.isActivated)
                                        ? AppStyles.SECONDARY_COLOR_DARK
                                        : AppStyles.THIRD_COLOR_DARK
                                    : (group.isLeaderOrModerator(
                                            provider.appUser!))
                                        ? AppStyles.PRIMARY_COLOR_DARK
                                        : AppStyles.SECONDARY_COLOR_DARK,
                              ),
                            ),
                            onPressed: (provider.appUser?.isAdmin == true &&
                                    isFromAdmin)
                                ? (group.isActivated)
                                    ? provider.adminDeactivateGroup
                                    : provider.adminActivateGroup
                                : (group.isLeaderOrModerator(provider.appUser!))
                                    ? provider.editGroup
                                    : provider.leaveGroup,
                          ),
                        ],
                      ),
                    ),
                    if (!group.isActivated)
                      Container(
                        color: AppStyles.SECONDARY_COLOR,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "لقد تم تعطيل هذه المجموعة، برجاء التواصل مع إدارة التطبيق.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
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
                              GroupVerticalTile(group: group),
                              const SizedBox(height: 32.0),
                              if (provider.group
                                  .isLeaderOrModerator(provider.appUser!)) ...[
                                Text(
                                  "رابط المجموعة",
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: AppStyles.PRIMARY_COLOR_DARK,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                RoundedTextField(
                                  height: null,
                                  width: scaleWidth(100.0),
                                  padding: EdgeInsets.all(scaleWidth(12.0)),
                                  textField: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        textDirection:
                                            (provider.group.shareID == null)
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              (provider.group.shareID == null)
                                                  ? "لا يوجد رابط خاص بالمجموعة"
                                                  : "https://app.anawketaby.com/g/${provider.group.shareID}",
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppStyles
                                                    .PRIMARY_COLOR_DARK,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          if (provider.group.shareID !=
                                              null) ...[
                                            const SizedBox(width: 16.0),
                                            InkWell(
                                              onTap: () {
                                                Share.share(
                                                    "https://app.anawketaby.com/g/${provider.group.shareID}");
                                              },
                                              child: Icon(
                                                Icons.share,
                                                color: AppStyles
                                                    .PRIMARY_COLOR_DARK,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 12.0),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:ElevatedButton(
                                          onPressed: provider.generateNewShareId,
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                                            backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                                            minimumSize: Size(160.0, scaleHeight(40.0)), // Width & Height
                                          ),
                                          child: const Text(
                                            "إعادة تعيين الرابط",
                                            style: TextStyle(
                                              color: AppStyles.TEXT_PRIMARY_COLOR,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        )

                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32.0),
                              ],
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
                                provider.group.leaderID,
                                showNumber: false,
                              ),
                              const SizedBox(height: 18.0),
                              if (provider.group.moderatorsIDs.isNotEmpty) ...[
                                Text(
                                  "المشرفين",
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: AppStyles.PRIMARY_COLOR_DARK,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                ...provider.group.moderatorsIDs
                                    .map((e) => _memberItem(
                                          provider,
                                          e,
                                          showNumber: false,
                                        ))
                                    .toList(),
                                const SizedBox(height: 18.0),
                              ],
                              Text(
                                "أعضاء المجموعة",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: AppStyles.PRIMARY_COLOR_DARK,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              ...provider.group.membersIDs
                                  .map((e) => _memberItem(provider, e))
                                  .toList(),
                              const SizedBox(height: 18.0),
                              if (provider.group.description.isNotEmpty) ...[
                                Text(
                                  "وصف المجموعة",
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: AppStyles.PRIMARY_COLOR_DARK,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "${provider.group.description}",
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
                                    provider.group.createdCompetitions),
                            builder: (context, snapshot) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: (!snapshot.hasData)
                                        ? Center(child: EmptyListLoader())
                                        : (snapshot.data!.isEmpty)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: EmptyListText(
                                                    text:
                                                        "لا توجد مسابقات في هذه المجموعة",
                                                  ),
                                                ),
                                              )
                                            : ListView.separated(
                                                itemCount:
                                                    snapshot.data!.length,
                                                separatorBuilder: (_, __) =>
                                                    SizedBox(
                                                        height:
                                                            scaleHeight(12.0)),
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        scaleHeight(16.0)),
                                                itemBuilder: (_, index) {
                                                  Competition competition =
                                                      snapshot.data![index];
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      ChallengeVerticalTile(
                                                        competition:
                                                            competition,
                                                      ),
                                                      // Padding(
                                                      //   padding:
                                                      //       const EdgeInsets
                                                      //           .all(8.0),
                                                      //   child: FilledButton(
                                                      //     onPressed: () => provider
                                                      //         .copyCompetitionToGroup(
                                                      //             competition),
                                                      //     text:
                                                      //         "نسخ المسابقة لمجموعة اخرى",
                                                      //     height:
                                                      //         scaleHeight(36.0),
                                                      //     minWidth:
                                                      //         double.infinity,
                                                      //     color: AppStyles
                                                      //         .PRIMARY_COLOR,
                                                      //     backgroundColor: AppStyles
                                                      //         .PRIMARY_COLOR_DARK,
                                                      //     style:
                                                      //         const TextStyle(
                                                      //       color: AppStyles
                                                      //           .TEXT_PRIMARY_COLOR,
                                                      //       fontSize: 14.0,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      if (competition
                                                                  .groupsIDs !=
                                                              null &&
                                                          competition.groupsIDs!
                                                                  .length >
                                                              1)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:ElevatedButton(
                                                            onPressed: () => provider.removeCompetitionFromGroup(competition),
                                                            style: ElevatedButton.styleFrom(
                                                              foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                                                              backgroundColor: AppStyles.SECONDARY_COLOR_DARK, // Button background color
                                                              minimumSize: Size(double.infinity, scaleHeight(36.0)), // Full width & Height
                                                            ),
                                                            child: const Text(
                                                              "حذفها من المجموعة",
                                                              style: TextStyle(
                                                                color: AppStyles.TEXT_PRIMARY_COLOR,
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          )

                                                        ),
                                                    ],
                                                  );
                                                }),
                                  ),
                                  if (group
                                      .isLeaderOrModerator(provider.appUser!))
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:ElevatedButton(
                                        onPressed: () async {
                                          await navigateTo(
                                            AdminNewCompetitionScreen(group: group),
                                          );
                                          provider.notifyListeners();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                                          backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                                          minimumSize: Size(double.infinity, scaleHeight(55.0)), // Full width & Height
                                        ),
                                        child: const Text(
                                          "مسابقة جديدة",
                                          style: TextStyle(
                                            color: AppStyles.TEXT_PRIMARY_COLOR,
                                            fontSize: 22.0,
                                          ),
                                        ),
                                      )

                                    ),
                                ],
                              );
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
    GroupInfoScreenProvider provider,
    String memberID, {
    bool showNumber = true,
  }) {
    int index = provider.group.membersIDs.indexOf(memberID) + 1;
    Map memberMap = provider.group.membersProfiles[memberID];

    return Column(
      children: [
        InkWell(
          onTap: (group.isLeaderOrModerator(provider.appUser!))
              ? () => navigateToProfile(memberID)
              : null,
          child: RoundedContainer(
            backgroundColor: AppStyles.BACKGROUND_COLOR.withAlpha(30),
            child: Row(
              children: [
                if (showNumber) ...[
                  RoundedContainer(
                    height: scaleHeight(35.0),
                    width: scaleWidth(35.0),
                    padding: EdgeInsets.symmetric(
                        vertical: scaleHeight(2.0),
                        horizontal: scaleWidth(2.0)),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AutoSizeText(
                        "${memberMap["fullName"]}",
                        maxLines: 1,
                        minFontSize: 6.0,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: AppStyles.APP_MATERIAL_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (provider.group
                                  .isLeaderOrModerator(provider.appUser!) ==
                              true ||
                          provider.appUser!.isAdmin == true) ...[
                        SizedBox(height: scaleHeight(8.0)),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  launchUrl(
                                      Uri.parse("tel:${memberMap["phone"]}"));
                                },
                                child: AutoSizeText(
                                  "${memberMap["phone"]}",
                                  maxLines: 1,
                                  minFontSize: 6.0,
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: AppStyles.APP_MATERIAL_COLOR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            InkWell(
                              onTap: () {
                                launchUrl(
                                    Uri.parse("tel:${memberMap["phone"]}"));
                              },
                              child: Icon(
                                Icons.call,
                                color: AppStyles.PRIMARY_COLOR,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            InkWell(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                      "https://wa.me/${memberMap["phone"]}"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              ///M
                              child: Icon(
                                Icons.whatshot,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: AppStyles.SELECTION_COLOR_DARK),
      ],
    );
  }
}
