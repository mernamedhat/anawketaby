import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChallengeTile extends StatelessWidget {
  final Competition? competition;
  final Function? onTap;

  const ChallengeTile({Key? key, this.competition, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? defaultCompetitionImage =
        Provider.of<SettingsProvider>(Get.context!).defaultCompetitionImageURL;

    return InkWell(
      onTap: this.onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedImage(
                  url: this.competition!.imageURL ?? defaultCompetitionImage,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: scaleHeight(60.0),
                  width: scaleWidth(170.0),
                  color: Color(0x80000000),
                  padding: const EdgeInsets.all(4.0),
                  child: AutoSizeText(
                    '${this.competition!.name}',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: AppStyles.TEXT_PRIMARY_COLOR,
                    ),
                    maxLines: 2,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
