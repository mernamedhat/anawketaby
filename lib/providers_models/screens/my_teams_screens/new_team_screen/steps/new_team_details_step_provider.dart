import 'package:anawketaby/models/app_team.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NewTeamDetailsStepProvider extends ChangeNotifier {
  final AppTeam team;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  NewTeamDetailsStepProvider(this.team) {
    nameController.text = this.team.name ;
    descriptionController.text = this.team.description;

    notifyListeners();
  }

  @override
  void notifyListeners() {
    _setFields();
    super.notifyListeners();
  }

  _setFields() {
    this.team.name = nameController.text.trim();
    this.team.description = descriptionController.text.trim();
  }

  Future<void> pickFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
      type: FileType.image,
    );

    if (result != null) {
      this.team.tempPickedImage = result.files.first;
      notifyListeners();
    }
  }

  textChanged(String value) {
    notifyListeners();
  }

  onNumberChanged() {
    notifyListeners();
  }

  onChoiceChanged() {
    notifyListeners();
  }
}
