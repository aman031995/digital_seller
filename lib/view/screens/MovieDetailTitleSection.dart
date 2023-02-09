import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/widgets/video_listpage.dart';

class MovieDetailTitleSection extends StatefulWidget {
  bool? isWall;
  VideoList? movieDetailModel;

  MovieDetailTitleSection({this.isWall, this.movieDetailModel});

  @override
  _MovieDetailTitleSectionState createState() =>
      _MovieDetailTitleSectionState();
}

class _MovieDetailTitleSectionState extends State<MovieDetailTitleSection> {
  bool isShowList = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: WHITE_COLOR,
      height: SizeConfig.screenHeight * 0.7,
      padding: EdgeInsets.only(top: 5, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppRegularFont(
              msg: widget.movieDetailModel?.videoTitle,
              maxLines: 2,
              color: Colors.black,
              fontSize: 18),
          SizedBox(
            height: 15,
          ),
          ReadMoreText(
            'The Flutter framework builds its layout via the composition of widgets, everything that you construct programmatically is a widget and these are compiled together to create the user interface. ',
            trimLines: 2,
            style: TextStyle(color: TEXT_COLOR),
            colorClickableText: THEME_COLOR,
            trimMode: TrimMode.Line,
            trimCollapsedText: '...Read more',
            trimExpandedText: ' Less',
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              height: 400,
              width: SizeConfig.screenWidth,
              child: VideoListPage(
                isDetail: true,
              ))
        ],
      ),
    );
  }
}
