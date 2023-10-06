import 'package:flutter/material.dart';

/// Global variables
/// * [GlobalKey<NavigatorState>]
class GlobalVariable {
  /// This global key is used in material app for navigation through firebase notifications.
  /// [navState] usage can be found in [notification_notifier.dart] file.
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  static bool? cod;
  static bool? isLightTheme;
  static bool? fromCart;
  static bool? fromFavourite;
  static String? payGatewayName;
  static String SECRET_KEY =
      "sk_test_51NXhtjSJK48GkIWFaWaMUY1amdUDTtvYdzwmbi8rXmsIFuz7sB2HraObpFPJZWtyrD5NVtJplj3E6d853NIjx7ko00MmnjVc2K";

  static String? names;
  static String? token = 'false';
  static bool isLogin = false;
  static bool isLogins = false;
  static bool isSearch = false;
  static bool isnotification=false;
  static bool isProfile=false;

}
