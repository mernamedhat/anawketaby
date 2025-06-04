import 'package:anawketaby/extensions/list_extensions.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/screens/home_screens/competitions_list_screen/competitions_list_screen_provider.dart';
import 'package:anawketaby/ui/widgets/challenge_vertical_tile.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CompetitionsListScreen extends StatelessWidget {
  final String title;
  final Stream<dynamic> stream;

  const CompetitionsListScreen(
      {Key? key, required this.title, required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompetitionsListScreenProvider(),
      child:
          Consumer<CompetitionsListScreenProvider>(builder: (_, provider, __) {
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
                        "${this.title}",
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
                          image:
                              AssetImage("assets/images/custom_background.png"),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      child: StreamBuilder<dynamic>(
                        stream: this.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: EmptyListLoader());
                          } else {
                            List docs = [];

                            if (snapshot.data is List) {
                              for (final list in snapshot.data) {
                                docs.addAll(list.docs);
                              }
                              docs = docs.distinctBy(((e) => e.data()["id"]))
                                  as List<dynamic>;
                              docs.sort((a, b) => b
                                  .data()["timeStart"]
                                  .compareTo(a.data()["timeStart"]));
                            } else {
                              docs.addAll(snapshot.data!.docs);
                            }

                            if (docs.isEmpty)
                              return Center(
                                  child: EmptyListText(text: "لا توجد تحديات"));
                            else {
                              return ListView.separated(
                                  itemCount: docs.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: scaleHeight(12.0)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: scaleHeight(16.0)),
                                  itemBuilder: (_, index) {
                                    Competition competition =
                                        Competition.fromDocument(docs[index]);
                                    return ChallengeVerticalTile(
                                        competition: competition);
                                  });
                            }
                          }
                        },
                      ),
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
