import 'package:anawketaby/enums/points_history_type.dart';
import 'package:anawketaby/models/point_history.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PointHistoryVerticalTile extends StatelessWidget {
  final PointHistory? pointHistory;

  const PointHistoryVerticalTile({Key? key, this.pointHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            /*CachedImage(
              url: this.pointHistory.imageURL ?? defaultCompetitionImage,
              width: scaleWidth(140.0),
            ),*/
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AutoSizeText(
                      '${PointHistory.getPointHistoryTypeName(this.pointHistory!.type)}',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: AppStyles.TEXT_SECONDARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      '${getDateTime(this.pointHistory!.timeCreated!.toDate())}',
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
                            backgroundColor: (this.pointHistory!.points! > 0)
                                ? AppStyles.THIRD_COLOR
                                : AppStyles.SECONDARY_COLOR,
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  '${this.pointHistory!.points}',
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  minFontSize: 6.0,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                  ),
                                ),
                                SizedBox(width: scaleWidth(8.0)),
                                AutoSizeText(
                                  'نقطة',
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  minFontSize: 6.0,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: AppStyles.TEXT_PRIMARY_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (this.pointHistory!.type ==
                            PointsHistoryType.competition_winner)
                          SizedBox(width: scaleWidth(4.0)),
                        if (this.pointHistory!.type ==
                            PointsHistoryType.competition_winner)
                          Expanded(
                            child: RoundedContainer(
                              height: scaleHeight(40.0),
                              backgroundColor: AppStyles.SECONDARY_COLOR,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AutoSizeText(
                                    'المركز',
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    minFontSize: 6.0,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      color: AppStyles.TEXT_PRIMARY_COLOR,
                                    ),
                                  ),
                                  SizedBox(width: scaleWidth(8.0)),
                                  AutoSizeText(
                                    '${this.pointHistory!.place}',
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    minFontSize: 6.0,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      color: AppStyles.TEXT_PRIMARY_COLOR,
                                    ),
                                  ),
                                ],
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
    );
  }

  String getDateTime(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd');
    return timeFormatter.format(date);
  }
}
