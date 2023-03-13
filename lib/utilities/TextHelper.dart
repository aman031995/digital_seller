import 'package:flutter/material.dart';
import 'TextStyling.dart';


Text AppBoldFont(
    BuildContext context,
    {@required String? msg,
        double? fontSize,
        FontWeight? fontWeight,
        int? maxLines,
        TextAlign? textAlign,
        Color? color,
    }) {
    return Text(msg!,

        maxLines: maxLines,
        textAlign: textAlign,
        style: CustomTextStyle.textFormFieldInterBold
            .copyWith(color: Theme.of(context).accentColor, fontSize: fontSize, fontWeight: fontWeight,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily));
}


Text AppMediumFont(
    BuildContext context,
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
            .copyWith(color: Theme.of(context).accentColor, fontSize: fontSize, fontWeight: fontWeight,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily));
}

Text AppRegularFont(
    BuildContext context,
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
            .copyWith(color: Theme.of(context).accentColor, fontSize: fontSize, fontWeight: fontWeight,fontFamily: Theme.of(context).textTheme.labelLarge?.fontFamily));
}
