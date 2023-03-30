import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/WebScreen/DesktopAppBar.dart';
import 'package:tycho_streams/view/WebScreen/DetailPage.dart';
import 'package:tycho_streams/view/WebScreen/EditProfile.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/OnHover.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/widgets/app_menu.dart';
import 'package:tycho_streams/view/widgets/search_view.dart';
import 'package:tycho_streams/viewmodel/CategoryViewModel.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

import '../../main.dart';

class SeeAllListPages extends StatefulWidget {
  String? title;

  String? VideoId;

  SeeAllListPages({
    Key? key,
    this.title,
    this.VideoId,
  }) : super(key: key);

  @override
  State<SeeAllListPages> createState() => _SeeAllListPagesState();
}

class _SeeAllListPagesState extends State<SeeAllListPages> {
  final CategoryViewModel categoryView = CategoryViewModel();
  final HomeViewModel homeView = HomeViewModel();
  ScrollController _scrollController = ScrollController();
  TextEditingController? searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool isSearch = false;
  int pageNum = 1;

  @override
  void initState() {
    homeView.getMoreLikeThis(context, widget.VideoId ?? '');
    homeView.getAppConfigData(context);
    searchController?.addListener(() {
      homeView.getSearchData(context, '${searchController?.text}', pageNum);
    });
    super.initState();
  }

  void dispose() {
    _scrollController.dispose();
    searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeView,
        child: Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
          return homeViewModel != null
              ? GestureDetector(
                  onTap: () {
                    if (isSearch == true) {
                      isSearch = false;
                      searchController?.clear();
                      setState(() {});
                    }
                    if (isLogins == true) {
                      isLogins = false;
                      setState(() {});
                    }
                  },
                  child: Scaffold(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    appBar: homePageTopBar(),
                    body: Scaffold(
                        key: _scaffoldKey,
                        drawer: AppMenu(homeViewModel: homeViewModel),
                        body: Stack(
                          children: [
                            homeViewModel.homePageDataModel != null
                                ? SingleChildScrollView(
                                    child: ResponsiveWidget.isMediumScreen(
                                            context)
                                        ? Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: GridView.builder(
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                controller: _scrollController,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 0.0,
                                                        mainAxisSpacing: 0.0,
                                                        childAspectRatio: 1.8),
                                                itemCount: homeViewModel
                                                    .homePageDataModel!
                                                    .videoList!
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      GoRouter.of(context)
                                                          .pushNamed(
                                                              RoutesName
                                                                  .DeatilPage,
                                                              queryParams: {
                                                            'movieID':
                                                                "${homeViewModel.homePageDataModel?.videoList?[index].youtubeVideoId}",
                                                            'VideoId':
                                                                '${homeViewModel.homePageDataModel?.videoList?[index].videoId}',
                                                            'Title':
                                                                "${homeViewModel.homePageDataModel?.videoList?[index].videoTitle}",
                                                            'Desc':
                                                                '${homeViewModel.homePageDataModel?.videoList?[index].videoDescription}'
                                                          });
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5, right: 5),
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          3.5,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: Image.network(
                                                              homeViewModel
                                                                      .homePageDataModel
                                                                      ?.videoList?[
                                                                          index]
                                                                      .thumbnail ??
                                                                  '',
                                                              fit: BoxFit.fill,
                                                              width: 50,
                                                              height: 50)),
                                                    ),
                                                  );
                                                }),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                bottom: 10,
                                                right: 10,
                                                left: 10),
                                            child: GridView.builder(
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                controller: _scrollController,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 4,
                                                        crossAxisSpacing: 0.0,
                                                        mainAxisSpacing: 0.0,
                                                        childAspectRatio: 1.5),
                                                itemCount: homeViewModel
                                                    .homePageDataModel!
                                                    .videoList!
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      GoRouter.of(context)
                                                          .pushNamed(
                                                              RoutesName
                                                                  .DeatilPage,
                                                              queryParams: {
                                                            'movieID':
                                                                "${homeViewModel.homePageDataModel?.videoList?[index].youtubeVideoId}",
                                                            'VideoId':
                                                                '${homeViewModel.homePageDataModel?.videoList?[index].videoId}',
                                                            'Title':
                                                                "${homeViewModel.homePageDataModel?.videoList?[index].videoTitle}",
                                                            'Desc':
                                                                '${homeViewModel.homePageDataModel?.videoList?[index].videoDescription}'
                                                          });
                                                    },
                                                    child: OnHover(
                                                        builder: (isHovered) {
                                                          bool _heigth =
                                                              isHovered;
                                                          return Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: _heigth
                                                                        ? 20
                                                                        : 10,
                                                                    right:
                                                                        _heigth
                                                                            ? 20
                                                                            : 10,
                                                                    top: _heigth
                                                                        ? 20
                                                                        : 10,
                                                                    bottom:
                                                                        _heigth
                                                                            ? 20
                                                                            : 10),
                                                            height: SizeConfig
                                                                    .screenHeight *
                                                                3.5,
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                child: Image.network(
                                                                    homeViewModel
                                                                            .homePageDataModel
                                                                            ?.videoList?[
                                                                                index]
                                                                            .thumbnail ??
                                                                        '',
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width: 50,
                                                                    height:
                                                                        50)),
                                                          );
                                                        },
                                                        hovered:
                                                            Matrix4.identity()
                                                              ..translate(
                                                                  0, 0, 0)),
                                                  );
                                                }),
                                          ),
                                  )
                                : Container(
                                    height: SizeConfig.screenHeight * 1.5,
                                    child: Center(
                                      child: ThreeArchedCircle(size: 45.0),
                                    )),
                            isLogins == true
                                ? profile(context, setState)
                                : Container(),
                            if (homeViewModel.searchDataModel != null)
                              searchView(
                                  context,
                                  homeViewModel,
                                  isSearch,
                                  scrollController,
                                  homeViewModel,
                                  searchController!,
                                  setState)
                          ],
                        )),
                  ),
                )
              : Container();
        }));
  }

  homePageTopBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).cardColor,
      title: Row(children: <Widget>[
        Image.asset(AssetsConstants.icLogo,
            width: ResponsiveWidget.isMediumScreen(context) ? 35 : 45,
            height: ResponsiveWidget.isMediumScreen(context) ? 35 : 45),
        SizedBox(width: SizeConfig.screenWidth * 0.04),
        AppBoldFont(context,
            msg: widget.title ?? "",
            fontSize: ResponsiveWidget.isMediumScreen(context) ? 18 : 20,
            fontWeight: FontWeight.w700),
      ]),
      actions: [
        GestureDetector(
          onTap: () {
            setState(() {
              isLogins = true;
              if (isSearch == true) {
                isSearch = false;
                searchController?.clear();
                setState(() {});
              }
            });
          },
          child: Row(
            children: [
              appTextButton(context, names!, Alignment.center,
                  Theme.of(context).canvasColor, 18, true),
              Image.asset(
                AssetsConstants.icProfile,
                height: 30,
                color: Theme.of(context).canvasColor,
              ),
            ],
          ),
        ),
        SizedBox(width: SizeConfig.screenWidth * 0.04),
      ],
    );
  }
}
