import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/screens/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      navigation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AssetsConstants.icLogo, height: 70, width: 70),
      ),
    );
  }

  void navigation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isPhone = sharedPreferences.getString('phone');
    if (isPhone != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => BottomNavigation(index: 0)));
    } else {
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
  }
}
