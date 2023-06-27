import 'dart:ui';
import 'package:TychoStream/AppRouter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/repository/subscription_provider.dart';
import 'package:TychoStream/view/CustomPlayer/YoutubePlayer/CommonWidget.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:TychoStream/viewmodel/sociallogin_view_model.dart';
import 'package:url_strategy/url_strategy.dart';
import 'dart:html' as html;
String? image;
String? names;
String? token;
bool isLogin = false;
bool isLogins = false;
bool isSearch = false;
bool isProfile=false;
bool isDelete=false;
bool isNotification=false;
TextEditingController? searchController = TextEditingController();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async {
  setPathUrlStrategy();

  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCYNNyloGMREO0_7qajgvRTdvobmyZnBT8",
          authDomain: "flutter-web-29d92.firebaseapp.com",
          projectId: "flutter-web-29d92",
          storageBucket: "flutter-web-29d92.appspot.com",
          messagingSenderId: "1039297047623",
          appId: "1:1039297047623:web:c2e9205493d33a2f6f1562",
          measurementId: "G-RFYDXHGWCK"
  ));
  html.window.onPopState.listen((event) {
    // Handle browser back navigation here
    reloadPage();
    // You can perform any necessary actions or navigate to a specific route
    print('Browser back navigation detected!');
  });
  runApp(MyApp());
}
// void configureApp() {
//   final urlStrategy = PathUrlStrategy();
//   urlStrategy.setPathUrlStrategy();
//   setUrlStrategy(urlStrategy);
//
//   // Add event listener for browser back navigation
//   html.window.onPopState.listen((event) {
//     // Handle browser back navigation here
//     // You can perform any necessary actions or navigate to a specific route
//     print('Browser back navigation detected!');
//   });
// }
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HomeViewModel homeViewModel = HomeViewModel();
  // late GoRouter _router;

  final _appRouter = AppRouter();
  @override
  getTokent() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    print('DEVICE TOKEN ' + deviceToken!);
  }

  void initState() {
    User();
    homeViewModel.getAppConfig(context);
    super.initState();
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
              final themeColor = viewmodel.appConfigModel?.androidConfig?.appTheme?.primaryColor?.hex;
              final bgColor = viewmodel.appConfigModel?.androidConfig?.appTheme?.themeColor?.hex;
              final font = viewmodel.appConfigModel?.androidConfig?.fontStyle?.fontFamily;
              final secondaryColor = viewmodel.appConfigModel?.androidConfig?.appTheme?.secondaryColor?.hex;
              final txtColor = viewmodel.appConfigModel?.androidConfig?.appTheme?.textColor?.hex;
              return MaterialApp.router(
                  theme: ThemeData(
                      scrollbarTheme: ScrollbarThemeData(
                        thumbColor: MaterialStateProperty.all(Theme.of(context).canvasColor),
                        trackColor: MaterialStateProperty.all(Colors.grey),
                      ),
                      scaffoldBackgroundColor: (bgColor)?.toColor(),
                      primaryColor: (themeColor)?.toColor(),
                      backgroundColor: (bgColor)?.toColor(),
                      cardColor: (secondaryColor)?.toColor(),
                      fontFamily: font,
                      canvasColor: (txtColor)?.toColor()),
                  builder: EasyLoading.init(),
                  debugShowCheckedModeBanner: false,
                  scrollBehavior: MyCustomScrollBehavior(),
                routerConfig: _appRouter.config(),
                // routeInformationParser: _appRouter.routeInformationParser,
                // routerDelegate: _appRouter.routerDelegate,
                  // routeInformationProvider: _router.routeInformationProvider,

              );
            })
        )
    );}}



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
