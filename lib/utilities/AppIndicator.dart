import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';

class AppIndicator {
  static Future<void> loadingIndicator(BuildContext context) async {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 100.0
      ..radius = 8.0
      ..progressColor = Colors.transparent
      ..boxShadow = <BoxShadow>[]
      ..backgroundColor = Colors.transparent
      ..indicatorColor = Theme.of(context).primaryColor
      ..textColor = Colors.black12
      ..maskColor = Colors.white.withOpacity(0.5)
      ..maskType = EasyLoadingMaskType.custom
      ..indicatorWidget = ThreeArchedCircle( size: 90.0)
      ..userInteractions = false;
    EasyLoading.show();
  }

  static Future<void> disposeIndicator() async {
    EasyLoading.dismiss();
  }
}
