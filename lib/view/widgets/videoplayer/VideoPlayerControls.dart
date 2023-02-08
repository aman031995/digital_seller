import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerControls extends StatefulWidget {
  BetterPlayerController? controller;
  final Function(bool visbility)? onControlsVisibilityChanged;

  VideoPlayerControls({
    Key? key,
    this.controller,
    this.onControlsVisibilityChanged,
  }) : super(key: key);

  @override
  _VideoPlayerControlsState createState() => _VideoPlayerControlsState();
}

class _VideoPlayerControlsState extends State<VideoPlayerControls> {

  @override
  void initState() {
    widget.controller?.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      Duration? videoDuration = await widget
                          .controller!.videoPlayerController!.position;
                      if (widget.controller!.isPlaying()!) {
                        Duration rewindDuration =
                        Duration(seconds: (videoDuration!.inSeconds - 5));
                        if (rewindDuration <
                            widget.controller!.videoPlayerController!.value
                                .duration!) {
                          widget.controller!.seekTo(rewindDuration);

                        } else {
                          widget.controller!.seekTo(const Duration(seconds: 0));
                        }
                      }
                    },
                    child: const Icon(
                      Icons.fast_rewind,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.controller!.isPlaying()!){
                        widget.controller!.pause();
                      } else{
                        widget.controller!.play();
                      }
                      setState(() {});
                    },
                    child: Icon(
                      widget.controller!.isPlaying()!
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      Duration? videoDuration = await widget
                          .controller!.videoPlayerController!.position;
                      if (widget.controller!.isPlaying()!) {
                        Duration forwardDuration =
                        Duration(seconds: (videoDuration!.inSeconds + 5));
                        if (forwardDuration >
                            widget.controller!.videoPlayerController!.value
                                .duration!) {
                          widget.controller!.seekTo(const Duration(seconds: 0));
                          widget.controller!.pause();
                        } else {
                          widget.controller!.seekTo(forwardDuration);
                        }
                      }
                    },
                    child: const Icon(
                      Icons.fast_forward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
