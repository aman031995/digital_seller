import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/repository/subscription_provider.dart';
import 'package:tycho_streams/utilities/route_service/routes.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/CommonWidget.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/Recommended.dart';
import 'package:tycho_streams/view/WebScreen/ViewAll.dart';
import 'package:tycho_streams/view/screens/splash_screen.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
import 'package:tycho_streams/viewmodel/sociallogin_view_model.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBaAbG2eNrQR2e1JmJcLj0N4QoKSv59Sb0",
        authDomain: "tychostreams.firebaseapp.com",
        storageBucket: "tychostreams.appspot.com",
        projectId: "tychostreams",
        messagingSenderId: "746850038788",
        appId: "1:746850038788:web:0e231dc5e9ead255407151",
      )
  );
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "618109773188282",
      cookie: true,
      xfbml: true,
      version: "v16.0",
    );
  }
  runApp(const   MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        child: MaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
          initialRoute: '/HomePage',
          routes:
          {
            '/HomePage': (context) => HomePageWeb(),
            '/ViewAll': (context) => ViewAll(),
            '/Recommended' :(context)=>Recommended()

          },
        ));
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}