/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/providers_models/screens/my_teams_screens/new_team_screen/steps/new_team_members_step_provider.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewTeamMembersStep extends StatelessWidget {
  final AppTeam team;

  const NewTeamMembersStep({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewTeamMembersStepProvider(this.team),
      child: Consumer<NewTeamMembersStepProvider>(builder: (_, provider, __) {
        return ListView(
          children: [
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "إضافة عضو للفريق برقم الموبايل",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: scaleHeight(10.0)),
                  RoundedContainer(
                    backgroundColor: AppStyles.BACKGROUND_COLOR.withAlpha(30),
                    height: scaleHeight(50.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: provider.phoneController,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'رقم الموبايل',
                              hintTextDirection: TextDirection.rtl,
                              hintStyle:
                                  TextStyle(color: AppStyles.TEXT_THIRD_COLOR),
                              icon: Icon(Icons.phone_android),
                            ),
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: CountryCodePicker(
                            onChanged: (CountryCode countryCode) {
                              provider.countryCode = countryCode.dialCode;
                            },
                            padding: EdgeInsets.zero,
                            initialSelection: 'EG',
                            favorite: ['EG'],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: scaleHeight(10.0)),
                  (provider.isLoading)
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: provider.addMember,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                      backgroundColor: AppStyles.PRIMARY_COLOR_DARK, // Button background color
                      minimumSize: Size(double.infinity, scaleHeight(55.0)), // Full width & height
                    ),
                    child: const Text(
                      "إضافة عضو",
                      style: TextStyle(
                        color: AppStyles.TEXT_PRIMARY_COLOR,
                        fontSize: 18.0,
                      ),
                    ),
                  )

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
                    "أعضاء الفريق",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: scaleHeight(8.0)),
                  Column(
                    children: provider.team.membersIDs
                        .map((e) => _memberItem(provider, e))
                        .toList(),
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

  Widget _memberItem(NewTeamMembersStepProvider provider, String memberID) {
    int index = provider.team.membersIDs.indexOf(memberID) + 1;
    Map memberMap = provider.team.membersProfiles[memberID];

    return Column(
      children: [
        RoundedContainer(
          backgroundColor: AppStyles.BACKGROUND_COLOR.withAlpha(30),
          child: Row(
            children: [
              RoundedContainer(
                height: scaleHeight(35.0),
                width: scaleWidth(35.0),
                padding: EdgeInsets.symmetric(
                    vertical: scaleHeight(2.0), horizontal: scaleWidth(2.0)),
                backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                child: AutoSizeText(
                  "$index",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppStyles.PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: scaleWidth(16.0)),
              ClipRRect(
                borderRadius: BorderRadius.circular(35.0),
                child: (memberMap["profilePhotoURL"] != null)
                    ? CachedImage(
                        url: "${memberMap["profilePhotoURL"]}",
                        height: scaleHeight(70.0),
                        width: scaleWidth(70.0),
                      )
                    : Container(
                        color: Colors.white,
                        child: Image.asset(
                          "assets/images/default_profile.png",
                          fit: BoxFit.contain,
                          height: scaleHeight(70.0),
                          width: scaleWidth(70.0),
                        ),
                      ),
              ),
              SizedBox(width: scaleWidth(16.0)),
              Expanded(
                child: AutoSizeText(
                  "${memberMap["fullName"]}",
                  maxLines: 1,
                  minFontSize: 6.0,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppStyles.APP_MATERIAL_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: scaleWidth(4.0)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: (memberID == provider.team.leaderID)
                        ? null
                        : () => provider.removeMember(memberMap),
                    child: RoundedContainer(
                      height: scaleHeight(35.0),
                      width: scaleWidth(60.0),
                      padding: EdgeInsets.symmetric(
                          vertical: scaleHeight(2.0),
                          horizontal: scaleWidth(2.0)),
                      backgroundColor: (memberID == provider.team.leaderID)
                          ? Colors.blue
                          : Colors.redAccent,
                      child: Text(
                        (memberID == provider.team.leaderID) ? "القائد" : "حذف",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (provider.team.id != null &&
                      provider.team.leaderID != memberID) ...[
                    SizedBox(height: scaleHeight(4.0)),
                    InkWell(
                      onTap: (memberID == provider.team.leaderID)
                          ? null
                          : () => provider.makeLeader(memberMap),
                      child: RoundedContainer(
                        height: scaleHeight(35.0),
                        width: scaleWidth(60.0),
                        padding: EdgeInsets.symmetric(
                            vertical: scaleHeight(2.0),
                            horizontal: scaleWidth(2.0)),
                        backgroundColor: Colors.green,
                        child: Text(
                          "جعله القائد",
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: AppStyles.TEXT_PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        Divider(color: AppStyles.SELECTION_COLOR_DARK),
      ],
    );
  }
}
