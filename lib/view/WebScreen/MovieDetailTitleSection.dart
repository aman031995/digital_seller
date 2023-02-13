import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/screens/DetailPage.dart';
import 'package:tycho_streams/view/screens/ViewAllListPages.dart';
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
      height: SizeConfig.screenHeight * 0.7,
      padding: EdgeInsets.only(top: 5, left: 10),
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
          height: 140,
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
                                          .homePageDataModel?.videoList?[index],
                                      // movieID: 'mZ5lbn9FWAQ',
                                      movieID: homeViewModel.homePageDataModel
                                          ?.videoList?[index].youtubeVideoId,
                                    )));
                      },
                      child: Container(
                        width: 200,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                    homeViewModel.homePageDataModel
                                            ?.videoList?[index].thumbnail ??
                                        '',
                                    fit: BoxFit.fill))),
                      ),
                    );
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
          AppBoldFont(msg: title, fontSize: 16, color: TEXT_COLOR),
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
