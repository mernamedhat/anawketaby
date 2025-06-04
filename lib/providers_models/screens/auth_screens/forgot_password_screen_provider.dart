import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreenProvider extends ChangeNotifier {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreenProvider();

  forgotPassword() async {
    showLoadingDialog();

    //Get string values from controllers
    String email = emailController.text.trim();

    if (email == "") {
      Navigator.pop(Get.context!);
      showErrorDialog(
          title: "فشل البريد الالكتروني",
          desc: "من فضلك ادخل بريد الكتروني صحيح.");
      return;
    }

    bool successful = await UsersManagement.instance.resetPassword(email);

    if (successful) {
      Navigator.pop(Get.context!);
      Navigator.pop(Get.context!);

      showSuccessDialog(
        title: "تم بنجاح",
        desc:
            "تم بنجاح ارسال رسالة استرجاع للبريد الاكتروني الخاص بك، برجاء التحقق من بريدك.",
      );
    }
  }
}
