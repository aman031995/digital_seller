import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/YoutubeAppDemo.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/YoutubePlayerFlutter.dart';
import 'package:tycho_streams/view/WebScreen/MovieDetailTitleSection.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';

// double maxHeight = 700;

class MovieDetailPage extends StatefulWidget {
  String? movieID;
  VideoList? platformMovieData;

  MovieDetailPage({this.movieID, this.platformMovieData});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? userID;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // appBar: movieDetails(),
      body:  SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

           Container(
                   width: SizeConfig.screenWidth,
                   height:  ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenWidth /2.47:SizeConfig.screenWidth /2.959,
                   child:
                   YoutubeAppDemo(videoID: widget.movieID,)
               ),

                  MovieDetailTitleSection(
                      isWall: true, movieDetailModel: widget.platformMovieData),
                SizedBox(height: 20),
                ResponsiveWidget.isMediumScreen(context)? footerMobile(context):footerDesktop()
              ],
            ),
          ),
        ));

  }


}
