
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
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
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
            homeViewModel!=null? GestureDetector(
              onTap: () {
                if (isSearch == true) {
                  isSearch = false;
                  searchController?.clear();
                  setState(() {});
                }
                if( isLogins == true){
                  isLogins=false;
                  setState(() {

                  });
                }
              },
              child: Scaffold( backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                appBar:  ResponsiveWidget.isMediumScreen(context)
                    ? homePageTopBar()
                    :
                PreferredSize(preferredSize: Size.fromHeight( ResponsiveWidget.isMediumScreen(context)? 50:55),
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
                                  RoutesName.Contact,
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
                                    if( isLogins == true){
                                      isLogins=false;
                                      setState(() {

                                      });
                                    }
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
                              onPressed: () {
                                if (isSearch == true) {
                                  isSearch = false;
                                  searchController?.clear();
                                  setState(() {});
                                }
                              }),
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
                                if (isSearch == true) {
                                  isSearch = false;
                                  searchController?.clear();
                                  setState(() {});
                                }
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
                    )),
                body: Scaffold(
                    key: _scaffoldKey,
                drawer: AppMenu(homeViewModel: homeViewModel),
                body: ResponsiveWidget.isMediumScreen(context)?  Stack(
                  children: [
                    homeViewModel.homePageDataModel != null
                        ?  SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 20, top: 30,bottom: 15), child: AppBoldFont(context,msg: widget.title ?? "",fontSize: 16)),
                          Container(padding: EdgeInsets.only(left: 10, right: 10),
                            child: GridView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                controller: _scrollController,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing:  8.0,
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
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5,right: 5),
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
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(height: 80),
                          footerMobile(context)
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
                        ? profile(context, setState)
                        : Container(),
                    if (homeViewModel.searchDataModel != null)
                      searchView(context, homeViewModel, isSearch, scrollController, homeViewModel, searchController!, setState)
                  ],
                ):
                Stack(
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
                          ? profile(context, setState)
                          : Container(),
                      if (homeViewModel.searchDataModel != null)
                        searchView(context, homeViewModel, isSearch, scrollController, homeViewModel, searchController!, setState)
                    ],
                  )
          ),
              ),
            ):
          Container();
        }));
  }

  homePageTopBar() {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        title: Stack(children: <Widget>[
          Container(
              child: Row(children: [
                GestureDetector(
                    onTap: () {
                      if (isSearch == true) {
                        isSearch = false;
                        searchController?.clear();
                        setState(() {});
                      }
                      if( isLogins == true){
                        isLogins=false;
                        setState(() {

                        });
                      }
                      names == "null"
                          ? showDialog(context: context, barrierColor: Colors.black87, builder: (BuildContext context) {return const SignUp();}):

                      _scaffoldKey.currentState?.isDrawerOpen == false?
                      _scaffoldKey.currentState?.openDrawer()
                          :
                      _scaffoldKey.currentState?.openEndDrawer();

                    },
                    child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: Color(0xff001726),
                            borderRadius: BorderRadius.circular(2)
                        ),
                        child: Image.asset(
                          'images/ic_menu.png',
                          height: 25,
                          width: 25,
                        ))),
                Container(
                    height: 45,
                    width: SizeConfig.screenWidth * 0.58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: TRANSPARENT_COLOR, width: 1.0),
                    ),
                    child: AppTextField(
                        controller: searchController,
                        maxLine: searchController!.text.length > 2 ? 2 : 1,
                        textCapitalization: TextCapitalization.words,
                        secureText: false,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        maxLength: 30,
                        labelText: 'Search videos, shorts, products',
                        keyBoardType: TextInputType.text,
                        onChanged: (m) {
                          isSearch = true;
                        },
                        isTick: null)),
                names == "null"
                    ? ElevatedButton(onPressed: (){
                  showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder:
                          (BuildContext context) {
                        return const SignUp();
                      });

                }, child:Text(
                  "Sign Up",style: TextStyle(
                    color: Theme.of(context).canvasColor,fontSize: 16,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily
                ),
                ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).cardColor),
                        overlayColor: MaterialStateColor
                            .resolveWith((states) =>
                        Theme.of(context).primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(Size(90, 35)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    5.0
                                )))
                    ))
                    : GestureDetector(
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
                      SizedBox(width: SizeConfig.screenWidth*0.1),
                      Image.asset(
                        'images/LoginUser.png',
                        height: 30,
                        color:
                        Theme
                            .of(context)
                            .canvasColor,
                      ),
                    ],
                  ),
                ),
              ]))
        ]));
  }
}
