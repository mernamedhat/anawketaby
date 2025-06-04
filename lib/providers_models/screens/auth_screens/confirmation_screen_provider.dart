import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:anawketaby/ui/screens/auth_screens/confirmation_screen.dart';
import 'package:anawketaby/ui/screens/auth_screens/intro_screen.dart';
import 'package:anawketaby/ui/screens/home_screens/home_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ConfirmationScreenProvider extends ChangeNotifier {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  final TextEditingController codeController = TextEditingController();

  ConfirmationScreenProvider();

  Future confirmCode() async {
    showLoadingDialog();

    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: appUser!.verificationId!, smsCode: codeController.text);
    try {
      await FirebaseAuth.instance.currentUser!
          .linkWithCredential(phoneAuthCredential);
      await FirebaseFirestore.instance
          .doc(FirestorePaths.userDocument("${appUser!.firebaseUser!.uid}"))
          .update({
        'phoneVerificationID': FieldValue.delete(),
        'phoneResendToken': FieldValue.delete(),
        'phoneLastTryTime': FieldValue.delete(),
      });
      String userID = FirebaseAuth.instance.currentUser!.uid;
      await UsersManagement.instance.updateUserToken(userID: userID);
      navigateRemoveUntil(HomeScreen(), (Route<dynamic> route) => false);
    } catch (_) {
      Navigator.pop(Get.context!);
      showErrorDialog(title: "كود خاطئ", desc: "الكود الذي ادخلته غير صحيح.");
    }
  }

  Future resendCode() async {
    if (this.appUser!.lastTryTime == null ||
        RealTime.instance.now!.isAfter(this
            .appUser!
            .lastTryTime!
            .toDate()
            .add(Duration(minutes: 1, seconds: 30)))) {
      notifyListeners();

      showLoadingDialog();

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: appUser!.phone!,
        forceResendingToken: appUser!.resendToken as int?,
        verificationCompleted: (PhoneAuthCredential credential) async {
          showLoadingDialog();

          await FirebaseAuth.instance.currentUser!
              .linkWithCredential(credential);
          await FirebaseFirestore.instance
              .doc(FirestorePaths.userDocument("${appUser!.firebaseUser!.uid}"))
              .update({
            'phoneVerificationID': FieldValue.delete(),
            'phoneResendToken': FieldValue.delete(),
            'phoneLastTryTime': FieldValue.delete(),
          });
          String userID = FirebaseAuth.instance.currentUser!.uid;
          await UsersManagement.instance.updateUserToken(userID: userID);
          navigateRemoveUntil(HomeScreen(), (Route<dynamic> route) => false);
        },
        verificationFailed: (FirebaseAuthException e) {
          Navigator.pop(Get.context!);
          showErrorDialog(
              title: "حدث خطأ",
              desc: "حدث خطأ في هذه العملية من فضلك اعد المحاولة.");
        },
        codeSent: (String verificationId, int? resendToken) async {
          await FirebaseFirestore.instance
              .doc(FirestorePaths.userDocument("${appUser!.firebaseUser!.uid}"))
              .update({
            'phoneVerificationID': verificationId,
            'phoneResendToken': resendToken,
            'phoneLastTryTime': Timestamp.fromDate(RealTime.instance.now!),
          });

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .doc(FirestorePaths.userDocument("${appUser!.firebaseUser!.uid}"))
              .get();
          AppUser user = AppUser.fromDocument(userDoc, appUser!.firebaseUser);
          Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);

          Navigator.pop(Get.context!);
          navigateReplacement(ConfirmationScreen());
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      Navigator.pop(Get.context!);
      showInfoDialog(
          title: "يجب الانتظار",
          desc: "مازال هناك وقت قبل ارسال الكود مره اخرى، برجاء الانتظار.");
    }
  }

  Future<void> signOut() async {
    await UsersManagement.instance.updateUserToken(
        userID: this.appUser!.firebaseUser!.uid, isLoggedOut: true);

    await FirebaseAuth.instance.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FacebookAuth.instance.logOut();

    Provider.of<UserProvider>(Get.context!, listen: false).setUser(null);
    navigateRemoveUntil(IntroScreen(), (Route<dynamic> route) => false);
  }

  refreshScreen() {
    Future.delayed(const Duration(seconds: 3), () => notifyListeners());
  }
}
