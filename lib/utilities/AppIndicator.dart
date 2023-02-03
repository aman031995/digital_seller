import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tycho_streams/utilities/AppColor.dart';

class AppIndicator {
  static Future<void> loadingIndicator() async {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 8.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.white
      ..indicatorColor = THEME_BUTTON
      ..textColor = Colors.black12
      ..maskColor = Colors.white.withOpacity(0.5)
      ..maskType = EasyLoadingMaskType.custom
      ..userInteractions = false;
    EasyLoading.show();
  }

  static Future<void> disposeIndicator() async {
    EasyLoading.dismiss();
  }
}
