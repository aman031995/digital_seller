import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/CommonCarousel.dart';
import 'package:tycho_streams/view/WebScreen/EditProfile.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/widgets/video_listpage.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

import '../../main.dart';
import '../widgets/app_menu.dart';

bool isLogin = false;
bool isLogins = false;

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  final List<String> genderItems = ['My Acount', 'Logout'];
  HomeViewModel homeViewModel = HomeViewModel();
  TextEditingController? editingController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  TextEditingController? searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isSearch = false;
  int pageNum = 1;

  void initState() {
    homeViewModel.getAppConfigData(context);
    searchController?.addListener(() {
      homeViewModel.getSearchData(
          context, '${searchController?.text}', pageNum);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return viewmodel != null
              ? Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: ResponsiveWidget.isMediumScreen(context)
                      ? homePageTopBar(viewmodel)
                      : null,
                  key: _scaffoldKey,
                  drawer: ResponsiveWidget.isMediumScreen(context)
                      ? AppMenu(homeViewModel: viewmodel)
                      : Container(),

                  //  drawer: ResponsiveWidget.isMediumScreen(context) ? MobileMenu(context) : Container(),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonCarousel(),
                            VideoListPage(),
                          ],
                        ),
                      ),
                      ResponsiveWidget.isMediumScreen(context)
                          ? Container()
                          : Container(
                              height: 50,
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
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: TRANSPARENT_COLOR,
                                              width: 1.0)),
                                      child: AppTextField(
                                          controller: searchController,
                                          maxLine:
                                              searchController!.text.length > 2
                                                  ? 2
                                                  : 1,
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
                            ),
                      isLogins == true
                          ? Positioned(
                              top: 50,
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
                                      });
                                    }),
                                  ],
                                ),
                                color: Theme.of(context).cardColor,
                                // height: 20,width: 20,
                              ))
                          : Container(),
                      if (viewmodel.searchDataModel != null)
                        searchView(viewmodel)
                    ],
                  ))
              : Container();
        }));
  }

  homePageTopBar(HomeViewModel viewmodel) {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Stack(children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(children: [
                GestureDetector(
                    onTap: () {
                      if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                        _scaffoldKey.currentState?.openDrawer();
                      } else {
                        _scaffoldKey.currentState?.openEndDrawer();
                      }
                    },
                    child: Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xff001726),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          'images/ic_menu.png',
                          height: 32,
                          width: 32,
                        ))),
                SizedBox(width: 3.0),
                GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(RoutesName.home);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => NotificationScreen()));
                    },
                    child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Color(0xff001726),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          AssetsConstants.icLogo,
                          height: 50,
                          width: 50,
                        ))),
                Container(
                    height: 55,
                    width: SizeConfig.screenWidth * 0.64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: TRANSPARENT_COLOR, width: 2.0),
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
                SizedBox(width: 3.0),
              ]))
        ]));
  }

  searchView(HomeViewModel viewmodel) {
    return viewmodel.searchDataModel!.searchList != null && isSearch == true
        ? Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 70),
            child: Stack(children: [
              if (isSearch)
                Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color:
                          viewmodel.searchDataModel != null && isSearch == true
                              ? Theme.of(context).scaffoldBackgroundColor
                              : TRANSPARENT_COLOR,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 2, color: Theme.of(context).primaryColor),
                    ),
                    child: viewmodel.searchDataModel!.searchList!.isNotEmpty
                        ? ListView.builder(
                            controller: _scrollController,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (_, index) {
                              _scrollController.addListener(() {
                                if (_scrollController.position.pixels ==
                                    _scrollController
                                        .position.maxScrollExtent) {
                                  onPagination(
                                      viewmodel.lastPage,
                                      viewmodel.nextPage,
                                      viewmodel.isLoading,
                                      searchController?.text ?? '');
                                }
                              });
                              return GestureDetector(
                                  onTap: () async {
                                    isSearch = false;

                                    GoRouter.of(context).pushNamed(
                                        RoutesName.DeatilPage,
                                        queryParams: {
                                          'movieID':
                                              '${viewmodel.searchDataModel?.searchList?[index].youtubeVideoId}',
                                          'VideoId':
                                              '${viewmodel.searchDataModel?.searchList?[index].videoId}',
                                          'Title':
                                              '${viewmodel.searchDataModel?.searchList?[index].videoTitle}',
                                          'Desc':
                                              '${viewmodel.searchDataModel?.searchList?[index].videoDescription}'
                                        });
                                    setState(() {
                                      searchController?.clear();
                                    });
                                  },
                                  child: Card(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: AppMediumFont(context,
                                          msg: viewmodel.searchDataModel
                                              ?.searchList?[index].videoTitle),
                                      leading: Image.network(viewmodel
                                              .searchDataModel
                                              ?.searchList?[index]
                                              .thumbnail ??
                                          ''),
                                    ),
                                  ));
                            },
                            itemCount:
                                viewmodel.searchDataModel?.searchList?.length)
                        : Center(
                            child: AppMediumFont(context,
                                msg: viewmodel.message,
                                color: Theme.of(context).canvasColor))),
              homeViewModel.isLoading == true
                  ? Positioned(
                      bottom: 7,
                      left: 1,
                      right: 1,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      )))
                  : SizedBox()
            ]))
        : Container();
  }

  onPagination(int lastPage, int nextPage, bool isLoading, String searchData) {
    if (isLoading) return;
    isLoading = true;
    if (nextPage <= lastPage) {
      homeViewModel.runIndicator(context);
      homeViewModel.getSearchData(context, searchData, nextPage);
    }
  }
}
//
// Widget MobileMenu(BuildContext context) {
//   final authVM = Provider.of<AuthViewModel>(context);
//   return MultiLevelDrawer(
//     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//     rippleColor: Theme.of(context).primaryColorDark,
//     subMenuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
//     divisionColor: Theme.of(context).primaryColorLight,
//     header: Container(
//       height: 150,
//       child: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Image.asset(
//             AssetsConstants.icLogo,
//             width: 100,
//             height: 100,
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//         ],
//       )),
//     ),
//     children: [
//       MLMenuItem(
//           trailing: Icon(Icons.arrow_right,
//               color: Theme.of(context).primaryColorLight),
//           leading: Icon(
//             Icons.home_filled,
//             color: Theme.of(context).primaryColorLight,
//           ),
//           content: Text(" Home",
//               style: TextStyle(color: Theme.of(context).primaryColorLight)),
//           onClick: () {
//             GoRouter.of(context).pushNamed(RoutesName.home);
//           }),
//       names == "null"
//           ? MLMenuItem(
//               trailing: Icon(Icons.login_sharp,
//                   color: Theme.of(context).primaryColorLight),
//               leading: Icon(
//                 Icons.upcoming_sharp,
//                 color: Theme.of(context).primaryColorLight,
//               ),
//               content: Text(" Login",
//                   style: TextStyle(color: Theme.of(context).primaryColorLight)),
//               onClick: () {
//                 Navigator.pop(context);
//                 showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     barrierColor: Colors.black87,
//                     builder: (BuildContext context) {
//                       return const LoginUp();
//                     });
//               })
//           : MLMenuItem(
//               trailing: Icon(Icons.login_outlined,
//                   color: Theme.of(context).primaryColorLight),
//               leading: Icon(
//                 Icons.upcoming_sharp,
//                 color: Theme.of(context).primaryColorLight,
//               ),
//               content: Text("Logout",
//                   style: TextStyle(color: Theme.of(context).primaryColorLight)),
//               onClick: () {
//                 authVM.logoutButtonPressed(context);
//               },
//             ),
//       MLMenuItem(
//           leading: Icon(
//             Icons.contacts,
//             color: Theme.of(context).primaryColorLight,
//           ),
//           trailing: Icon(Icons.arrow_right,
//               color: Theme.of(context).primaryColorLight),
//           content: Text(" Contact Us",
//               style: TextStyle(color: Theme.of(context).primaryColorLight)),
//           onClick: () {}),
//     ],
//   );
// }
