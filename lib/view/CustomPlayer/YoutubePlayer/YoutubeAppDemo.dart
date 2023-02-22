import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeAppDemo extends StatefulWidget {
  String? videoID;
  YoutubeAppDemo({this.videoID});
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  late YoutubePlayerController _controller;
  List<String> _videoIds = [' ',];

  @override
  void initState() {
    _videoIds.add(widget.videoID ?? ' ');
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(

        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );

    _controller.setFullScreenListener(
          (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );

    _controller.loadPlaylist(
      list: _videoIds,
      listType: ListType.playlist,
      startSeconds: 02,
    );
    _controller.videoUrl;
// _controller.

  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (kIsWeb && constraints.maxWidth > 370) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                         flex: ResponsiveWidget.isMediumScreen(context)?1:1,

                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: ResponsiveWidget.isMediumScreen(context)?5:3,
                      child: Column(
                        children: [
                          player,
                          VideoPositionIndicator(),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: ResponsiveWidget.isMediumScreen(context)?1:1,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              }


              return ListView(
                children: [
                  player,
                  VideoPositionIndicator(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
class VideoPositionIndicator extends StatelessWidget {
  const VideoPositionIndicator({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;
    return StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inMilliseconds ?? 0;
        final duration = controller.metadata.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == 0 ? 0 : position / duration,
          minHeight: 1,
        );
      },
    );
  }
}
