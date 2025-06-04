import 'package:anawketaby/models/app_group.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NewGroupDetailsStepProvider extends ChangeNotifier {
  final AppGroup group;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  NewGroupDetailsStepProvider(this.group) {
    nameController.text = this.group.name ;
    descriptionController.text = this.group.description;

    notifyListeners();
  }

  @override
  void notifyListeners() {
    _setFields();
    super.notifyListeners();
  }

  _setFields() {
    this.group.name = nameController.text.trim();
    this.group.description = descriptionController.text.trim();
  }

  Future<void> pickFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
      type: FileType.image,
    );

    if (result != null) {
      this.group.tempPickedImage = result.files.first;
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
