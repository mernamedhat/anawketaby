import 'package:anawketaby/providers_models/screens/auth_screens/forgot_password_screen_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordScreenProvider(),
      child: Consumer<ForgotPasswordScreenProvider>(builder: (_, provider, __) {
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
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        ResponsiveSize.getWidth(context, 0.15)),
                                Text(
                                  "البريد الالكتروني",
                                  style: TextStyle(
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        ResponsiveSize.getWidth(context, 0.05)),
                                RoundedContainer(
                                  height: scaleHeight(50.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextField(
                                    controller: provider.emailController,
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'اكتب هنا بريدك الالكتروني',
                                      hintStyle: TextStyle(
                                          color: AppStyles.TEXT_THIRD_COLOR),
                                      icon: Icon(Icons.mail),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: provider.forgotPassword,
                          child: Text(
                            "استرجاع كلمة السر",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.THIRD_COLOR, backgroundColor: AppStyles.THIRD_COLOR_DARK, minimumSize: Size(310.0, scaleHeight(55.0)),
                          ),
                        ),

                      ],
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
