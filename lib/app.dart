import 'dart:math';

import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/app_language_provider.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/auth_screens/confirmation_screen.dart';
import 'package:anawketaby/ui/screens/auth_screens/intro_screen.dart';
import 'package:anawketaby/ui/screens/home_screens/home_screen.dart';
import 'package:anawketaby/ui/screens/splash_screens/splash_screen.dart';
import 'package:anawketaby/utils/app_localizations.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/check_internet_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  // final FirebaseAnalytics _analytics = FirebaseAnalytics();

  MyApp() {
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLanguageProvider>(
            create: (_) => AppLanguageProvider(), lazy: false),
        ChangeNotifierProvider<SettingsProvider>(
            create: (_) => SettingsProvider(), lazy: false),
        ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(), lazy: false),
      ],
      builder: (ctx, child) {
        // final appLanguageProvider = ctx.watch<AppLanguageProvider>();
        final settingsProvider = ctx.watch<SettingsProvider>();
        final textScaleFactor = settingsProvider.appSettings.textScaleFactor;

        final userProvider = Provider.of<UserProvider>(ctx);
        AppUser? appUser = userProvider.appUser;

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale('ar'),
          supportedLocales: [
            // Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
            GlobalWidgetsLocalizations.delegate,
          ],
          /*navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: _analytics),
        ],*/
          title: 'أنا وكتابي',
          theme: ThemeData(
            fontFamily: AppStyles.GE_SS_UNIQUE,
            primaryColor: AppStyles.PRIMARY_COLOR_DARK,
            appBarTheme: AppBarTheme(
              color: Color(0xFF151026),
            ),
            primarySwatch: AppStyles.APP_MATERIAL_COLOR,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.white,
            unselectedWidgetColor: Colors.white,
          ),
          builder: (_, child) {
            return Builder(builder: (context) {
              final MediaQueryData mediaQuery = MediaQuery.of(context);

              return MediaQuery(
                data: mediaQuery.copyWith(
                  textScaleFactor:
                      min(mediaQuery.size.width / 360.0 * textScaleFactor, 1.0),
                ),
                child: child!,
              );
            });
          },
          home: (settingsProvider.isInit)
              ? (appUser == null ||
                      (appUser.firebaseUser?.phoneNumber == null ||
                          appUser.firebaseUser?.phoneNumber == ""))
                  ? (appUser == null)
                      ? IntroScreen()
                      : ConfirmationScreen()
                  : HomeScreen()
              : SplashScreen(),
        );
      },
    );
  }
}
