import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_participant_individual.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ParticipantIndividualItem extends StatelessWidget {
  final Competition competition;

  final int index;
  final CompetitionParticipantIndividual participant;

  const ParticipantIndividualItem({
    Key? key,
    required this.competition,
    required this.index,
    required this.participant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => navigateToProfile(participant.id),
      child: Column(
        children: [
          Row(
            children: [
              RoundedContainer(
                height: scaleHeight(35.0),
                width: scaleWidth(35.0),
                padding: EdgeInsets.symmetric(
                    vertical: scaleHeight(2.0), horizontal: scaleWidth(2.0)),
                backgroundColor: AppStyles.TEXT_PRIMARY_COLOR,
                child: AutoSizeText(
                  "$index",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppStyles.PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: scaleWidth(16.0)),
              ClipRRect(
                borderRadius: BorderRadius.circular(35.0),
                child: (participant.profilePhotoURL != null)
                    ? CachedImage(
                        url: "${participant.profilePhotoURL}",
                        height: scaleHeight(70.0),
                        width: scaleWidth(70.0),
                      )
                    : Container(
                        color: Colors.white,
                        child: Image.asset(
                          "assets/images/default_profile.png",
                          fit: BoxFit.contain,
                          height: scaleHeight(70.0),
                          width: scaleWidth(70.0),
                        ),
                      ),
              ),
              SizedBox(width: scaleWidth(16.0)),
              Expanded(
                child: AutoSizeText(
                  "${participant.fullName}",
                  maxLines: 1,
                  minFontSize: 6.0,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: scaleWidth(4.0)),
              RoundedContainer(
                height: scaleHeight(35.0),
                width: scaleWidth(35.0),
                padding: EdgeInsets.symmetric(
                    vertical: scaleHeight(2.0), horizontal: scaleWidth(2.0)),
                backgroundColor: Colors.amber,
                child: AutoSizeText(
                  (competition.totalPoints == null)
                      ? "${participant.points}"
                      : "%${((participant.points! / competition.totalPoints!) * 100).toStringAsFixed(2).replaceAll(RegExp(r'\.{1}0{1,}'), '')}",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  minFontSize: 6.0,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppStyles.PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: AppStyles.SELECTION_COLOR_DARK),
        ],
      ),
    );
  }
}
