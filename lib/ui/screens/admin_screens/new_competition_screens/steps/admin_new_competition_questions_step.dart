/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/providers_models/screens/admin_screens/new_competition_screens/steps/admin_new_competition_questions_step_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminNewCompetitionQuestionsStep extends StatelessWidget {
  final Competition competition;
  final AppGroup? group;

  const AdminNewCompetitionQuestionsStep({
    Key? key,
    required this.competition,
    this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminNewCompetitionQuestionsStepProvider(
        this.competition,
        this.group,
      ),
      child: Consumer<AdminNewCompetitionQuestionsStepProvider>(
          builder: (_, provider, __) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: provider.addNewQuestion,
              child: Text(
                "إضافة سؤال جديد",
                style: const TextStyle(
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  fontSize: 20.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(60.0)),    // Set text color
              ),
            ),

            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) => SizedBox(height: 8.0),
                itemCount: provider.competition.questions.length,
                itemBuilder: (_, index) => _questionTile(
                    provider, provider.competition.questions[index]),
              ),
            ),
          ],
        );
      }),
    );
  }

  _questionTile(AdminNewCompetitionQuestionsStepProvider provider,
      CompetitionQuestion question) {
    return InkWell(
      onTap: () => provider.showQuestionDialog(question),
      child: RoundedContainer(
        height: null,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "${question.content}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: AppStyles.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.copy),
                onPressed: () => provider.cloneQuestion(question)),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => provider.removeQuestion(question)),
          ],
        ),
      ),
    );
  }
}
