import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/AppNetwork.dart';
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
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'package:tycho_streams/view/widgets/app_menu.dart';
import 'package:tycho_streams/view/widgets/search_view.dart';
import 'package:tycho_streams/viewmodel/CategoryViewModel.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

import '../../main.dart';

class HomeViewPage extends StatefulWidget {
  int? trayId;
  String?  title;

  HomeViewPage(
      {Key? key,
        this.trayId,
        this.title,
      })
      : super(key: key);

  @override
  State<HomeViewPage> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> {
 CategoryViewModel categoryView = CategoryViewModel();
  HomeViewModel homeView = HomeViewModel();
  ScrollController _scrollController = ScrollController();
  TextEditingController? searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool isSearch = false;
  int pageNum = 1;

  @override
  onNotification(
      ScrollNotification notification,
      int lastPage,
      int nextPage,
      int homeNextPage,
      ) {
    if (nextPage <= lastPage) {
      categoryView.runIndicator(context);
      categoryView.seealll(context, widget.trayId ?? 1, 'video',nextPage);
    } else {
      categoryView.stopIndicator(context);
    }
  }

  void initState() {
    categoryView.seealll(context, widget.trayId ?? 1,'video', pageNum);
    // homeView.getAppConfigData(context);
    searchController?.addListener(() {
      homeView.getSearchData(
          context, '${searchController?.text}', pageNum);
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
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return ChangeNotifierProvider<CategoryViewModel>(
              create: (BuildContext context) => categoryView,
              child: Consumer<CategoryViewModel>(
                  builder: (context, categoryView, _) {
                    return GestureDetector(
                      onTap: (){ if (isSearch == true) {
                        isSearch = false;
                        setState(() {});
                      }
                      if (isLogins == true) {
                        isLogins = false;
                        setState(() {});
                      }
                      },
                      child: contentWidget(
                          videoList: NotificationListener(
                              onNotification: (notification) {
                                if (notification is ScrollEndNotification) {
                                  onNotification(
                                      notification,
                                      categoryView.lastPage,
                                      categoryView.nextPage,
                                      categoryView.homeNextPage);
                                }
                                return false;
                              },
                              child: mainView(categoryView))),
                    );
                  }));
        }));
  }

  mainView(CategoryViewModel categoryView) {
    if (categoryView.getPreviousPageList != null) {
      return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar:  homePageTopBar(),
          body: Stack(
            children: [
              SingleChildScrollView(
                    child:   ResponsiveWidget.isMediumScreen(context)
                        ?  Container(
                      margin: EdgeInsets.only(bottom: 10,right: 10,left: 10,top: 10),
                      child: GridView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollController,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 1.5),
                          itemCount: categoryView.getPreviousPageList?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                GoRouter.of(context).pushNamed(RoutesName.DeatilPage,queryParams: {
                                  'movieID':"${categoryView.getPreviousPageList?[index].youtubeVideoId}",
                                  'VideoId':"${categoryView.getPreviousPageList?[index].videoId}",
                                  'Title':"${categoryView.getPreviousPageList?[index].videoTitle}",
                                  'Desc':"${categoryView.getPreviousPageList?[index].videoDescription}"
                                  // 'movieID':"${homeViewModel.homePageDataModel?.videoList?[index].youtubeVideoId}",
                                  // 'VideoId':'${homeViewModel.homePageDataModel?.videoList?[index].videoId}',
                                  // 'Title':"${homeViewModel.homePageDataModel?.videoList?[index].videoTitle}",
                                  // 'Desc':'${homeViewModel.homePageDataModel?.videoList?[index].videoDescription}'
                                });
                              },
                              child: OnHover(
                                  builder: (isHovered) {
                                    bool _heigth = isHovered;
                                    return ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                            categoryView.getPreviousPageList?[index].thumbnail ?? "",
                                            fit: BoxFit.fill,
                                           ));
                                  },
                                  hovered: Matrix4.identity()..translate(0, 0, 0)),
                            );
                          }),
                    )
                        :Container(

                margin: EdgeInsets.only(bottom: 10,right: 20,left: 20,top: 10),
                child: GridView.builder(

                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                          childAspectRatio: 1.8),
                      itemCount: categoryView.getPreviousPageList?.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            GoRouter.of(context).pushNamed(RoutesName.DeatilPage,queryParams: {
                              'movieID':"${categoryView.getPreviousPageList?[index].youtubeVideoId}",
                              'VideoId':"${categoryView.getPreviousPageList?[index].videoId}",
                              'Title':"${categoryView.getPreviousPageList?[index].videoTitle}",
                              'Desc':"${categoryView.getPreviousPageList?[index].videoDescription}"
                              // 'movieID':"${homeViewModel.homePageDataModel?.videoList?[index].youtubeVideoId}",
                              // 'VideoId':'${homeViewModel.homePageDataModel?.videoList?[index].videoId}',
                              // 'Title':"${homeViewModel.homePageDataModel?.videoList?[index].videoTitle}",
                              // 'Desc':'${homeViewModel.homePageDataModel?.videoList?[index].videoDescription}'
                            });
                          },
                          child: OnHover(
                              builder: (isHovered) {
                                bool _heigth = isHovered;
                                return Container(
                                  padding: EdgeInsets.only(
                                      left: _heigth ? 20 : 10,
                                      right: _heigth ? 20 : 10,
                                      top: _heigth ? 20 : 10,
                                      bottom: _heigth ? 20 : 10),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                          categoryView.getPreviousPageList?[index].thumbnail ?? "",
                                          fit: BoxFit.fill,
                                          width: 50,
                                          height: 50)),
                                );
                              },
                              hovered: Matrix4.identity()..translate(0, 0, 0)),
                        );
                      }),
              ),
                  ),
              categoryView.isLoading == true
                  ? Positioned(
                  bottom: 8,
                  left: 1,
                  right: 1,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ))
                  : SizedBox(),
              isLogins == true
                  ? profile(context, setState)
                  : Container(),
            ],
          ));
    }
    else{
      return Container(
          height: SizeConfig.screenHeight * 1.5,
          child: Center(
            child:
            ThreeArchedCircle( size: 45.0),
          ) );
    }
  }

  contentWidget({Widget? videoList}) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        height: SizeConfig.screenHeight,
        child: videoList);
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
