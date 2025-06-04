import 'dart:io';

import 'package:anawketaby/enums/church.dart';
import 'package:anawketaby/enums/church_role.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/providers_models/screens/account_screens/edit_account_screen_provider.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditAccountScreenProvider(),
      child: Consumer<EditAccountScreenProvider>(builder: (_, provider, __) {
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
                        "تعديل الملف الشخصي",
                        style: TextStyle(
                          fontSize: 18.0,
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
                            "حفظ",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                            ),
                          ),
                          onPressed: provider.saveEdits,
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
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: (provider.appUser!.getPhotoURL() !=
                                                  null &&
                                              provider.appUser!
                                                      .tempPickedImage ==
                                                  null)
                                          ? CachedImage(
                                              url: provider.appUser!
                                                  .getPhotoURL(),
                                              fit: BoxFit.cover,
                                              height: scaleHeight(100.0),
                                              width: scaleWidth(100.0),
                                            )
                                          : (provider.appUser!.tempPickedImage !=
                                                  null)
                                              ? Image.file(
                                                  File(provider.appUser!
                                                      .tempPickedImage!.path!),
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
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.white),
                                      onPressed: provider.changePhoto,
                                      // padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
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
                                if (provider.appUser!.gender == null) ...[
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
                                RoundedContainer(
                                  height: scaleHeight(50.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: InkWell(
                                    onTap: provider.chooseBirthdate,
                                    child: TextField(
                                      controller: provider.birthDateController,
                                      keyboardType: TextInputType.number,
                                      enabled: false,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'تاريخ الميلاد',
                                        hintStyle: TextStyle(
                                            color: AppStyles.TEXT_THIRD_COLOR),
                                        icon: Icon(Icons.calendar_today),
                                      ),
                                    ),
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
                                SizedBox(
                                    height:
                                    ResponsiveSize.getWidth(context, 0.08)),
                                SizedBox(
                                    height:
                                    ResponsiveSize.getWidth(context, 0.2)),
                                ElevatedButton(
                                  onPressed: provider.deleteMyAccount,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyles.SECONDARY_COLOR_DARK, // Background color
                                    minimumSize: Size(double.infinity, scaleHeight(58.0)), // Width and height
                                  ),
                                  child: Text(
                                    "حذف الحساب",
                                    style: const TextStyle(
                                      color: AppStyles.TEXT_PRIMARY_COLOR,
                                      fontSize: 18.0,
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
}
