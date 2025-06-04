/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/enums/question_types.dart';
import 'package:anawketaby/models/bible_book.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/models/question_choice.dart';
import 'package:anawketaby/ui/widgets/number_counter_buttons.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/ui/widgets/rounded_text_field.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/bible_util.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class QuestionJoinDialog extends StatefulWidget {
  final Competition competition;
  final CompetitionQuestion? competitionQuestion;

  const QuestionJoinDialog(
      {Key? key, required this.competition, this.competitionQuestion})
      : super(key: key);

  @override
  _QuestionJoinDialogState createState() => _QuestionJoinDialogState();
}

class _QuestionJoinDialogState extends State<QuestionJoinDialog> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _newConstantChoiceController =
      TextEditingController();
  final TextEditingController _newChoiceController = TextEditingController();
  final NumberCounterController _durationSeconds =
      NumberCounterController(value: 20);
  final NumberCounterController _points = NumberCounterController(value: 1);

  final List<QuestionChoice> _choices = [];
  final List<QuestionChoice> _constantChoices = [];

  String? _selectedRead;

  List<String> _readsList = [];

  @override
  void initState() {
    super.initState();

    for (var read in widget.competition.reads!) {
      if (BibleUtil.isKeyBookOnly(read)) {
        BibleBook book =
            BibleUtil.instance.books.firstWhere((e) => e.key == read);
        List.generate(book.chaptersNo!, (index) => index + 1).forEach((e) {
          _readsList.add("${book.key}_$e");
        });
      } else {
        _readsList.add("$read");
      }
    }

    if (widget.competitionQuestion != null) {
      _contentController.text = widget.competitionQuestion!.content!;
      _durationSeconds.value = widget.competitionQuestion!.durationSeconds ?? 5;
      _points.value = widget.competitionQuestion!.points ?? 1;
      _choices.addAll(widget.competitionQuestion!.choices);
      _constantChoices.addAll(widget.competitionQuestion!.constantChoices);
      _selectedRead = widget.competitionQuestion!.read;

      List<int> numbers = List.generate(
          widget.competitionQuestion!.answer!.length, (index) => index + 1);

      // Each new order with old new no
      for (int? no in widget.competitionQuestion!.answer as Iterable<int?>) {
        _choices[no! - 1].no =
            numbers[widget.competitionQuestion!.answer!.indexOf(no)];
      }

      _choices.sort((q1, q2) => q1.no!.compareTo(q2.no!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.alphaBlend(AppStyles.BACKGROUND_COLOR, Colors.white),
      padding: EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "محتوى السؤال",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: scaleHeight(10.0)),
                  RoundedTextField(
                    height: null,
                    width: scaleWidth(100.0),
                    padding: EdgeInsets.only(
                        left: scaleWidth(8.0), right: scaleWidth(8.0)),
                    textField: TextField(
                      controller: _contentController,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 100,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "اكتب السؤال هنا",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppStyles.TEXT_FIELD_HINT_COLOR,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                      ),
                      style: TextStyle(
                        color: AppStyles.SECONDARY_COLOR,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: scaleHeight(16.0)),
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "الثوابت",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: scaleHeight(10.0)),
                  Container(
                    padding: (_constantChoices.isEmpty)
                        ? const EdgeInsets.all(0.0)
                        : const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _constantChoices
                          .map<Widget>(
                            (choice) => Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    "${choice.no}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${choice.content}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        _removeConstantChoice(choice)),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedTextField(
                          height: null,
                          width: scaleWidth(100.0),
                          padding: EdgeInsets.only(
                              left: scaleWidth(8.0), right: scaleWidth(8.0)),
                          textField: TextField(
                            controller: _newConstantChoiceController,
                            textAlignVertical: TextAlignVertical.center,
                            maxLength: 100,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: "اكتب الاختيار هنا",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: AppStyles.TEXT_FIELD_HINT_COLOR,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                            ),
                            style: TextStyle(
                              color: AppStyles.SECONDARY_COLOR,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _addNewConstantChoice),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: scaleHeight(16.0)),
            RoundedContainer(
              height: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "التوصيل الصحيح",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: scaleHeight(10.0)),
                  Container(
                    padding: (_choices.isEmpty)
                        ? const EdgeInsets.all(0.0)
                        : const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _choices
                          .map<Widget>(
                            (choice) => Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    "${choice.no}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${choice.content}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => _removeChoice(choice)),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedTextField(
                          height: null,
                          width: scaleWidth(100.0),
                          padding: EdgeInsets.only(
                              left: scaleWidth(8.0), right: scaleWidth(8.0)),
                          textField: TextField(
                            controller: _newChoiceController,
                            textAlignVertical: TextAlignVertical.center,
                            maxLength: 100,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: "اكتب التوصيل هنا",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: AppStyles.TEXT_FIELD_HINT_COLOR,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                            ),
                            style: TextStyle(
                              color: AppStyles.SECONDARY_COLOR,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.add), onPressed: _addNewChoice),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: scaleHeight(16.0)),
            if (widget.competition.durationPerCompetition == null ||
                !widget.competition.durationPerCompetition!)
              Column(
                children: [
                  RoundedContainer(
                    height: null,
                    padding: EdgeInsets.symmetric(
                        vertical: scaleHeight(8.0),
                        horizontal: scaleWidth(8.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مدة السؤال",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: AppStyles.PRIMARY_COLOR,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        NumberCounterButtons(
                          controller: _durationSeconds,
                          width: double.infinity,
                          minNumber: 5,
                          maxNumber: 120,
                          descriptionText: "ث",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: scaleHeight(16.0)),
                ],
              ),
            RoundedContainer(
              height: null,
              padding: EdgeInsets.symmetric(
                  vertical: scaleHeight(8.0), horizontal: scaleWidth(8.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "نقط الاجابة الصحيحة",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  NumberCounterButtons(
                    controller: _points,
                    width: double.infinity,
                    minNumber: 1,
                    maxNumber: 100,
                  ),
                ],
              ),
            ),
            SizedBox(height: scaleHeight(16.0)),
            if (widget.competition.reads!.isNotEmpty)
              Column(
                children: [
                  RoundedContainer(
                    height: null,
                    padding: EdgeInsets.symmetric(
                        vertical: scaleHeight(8.0),
                        horizontal: scaleWidth(8.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "اصحاح الإجابة (اختياري)",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: AppStyles.PRIMARY_COLOR,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        DropdownButtonFormField(
                          hint: Text("القراءات"),
                          value: _selectedRead,
                          isExpanded: true,
                          items: [null, ...this._readsList]
                              .map((read) => DropdownMenuItem(
                                  value: read,
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${(read == null) ? "بدون تحديد" : BibleUtil.readFromKey(read)}",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black)))))
                              .toList(),
                          onChanged: (dynamic value) => _selectedRead = value,
                          autofocus: true,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: scaleHeight(16.0)),
                ],
              ),
            if (_choices.length >= 2 &&
                _constantChoices.length == _choices.length)
              ElevatedButton(
                onPressed: _addQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.PRIMARY_COLOR_DARK,
                  // Background color
                  minimumSize: Size(
                      double.infinity, scaleHeight(55.0)), // Width and height
                ),
                child: Text(
                  (widget.competitionQuestion == null) ? "إضافة" : "تعديل",
                  style: const TextStyle(
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontSize: 18.0,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _addNewConstantChoice() {
    setState(() {
      QuestionChoice choice = QuestionChoice(
          _choices.length + 1, _newConstantChoiceController.text.trim());
      _newConstantChoiceController.clear();
      _constantChoices.add(choice);
      _refreshChoices();
    });
  }

  void _removeConstantChoice(QuestionChoice choice) {
    setState(() {
      _constantChoices.remove(choice);
      _refreshChoices();
    });
  }

  void _addNewChoice() {
    if (_newChoiceController.text.trim().isEmpty) {
      showErrorSnackBar(
          title: "خانات فارغة", message: "من فضلك اكتب محتوى الاجابة.");
      return;
    }

    setState(() {
      QuestionChoice choice =
          QuestionChoice(_choices.length + 1, _newChoiceController.text.trim());
      _newChoiceController.clear();
      _choices.add(choice);
      _refreshChoices();
    });
  }

  void _removeChoice(QuestionChoice choice) {
    setState(() {
      _choices.remove(choice);
      _refreshChoices();
    });
  }

  void _refreshChoices() {
    for (QuestionChoice choice in _choices) {
      choice.no = _choices.indexOf(choice) + 1;
    }
    for (QuestionChoice choice in _constantChoices) {
      choice.no = _constantChoices.indexOf(choice) + 1;
    }
  }

  _addQuestion() {
    if (_contentController.text.trim().length < 3) {
      showErrorSnackBar(
          title: "خانات فارغة", message: "من فضلك اكتب محتوى السؤال.");
      return;
    }

    List<int?> answer = List.filled(_choices.length, null);

    _choices.shuffle();

    List<int?> shuffleChoicesNo = _choices.map((e) => e.no).toList();

    // Change no as new ordering.
    for (QuestionChoice choice in _choices) {
      choice.no = _choices.indexOf(choice) + 1;
    }

    // Each old order with new new no
    for (int? no in shuffleChoicesNo) {
      answer[no! - 1] = _choices[shuffleChoicesNo.indexOf(no)].no;
    }

    CompetitionQuestion competitionQuestion = CompetitionQuestion(
      questionType: QuestionTypes.join,
      content: _contentController.text.trim(),
      constantChoices: _constantChoices,
      choices: _choices,
      answer: answer,
      durationSeconds: (widget.competition.durationPerCompetition == null ||
              !widget.competition.durationPerCompetition!)
          ? _durationSeconds.value
          : null,
      points: _points.value,
      read: _selectedRead,
    );

    if (widget.competitionQuestion == null) {
      widget.competition.questions.add(competitionQuestion);
    } else {
      int questionIndex =
          widget.competition.questions.indexOf(widget.competitionQuestion!);
      widget.competition.questions.replaceRange(
          questionIndex, questionIndex + 1, [competitionQuestion]);
    }

    Navigator.pop(context);
  }
}
