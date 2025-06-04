import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/auth_screens/confirmation_screen.dart';
import 'package:anawketaby/ui/screens/auth_screens/forgot_password_screen.dart';
import 'package:anawketaby/ui/screens/home_screens/home_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LogInScreenProvider extends ChangeNotifier {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LogInScreenProvider();

  logIn() async {
    showLoadingDialog();

    //Get string values from controllers
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email == "" || password == "") {
      Navigator.pop(Get.context!);
      showErrorDialog(title: "فشل الدخول", desc: "يجب ملئ جميع البيانات.");
      return;
    }

    bool successful =
        await UsersManagement.instance.loginWithEmail(email, password);

    if (successful) {
      appUser = Provider.of<UserProvider>(Get.context!, listen: false).appUser;
      UsersManagement.instance
          .updateUserToken(userID: appUser!.firebaseUser!.uid);

      if (appUser?.firebaseUser?.phoneNumber == null)
        navigateRemoveUntil(
            ConfirmationScreen(), (Route<dynamic> route) => false);
      else
        navigateRemoveUntil(HomeScreen(), (Route<dynamic> route) => false);
    }
  }

  goToForgotPassword() async {
    navigateTo(ForgotPasswordScreen());
  }
}
