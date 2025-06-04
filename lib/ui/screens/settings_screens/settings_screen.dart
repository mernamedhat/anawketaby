import 'package:anawketaby/providers_models/screens/settings_screens/settings_screen_provider.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsScreenProvider(),
      child: Consumer<SettingsScreenProvider>(builder: (_, provider, __) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppStyles.PRIMARY_COLOR,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
          ),
          child: Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              color: AppStyles.PRIMARY_COLOR,
              child: Column(
                children: [
                  SafeArea(
                    child: AppBar(
                      backgroundColor: AppStyles.PRIMARY_COLOR_DARK,
                      toolbarHeight: 75.0,
                      title: Text(
                        "إعدادات التطبيق",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                        ),
                      ),
                      centerTitle: true,
                      leading: TextButton(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppStyles.TEXT_PRIMARY_COLOR,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            "حفظ",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                            ),
                          ),
                          onPressed: provider.saveEdits,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(12.0),
                      children: [
                        RoundedContainer(
                          height: null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "تشغيل موسيقى المسابقة",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: scaleHeight(8.0)),
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      AppStyles.SECONDARY_COLOR_DARK,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: true,
                                          groupValue: provider
                                              .isCompetitionMusicEnabled,
                                          onChanged: (dynamic value) => provider
                                                  .isCompetitionMusicEnabled =
                                              value,
                                          activeColor:
                                              AppStyles.SECONDARY_COLOR_DARK,
                                        ),
                                        Text(
                                          "تفعيل",
                                          style: TextStyle(
                                            color:
                                                AppStyles.SECONDARY_COLOR_DARK,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: false,
                                          groupValue: provider
                                              .isCompetitionMusicEnabled,
                                          onChanged: (dynamic value) => provider
                                                  .isCompetitionMusicEnabled =
                                              value,
                                          activeColor:
                                              AppStyles.SECONDARY_COLOR_DARK,
                                        ),
                                        Text(
                                          "تعطيل",
                                          style: TextStyle(
                                            color:
                                                AppStyles.SECONDARY_COLOR_DARK,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveSize.getWidth(context, 0.08)),
                        RoundedContainer(
                          height: null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "تشغيل صوت الوقت في المسابقة",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: scaleHeight(8.0)),
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      AppStyles.SECONDARY_COLOR_DARK,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: true,
                                          groupValue: provider
                                              .isCompetitionTimerSoundEnabled,
                                          onChanged: (dynamic value) => provider
                                                  .isCompetitionTimerSoundEnabled =
                                              value,
                                          activeColor:
                                              AppStyles.SECONDARY_COLOR_DARK,
                                        ),
                                        Text(
                                          "تفعيل",
                                          style: TextStyle(
                                            color:
                                                AppStyles.SECONDARY_COLOR_DARK,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: false,
                                          groupValue: provider
                                              .isCompetitionTimerSoundEnabled,
                                          onChanged: (dynamic value) => provider
                                                  .isCompetitionTimerSoundEnabled =
                                              value,
                                          activeColor:
                                              AppStyles.SECONDARY_COLOR_DARK,
                                        ),
                                        Text(
                                          "تعطيل",
                                          style: TextStyle(
                                            color:
                                                AppStyles.SECONDARY_COLOR_DARK,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveSize.getWidth(context, 0.08)),
                        RoundedContainer(
                          height: null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "تشغيل صوت التكة في المسابقة",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: scaleHeight(8.0)),
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      AppStyles.SECONDARY_COLOR_DARK,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: true,
                                          groupValue: provider
                                              .isCompetitionClickSoundEnabled,
                                          onChanged: (dynamic value) => provider
                                                  .isCompetitionClickSoundEnabled =
                                              value,
                                          activeColor:
                                              AppStyles.SECONDARY_COLOR_DARK,
                                        ),
                                        Text(
                                          "تفعيل",
                                          style: TextStyle(
                                            color:
                                                AppStyles.SECONDARY_COLOR_DARK,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: false,
                                          groupValue: provider
                                              .isCompetitionClickSoundEnabled,
                                          onChanged: (dynamic value) => provider
                                                  .isCompetitionClickSoundEnabled =
                                              value,
                                          activeColor:
                                              AppStyles.SECONDARY_COLOR_DARK,
                                        ),
                                        Text(
                                          "تعطيل",
                                          style: TextStyle(
                                            color:
                                                AppStyles.SECONDARY_COLOR_DARK,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveSize.getWidth(context, 0.08)),
                        RoundedContainer(
                          height: null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "تغيير حجم النص",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: AppStyles.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: scaleHeight(8.0)),
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      AppStyles.SECONDARY_COLOR_DARK,
                                ),
                                child: Slider(
                                  value: provider.textScaleFactor,
                                  min: 0.1,
                                  max: 2.0,
                                  // divisions: 1,
                                  label: 'حجم الخط',
                                  onChanged: (double newValue) {
                                    provider.textScaleFactor = newValue;
                                  },
                                ),
                              ),
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
}
