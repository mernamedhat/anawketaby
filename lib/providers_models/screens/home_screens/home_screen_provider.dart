import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/managements/groups_management.dart';
import 'package:anawketaby/managements/topics_management.dart';
import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_category.dart';
import 'package:anawketaby/models/topic.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/providers_models/screens/my_groups_screens/new_group_screen/new_group_screen_provider.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:anawketaby/ui/screens/account_screens/account_screen.dart';
import 'package:anawketaby/ui/screens/admin_screens/admin_main_screen.dart';
import 'package:anawketaby/ui/screens/auth_screens/intro_screen.dart';
import 'package:anawketaby/ui/screens/home_screens/competitions_list_screen/competitions_list_screen.dart';
import 'package:anawketaby/ui/screens/my_groups_screens/group_info_screen/group_info_screen.dart';
import 'package:anawketaby/ui/screens/my_groups_screens/my_groups_list_screen/my_groups_list_screen.dart';
import 'package:anawketaby/ui/screens/my_teams_screens/my_teams_list_screen/my_teams_list_screen.dart';
import 'package:anawketaby/ui/screens/settings_screens/settings_screen.dart';
import 'package:anawketaby/ui/screens/topic_details_screen/topic_details_screen.dart';
import 'package:anawketaby/ui/screens/topics_list_screen/topics_list_screen.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

class HomeScreenProvider extends ChangeNotifier with WidgetsBindingObserver {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isTimeErrorShowing = false;

  Map<String, dynamic>? _competitionCategoriesSort;

  final int _limit = 5;

  final List<CompetitionCategory> competitionCategories = [];

  HomeScreenProvider() {
    WidgetsBinding.instance.addObserver(this);

    _setAndSortCompetitionCategories();
    _initNotifications();
    _initUniLinks();
  }

  void _initNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String? title = message.notification?.title;
      String? body = message.notification?.body;
      String? tag =
          message.data.containsKey("tag") ? message.data["tag"] : null;

      if (message.notification != null) {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "$title",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: AppStyles.PRIMARY_COLOR_DARK,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: scaleHeight(12.0)),
                  Text(
                    "$body",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppStyles.PRIMARY_COLOR_DARK,
                    ),
                  ),
                  if (tag != null && tag.contains("competition")) ...[
                    SizedBox(height: scaleHeight(20.0)),
                    ElevatedButton(
                      onPressed: () async {
                        int? competitionCode = int.tryParse(tag.split("_").last);
                        if (competitionCode != null) {
                          showLoadingDialog();
                          Competition? competition = await CompetitionManagement
                              .instance
                              .getCompetitionByCode(competitionCode);
                          Navigator.pop(Get.context!);
                          if (competition != null) {
                            Navigator.pop(Get.context!);
                            navigateToCompetition(competition);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                        minimumSize: Size(double.infinity, scaleHeight(60.0)), // Width and height
                        padding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding if needed
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "انتقال للتحدي",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(width: 8.0), // Add space between text and icon
                          Icon(
                            CupertinoIcons.rocket,
                            color: AppStyles.TEXT_PRIMARY_COLOR,
                            size: scaleWidth(28.0),
                          ),
                        ],
                      ),
                    ),

                  ],
                ],
              ),
            );
          },
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      String? tag =
          message.data.containsKey("tag") ? message.data["tag"] : null;

      if (tag != null) {
        if (tag.contains("competition")) {
          int? competitionCode = int.tryParse(tag.split("_").last);
          if (competitionCode != null) {
            showLoadingDialog();
            Competition? competition = await CompetitionManagement.instance
                .getCompetitionByCode(competitionCode);
            Navigator.pop(Get.context!);
            if (competition != null) {
              navigateToCompetition(competition);
            }
          }
        }
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message == null) {
        return;
      }

      String? tag =
          message.data.containsKey("tag") ? message.data["tag"] : null;

      if (tag != null) {
        if (tag.contains("competition")) {
          print("object11");
          int? competitionCode = int.tryParse(tag.split("_").last);
          if (competitionCode != null) {
            showLoadingDialog();
            Competition? competition = await CompetitionManagement.instance
                .getCompetitionByCode(competitionCode);
            Navigator.pop(Get.context!);
            if (competition != null) {
              navigateToCompetition(competition);
            }
          }
        }
      }
    });
  }

  _initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      if (SettingsProvider.deepLinkHandled == false) {
        SettingsProvider.deepLinkHandled = true;
        final initialLink = await getInitialLink();
        if (initialLink != null) {
          _handleUniLinks(initialLink);
        }
      }
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }

    linkStream.listen((String? link) {
      if (link == null) return;
      _handleUniLinks(link);
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  Future<void> _handleUniLinks(String link) async {
    try {
      final navigateDetailsStr = link
          .replaceAll("https://app.anawketaby.com/", "")
          .replaceAll("anawketaby://", "");

      final List<String> navigateDetailsList = navigateDetailsStr.split("/");

      final action = navigateDetailsList.first;

      switch (action) {
        case 't':
          final topicId = navigateDetailsList[1];
          final Topic? topic =
              await TopicsManagement.instance.getTopicByID(topicId);
          if (topic != null) {
            navigateTo(TopicDetailsScreen(topic: topic));
          } else {
            showErrorDialog(
              title: 'خطأ في الرابط',
              desc: 'هذا الرابط لا يعمل الآن',
            );
          }
          break;
        case 'g':
          final groupShareId = navigateDetailsList[1];
          final AppGroup? group = await GroupsManagement.instance
              .getAppGroupByShareID(groupShareId);
          if (group != null) {
            if (group.membersIDs.contains(appUser!.id)) {
              navigateTo(GroupInfoScreen(group: group));
            } else {
              AwesomeDialog(
                context: Get.context!,
                animType: AnimType.scale,
                headerAnimationLoop: false,
                dialogType: DialogType.question,
                title: 'الإنضمام إلى المجموعة',
                desc: 'أنت غير مشترك في هذه المجموعة، هل تريد الانضمام الآن؟',
                btnOkText: 'نعم',
                btnOkOnPress: () async {
                  // Exclude moderators and leader him/her-self
                  if (group.membersIDs.length -
                          group.moderatorsIDs.length -
                          1 >=
                      group.groupFeature.membersLimit) {
                    showErrorSnackBar(
                      title: "عدد الأعضاء مكتمل",
                      message:
                          "عدد الأعضاء في المجموعة مكتمل، برجاء التواصل مع قائد المجموعة.",
                    );
                    return;
                  }

                  group.membersIDs.add(appUser!.id!);
                  if (appUser?.fcmToken != null)
                    group.membersFCMTokens.add(appUser!.fcmToken!);
                  group.membersProfiles[appUser!.id!] =
                      NewGroupScreenProvider.memberJSON(appUser!);

                  bool isSuccess = await GroupsManagement.instance
                      .joinGroupByLink(group.id!);

                  if (isSuccess) {
                    showSuccessfulSnackBar(
                      title: "تم انضمامك في المجموعة بنجاح",
                      message:
                          "يمكنك الآن الدخول إلى مجموعاتي ومتابعة المجموعة.",
                    );
                  } else {
                    showErrorDialog(
                      title: 'حدث خطأ في الانضمام',
                      desc: 'من فضلك قم بالمحاولة مرة اخرى',
                    );
                  }
                },
                btnCancelText: 'لا',
                btnCancelOnPress: () {},
              )..show();
            }
          } else {
            showErrorDialog(
              title: 'خطأ في الرابط',
              desc: 'هذا الرابط لا يعمل الآن',
            );
          }
          break;
      }
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (_isTimeErrorShowing) {
        Navigator.pop(Get.context!);
        _isTimeErrorShowing = false;
      }
    } else if (state == AppLifecycleState.resumed) {
      DateTime localDateTime = DateTime.now();
      DateTime realDateTime = RealTime.instance.now!;
      if (realDateTime.difference(localDateTime).inSeconds > 10) {
        if (!_isTimeErrorShowing) {
          _isTimeErrorShowing = true;
          showErrorDialog(
            title: 'خطأ في الوقت',
            desc:
                'يوجد فرق توقيت بين وقت الهاتف والوقت الأصلي، برجاء تفعيل تحديد الوقت تلقائيا من اعدادات الهاتف.',
            onDismissCallback: (_) => _isTimeErrorShowing = false,
          );
        }
      }
    }
  }

  Future _setAndSortCompetitionCategories() async {
    competitionCategories.addAll([
      CompetitionCategory(
        key: "newest",
        title: "أحدث التحديات",
        streamLimited: CompetitionManagement.instance
            .getPublishedCompetitions(limit: _limit),
        streamUnlimited:
            CompetitionManagement.instance.getPublishedCompetitions(),
        moreOnTap: () async => navigateTo(
          CompetitionsListScreen(
            title: "احدث التحديات",
            stream: CompetitionManagement.instance.getPublishedCompetitions(),
          ),
        ),
      ),
      CompetitionCategory(
        key: "popular",
        title: "أشهر التحديات",
        streamLimited: CompetitionManagement.instance
            .getPopularCompetitions(limit: _limit),
        streamUnlimited:
            CompetitionManagement.instance.getPopularCompetitions(),
        moreOnTap: () async => navigateTo(
          CompetitionsListScreen(
            title: "أشهر التحديات",
            stream: CompetitionManagement.instance.getPopularCompetitions(),
          ),
        ),
      ),
      CompetitionCategory(
        key: "tests",
        title: "أختبر نفسك",
        streamLimited: CompetitionManagement.instance
            .getTestYourselfCompetitions(limit: _limit),
        streamUnlimited:
            CompetitionManagement.instance.getTestYourselfCompetitions(),
        moreOnTap: () async => navigateTo(
          CompetitionsListScreen(
            title: "أختبر نفسك",
            stream:
                CompetitionManagement.instance.getTestYourselfCompetitions(),
          ),
        ),
      ),
      CompetitionCategory(
        key: "mine",
        title: "تحدياتي",
        streamLimited:
            CompetitionManagement.instance.getMyCompetitions(limit: _limit),
        streamUnlimited: CompetitionManagement.instance.getMyCompetitions(),
        moreOnTap: () async => navigateTo(
          CompetitionsListScreen(
            title: "تحدياتي",
            stream: CompetitionManagement.instance.getMyCompetitions(),
          ),
        ),
      ),
    ]);

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .doc(FirestorePaths.configurationsDocument())
        .get();

    _competitionCategoriesSort =
        (doc.data() as Map)["competitionCategoriesSort"];

    competitionCategories.sort((a, b) => _competitionCategoriesSort![a.key]
        .compareTo(_competitionCategoriesSort![b.key]));
    notifyListeners();
  }

  void goToProfile() {
    Navigator.pop(Get.context!);
    navigateTo(AccountScreen());
  }

  Future<void> goToMyChallenges() async {
    Navigator.pop(Get.context!);
    navigateTo(CompetitionsListScreen(
      title: "تحدياتي",
      stream: CompetitionManagement.instance.getMyCompetitions(),
    ));
  }

  Future<void> goToMyGroups() async {
    Navigator.pop(Get.context!);
    navigateTo(MyGroupsListScreen());
  }

  Future<void> goToMyTeams() async {
    Navigator.pop(Get.context!);
    navigateTo(MyTeamsListScreen());
  }

  Future<void> goToTopics() async {
    Navigator.pop(Get.context!);
    navigateTo(TopicsListScreen());
  }

  void goToSettings() {
    Navigator.pop(Get.context!);
    navigateTo(SettingsScreen());
  }

  Future<void> signOut() async {
    showLoadingDialog();

    await UsersManagement.instance.updateUserToken(
        userID: this.appUser!.firebaseUser!.uid, isLoggedOut: true);

    await FirebaseAuth.instance.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FacebookAuth.instance.logOut();

    Provider.of<UserProvider>(Get.context!, listen: false).setUser(null);
    navigateRemoveUntil(IntroScreen(), (Route<dynamic> route) => false);
  }

  void goToAdminPanel() {
    Navigator.pop(Get.context!);
    navigateTo(AdminMainScreen());
  }

  Future reviewApplication() async {
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.openStoreListing(
      appStoreId: '1605462556', // AppStore id of your app
    );
  }

  Map<String, dynamic>? get competitionCategoriesSort =>
      _competitionCategoriesSort;
}
