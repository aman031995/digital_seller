import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'TextStyling.dart';

TextSpan AppBoldTextSpan(
    {@required String? text1,
    double? fontSize,
    Color? color,
    VoidCallback? onPressed,
    String? msg}) {
  return TextSpan(
      recognizer: new TapGestureRecognizer()..onTap = onPressed,
      text: text1,
      style: CustomTextStyle.textFormFieldGILROYBold
          .copyWith(color: color, fontSize: fontSize));
}

TextSpan AppLightTextSpan(
    {@required String? text1, double? fontSize, Color? color}) {
  return TextSpan(
      text: text1,
      style: CustomTextStyle.textFormFieldGILROYLight
          .copyWith(color: color, fontSize: fontSize));
}

TextSpan AppMediumTextSpan(
    {@required String? text1, double? fontSize, Color? color}) {
  return TextSpan(
      text: text1,
      style: CustomTextStyle.textFormFieldGILROYMedium
          .copyWith(color: color, fontSize: fontSize));
}

TextSpan AppRegularTextSpan(
    {@required String? text1,
    double? fontSize,
    Color? color,
    VoidCallback? onPressed}) {
  return TextSpan(
      recognizer: new TapGestureRecognizer()..onTap = onPressed,
      text: text1,
      style: CustomTextStyle.textFormFieldGILROYRegular
          .copyWith(color: color, fontSize: fontSize));
}

TextSpan AppSemiBoldTextSpan(
    {@required String? text1,
    double? fontSize,
    Color? color,
    VoidCallback? onPressed}) {
  return TextSpan(
      recognizer: new TapGestureRecognizer()..onTap = onPressed,
      text: text1,
      style: CustomTextStyle.textFormFieldGILROYRegular
          .copyWith(color: color, fontSize: fontSize));
}
