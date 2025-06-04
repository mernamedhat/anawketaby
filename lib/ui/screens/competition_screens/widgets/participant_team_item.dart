import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_participant_team.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ParticipantTeamItem extends StatefulWidget {
  final Competition competition;

  final int index;
  final CompetitionParticipantTeam participant;

  const ParticipantTeamItem({
    Key? key,
    required this.competition,
    required this.index,
    required this.participant,
  }) : super(key: key);

  @override
  State<ParticipantTeamItem> createState() => _ParticipantTeamItemState();
}

class _ParticipantTeamItemState extends State<ParticipantTeamItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
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
                  "${widget.index}",
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
                child: (widget.participant.imageURL != null)
                    ? CachedImage(
                        url: "${widget.participant.imageURL}",
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
                  "${widget.participant.name}",
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
                  (widget.competition.totalPoints == null)
                      ? "${widget.participant.points}"
                      : "%${((widget.participant.points! / widget.competition.totalPoints!) * 100).toStringAsFixed(2).replaceAll(RegExp(r'\.{1}0{1,}'), '')}",
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
          if (_expanded) ...[
            ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 12.0,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: widget.participant.membersIDs
                  .map((e) => _memberItem(e))
                  .toList(),
            ),
          ],
          Divider(color: AppStyles.SELECTION_COLOR_DARK),
        ],
      ),
    );
  }

  Widget _memberItem(String memberID) {
    Map memberMap = widget.participant.membersProfiles[memberID];

    return InkWell(
      onTap: () => navigateToProfile(memberID),
      child: RoundedContainer(
        backgroundColor: AppStyles.BACKGROUND_COLOR.withAlpha(30),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(35.0),
              child: (memberMap["profilePhotoURL"] != null)
                  ? CachedImage(
                      url: "${memberMap["profilePhotoURL"]}",
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
                "${memberMap["fullName"]}",
                maxLines: 1,
                minFontSize: 6.0,
                style: TextStyle(
                  fontSize: 20.0,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (memberID == widget.participant.leaderID)
              RoundedContainer(
                height: scaleHeight(35.0),
                width: scaleWidth(60.0),
                padding: EdgeInsets.symmetric(
                    vertical: scaleHeight(2.0), horizontal: scaleWidth(2.0)),
                backgroundColor: Colors.blue,
                child: Text(
                  "القائد",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: AppStyles.TEXT_PRIMARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
