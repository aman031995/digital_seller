import 'package:TychoStream/model/data/homepage_data_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/MovieCardCommonWidget.dart';



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
                    ? ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenHeight*0.25 :SizeConfig.screenHeight * 0.25
                    : 0.0,

                child: widget.platformMovieData?.content != null
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount:
                            widget.platformMovieData!.content!.length > 8
                                ? 10
                                : widget.platformMovieData?.content?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return CardMovieHome(
                            onTap: (fadeInImage) {

                            },
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
      height: isSubTitle ? 20 : 40,
    margin: EdgeInsets.only(right:ResponsiveWidget.isMediumScreen(context)?15: 25,left:ResponsiveWidget.isMediumScreen(context)?0: 10,top:ResponsiveWidget.isMediumScreen(context)?0: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBoldFont(context,msg: title, fontSize: ResponsiveWidget.isMediumScreen(context)? 16:22),
              widget.platformMovieData!.content!.length > 8
                  ? textButton(context, "See All", onApply: () async {

                names == "null"
                    ? showDialog(
                    context: context,
                    barrierColor: Colors.black87,
                    builder: (BuildContext context) {
                      return  LoginUp();
                    })
                    :

                GoRouter.of(context)
                    .pushNamed(RoutesName.HomeViewPage, queryParameters: {
                  'title': '${widget.trayTitle}',
                  'trayId':'${widget.trayId}',
                },
                );
                    })
                  : SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
