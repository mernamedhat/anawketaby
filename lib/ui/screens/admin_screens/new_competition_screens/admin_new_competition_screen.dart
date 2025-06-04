import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/screens/admin_screens/new_competition_screens/admin_new_competition_screen_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';

enum CompetitionSteps { details, questions, conditions, moreDetails, share }

class AdminNewCompetitionScreen extends StatelessWidget {
  final Competition? competition;
  final CompetitionSteps? step;
  final AppGroup? group;

  const AdminNewCompetitionScreen({
    Key? key,
    this.competition,
    this.step,
    this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminNewCompetitionScreenProvider(
          this.competition ?? Competition(), this.step, this.group),
      child: Consumer<AdminNewCompetitionScreenProvider>(
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
              width: MediaQuery.of(context).size.width,
              color: AppStyles.BACKGROUND_COLOR,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SafeArea(
                    child: AppBar(
                      backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                      toolbarHeight: 75.0,
                      title: AutoSizeText(
                        (provider.isNewCompetition)
                            ? "مسابقة جديدة"
                            : "تعديل المسابقة",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: AppStyles.PRIMARY_COLOR,
                        ),
                      ),
                      centerTitle: true,
                      leading: TextButton(
                        child: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        IconStepper(
                          icons: [
                            Icon(
                              Icons.edit_outlined,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                            ),
                            Icon(
                              Icons.list_outlined,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                            ),
                            Icon(
                              Icons.quick_contacts_dialer_outlined,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                            ),
                            Icon(
                              Icons.format_indent_increase,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                            ),
                            Icon(
                              Icons.share_outlined,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                            ),
                          ],
                          // activeStep property set to activeStep variable defined above.
                          activeStep: provider.activeStep,
                          // This ensures step-tapping updates the activeStep.
                          onStepReached: provider.onStepReached,
                          activeStepColor: AppStyles.SELECTION_COLOR,
                          stepColor: AppStyles.TEXT_THIRD_COLOR,
                          lineColor: Colors.white,
                          activeStepBorderColor: Colors.white,
                          enableNextPreviousButtons: false,
                          enableStepTapping: false,
                          steppingEnabled: false,
                          stepRadius: 16.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: scaleWidth(8.0)),
                            child: provider.stepContent(),
                          ),
                        ),
                        Container(
                          height: scaleHeight(74.0),
                          padding: EdgeInsets.symmetric(
                              vertical: scaleHeight(4.0),
                              horizontal: scaleWidth(12.0)),
                          color: AppStyles.PRIMARY_COLOR,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              previousButton(provider),
                              nextButton(provider),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Returns the next button.
  Widget nextButton(AdminNewCompetitionScreenProvider provider) {
    return ElevatedButton(
      onPressed: provider.isNextEnabled() ? provider.nextClick : null,
      child: Text(
        "التالي",
        style: const TextStyle(
          color: AppStyles.TEXT_PRIMARY_COLOR,
          fontSize: 20.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: AppStyles.THIRD_COLOR, backgroundColor: AppStyles.THIRD_COLOR_DARK, minimumSize: Size(scaleWidth(140.0), scaleHeight(60.0)), disabledForegroundColor: AppStyles.THIRD_COLOR.withOpacity(0.38), disabledBackgroundColor: AppStyles.THIRD_COLOR.withOpacity(0.12),   // Disable color when the button is disabled
      ),
    )
    ;
  }

  /// Returns the previous button.
  Widget previousButton(AdminNewCompetitionScreenProvider provider) {
    return ElevatedButton(
      onPressed: provider.isPreviousEnabled() ? provider.previousClick : null,
      child: Text(
        "السابق",
        style: const TextStyle(
          color: AppStyles.TEXT_PRIMARY_COLOR,
          fontSize: 20.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: AppStyles.SECONDARY_COLOR, backgroundColor: AppStyles.SECONDARY_COLOR_DARK, minimumSize: Size(scaleWidth(140.0), scaleHeight(60.0)), disabledForegroundColor: AppStyles.SECONDARY_COLOR.withOpacity(0.38), disabledBackgroundColor: AppStyles.SECONDARY_COLOR.withOpacity(0.12),   // Disable color when the button is disabled
      ),
    )
    ;
  }
}
