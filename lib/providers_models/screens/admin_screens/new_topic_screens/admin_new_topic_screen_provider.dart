import 'package:anawketaby/managements/topics_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/topic.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AdminNewTopicScreenProvider extends ChangeNotifier {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  final Topic? topic;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController topicIDController = TextEditingController();
  final TextEditingController resultURLController = TextEditingController();

  bool? _isAbleFollowing = true;
  bool? _isShowing = true;

  final List<String> _selectedCompetitionsIDs = [];

  AdminNewTopicScreenProvider(this.topic) {
    nameController.text = this.topic!.name ?? "";
    descriptionController.text = this.topic!.description ?? "";
    topicIDController.text = this.topic!.topicID ?? "";
    resultURLController.text = this.topic!.resultURL ?? "";

    _isAbleFollowing = this.topic!.isAbleFollowing ?? _isAbleFollowing;
    _isShowing = this.topic!.isShowing ?? _isShowing;

    _selectedCompetitionsIDs.addAll(this.topic!.competitionsIDs);
  }

  Future<void> pickFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
      type: FileType.image,
    );

    if (result != null) {
      this.topic!.tempPickedImage = result.files.first;
      notifyListeners();
    }
  }

  void addCompetitionToList(Competition competition) {
    _selectedCompetitionsIDs.add(competition.id!);
    notifyListeners();
  }

  void removeCompetitionFromList(Competition competition) {
    _selectedCompetitionsIDs.remove(competition.id);
    notifyListeners();
  }

  bool isCompetitionIncluded(Competition competition) {
    return _selectedCompetitionsIDs.contains(competition.id);
  }

  Future createTopic() async {

    _setFields();

    if (this.topic!.name == null || this.topic!.name!.isEmpty) {
      showErrorSnackBar(
          title: "خانات فارغة", message: "من فضلك اكتب اسم الموضوع.");
      return;
    } else if (this.topic!.description == null ||
        this.topic!.description!.isEmpty) {
      showErrorSnackBar(
          title: "خانات فارغة", message: "من فضلك اكتب وصف الموضوع.");
      return;
    } else if (this.topic!.topicID == null || this.topic!.topicID!.isEmpty) {
      showErrorSnackBar(
          title: "خانات فارغة", message: "من فضلك اكتب كود الموضوع.");
      return;
    }

    showLoadingDialog();

    bool successful;

    if (!this.isEditing) {
      successful =
          await TopicsManagement.instance.createTopic(this.topic!, this.appUser!);
    } else {
      successful =
          await TopicsManagement.instance.editTopic(this.topic!, this.appUser);
    }

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: (this.isEditing) ? "تم تعديل الموضوع" : "تم إنشاء الموضوع",
        desc: (this.isEditing)
            ? "تم تعديل الموضوع بنجاح."
            : "تم إنشاء الموضوع بنجاح.",
        onDismissCallback: (_) => Navigator.pop(Get.context!),
      );
    } else {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "حدث خطأ في اتمام العملية.",
      );
    }
  }

  _setFields() {
    this.topic!.name = nameController.text.trim();
    this.topic!.description = descriptionController.text.trim();
    this.topic!.topicID = topicIDController.text.trim();
    this.topic!.resultURL = (resultURLController.text.trim().isNotEmpty)
        ? resultURLController.text.trim()
        : null;

    this.topic!.isAbleFollowing = isAbleFollowing;
    this.topic!.isShowing = isShowing;

    this.topic!.competitionsIDs = _selectedCompetitionsIDs;
  }

  bool? get isShowing => _isShowing;

  set isShowing(bool? value) {
    _isShowing = value;
    notifyListeners();
  }

  bool? get isAbleFollowing => _isAbleFollowing;

  set isAbleFollowing(bool? value) {
    _isAbleFollowing = value;
    notifyListeners();
  }

  bool get isEditing => topic!.id != null;
}
