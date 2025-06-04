/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/screens/admin_screens/new_competition_screens/steps/admin_new_competition_share_step_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/ui/widgets/rounded_text_field.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminNewCompetitionShareStep extends StatelessWidget {
  final Competition competition;
  final AppGroup? group;
  final bool shareOnly;

  const AdminNewCompetitionShareStep({
    Key? key,
    required this.competition,
    this.group,
    this.shareOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminNewCompetitionShareStepProvider(this.competition),
      child: Consumer<AdminNewCompetitionShareStepProvider>(
          builder: (_, provider, __) {
        return ListView(
          children: [
            if (!this.shareOnly)
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(scaleHeight(16.0)),
                    decoration: BoxDecoration(
                        color: AppStyles.THIRD_COLOR, shape: BoxShape.circle),
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: scaleHeight(40.0),
                    ),
                  ),
                  SizedBox(height: scaleHeight(16.0)),
                  Text(
                    (provider.isNewCompetition)
                        ? "تم إنشاء المسابقة"
                        : "تم تعديل المسابقة",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppStyles.THIRD_COLOR_DARK,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(height: scaleHeight(16.0)),
                  Divider(thickness: 2.0),
                ],
              ),
            SizedBox(height: scaleHeight(16.0)),
            if (provider.isCompetitionCreator &&
                provider.competition.competitionCode != null)
              Column(
                children: [
                  if (provider.isEditAvailable)
                    Column(
                      children: [
                        RoundedContainer(
                          height: null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "إظهارها قبل ميعاد بدءها ؟",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: scaleHeight(8.0)),
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      AppStyles.SECONDARY_COLOR_DARK,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: true,
                                          groupValue:
                                              provider.isPublishBeforeStartTime,
                                          onChanged: (dynamic value) => provider
                                              .isPublishBeforeStartTime = value,
                                          activeColor:
                                              AppStyles.SECONDARY_COLOR_DARK,
                                        ),
                                        Text(
                                          "نعم",
                                          style: TextStyle(
                                            color:
                                                AppStyles.SECONDARY_COLOR_DARK,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: false,
                                          groupValue:
                                              provider.isPublishBeforeStartTime,
                                          onChanged: (dynamic value) => provider
                                              .isPublishBeforeStartTime = value,
                                          activeColor:
                                              AppStyles.SECONDARY_COLOR_DARK,
                                        ),
                                        Text(
                                          "لا",
                                          style: TextStyle(
                                            color:
                                                AppStyles.SECONDARY_COLOR_DARK,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: scaleHeight(16.0)),
                        if (provider.isPublishBeforeStartTime!)
                          Column(
                            children: [
                              RoundedContainer(
                                height: null,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "ميعاد نشر المسابقة المسابقة",
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: AppStyles.PRIMARY_COLOR,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    SizedBox(height: scaleHeight(10.0)),
                                    InkWell(
                                      onTap: provider.showPublishDateTimePicker,
                                      child: RoundedTextField(
                                        height: null,
                                        width: scaleWidth(100.0),
                                        padding: EdgeInsets.only(
                                            left: scaleWidth(8.0),
                                            right: scaleWidth(8.0)),
                                        textField: TextField(
                                          controller: provider
                                              .publishDateTimeController,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          enabled: false,
                                          decoration: InputDecoration(
                                            hintText:
                                                "اضغط هنا لاختيار ميعاد النشر",
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              color: AppStyles
                                                  .TEXT_FIELD_HINT_COLOR,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: AppStyles.SECONDARY_COLOR,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: scaleHeight(16.0)),
                            ],
                          ),
                      ],
                    ),
                  if (this.competition.timeResultPublished == null) ...[
                    RoundedContainer(
                      height: null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "ميعاد حساب نتيجة المسابقة",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: AppStyles.PRIMARY_COLOR,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: scaleHeight(10.0)),
                          InkWell(
                            onTap: provider.showCalculateDateTimePicker,
                            child: RoundedTextField(
                              height: null,
                              width: scaleWidth(100.0),
                              padding: EdgeInsets.only(
                                  left: scaleWidth(8.0),
                                  right: scaleWidth(8.0)),
                              textField: TextField(
                                controller:
                                    provider.calculateDateTimeController,
                                textAlignVertical: TextAlignVertical.center,
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText:
                                      "اضغط هنا لاختيار وقت حساب المسابقة",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: AppStyles.TEXT_FIELD_HINT_COLOR,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                                style: TextStyle(
                                  color: AppStyles.SECONDARY_COLOR,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: scaleHeight(16.0)),
                  ],
                  RoundedContainer(
                    height: null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "إضافتها في اختبر نفسك بعد إنهاءها ؟",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: AppStyles.PRIMARY_COLOR,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: scaleHeight(8.0)),
                        Theme(
                          data: ThemeData(
                            unselectedWidgetColor:
                                AppStyles.SECONDARY_COLOR_DARK,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: true,
                                    groupValue: provider.isTestYourself,
                                    onChanged: (dynamic value) =>
                                        provider.isTestYourself = value,
                                    activeColor: AppStyles.SECONDARY_COLOR_DARK,
                                  ),
                                  Text(
                                    "نعم",
                                    style: TextStyle(
                                      color: AppStyles.SECONDARY_COLOR_DARK,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: false,
                                    groupValue: provider.isTestYourself,
                                    onChanged: (dynamic value) =>
                                        provider.isTestYourself = value,
                                    activeColor: AppStyles.SECONDARY_COLOR_DARK,
                                  ),
                                  Text(
                                    "لا",
                                    style: TextStyle(
                                      color: AppStyles.SECONDARY_COLOR_DARK,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: scaleHeight(16.0)),
                  Divider(thickness: 2.0),
                ],
              ),
            SizedBox(height: scaleHeight(16.0)),
            Column(
              children: [
                Text(
                  "مشاركة المسابقة",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppStyles.PRIMARY_COLOR,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: scaleHeight(16.0)),
                (provider.competition.competitionCode == null)
                    ? Center(child: CircularProgressIndicator())
                    :
                Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "كود المسابقة",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontSize: 16.0,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: scaleWidth(8.0)),
                                  child: Text(
                                    "${provider.competition.competitionCode}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppStyles.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                      fontFamily: AppStyles.RAKKAS,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.copy),
                                onPressed: () => provider.copy(
                                    "${provider.competition.competitionCode}"),
                              ),
                            ],
                          ),
                          SizedBox(height: scaleHeight(16.0)),
                          if (provider.competition.closed!)
                            Row(
                              children: [
                                Text(
                                  "كلمة المرور",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppStyles.PRIMARY_COLOR,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: scaleWidth(8.0)),
                                    child: Text(
                                      "${provider.competition.closedPassword}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppStyles.PRIMARY_COLOR,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                        fontFamily: AppStyles.RAKKAS,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () => provider.copy(
                                      "${provider.competition.closedPassword}"),
                                ),
                              ],
                            ),
                          if (provider.competition.closed!)
                            SizedBox(height: scaleHeight(16.0)),
                          Row(
                            children: [
                              Text(
                                "لينك المسابقة",

                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontSize: 16.0,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: scaleWidth(8.0)),
                                  child: Text(
                                    "${provider.competition.url}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppStyles.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                      fontFamily: AppStyles.RAKKAS,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.copy),
                                onPressed: () => provider
                                    .copy("${provider.competition.url}"),
                              ),
                            ],
                          ),
                          SizedBox(height: scaleHeight(16.0)),
                          ElevatedButton(
                            onPressed: provider.shareCompetition,
                            child: Text(
                              "مشاركة المسابقة",
                              style: const TextStyle(
                                color: AppStyles.TEXT_PRIMARY_COLOR,
                                fontSize: 20.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(60.0)),    // Set text color
                            ),
                          ),

                        ],
                      ),
              ],
            ),
            SizedBox(height: scaleHeight(16.0)),
          ],
        );
      }),
    );
  }
}
