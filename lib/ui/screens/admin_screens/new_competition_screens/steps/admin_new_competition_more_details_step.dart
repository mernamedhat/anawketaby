/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:io';

import 'package:anawketaby/enums/competition_creation_feature.dart';
import 'package:anawketaby/enums/competition_level.dart';
import 'package:anawketaby/enums/competition_type.dart';
import 'package:anawketaby/enums/competition_winner.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/screens/admin_screens/new_competition_screens/steps/admin_new_competition_more_details_step_provider.dart';
import 'package:anawketaby/ui/widgets/choices_buttons_picker.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/number_counter_buttons.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/ui/widgets/rounded_text_field.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminNewCompetitionMoreDetailsStep extends StatelessWidget {
  final Competition competition;
  final AppGroup? group;

  const AdminNewCompetitionMoreDetailsStep({
    Key? key,
    required this.competition,
    this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AdminNewCompetitionMoreDetailsStepProvider(this.competition),
      child: Consumer<AdminNewCompetitionMoreDetailsStepProvider>(
          builder: (_, provider, __) {
        return ListView(
          children: [
            SizedBox(height: scaleHeight(16.0)),
            RoundedContainer(
              height: scaleHeight(50.0),
              padding: EdgeInsets.symmetric(horizontal: scaleWidth(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "نقاط الاشتراك",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  NumberCounterButtons(
                    controller: provider.participationPoints,
                    width: scaleWidth(150.0),
                    minNumber: (competition.isFeatureAllowed(provider.appUser!,
                            group, CompetitionCreationFeature.pointsFree))
                        ? 0
                        : 1,
                    maxNumber: 1000,
                    zeroText: "مجاناً",
                    onChanged: provider.onNumberChanged,
                  ),
                ],
              ),
            ),
            if (competition.isFeatureAllowed(provider.appUser!, group,
                    CompetitionCreationFeature.typeIndividuals) &&
                competition.isFeatureAllowed(provider.appUser!, group,
                    CompetitionCreationFeature.typeTeams)) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: scaleHeight(100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "نوع المسابقة",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    ChoicesButtonsPicker(
                      controller:
                          provider.competitionTypeChoicesButtonsController,
                      values: CompetitionType.values,
                      buttonsText: ["فردي", "فرق"],
                      onChoiceClick: provider.onChoiceChanged,
                    ),
                  ],
                ),
              ),
            ],
            if (provider.competitionTypeChoicesButtonsController.value ==
                CompetitionType.teams) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: scaleHeight(50.0),
                padding: EdgeInsets.symmetric(horizontal: scaleWidth(8.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "عدد اعضاء الفريق",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    NumberCounterButtons(
                      controller: provider.teamCount,
                      width: scaleWidth(150.0),
                      minNumber: 2,
                      maxNumber: 10,
                      onChanged: provider.onNumberChanged,
                    ),
                  ],
                ),
              ),
            ],
            if (competition.isFeatureAllowed(provider.appUser!, group,
                CompetitionCreationFeature.level)) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: scaleHeight(100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "مستوى المسابقة",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    ChoicesButtonsPicker(
                      controller:
                          provider.competitionLevelChoicesButtonsController,
                      values: CompetitionLevel.values,
                      buttonsText: ["سهله", "متوسطة", "صعبة", "غير محدد"],
                      onChoiceClick: provider.onChoiceChanged,
                    ),
                  ],
                ),
              ),
            ],
            if (competition.isFeatureAllowed(provider.appUser!, group,
                CompetitionCreationFeature.randomQuestions)) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "ترتيب الاسئلة عشوائي",
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
                        unselectedWidgetColor: AppStyles.SECONDARY_COLOR_DARK,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: true,
                                groupValue: provider.shuffleQuestions,
                                onChanged: (dynamic value) =>
                                    provider.shuffleQuestions = value,
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
                                groupValue: provider.shuffleQuestions,
                                onChanged: (dynamic value) =>
                                    provider.shuffleQuestions = value,
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
            ],
            if (competition.isFeatureAllowed(provider.appUser!, group,
                CompetitionCreationFeature.timeConsideration)) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "اعتبار الوقت المتبقي من ضمن النتيجة",
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
                        unselectedWidgetColor: AppStyles.SECONDARY_COLOR_DARK,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: true,
                                groupValue: provider.remainingTimeConsider,
                                onChanged: (dynamic value) =>
                                    provider.remainingTimeConsider = value,
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
                                groupValue: provider.remainingTimeConsider,
                                onChanged: (dynamic value) =>
                                    provider.remainingTimeConsider = value,
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
            ],
            if (competition.isFeatureAllowed(provider.appUser!, group,
                CompetitionCreationFeature.winner)) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: scaleHeight(100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "فائز المسابقة",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    ChoicesButtonsPicker(
                      controller:
                          provider.competitionWinnerChoicesButtonsController,
                      values: CompetitionWinner.values,
                      buttonsText: ["واحد فقط", "ثلاثة فائزين"],
                      onChoiceClick: provider.onChoiceChanged,
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: scaleHeight(16.0)),
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "ميعاد بداية ونهاية المسابقة",
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
                    onTap: provider.showStartDateTimePicker,
                    child: RoundedTextField(
                      height: null,
                      width: scaleWidth(100.0),
                      padding: EdgeInsets.only(
                          left: scaleWidth(8.0), right: scaleWidth(8.0)),
                      textField: TextField(
                        controller: provider.startDateTimeController,
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "اضغط هنا لاختيار بداية المسابقة",
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
                  SizedBox(height: scaleHeight(10.0)),
                  InkWell(
                    onTap: provider.showEndDateTimePicker,
                    child: RoundedTextField(
                      height: null,
                      width: scaleWidth(100.0),
                      padding: EdgeInsets.only(
                          left: scaleWidth(8.0), right: scaleWidth(8.0)),
                      textField: TextField(
                        controller: provider.endDateTimeController,
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "اضغط هنا لاختيار نهاية المسابقة",
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
            if (competition.isFeatureAllowed(provider.appUser!, group,
                CompetitionCreationFeature.passwordLock)) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "مغلقة بكلمة مرور",
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
                        unselectedWidgetColor: AppStyles.SECONDARY_COLOR_DARK,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: true,
                                groupValue: provider.closed,
                                onChanged: (dynamic value) =>
                                    provider.closed = value,
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
                                groupValue: provider.closed,
                                onChanged: (dynamic value) =>
                                    provider.closed = value,
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
            ],
            SizedBox(height: scaleHeight(16.0)),
            if (provider.closed != null && provider.closed!)
              Column(
                children: [
                  RoundedContainer(
                    height: null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "كلمة المرور",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: AppStyles.PRIMARY_COLOR,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: scaleHeight(10.0)),
                        RoundedTextField(
                          height: null,
                          width: scaleWidth(100.0),
                          padding: EdgeInsets.only(
                              left: scaleWidth(8.0), right: scaleWidth(8.0)),
                          textField: TextField(
                            controller: provider.closedPasswordController,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "اكتب كلمة المرور هنا",
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
                            onChanged: provider.textChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: scaleHeight(16.0)),
                ],
              ),
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "صورة المسابقة",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: scaleHeight(8.0)),
                  if (provider.competition.tempPickedImage == null)
            ElevatedButton(
            onPressed: provider.pickFromGallery,
            child: Text(
            "اختيار صورة",
            style: const TextStyle(
            color: AppStyles.TEXT_PRIMARY_COLOR,
            fontSize: 18.0,
            ),
            ),
            style: ElevatedButton.styleFrom(
            foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(55.0)),    // Set text color
            ),
            )

            else
                    Column(
                      children: [
                        Container(
                            constraints:
                                BoxConstraints(minHeight: 10.0, minWidth: 10.0),
                            child: Image.file(File(
                                provider.competition.tempPickedImage!.path!))),
                        SizedBox(
                          height: scaleHeight(10.0),
                        ),
                        ElevatedButton(
                          onPressed: provider.pickFromGallery,
                          child: Text(
                            "تغيير الصورة",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 20.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(scaleWidth(180.0), scaleHeight(60.0)),    // Set text color
                          ),
                        ),

                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: scaleHeight(16.0)),
          ],
        );
      }),
    );
  }
}
