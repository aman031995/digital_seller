import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/view/YoutubePlayer/YoutubePlayerFlutter.dart';
import 'package:tycho_streams/view/screens/MovieDetailTitleSection.dart';

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
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _tabController = TabController(length: 2, vsync: this);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return
      // movieDetailModel != null
      //   ?
    Scaffold(backgroundColor: THEME_BACKGROUND, body: movieDetails());
        // : CircularProgressIndicator();
  }

  movieDetails() {
    return CustomScrollView(slivers: <Widget>[
      new SliverAppBar(
        backgroundColor: WHITE_COLOR,
        expandedHeight: 210,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Stack(
                children: [
                  Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth / 1.77,
                    child: YouTubePlayerSection(
                        videoID: widget.movieID,
                        isDetail: true),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        width: 60,
                        color: Colors.transparent,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
          padding: EdgeInsets.only(top: 10),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            MovieDetailTitleSection(
                isWall: true,
                movieDetailModel: widget.platformMovieData),
          ])))
    ]);
  }
}

