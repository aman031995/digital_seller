import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/YoutubePlayerFlutter.dart';
import 'package:tycho_streams/view/WebScreen/MovieDetailTitleSection.dart';

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
      backgroundColor: THEME_BACKGROUND,
      body: OrientationBuilder(builder: (context, orientation) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            orientation == Orientation.portrait
                ? SizedBox(
                    height: 30,
                  )
                : SizedBox(),
            Container(
              width: SizeConfig.screenWidth,
              height:  SizeConfig.screenWidth /4,
              child:
                  YouTubePlayerSection(videoID: widget.movieID, isDetail: true),
            ),
            Expanded(
              child: MovieDetailTitleSection(
                  isWall: true, movieDetailModel: widget.platformMovieData),
            )
          ],
        );
      }),
    );
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
                children: [],
              ),
            ],
          ),
        ),
      ),
      // SliverPadding(
      //     padding: EdgeInsets.only(top: 10),
      //     sliver: SliverList(
      //         delegate: SliverChildListDelegate([

      //     ])))
    ]);
  }
}
