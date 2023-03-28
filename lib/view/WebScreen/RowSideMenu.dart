import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/model/data/app_menu_model.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/Career.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';

class SidebarXExampleApp extends StatefulWidget {
  HomeViewModel? homeViewModel;
  SidebarXExampleApp({Key? key}) : super(key: key);

  @override
  State<SidebarXExampleApp> createState() => _SidebarXExampleAppState();
}

class _SidebarXExampleAppState extends State<SidebarXExampleApp> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  HomeViewModel homeViewModel = HomeViewModel();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getMenu();
  }

  getMenu() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.get('oldMenuVersion') == sharedPreferences.get('newMenuVersion')){
      homeViewModel.getAppMenuData(context);
    } else {
      homeViewModel.getAppMenu(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 1200;
          return ChangeNotifierProvider(
              create: (BuildContext context) => homeViewModel,
              child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
                final menuItem = viewmodel.appMenuModel;
                return SizedBox(
                  width: SizeConfig.screenWidth * 0.60,
                  child: Scaffold(
                    key: _key,
                    appBar: isSmallScreen
                        ? AppBar(
                      backgroundColor: Theme.of(context).cardColor,
                      // title: Text(_getTitleByIndex(_controller.selectedIndex)),
                      leading: IconButton(
                        onPressed: () {
                          // if (!Platform.isAndroid && !Platform.isIOS) {
                          //   _controller.setExtended(true);
                          // }
                          _key.currentState?.openDrawer();
                        },
                        icon: const Icon(Icons.menu),
                      ),
                    )

                        : null,
                    drawer: Drawer(
                        backgroundColor: Theme.of(context).cardColor,
                        child: viewmodel.appMenuModel != null
                            ? Container(
                            color: Theme.of(context).cardColor,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: menuItem?.appMenu?.length,
                                itemBuilder: (context, index) {
                                  final appMenuItem = menuItem?.appMenu?[index];
                                  return InkWell(
                                      onTap: () {
                                        onItemSelection(context, appMenuItem);
                                      },
                                      child: Column(
                                          children: [
                                            appMenuItem!.childNodes!.isNotEmpty ?
                                            Theme(
                                              data: Theme.of(context).copyWith(dividerColor: Theme.of(context).canvasColor.withOpacity(0.2)),
                                              child: ExpansionTile(
                                                // tilePadding: EdgeInsets.only(left: 18, right: 15),
                                                  leading: Image.network(appMenuItem.icon ?? '', color: Theme.of(context).canvasColor, height: 20, width: 20),
                                                  title: Transform(
                                                      transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                                      child: Text(appMenuItem.title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
                                                  iconColor: Theme.of(context).primaryColor,
                                                  collapsedIconColor: Theme.of(context).canvasColor,
                                                  children: [
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: appMenuItem.childNodes?.length,
                                                        physics: BouncingScrollPhysics(),
                                                        itemBuilder: (BuildContext? context, int index1) {
                                                          return appMenuItem.childNodes![index1].childNodes!.isNotEmpty  ?
                                                          ExpansionTile(
                                                              leading: Image.network(appMenuItem.childNodes?[index1].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                              title: Transform(
                                                                  transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                                                  child: Text(appMenuItem.childNodes?[index1].title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
                                                              iconColor: Theme.of(context).primaryColor,
                                                              collapsedIconColor: Theme.of(context).canvasColor,
                                                              children: [
                                                                ListView.builder(
                                                                    shrinkWrap: true,
                                                                    physics: BouncingScrollPhysics(),
                                                                    itemCount: appMenuItem.childNodes?[index1].childNodes?.length,
                                                                    itemBuilder: (BuildContext? context, int index2) {
                                                                      return appMenuItem.childNodes![index1].childNodes![index2].childNodes!.isNotEmpty ? ExpansionTile(
                                                                          leading: Image.network(appMenuItem.childNodes?[index1].childNodes![index2].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                                          title: Transform(
                                                                              transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                                                              child: Text(appMenuItem.childNodes?[index1].childNodes![index2].title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
                                                                          iconColor: Theme.of(context).primaryColor,
                                                                          collapsedIconColor: Theme.of(context).canvasColor,
                                                                          children: [
                                                                            ListView.builder(
                                                                                shrinkWrap: true,
                                                                                physics: BouncingScrollPhysics(),
                                                                                itemCount: appMenuItem.childNodes?[index1].childNodes![index2].childNodes?.length,
                                                                                itemBuilder: (BuildContext? context, int index3) {
                                                                                  return ListTile(
                                                                                    leading: Image.network(appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                                                    title: Text(appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                                                    minLeadingWidth : 2,
                                                                                    onTap: () {
                                                                                      onItemSelection(context, appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3]);
                                                                                    },
                                                                                  );
                                                                                }),
                                                                          ]) :
                                                                      ListTile(
                                                                        leading: Image.network(appMenuItem.childNodes?[index1].childNodes?[index2].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                                        title: Text(appMenuItem.childNodes?[index1].childNodes?[index2].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                                        minLeadingWidth : 2,
                                                                        onTap: () {
                                                                          onItemSelection(context, appMenuItem.childNodes?[index1].childNodes?[index2]);
                                                                        },
                                                                      );
                                                                    }),
                                                              ]) :
                                                          ListTile(
                                                              leading: Image.network(appMenuItem.childNodes?[index1].icon ?? '', color: Theme.of(context!).canvasColor,  height: 20, width: 20),
                                                              title: Text(appMenuItem.childNodes?[index1].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                              minLeadingWidth : 2,
                                                              onTap: () {
                                                                onItemSelection(context, appMenuItem.childNodes?[index1]);
                                                              });
                                                        }),
                                                  ]),
                                            ) :
                                            ListTile(
                                                leading: Image.network(appMenuItem.icon ?? '', color: Theme.of(context).canvasColor, height: 20, width: 20),
                                                title: Text(appMenuItem.title ?? '', style: TextStyle(color: Theme.of(context).canvasColor)),
                                                minLeadingWidth : 2,
                                                onTap: () {
                                                  onItemSelection(context, appMenuItem);
                                                })
                                          ]
                                      ));
                                }))
                            : Center(
                            child: CircularProgressIndicator(color: Theme.of(context).primaryColor))),
                    body: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!isSmallScreen) Drawer(
                              backgroundColor: Theme.of(context).cardColor,
                              child: viewmodel.appMenuModel != null
                                  ? Container(
                                margin: EdgeInsets.only(top: 50),
                                  color: Theme.of(context).cardColor,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: menuItem?.appMenu?.length,
                                      itemBuilder: (context, index) {
                                        final appMenuItem = menuItem?.appMenu?[index];
                                        return InkWell(
                                            onTap: () {
                                              onItemSelection(context, appMenuItem);
                                            },
                                            child: Column(
                                                children: [
                                                  appMenuItem!.childNodes!.isNotEmpty ?
                                                  Theme(
                                                    data: Theme.of(context).copyWith(dividerColor: Theme.of(context).canvasColor.withOpacity(0.2)),
                                                    child: ExpansionTile(
                                                      // tilePadding: EdgeInsets.only(left: 18, right: 15),
                                                        leading: Image.network(appMenuItem.icon ?? '', color: Theme.of(context).canvasColor, height: 20, width: 20),
                                                        title: Transform(
                                                            transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                                            child: Text(appMenuItem.title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
                                                        iconColor: Theme.of(context).primaryColor,
                                                        collapsedIconColor: Theme.of(context).canvasColor,
                                                        children: [
                                                          ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount: appMenuItem.childNodes?.length,
                                                              physics: BouncingScrollPhysics(),
                                                              itemBuilder: (BuildContext? context, int index1) {
                                                                return appMenuItem.childNodes![index1].childNodes!.isNotEmpty  ?
                                                                ExpansionTile(
                                                                    leading: Image.network(appMenuItem.childNodes?[index1].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                                    title: Transform(
                                                                        transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                                                        child: Text(appMenuItem.childNodes?[index1].title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
                                                                    iconColor: Theme.of(context).primaryColor,
                                                                    collapsedIconColor: Theme.of(context).canvasColor,
                                                                    children: [
                                                                      ListView.builder(
                                                                          shrinkWrap: true,
                                                                          physics: BouncingScrollPhysics(),
                                                                          itemCount: appMenuItem.childNodes?[index1].childNodes?.length,
                                                                          itemBuilder: (BuildContext? context, int index2) {
                                                                            return appMenuItem.childNodes![index1].childNodes![index2].childNodes!.isNotEmpty ? ExpansionTile(
                                                                                leading: Image.network(appMenuItem.childNodes?[index1].childNodes![index2].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                                                title: Transform(
                                                                                    transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                                                                    child: Text(appMenuItem.childNodes?[index1].childNodes![index2].title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
                                                                                iconColor: Theme.of(context).primaryColor,
                                                                                collapsedIconColor: Theme.of(context).canvasColor,
                                                                                children: [
                                                                                  ListView.builder(
                                                                                      shrinkWrap: true,
                                                                                      physics: BouncingScrollPhysics(),
                                                                                      itemCount: appMenuItem.childNodes?[index1].childNodes![index2].childNodes?.length,
                                                                                      itemBuilder: (BuildContext? context, int index3) {
                                                                                        return ListTile(
                                                                                          leading: Image.network(appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                                                          title: Text(appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                                                          minLeadingWidth : 2,
                                                                                          onTap: () {
                                                                                            onItemSelection(context, appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3]);
                                                                                          },
                                                                                        );
                                                                                      }),
                                                                                ]) :
                                                                            ListTile(
                                                                              leading: Image.network(appMenuItem.childNodes?[index1].childNodes?[index2].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                                              title: Text(appMenuItem.childNodes?[index1].childNodes?[index2].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                                              minLeadingWidth : 2,
                                                                              onTap: () {
                                                                                onItemSelection(context, appMenuItem.childNodes?[index1].childNodes?[index2]);
                                                                              },
                                                                            );
                                                                          }),
                                                                    ]) :
                                                                ListTile(
                                                                    leading: Image.network(appMenuItem.childNodes?[index1].icon ?? '', color: Theme.of(context!).canvasColor,  height: 20, width: 20),
                                                                    title: Text(appMenuItem.childNodes?[index1].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                                    minLeadingWidth : 2,
                                                                    onTap: () {
                                                                      onItemSelection(context, appMenuItem.childNodes?[index1]);
                                                                    });
                                                              }),
                                                        ]),
                                                  ) :
                                                  ListTile(
                                                      leading: Image.network(appMenuItem.icon ?? '', color: Theme.of(context).canvasColor, height: 20, width: 20),
                                                      title: Text(appMenuItem.title ?? '', style: TextStyle(color: Theme.of(context).canvasColor)),
                                                      minLeadingWidth : 2,
                                                      onTap: () {
                                                        onItemSelection(context, appMenuItem);
                                                      })
                                                ]
                                            ));
                                      }))
                                  : Center(
                                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor))),
                          Expanded(
                            child: Center(
                              child: HomePageWeb(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }));

        },
    );
  }
  void onItemSelection(BuildContext context, Menu? appMenu) {
    if(appMenu != null){
      if (appMenu.title?.contains('Share') == true) {
        Share.share(appMenu.url ?? '');
      } else if (appMenu.url?.contains('push_notification') == true) {
        // getPath(appMenu.url ?? '', RoutesName.pushNotification).then((routePath) {
        //   if (routePath != null) {
        //     Navigator.pushNamed(context, routePath, arguments: {'title': appMenu.title});
        //   }
        // });
      } else if (appMenu.url?.contains('terms-and-conditions') == true) {
        Router.neglect(context, () =>  GoRouter.of(context).pushNamed(RoutesName.Terms));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
      } else if (appMenu.url?.contains('privacy-policy') == true) {
        Router.neglect(context, () => GoRouter.of(context).pushNamed(RoutesName.Privacy));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
      } else if (appMenu.url?.contains('profile') == true) {
        Router.neglect(context, () => GoRouter.of(context).pushNamed(RoutesName.EditProfille));
        // getPath(appMenu.url ?? '', RoutesName.profilePage).then((routePath) {
        //   if (routePath != null) {
        //     Navigator.pushNamed(context, routePath, arguments: {'title': appMenu.title, 'isBack' : true});
        //   }
        // });
      } else if (appMenu.url?.contains('bottom_navigation') == true){
        Router.neglect(context, () =>  GoRouter.of(context).pushNamed(RoutesName.home));
        // getPath(appMenu.url ?? '', RoutesName.bottomNavigation).then((routePath) {
        //   if (routePath != null) {
        //     // Navigator.pushNamed(context, routePath);
        //     Navigator.of(context)
        //         .pushNamedAndRemoveUntil(routePath, (Route<dynamic> route) => false);
        //   }
        // });
      } else if (appMenu.url?.contains('update_user') == true){
        Router.neglect(context, () => GoRouter.of(context).pushNamed(RoutesName.EditProfille));
        // getPath(appMenu.url ?? '', RoutesName.editProfile).then((routePath) {
        //    if (routePath != null) {
        //      Navigator.pushNamed(context, routePath, arguments: {'title' : appMenu.title});
        //    }
        //  });
      } else if (appMenu.url?.contains('faqs') == true){
        Router.neglect(context, () =>  GoRouter.of(context).pushNamed(RoutesName.FAQ));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
      } else if (appMenu.url?.contains('notify_setting') == true){
        // getPath(appMenu.url ?? '', RoutesName.notifysetting).then((routePath) {
        //   if (routePath != null) {
        //     Navigator.pushNamed(context, routePath, arguments: {'title' : appMenu.title});
        //   }
        // });
      }
    }
  }
  // void onItemSelection(BuildContext context, Menu? appMenu) {
  //   if(appMenu != null){
  //     if (appMenu.title?.contains('Share') == true) {
  //       Share.share(appMenu.url ?? '');
  //     } else if (appMenu.url?.contains('push_notification') == true) {
  //       getPath(appMenu.url ?? '', RoutesName.DeatilPage).then((routePath) {
  //         if (routePath != null) {
  //           Navigator.pushNamed(context, routePath, arguments: {'title': appMenu.title});
  //         }
  //       });
  //     } else if (appMenu.url?.contains('terms-and-conditions') == true) {
  //       // Navigator.push(
  //       //     context,
  //       //     MaterialPageRoute(
  //       //         builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
  //     } else if (appMenu.url?.contains('privacy-policy') == true) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
  //     } else if (appMenu.url?.contains('profile') == true) {
  //       getPath(appMenu.url ?? '', RoutesName.FAQ).then((routePath) {
  //         if (routePath != null) {
  //           Navigator.pushNamed(context, routePath, arguments: {'title': appMenu.title, 'isBack' : true});
  //         }
  //       });
  //     } else if (appMenu.url?.contains('bottom_navigation') == true){
  //       getPath(appMenu.url ?? '', RoutesName.home).then((routePath) {
  //         if (routePath != null) {
  //           // Navigator.pushNamed(context, routePath);
  //           Navigator.of(context)
  //               .pushNamedAndRemoveUntil(routePath, (Route<dynamic> route) => false);
  //         }
  //       });
  //     } else if (appMenu.url?.contains('update_user') == true){
  //       getPath(appMenu.url ?? '', RoutesName.AboutUsPage).then((routePath) {
  //         if (routePath != null) {
  //           Navigator.pushNamed(context, routePath, arguments: {'title' : appMenu.title});
  //         }
  //       });
  //     } else if (appMenu.url?.contains('faqs') == true){
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
  //     } else if (appMenu.url?.contains('notify_setting') == true){
  //       getPath(appMenu.url ?? '', RoutesName.DeatilPage).then((routePath) {
  //         if (routePath != null) {
  //           Navigator.pushNamed(context, routePath, arguments: {'title' : appMenu.title});
  //         }
  //       });
  //     }
  //   }
  // }
}

Future<String?> getPath(String url, String pathName) async {
  RegExp pattern = RegExp(r"\" + '${pathName}');
  Match match = pattern.firstMatch(url) as Match;
  String? path = match.group(0);
  return path;
}


// class ExampleSidebarX extends StatefulWidget {
//   HomeViewModel? homeViewModel;
//    ExampleSidebarX({
//     Key? key,
//     required SidebarXController controller,
//   })  : _controller = controller,
//         super(key: key);
//
//   final SidebarXController _controller;
//
//   @override
//   State<ExampleSidebarX> createState() => _ExampleSidebarXState();
// }
//
// class _ExampleSidebarXState extends State<ExampleSidebarX> {
//   HomeViewModel homeViewModel = HomeViewModel();
//
//   @override
//   void initState() {
//     super.initState();
//     getMenu();
//   }
//   getMenu() async{
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     if(sharedPreferences.get('oldMenuVersion') == sharedPreferences.get('newMenuVersion')){
//       homeViewModel.getAppMenuData(context);
//     } else {
//       homeViewModel.getAppMenu(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (BuildContext context) => homeViewModel,
//         child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
//           final menuItem = viewmodel.appMenuModel;
//           List<SidebarXItem> sideList = [];
//           menuItem?.appMenu?.forEach((e) {
//             sideList.add(SidebarXItem(label: e.title,
//               iconWidget: Image.network(e.icon ?? '', height: 30, width:  30,
//                 ),
//               onTap: () {
//                 getPath(e.url ?? '', RoutesName.home).then((
//                     routePath) {
//                   if (routePath != null) {
//                     // Navigator.pushNamed(context, routePath);
//                     Navigator.of(context)
//                         .pushNamedAndRemoveUntil(routePath, (
//                         Route<dynamic> route) => false);
//                   }
//                 }
//                 );
//               }));
//           });
//
//
//           return SidebarX(
//             controller: widget._controller,
//             theme: SidebarXTheme(
//               margin: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Theme
//                     .of(context)
//                     .canvasColor,
//                 // borderRadius: BorderRadius.circular(20),
//               ),
//               hoverColor: Theme
//                   .of(context)
//                   .canvasColor.withOpacity(0.2),
//               textStyle: TextStyle(color: Theme.of(context).canvasColor ),
//               selectedTextStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
//               itemTextPadding: const EdgeInsets.only(left: 30),
//               selectedItemTextPadding: const EdgeInsets.only(left: 30),
//               itemDecoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 // color: Theme.of(context).canvasColor,
//                 // border: Border.all(color: Theme
//                 //     .of(context)
//                 //     .canvasColor),
//               ),
//               selectedItemDecoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Theme.of(context).canvasColor,
//                 // border: Border.all(
//                 //   color: Theme
//                 //       .of(context)
//                 //       .primaryColor,
//                 // ),
//                 // gradient: LinearGradient(
//                 //   colors: [Theme
//                 //       .of(context)
//                 //       .scaffoldBackgroundColor, Theme
//                 //       .of(context)
//                 //       .cardColor
//                 //   ],
//                 // ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.28),
//                     blurRadius: 30,
//                   )
//                 ],
//               ),
//               iconTheme: IconThemeData(
//                 color: Colors.white.withOpacity(0.7),
//                 size: 20,
//               ),
//               selectedIconTheme:  IconThemeData(
//                 color: Theme.of(context).primaryColor,
//                 size: 20,
//               ),
//             ),
//             extendedTheme: SidebarXTheme(
//               width: SizeConfig.screenWidth / 7.6,
//               decoration: BoxDecoration(
//                 color: Theme
//                     .of(context)
//                     .cardColor,
//               ),
//             ),
//             // footerDivider: divider,
//             headerBuilder: (context, extended) {
//               return SizedBox(
//                 height: 100,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 16.0, bottom: 25,),
//                   child: Image.asset(AssetsConstants.icLogo, height: 40),
//                 ),
//               );
//             },
//             items: sideList
//
//           );
//         }));
//   }
// }

