import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'TextStyling.dart';

TextSpan AppBoldTextSpan(
    BuildContext context,
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
          .copyWith(color: Theme.of(context).canvasColor, fontSize: fontSize, fontWeight: fontWeight));
}


TextSpan AppMediumTextSpan(
    BuildContext context,
    {@required String? text1, double? fontSize, FontWeight? fontWeight, Color? color}) {
  return TextSpan(
      text: text1,
      style: CustomTextStyle.textFormFieldInterMedium
          .copyWith(color: Theme.of(context).canvasColor, fontSize: fontSize, fontWeight: fontWeight));
}

TextSpan AppRegularTextSpan(
    BuildContext context,
    {@required String? text1,
    double? fontSize,
      FontWeight? fontWeight,
    Color? color,
    VoidCallback? onPressed}) {
  return TextSpan(
      recognizer: new TapGestureRecognizer()..onTap = onPressed,
      text: text1,
      style: CustomTextStyle.textFormFieldInterRegular
          .copyWith(color: Theme.of(context).canvasColor.withOpacity(0.8), fontSize: fontSize, fontWeight: fontWeight));
}

TextSpan AppSemiBoldTextSpan(
    BuildContext context,
    {@required String? text1,
    double? fontSize,
      FontWeight? fontWeight,
    Color? color,
    VoidCallback? onPressed}) {
  return TextSpan(
      recognizer: new TapGestureRecognizer()..onTap = onPressed,
      text: text1,
      style: CustomTextStyle.textFormFieldInterRegular
          .copyWith(color: Theme.of(context).canvasColor, fontSize: fontSize, fontWeight: fontWeight));
}
