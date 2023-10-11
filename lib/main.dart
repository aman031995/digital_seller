import 'dart:ui';
import 'package:TychoStream/AppRouter.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/repository/subscription_provider.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:TychoStream/viewmodel/sociallogin_view_model.dart';
import 'package:url_strategy/url_strategy.dart';
import 'dart:html' as html;

Future<void> main() async {
 // Stripe.publishableKey = "pk_test_51NXhtjSJK48GkIWFjJzBm88uzgrwb7i4aIyls9YoPHT5IvYAV9rMnlEW0U8AUY1VpIJB3ZOBFTFdSFuMYnxM0fkK00KqwNEEeH";
  setPathUrlStrategy();
  await WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = "pk_test_51NXhtjSJK48GkIWFjJzBm88uzgrwb7i4aIyls9YoPHT5IvYAV9rMnlEW0U8AUY1VpIJB3ZOBFTFdSFuMYnxM0fkK00KqwNEEeH";
  // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  // Stripe.urlScheme = 'flutterstripe';
  // await Stripe.instance.applySettings();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCJld8j8yV8TC-PeC1XpqvThaVTYvI6bbw",
          authDomain: "digital-fashion-seller.firebaseapp.com",
          projectId: "digital-fashion-seller",
          storageBucket: "digital-fashion-seller.appspot.com",
          messagingSenderId: "986127637622",
          appId: "1:986127637622:web:0ac78b2a3626755edfd357",
          measurementId: "G-B37TDNX53B"

  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HomeViewModel homeViewModel = HomeViewModel();
  final _appRouter = AppRouter();

  void initState() {
    User();
    homeViewModel.getAppConfig(context);
    super.initState();
  }
  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    GlobalVariable.names = sharedPreferences.get('name').toString();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => CartViewModel()),
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
              final buttonTxtColor = viewmodel.appConfigModel?.androidConfig?.appTheme?.buttonTextColor?.hex;
              return MaterialApp.router(
                title:StringConstant.kappName,
                  theme: ThemeData(
                      scaffoldBackgroundColor: (bgColor)?.toColor(),
                      primaryColor: (themeColor)?.toColor(),
                      backgroundColor: (bgColor)?.toColor(),
                      cardColor: (secondaryColor)?.toColor(),
                      fontFamily: font,
                      canvasColor: (txtColor)?.toColor(),
                      hintColor: (buttonTxtColor)?.toColor(),
                    scrollbarTheme: ScrollbarThemeData(
                      thickness: MaterialStateProperty.all(0.0),
                      radius: Radius.circular(2),
                      minThumbLength: 2,
                      trackVisibility: MaterialStateProperty.all(false),
                      thumbVisibility:  MaterialStateProperty.all(false),
                    )
                  ),
                builder: EasyLoading.init(),
                  debugShowCheckedModeBanner: false,
                 scrollBehavior: MyCustomScrollBehavior(),
                routerConfig: _appRouter.config(),
              );
            }))
    );
  }}

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


