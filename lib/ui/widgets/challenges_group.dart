import 'package:anawketaby/extensions/list_extensions.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/ui/widgets/challenge_tile.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class ChallengesGroup extends StatelessWidget {
  final String title;
  final Function moreOnTap;
  final Stream stream;

  final ScrollController _controller =
      ScrollController(initialScrollOffset: scaleWidth(28.0));

  ChallengesGroup({
    Key? key,
    required this.title,
    required this.moreOnTap,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${this.title}",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: this.moreOnTap as void Function()?,
                // padding: const EdgeInsets.all(0.0),
                child: Text(
                  "عرض الكل",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: scaleHeight(10.0)),
        Container(
          height: scaleHeight(220.0),
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
                  docs =
                      docs.distinctBy(((e) => e.data()["id"])) as List<dynamic>;
                  docs.sort((a, b) =>
                      b.data()["timeStart"].compareTo(a.data()["timeStart"]));
                  if (docs.length > 5) {
                    docs.removeRange(4, docs.length - 1);
                  }
                } else {
                  docs.addAll(snapshot.data.docs);
                }

                if (docs.isEmpty)
                  return Center(child: EmptyListText(text: "لا توجد تحديات"));
                else {
                  return ListView(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    children: docs.map<Widget>((doc) {
                      Competition competition = Competition.fromDocument(doc);

                      return ChallengeTile(
                        competition: competition,
                        onTap: () => navigateToCompetition(competition),
                      );
                    }).toList(),
                  );
                }
              }
            },
          ),
        ),
        Divider(),
      ],
    );
  }
}
