import 'package:anawketaby/enums/church.dart';
import 'package:anawketaby/enums/church_role.dart';
import 'package:anawketaby/enums/gender.dart';
import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/auth_screens/intro_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditAccountScreenProvider extends ChangeNotifier {
  AppUser? appUser = Provider.of<UserProvider>(Get.context!).appUser;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  Church? _selectedChurch;
  ChurchRole? _selectedChurchRole;
  bool? _isMale;

  var _birthDate;

  EditAccountScreenProvider() {
    appUser!.tempPickedImage = null;
    fullNameController.text = appUser!.fullName!;
    selectedChurch = appUser!.church;
    birthDateController.text = (appUser!.birthDate != null)
        ? _getDateTimeBirthDate(appUser!.birthDate!.toDate())
        : "";
    selectedChurchRole = appUser!.churchRole;

    _birthDate = appUser!.birthDate?.toDate();

    _isMale = (appUser!.gender != null) ? appUser!.gender == Gender.male : null;
  }

  Future saveEdits() async {
    if (fullNameController.text.trim().isEmpty || _selectedChurch == null) {
      showErrorDialog(
          title: "فشل التعديل", desc: "يجب ملئ جميع البيانات بصورة صحيحة.");
      return;
    }

    if (fullNameController.text.trim().length < 7 &&
        !fullNameController.text.trim().contains(" ")) {
      showErrorDialog(
          title: "فشل التعديل", desc: "يجب ملئ ان يكون الاسم ثنائي على الاقل.");
      return;
    }

    if (_isMale == null) {
      showErrorDialog(title: "فشل التسجيل", desc: "من فضلك قم باختيار النوع.");
      return;
    }

    if (_birthDate == null) {
      showErrorDialog(title: "فشل التسجيل", desc: "تاريخ الميلاد غير صحيح.");
      return;
    }

    this.appUser!.fullName = fullNameController.text.trim();
    this.appUser!.church = selectedChurch;
    this.appUser!.birthDate = Timestamp.fromDate(_birthDate);
    this.appUser!.churchRole = selectedChurchRole;
    this.appUser!.gender = (isMale != null)
        ? _isMale!
            ? Gender.male
            : Gender.female
        : null;

    showLoadingDialog();

    bool successful = await UsersManagement.instance.editUser(this.appUser!);

    Navigator.pop(Get.context!);
    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم التعديل",
        desc: "تم تعديل بياناتك بنجاح.",
      );
    } else {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "حدث خطأ في تعديل البيانات الخاصة بك.",
      );
    }
  }

  Future changePhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
      type: FileType.image,
    );

    if (result != null) {
      appUser!.tempPickedImage = result.files.first;
      notifyListeners();
    }
  }

  Future deleteMyAccount() async {
    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.question,
      title: 'تأكيد الحذف',
      desc: 'هل تريد بالتأكيد حذف حسابك؟ لا يمكن الرجوع في هذه الخطوة.',
      btnOkText: 'نعم',
      btnOkOnPress: () async {
        showLoadingDialog();

        HttpsCallable callable = FirebaseFunctions.instance
            .httpsCallable('usersCallable-deleteMyAccount');
        try {
          final isSuccess = (await callable.call()).data;

          if (isSuccess) {
            await FirebaseAuth.instance.signOut();
            final GoogleSignIn googleSignIn = GoogleSignIn();
            await googleSignIn.signOut();
            await FacebookAuth.instance.logOut();

            Provider.of<UserProvider>(Get.context!, listen: false)
                .setUser(null);
            navigateRemoveUntil(IntroScreen(), (Route<dynamic> route) => false);
          }
        } catch (ex) {
          print(ex);
          Navigator.pop(Get.context!);

          showErrorDialog(
            title: "حدث خطأ",
            desc: "حدث خطأ في اتمام العملية.",
          );
        }
      },
      btnCancelText: 'لا',
      btnCancelOnPress: () {},
    )..show();
  }

  Church? get selectedChurch => _selectedChurch;

  set selectedChurch(Church? value) {
    _selectedChurch = value;
    notifyListeners();
  }

  ChurchRole? get selectedChurchRole => _selectedChurchRole;

  set selectedChurchRole(ChurchRole? value) {
    _selectedChurchRole = value;
    notifyListeners();
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

  bool? get isMale => _isMale;

  set isMale(bool? value) {
    _isMale = value;
    notifyListeners();
  }
}
