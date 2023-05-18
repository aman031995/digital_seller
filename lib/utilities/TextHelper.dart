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
            .copyWith(color: color??Theme.of(context).canvasColor, fontSize: fontSize, fontWeight: fontWeight,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily));
}


Text AppMediumFont(
    BuildContext context,
    {@required String? msg,
        double? fontSize,
        FontWeight? fontWeight,
        int? maxLines,
        TextAlign? textAlign,
        Color? color,
            TextDecoration? textDecoration,
        TextOverflow? overflowBar, }) {
    return Text(msg!,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: overflowBar,

        style: CustomTextStyle.textFormFieldInterMedium
            .copyWith(color: color??Theme.of(context).canvasColor, fontSize: fontSize, fontWeight: fontWeight,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily, decoration: textDecoration));
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
            .copyWith(color:color?? Theme.of(context).canvasColor.withOpacity(0.8), fontSize: fontSize, fontWeight: fontWeight,fontFamily: Theme.of(context).textTheme.labelLarge?.fontFamily));
}
