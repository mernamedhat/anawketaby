import 'package:anawketaby/providers_models/screens/auth_screens/confirmation_screen_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfirmationScreenProvider(),
      child: Consumer<ConfirmationScreenProvider>(builder: (_, provider, __) {
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
              color: AppStyles.PRIMARY_COLOR,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                    height:
                                        ResponsiveSize.getWidth(context, 0.15)),
                                Text(
                                  "تأكيد رقم الهاتف",
                                  style: TextStyle(
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: scaleHeight(20.0)),
                                Text(
                                  "رقم الهاتف الخاص بك هو",
                                  style: TextStyle(
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: scaleHeight(12.0)),
                                Text(
                                  "${provider.appUser!.phone}",
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        ResponsiveSize.getWidth(context, 0.15)),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: PinCodeTextField(
                                    appContext: context,
                                    controller: provider.codeController,
                                    //errorAnimationController: errorController,
                                    length: 6,
                                    obscureText: false,
                                    animationType: AnimationType.fade,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    backgroundColor: Colors.transparent,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 50,
                                      activeColor: Colors.white,
                                      activeFillColor: Colors.white,
                                      inactiveColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      selectedColor: AppStyles.THIRD_COLOR,
                                      selectedFillColor: Colors.white,
                                    ),
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    enableActiveFill: true,
                                    textStyle: const TextStyle(
                                      color: AppStyles.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22.0,
                                    ),
                                    onChanged: (value) {
                                    },
                                    beforeTextPaste: (text) => true,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        ResponsiveSize.getWidth(context, 0.1)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "لم يصل رمز التحقق بعد ؟",
                                      style: const TextStyle(
                                        color: AppStyles.TEXT_PRIMARY_COLOR,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    SizedBox(width: scaleWidth(5.0)),
                                    if (provider.appUser?.lastTryTime != null)
                                      CountdownTimer(
                                        endTime: provider.appUser!.lastTryTime
                                            ?.toDate()
                                            .add(Duration(
                                                minutes: 1, seconds: 30))
                                            .millisecondsSinceEpoch,
                                        widgetBuilder: (ctx, remainTime) {
                                          if (remainTime == null)
                                            return Text("");
                                          return Text(
                                            "متبقي ${remainTime.min ?? 0}:${(remainTime.sec! > 9) ? remainTime.sec : "0${remainTime.sec}"}",
                                            style: TextStyle(
                                                color: AppStyles
                                                    .TEXT_PRIMARY_COLOR),
                                          );
                                        },
                                        onEnd: provider.refreshScreen,
                                      ),
                                  ],
                                ),
                                if (provider.appUser?.lastTryTime == null || (provider.appUser?.lastTryTime != null &&
                                    RealTime.instance.now!.isAfter(provider
                                        .appUser!.lastTryTime!
                                        .toDate()
                                        .add(
                                            Duration(minutes: 1, seconds: 30)))))
                                  Center(
                                    child: TextButton(
                                      onPressed: provider.resendCode,
                                      child: Text(
                                        "إعادة الارسال",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: AppStyles.TEXT_PRIMARY_COLOR,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.getWidth(context, 0.05)),
                  ElevatedButton(
                    onPressed: provider.confirmCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                      minimumSize: Size(310.0, scaleHeight(55.0)), // Width and height
                    ),
                    child: Text(
                      "تأكيد",
                      style: const TextStyle(
                        color: AppStyles.TEXT_PRIMARY_COLOR,
                        fontSize: 18.0,
                      ),
                    ),
                  ),


                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: provider.signOut,
                      child: Text(
                        "تسجيل الخروج",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
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
