import 'package:anawketaby/extensions/list_extensions.dart';
import 'package:anawketaby/managements/groups_management.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/providers_models/screens/my_groups_screens/my_groups_list_screen/my_groups_list_screen_provider.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/ui/widgets/group_vertical_tile.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyGroupsListScreen extends StatelessWidget {
  const MyGroupsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyGroupsListScreenProvider(),
      child: Consumer<MyGroupsListScreenProvider>(builder: (_, provider, __) {
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
                        "مجموعاتي",
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
                        if (provider.appUser?.isServantOrLeaderOrPriest == true)
                          TextButton(
                            child: Text(
                              "مجموعة جديدة",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppStyles.PRIMARY_COLOR_DARK,
                              ),
                            ),
                            onPressed: provider.createNewGroup,
                          ),
                      ],
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
                        stream: GroupsManagement.instance
                            .getMyGroups(provider.appUser!),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: EmptyListLoader());
                          } else {
                            List docs = [];

                            if (snapshot.data is List) {
                              for (final list in snapshot.data) {
                                docs.addAll(list.docs);
                              }
                              docs = docs.distinctBy(
                                      ((e) => e.data()[AppGroup.ID_KEY]))
                                  as List<dynamic>;
                              docs.sort((a, b) => b
                                  .data()[AppGroup.TIME_CREATED_KEY]
                                  .compareTo(
                                      a.data()[AppGroup.TIME_CREATED_KEY]));
                            } else {
                              docs.addAll(snapshot.data!.docs);
                            }

                            if (docs.isEmpty)
                              return Center(
                                  child: EmptyListText(
                                      text: "لا توجد مجموعات خاصة بك"));
                            else {
                              return ListView.separated(
                                  itemCount: docs.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: scaleHeight(12.0)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: scaleHeight(16.0)),
                                  itemBuilder: (_, index) {
                                    AppGroup group =
                                        AppGroup.fromDocument(docs[index]);
                                    return GroupVerticalTile(
                                      group: group,
                                      afterNavigation: provider.notifyListeners,
                                    );
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
