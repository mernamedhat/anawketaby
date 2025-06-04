import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
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

class ChallengeVerticalTile extends StatelessWidget {
  final Competition? competition;

  const ChallengeVerticalTile({Key? key, this.competition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? defaultCompetitionImage =
        Provider.of<SettingsProvider>(Get.context!).defaultCompetitionImageURL;

    return InkWell(
      onTap: () => navigateToCompetition(this.competition!),
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
                url: this.competition!.imageURL ?? defaultCompetitionImage,
                width: scaleWidth(140.0),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AutoSizeText(
                        '${this.competition!.name}',
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: AppStyles.TEXT_SECONDARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AutoSizeText(
                        '${getDateTime(this.competition!.timeStart!.toDate())}',
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
                                '${this.competition!.participantsCount}  مشترك',
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
                                  navigateToProfile(this.competition!.creatorID),
                              child: RoundedContainer(
                                height: scaleHeight(40.0),
                                backgroundColor: AppStyles.SECONDARY_COLOR,
                                child: SizedBox(
                                  height: scaleHeight(20.0),
                                  child: AutoSizeText(
                                    '${this.competition!.creatorFullName}',
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
