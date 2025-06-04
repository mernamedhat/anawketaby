import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/bible_book.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/widgets/number_counter_buttons.dart';
import 'package:anawketaby/utils/bible_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AdminNewCompetitionDetailsStepProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final Competition competition;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<String> reads = [];
  BibleBook? _tempSelectedBibleBook = BibleUtil.instance.books.first;
  int? _tempSelectedBibleBookChapter;

  final NumberCounterController durationCompetitionSeconds =
      NumberCounterController(value: 20);

  bool? _durationPerCompetition = true;
  bool? _canBack = false;

  AdminNewCompetitionDetailsStepProvider(this.competition) {
    nameController.text = this.competition.name ?? "";
    descriptionController.text = this.competition.description ?? "";
    reads.addAll(this.competition.reads ?? []);
    durationCompetitionSeconds.value =
        (this.competition.durationCompetitionSeconds != null)
            ? (this.competition.timeCreated == null ||
                    (this.competition.durationCompetitionSeconds != null &&
                        this.competition.durationCompetitionSeconds! < 90))
                ? this.competition.durationCompetitionSeconds
                : (this.competition.durationCompetitionSeconds! / 60).floor()
            : durationCompetitionSeconds.value;
    _durationPerCompetition =
        this.competition.durationPerCompetition ?? _durationPerCompetition;
    _canBack = this.competition.canBack ?? _canBack;

    _tempSelectedBibleBook = this.bibleBooks.first;

    notifyListeners();
  }

  @override
  void notifyListeners() {
    _setFields();
    super.notifyListeners();
  }

  _setFields() {
    this.competition.name = nameController.text.trim();
    this.competition.description = descriptionController.text.trim();
    this.competition.reads = reads;
    this.competition.durationPerCompetition = durationPerCompetition;
    this.competition.durationCompetitionSeconds =
        durationCompetitionSeconds.value;
    this.competition.canBack = canBack;
  }

  List<BibleBook> get bibleBooks => BibleUtil.instance.books
      .where((e) => !this.reads.contains(e.key))
      .toList();

  List<int?> get bookChapters {
    List<int?> chaptersList = [];

    if (!this.reads.join(",").contains(_tempSelectedBibleBook!.key!)) {
      chaptersList.add(null);
    }

    chaptersList.addAll(List.generate(
        _tempSelectedBibleBook!.chaptersNo!, (index) => index + 1));

    return chaptersList;
  }

  void addRead() {
    String newRead = BibleUtil.readFromBook(_tempSelectedBibleBook!,
        chapter: _tempSelectedBibleBookChapter);
    if (!this.reads.contains(newRead)) this.reads.add(newRead);
    if (BibleUtil.isKeyBookOnly(newRead))
      _tempSelectedBibleBook = bibleBooks.first;
    notifyListeners();
  }

  removeRead(String read) {
    this.reads.remove(read);
    notifyListeners();
  }

  Future<void> pickFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
      type: FileType.image,
    );

    if (result != null) {
      this.competition.tempPickedImage = result.files.first;
      notifyListeners();
    }
  }

  bool? get durationPerCompetition => _durationPerCompetition;

  set durationPerCompetition(bool? value) {
    _durationPerCompetition = value;
    notifyListeners();
  }

  bool? get canBack => _canBack;

  set canBack(bool? value) {
    _canBack = value;
    notifyListeners();
  }

  BibleBook? get tempSelectedBibleBook => _tempSelectedBibleBook;

  set tempSelectedBibleBook(BibleBook? value) {
    _tempSelectedBibleBook = value;
    _tempSelectedBibleBookChapter = null;
    notifyListeners();
  }

  int? get tempSelectedBibleBookChapter => _tempSelectedBibleBookChapter;

  set tempSelectedBibleBookChapter(int? value) {
    _tempSelectedBibleBookChapter = value;
    notifyListeners();
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
