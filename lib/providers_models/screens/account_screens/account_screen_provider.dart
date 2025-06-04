import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/account_screens/edit_account_screen.dart';
import 'package:anawketaby/ui/screens/auth_screens/intro_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AccountScreenProvider extends ChangeNotifier {
  AppUser? appUser = Provider.of<UserProvider>(Get.context!).appUser;

  AccountScreenProvider();

  void editAccount() async {
    navigateTo(EditAccountScreen());
  }

  String getDateTimeBirthDate(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd');
    return timeFormatter.format(date);
  }

  Future signOut() async {
    showLoadingDialog();

    await UsersManagement.instance
        .updateUserToken(userID: appUser!.firebaseUser!.uid, isLoggedOut: true);

    await FirebaseAuth.instance.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FacebookAuth.instance.logOut();

    Provider.of<UserProvider>(Get.context!, listen: false).setUser(null);
    navigateRemoveUntil(IntroScreen(), (Route<dynamic> route) => false);
  }
}
