/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:io';

import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/providers_models/screens/my_groups_screens/new_group_screen/steps/new_group_details_step_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/ui/widgets/rounded_text_field.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewGroupDetailsStep extends StatelessWidget {
  final AppGroup group;

  const NewGroupDetailsStep({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewGroupDetailsStepProvider(this.group),
      child: Consumer<NewGroupDetailsStepProvider>(builder: (_, provider, __) {
        return ListView(
          children: [
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "اسم المجموعة",
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
                      maxLength: 20,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "اكتب اسم المجموعة هنا",
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
                    "وصف المجموعة (اختياري)",
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
                      maxLength: 100,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "اكتب وصف المجموعة هنا",
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
                    "صورة المجموعة (اختياري)",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: scaleHeight(8.0)),
                  if (provider.group.tempPickedImage == null)
                    ElevatedButton(
                      onPressed: provider.pickFromGallery,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                        backgroundColor: AppStyles.PRIMARY_COLOR_DARK, // Button background color
                        minimumSize: Size(double.infinity, scaleHeight(55.0)), // Full width & height
                      ),
                      child: const Text(
                        "اختيار صورة",
                        style: TextStyle(
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontSize: 18.0,
                        ),
                      ),
                    )

                  else
                    Column(
                      children: [
                        Container(
                            constraints:
                            BoxConstraints(minHeight: 10.0, minWidth: 10.0),
                            child: Image.file(File(
                                provider.group.tempPickedImage!.path!))),
                        SizedBox(
                          height: scaleHeight(10.0),
                        ),
                        ElevatedButton(
                          onPressed: provider.pickFromGallery,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                            backgroundColor: AppStyles.PRIMARY_COLOR_DARK, // Button background color
                            minimumSize: Size(scaleWidth(180.0), scaleHeight(60.0)), // Width & Height
                          ),
                          child: const Text(
                            "تغيير الصورة",
                            style: TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 20.0,
                            ),
                          ),
                        )

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
