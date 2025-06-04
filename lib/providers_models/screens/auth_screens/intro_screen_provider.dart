import 'dart:async';

import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/auth_screens/confirmation_screen.dart';
import 'package:anawketaby/ui/screens/auth_screens/log_in_screen.dart';
import 'package:anawketaby/ui/screens/auth_screens/sign_up_screen.dart';
import 'package:anawketaby/ui/screens/home_screens/home_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class IntroScreenProvider extends ChangeNotifier {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  IntroScreenProvider();

  loginWithEmail() {
    navigateTo(LogInScreen());
  }

  Future loginWithGoogle() async {
    // Show loading dialog
    showLoadingDialog();

    // Initialize Google Sign in
    final GoogleSignIn _googleSignIn = GoogleSignIn(

      scopes: ['email'],
    );

    _handleSignIn() async {
      // Get user information
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if(googleUser == null) {
        return throw Exception();
      }

      // Get user auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Get credential for google user tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((error) {
            print("GoogleError"+error.toString());
        Navigator.pop(Get.context!);
        _showErrorException(error);
      });

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc("${userCredential.user!.uid}")
          .get();

      if (userDoc.data() == null) {
        navigateTo(SignUpScreen(
            socialLogging: true, socialEmail: userCredential.user!.email));
      } else {
        AppUser user = AppUser.fromDocument(userDoc, userCredential.user);
        Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);
        await UsersManagement.instance
            .updateUserToken(userID: user.firebaseUser!.uid);
        if (user.firebaseUser?.phoneNumber == null)
          navigateRemoveUntil(
              ConfirmationScreen(), (Route<dynamic> route) => false);
        else
          navigateRemoveUntil(HomeScreen(), (Route<dynamic> route) => false);
      }
    }

    try {
      await _handleSignIn();
    } catch (ex) {
      print("GoogleErrorr"+ex.toString());
      Navigator.pop(Get.context!);
      showErrorDialog(title: "حدث خطأ", desc: "لقد حدث خطأ ما غير معروف.");
    }
  }

  loginWithFacebook() async {
    // Show loading dialog
    showLoadingDialog();

    // Initialize Facebook login
    // by default we request the email and the public profile
    final LoginResult result = await FacebookAuth.instance.login();

    late var facebookToken;
    var facebookUserId;

    _signInWithFacebook() async {
      // Get credential of facebook user
      final AuthCredential credential =
          FacebookAuthProvider.credential(facebookToken);

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((error) async {
        Navigator.pop(Get.context!);
        if (_showErrorException(error) ==
            "An account already exists with the same email address but different sign-in credentials.") {
          // Show loading dialog
          showLoadingDialog();

          var email = (error as FirebaseAuthException).email;

          HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
              'usersCallable-linkCredentialFBWithExistedSameEmail');
          HttpsCallableResult result = await callable.call({
            "email": email,
            "fbUserID": facebookUserId,
          });
          if (result.data ?? false) {
            return await FirebaseAuth.instance.signInWithCredential(credential);
          }
        }
      });

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc("${userCredential.user!.uid}")
          .get();

      if (userDoc.data() == null) {
        navigateTo(SignUpScreen(
            socialLogging: true, socialEmail: userCredential.user!.email));
      } else {
        AppUser user = AppUser.fromDocument(userDoc, userCredential.user);
        Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);
        await UsersManagement.instance
            .updateUserToken(userID: user.firebaseUser!.uid);
        if (user.firebaseUser?.phoneNumber == null)
          navigateRemoveUntil(
              ConfirmationScreen(), (Route<dynamic> route) => false);
        else
          navigateRemoveUntil(HomeScreen(), (Route<dynamic> route) => false);
      }
    }

    switch (result.status) {
      case LoginStatus.success:
        facebookToken = result.accessToken!.tokenString;
        final userData = await FacebookAuth.instance.getUserData();
        facebookUserId = userData["id"];
        await _signInWithFacebook();
        break;
      case LoginStatus.cancelled:
        Navigator.pop(Get.context!);
        break;
      case LoginStatus.failed:
        Navigator.pop(Get.context!);
        showErrorDialog(title: "حدث خطأ", desc: "لقد حدث خطأ ما غير معروف.");
        break;
      case LoginStatus.operationInProgress:
        break;
    }
  }

  Future loginWithApple() async {
    // Show loading dialog
    showLoadingDialog();

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Get credential for apple user tokens
      final oAuthProvider = OAuthProvider('apple.com');

      final AuthCredential credential = oAuthProvider.credential(
        accessToken: appleCredential.authorizationCode,
        idToken: appleCredential.identityToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((error) {
        Navigator.pop(Get.context!);
        _showErrorException(error);
      });

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc("${userCredential.user!.uid}")
          .get();

      if (userDoc.data() == null) {
        navigateTo(SignUpScreen(
          socialLogging: true,
          socialEmail: userCredential.user!.email,
          appleCredential: appleCredential,
        ));
      } else {
        AppUser user = AppUser.fromDocument(userDoc, userCredential.user);
        Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);
        await UsersManagement.instance
            .updateUserToken(userID: user.firebaseUser!.uid);
        if (user.firebaseUser?.phoneNumber == null)
          navigateRemoveUntil(
              ConfirmationScreen(), (Route<dynamic> route) => false);
        else
          navigateRemoveUntil(HomeScreen(), (Route<dynamic> route) => false);
      }
    } catch (ex) {
      Navigator.pop(Get.context!);
      showErrorDialog(title: "حدث خطأ", desc: "لقد حدث خطأ ما غير معروف.");
    }
  }

  createAccount() {
    if (this.appUser?.firebaseUser == null)
      navigateTo(SignUpScreen());
    else
      navigateTo(ConfirmationScreen());
  }

  String _showErrorException(e) {
    if (e is FirebaseAuthException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          showErrorDialog(
              title: "فشل الدخول",
              desc:
                  "لا يوجد بريد الكتروني في قاعدة البيانات، من فضلك قم بالتسجيل اولاً.");
          return 'User with this e-mail not found.';
        case 'The password is invalid or the user does not have a password.':
          showErrorDialog(
              title: "فشل الدخول", desc: "كلمة المرور خاطئة، اعد المحاولة.");
          return 'Invalid password.';
        case 'Password should be at least 6 characters':
          showErrorDialog(
              title: "فشل التسجيل",
              desc:
                  "كلمة المرور خاطئة، يجب ان تكون على الاقل 6 احرف او ارقام.");
          return 'Invalid password.';
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          showErrorDialog(title: "حدث خطأ", desc: "لا يوجد اتصال بالانترنت.");
          return 'No internet connection.';
        case 'The email address is already in use by another account.':
          showErrorDialog(
              title: "فشل التسجيل", desc: "هذا البريد الالكتروني مسجل من قبل.");
          return 'Email address is already taken.';
        case 'An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.':
          // showErrorDialog(
          //     title: "فشل الدخول",
          //     desc:
          //         "هذا البريد الالكتروني مسجل من قبل من خلال طريقة دخول اخرى.");
          return 'An account already exists with the same email address but different sign-in credentials.';
        default:
          showErrorDialog(title: "حدث خطأ", desc: "لقد حدث خطأ ما غير معروف.");
          return 'Unknown error occurred.';
      }
    } else {
      return 'Unknown error occurred.';
    }
  }
}
