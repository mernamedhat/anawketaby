/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/enums/church.dart';
import 'package:anawketaby/enums/church_role.dart';
import 'package:anawketaby/enums/competition_creation_feature.dart';
import 'package:anawketaby/enums/gender.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_conditions.dart';
import 'package:anawketaby/providers_models/screens/admin_screens/new_competition_screens/steps/admin_new_competition_conditions_step_provider.dart';
import 'package:anawketaby/ui/widgets/choices_buttons_picker.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminNewCompetitionConditionsStep extends StatelessWidget {
  final Competition competition;
  final AppGroup? group;

  const AdminNewCompetitionConditionsStep({
    Key? key,
    required this.competition,
    this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AdminNewCompetitionConditionsStepProvider(this.competition),
      child: Consumer<AdminNewCompetitionConditionsStepProvider>(
          builder: (_, provider, __) {
        return ListView(
          children: [
            if (provider.competition.competitionConditions?.gender != null) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "تحديد نوع الجنس",
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
                                value: Gender.male,
                                groupValue: provider
                                    .competition.competitionConditions?.gender,
                                onChanged: (dynamic value) =>
                                    provider.changeGender(value),
                                activeColor: AppStyles.SECONDARY_COLOR_DARK,
                              ),
                              Text(
                                "ذكور فقط",
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
                                value: Gender.female,
                                groupValue: provider
                                    .competition.competitionConditions?.gender,
                                onChanged: (dynamic value) =>
                                    provider.changeGender(value),
                                activeColor: AppStyles.SECONDARY_COLOR_DARK,
                              ),
                              Text(
                                "إناث فقط",
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
                    SizedBox(height: scaleHeight(8.0)),
                    ElevatedButton(
                      onPressed: provider.deleteGender,
                      child: Text(
                        "حذف الشرط",
                        style: const TextStyle(
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontSize: 12.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.SECONDARY_COLOR, backgroundColor: AppStyles.SECONDARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(35.0)),    // Text color
                      ),
                    ),

                  ],
                ),
              ),
            ],
            if (provider.competition.competitionConditions?.churches !=
                null) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "تحديد الكنيسة",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: scaleHeight(8.0)),
                    ChoicesButtonsPicker(
                      controller: provider.churchesChoicesButtonsController,
                      values: Church.values,
                      buttonsText: Church.values
                          .map((church) =>
                              CompetitionConditions.getChurchName(church))
                          .toList(),
                      onChoiceClick: provider.onChurchesChoiceChanged,
                      isMultiple: true,
                    ),
                    SizedBox(height: scaleHeight(8.0)),
                    ElevatedButton(
                      onPressed: provider.deleteChurch,
                      child: Text(
                        "حذف الشرط",
                        style: const TextStyle(
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontSize: 12.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.SECONDARY_COLOR, backgroundColor: AppStyles.SECONDARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(35.0)),    // Text color
                      ),
                    ),

                  ],
                ),
              ),
            ],
            if (provider.competition.competitionConditions?.churchRoles !=
                null) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "تحديد الدور في الكنيسة",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: scaleHeight(8.0)),
                    ChoicesButtonsPicker(
                      controller: provider.churchRolesChoicesButtonsController,
                      values: ChurchRole.values,
                      buttonsText: ChurchRole.values
                          .map((churchRoles) =>
                              CompetitionConditions.getChurchRoleName(
                                  churchRoles))
                          .toList(),
                      onChoiceClick: provider.onChurchRolesChoiceChanged,
                      isMultiple: true,
                    ),
                    SizedBox(height: scaleHeight(8.0)),
                    ElevatedButton(
                      onPressed: provider.deleteChurchRole,
                      child: Text(
                        "حذف الشرط",
                        style: const TextStyle(
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontSize: 12.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.SECONDARY_COLOR, backgroundColor: AppStyles.SECONDARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(35.0)),    // Text color
                      ),
                    ),

                  ],
                ),
              ),
            ],
            if (provider.competition.competitionConditions?.ageFrom !=
                null) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "تحديد السن",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: scaleHeight(8.0)),
                    Text(
                      "من سن",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: scaleHeight(4.0)),
                    DropdownButtonFormField(
                      hint: Text("من سن"),
                      value: DateTime.now().year -
                          (provider.competition.competitionConditions?.ageFrom!
                              .toDate()
                              .year as int),
                      isExpanded: true,
                      items: List.generate(76, (index) => index + 5)
                          .map((age) => DropdownMenuItem(
                              value: age,
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text("$age",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black)))))
                          .toList(),
                      onChanged: (dynamic value) =>
                          provider.changeAgeFrom(value),
                      autofocus: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: scaleHeight(8.0)),
                    Text(
                      "حتى سن",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: scaleHeight(4.0)),
                    DropdownButtonFormField(
                      hint: Text("حتى سن"),
                      value: DateTime.now().year -
                          (provider.competition.competitionConditions?.ageTo!
                              .toDate()
                              .year as int),
                      isExpanded: true,
                      items: List.generate(76, (index) => index + 5)
                          .map((age) => DropdownMenuItem(
                              value: age,
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text("$age",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black)))))
                          .toList(),
                      onChanged: (dynamic value) => provider.changeAgeTo(value),
                      autofocus: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: scaleHeight(8.0)),
                    ElevatedButton(
                      onPressed: provider.deleteAge,
                      child: Text(
                        "حذف الشرط",
                        style: const TextStyle(
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontSize: 12.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.SECONDARY_COLOR, backgroundColor: AppStyles.SECONDARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(35.0)),    // Set text color
                      ),
                    ),

                  ],
                ),
              ),
            ],
            if (provider.competition.competitionConditions?.competitionsIDs !=
                null) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "تحديد مسابقات موضوع معين",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: scaleHeight(8.0)),
                    if (provider.loadedTopics == null)
                      Center(child: CircularProgressIndicator())
                    else
                      DropdownButtonFormField(
                        hint: Text("الموضوع"),
                        value: null,
                        isExpanded: true,
                        items: provider.loadedTopics
                            ?.map((topic) => DropdownMenuItem(
                                value: topic,
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text("${topic.name}",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black)))))
                            .toList(),
                        onChanged: (dynamic value) =>
                            provider.changeCompetitionsIDs(value),
                        autofocus: true,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    SizedBox(height: scaleHeight(8.0)),
                    ElevatedButton(
                      onPressed: provider.deleteCompetitionsIDs,
                      child: Text(
                        "حذف الشرط",
                        style: const TextStyle(
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontSize: 12.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.SECONDARY_COLOR, backgroundColor: AppStyles.SECONDARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(35.0)),    // Set text color
                      ),
                    ),

                  ],
                ),
              ),
            ],
            if (provider.competition.competitionConditions?.followersOnly ==
                true) ...[
              SizedBox(height: scaleHeight(16.0)),
              RoundedContainer(
                height: null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "تم تحديد المسابقة للمتابعين فقط",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppStyles.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: scaleHeight(8.0)),
                    ElevatedButton(
                      onPressed: provider.deleteFollowersOnly,
                      child: Text(
                        "حذف الشرط",
                        style: const TextStyle(
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontSize: 12.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.SECONDARY_COLOR, backgroundColor: AppStyles.SECONDARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(35.0)),    // Set text color
                      ),
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
                    "إضافة شرط",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: scaleHeight(5.0)),
                  Text(
                    "اختار نوع الشرط الذي تريد اضافته.",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: scaleHeight(10.0)),
                  Container(
                    color: Color(0x20000000),
                    padding: EdgeInsets.symmetric(horizontal: scaleWidth(2.0)),
                    child: DropdownButtonFormField<String?>(
                      hint: Text("إضافة شرط"),
                      value: null,
                      isExpanded: true,
                      items: _conditionsDropdownItems(provider),
                      onChanged: (dynamic value) {
                        if (value == 'gender') provider.addGenderCondition();
                        if (value == 'church') provider.addChurchCondition();
                        if (value == 'churchRole')
                          provider.addChurchRoleCondition();
                        if (value == 'age') provider.addAgeCondition();
                        if (value == 'competitionsIDs')
                          provider.addCompetitionsIDsCondition();
                        if (value == 'followersOnly')
                          provider.addFollowersOnlyCondition();
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
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

  List<DropdownMenuItem<String>> _conditionsDropdownItems(
      AdminNewCompetitionConditionsStepProvider provider) {
    return [
      if (competition.isFeatureAllowed(
          provider.appUser!, group, CompetitionCreationFeature.conditionGender))
        DropdownMenuItem(
          value: 'gender',
          enabled: (provider.competition.competitionConditions?.gender == null),
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "نوع الجنس",
              style: TextStyle(
                fontSize: 16.0,
                color:
                    (provider.competition.competitionConditions?.gender == null)
                        ? Colors.black
                        : Colors.grey,
              ),
            ),
          ),
        ),
      if (competition.isFeatureAllowed(
          provider.appUser!, group, CompetitionCreationFeature.conditionChurch))
        DropdownMenuItem(
          value: 'church',
          enabled: provider.competition.competitionConditions?.churches == null,
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "الكنيسة",
              style: TextStyle(
                fontSize: 16.0,
                color: (provider.competition.competitionConditions?.churches ==
                        null)
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ),
        ),
      if (competition.isFeatureAllowed(
          provider.appUser!, group, CompetitionCreationFeature.conditionRole))
        DropdownMenuItem(
          value: 'churchRole',
          enabled:
              provider.competition.competitionConditions?.churchRoles == null,
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "الدور في الكنيسة",
              style: TextStyle(
                fontSize: 16.0,
                color:
                    (provider.competition.competitionConditions?.churchRoles ==
                            null)
                        ? Colors.black
                        : Colors.grey,
              ),
            ),
          ),
        ),
      if (competition.isFeatureAllowed(
          provider.appUser!, group, CompetitionCreationFeature.conditionAge))
        DropdownMenuItem(
          value: 'age',
          enabled: provider.competition.competitionConditions?.ageFrom == null,
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "تحديد سن معين",
              style: TextStyle(
                fontSize: 16.0,
                color: (provider.competition.competitionConditions?.ageFrom ==
                        null)
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ),
        ),
      if (competition.isFeatureAllowed(
          provider.appUser!, group, CompetitionCreationFeature.conditionTopic))
        DropdownMenuItem(
          value: 'competitionsIDs',
          enabled:
              provider.competition.competitionConditions?.competitionsIDs ==
                  null,
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "إنهاء مسابقات موضوع معين",
              style: TextStyle(
                fontSize: 16.0,
                color: (provider.competition.competitionConditions
                            ?.competitionsIDs ==
                        null)
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ),
        ),
      if (competition.isFeatureAllowed(
          provider.appUser!, group, CompetitionCreationFeature.conditionFollowing))
        DropdownMenuItem(
          value: 'followersOnly',
          enabled: provider.competition.competitionConditions?.followersOnly ==
              false,
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "تحديدها للمتابعين فقط",
              style: TextStyle(
                fontSize: 16.0,
                color: (provider
                            .competition.competitionConditions?.followersOnly ==
                        false)
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ),
        ),
    ];
  }
}
