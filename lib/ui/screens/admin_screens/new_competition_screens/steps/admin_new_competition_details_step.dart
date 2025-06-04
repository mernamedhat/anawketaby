/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/enums/competition_creation_feature.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/screens/admin_screens/new_competition_screens/steps/admin_new_competition_details_step_provider.dart';
import 'package:anawketaby/ui/widgets/number_counter_buttons.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/ui/widgets/rounded_text_field.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/bible_util.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminNewCompetitionDetailsStep extends StatelessWidget {
  final Competition competition;
  final AppGroup? group;

  const AdminNewCompetitionDetailsStep({
    Key? key,
    required this.competition,
    this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminNewCompetitionDetailsStepProvider(this.competition),
      child: Consumer<AdminNewCompetitionDetailsStepProvider>(
          builder: (_, provider, __) {
        return ListView(
          children: [
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "اسم المسابقة",
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
                      controller: provider.nameController,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 60,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "اكتب اسم المسابقة هنا",
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
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "وصف المسابقة",
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
                      controller: provider.descriptionController,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 250,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "اكتب وصف المسابقة هنا",
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
                        fontSize: 18.0,
                      ),
                      onChanged: provider.textChanged,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: scaleHeight(16.0)),
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "القراءات",
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
                    "عدم إضافة قراءات ستصبح مسابقة عامة في كل الكتاب المقدس.",
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
                    padding: (provider.reads.isEmpty)
                        ? const EdgeInsets.all(0.0)
                        : const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: provider.reads
                          .map<Widget>(
                            (read) => Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${BibleUtil.readFromKey(read)}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => provider.removeRead(read)),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: scaleWidth(2.0)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Color(0x20000000),
                            child: DropdownButtonFormField(
                              hint: Text("السفر"),
                              value: provider.tempSelectedBibleBook,
                              isExpanded: true,
                              items: provider.bibleBooks
                                  .map((book) => DropdownMenuItem(
                                      value: book,
                                      child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text("${book.name}",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black)))))
                                  .toList(),
                              onChanged: (dynamic value) =>
                                  provider.tempSelectedBibleBook = value,
                              autofocus: true,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                disabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Color(0x20000000),
                            child: DropdownButtonFormField(
                              hint: Text("الأصحاح"),
                              value: provider.tempSelectedBibleBookChapter,
                              isExpanded: true,
                              items: provider.bookChapters
                                  .map((chapter) => DropdownMenuItem(
                                      value: chapter,
                                      child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              "${(chapter == null) ? "كل السفر" : chapter}",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black)))))
                                  .toList(),
                              onChanged: (dynamic value) {
                                provider.tempSelectedBibleBookChapter = value;
                                provider.addRead();
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                disabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: scaleHeight(16.0)),
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "وضع مدة عامة للمسابقة",
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
                              groupValue: provider.durationPerCompetition,
                              onChanged: (dynamic value) =>
                                  provider.durationPerCompetition = value,
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
                              groupValue: provider.durationPerCompetition,
                              onChanged: (dynamic value) =>
                                  provider.durationPerCompetition = value,
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
            if (provider.durationPerCompetition != null &&
                provider.durationPerCompetition!)
              Column(
                children: [
                  RoundedContainer(
                    height: scaleHeight(50.0),
                    padding: EdgeInsets.symmetric(horizontal: scaleWidth(8.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "مدة للمسابقة",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: AppStyles.PRIMARY_COLOR,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        NumberCounterButtons(
                          controller: provider.durationCompetitionSeconds,
                          width: scaleWidth(150.0),
                          minNumber: 1,
                          maxNumber: 90,
                          descriptionText: "د",
                          onChanged: provider.onChoiceChanged,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: scaleHeight(16.0)),
                ],
              ),
            if (provider.durationPerCompetition != null &&
                provider.durationPerCompetition!)
              if (competition.isFeatureAllowed(provider.appUser!, group,
                  CompetitionCreationFeature.canBackOrNot))
                Column(
                  children: [
                    RoundedContainer(
                      height: null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "اتاحية الرجوع للسؤال",
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
                                      groupValue: provider.canBack,
                                      onChanged: (dynamic value) =>
                                          provider.canBack = value,
                                      activeColor:
                                          AppStyles.SECONDARY_COLOR_DARK,
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
                                      groupValue: provider.canBack,
                                      onChanged: (dynamic value) =>
                                          provider.canBack = value,
                                      activeColor:
                                          AppStyles.SECONDARY_COLOR_DARK,
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
                  ],
                ),
          ],
        );
      }),
    );
  }
}
