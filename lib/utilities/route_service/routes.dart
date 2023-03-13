// import 'dart:js';
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tycho_streams/model/data/HomePageDataModel.dart';
// import 'package:tycho_streams/utilities/route_service/routes_name.dart';
// import 'package:tycho_streams/view/WebScreen/AboutUs.dart';
// import 'package:tycho_streams/view/WebScreen/Career.dart';
// import 'package:tycho_streams/view/WebScreen/DetailPage.dart';
// import 'package:tycho_streams/view/WebScreen/FAQ.dart';
// import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
// import 'package:tycho_streams/view/WebScreen/Privacy.dart';
// import 'package:tycho_streams/view/WebScreen/ViewAllListPages.dart';
// import 'dart:html' as html;
//
// import '../../main.dart';
// import '../../view/WebScreen/Terms.dart';
//
//
// class MyAppRouter {
//   late GoRouter _router= GoRouter(
//     routes: [
//       GoRoute(
//         name: RoutesName.home,
//         path: '/',
//         pageBuilder: (context, state) {
//           return MaterialPage(child: HomePageWeb());
//         },
//
//       ),
//       GoRoute(
//         name: RoutesName.FAQ,
//         path: '/FAQ',
//         pageBuilder: (context, state) {
//           html.window.history.pushState(state.fullpath, '', state.fullpath);
//           return MaterialPage(child: FAQ(
//           ));
//         },
//       ),
//       GoRoute(
//         name: RoutesName.Career,
//         path: '/Career',
//         pageBuilder: (context, state) {
//           return MaterialPage(child: Career(
//           ));
//         },
//       ),
//       GoRoute(
//         name: RoutesName.Privacy,
//         path: '/Privacy',
//         pageBuilder: (context, state) {
//           return MaterialPage(child: Privacy(
//           ));
//         },
//       ),
//       GoRoute(
//         name: RoutesName.Terms,
//         path: '/Terms',
//         pageBuilder: (context, state) {
//           return MaterialPage(child: Terms(
//           ));
//         },
//       ),
//       GoRoute(
//         name: RoutesName.AboutUs,
//         path: '/AboutUs',
//         pageBuilder: (context, state) {
//           return MaterialPage(child: AboutUs(
//           ));
//         },
//       ),
//       GoRoute(
//         name: RoutesName.DeatilPage,
//         path: '/MovieDetailPage',
//         pageBuilder: (context, state) {
//           state.queryParams.forEach((key, value) {
//             print("$key : $value");
//           });
//           return MaterialPage(
//               child: DetailPage(
//                 movieID: state.queryParams['movieID'],
//                 VideoId: state.queryParams['VideoId'],
//                 Title: state.queryParams['Title'],
//                 Desc: state.queryParams['Desc'],
//
//               ));
//         },
//         // redirect: (context,state){
//         //   if(){
//         //
//         //   }
//         // }
//       ),
//       GoRoute(
//         name: RoutesName.seaAll,
//         path: '/Seall',
//         pageBuilder: (context, state) {
//           state.queryParams.forEach((key, value) {
//             print("$key : $value");
//           });
//           return MaterialPage(child: SeeAllListPages(
//             VideoId: state.queryParams['VideoId'],
//             title: state.queryParams['title'],
//           ));
//         },
//
//       ),
//
//     ],
//     initialLocation: _getCurrentLocation(),
//     refreshListenable: _getRefreshListenable(),
//   );
//
//   String _getCurrentLocation() {
//     final uri = Uri.base;
//     return uri.path + uri.query;
//   }
//
//   ChangeNotifier _getRefreshListenable() {
//     return ChangeNotifier()
//       ..addListener(() {
//         if (_getCurrentLocation() != _router.location) {
//           _router.goNamed(_getCurrentLocation());
//         }
//       });
//   }
// }