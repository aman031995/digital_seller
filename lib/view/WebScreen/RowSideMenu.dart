// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:share/share.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sidebarx/sidebarx.dart';
// import 'package:TychoStream/Utilities/AssetsConstants.dart';
// import 'package:TychoStream/main.dart';
// import 'package:TychoStream/model/data/app_menu_model.dart';
// import 'package:TychoStream/utilities/SizeConfig.dart';
// import 'package:TychoStream/utilities/route_service/routes_name.dart';
// import 'package:TychoStream/view/WebScreen/HomePageWeb.dart';
// import 'package:TychoStream/view/WebScreen/LoginUp.dart';
// import 'package:TychoStream/viewmodel/HomeViewModel.dart';
// import 'package:TychoStream/viewmodel/auth_view_model.dart';
//
// class SidebarXExampleApp extends StatefulWidget {
//   HomeViewModel? homeViewModel;
//   SidebarXExampleApp({Key? key}) : super(key: key);
//
//   @override
//   State<SidebarXExampleApp> createState() => _SidebarXExampleAppState();
// }
//
// class _SidebarXExampleAppState extends State<SidebarXExampleApp> {
//   HomeViewModel homeViewModel = HomeViewModel();
//   final _key = GlobalKey<ScaffoldState>();
//   List<String> urlList = [];
//
//   @override
//   void initState() {
//     super.initState();
//   homeViewModel.getAppConfigData(context);
//
//   }
//
//
//   // getMenu() async{
//   //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   //   if(sharedPreferences.get('oldMenuVersion') == sharedPreferences.get('newMenuVersion')){
//   //     homeViewModel.getAppMenuData(context);
//   //   } else {
//   //     homeViewModel.getAppMenu(context);
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Builder(
//         builder: (context) {
//           final isSmallScreen = MediaQuery.of(context).size.width < 1200;
//           return ChangeNotifierProvider(
//               create: (BuildContext context) => homeViewModel,
//               child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
//                 final menuItem = viewmodel.appMenuModel;
//                 return GestureDetector(
//                   onTap: (){
//                     names == "null"
//                         ? showDialog(
//                         context: context,
//                         barrierColor: Colors.black87,
//                         builder: (BuildContext context) {
//                           return  LoginUp();
//                         })
//                         : null;
//                     if (isSearch == true) {
//                       isSearch = false;
//                       setState(() {});
//                     }
//                     if (isLogins == true) {
//                       isLogins = false;
//                       setState(() {});
//                     }
//                   },
//
//                   child: SizedBox(
//                     width: SizeConfig.screenWidth * 0.60,
//                     child: Scaffold(
//                       body: Container(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (!isSmallScreen) Drawer(
//                                 backgroundColor: Theme.of(context).cardColor,
//                                 child: viewmodel.appMenuModel != null
//                                     ? Column(
//                                       children: [
//                                         Container(
//                                           margin: EdgeInsets.only(top: 10, left: 10),
//                                             alignment: Alignment.centerLeft,
//                                             child: Image.asset(AssetsConstants.icLogo, height: 45, width: 45, alignment: Alignment.topLeft,)),
//                                         Container(
//                                   margin: EdgeInsets.only(top: 20),
//                                         color: Theme.of(context).cardColor,
//                                         child: ListView.builder(
//                                             shrinkWrap: true,
//                                             physics: BouncingScrollPhysics(),
//                                             itemCount: menuItem?.appMenu?.length,
//                                             itemBuilder: (context, index) {
//                                               final appMenuItem = menuItem?.appMenu?[index];
//                                               return InkWell(
//                                                   onTap: () {
//                                                     onItemSelection(context, appMenuItem);
//                                                   },
//                                                   child: Column(
//                                                       children: [
//                                                         appMenuItem!.childNodes!.isNotEmpty ?
//                                                         Theme(
//                                                           data: Theme.of(context).copyWith(dividerColor: Theme.of(context).canvasColor.withOpacity(0.2)),
//                                                           child: ExpansionTile(
//                                                             // tilePadding: EdgeInsets.only(left: 18, right: 15),
//                                                               leading: Image.network(appMenuItem.icon ?? '', color: Theme.of(context).canvasColor, height: 20, width: 20),
//                                                               title: Transform(
//                                                                   transform: Matrix4.translationValues(-20, 0.0, 0.0),
//                                                                   child: Text(appMenuItem.title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
//                                                               iconColor: Theme.of(context).primaryColor,
//                                                               collapsedIconColor: Theme.of(context).canvasColor,
//                                                               children: [
//                                                                 ListView.builder(
//                                                                     shrinkWrap: true,
//                                                                     itemCount: appMenuItem.childNodes?.length,
//                                                                     physics: BouncingScrollPhysics(),
//                                                                     itemBuilder: (BuildContext? context, int index1) {
//                                                                       return appMenuItem.childNodes![index1].childNodes!.isNotEmpty  ?
//                                                                       ExpansionTile(
//                                                                           leading: Image.network(appMenuItem.childNodes?[index1].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
//                                                                           title: Transform(
//                                                                               transform: Matrix4.translationValues(-20, 0.0, 0.0),
//                                                                               child: Text(appMenuItem.childNodes?[index1].title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
//                                                                           iconColor: Theme.of(context).primaryColor,
//                                                                           collapsedIconColor: Theme.of(context).canvasColor,
//                                                                           children: [
//                                                                             ListView.builder(
//                                                                                 shrinkWrap: true,
//                                                                                 physics: BouncingScrollPhysics(),
//                                                                                 itemCount: appMenuItem.childNodes?[index1].childNodes?.length,
//                                                                                 itemBuilder: (BuildContext? context, int index2) {
//                                                                                   return appMenuItem.childNodes![index1].childNodes![index2].childNodes!.isNotEmpty ? ExpansionTile(
//                                                                                       leading: Image.network(appMenuItem.childNodes?[index1].childNodes![index2].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
//                                                                                       title: Transform(
//                                                                                           transform: Matrix4.translationValues(-20, 0.0, 0.0),
//                                                                                           child: Text(appMenuItem.childNodes?[index1].childNodes![index2].title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
//                                                                                       iconColor: Theme.of(context).primaryColor,
//                                                                                       collapsedIconColor: Theme.of(context).canvasColor,
//                                                                                       children: [
//                                                                                         ListView.builder(
//                                                                                             shrinkWrap: true,
//                                                                                             physics: BouncingScrollPhysics(),
//                                                                                             itemCount: appMenuItem.childNodes?[index1].childNodes![index2].childNodes?.length,
//                                                                                             itemBuilder: (BuildContext? context, int index3) {
//                                                                                               return ListTile(
//                                                                                                 leading: Image.network(appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
//                                                                                                 title: Text(appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
//                                                                                                 minLeadingWidth : 2,
//                                                                                                 onTap: () {
//                                                                                                   onItemSelection(context, appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3]);
//                                                                                                 },
//                                                                                               );
//                                                                                             }),
//                                                                                       ]) :
//                                                                                   ListTile(
//                                                                                     leading: Image.network(appMenuItem.childNodes?[index1].childNodes?[index2].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
//                                                                                     title: Text(appMenuItem.childNodes?[index1].childNodes?[index2].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
//                                                                                     minLeadingWidth : 2,
//                                                                                     onTap: () {
//                                                                                       onItemSelection(context, appMenuItem.childNodes?[index1].childNodes?[index2]);
//                                                                                     },
//                                                                                   );
//                                                                                 }),
//                                                                           ]) :
//                                                                       ListTile(
//                                                                           leading: Image.network(appMenuItem.childNodes?[index1].icon ?? '', color: Theme.of(context!).canvasColor,  height: 20, width: 20),
//                                                                           title: Text(appMenuItem.childNodes?[index1].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
//                                                                           minLeadingWidth : 2,
//                                                                           onTap: () {
//                                                                             onItemSelection(context, appMenuItem.childNodes?[index1]);
//                                                                           });
//                                                                     }),
//                                                               ]),
//                                                         ) :
//                                                         ListTile(
//                                                             leading: Image.network(appMenuItem.icon ?? '', color: Theme.of(context).canvasColor, height: 20, width: 20),
//                                                             title: Text(appMenuItem.title ?? '', style: TextStyle(color: Theme.of(context).canvasColor)),
//                                                             minLeadingWidth : 2,
//                                                             onTap: () {
//                                                               onItemSelection(context, appMenuItem);
//                                                             })
//                                                       ]
//                                                   ));
//                                             })),
//                                       ],
//                                     )
//                                     : Center(
//                                     child: CircularProgressIndicator(color: Theme.of(context).primaryColor))),
//                             Expanded(
//                               child: Center(
//                                  child: HomePageWeb())
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }));
//
//         },
//     );
//   }
//
//
//   void onItemSelection(BuildContext context, Menu? appMenu) {
//     if(names == "null"){
//          showDialog(
//         context: context,
//         barrierColor: Colors.black87,
//         builder: (BuildContext context) {
//           return  LoginUp();
//         });}
//     else if(appMenu != null){
//       if (appMenu.title?.contains('Share') == true) {
//         Share.share(appMenu.url ?? '');
//       } else if (appMenu.url?.contains('push_notification') == true) {
//         // getPath(appMenu.url ?? '', RoutesName.pushNotification).then((routePath) {
//         //   if (routePath != null) {
//         //     Navigator.pushNamed(context, routePath, arguments: {'title': appMenu.title});
//         //   }
//         // });
//       } else if (appMenu.url?.contains('terms-and-conditions') == true) {
//         GoRouter.of(context).pushNamed(RoutesName.Terms);
//         // getPath(appMenu.url ?? '', RoutesName.Terms).then((path){
//         //   if(path != null){
//         //     Router.neglect(context, () =>  GoRouter.of(context).pushNamed(path));
//         //   }
//         // });
//         // Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //         builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
//       } else if (appMenu.url?.contains('privacy-policy') == true) {
//   GoRouter.of(context).pushNamed(RoutesName.Privacy);
//         // Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //         builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
//       } else if (appMenu.url?.contains('profile') == true) {
//        GoRouter.of(context).pushNamed(RoutesName.EditProfille);
//         // getPath(appMenu.url ?? '', RoutesName.profilePage).then((routePath) {
//         //   if (routePath != null) {
//         //     Navigator.pushNamed(context, routePath, arguments: {'title': appMenu.title, 'isBack' : true});
//         //   }
//         // });
//       } else if (appMenu.url?.contains('home') == true){
//         reloadPage();
//        // GoRouter.of(context).pushNamed(RoutesName.home);
//         // getPath(appMenu.url ?? '', RoutesName.bottomNavigation).then((routePath) {
//         //   if (routePath != null) {
//         //     // Navigator.pushNamed(context, routePath);
//         //     Navigator.of(context)
//         //         .pushNamedAndRemoveUntil(routePath, (Route<dynamic> route) => false);
//         //   }
//         // });
//       } else if (appMenu.url?.contains('update_user') == true){
//         GoRouter.of(context).pushNamed(RoutesName.EditProfille);
//         // getPath(appMenu.url ?? '', RoutesName.editProfile).then((routePath) {
//         //    if (routePath != null) {
//         //      Navigator.pushNamed(context, routePath, arguments: {'title' : appMenu.title});
//         //    }
//         //  });
//       } else if (appMenu.url?.contains('faqs') == true){
//                  GoRouter.of(context).pushNamed(RoutesName.FAQ);
//         // Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //         builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
//       } else if (appMenu.url?.contains('notify_setting') == true){
//         // getPath(appMenu.url ?? '', RoutesName.notifysetting).then((routePath) {
//         //   if (routePath != null) {
//         //     Navigator.pushNamed(context, routePath, arguments: {'title' : appMenu.title});
//         //   }
//         // });
//       }
//        else if(appMenu.url?.contains('contact_us')==true){
//         GoRouter.of(context).pushNamed(RoutesName.ContactUs);
//
//       }
//     }
//   }
// }
//
// Future<String?> getPath(String url, String pathName) async {
//   RegExp pattern = RegExp(r"\" + '${pathName}');
//   Match match = pattern.firstMatch(url) as Match;
//   String? path = match.group(0);
//   return path;
// }
//
//
