import 'package:flutter/material.dart';
import 'package:tycho_streams/view/screens/forgot_password.dart';
import 'package:tycho_streams/view/screens/home_page.dart';
import 'package:tycho_streams/view/screens/login_screen.dart';
import 'package:tycho_streams/view/screens/register_screen.dart';
import 'package:tycho_streams/view/screens/reset_screen.dart';
import 'package:tycho_streams/view/screens/splash_screen.dart';
import 'package:tycho_streams/view/screens/verify_otp_screen.dart';

import 'routes_name.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name){
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => HomePage());
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => LoginScreen());
      case RoutesName.register:
        return MaterialPageRoute(builder: (BuildContext context) => RegisterScreen());
      case RoutesName.verifyOtp:
        return MaterialPageRoute(builder: (BuildContext context) => VerifyOtp());
      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context) => SplashScreen());
      case RoutesName.forgot:
        return MaterialPageRoute(builder: (BuildContext context) => ForgotPassword());
      case RoutesName.reset_pw:
        return MaterialPageRoute(builder: (BuildContext context) => ResetPassword());
      default:
        return MaterialPageRoute(builder: (_){
          return const Scaffold(
             body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}