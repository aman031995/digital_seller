import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/view/WebScreen/EditProfile.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/repository/subscription_provider.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/CommonWidget.dart';
import 'package:tycho_streams/view/WebScreen/AboutUs.dart';
import 'package:tycho_streams/view/WebScreen/Career.dart';
import 'package:tycho_streams/view/WebScreen/ContactUsPage.dart';
import 'package:tycho_streams/view/WebScreen/DetailPage.dart';
import 'package:tycho_streams/view/WebScreen/FAQ.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/Privacy.dart';
import 'package:tycho_streams/view/WebScreen/Terms.dart';
import 'package:tycho_streams/view/WebScreen/ViewAllListPages.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
import 'package:tycho_streams/viewmodel/sociallogin_view_model.dart';
import 'package:url_strategy/url_strategy.dart';

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
  GoRouter? _router;

  @override
  void initState() {
    User();
    super.initState();
    homeViewModel.getAppConfig(context);

    _router = GoRouter(
      routes: [
        GoRoute(
          name: RoutesName.home,
          path: '/',
          pageBuilder: (context, state) {
            return MaterialPage(child: HomePageWeb());
          },
        ),
        GoRoute(
          name: RoutesName.ContactUsPage,
          path: '/ContactUsPage',
          pageBuilder: (context, state) {
            return MaterialPage(child: ContactUsPage());
          },

        ),
        GoRoute(
          name: RoutesName.FAQ,
          path: '/FAQ',
          pageBuilder: (context, state) {
            return MaterialPage(child: FAQ());
          },
        ),
        GoRoute(
          name: RoutesName.Career,
          path: '/Career',
          pageBuilder: (context, state) {
            return MaterialPage(child: Career());
          },
        ),
        GoRoute(
          name: RoutesName.Privacy,
          path: '/Privacy',
          pageBuilder: (context, state) {
            return MaterialPage(child: Privacy());
          },
        ),
        GoRoute(
          name: RoutesName.Terms,
          path: '/Terms',
          pageBuilder: (context, state) {
            return MaterialPage(child: Terms());
          },
        ),
        GoRoute(
          name: RoutesName.EditProfille,
          path: '/EditProfile',
          pageBuilder: (context, state) {
            return MaterialPage(child: EditProfile());
          },
        ),
        GoRoute(
          name: RoutesName.AboutUs,
          path: '/AboutUs',
          pageBuilder: (context, state) {
            return MaterialPage(child: AboutUs());
          },
        ),
        GoRoute(
          name: RoutesName.DeatilPage,
          path: '/MovieDetailPage',
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
            name: RoutesName.seaAll,
            path: '/Seall',
            pageBuilder: (context, state) {
              state.queryParams.forEach((key, value) {
                print("$key : $value");
              });
              return MaterialPage(
                  child: SeeAllListPages(
                VideoId: state.queryParams['VideoId'],
                title: state.queryParams['title'],
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
      initialLocation: _getCurrentLocation(),
      refreshListenable: _getRefreshListenable(),
    );
  }

  String _getCurrentLocation() {
    final uri = Uri.base;
    return uri.path + uri.query;
  }

  ChangeNotifier _getRefreshListenable() {
    return ChangeNotifier()
      ..addListener(() {
        if (_getCurrentLocation() != _router?.location) {
          _router?.goNamed(_getCurrentLocation());
        }
      });
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
                  routeInformationParser: _router?.routeInformationParser,
                  routerDelegate: _router?.routerDelegate,
                  routeInformationProvider: _router?.routeInformationProvider);
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
