import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/WebScreen/OnHover.dart';
import 'package:tycho_streams/view/screens/DetailPage.dart';
import 'package:tycho_streams/view/WebScreen/ViewAllListPages.dart';
import 'package:tycho_streams/view/widgets/AppDialog.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';

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
  final HomeViewModel homeView = HomeViewModel();

  @override
  void initState() {
    homeView.getMoreLikeThis(context, widget.movieDetailModel?.videoId ?? '');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: WHITE_COLOR,
      height:ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenHeight*0.5 :SizeConfig.screenHeight*0.45,
      padding: EdgeInsets.only(top: 10, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppRegularFont(
              msg: widget.movieDetailModel?.videoTitle,
              maxLines: 1,
              color: Colors.black,
              fontSize: ResponsiveWidget.isMediumScreen(context)?16:20),
          SizedBox(
            height: 10,
          ),
          ReadMoreText(
            widget.movieDetailModel?.videoDescription ?? '',
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
          ChangeNotifierProvider<HomeViewModel>(
              create: (BuildContext context) => homeView,
              child:
                  Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
                return homeViewModel.homePageDataModel != null
                    ? moreVideoList(homeViewModel)
                    : SizedBox();
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
          height: ResponsiveWidget.isMediumScreen(context)? 200:250,
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
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                                  builder: (context) => new MovieDetailPage(
                                        platformMovieData: homeViewModel
                                            .homePageDataModel
                                            ?.videoList?[index],
                                        // movieID: 'mZ5lbn9FWAQ',
                                        movieID: homeViewModel.homePageDataModel
                                            ?.videoList?[index].youtubeVideoId,
                                      )));
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
                  child: ThreeArchedCircle(color: THEME_COLOR, size: 45.0)),
        ),
      ],
    );
  }

  titleBar(String title, HomeViewModel homeViewModel) {
    return Container(
      height: 30,
      margin: EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBoldFont(msg: title, fontSize:ResponsiveWidget.isMediumScreen(context)?18: 30, color: TEXT_COLOR),
          homeViewModel.homePageDataModel!.videoList!.length > 8
              ? textButton(context, "See All", onApply: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeeAllListPages(
                          moviesList:
                              homeViewModel.homePageDataModel!.videoList,
                          title: title ?? "",
                          isCategory: false,
                        ),
                      ));
                })
              : SizedBox()
        ],
      ),
    );
  }
}
