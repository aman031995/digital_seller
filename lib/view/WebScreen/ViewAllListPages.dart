
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/model/data/HomePageDataModel.dart';
import 'package:TychoStream/network/AppDataManager.dart';
import 'package:TychoStream/network/CacheDataManager.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/DesktopAppBar.dart';
import 'package:TychoStream/view/WebScreen/DetailPage.dart';
import 'package:TychoStream/view/WebScreen/EditProfile.dart';
import 'package:TychoStream/view/WebScreen/HomePageWeb.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/OnHover.dart';
import 'package:TychoStream/view/WebScreen/SignUp.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/widgets/app_menu.dart';
import 'package:TychoStream/view/widgets/search_view.dart';
import 'package:TychoStream/viewmodel/CategoryViewModel.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';

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
    final authVM = Provider.of<AuthViewModel>(context);
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
                        // key: _scaffoldKey,
                        // drawer: AppMenu(homeViewModel: homeViewModel),
                        body: Stack(
                          children: [
                            homeViewModel.homePageDataModel != null
                                ? SingleChildScrollView(
                                    child: ResponsiveWidget.isMediumScreen(
                                            context)
                                        ? Container(
                                            padding: EdgeInsets.only(left: 20, right: 20,top: 10,bottom: 10),
                                            child: GridView.builder(
                                              padding: EdgeInsets.zero,
                                                physics: AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                controller: _scrollController,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 10.0,
                                                        mainAxisSpacing: 10.0,
                                                         childAspectRatio: 1.5
                                                    ),
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
                                                    child:Container(
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(width: 2,color:Theme.of(context).cardColor),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset: const Offset(
                                                              1.0,
                                                              1.0,
                                                            ),
                                                            blurRadius: 1.0,
                                                            spreadRadius: 1.0,
                                                          ), //BoxShadow//BoxShadow
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.network(
                                                              homeViewModel
                                                                      .homePageDataModel
                                                                      ?.videoList?[
                                                                          index]
                                                                      .thumbnail ??
                                                                  '',
                                                              fit: BoxFit.fill,
                                                              )),
                                                    ),
                                                  );
                                                }),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(top: 10,
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
                                                        crossAxisSpacing: 10.0,
                                                        mainAxisSpacing: 10.0,
                                                        childAspectRatio: 1.7),
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
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(width: 2,color:Theme.of(context).cardColor),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset: const Offset(
                                                              1.0,
                                                              1.0,
                                                            ),
                                                            blurRadius: 1.0,
                                                            spreadRadius: 1.0,
                                                          ), //BoxShadow//BoxShadow
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: Image.network(
                                                              homeViewModel
                                                                      .homePageDataModel
                                                                      ?.videoList?[
                                                                          index]
                                                                      .thumbnail ??
                                                                  '',
                                                              fit: BoxFit
                                                                  .fill,
                                                          )),
                                                    ),
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
        GestureDetector(
            onTap: (){
              GoRouter.of(context).pushNamed(RoutesName.home);
            },
            child: Image.asset(AssetsConstants.icLogo,width: ResponsiveWidget.isMediumScreen(context) ? 35:45, height:ResponsiveWidget.isMediumScreen(context) ? 35: 45)),
        SizedBox(width: SizeConfig.screenWidth*0.04),
        AppBoldFont(context,msg: widget.title ?? "",fontSize:ResponsiveWidget.isMediumScreen(context) ? 16: 20, fontWeight: FontWeight.w700),
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
              appTextButton(context, names!, Alignment.center, Theme.of(context).canvasColor,ResponsiveWidget.isMediumScreen(context)
                  ?16: 18, true),
              Image.asset(
                AssetsConstants.icProfile,
                height:ResponsiveWidget.isMediumScreen(context)
                    ?20: 30,
                color: Theme.of(context).canvasColor,
              ),
            ],
          ),
        ),
        SizedBox(width: SizeConfig.screenWidth*0.04),
      ],
    );
  }
}
