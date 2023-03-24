import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';


class YoutubeAppDemo extends StatefulWidget {
  String? videoID;

  YoutubeAppDemo({this.videoID});

  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        strictRelatedVideos: false,
        showControls: true,
        mute: false,
        enableJavaScript: false,
        enableKeyboard: kIsWeb,
        showFullscreenButton: true,
        loop: false,
      ),
    );
    _controller.loadVideoById(videoId: widget.videoID ?? ' ');
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      autoFullScreen: true,
      controller: _controller,
      builder: (context, player) {
        return ListView(
          itemExtent: ResponsiveWidget.isMediumScreen(context)
              ? SizeConfig.screenWidth / 2
              : SizeConfig.screenWidth / 2.959,
          children: [
            player,
          ],
        );
      },
    );
  }

}
