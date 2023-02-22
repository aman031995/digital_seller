import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/view/CustomPlayer/StreamPlayer.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/CommonWidget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerSection extends StatefulWidget {
  String? videoID;
  bool? isDetail;
  VideoList? platformMovieData;

  YouTubePlayerSection({this.videoID, this.isDetail,this.platformMovieData});

  @override
  _YouTubePlayerSectionState createState() => _YouTubePlayerSectionState();
}

class _YouTubePlayerSectionState extends State<YouTubePlayerSection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  YoutubePlayerController? _controller;
  TextEditingController? _idController;
  TextEditingController? _seekToController;
  PlayerState? _playerState;
  YoutubeMetaData? _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    // String? foo = getIdFromUrl(widget.videoID ?? '');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoID ?? '',
      flags:  YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: true,
        loop: true,
        // isLive: true,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
      setState(() {
        _playerState = _controller?.value.playerState;
        _videoMetaData = _controller?.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _idController?.dispose();
    _seekToController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<YoutubeProvider>(context);
    if (state.isPlay == false) {
      _controller?.pause();
    }
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: OrientationBuilder(builder:
          (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return Scaffold(
            body: youtubeHierarchy(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(""),
            ),
            body: youtubeHierarchy(),
          );
        }
      }),
    );
    // return YoutubePlayerBuilder(
    //   onExitFullScreen: () {
    //     SystemChrome.setPreferredOrientations(
    //         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //   },
    //   onEnterFullScreen: () {
    //     SystemChrome.setPreferredOrientations(
    //         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //   },
    //   player: YoutubePlayer(
    //     aspectRatio: widget.isDetail == true ? 10 / 3 : 16 / 9,
    //     controller: _controller!,
    //     bottomActions: [
    //       const SizedBox(width: 14.0),
    //       CurrentPosition(),
    //       const SizedBox(width: 8.0),
    //       ProgressBar(
    //         isExpanded: true,
    //         colors: ProgressBarColors(
    //             bufferedColor: THEME_COLOR,
    //             handleColor: THEME_COLOR,
    //             playedColor: YELLOW_COLOR,
    //             backgroundColor: FAMILY_GRADIENT),
    //       ),
    //       RemainingDuration(),
    //       // const PlaybackSpeedButton(),
    //     ],
    //     topActions: <Widget>[
    //       const SizedBox(width: 15.0),
    //       Expanded(
    //         child: Text(
    //           _controller!.metadata.title,
    //           style: const TextStyle(
    //             color: WHITE_COLOR,
    //             fontSize: 18.0,
    //           ),
    //           overflow: TextOverflow.ellipsis,
    //           maxLines: 1,
    //         ),
    //       ),
    //     ],
    //     onReady: () {
    //       _isPlayerReady = true;
    //     },
    //     onEnded: (data) {
    //       // _controller.load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
    //       _controller?.reload();
    //       _showSnackBar('Next Video');
    //     },
    //   ),
    //   builder: (context, player) => Scaffold(
    //     backgroundColor: WHITE_COLOR,
    //     key: _scaffoldKey,
    //     body: widget.isDetail == true
    //         ? player
    //         : Stack(children: [
    //             Center(
    //               child: player,
    //             ),
    //             Positioned(
    //                 top: 100,
    //                 right: 0,
    //                 child: Container(
    //                   alignment: Alignment.topRight,
    //                   child: IconButton(
    //                     icon: Icon(
    //                       Icons.clear,
    //                       color: WHITE_COLOR,
    //                     ),
    //                     onPressed: () {
    //                       Navigator.of(context).pop();
    //                     },
    //                   ),
    //                 )),
    //             FullScreenButton(
    //               controller: _controller,
    //             ),
    //           ]),
    //   ),
    // );
  }

  void _showSnackBar(String message) {
    // _scaffoldKey.currentState!.showSnackBar(
    //   SnackBar(
    //     content: AppBoldFont(
    //         msg: message, textAlign: TextAlign.center, fontSize: 16),
    //     backgroundColor: THEME_BACKGROUND,
    //     behavior: SnackBarBehavior.floating,
    //     elevation: 1.0,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(50.0),
    //     ),
    //   ),
    // );
  }
  youtubeHierarchy() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fill,
          child: widget.platformMovieData?.isYoutube == true? YoutubePlayer(
            controller: _controller!,
          ):VideoApp(element: widget.platformMovieData),
        ),
      ),
    );
  }
  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    return Future.value(true);
  }
}
