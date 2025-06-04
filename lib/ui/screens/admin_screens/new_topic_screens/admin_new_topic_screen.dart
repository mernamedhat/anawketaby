import 'dart:io';

import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/topic.dart';
import 'package:anawketaby/providers_models/screens/admin_screens/new_topic_screens/admin_new_topic_screen_provider.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/ui/widgets/rounded_text_field.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminNewTopicScreen extends StatelessWidget {
  final Topic? topic;

  const AdminNewTopicScreen({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminNewTopicScreenProvider(this.topic),
      child: Consumer<AdminNewTopicScreenProvider>(builder: (_, provider, __) {
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
              color: AppStyles.BACKGROUND_COLOR,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SafeArea(
                    child: AppBar(
                      backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                      toolbarHeight: 75.0,
                      title: AutoSizeText(
                        (provider.isEditing) ? "تعديل الموضوع" : "موضوع جديد",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: AppStyles.PRIMARY_COLOR,
                        ),
                      ),
                      centerTitle: true,
                      leading: TextButton(
                        child: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          vertical: scaleHeight(16.0),
                          horizontal: scaleWidth(16.0)),
                      children: [
                        RoundedContainer(
                          height: null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "اسم الموضوع",
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
                                    left: scaleWidth(8.0),
                                    right: scaleWidth(8.0)),
                                textField: TextField(
                                  controller: provider.nameController,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText: "اكتب اسم الموضوع هنا",
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
                                "وصف الموضوع",
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
                                    left: scaleWidth(8.0),
                                    right: scaleWidth(8.0)),
                                textField: TextField(
                                  controller: provider.descriptionController,
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: "اكتب وصف الموضوع هنا",
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
                                "تشغيل امكانية المتابعة",
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
                                          groupValue: provider.isAbleFollowing,
                                          onChanged: (dynamic value) =>
                                              provider.isAbleFollowing = value,
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
                                          groupValue: provider.isAbleFollowing,
                                          onChanged: (dynamic value) =>
                                              provider.isAbleFollowing = value,
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
                        RoundedContainer(
                          height: null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "عرض الموضوع",
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
                                          groupValue: provider.isShowing,
                                          onChanged: (dynamic value) =>
                                              provider.isShowing = value,
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
                                          groupValue: provider.isShowing,
                                          onChanged: (dynamic value) =>
                                              provider.isShowing = value,
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
                        RoundedContainer(
                          height: null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "كود الموضوع",
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
                                "هذا الكود لا يمكن تغييره فيما بعد، يجب وضعه بعناية شديدة. يجب ان يكون مثل هذا test_123 استخدام حروف انجيليزية وارقام وشرطة تحتيه فقط.",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                  fontFamily: AppStyles.TAJAWAL,
                                ),
                              ),
                              SizedBox(height: scaleHeight(10.0)),
                              RoundedTextField(
                                height: null,
                                width: scaleWidth(100.0),
                                padding: EdgeInsets.only(
                                    left: scaleWidth(8.0),
                                    right: scaleWidth(8.0)),
                                textField: TextField(
                                  controller: provider.topicIDController,
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: "اكتب كود الموضوع هنا",
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
                                    fontFamily: AppStyles.TAJAWAL,
                                  ),
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
                                "رابط النتيجة",
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
                                "إذا لم تعلن النتيجة بعد، اتركها فارغة.",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                  fontFamily: AppStyles.TAJAWAL,
                                ),
                              ),
                              SizedBox(height: scaleHeight(10.0)),
                              RoundedTextField(
                                height: null,
                                width: scaleWidth(100.0),
                                padding: EdgeInsets.only(
                                    left: scaleWidth(8.0),
                                    right: scaleWidth(8.0)),
                                textField: TextField(
                                  controller: provider.resultURLController,
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: "اكتب رابط النتيجة هنا",
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
                                    fontFamily: AppStyles.TAJAWAL,
                                  ),
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
                                "صورة الموضوع",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: scaleHeight(8.0)),
                              if (provider.topic!.tempPickedImage == null)
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
                                        constraints: BoxConstraints(
                                            minHeight: 10.0, minWidth: 10.0),
                                        child: Image.file(File(provider
                                            .topic!.tempPickedImage!.path!))),
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
                        RoundedContainer(
                          height: null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "مسابقاتك",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: scaleHeight(8.0)),
                              FutureBuilder<QuerySnapshot>(
                                future: CompetitionManagement.instance
                                    .getMyCreationCompetitionsFuture(
                                  provider.appUser!,
                                  limit: 30,
                                ),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(child: EmptyListLoader());
                                  else if (snapshot.data!.docs.isEmpty)
                                    return Center(
                                        child: EmptyListText(
                                      text: "لا توجد تحديات",
                                    ));
                                  else {
                                    return ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: scaleHeight(12.0)),
                                        itemBuilder: (_, index) {
                                          Competition competition =
                                              Competition.fromDocument(
                                                  snapshot.data!.docs[index]);
                                          return _competitionCheckBox(
                                              provider: provider,
                                              competition: competition);
                                        });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: scaleHeight(16.0)),
                        ElevatedButton(
                          onPressed: provider.createTopic,
                          child: Text(
                            provider.isEditing ? "تعديل الموضوع" : "إنشاء الموضوع",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(55.0)),    // Set text color
                          ),
                        ),

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

  Widget _competitionCheckBox(
      {required Competition competition, required AdminNewTopicScreenProvider provider}) {
    return InkWell(
      onTap: () {
        if (provider.isCompetitionIncluded(competition)) {
          provider.removeCompetitionFromList(competition);
        } else {
          provider.addCompetitionToList(competition);
        }
      },
      child: Container(
        child: Row(
          children: [
            Theme(
              data: ThemeData(
                unselectedWidgetColor: AppStyles.SECONDARY_COLOR_DARK,
              ),
              child: Checkbox(
                activeColor: AppStyles.PRIMARY_COLOR,
                value: provider.isCompetitionIncluded(competition),
                onChanged: (isSelected) {
                  if (isSelected!) {
                    provider.addCompetitionToList(competition);
                  } else {
                    provider.removeCompetitionFromList(competition);
                  }
                },
              ),
            ),
            SizedBox(width: scaleWidth(4.0)),
            Flexible(
              child: Text(
                "${competition.name}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: AppStyles.PRIMARY_COLOR,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
