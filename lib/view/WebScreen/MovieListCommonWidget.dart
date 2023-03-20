import 'package:flutter/material.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/WebScreen/MovieCardCommonWidget.dart';



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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.platformMovieData!.content!.isNotEmpty
                    ? movieCardTopBAR(context, widget.trayTitle!,
                        widget.isSubtitle!, widget.isButtom!)
                    : Container(),
                Container(
                  height: (widget.platformMovieData!.content!.isNotEmpty)
                      ? ResponsiveWidget.isMediumScreen(context)?200 :SizeConfig.screenHeight * 0.3
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
                      :  Container(
                    height: SizeConfig.screenHeight * 0.35,
                    child: Center(
                        child: ThreeArchedCircle( size: 50.0)
                    ),
                  ),
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
    margin: EdgeInsets.only(right: 25,left: 10,top: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBoldFont(context,msg: title, fontSize: ResponsiveWidget.isMediumScreen(context)? 16:22, color: TEXT_COLOR),
              widget.platformMovieData!.content!.length > 8
                  ? textButton(context, "See All", onApply: () async {

                // Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) => SeeAllListPages(
                //               trayId: widget.trayId,
                //               moviesList: widget.platformMovieData?.content,
                //               title: widget.trayTitle ?? "",
                //               isCategory: false,
                //             ),
                //           ));
                    })
                  : SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
