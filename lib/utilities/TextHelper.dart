import 'package:flutter/material.dart';
import 'TextStyling.dart';

Text AppBoldFont(
    {@required String? msg,
    double? fontSize,
    int? maxLines,
    TextAlign? textAlign,
    Color? color}) {
  return Text(msg!,
      maxLines: maxLines,
      textAlign: textAlign,
      style: CustomTextStyle.textFormFieldGILROYBold
          .copyWith(color: color, fontSize: fontSize));
}

Text AppLightFont(
    {@required String? msg,
    double? fontSize,
    int? maxLines,
    TextAlign? textAlign,
    Color? color}) {
  return Text(msg!,
      maxLines: maxLines,
      textAlign: textAlign,
      style: CustomTextStyle.textFormFieldGILROYLight
          .copyWith(color: color, fontSize: fontSize));
}

Text AppMediumFont(
    {@required String? msg,
    double? fontSize,
    int? maxLines,
    TextAlign? textAlign,
    Color? color,
    TextOverflow? overflowBar}) {
  return Text(msg!,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflowBar,
      style: CustomTextStyle.textFormFieldGILROYMedium
          .copyWith(color: color, fontSize: fontSize));
}

Text AppRegularFont(
    {@required String? msg,
    double? fontSize,
    int? maxLines,
    TextAlign? textAlign,
    TextOverflow? overflowBar,
    Color? color}) {
  return Text(msg!,
      overflow: overflowBar,
      maxLines: maxLines,
      textAlign: textAlign,
      style: CustomTextStyle.textFormFieldGILROYRegular
          .copyWith(color: color, fontSize: fontSize));
}

Text AppSemiBoldFont(
    {@required String? msg,
    double? fontSize,
    int? maxLines,
    TextAlign? textAlign,
    Color? color,
    TextOverflow? overflowBar}) {
  return Text(msg!,
      maxLines: maxLines,
      textAlign: textAlign,
      style: CustomTextStyle.textFormFieldGILROYSemiBOLD
          .copyWith(color: color, fontSize: fontSize),
      overflow: overflowBar);
}
