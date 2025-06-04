import 'package:anawketaby/models/topic.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/ui/screens/topic_details_screen/topic_details_screen.dart';
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

class TopicVerticalTile extends StatelessWidget {
  final Topic? topic;

  const TopicVerticalTile({Key? key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? defaultCompetitionImage =
        Provider.of<SettingsProvider>(Get.context!).defaultCompetitionImageURL;

    return InkWell(
      onTap: () =>  navigateTo(TopicDetailsScreen(topic: topic)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RoundedContainer(
          height: scaleHeight(160.0),
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
                url: this.topic!.imageURL ?? defaultCompetitionImage,
                width: scaleWidth(140.0),
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AutoSizeText(
                        '${this.topic!.name}',
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: AppStyles.TEXT_SECONDARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AutoSizeText(
                        '${topic!.competitionsIDs.length} مسابقات',
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
                                '${this.topic!.followers!.length}  متابع',
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
                                  navigateToProfile(this.topic!.creatorID),
                              child: RoundedContainer(
                                height: scaleHeight(40.0),
                                backgroundColor: AppStyles.SECONDARY_COLOR,
                                child: SizedBox(
                                  height: scaleHeight(20.0),
                                  child: AutoSizeText(
                                    '${this.topic!.creatorFullName}',
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
