import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/screens/competition_screens/competition_test_screens/competition_test_start_screen_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CompetitionTestStartScreen extends StatelessWidget {
  final Competition competition;

  const CompetitionTestStartScreen({Key? key, required this.competition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompetitionTestStartScreenProvider(this.competition),
      child: Consumer<CompetitionTestStartScreenProvider>(
          builder: (_, provider, __) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppStyles.PRIMARY_COLOR_DARK,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
          ),
          child: Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: AppStyles.PRIMARY_COLOR,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints:
                            BoxConstraints(maxHeight: scaleHeight(60.0)),
                        child: AutoSizeText(
                          "${provider.competition.name}",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 48.0,
                            color: AppStyles.TEXT_PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: scaleHeight(12.0)),
                      AutoSizeText(
                        "${provider.competition.creatorFullName}",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: scaleHeight(24.0)),
                      AutoSizeText(
                        "${provider.competitionQuestionsCount}",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 28.0,
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                        ),
                      ),
                      SizedBox(height: scaleHeight(22.0)),
                      AutoSizeText(
                        "${provider.competitionReads}",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                        ),
                      ),
                      SizedBox(height: scaleHeight(22.0)),
                      AutoSizeText(
                        "${provider.competitionLevel}",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                        ),
                      ),
                      SizedBox(height: scaleHeight(64.0)),
                      ElevatedButton(
                        onPressed: provider.startCompetition,
                        child: Text(
                          "بدأ الأن",
                          style: const TextStyle(
                            color: AppStyles.TEXT_PRIMARY_COLOR,
                            fontSize: 22.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppStyles.THIRD_COLOR, backgroundColor: AppStyles.THIRD_COLOR_DARK, minimumSize: Size(310.0, scaleHeight(55.0)),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
