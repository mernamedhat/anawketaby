import 'dart:io';

import 'package:anawketaby/enums/church.dart';
import 'package:anawketaby/enums/church_role.dart';
import 'package:anawketaby/enums/gender.dart';
import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:anawketaby/ui/screens/auth_screens/confirmation_screen.dart';
import 'package:anawketaby/ui/screens/home_screens/home_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignUpScreenProvider extends ChangeNotifier {
  final bool socialLogging;
  final String? socialEmail;
  final AuthorizationCredentialAppleID? appleCredential;
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? countryCode = "+20";

  Church? _selectedChurch;
  ChurchRole? _selectedChurchRole;
  bool? _isMale;

  var _birthDate;

  SignUpScreenProvider(
    this.socialLogging,
    this.socialEmail,
    this.appleCredential,
  ) {
    if (appleCredential != null) {
      fullNameController.text =
          '${appleCredential!.givenName ?? ''} ${appleCredential!.familyName ?? ''}';
      fullNameController.text = fullNameController.text.trim();
    }
  }

  bool get isRequiredFields =>
      Platform.isAndroid ||
      (Platform.isIOS &&
          Provider.of<SettingsProvider>(Get.context!, listen: false)
              .iOSRequiredFields!);

  signUp() async {
    showLoadingDialog();

    if (phoneController.text.startsWith("0")) {
      phoneController.text = phoneController.text.substring(1);
    }

    if (fullNameController.text.trim().isEmpty ||
        (phoneController.text.trim().isEmpty ||
            phoneController.text.trim().length < 6) ||
        (isRequiredFields && _selectedChurch == null) ||
        (isRequiredFields && _isMale == null) ||
        (!this.socialLogging &&
            (emailController.text.trim().isEmpty ||
                passwordController.text.isEmpty))) {
      Navigator.pop(Get.context!);
      showErrorDialog(
          title: "فشل التسجيل", desc: "يجب ملئ جميع البيانات بصورة صحيحة.");
      return;
    }

    if (isRequiredFields && _birthDate == null) {
      Navigator.pop(Get.context!);
      showErrorDialog(title: "فشل التسجيل", desc: "تاريخ الميلاد غير صحيح.");
      return;
    }

    if (fullNameController.text.trim().length < 7 &&
        !fullNameController.text.trim().contains(" ")) {
      Navigator.pop(Get.context!);
      showErrorDialog(
          title: "فشل التسجيل", desc: "يجب ملئ ان يكون الاسم ثنائي على الاقل.");
      return;
    }

    //Get string values from controllers
    String fullName = fullNameController.text.trim();

    if (countryCode == "+20" && phoneController.text.trim().startsWith("0")) {
      phoneController.text = phoneController.text.trim().substring(1);
    }

    String phone = "$countryCode${phoneController.text.trim()}";
    Church? church = _selectedChurch;
    ChurchRole? churchRole = _selectedChurchRole;
    Gender? gender = (isMale != null)
        ? _isMale!
            ? Gender.male
            : Gender.female
        : null;
    Timestamp? birthDate =
        (_birthDate != null) ? Timestamp.fromDate(_birthDate) : null;
    String? email =
        (this.socialLogging) ? this.socialEmail : emailController.text.trim();
    String password = passwordController.text;

    // Check if phone number is exists before.
    if (await phoneNumberExist(phone)) {
      Navigator.pop(Get.context!);
      showErrorDialog(title: "فشل التسجيل", desc: "رقم الهاتف مسجل من قبل.");
      return;
    }

    AppUser newAppUser = AppUser(
      fullName: fullName,
      phone: phone,
      church: church,
      gender: gender,
      birthDate: birthDate,
      churchRole: churchRole,
      email: email,
      isAdmin: false,
      timeCreated: Timestamp.fromDate(RealTime.instance.now!),
    );

    String userID;

    if (this.socialLogging) {
      userID = FirebaseAuth.instance.currentUser!.uid;
      newAppUser.id = userID;
    } else
    {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password)
          .catchError((error) {
        Navigator.pop(Get.context!);
        _showErrorException(error);
      });
      userID = userCredential.user!.uid;
      newAppUser.id = userID;
    }

    await FirebaseFirestore.instance
        .doc(FirestorePaths.userDocument("$userID"))
        .set(newAppUser.toJson(), SetOptions(merge: true));

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        showLoadingDialog();

        await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
        await FirebaseFirestore.instance
            .doc(FirestorePaths.userDocument("$userID"))
            .update({
          'phoneVerificationID': FieldValue.delete(),
          'phoneResendToken': FieldValue.delete(),
          'phoneLastTryTime': FieldValue.delete(),
        });
        await UsersManagement.instance.updateUserToken(userID: userID);
        navigateRemoveUntil(HomeScreen(), (Route<dynamic> route) => false);
      },
      verificationFailed: (FirebaseAuthException e) {
        Navigator.pop(Get.context!);
        showErrorDialog(
            title: "حدث خطأ",
            desc: "حدث خطأ في هذه العملية من فضلك اعد المحاولة.");
        print("klkl"+e.toString());
      },
      codeSent: (String verificationId, int? resendToken) async {
        await FirebaseFirestore.instance
            .doc(FirestorePaths.userDocument("$userID"))
            .update({
          'phoneVerificationID': verificationId,
          'phoneResendToken': resendToken,
          'phoneLastTryTime': Timestamp.fromDate(RealTime.instance.now!),
        });

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .doc(FirestorePaths.userDocument("$userID"))
            .get();
        AppUser user =
            AppUser.fromDocument(userDoc, FirebaseAuth.instance.currentUser);
        Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);
        navigateRemoveUntil(
            ConfirmationScreen(), (Route<dynamic> route) => false);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
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
          showErrorDialog(
              title: "فشل الدخول",
              desc:
                  "هذا البريد الالكتروني مسجل من قبل من خلال طريقة دخول اخرى.");
          return 'An account already exists with the same email address but different sign-in credentials..';
        default:
          showErrorDialog(title: "حدث خطأ", desc: "لقد حدث خطأ ما غير معروف.");
          return 'Unknown error occurred.';
      }
    } else {
      return 'Unknown error occurred.';
    }
  }

  set selectedChurch(Church? value) {
    _selectedChurch = value;
    notifyListeners();
  }

  bool? get isMale => _isMale;

  Church? get selectedChurch => _selectedChurch;

  set selectedChurchRole(ChurchRole? value) {
    _selectedChurchRole = value;
    notifyListeners();
  }

  ChurchRole? get selectedChurchRole => _selectedChurchRole;

  set isMale(bool? value) {
    _isMale = value;
    notifyListeners();
  }

  // Future<bool> phoneNumberExist(String phone) async {
  //   HttpsCallable callable = FirebaseFunctions.instance
  //       .httpsCallable('usersCallable-isPhoneNumberExist');
  //   HttpsCallableResult result = await callable.call({"phone": phone});
  //   return result.data ?? false;
  // }
  Future<bool> phoneNumberExist(String phone) async {
    try {
      final callable = FirebaseFunctions.instance
          .httpsCallable('usersCallable-isPhoneNumberExist');
      final result = await callable.call({"phone": phone});
      return result.data ?? false;
    } on FirebaseFunctionsException catch (e) {
      print('⚠️ FirebaseFunctionsException: ${e.code} - ${e.message}');
      print('Details: ${e.details}');
      return false;
    } catch (e) {
      print('⚠️ Unexpected error: $e');
      return false;
    }
  }

  Future chooseBirthdate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime.now().add(Duration(days: -(356 * 100))),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) return;

    if (DateTime.now().year - pickedDate.year < 10) {
      showErrorDialog(
          title: "تاريخ ميلاد خاطئ",
          desc: "يجب ان يكون عمرك أكثر من ١٠ سنوات.");
      return;
    }

    _birthDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
    );

    birthDateController.text = _getDateTimeBirthDate(_birthDate);

    notifyListeners();
  }

  String _getDateTimeBirthDate(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd');
    return timeFormatter.format(date);
  }
}
