import 'dart:io';

import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/screens/auth_screens/intro_screen_provider.dart';
import 'package:anawketaby/ui/widgets/auth_button.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IntroScreenProvider(),
      child: Consumer<IntroScreenProvider>(builder: (_, provider, __) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: AppStyles.APP_MATERIAL_COLOR.shade900,
          ),
          child: Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              "assets/images/logo.png",
                              width: scaleWidth(200.0),
                              height: scaleHeight(200.0),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          "تسجيل الدخول",
                          style: TextStyle(
                            fontSize: 24.0,
                            color: AppStyles.PRIMARY_COLOR,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: AppStyles.PRIMARY_COLOR,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppStyles.PRIMARY_COLOR.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              height: ResponsiveSize.getWidth(context, 0.05)),
                          ElevatedButton(
                            onPressed: provider.loginWithEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                              minimumSize: Size(310.0, scaleHeight(55.0)), // Width and height
                              padding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding if needed
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "الدخول بالبريد الالكتروني",
                                  style: const TextStyle(
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 8.0), // Add space between text and icon
                                Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                              height: ResponsiveSize.getWidth(context, 0.08)),
                          if (Platform.isAndroid ||
                              (Platform.isIOS &&
                                  Provider.of<SettingsProvider>(context,
                                          listen: false)
                                      .iOSSocialLoginsEnabled!))
                            Text(
                              "أو",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppStyles.TEXT_PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          SizedBox(
                              height: ResponsiveSize.getWidth(context, 0.08)),
                          if (Platform.isAndroid)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AuthButton(
                                  onPressed: provider.loginWithGoogle,
                                  text: "حساب جوجل",
                                  height: scaleHeight(110.0),
                                  minWidth: 140.0,
                                  color: Colors.white,
                                  style: const TextStyle(
                                    color: AppStyles.TEXT_SECONDARY_COLOR,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  backgroundColor: Color(0xFFF00000),
                                  trailingWidget: Image.asset(
                                    "assets/images/icons/google.png",
                                    height: scaleHeight(35.0),
                                    width: scaleWidth(35.0),
                                  ),
                                ),
                                AuthButton(
                                  onPressed: provider.loginWithFacebook,
                                  text: "حساب فيسبوك",
                                  height: scaleHeight(110.0),
                                  minWidth: 140.0,
                                  color: Colors.white,
                                  style: const TextStyle(
                                    color: AppStyles.TEXT_SECONDARY_COLOR,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  backgroundColor: Color(0xFF3063C9),
                                  trailingWidget: Image.asset(
                                    "assets/images/icons/facebook.png",
                                    height: scaleHeight(35.0),
                                    width: scaleWidth(35.0),
                                  ),
                                ),
                              ],
                            ),
                          if (Platform.isIOS &&
                              Provider.of<SettingsProvider>(context,
                                      listen: false)
                                  .iOSSocialLoginsEnabled!)
                            Column(
                              children: [
                                SignInButton(
                                  Buttons.Facebook,
                                  onPressed: provider.loginWithFacebook,
                                ),
                                SignInButton(
                                  Buttons.Google,
                                  onPressed: provider.loginWithGoogle,
                                ),
                                SignInButton(
                                  Buttons.Apple,
                                  onPressed: provider.loginWithApple,
                                ),
                              ],
                            ),
                          SizedBox(
                              height: ResponsiveSize.getWidth(context, 0.08)),
                          Text(
                            "مستخدم جديد",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: ResponsiveSize.getWidth(context, 0.08)),
                          ElevatedButton(
                            onPressed: provider.createAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                              minimumSize: Size(310.0, scaleHeight(55.0)), // Width and height
                              padding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding if needed
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "إنشاء حساب",
                                  style: const TextStyle(
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 8.0), // Add space between text and icon
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                              height: ResponsiveSize.getWidth(context, 0.08)),
                          InkWell(
                            onTap: () {
                              launchUrl(
                                Uri.parse(
                                    'https://anawketaby.org/support'),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text(
                              "تواجه مشكلة في التسجيل؟",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppStyles.TEXT_PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
