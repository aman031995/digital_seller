import 'package:flutter/material.dart';
import 'TextStyling.dart';


Text AppBoldFont(
    {@required String? msg,
    double? fontSize,
        FontWeight? fontWeight,
    int? maxLines,
    TextAlign? textAlign,
    Color? color}) {
  return Text(msg!,
      maxLines: maxLines,
      textAlign: textAlign,
      style: CustomTextStyle.textFormFieldInterBold
          .copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight));
}


Text AppMediumFont(
    {@required String? msg,
    double? fontSize,
        FontWeight? fontWeight,
    int? maxLines,
    TextAlign? textAlign,
    Color? color,
    TextOverflow? overflowBar}) {
  return Text(msg!,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflowBar,
      style: CustomTextStyle.textFormFieldInterMedium
          .copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight));
}

Text AppRegularFont(
    {@required String? msg,
    double? fontSize,
        FontWeight? fontWeight,
    int? maxLines,
    TextAlign? textAlign,
    TextOverflow? overflowBar,
    Color? color}) {
  return Text(msg!,
      overflow: overflowBar,
      maxLines: maxLines,
      textAlign: textAlign,
      style: CustomTextStyle.textFormFieldInterRegular
          .copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight));
}

Text AppSemiBoldFont(
    {@required String? msg,
    double? fontSize,
        FontWeight? fontWeight,
    int? maxLines,
    TextAlign? textAlign,
    Color? color,
    TextOverflow? overflowBar}) {
  return Text(msg!,
      maxLines: maxLines,
      textAlign: textAlign,
      style: CustomTextStyle.textFormFieldInterSemiBOLD
          .copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight,),
      overflow: overflowBar);
}
