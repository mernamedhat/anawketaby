import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/ui/screens/my_groups_screens/group_info_screen/group_info_screen.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupVerticalTile extends StatelessWidget {
  final AppGroup group;
  final bool fromStartCompetition;
  final bool isFromAdmin;
  final Function()? afterNavigation;

  const GroupVerticalTile({
    Key? key,
    required this.group,
    this.fromStartCompetition = false,
    this.isFromAdmin = false,
    this.afterNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? defaultCompetitionImage =
        Provider.of<SettingsProvider>(Get.context!).defaultCompetitionImageURL;

    return InkWell(
      onTap: (fromStartCompetition)
          ? null
          : () async {
              await navigateTo(GroupInfoScreen(
                group: group,
                isFromAdmin: isFromAdmin,
              ));
              if (afterNavigation != null) {
                afterNavigation!();
              }
            },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: (fromStartCompetition) ? 0.0 : 8.0),
        child: RoundedContainer(
          height: scaleHeight((fromStartCompetition) ? 105.0 : 160.0),
          padding: EdgeInsets.zero,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 3),
              blurRadius: 4.0,
            ),
          ],
          child: Row(
            children: [
              CachedImage(
                url: this.group.imageURL ?? defaultCompetitionImage,
                width: scaleWidth((fromStartCompetition) ? 60.0 : 140.0),
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: (fromStartCompetition)
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AutoSizeText(
                        '${this.group.name}',
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: (fromStartCompetition) ? 16.0 : 24.0,
                          color: AppStyles.TEXT_SECONDARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (fromStartCompetition) ...[
                        const SizedBox(height: 4.0),
                        AutoSizeText(
                          'القائد: ${group.leaderFullName}',
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        AutoSizeText(
                          'عدد الأعضاء: ${group.membersIDs.length}',
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                      ] else ...[
                        AutoSizeText(
                          '${group.createdCompetitions.length} مسابقات',
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: AppStyles.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: RoundedContainer(
                                height: scaleHeight(40.0),
                                backgroundColor: AppStyles.SECONDARY_COLOR,
                                padding: EdgeInsets.all(10.0),
                                child: AutoSizeText(
                                  '${this.group.membersIDs.length}  عضو',
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  minFontSize: 6.0,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: scaleWidth(4.0)),
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    navigateToProfile(this.group.creatorID),
                                child: RoundedContainer(
                                  height: scaleHeight(40.0),
                                  backgroundColor: AppStyles.SECONDARY_COLOR,
                                  child: SizedBox(
                                    height: scaleHeight(20.0),
                                    child: AutoSizeText(
                                      '${this.group.leaderFullName}',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      minFontSize: 6.0,
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: AppStyles.TEXT_PRIMARY_COLOR,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getDateTime(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd');
    return timeFormatter.format(date);
  }
}
