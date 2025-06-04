import 'package:anawketaby/managements/topics_management.dart';
import 'package:anawketaby/models/topic.dart';
import 'package:anawketaby/providers_models/screens/topics_list_screen/topics_list_screen_provider.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/ui/widgets/topic_vertical_tile.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TopicsListScreen extends StatelessWidget {
  const TopicsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TopicsListScreenProvider(),
      child: Consumer<TopicsListScreenProvider>(builder: (_, provider, __) {
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
                        "الموضوعات",
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: TopicsManagement.instance.getTopics(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: EmptyListLoader());
                          } else {
                            if (snapshot.data!.docs.isEmpty)
                              return Center(
                                  child: EmptyListText(text: "لا توجد موضوعات"));
                            else {
                              return ListView.separated(
                                  itemCount: snapshot.data!.docs.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: scaleHeight(12.0)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: scaleHeight(16.0)),
                                  itemBuilder: (_, index) {
                                    Topic topic = Topic.fromDocument(
                                        snapshot.data!.docs[index]);
                                    return TopicVerticalTile(topic: topic);
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
