import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/providers_models/screens/profile_screens/profile_screen_provider.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/challenge_vertical_tile.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  final AppUser userProfile;

  const ProfileScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileScreenProvider(this.userProfile),
      child: Consumer<ProfileScreenProvider>(builder: (_, provider, __) {
        provider.appUser = Provider.of<UserProvider>(context).appUser;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppStyles.PRIMARY_COLOR,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
          ),
          child: Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              color: AppStyles.BACKGROUND_COLOR,
              child: Column(
                children: [
                  SafeArea(
                    child: AppBar(
                      backgroundColor: AppStyles.PRIMARY_COLOR_DARK,
                      toolbarHeight: 75.0,
                      title: AutoSizeText(
                        "${provider.userProfile.fullName}",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                        ),
                      ),
                      centerTitle: true,
                      leading: TextButton(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(70.0),
                                      child:
                                          (provider.userProfile.getPhotoURL() !=
                                                  null)
                                              ? CachedImage(
                                                  url: provider.userProfile
                                                      .getPhotoURL(),
                                                  fit: BoxFit.cover,
                                                  height: scaleHeight(100.0),
                                                  width: scaleWidth(100.0),
                                                  loaderColor: Colors.white,
                                                )
                                              : Image.asset(
                                                  "assets/images/default_profile.png",
                                                  fit: BoxFit.cover,
                                                  height: scaleHeight(140.0),
                                                  width: scaleWidth(140.0),
                                                ),
                                    ),
                                    if (provider.appUser!.id !=
                                        provider.userProfile.id) ...[
                                      if (!provider.appUser!.following.contains(provider.userProfile.id))
                                        ElevatedButton(
                                          onPressed: provider.followUser,
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                                            backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                                            minimumSize: Size(80.0, scaleHeight(40.0)), // Width & Height
                                          ),
                                          child: const Text(
                                            "متابعة",
                                            style: TextStyle(
                                              color: AppStyles.TEXT_PRIMARY_COLOR,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        )
                                      else
                                        ElevatedButton(
                                          onPressed: provider.unfollowUser,
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                                            backgroundColor: AppStyles.SECONDARY_COLOR_DARK, // Button background color
                                            minimumSize: Size(80.0, scaleHeight(40.0)), // Width & Height
                                          ),
                                          child: const Text(
                                            "إلغاء",
                                            style: TextStyle(
                                              color: AppStyles.TEXT_PRIMARY_COLOR,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        )

                                    ]
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                color: AppStyles.APP_MATERIAL_COLOR.shade300,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          AutoSizeText(
                                            "${provider.userProfile.followers?.length}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  AppStyles.TEXT_PRIMARY_COLOR,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          AutoSizeText(
                                            "متابعون",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color:
                                                  AppStyles.TEXT_PRIMARY_COLOR,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 40.0,
                                      child: VerticalDivider(
                                        width: 12.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          AutoSizeText(
                                            "${provider.userProfile.following.length}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  AppStyles.TEXT_PRIMARY_COLOR,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          AutoSizeText(
                                            "يتابعهم",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color:
                                                  AppStyles.TEXT_PRIMARY_COLOR,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                color: AppStyles.APP_MATERIAL_COLOR.shade300,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          AutoSizeText(
                                            "${provider.userProfile.points}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  AppStyles.TEXT_PRIMARY_COLOR,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          AutoSizeText(
                                            "النقاط",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color:
                                                  AppStyles.TEXT_PRIMARY_COLOR,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (provider.appUser!.isAdmin!) ...[
                                      Container(
                                        height: 40.0,
                                        child: VerticalDivider(
                                          width: 12.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            AutoSizeText(
                                              "${AppUser.getChurchName(provider.userProfile.church)}",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: AppStyles
                                                    .TEXT_PRIMARY_COLOR,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            AutoSizeText(
                                              "الكنيسة",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppStyles
                                                    .TEXT_PRIMARY_COLOR,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (provider.appUser!.isAdmin!)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12.0),
                                  color: AppStyles.APP_MATERIAL_COLOR.shade300,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "رقم الهاتف: ",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          launchUrl(Uri.parse(
                                              "tel:${provider.userProfile.phone}"));
                                        },
                                        child: AutoSizeText(
                                          "${provider.userProfile.phone}",
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppStyles.TEXT_PRIMARY_COLOR,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      InkWell(
                                        onTap: () {
                                          launchUrl(Uri.parse(
                                              "tel:${provider.userProfile.phone}"));
                                        },
                                        child: Icon(
                                          Icons.call,
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      InkWell(
                                        onTap: () {
                                          launchUrl(
                                            Uri.parse(
                                                "https://wa.me/${provider.userProfile.phone}"),
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        },
                                        child: Icon(
                                          Icons.whatshot,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            color: AppStyles.PRIMARY_COLOR_DARK,
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  "المسابقات",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                  ),
                                ),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: CompetitionManagement.instance
                                        .getMyCreationCompetitions(
                                            provider.userProfile),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return Center(child: EmptyListLoader());
                                      else if (snapshot.data!.docs.isEmpty)
                                        return Center(
                                            child: EmptyListText(
                                          text: "لا توجد تحديات",
                                        ));
                                      else {
                                        return ListView.separated(
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            separatorBuilder: (_, __) =>
                                                SizedBox(
                                                    height: scaleHeight(12.0)),
                                            padding: EdgeInsets.symmetric(
                                                vertical: scaleHeight(16.0)),
                                            itemBuilder: (_, index) {
                                              Competition competition =
                                                  Competition.fromDocument(
                                                      snapshot
                                                          .data!.docs[index]);
                                              return ChallengeVerticalTile(
                                                  competition: competition);
                                            });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
