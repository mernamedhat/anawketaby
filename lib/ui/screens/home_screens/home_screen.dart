import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/providers_models/screens/home_screens/home_screen_provider.dart';
import 'package:anawketaby/ui/widgets/bottom_nav_bar.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/challenges_group.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeScreenProvider(),
      child: Consumer<HomeScreenProvider>(builder: (_, provider, __) {
        provider.appUser = Provider.of<UserProvider>(context).appUser;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppStyles.PRIMARY_COLOR_DARK,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
          ),
          child: Scaffold(
            key: provider.scaffoldKey,
            drawer: _drawer(provider),
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
                        child: Icon(Icons.menu),
                        onPressed: () =>
                            provider.scaffoldKey.currentState!.openDrawer(),
                      ),
                      /*actions: [
                        TextButton(
                          child: Image.asset("assets/images/icons/search_icon.png"),
                          onPressed: () {},
                        ),
                      ],*/
                    ),
                  ),
                  Expanded(
                    child: (provider.competitionCategoriesSort == null)
                        ? Center(child: EmptyListLoader())
                        : SingleChildScrollView(
                            child: Column(
                              children: provider.competitionCategories.map(
                                (category) {
                                  if (provider.competitionCategoriesSort![
                                          category.key] !=
                                      -1)
                                    return ChallengesGroup(
                                      title: category.title,
                                      stream: category.streamLimited,
                                      moreOnTap: category.moreOnTap,
                                    );
                                  else
                                    return Container();
                                },
                              ).toList(),
                            ),
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

  Widget _drawer(HomeScreenProvider provider) {
    return Drawer(
      child: Container(
        color: AppStyles.PRIMARY_COLOR_DARK,
        child: SafeArea(
          child: ListView(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(Get.context!),
                  icon: Icon(
                    Icons.close,
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                  ),
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Container(
                    color: Colors.white,
                    child: (provider.appUser?.getPhotoURL() != null)
                        ? CachedImage(
                            url: provider.appUser!.getPhotoURL(),
                            fit: BoxFit.cover,
                            height: scaleHeight(100.0),
                            width: scaleWidth(100.0),
                          )
                        : Image.asset(
                            "assets/images/default_profile.png",
                            fit: BoxFit.cover,
                            height: scaleHeight(100.0),
                            width: scaleWidth(100.0),
                          ),
                  ),
                ),
              ),
              ListTile(
                onTap: provider.goToProfile,
                contentPadding: const EdgeInsets.all(20.0),
                title: Text(
                  "الصفحة الشخصية",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Icons.chevron_right,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
              ),
              ListTile(
                onTap: provider.goToMyChallenges,
                contentPadding: const EdgeInsets.all(20.0),
                title: Text(
                  "تحدياتي",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Icons.chevron_right,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
              ),
              ListTile(
                onTap: provider.goToMyGroups,
                contentPadding: const EdgeInsets.all(20.0),
                title: Text(
                  "مجموعاتي",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Icons.chevron_right,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
              ),
              ListTile(
                onTap: provider.goToMyTeams,
                contentPadding: const EdgeInsets.all(20.0),
                title: Text(
                  "فرقي",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Icons.chevron_right,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
              ),
              ListTile(
                onTap: provider.goToTopics,
                contentPadding: const EdgeInsets.all(20.0),
                title: Text(
                  "الموضوعات",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Icons.chevron_right,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
              ),
              if (provider.appUser != null && provider.appUser!.isAdmin!)
                ListTile(
                  onTap: provider.goToAdminPanel,
                  contentPadding: const EdgeInsets.all(20.0),
                  title: Text(
                    "لوحة التحكم",
                    style: TextStyle(
                      color: AppStyles.TEXT_PRIMARY_COLOR,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.chevron_right,
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    size: 36.0,
                  ),
                ),
              ListTile(
                onTap: provider.goToSettings,
                contentPadding: const EdgeInsets.all(20.0),
                title: Text(
                  "إعدادات التطبيق",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Icons.chevron_right,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
              ),
              ListTile(
                onTap: provider.reviewApplication,
                contentPadding: const EdgeInsets.all(20.0),
                title: Text(
                  "قيم التطبيق",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Icons.chevron_right,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(Get.context!);
                  launchUrl(
                    Uri.parse('https://anawketaby.org/support'),
                    mode: LaunchMode.externalApplication,
                  );
                },
                contentPadding: const EdgeInsets.all(20.0),
                title: Text(
                  "الدعم الفني",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Icons.chevron_right,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
              ),
              ListTile(
                onTap: provider.signOut,
                contentPadding: const EdgeInsets.all(20.0),
                title: Text(
                  "تسجيل الخروج",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Icons.chevron_right,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
