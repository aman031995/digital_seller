import 'package:flutter/material.dart';

/// Global variables
/// * [GlobalKey<NavigatorState>]
class GlobalVariable {

  /// This global key is used in material app for navigation through firebase notifications.
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  static bool? cod;
  static bool? isLightTheme;
}