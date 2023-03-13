import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/repository/subscription_provider.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/CommonWidget.dart';
import 'package:tycho_streams/view/WebScreen/AboutUs.dart';
import 'package:tycho_streams/view/WebScreen/Career.dart';
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
import 'dart:html' as html;
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
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "618109773188282",
      cookie: true,
      xfbml: true,
      version: "v16.0",
    );
  }
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
          name: RoutesName.FAQ,
          path: '/FAQ',
          pageBuilder: (context, state) {
            html.window.history.pushState(state.fullpath, '', state.fullpath);
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
      initialLocation: _getCurrentLocation(),
      refreshListenable: _getRefreshListenable(),
    );
    super.initState();
    homeViewModel.getAppConfig(context);
  }

  String _getCurrentLocation() {
    final uri = Uri.base;
    return uri.path + uri.query;
  }
  ChangeNotifier _getRefreshListenable() {
    return ChangeNotifier()
      ..addListener(() {
        if (_getCurrentLocation() != _router.location) {
          _router.goNamed(_getCurrentLocation());
        }
      });
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
              return MaterialApp.router(
                  theme: ThemeData(
                      scaffoldBackgroundColor: viewmodel.appConfigModel?.androidConfig?.appTheme?.themeColor?.hex?.toColor(),
                      primaryColor: viewmodel.appConfigModel?.androidConfig?.appTheme?.primaryColor?.hex?.toColor(),
                      fontFamily: viewmodel.appConfigModel?.androidConfig?.fontStyle?.fontFamily, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: viewmodel.appConfigModel?.androidConfig?.appTheme?.secondaryColor?.hex?.toColor())),
                  builder: EasyLoading.init(),
                  debugShowCheckedModeBanner: false,
                  scrollBehavior: MyCustomScrollBehavior(),
                  routeInformationParser: _router.routeInformationParser,
                  routerDelegate: _router.routerDelegate,
                  routeInformationProvider: _router.routeInformationProvider);
            })));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
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
