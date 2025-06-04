import 'package:anawketaby/providers_models/screens/admin_screens/admin_main_screen_provider.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminMainScreenProvider(),
      child: Consumer<AdminMainScreenProvider>(builder: (_, provider, __) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SafeArea(
                    child: AppBar(
                      backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                      toolbarHeight: 75.0,
                      title: AutoSizeText(
                        "لوحة التحكم",
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
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          vertical: scaleHeight(16.0),
                          horizontal: scaleWidth(8.0)),
                      children: [
                        ElevatedButton(
                          onPressed: provider.createNewCompetition,
                          child: Text(
                            "مسابقة جديدة",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(55.0)),
                          ),
                        ),
                        SizedBox(height: scaleHeight(16.0)),
                        ElevatedButton(
                          onPressed: provider.myCreationCompetitions,
                          child: Text(
                            "مسابقاتي",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(55.0)),
                          ),
                        ),
                        SizedBox(height: scaleHeight(16.0)),
                        const Divider(),
                        SizedBox(height: scaleHeight(16.0)),
                        ElevatedButton(
                          onPressed: provider.createNewTopic,
                          child: Text(
                            "موضوع جديد",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(55.0)),
                          ),
                        ),
                        SizedBox(height: scaleHeight(16.0)),
                        ElevatedButton(
                          onPressed: provider.myCreationTopics,
                          child: Text(
                            "موضوعاتي",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(55.0)),
                          ),
                        ),
                        SizedBox(height: scaleHeight(16.0)),
                        const Divider(),
                        SizedBox(height: scaleHeight(16.0)),
                        ElevatedButton(
                          onPressed: provider.goToRequests,
                          child: Text(
                            "الطلبات",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(55.0)),
                          ),
                        ),
                        SizedBox(height: scaleHeight(16.0)),
                        const Divider(),
                        SizedBox(height: scaleHeight(16.0)),
                        ElevatedButton(
                          onPressed: provider.goToGroups,
                          child: Text(
                            "المجموعات",
                            style: const TextStyle(
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppStyles.PRIMARY_COLOR, backgroundColor: AppStyles.PRIMARY_COLOR_DARK, minimumSize: Size(double.infinity, scaleHeight(55.0)),
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
