import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/ui/screens/account_screens/account_screen.dart';
import 'package:anawketaby/ui/screens/home_screens/home_screen.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_text_field.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: scaleHeight(80.0),
      color: AppStyles.PRIMARY_COLOR_DARK,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => navigateRemoveUntil(HomeScreen(), (_) => false),
            // padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
                Text(
                  "الرئيسية",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _showCompetitionIDDialog,
            icon: Icon(
              CupertinoIcons.rocket,
              color: AppStyles.TEXT_PRIMARY_COLOR,
              size: scaleWidth(28.0),
            ),
            label: const Text(
              "كود التحدي",
              style: TextStyle(
                color: AppStyles.TEXT_PRIMARY_COLOR,
                fontSize: 18.0,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
              backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
              minimumSize: Size(scaleWidth(175.0), scaleHeight(60.0)), // Width & Height
            ),
          )
,
          TextButton(
            onPressed: () => navigateTo(AccountScreen()),
            // padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: 36.0,
                ),
                Text(
                  "الملف",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showCompetitionIDDialog() {
    TextEditingController competitionCode = TextEditingController();

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: AppStyles.SECONDARY_COLOR,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "كود المسابقة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: scaleHeight(12.0)),
              RoundedTextField(
                height: null,
                width: scaleWidth(100.0),
                padding: EdgeInsets.only(
                    left: scaleWidth(8.0), right: scaleWidth(8.0)),
                textField: TextField(
                  controller: competitionCode,
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "اكتب الكود هنا",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: AppStyles.TEXT_FIELD_HINT_COLOR,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(height: scaleHeight(20.0)),
              ElevatedButton.icon(
                onPressed: () => _goToCompetition(competitionCode.text.trim()),
                icon: Icon(
                  CupertinoIcons.rocket,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  size: scaleWidth(28.0),
                ),
                label: const Text(
                  "بدء التحدي",
                  style: TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 18.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                  backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                  minimumSize: Size(double.infinity, scaleHeight(60.0)), // Width & Height
                ),
              )

            ],
          ),
        );
      },
    );
  }

  _goToCompetition(String competitionCodeString) async {
    Navigator.pop(Get.context!);
    int? competitionCode = int.tryParse(competitionCodeString);

    if (competitionCodeString.isEmpty || competitionCode == null) {
      showErrorDialog(
        title: "كود فارغ",
        desc: "برجاء ادخال الكود بشكل صحيح.",
      );
      return;
    }

    Competition? competition = await CompetitionManagement.instance
        .getCompetitionByCode(competitionCode);

    if (competition != null)
      navigateToCompetition(competition);
    else
      showErrorDialog(
        title: "كود غير صحيح",
        desc:
            "هذا الكود غير صحيح، لا يوجد مسابقة بهذا الكود، برجاء اعادة المحاولة.",
      );
  }
}
