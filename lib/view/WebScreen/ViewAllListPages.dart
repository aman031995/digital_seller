
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
  TextEditingController? searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isSearch = false;
  int pageNum = 1;
  @override
  void initState() {
    homeView.getMoreLikeThis(context, widget.VideoId ?? '');
    homeView.getAppConfigData(context);
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
        child: Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
          return
            homeViewModel!=null? Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: PreferredSize(preferredSize: Size.fromHeight( ResponsiveWidget.isMediumScreen(context)? 50:55),
                child: Container(
                  height: 55,
                  color: Theme.of(context).cardColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 40),
                      Image.asset(AssetsConstants.icLogo, height: 40),
                      Expanded(child: SizedBox(width: SizeConfig.screenWidth * .12)),
                      AppButton(context, 'Home', onPressed: () {
                        GoRouter.of(context)
                            .pushNamed(RoutesName.home);
                      }),
                      SizedBox(width: SizeConfig.screenWidth * .02),
                      AppButton(context, 'Contact US',
                          onPressed: () {
                            GoRouter.of(context).pushNamed(
                              RoutesName.ContactUsPage,
                            );
                          }),
                      Expanded(
                          child: SizedBox(
                              width: SizeConfig.screenWidth * .12)),
                      Container(
                          height: 45,
                          width: SizeConfig.screenWidth / 4.2,
                          alignment: Alignment.center,
                          child: AppTextField(
                              controller: searchController,
                              maxLine: searchController!.text.length > 2 ? 2 : 1,
                              textCapitalization:
                              TextCapitalization.words,
                              secureText: false,
                              floatingLabelBehavior:
                              FloatingLabelBehavior.never,
                              maxLength: 30,
                              labelText:
                              'Search videos, shorts, products',
                              keyBoardType: TextInputType.text,
                              onChanged: (m) {
                                isSearch = true;
                              },
                              isTick: null)),
                      SizedBox(width: SizeConfig.screenWidth * .02),
                      names == "null"
                          ? OutlinedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierColor: Colors.black87,
                                builder:
                                    (BuildContext context) {
                                  return const SignUp();
                                });
                          },
                          style: ButtonStyle(
                            overlayColor:
                            MaterialStateColor.resolveWith(
                                    (states) =>
                                Theme.of(context)
                                    .primaryColor),
                            fixedSize:
                            MaterialStateProperty.all(
                                Size.fromHeight(30)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        5.0))),
                          ),
                          child: appTextButton(
                              context,
                              'SignUp',
                              Alignment.center,
                              Theme.of(context).canvasColor,
                              18,
                              true))
                          : appTextButton(
                          context,
                          names!,
                          Alignment.center,
                          Theme.of(context).canvasColor,
                          18,
                          true,
                          onPressed: () {}),
                      names == "null"
                          ? SizedBox(
                          width: SizeConfig.screenWidth * .01)
                          : const SizedBox(),
                      names == "null"
                          ? OutlinedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierColor: Colors.black87,
                                builder:
                                    (BuildContext context) {
                                  return const LoginUp();
                                });
                          },
                          style: ButtonStyle(
                            overlayColor:
                            MaterialStateColor.resolveWith(
                                    (states) =>
                                Theme.of(context)
                                    .primaryColor),
                            fixedSize:
                            MaterialStateProperty.all(
                                Size.fromHeight(30)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        5.0))),
                          ),
                          child: appTextButton(
                              context,
                              'Login',
                              Alignment.center,
                              Theme.of(context).canvasColor,
                              18,
                              true))
                          : GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogins = true;
                          });
                        },
                        child: Image.asset(
                          'images/LoginUser.png',
                          height: 30,
                          color:
                          Theme.of(context).accentColor,
                        ),
                      ),
                      SizedBox(width: SizeConfig.screenWidth * .02),
                    ],
                  ),
                ),),
            drawer: AppMenu(homeViewModel: homeViewModel),
            body: ResponsiveWidget.isMediumScreen(context)?Container():

            GestureDetector(
              onTap: () {
                if (isSearch == true) {
                  isSearch = false;
                  setState(() {});
                }
              },
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    homeViewModel.homePageDataModel != null
                             ?  SingleChildScrollView(
                               child: Column(
                                 children: [
                                   Padding(padding: EdgeInsets.only(left: 40, top: 30), child: AppBoldFont(context,msg: widget.title ?? "",fontSize: 22)),
                                   GridView.builder(
                                           physics: AlwaysScrollableScrollPhysics(),
                                           shrinkWrap: true,
                                           controller: _scrollController,
                                           gridDelegate:
                                               SliverGridDelegateWithFixedCrossAxisCount(
                                                   crossAxisCount: 4,
                                                   crossAxisSpacing: 9.0,
                                                   mainAxisSpacing:  5.0,
                                                   childAspectRatio: 1.5),
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
                                                           left: _heigth ? 20 :10,
                                                           right: _heigth ? 20 :10,
                                                           top:_heigth ? 20 :10,
                                                           bottom:  _heigth ? 20 :10),
                                                       height:  SizeConfig.screenHeight * 3.5,
                                                       child: ClipRRect(
                                                           borderRadius:
                                                               BorderRadius.circular(15),
                                                           child: Image.network(
                                                             homeViewModel
                                                                 .homePageDataModel
                                                                 ?.videoList?[index]
                                                                 .thumbnail ??
                                                                 '',
                                                               fit: BoxFit.fill,width: 50,height: 50)),
                                                     );
                                                   },
                                                   hovered: Matrix4.identity()
                                                     ..translate(0, 0, 0)),
                                             );
                                           }),
                                   SizedBox(height: 80),
                                         footerDesktop()
                                 ],
                               ),
                             )
                        : Container(
                                 height: SizeConfig.screenHeight * 1.5,
                                 child: Center(
                                   child:
                                       ThreeArchedCircle( size: 45.0),
                                 ) ),

                    isLogins == true
                        ? Positioned(
                        top: 10,
                        right: 20,
                        child: Container(
                          height: 80, width: 150,
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              appTextButton(
                                  context,
                                  "My Account",
                                  Alignment.center,
                                  Theme.of(context).canvasColor,
                                  18,
                                  false, onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditProfile();
                                    });
                                setState(() {
                                  isLogins = false;
                                });
                              }),
                              SizedBox(height: 5),
                              Container(
                                height: 1,
                                color: Colors.black,
                              ),
                              SizedBox(height: 5),
                              appTextButton(
                                  context,
                                  "LogOut",
                                  Alignment.center,
                                  Theme.of(context).canvasColor,
                                  18,
                                  false, onPressed: () {
                                setState(() {
                                  authVM.logoutButtonPressed(context);
                                  isLogins = false;
                                  isLogin=false;
                                });
                              }),
                            ],
                          ),
                          color: Theme.of(context).cardColor,
                          // height: 20,width: 20,
                        ))
                        : Container(),
                    if (homeViewModel.searchDataModel != null)
                      searchView(context, homeViewModel, isSearch, _scrollController, homeViewModel, searchController!, setState)
                  ],
                ),
              ),
            )

            // body: SingleChildScrollView(
            //     child:   ResponsiveWidget.isMediumScreen(context)?
            //   contentMobileWidget( videoList: homeViewModel.homePageDataModel != null
            //       ?  SingleChildScrollView(
            //         child: Column(
            //           children: [
            //             Container(
            //               width: 250,
            //               child: GridView.builder(
            //               physics: ScrollPhysics(),
            //               shrinkWrap: true,
            //               controller: _scrollController,
            //               gridDelegate:
            //               SliverGridDelegateWithFixedCrossAxisCount(
            //                   crossAxisCount: 1,
            //                   crossAxisSpacing: 5,
            //                   mainAxisSpacing:  15,
            //                   childAspectRatio: 1.8),
            //               itemCount:  homeViewModel.homePageDataModel!.videoList!.length,
            //               itemBuilder: (context, index) {
            //                 return InkWell(
            //                   onTap: () {
            //                     GoRouter.of(context).pushNamed(RoutesName.DeatilPage,queryParams: {
            //                       'movieID':"${homeViewModel.homePageDataModel?.videoList?[index].youtubeVideoId}",
            //                       'VideoId':'${homeViewModel.homePageDataModel?.videoList?[index].videoId}',
            //                       'Title':"${homeViewModel.homePageDataModel?.videoList?[index].videoTitle}",
            //                       'Desc':'${homeViewModel.homePageDataModel?.videoList?[index].videoDescription}'
            //                       // 'movieID':'${homeViewModel.homePageDataModel?.moviesList?.youtubeVideoId}',
            //                       // 'VideoId':'${widget.moviesList?.videoId}',
            //                       // 'Title':'${widget.moviesList?.videoTitle}',
            //                       // 'Desc':'${widget.moviesList?.videoDescription}'
            //                       // 'platformMovieData':'${widget.moviesList}'
            //                     });
            //                     // Navigator.of(context, rootNavigator: true)
            //                     //     .push(MaterialPageRoute(
            //                     //     builder: (context) =>
            //                     //     new DetailPage(
            //                     //       // platformMovieData: categoryView
            //                     //       //     .getPreviousPageList[index],
            //                     //       movieID: categoryView
            //                     //           .getPreviousPageList[index]
            //                     //           .youtubeVideoId,
            //                     //     )));
            //
            //                   },
            //                   child: OnHover(
            //                       builder: (isHovered) {
            //                         return Container(
            //                           child: ClipRRect(
            //                               borderRadius:
            //                               BorderRadius.circular(15),
            //                               child: Image.network(
            //                                   homeViewModel
            //                                       .homePageDataModel
            //                                       ?.videoList?[index]
            //                                       .thumbnail ??
            //                                       '',
            //                                 fit: BoxFit.fill)),
            //                         );
            //                       },
            //                       hovered: Matrix4.identity()
            //                         ..translate(0, 0, 0)),
            //                 );
            //               }),
            //             ),
            //             SizedBox(height: 40),
            //             footerMobile(context)
            //           ],
            //         ),
            //       )
            //       : Container(
            //     height: SizeConfig.screenHeight * 0.8,
            //     child: Center(
            //       child:
            //       ThreeArchedCircle( size: 45.0),
            //     ),
            //   )) :
            // contentWidget(
            //      videoList: homeViewModel.homePageDataModel != null
            //          ?  GridView.builder(
            //                  physics: AlwaysScrollableScrollPhysics(),
            //                  shrinkWrap: true,
            //                  controller: _scrollController,
            //                  gridDelegate:
            //                      SliverGridDelegateWithFixedCrossAxisCount(
            //                          crossAxisCount:
            //                              ResponsiveWidget.isMediumScreen(context)
            //                                  ? 1
            //                                  : 4,
            //                          crossAxisSpacing: ResponsiveWidget.isMediumScreen(context)?5:9.0,
            //                          mainAxisSpacing:  ResponsiveWidget.isMediumScreen(context)?15:5.0,
            //                          childAspectRatio: ResponsiveWidget.isMediumScreen(context)
            //                              ? 1.8:1.5),
            //                  itemCount:  homeViewModel.homePageDataModel!.videoList!.length,
            //                  itemBuilder: (context, index) {
            //                    return InkWell(
            //                      onTap: () {
            //                        GoRouter.of(context).pushNamed(RoutesName.DeatilPage,queryParams: {
            //                          'movieID':"${homeViewModel.homePageDataModel?.videoList?[index].youtubeVideoId}",
            //                          'VideoId':'${homeViewModel.homePageDataModel?.videoList?[index].videoId}',
            //                          'Title':"${homeViewModel.homePageDataModel?.videoList?[index].videoTitle}",
            //                          'Desc':'${homeViewModel.homePageDataModel?.videoList?[index].videoDescription}'
            //                        });
            //                      },
            //                      child: OnHover(
            //                          builder: (isHovered) {
            //                            bool _heigth = isHovered;
            //                            return Container(
            //                              margin: EdgeInsets.only(left: 25,right: 25),
            //                              padding: EdgeInsets.only(
            //                                  left:ResponsiveWidget.isMediumScreen(context)?0: _heigth ? 20 :10,
            //                                  right: ResponsiveWidget.isMediumScreen(context)? 0:_heigth ? 20 :10,
            //                                  top: ResponsiveWidget.isMediumScreen(context)? 0:_heigth ? 20 :10,
            //                                  bottom: ResponsiveWidget.isMediumScreen(context)?0: _heigth ? 20 :10),
            //                              height: ResponsiveWidget.isMediumScreen(
            //                                      context)
            //                                  ? 1000
            //                                  : SizeConfig.screenHeight * 0.5,
            //                              child: ClipRRect(
            //                                  borderRadius:
            //                                      BorderRadius.circular(15),
            //                                  child: Image.network(
            //                                    homeViewModel
            //                                        .homePageDataModel
            //                                        ?.videoList?[index]
            //                                        .thumbnail ??
            //                                        '',
            //                                      fit: BoxFit.fill,width: 50,height: 50,)),
            //                            );
            //                          },
            //                          hovered: Matrix4.identity()
            //                            ..translate(0, 0, 0)),
            //                    );
            //                  })
            //
            //          : Container(
            //              height: SizeConfig.screenHeight * 1.5,
            //              child: Center(
            //                child:
            //                    ThreeArchedCircle( size: 45.0),
            //              ),
            //            ))),
          ):
          Container();
        }));
  }


  // contentWidget({Widget? videoList}) {
  //   return Stack(
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(left: 40, top: 30),
  //             child: AppBoldFont(context,msg: widget.title ?? "",fontSize: 22),
  //           ),
  //           Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(15),
  //               ),
  //               margin: EdgeInsets.only(left: 20, top: 15, right: 20),
  //               height: SizeConfig.screenHeight,
  //               child: videoList),
  //           SizedBox(height: 80),
  //       footerDesktop()
  //         ],
  //       ),
  //       isLogins == true
  //           ? Positioned(
  //           top: 10,
  //           right: 20,
  //           child: Container(
  //             height: 80, width: 150,
  //             child: Column(
  //               children: [
  //                 SizedBox(height: 5),
  //                 appTextButton(
  //                     context,
  //                     "My Account",
  //                     Alignment.center,
  //                     Theme.of(context).canvasColor,
  //                     18,
  //                     false, onPressed: () {
  //                   showDialog(
  //                       context: context,
  //                       builder: (BuildContext context) {
  //                         return EditProfile();
  //                       });
  //                   setState(() {
  //                     isLogins = false;
  //                   });
  //                 }),
  //                 SizedBox(height: 5),
  //                 Container(
  //                   height: 1,
  //                   color: Colors.black,
  //                 ),
  //                 SizedBox(height: 5),
  //                 appTextButton(
  //                     context,
  //                     "LogOut",
  //                     Alignment.center,
  //                     Theme.of(context).canvasColor,
  //                     18,
  //                     false, onPressed: () {
  //                   setState(() {
  //                     logoutButtonPressed();
  //                     isLogins = false;
  //                   });
  //                 }),
  //               ],
  //             ),
  //             color: Theme.of(context).cardColor,
  //             // height: 20,width: 20,
  //           ))
  //           : Container(),
  //     ],
  //   );
  // }
  // contentMobileWidget({Widget? videoList}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.only(left: 40, top: 30,bottom: 20),
  //         child: AppBoldFont(context,msg: widget.title ?? "",fontSize: 18),
  //       ),
  //       Center(
  //         child: Container(
  //           width: SizeConfig.screenWidth,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: videoList),
  //       ),
  //
  //     ],
  //   );
  // }
  // logoutButtonPressed() async {
  //   AppDataManager.deleteSavedDetails();
  //   CacheDataManager.clearCachedData();
  //   isLogin=false;
  //   GoRouter.of(context).pushNamed(RoutesName.home);
  // }
}
