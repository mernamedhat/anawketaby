import 'package:anawketaby/enums/church.dart';
import 'package:anawketaby/enums/church_role.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/screens/auth_screens/sign_up_screen_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple_platform_interface/authorization_credential.dart';

class SignUpScreen extends StatelessWidget {
  final bool socialLogging;
  final String? socialEmail;
  final AuthorizationCredentialAppleID? appleCredential;

  const SignUpScreen({
    Key? key,
    this.socialLogging = false,
    this.socialEmail,
    this.appleCredential,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpScreenProvider(
        this.socialLogging,
        this.socialEmail,
        this.appleCredential,
      ),
      child: Consumer<SignUpScreenProvider>(builder: (_, provider, __) {
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
                                Text(
                                  "إنشاء حساب جديد",
                                  style: TextStyle(
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        ResponsiveSize.getWidth(context, 0.1)),
                                if (provider.appleCredential == null ||
                                    provider.appleCredential!.givenName ==
                                        null ||
                                    provider.appleCredential!.familyName ==
                                        null) ...[
                                  RoundedContainer(
                                    height: scaleHeight(50.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextField(
                                      controller: provider.fullNameController,
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'الاسم ثلاثي',
                                        hintStyle: TextStyle(
                                            color: AppStyles.TEXT_THIRD_COLOR),
                                        icon: Icon(Icons.person),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: ResponsiveSize.getWidth(
                                          context, 0.08)),
                                ],
                                RoundedContainer(
                                  height: scaleHeight(50.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: provider.phoneController,
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.start,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          style: TextStyle(
                                            fontFamily: AppStyles.TAJAWAL,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'رقم التليفون',
                                            hintTextDirection:
                                                TextDirection.rtl,
                                            hintStyle: TextStyle(
                                                color:
                                                    AppStyles.TEXT_THIRD_COLOR),
                                            icon: Icon(Icons.phone_android),
                                          ),
                                        ),
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: CountryCodePicker(
                                          onChanged: (CountryCode countryCode) {
                                            provider.countryCode =
                                                countryCode.dialCode;
                                          },
                                          padding: EdgeInsets.zero,
                                          initialSelection: 'EG',
                                          favorite: ['EG'],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        ResponsiveSize.getWidth(context, 0.08)),
                                RoundedContainer(
                                  height: scaleHeight(50.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.home,
                                          color: AppStyles.TEXT_THIRD_COLOR),
                                      SizedBox(width: scaleWidth(20.0)),
                                      Expanded(
                                        child: DropdownButtonFormField(
                                          hint: Text("الكنيسة"),
                                          value: provider.selectedChurch,
                                          isExpanded: true,
                                          items: Church.values
                                              .map((church) => DropdownMenuItem(
                                                  value: church,
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                          "${AppUser.getChurchName(church)}",
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              color: Colors
                                                                  .black)))))
                                              .toList(),
                                          onChanged: (dynamic value) =>
                                              provider.selectedChurch = value,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        ResponsiveSize.getWidth(context, 0.08)),
                                if (provider.isRequiredFields) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "النوع",
                                          style: TextStyle(
                                            color: AppStyles.TEXT_PRIMARY_COLOR,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Radio(
                                              value: true,
                                              groupValue: provider.isMale,
                                              onChanged: (dynamic value) =>
                                                  provider.isMale = value,
                                              activeColor:
                                                  AppStyles.TEXT_PRIMARY_COLOR,
                                            ),
                                            Text(
                                              "ذكر",
                                              style: TextStyle(
                                                color: AppStyles
                                                    .TEXT_PRIMARY_COLOR,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Radio(
                                              value: false,
                                              groupValue: provider.isMale,
                                              onChanged: (dynamic value) =>
                                                  provider.isMale = value,
                                              activeColor:
                                                  AppStyles.TEXT_PRIMARY_COLOR,
                                            ),
                                            Text(
                                              "انثى",
                                              style: TextStyle(
                                                color: AppStyles
                                                    .TEXT_PRIMARY_COLOR,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height: ResponsiveSize.getWidth(
                                          context, 0.08)),
                                ],
                                if (provider.isRequiredFields) ...[
                                  RoundedContainer(
                                    height: scaleHeight(50.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: InkWell(
                                      onTap: provider.chooseBirthdate,
                                      child: TextField(
                                        controller:
                                            provider.birthDateController,
                                        keyboardType: TextInputType.number,
                                        enabled: false,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'تاريخ الميلاد',
                                          hintStyle: TextStyle(
                                              color:
                                                  AppStyles.TEXT_THIRD_COLOR),
                                          icon: Icon(Icons.calendar_today),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: ResponsiveSize.getWidth(
                                          context, 0.08)),
                                ],
                                RoundedContainer(
                                  height: scaleHeight(50.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.volunteer_activism,
                                          color: AppStyles.TEXT_THIRD_COLOR),
                                      SizedBox(width: scaleWidth(20.0)),
                                      Expanded(
                                        child: DropdownButtonFormField(
                                          hint: Text("دورك في الكنيسة"),
                                          value: provider.selectedChurchRole,
                                          isExpanded: true,
                                          items: ChurchRole.values
                                              .map((churchRole) => DropdownMenuItem(
                                                  value: churchRole,
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                          "${AppUser.getChurchRoleName(churchRole)}",
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              color: Colors
                                                                  .black)))))
                                              .toList(),
                                          onChanged: (dynamic value) => provider
                                              .selectedChurchRole = value,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!socialLogging) ...[
                                  SizedBox(
                                      height: ResponsiveSize.getWidth(
                                          context, 0.08)),
                                  RoundedContainer(
                                    height: scaleHeight(50.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextField(
                                      controller: provider.emailController,
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.left,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                        fontFamily: AppStyles.TAJAWAL,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'اكتب هنا بريدك الالكتروني',
                                        hintStyle: TextStyle(
                                            color: AppStyles.TEXT_THIRD_COLOR),
                                        icon: Icon(Icons.mail),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: ResponsiveSize.getWidth(
                                          context, 0.08)),
                                  RoundedContainer(
                                    height: scaleHeight(50.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextField(
                                      obscureText: true,
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.left,
                                      controller: provider.passwordController,
                                      style: TextStyle(
                                        fontFamily: AppStyles.TAJAWAL,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '*********',
                                        hintStyle: TextStyle(
                                            color: AppStyles.TEXT_THIRD_COLOR),
                                        icon: Icon(Icons.security),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.getWidth(context, 0.05)),
                  ElevatedButton(
                    onPressed: provider.signUp,
                    child: Text(
                      "تسجيل",
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
        );
      }),
    );
  }
}
