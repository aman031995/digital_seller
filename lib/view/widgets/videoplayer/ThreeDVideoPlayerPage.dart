import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'VideoPlayerControls.dart';

class ThreeDVideoPlayerPage extends StatefulWidget {
  String? filePath;
  bool? isPreview;
  bool? isControll;

  ThreeDVideoPlayerPage({Key? key, this.filePath, this.isControll, this.isPreview}) : super(key: key);

  @override
  State<ThreeDVideoPlayerPage> createState() => _ThreeDVideoPlayerPageState();
}

class _ThreeDVideoPlayerPageState extends State<ThreeDVideoPlayerPage> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  @override
  void dispose() {
    // TODO: implement dispose
    _betterPlayerController.dispose();
    super.dispose();
  }

  getLooping() {
    if (widget.isControll != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        const BetterPlayerConfiguration(
            aspectRatio: 0.8,
            fit: BoxFit.contain,
            autoPlay: true,
            looping: true,
            fullScreenByDefault: false,
            deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp
        ]);
    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      widget.filePath!,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(_betterPlayerDataSource);
    _betterPlayerController.setControlsEnabled(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      bottomNavigationBar: VideoPlayerControls(controller: _betterPlayerController),
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 35, left: 25),
              alignment: Alignment.topLeft,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: const Icon(Icons.disabled_by_default_outlined,
                          color: Colors.white)))),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 1),
              alignment: Alignment.center,
              child: BetterPlayer(controller: _betterPlayerController),
            ),
          ),
        ],
      ),
    );
  }
}
