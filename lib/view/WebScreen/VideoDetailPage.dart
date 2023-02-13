import 'package:flutter/material.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/view/CustomPlayer/StreamPlayer.dart';

class VideoDetailPage extends StatefulWidget {
  VideoList? element;
   VideoDetailPage({Key? key,this.element}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: SizeConfig.screenHeight * 0.35,
              width: SizeConfig.screenWidth,
              child: VideoApp(element: widget.element),
            )
          ],
        ),
      ),
    );
  }
}
