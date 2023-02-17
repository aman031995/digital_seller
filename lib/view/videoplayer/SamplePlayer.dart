import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'LandscapePlayerControls.dart';

class SamplePlayer extends StatefulWidget {
  String? url;
  bool? isVideoOption = false;

  SamplePlayer({Key? key, this.url, this.isVideoOption}) : super(key: key);

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
          // VideoPlayerController.network(widget.url!),
          VideoPlayerController.asset(widget.url!),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(
        flickManager: flickManager,
        preferredDeviceOrientation: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft
        ],
        systemUIOverlay: [],
        flickVideoWithControls:
            FlickVideoWithControls(controls: LandscapePlayerControls()),
      ),
    );
  }
}