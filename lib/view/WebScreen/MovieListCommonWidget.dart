import 'package:flutter/material.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/screens/DetailPage.dart';
import 'package:tycho_streams/view/screens/MovieCardCommonWidget.dart';
import 'package:tycho_streams/view/screens/ViewAllListPages.dart';
import 'package:tycho_streams/view/widgets/AppDialog.dart';

class MovieListCommonWidget extends StatefulWidget {
  int? trayId;
  String? trayIdentifier;
  String? trayTitle;
  bool? isSubtitle;
  bool? isButtom;
  bool? isFilterApply;

  PlatformMovieData? platformMovieData;

  MovieListCommonWidget({
    this.trayId,
    this.isButtom,
    this.isSubtitle,
    this.trayTitle,
    this.platformMovieData,
    this.trayIdentifier,
    this.isFilterApply,
  });

  @override
  _MovieListCommonWidgetState createState() => _MovieListCommonWidgetState();
}

class _MovieListCommonWidgetState extends State<MovieListCommonWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return widget.platformMovieData != null
        ? Container(
            child: Column(
              children: [
                widget.platformMovieData!.content!.isNotEmpty
                    ? movieCardTopBAR(context, widget.trayTitle!,
                        widget.isSubtitle!, widget.isButtom!)
                    : Container(),
                Container(
                  height: (widget.platformMovieData!.content!.isNotEmpty)
                      ? SizeConfig.screenHeight * 0.3
                      : 0.0,
                  child: widget.platformMovieData?.content != null
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount:
                              widget.platformMovieData!.content!.length > 9
                                  ? 10
                                  : widget.platformMovieData?.content?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return CardMovieHome(
                              onTap: (fadeInImage) {},
                              trayId: widget.trayId,
                              movieID: widget
                                  .platformMovieData?.content?[index].videoId,
                              title: widget.platformMovieData?.content?[index]
                                  .videoTitle,
                              image: widget
                                  .platformMovieData?.content?[index].thumbnail,
                              index: index,
                              moviesList:
                                  widget.platformMovieData?.content?[index],
                            );
                          },
                        )
                      : CircularProgressIndicator(),
                ),
              ],
            ),
          )
        : Container();
  }

  movieCardTopBAR(
      BuildContext context, String title, bool isSubTitle, bool isButton) {
    return Container(
      height: isSubTitle ? 70 : 40,
    margin: EdgeInsets.only(right: 25,left: 10,top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBoldFont(msg: title, fontSize: 30, color: TEXT_COLOR),
              widget.platformMovieData!.content!.length > 8
                  ? textButton(context, "See All", onApply: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SeeAllListPages(
                              trayId: widget.trayId,
                              moviesList: widget.platformMovieData?.content,
                              title: widget.trayTitle ?? "",
                              isCategory: false,
                            ),
                          ));
                    })
                  : SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
