
import 'package:flutter/material.dart';
class ResponsiveWidget {
  static bool isMediumScreen(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width < 1100;
  }
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width < 1300;
  }
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width < 520;
  }
}