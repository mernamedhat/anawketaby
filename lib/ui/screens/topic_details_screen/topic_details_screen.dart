import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/topic.dart';
import 'package:anawketaby/providers_models/screens/topic_details_screen/topic_details_screen_provider.dart';
import 'package:anawketaby/ui/widgets/challenge_vertical_tile.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TopicDetailsScreen extends StatelessWidget {
  final Topic? topic;

  const TopicDetailsScreen({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TopicDetailsScreenProvider(),
      child: Consumer<TopicDetailsScreenProvider>(builder: (_, provider, __) {
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
                        "${topic!.name}",
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
                      actions: [
                        if (provider.appUser!.firebaseUser!.uid ==
                            topic!.creatorID)
                          TextButton(
                            child: Text(
                              "تعديل",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppStyles.PRIMARY_COLOR,
                              ),
                            ),
                            onPressed: () => provider.editTopic(topic),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "المسئول: ${topic!.creatorFullName}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 18.0),
                            Text(
                              "الوصف",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "${topic!.description}",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  var text = "تابع معنا موضوع (${topic!.name})";
                                  text += "\n";
                                  text += "على تطبيق أنا وكتابي";
                                  text += "\n";
                                  text += "من خلال الرابط";
                                  text += "\n";
                                  text += "http://app.anawketaby.com/t/${topic!.id}";
                                  Share.share(text);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                                  backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                                  minimumSize: Size(160.0, scaleHeight(40.0)), // Width & Height
                                ),
                                child: const Text(
                                  "مشاركة الموضوع",
                                  style: TextStyle(
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            )
,
                            const SizedBox(height: 18.0),
                            if (topic!.isAbleFollowing! &&
                                provider.appUser!.firebaseUser!.uid !=
                                    topic!.creatorID) ...[
                              Text(
                                "المتابعة",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "لمتابعة المسابقات لهذا الموضوع ويصلك كل ما هو جديد، يرجى الضغط على زر المتابعة.",
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(height: 18.0),
                              Center(
                                child: (provider.followingLoading)
                                    ? const CircularProgressIndicator()
                                    : (!topic!.followers!.contains(provider.appUser!.id))
                                    ? ElevatedButton(
                                  onPressed: () => provider.followTopic(topic!),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                                    backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                                    minimumSize: Size(120.0, scaleHeight(40.0)), // Width & Height
                                  ),
                                  child: const Text(
                                    "متابعة",
                                    style: TextStyle(
                                      color: AppStyles.TEXT_PRIMARY_COLOR,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )
                                    : ElevatedButton(
                                  onPressed: () => provider.unfollowTopic(topic!),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                                    backgroundColor: AppStyles.SECONDARY_COLOR_DARK, // Button background color
                                    minimumSize: Size(120.0, scaleHeight(40.0)), // Width & Height
                                  ),
                                  child: const Text(
                                    "إلغاء المتابعة",
                                    style: TextStyle(
                                      color: AppStyles.TEXT_PRIMARY_COLOR,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              )
                              ,
                              const SizedBox(height: 18.0),
                            ],
                            if (topic!.resultURL != null) ...[
                              Text(
                                "النتيجة",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "لمشاهدة النتيجة يرجى الضغط على زر النتيجة.",
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(height: 18.0),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () => provider.openResult(topic!),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, // Text color
                                    backgroundColor: AppStyles.THIRD_COLOR_DARK, // Button background color
                                    minimumSize: Size(120.0, scaleHeight(40.0)), // Width & Height
                                  ),
                                  child: const Text(
                                    "النتيجة",
                                    style: TextStyle(
                                      color: AppStyles.TEXT_PRIMARY_COLOR,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18.0),
                            ],
                            Text(
                              "المسابقات",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            FutureBuilder<List<Competition>>(
                              future: CompetitionManagement.instance
                                  .getCompetitionsByIDs(topic!.competitionsIDs),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: EmptyListLoader());
                                } else {
                                  if (snapshot.data!.isEmpty)
                                    return Center(
                                        child: EmptyListText(
                                            text: "لا توجد مسابقات"));
                                  else {
                                    return ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: scaleHeight(12.0)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: scaleHeight(16.0)),
                                        itemBuilder: (_, index) {
                                          return ChallengeVerticalTile(
                                              competition:
                                                  snapshot.data![index]);
                                        });
                                  }
                                }
                              },
                            ),
                          ],
                        ),
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
