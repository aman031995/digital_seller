import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/WebScreen/DetailPage.dart';
import 'package:tycho_streams/view/WebScreen/OnHover.dart';

import 'package:tycho_streams/view/WebScreen/ViewAllListPages.dart';
import 'package:tycho_streams/view/widgets/AppDialog.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

class MovieDetailTitleSection extends StatefulWidget {
  bool? isWall;
  String? movieDetailModel;
  String? Title;
  String? Desc;

  MovieDetailTitleSection({this.isWall, this.movieDetailModel,this.Title,this.Desc});

  @override
  _MovieDetailTitleSectionState createState() =>
      _MovieDetailTitleSectionState();
}

class _MovieDetailTitleSectionState extends State<MovieDetailTitleSection> {
  bool isShowList = false;
  final HomeViewModel homeView = HomeViewModel();

  @override
  void initState() {
    setState((){});
    homeView.getMoreLikeThis(context, widget.movieDetailModel ?? '');
    // TODO: implement initState
    super.initState();
  }
//806b4763-e6e6-4f6a-9e6e-8ac30cf11d9c
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return

      Container(
        color: Theme.of(context).scaffoldBackgroundColor,
      height:ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenHeight*0.5 :SizeConfig.screenHeight*0.45,
      padding: EdgeInsets.only(top: 10, left: 30,right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppRegularFont(
              context,msg: widget.Title,
              maxLines: 1,
              
              fontSize: ResponsiveWidget.isMediumScreen(context)?16:22),
          SizedBox(
            height: 10,
          ),
          ReadMoreText(
            widget.Desc ?? '',
            trimLines: 2,
            style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18),
            colorClickableText: THEME_COLOR,
            trimMode: TrimMode.Line,
            trimCollapsedText: '...Read more',
            trimExpandedText: ' Less',
          ),
          ChangeNotifierProvider<HomeViewModel>(
              create: (BuildContext context) => homeView,
              child: Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
                return homeViewModel.homePageDataModel != null
                    ? moreVideoList(homeViewModel)
                    :  Container(
                  height: SizeConfig.screenHeight * 0.35,
                  child: Center(
                      child: ThreeArchedCircle( size: 50.0)
                  ),
                );
              }))
        ],
      ),
    );
  }

  moreVideoList(HomeViewModel homeViewModel) {
    return Column(
      children: [
        titleBar('More Like This', homeViewModel),
        Container(
          height: ResponsiveWidget.isMediumScreen(context)? 200:270,
          width: SizeConfig.screenWidth,
          child: homeViewModel.homePageDataModel?.videoList != null
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount:
                      homeViewModel.homePageDataModel!.videoList!.length > 9
                          ? 10
                          : homeViewModel.homePageDataModel!.videoList!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {

                            GoRouter.of(context).pushNamed(RoutesName.DeatilPage,queryParams: {
    'movieID':'${homeViewModel.homePageDataModel?.videoList?[index].youtubeVideoId}',
    'VideoId':'${homeViewModel.homePageDataModel?.videoList?[index].videoId}',
    'Title':'${homeViewModel.homePageDataModel?.videoList?[index].videoTitle}',
    'Desc':'${homeViewModel.homePageDataModel?.videoList?[index].videoDescription}'
    });

                          },



                        child: OnHover(
                            builder: (isHovered) {
                              bool _heigth = isHovered;
                              return Container(
                                width:ResponsiveWidget.isMediumScreen(context)? 250 : SizeConfig.screenWidth * 0.20,
                                height:ResponsiveWidget.isMediumScreen(context)? 200 : SizeConfig.screenHeight * 5.07,
                                padding: EdgeInsets.only(
                                    right: _heigth ? 1 : 10,
                                    top: _heigth ? 1 : 10,
                                    bottom: _heigth ? 1 : 10),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                            homeViewModel
                                                    .homePageDataModel
                                                    ?.videoList?[index]
                                                    .thumbnail ??
                                                '',
                                            fit: BoxFit.fill))),
                              );
                            },
                            hovered: Matrix4.identity()..translate(0, 0, 0)));
                  })
              : Container(
                  height: SizeConfig.screenHeight * 0.3,
                  // width:SizeConfig.screenHeight * 0.3,
                  child: ThreeArchedCircle( size: 45.0)),
        ),
      ],
    );
  }

  titleBar(String title, HomeViewModel homeViewModel) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBoldFont(context,msg: title, fontSize:ResponsiveWidget.isMediumScreen(context)?18: 30, color: TEXT_COLOR),
          homeViewModel.homePageDataModel!.videoList!.length > 8
              ? textButton(context, "See All", onApply: () {
            GoRouter.of(context).pushNamed(RoutesName.seaAll,queryParams: {
              'VideoId':'${widget.movieDetailModel}',
              'title':'${title}',
            });
                })
              : SizedBox()
        ],
      ),
    );
  }
}
