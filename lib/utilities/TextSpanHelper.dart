import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'TextStyling.dart';

TextSpan AppBoldTextSpan(
    {@required String? text1,
    double? fontSize,
      FontWeight? fontWeight,
    Color? color,
    VoidCallback? onPressed,
    String? msg}) {
  return TextSpan(
      recognizer: new TapGestureRecognizer()..onTap = onPressed,
      text: text1,
      style: CustomTextStyle.textFormFieldInterBold
          .copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight));
}


TextSpan AppMediumTextSpan(
    {@required String? text1, double? fontSize, FontWeight? fontWeight, Color? color}) {
  return TextSpan(
      text: text1,
      style: CustomTextStyle.textFormFieldInterMedium
          .copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight));
}

TextSpan AppRegularTextSpan(
    {@required String? text1,
    double? fontSize,
      FontWeight? fontWeight,
    Color? color,
    VoidCallback? onPressed}) {
  return TextSpan(
      recognizer: new TapGestureRecognizer()..onTap = onPressed,
      text: text1,
      style: CustomTextStyle.textFormFieldInterRegular
          .copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight));
}

TextSpan AppSemiBoldTextSpan(
    {@required String? text1,
    double? fontSize,
      FontWeight? fontWeight,
    Color? color,
    VoidCallback? onPressed}) {
  return TextSpan(
      recognizer: new TapGestureRecognizer()..onTap = onPressed,
      text: text1,
      style: CustomTextStyle.textFormFieldInterRegular
          .copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight));
}
