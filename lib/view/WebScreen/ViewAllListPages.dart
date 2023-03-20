
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/WebScreen/DesktopAppBar.dart';
import 'package:tycho_streams/view/WebScreen/DetailPage.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/OnHover.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/viewmodel/CategoryViewModel.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';


class SeeAllListPages extends StatefulWidget {
  int? trayId;
  List<VideoList>? moviesList;
  String? categoryWiseId, title;
  bool? isCategory;
  String? VideoId;
  SeeAllListPages(
      {Key? key,
      this.trayId,
      this.moviesList,
      this.categoryWiseId,
      this.title,
        this.VideoId,
      this.isCategory})
      : super(key: key);

  @override
  State<SeeAllListPages> createState() => _SeeAllListPagesState();
}

class _SeeAllListPagesState extends State<SeeAllListPages> {
  final CategoryViewModel categoryView = CategoryViewModel();
  final HomeViewModel homeView = HomeViewModel();
  ScrollController _scrollController = ScrollController();
  TextEditingController? editingController = TextEditingController();
  HomeViewModel homeViewModel = HomeViewModel();
  bool onNotification(ScrollNotification notification) {
    // if (notification is ScrollUpdateNotification) {
    if (_scrollController.hasClients) {
      if (_scrollController.position.maxScrollExtent >
              _scrollController.offset &&
          _scrollController.position.maxScrollExtent -
                  _scrollController.offset <=
              150) {}
      // }
    }
    return true;
  }

  @override
  void initState() {
    homeView.getMoreLikeThis(context, widget.VideoId ?? '');
    super.initState();
  }
  final List<String> genderItems = ['My Acount', 'Logout'];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeView,
        child: Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: PreferredSize(preferredSize: Size.fromHeight( ResponsiveWidget.isMediumScreen(context)? 50:70),
                child: DesktopAppBar()),
            drawer: MobileMenu(context),
            body: SingleChildScrollView(
                child:   ResponsiveWidget.isMediumScreen(context)?
              contentsWidget( videoList: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  print(_scrollController.position.pixels);
                }
                return false;
              },
              child: homeViewModel.homePageDataModel != null
                  ?  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: 250,
                          child: GridView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollController,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 5,
                              mainAxisSpacing:  15,
                              childAspectRatio: 1.8),
                          itemCount:  homeViewModel.homePageDataModel!.videoList!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                GoRouter.of(context).pushNamed(RoutesName.DeatilPage,queryParams: {
                                  'movieID':"${homeViewModel.homePageDataModel?.videoList?[index].youtubeVideoId}",
                                  'VideoId':'${homeViewModel.homePageDataModel?.videoList?[index].videoId}',
                                  'Title':"${homeViewModel.homePageDataModel?.videoList?[index].videoTitle}",
                                  'Desc':'${homeViewModel.homePageDataModel?.videoList?[index].videoDescription}'
                                  // 'movieID':'${homeViewModel.homePageDataModel?.moviesList?.youtubeVideoId}',
                                  // 'VideoId':'${widget.moviesList?.videoId}',
                                  // 'Title':'${widget.moviesList?.videoTitle}',
                                  // 'Desc':'${widget.moviesList?.videoDescription}'
                                  // 'platformMovieData':'${widget.moviesList}'
                                });
                                // Navigator.of(context, rootNavigator: true)
                                //     .push(MaterialPageRoute(
                                //     builder: (context) =>
                                //     new DetailPage(
                                //       // platformMovieData: categoryView
                                //       //     .getPreviousPageList[index],
                                //       movieID: categoryView
                                //           .getPreviousPageList[index]
                                //           .youtubeVideoId,
                                //     )));

                              },
                              child: OnHover(
                                  builder: (isHovered) {
                                    return Container(
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          child: Image.network(
                                              homeViewModel
                                                  .homePageDataModel
                                                  ?.videoList?[index]
                                                  .thumbnail ??
                                                  '',
                                            fit: BoxFit.fill)),
                                    );
                                  },
                                  hovered: Matrix4.identity()
                                    ..translate(0, 0, 0)),
                            );
                          }),
                        ),
                        SizedBox(height: 40),
                        footerMobile(context)
                      ],
                    ),
                  )

                  : Container(
                height: SizeConfig.screenHeight * 0.8,
                child: Center(
                  child:
                  ThreeArchedCircle( size: 45.0),
                ),
              ),
            )) :
            contentWidget(
                 videoList: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  print(_scrollController.position.pixels);
                }
                return false;
              },
              child: homeViewModel.homePageDataModel != null
                  ?  GridView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      ResponsiveWidget.isMediumScreen(context)
                                          ? 1
                                          : 4,
                                  crossAxisSpacing: ResponsiveWidget.isMediumScreen(context)?5:9.0,
                                  mainAxisSpacing:  ResponsiveWidget.isMediumScreen(context)?15:5.0,
                                  childAspectRatio: ResponsiveWidget.isMediumScreen(context)
                                      ? 1.8:1.5),
                          itemCount:  homeViewModel.homePageDataModel!.videoList!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                GoRouter.of(context).pushNamed(RoutesName.DeatilPage,queryParams: {
                                  'movieID':"${homeViewModel.homePageDataModel?.videoList?[index].youtubeVideoId}",
                                  'VideoId':'${homeViewModel.homePageDataModel?.videoList?[index].videoId}',
                                  'Title':"${homeViewModel.homePageDataModel?.videoList?[index].videoTitle}",
                                  'Desc':'${homeViewModel.homePageDataModel?.videoList?[index].videoDescription}'
                                });
                              },
                              child: OnHover(
                                  builder: (isHovered) {
                                    bool _heigth = isHovered;
                                    return Container(
                                      margin: EdgeInsets.only(left: 25,right: 25),
                                      padding: EdgeInsets.only(
                                          left:ResponsiveWidget.isMediumScreen(context)?0: _heigth ? 20 :10,
                                          right: ResponsiveWidget.isMediumScreen(context)? 0:_heigth ? 20 :10,
                                          top: ResponsiveWidget.isMediumScreen(context)? 0:_heigth ? 20 :10,
                                          bottom: ResponsiveWidget.isMediumScreen(context)?0: _heigth ? 20 :10),
                                      height: ResponsiveWidget.isMediumScreen(
                                              context)
                                          ? 1000
                                          : SizeConfig.screenHeight * 0.5,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            homeViewModel
                                                .homePageDataModel
                                                ?.videoList?[index]
                                                .thumbnail ??
                                                '',
                                              fit: BoxFit.fill,width: 50,height: 50,)),
                                    );
                                  },
                                  hovered: Matrix4.identity()
                                    ..translate(0, 0, 0)),
                            );
                          })

                  : Container(
                      height: SizeConfig.screenHeight * 1.5,
                      child: Center(
                        child:
                            ThreeArchedCircle( size: 45.0),
                      ),
                    ),
            ))),
          );
        }));
  }

  homePageTopBar() {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: WHITE_COLOR,
        title: Stack(children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Row(children: [
                GestureDetector(
                    onTap: () {},
                    child: Image.asset(AssetsConstants.icLogo,
                        height: 50, width: 50)),
                Expanded(child: SizedBox(width: SizeConfig.screenWidth * 0.09)),
                Container(
                    height: 50,
                    width: SizeConfig.screenWidth * 0.64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: TRANSPARENT_COLOR, width: 2.0),
                    ),
                    child: new TextField(
                      maxLines: editingController!.text.length > 2 ? 2 : 1,
                      controller: editingController,
                      decoration: new InputDecoration(
                          hintText: StringConstant.search,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintStyle: TextStyle(color: GREY_COLOR)),
                      onChanged: (m) {},
                    )),
                Expanded(child: SizedBox(width: SizeConfig.screenWidth * 0.13)),
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: LIGHT_THEME_COLOR,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.asset(
                      AssetsConstants.icNotification,
                      height: 45,
                      width: 45,
                    ))
              ]))
        ]));
  }

  contentWidget({Widget? videoList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 40, top: 30),
          child: AppBoldFont(context,msg: widget.title ?? "",fontSize: 22),
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(left: 20, top: 15, right: 20),
            height: SizeConfig.screenHeight,
            child: videoList),
        SizedBox(height: 80),
    footerDesktop()
      ],
    );
  }
  contentsWidget({Widget? videoList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 40, top: 30,bottom: 20),
          child: AppBoldFont(context,msg: widget.title ?? "",fontSize: 18),
        ),
        Center(
          child: Container(
            width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: videoList),
        ),

      ],
    );
  }
  logoutButtonPressed() async {
    AppDataManager.deleteSavedDetails();
    CacheDataManager.clearCachedData();
    await Future.delayed(const Duration(milliseconds:100)).then((value) =>Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (route) => false));

  }
}
