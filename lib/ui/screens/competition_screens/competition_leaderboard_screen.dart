import 'dart:io';
import 'dart:math';

import 'package:anawketaby/enums/competition_type.dart';
import 'package:anawketaby/enums/competition_winner.dart';
import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_participant_individual.dart';
import 'package:anawketaby/models/competition_participant_team.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/ui/widgets/cached_image.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:social_share/social_share.dart';

class CompetitionLeaderboardScreen extends StatefulWidget {
  final Competition competition;

  CompetitionLeaderboardScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  State<CompetitionLeaderboardScreen> createState() =>
      _CompetitionLeaderboardScreenState();
}

class _CompetitionLeaderboardScreenState
    extends State<CompetitionLeaderboardScreen> with TickerProviderStateMixin {
  late final AnimationController _backgroundRotationController =
      AnimationController(vsync: this, duration: Duration(seconds: 10))
        ..repeat();
  late final AnimationController _congratulationsSizingController =
      AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
    reverseDuration: Duration(milliseconds: 500),
    lowerBound: 0.5,
  )..repeat(reverse: true);

  final ScreenshotController screenshotController = ScreenshotController();

  final appSettings =
      Provider.of<SettingsProvider>(Get.context!, listen: false).appSettings;

  final AudioPlayer player =
      Provider.of<SettingsProvider>(Get.context!, listen: false).player;
  final AudioPlayer playerMusic =
      Provider.of<SettingsProvider>(Get.context!, listen: false).playerMusic;

  List _winners = [];

  int _seconds = 0;

  bool _showExit = true;
  bool _showShare = false;

  bool _showCompetitionName = false;

  bool _congratulationsShow = false;
  bool _congratulationsAnimateToTop = false;

  bool _fireworksShow = false;

  bool _thirdPlaceAnimateFromBottom = false;
  bool _thirdPlacePerson = false;
  bool _thirdPlaceAnimateToSide = false;

  bool _secondPlaceAnimateFromBottom = false;
  bool _secondPlacePerson = false;
  bool _secondPlaceAnimateToSide = false;

  bool _firstPlaceAnimateFromBottom = false;
  bool _firstPlacePerson = false;
  bool _firstPlaceAnimateToSide = false;

  @override
  void initState() {
    super.initState();
    _getWinners();
  }

  Future _getWinners() async {
    try {
      _winners.addAll(
          await CompetitionManagement.instance.getWinners(widget.competition));
      if (!mounted) return;
      setState(() {});
      _startAnimation();
    } catch (_) {
      Navigator.pop(context);
    }
  }

  void _startAnimation() {
    _playMusic();

    Future.delayed(const Duration(minutes: 2, seconds: 30),
        () => _backgroundRotationController.stop());

    _seconds += 2;
    Future.delayed(Duration(seconds: _seconds), () {
      if (!mounted) return;
      setState(() {
        _showCompetitionName = true;
      });
    });

    _seconds += 2;
    Future.delayed(Duration(seconds: _seconds), () {
      if (!mounted) return;
      _playFireworks();
      setState(() {
        _fireworksShow = true;
        _congratulationsShow = true;
      });
    });

    _seconds += 4;
    Future.delayed(Duration(seconds: _seconds), () {
      if (!mounted) return;
      setState(() {
        _fireworksShow = false;
        _congratulationsSizingController.stop();
        _congratulationsAnimateToTop = true;
      });
    });

    if (widget.competition.competitionWinner == CompetitionWinner.one ||
        widget.competition.winnersIDs?.length == 1) {
      _seconds += 2;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        setState(() {
          _firstPlaceAnimateFromBottom = true;
        });
      });
      _seconds += 4;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        _playFireworks();
        setState(() {
          _fireworksShow = true;
          _firstPlacePerson = true;
        });
      });
      _seconds += 6;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        player.stop();
        setState(() {
          _fireworksShow = false;
          _firstPlaceAnimateToSide = true;
        });
      });
    } else if (widget.competition.competitionWinner ==
            CompetitionWinner.three &&
        widget.competition.winnersIDs?.length == 2) {
      _seconds += 2;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        setState(() {
          _secondPlaceAnimateFromBottom = true;
        });
      });
      _seconds += 4;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        _playFireworks();
        setState(() {
          _fireworksShow = true;
          _secondPlacePerson = true;
        });
      });
      _seconds += 6;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        player.stop();
        setState(() {
          _fireworksShow = false;
          _secondPlaceAnimateToSide = true;
        });
      });

      _seconds += 4;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        setState(() {
          _firstPlaceAnimateFromBottom = true;
        });
      });
      _seconds += 4;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        _playFireworks();
        setState(() {
          _fireworksShow = true;
          _firstPlacePerson = true;
        });
      });
      _seconds += 6;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        player.stop();
        setState(() {
          _fireworksShow = false;
          _firstPlaceAnimateToSide = true;
        });
      });
    } else {
      _seconds += 2;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        setState(() {
          _thirdPlaceAnimateFromBottom = true;
        });
      });
      _seconds += 4;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        _playFireworks();
        setState(() {
          _fireworksShow = true;
          _thirdPlacePerson = true;
        });
      });
      _seconds += 6;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        player.stop();
        setState(() {
          _fireworksShow = false;
          _thirdPlaceAnimateToSide = true;
        });
      });

      _seconds += 4;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        setState(() {
          _secondPlaceAnimateFromBottom = true;
        });
      });
      _seconds += 4;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        _playFireworks();
        setState(() {
          _fireworksShow = true;
          _secondPlacePerson = true;
        });
      });
      _seconds += 6;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        player.stop();
        setState(() {
          _fireworksShow = false;
          _secondPlaceAnimateToSide = true;
        });
      });

      _seconds += 4;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        setState(() {
          _firstPlaceAnimateFromBottom = true;
        });
      });
      _seconds += 4;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        _playFireworks();
        setState(() {
          _fireworksShow = true;
          _firstPlacePerson = true;
        });
      });
      _seconds += 6;
      Future.delayed(Duration(seconds: _seconds), () {
        if (!mounted) return;
        setState(() {
          _fireworksShow = false;
          _firstPlaceAnimateToSide = true;
        });
      });
    }

    _seconds += 2;
    Future.delayed(Duration(seconds: _seconds), () {
      if (!mounted) return;
      setState(() {
        _showShare = true;
      });
    });
  }

  void _playMusic() async {
    await playerMusic.setAsset("assets/sounds/winners_music.mp3");
    playerMusic.setLoopMode(LoopMode.off);
    playerMusic.play();
  }

  void _playFireworks() async {
    await player.setAsset("assets/sounds/fireworks_effect.mp3");
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppStyles.PRIMARY_COLOR_DARK,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppStyles.PRIMARY_COLOR_DARK,
      ),
      child: WillPopScope(
        onWillPop: () => Future.value(_showShare),
        child: Scaffold(
          body: Screenshot(
            controller: screenshotController,
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: AppStyles.PRIMARY_COLOR,
              child: (_winners.length == 0)
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: AnimatedBuilder(
                              animation: _backgroundRotationController,
                              builder: (_, child) {
                                return Transform.rotate(
                                  angle: _backgroundRotationController.value *
                                      2 *
                                      pi,
                                  child: Image.asset(
                                    "assets/images/leaderboard_background.png",
                                  ),
                                );
                              }),
                        ),
                        Positioned.fill(
                          child: AnimatedOpacity(
                            opacity: (_fireworksShow) ? 1.0 : 0.0,
                            duration: const Duration(seconds: 1),
                            child: Image.asset('assets/images/fireworks.gif'),
                          ),
                        ),
                        if (_showExit)
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "خروج",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (_showShare)
                          Positioned(
                            top: 32.0,
                            right: 8.0,
                            child: InkWell(
                              onTap: _shareResult,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 2.0),
                                  Text(
                                    "مشاركة",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_congratulationsShow)
                          AnimatedAlign(
                            alignment: (_congratulationsAnimateToTop)
                                ? Alignment.topCenter
                                : Alignment.center,
                            duration: const Duration(seconds: 1),
                            child: AnimatedBuilder(
                                animation: _congratulationsSizingController,
                                builder: (_, child) {
                                  return Transform.scale(
                                    scale: (_congratulationsAnimateToTop)
                                        ? 1.0
                                        : _congratulationsSizingController
                                                .value *
                                            1.5,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: (_congratulationsAnimateToTop)
                                            ? 32.0
                                            : 0.0,
                                      ),
                                      child: RoundedContainer(
                                        width: (_congratulationsAnimateToTop)
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                        height: (_congratulationsAnimateToTop)
                                            ? 40.0
                                            : 60.0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 4.0,
                                        ),
                                        backgroundColor: Colors.white30,
                                        child: AutoSizeText(
                                          "ألف مبروك",
                                          maxLines: 2,
                                          minFontSize: 6.0,
                                          style: TextStyle(
                                            fontSize:
                                                (_congratulationsAnimateToTop)
                                                    ? 18.0
                                                    : 32.0,
                                            color: Color(0xFF003867),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        Positioned.fill(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AnimatedOpacity(
                                      opacity:
                                          (_showCompetitionName) ? 1.0 : 0.0,
                                      duration: const Duration(seconds: 2),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            (widget.competition
                                                        .competitionWinner ==
                                                    CompetitionWinner.one)
                                                ? "فائز المسابقة"
                                                : "فائزين مسابقة",
                                            maxLines: 2,
                                            minFontSize: 6.0,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color:
                                                  AppStyles.TEXT_PRIMARY_COLOR,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RoundedContainer(
                                              width: null,
                                              height: null,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 4.0,
                                              ),
                                              backgroundColor: Colors.white10,
                                              child: AutoSizeText(
                                                "${widget.competition.name}",
                                                maxLines: 2,
                                                minFontSize: 6.0,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 24.0,
                                                  color: AppStyles
                                                      .TEXT_PRIMARY_COLOR,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 60),
                                  child: Stack(
                                    children: [
                                      if (_winners.length == 3)
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: AnimatedOpacity(
                                            opacity: ((_secondPlaceAnimateFromBottom &&
                                                        !_secondPlaceAnimateToSide) ||
                                                    (_firstPlaceAnimateFromBottom &&
                                                        !_firstPlaceAnimateToSide))
                                                ? 0.0
                                                : 1.0,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: _winnerPlatform(
                                              3,
                                              _thirdPlaceAnimateFromBottom,
                                              _thirdPlaceAnimateToSide,
                                              _thirdPlacePerson,
                                            ),
                                          ),
                                        ),
                                      if (_winners.length >= 2)
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: AnimatedOpacity(
                                            opacity:
                                                (_firstPlaceAnimateFromBottom &&
                                                        !_firstPlaceAnimateToSide)
                                                    ? 0.0
                                                    : 1.0,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: _winnerPlatform(
                                              2,
                                              _secondPlaceAnimateFromBottom,
                                              _secondPlaceAnimateToSide,
                                              _secondPlacePerson,
                                            ),
                                          ),
                                        ),
                                      if (_winners.length >= 1)
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: _winnerPlatform(
                                            1,
                                            _firstPlaceAnimateFromBottom,
                                            _firstPlaceAnimateToSide,
                                            _firstPlacePerson,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _winnerPlatform(
    int order,
    bool placeAnimateFromBottom,
    bool placeAnimateToSide,
    bool placePerson,
  ) {
    return AnimatedContainer(
      height: (placeAnimateFromBottom) ? MediaQuery.of(context).size.height : 0,
      width: (placeAnimateToSide)
          ? (MediaQuery.of(context).size.width - 60) / 3
          : MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        top: (order == 1)
            ? 0.0
            : (order == 2)
                ? 40.0
                : 80.0,
      ),
      duration: const Duration(seconds: 2),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          AnimatedOpacity(
            opacity: (placePerson) ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: Column(
              children: [
                RoundedContainer(
                  width: null,
                  height: null,
                  padding: const EdgeInsets.all(4.0),
                  backgroundColor: Colors.black26,
                  child: AutoSizeText(
                    "${_getWinnerName(_winners[order - 1])}",
                    maxLines: 2,
                    minFontSize: 6.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: AppStyles.TEXT_PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: scaleHeight(12.0)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(35.0),
                  child: (_getWinnerImage(_winners[order - 1]) != null)
                      ? CachedImage(
                          url: "${_getWinnerImage(_winners[order - 1])}",
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
              ],
            ),
          ),
          SizedBox(height: scaleHeight(12.0)),
          Expanded(
            child: Material(
              elevation: 20.0,
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                color: (order == 1)
                    ? Color(0xFFFFD700)
                    : (order == 2)
                        ? Color(0xFFC0C0C0)
                        : Color(0xFFCD7F32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8.0),
                    _orderWidget(order),
                    const SizedBox(height: 20.0),
                    AnimatedOpacity(
                      opacity: (placePerson) ? 1.0 : 0.0,
                      duration: const Duration(seconds: 2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: RoundedContainer(
                          width: null,
                          height: null,
                          padding: const EdgeInsets.all(4.0),
                          backgroundColor: Colors.black12,
                          child: AutoSizeText(
                            _getWinnerPoints(_winners[order - 1]),
                            maxLines: 1,
                            minFontSize: 6.0,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: AppStyles.TEXT_PRIMARY_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (order == 1) ...[
                      const SizedBox(height: 32.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Image.asset(
                          "assets/images/logo_named_transparent.png",
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderWidget(int order) {
    return Material(
      elevation: 20.0,
      color: Colors.transparent,
      child: Stack(
        children: [
          ClipPath(
            clipper: MyPolygon(),
            child: Container(
              height: scaleHeight(60),
              width: scaleHeight(60),
              color: AppStyles.APP_MATERIAL_COLOR,
              alignment: Alignment.bottomCenter,
              child: AutoSizeText(
                "$order",
                maxLines: 1,
                minFontSize: 6.0,
                style: TextStyle(
                  fontSize: 38.0,
                  color: AppStyles.TEXT_PRIMARY_COLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: MyPolygonBorder(),
            child: Container(
              height: scaleHeight(60),
              width: scaleHeight(60),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    playerMusic.stop();
    player.stop();
    _backgroundRotationController.dispose();
    _congratulationsSizingController.dispose();
    super.dispose();
  }

  String? _getWinnerName(winner) {
    if (widget.competition.competitionType == CompetitionType.individual) {
      return (winner as CompetitionParticipantIndividual)
          .fullName
          ?.split(" ")
          .first;
    } else {
      return (winner as CompetitionParticipantTeam).name;
    }
  }

  String? _getWinnerImage(winner) {
    if (widget.competition.competitionType == CompetitionType.individual) {
      return (winner as CompetitionParticipantIndividual).profilePhotoURL;
    } else {
      return (winner as CompetitionParticipantTeam).imageURL;
    }
  }

  String _getWinnerPoints(winner) {
    if (widget.competition.totalPoints == null) {
      return winner.points.toString();
    } else {
      return "%${((winner.points! / widget.competition.totalPoints!) * 100).toStringAsFixed(2).replaceAll(RegExp(r'\.{1}0{1,}'), '')}";
    }
  }

  Future _shareResult() async {
    setState(() {
      _showExit = false;
      _showShare = false;
    });

    Uint8List? imageList = await screenshotController.capture();
    if (imageList != null) {
      final directory = await getApplicationDocumentsDirectory();
      final file = await File('${directory.path}/temp.png').create();
      await file.writeAsBytes(imageList);

      String text = "نتيجة مسابقة ";
      text += "${widget.competition.name}";
      text += "\n";
      text += "رابط المسابقة: ";
      text += "${widget.competition.url}";

      text += "\n";
      text += "شاهد الان نتيجة المسابقة ❤";

      // SocialShare.shareOptions(text, imagePath: file.path);
    }

    setState(() {
      _showExit = true;
      _showShare = true;
    });
  }
}

class MyPolygon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addPolygon([
      Offset(0, size.height * 1 / 3),
      Offset(size.width / 2, 0),
      Offset(size.width, size.height * 1 / 3),
      Offset(size.width * 4 / 5, size.height),
      Offset(size.width * 1 / 5, size.height),
    ], true);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MyPolygonBorder extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.addPolygon([
      Offset(0, size.height * 1 / 3),
      Offset(size.width / 2, 0),
      Offset(size.width, size.height * 1 / 3),
      Offset(size.width * 4 / 5, size.height),
      Offset(size.width * 1 / 5, size.height),
    ], true);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
