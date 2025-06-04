import 'package:anawketaby/models/point_history.dart';
import 'package:anawketaby/providers_models/screens/account_screens/points_history_list_screen/points_history_list_screen.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/ui/widgets/point_history_vertical_tile.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PointsHistoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PointsHistoryListScreenProvider(),
      child:
          Consumer<PointsHistoryListScreenProvider>(builder: (_, provider, __) {
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
                        "سجل النقاط",
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
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/custom_background.png"),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        child: (provider.appUser!.pointsHistory.isEmpty)
                            ? Center(child: EmptyListText())
                            : ListView.separated(
                                itemCount:
                                    provider.appUser!.pointsHistory.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: scaleHeight(12.0)),
                                padding: EdgeInsets.symmetric(
                                    vertical: scaleHeight(16.0)),
                                itemBuilder: (_, index) {
                                  PointHistory pointHistory =
                                      PointHistory.fromJson(provider
                                          .appUser!.pointsHistory[index]);
                                  return PointHistoryVerticalTile(
                                      pointHistory: pointHistory);
                                })),
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
