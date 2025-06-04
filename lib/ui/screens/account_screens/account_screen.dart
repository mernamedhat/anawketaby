import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/providers_models/screens/account_screens/account_screen_provider.dart';
import 'package:anawketaby/ui/screens/account_screens/points_history_list_screen/points_history_list_screen.dart';
import 'package:anawketaby/ui/screens/home_screens/competitions_list_screen/competitions_list_screen.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountScreenProvider(),
      child: Consumer<AccountScreenProvider>(builder: (_, provider, __) {
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
              color: AppStyles.PRIMARY_COLOR,
              child: Column(
                children: [
                  SafeArea(
                    child: AppBar(
                      backgroundColor: AppStyles.PRIMARY_COLOR_DARK,
                      toolbarHeight: 75.0,
                      title: Text(
                        "الملف الشخصي",
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
                      actions: [
                        TextButton(
                          child: Text(
                            "تعديل",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                            ),
                          ),
                          onPressed: provider.editAccount,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: scaleHeight(220.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: (provider.appUser?.getPhotoURL() != null)
                                    ? CachedImage(
                                        url: provider.appUser?.getPhotoURL(),
                                        fit: BoxFit.cover,
                                        height: scaleHeight(100.0),
                                        width: scaleWidth(100.0),
                                        loaderColor: Colors.white,
                                      )
                                    : Image.asset(
                                        "assets/images/default_profile.png",
                                        fit: BoxFit.cover,
                                        height: scaleHeight(100.0),
                                        width: scaleWidth(100.0),
                                      ),
                              ),
                              Text(
                                "${provider.appUser?.fullName}",
                                style: TextStyle(
                                    fontSize: 24.0,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            color: AppStyles.PRIMARY_COLOR_DARK,
                            padding: const EdgeInsets.all(12.0),
                            child: ListView(
                              children: [
                                _listTile(
                                  "رقم التليفون",
                                  "${provider.appUser?.phone}",
                                  fontFamily: AppStyles.TAJAWAL,
                                ),
                                _listTile(
                                  "الكنيسة",
                                  (provider.appUser?.church != null)
                                      ? "${AppUser.getChurchName(provider.appUser?.church)}"
                                      : "-",
                                ),
                                _listTile(
                                  "دورك في الكنيسة",
                                  (provider.appUser?.churchRole != null)
                                      ? AppUser.getChurchRoleName(
                                          provider.appUser?.churchRole)
                                      : "-",
                                ),
                                _listTile(
                                  "البريد الالكتروني",
                                  "${provider.appUser?.email}",
                                  fontFamily: AppStyles.TAJAWAL,
                                ),
                                _listTile(
                                  "تاريخ الميلاد",
                                  (provider.appUser?.birthDate != null)
                                      ? provider.getDateTimeBirthDate(provider
                                              .appUser?.birthDate
                                              ?.toDate() ??
                                          DateTime.now())
                                      : "-",
                                ),
                                ListTile(
                                  onTap: () async =>
                                      navigateTo(CompetitionsListScreen(
                                    title: "تحدياتي",
                                    stream: CompetitionManagement.instance
                                        .getMyCompetitions(),
                                  )),
                                  title: Text(
                                    "تحدياتي",
                                    style: TextStyle(
                                      color: AppStyles.TEXT_PRIMARY_COLOR,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    size: 36.0,
                                  ),
                                ),
                                Divider(color: AppStyles.TEXT_PRIMARY_COLOR),
                                ListTile(
                                  onTap: () =>
                                      navigateTo(PointsHistoryListScreen()),
                                  title: Text(
                                    "النقاط",
                                    style: TextStyle(
                                      color: AppStyles.TEXT_PRIMARY_COLOR,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${provider.appUser?.points}",
                                        style: TextStyle(
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: AppStyles.TEXT_PRIMARY_COLOR,
                                        size: 36.0,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(color: AppStyles.TEXT_PRIMARY_COLOR),
                                ListTile(
                                  onTap: provider.signOut,
                                  title: Text(
                                    "تسجيل الخروج",
                                    style: TextStyle(
                                      color: AppStyles.TEXT_PRIMARY_COLOR,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
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

  Widget _listTile(title, value, {String? fontFamily}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "$title",
            style: TextStyle(
              fontSize: 16.0,
              color: AppStyles.TEXT_PRIMARY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "$value",
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 16.0,
              color: AppStyles.TEXT_PRIMARY_COLOR,
            ),
          ),
        ),
        Divider(color: AppStyles.TEXT_PRIMARY_COLOR),
      ],
    );
  }
}
