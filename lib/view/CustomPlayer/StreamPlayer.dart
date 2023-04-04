// /*
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:provider/provider.dart';
// import 'package:TychoStream/model/data/HomePageDataModel.dart';
// import 'package:TychoStream/utilities/AppColor.dart';
// import 'package:TychoStream/utilities/SizeConfig.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoApp extends StatefulWidget {
//   VideoList? element;
//
//   VideoApp({Key? key,this.element}) : super(key: key);
//
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }
//
// class _VideoAppState extends State<VideoApp> {
//   late VideoPlayerController _controller;
//   bool isHideControl = false;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//         'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
//       ..initialize().then((_) {
//         setState(() {
//           isLoading = true;
//           _controller.play();
//         });
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//       backgroundColor: LIGHT_THEME_BACKGROUND,
//       body: Stack(
//         children: [
//         HtmlWidget(
//         '''
// <video controls width="250">
//   <source src="https://www.instagram.com/reel/CpxhVztjVGY/?igshid=MDJmNzVkMjY%3D" type="video/mp4">
//   <code>VIDEO</code> support is not enabled.
// </video>'''
//           // GestureDetector(
//           //   onTap: () {
//           //     setState(() {
//           //       isHideControl = !isHideControl;
//           //     });
//           //     Future.delayed(const Duration(seconds: 5), () {
//           //       setState(() {
//           //         isHideControl = false;
//           //       });
//           //     });
//           //   },
//           //   child: isLoading == true? Container(
//           //     margin: const EdgeInsets.only(top: 60),
//           //     child: _controller.value.isInitialized
//           //         ? AspectRatio(
//           //             aspectRatio: _controller.value.aspectRatio,
//           //             child: VideoPlayer(_controller),
//           //           )
//           //         : Container(),
//           //   ): Center(child: CircularProgressIndicator()),
//           // ),
//           // Positioned(
//           //     top: 60,
//           //     child: isHideControl == true
//           //         ? Column(
//           //             children: [
//           //               Container(
//           //                   width: SizeConfig.screenWidth,
//           //                   color: Colors.black38.withOpacity(0.3),
//           //                   height: 45,
//           //                   child: _ControlsOverlayTop(
//           //                     element: widget.element,
//           //                     controller: _controller,
//           //                   )),
//           //             ],
//           //           )
//           //         : const SizedBox()),
//           // Positioned(
//           //     bottom: 0,
//           //     child: isHideControl == true
//           //         ? Column(
//           //             children: [
//           //               SizedBox(
//           //                 height: 10,
//           //                 width: SizeConfig.screenWidth,
//           //                 child: VideoProgressIndicator(
//           //                   _controller,
//           //                   allowScrubbing: true,
//           //                   colors: const VideoProgressColors(
//           //                     backgroundColor: Colors.black,
//           //                     // bufferedColor: Colors.yellow,
//           //                     playedColor: Color(0xff18BAE8),
//           //                   ),
//           //                 ),
//           //               ),
//           //               Container(
//           //                   width: SizeConfig.screenWidth,
//           //                   color: Colors.black38.withOpacity(0.3),
//           //                   height: 45,
//           //                   child: _ControlsOverlay(
//           //                     controller: _controller,
//           //                   )),
//           //             ],
//           //           )
//           //         : const SizedBox())
//         )],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//
//   getTimeStamp(){
//     if(_controller.value.duration.inSeconds < 60){
//       return "   ${_controller.value.position.inSeconds}";
//     }else if(_controller.value.duration.inSeconds < 3660){
//       return "   ${_controller.value.position.inMinutes}";
//     }else{
//       return "   ${_controller.value.position.inHours}";
//     }
//   }
// }
//
// class _ControlsOverlay extends StatefulWidget {
//   const _ControlsOverlay({Key? key, required this.controller})
//       : super(key: key);
//   static const List<double> _examplePlaybackRates = <double>[
//     0.25,
//     0.5,
//     1.0,
//     1.5,
//     2.0,
//   ];
//   final VideoPlayerController controller;
//
//   @override
//   State<_ControlsOverlay> createState() => _ControlsOverlayState();
// }
//
// class _ControlsOverlayState extends State<_ControlsOverlay> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 50),
//           reverseDuration: const Duration(milliseconds: 200),
//           child: Container(
//             color: Colors.black26,
//             child: Center(
//                 child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Duration currentPosition = widget.controller.value.position;
//                     Duration targetPosition =
//                         currentPosition - const Duration(seconds: 10);
//                     widget.controller.seekTo(targetPosition);
//                   },
//                   child: const Icon(
//                     Icons.replay_10_rounded,
//
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 15,
//                 ),
//                 widget.controller.value.isPlaying
//                     ? GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             widget.controller.pause();
//                           });
//                         },
//                         child: const Icon(
//                           Icons.pause,
//
//                           size: 25.0,
//                           semanticLabel: 'Pause',
//                         ),
//                       )
//                     : GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             widget.controller.play();
//                           });
//                         },
//                         child: const Icon(
//                           Icons.play_arrow,
//
//                           size: 25.0,
//                           semanticLabel: 'Play',
//                         ),
//                       ),
//                 const SizedBox(
//                   width: 15,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Duration currentPosition = widget.controller.value.position;
//                     Duration targetPosition =
//                         currentPosition + const Duration(seconds: 10);
//                     widget.controller.seekTo(targetPosition);
//                   },
//                   child: const Icon(
//                     Icons.forward_10_rounded,
//
//                   ),
//                 )
//               ],
//             )),
//           ),
//         ),
//         Align(
//           alignment: Alignment.topRight,
//           child: Padding(
//             padding: const EdgeInsets.only(right: 36.0),
//             child: PopupMenuButton<double>(
//               initialValue: widget.controller.value.playbackSpeed,
//               tooltip: 'Playback speed',
//               onSelected: (double speed) {
//                 widget.controller.setPlaybackSpeed(speed);
//               },
//               itemBuilder: (BuildContext context) {
//                 return <PopupMenuItem<double>>[
//                   for (final double speed
//                       in _ControlsOverlay._examplePlaybackRates)
//                     PopupMenuItem<double>(
//                       value: speed,
//                       child: Text('${speed}x'),
//                     )
//                 ];
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 16,
//                 ),
//                 child: Text(
//                   '${widget.controller.value.playbackSpeed}x',
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Align(
//             alignment: Alignment.topRight,
//             child: Container(
//                 height: 50,
//                 width: 50,
//                 child: IconButton(
//                     onPressed: () {
//                       enterFullScreenButKeepBottomOverlay();
//                     },
//                     icon: Icon(
//                       Icons.fullscreen,
//
//                     )))),
//       ],
//     );
//   }
//
//   void enterFullScreenButKeepBottomOverlay() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
//         overlays: [SystemUiOverlay.bottom]);
//   }
// }
//
// class _ControlsOverlayTop extends StatelessWidget {
//   _ControlsOverlayTop({Key? key, required this.controller,this.element})
//       : super(key: key);
//   final VideoPlayerController controller;
//   VideoList? element;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 50),
//           reverseDuration: const Duration(milliseconds: 200),
//           child: Container(
//             padding: EdgeInsets.only(left: 40),
//                   alignment: Alignment.center,
//                   color: Colors.black26,
//                   child: Text(
//                     element?.videoTitle ?? '',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//         ),
//         Align(
//             alignment: Alignment.centerLeft,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(left: 8.0),
//                 child: Icon(
//                   Icons.arrow_back_outlined,
//
//                   size: 20,
//                 ),
//               ),
//             )),
//       ],
//     );
//   }
// }
// */
