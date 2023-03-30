import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/route_service/routes.dart';
import 'package:tycho_streams/view/WebScreen/EditProfile.dart';
import 'package:tycho_streams/view/WebScreen/HomeViewPage.dart';
import 'package:tycho_streams/view/WebScreen/MovieListCommonWidget.dart';
import 'package:tycho_streams/view/WebScreen/RowSideMenu.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/repository/subscription_provider.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/CommonWidget.dart';
import 'package:tycho_streams/view/WebScreen/DetailPage.dart';
import 'package:tycho_streams/view/WebScreen/FAQ.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/Privacy.dart';
import 'package:tycho_streams/view/WebScreen/Terms.dart';
import 'package:tycho_streams/view/WebScreen/ViewAllListPages.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
import 'package:tycho_streams/viewmodel/sociallogin_view_model.dart';
import 'package:url_strategy/url_strategy.dart';

import 'view/WebScreen/contact_us.dart';
String? image;
String? names;
bool isLogin = false;
bool isLogins = false;
bool isSearch = false;
bool isProfile=false;
bool isDelete=false;
TextEditingController? searchController = TextEditingController();
Future<void> main() async {
  setPathUrlStrategy();
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyBaAbG2eNrQR2e1JmJcLj0N4QoKSv59Sb0",
    authDomain: "tychostreams.firebaseapp.com",
    storageBucket: "tychostreams.appspot.com",
    projectId: "tychostreams",
    messagingSenderId: "746850038788",
    appId: "1:746850038788:web:0e231dc5e9ead255407151",
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HomeViewModel homeViewModel = HomeViewModel();
  late GoRouter _router;
  @override
  void initState() {
    User();
    homeViewModel.getAppConfig(context);
    super.initState();

    _router = GoRouter(

      routes: [
        GoRoute(
          name: RoutesName.home,
          path: '/',
          pageBuilder: (context, state) {
            return MaterialPage(child: SidebarXExampleApp());
          },
        ),
        GoRoute(
          path: '/about_us_page',
          name: RoutesName.ContactUs,
          pageBuilder: (context, state) {
            return MaterialPage(child: ContactUs());
          },
        ),
        GoRoute(
          name: RoutesName.FAQ,
          path: '/faq',
          pageBuilder: (context, state) {
            return MaterialPage(child: FAQ());
          },
        ),
        // GoRoute(
        //   name: RoutesName.Contact,
        //   path: '/Contact',
        //   pageBuilder: (context, state) {
        //     return MaterialPage(child: Contact());
        //   },
        // ),
        GoRoute(
          name: RoutesName.Privacy,
          path: '/privacy_terms',
          pageBuilder: (context, state) {
            return MaterialPage(child: Privacy());
          },
        ),
        GoRoute(
          name: RoutesName.Terms,
          path: '/terms_and_conditions',
          pageBuilder: (context, state) {
            return MaterialPage(child: Terms(
            ));
          },
        ),
        GoRoute(
          name: RoutesName.EditProfille,
          path: '/profile',
          pageBuilder: (context, state) {
            return MaterialPage(child: EditProfile());
          },
        ),
        GoRoute(
          name: RoutesName.DeatilPage,
          path: '/movie_detail_page',
          pageBuilder: (context, state) {
            state.queryParams.forEach((key, value) {
              print("$key : $value");
            });
            return MaterialPage(
                child: DetailPage(
                  movieID: state.queryParams['movieID'],
                  VideoId: state.queryParams['VideoId'],
                  Title: state.queryParams['Title'],
                  Desc: state.queryParams['Desc'],
                ));
          },
        ),
        GoRoute(
          name: RoutesName.HomeViewPage,
          path: '/HomeViewPage',
          pageBuilder: (context, state) {
            state.queryParams.forEach((key, value) {
              print("$key : $value");
            });
            return MaterialPage(
                child: HomeViewPage(
                  title: state.queryParams['title'],
                  trayId: int.parse(state.queryParams['trayId']!),
                ));
          },

        ),
        GoRoute(
          name: RoutesName.seaAll,
          path: '/seeall',
          pageBuilder: (context, state) {
            state.queryParams.forEach((key, value) {
              print("$key : $value");
            });
            return MaterialPage(
                child: SeeAllListPages(
                  title: state.queryParams['title'],
                 VideoId: state.queryParams['VideoId'],

                ));
          },

        ),
      ],
      redirect: ((context, state) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        if (sharedPreferences.get('token') != null) {
          if (isSearch == true)  {
            isSearch = false;
            searchController?.clear();
            setState(() {
            });
          }
          if(isProfile==true){
            isProfile=false;
            setState(() {
            });
          }
          if(isDelete==true){
            isDelete=false;
            setState(() {

            });
          }
          if( isLogins == true){
            isLogins=false;
            setState(() {
            });
          }
          return state.location;
        }
        else {
          return '/';
        }
      }),

    );
  }
  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    names = sharedPreferences.get('name').toString();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => YoutubeProvider()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
          ChangeNotifierProvider(create: (_) => ProfileViewModel()),
          ChangeNotifierProvider(create: (_) => SocialLoginViewModel()),
        ],
        child: ChangeNotifierProvider<HomeViewModel>(
            create: (BuildContext context) => homeViewModel,
            child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
              final themeColor = viewmodel
                  .appConfigModel?.androidConfig?.appTheme?.primaryColor?.hex;
              final bgColor = viewmodel
                  .appConfigModel?.androidConfig?.appTheme?.themeColor?.hex;
              final font = viewmodel
                  .appConfigModel?.androidConfig?.fontStyle?.fontFamily;
              final secondaryColor = viewmodel
                  .appConfigModel?.androidConfig?.appTheme?.secondaryColor?.hex;
              final txtColor = viewmodel
                  .appConfigModel?.androidConfig?.appTheme?.textColor?.hex;
              return MaterialApp.router(
                  theme: ThemeData(
                      scaffoldBackgroundColor: (bgColor)?.toColor(),
                      primaryColor: (themeColor)?.toColor(),
                      backgroundColor: (bgColor)?.toColor(),
                      cardColor: (secondaryColor)?.toColor(),
                      fontFamily: font,
                      canvasColor: (txtColor)?.toColor()),
                  builder: EasyLoading.init(),
                  debugShowCheckedModeBanner: false,
                  scrollBehavior: MyCustomScrollBehavior(),
                  routeInformationParser: _router.routeInformationParser,
                  routerDelegate: _router.routerDelegate,
                  routeInformationProvider: _router.routeInformationProvider,

              );

            })));
  }
}



class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad
      };
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
