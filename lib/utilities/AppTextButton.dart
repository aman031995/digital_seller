import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/Responsive.dart';

import 'AppColor.dart';
import 'TextHelper.dart';

Widget appButton(
    BuildContext context,
    String title,
    double _width,
    double _height,
    Color bgColor,
    //Color borderColor,
    double fontSize,
    double circular,
    bool isSelected,
    {VoidCallback? onTap}) {
  return Container(
    width: _width,
    height: _height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
    child: Container(
      margin: EdgeInsets.only(bottom: 5),
      height: _height,
      decoration: BoxDecoration(
        color: isSelected == true ? THEME_COLOR : bgColor,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: TextButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBoldFont(
              context,
                msg: title,
                color: isSelected == true ? Colors.white : Theme.of(context).accentColor,
                fontSize: fontSize,
                textAlign: TextAlign.center),
            SizedBox(width: 5,),
            Image.asset("images/ic_ForwordArrow.png", width: 15, height: 15,),
          ],
        ),
      ),
    ),
  );
}

Widget AppButton(BuildContext context,String msg,{VoidCallback? onPressed}){
  return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          alignment: Alignment.center,
          overlayColor: MaterialStateColor.resolveWith(
                  (states) => Color(0xffA31621))),
      child:  Text(

        msg,
        style: TextStyle(color:Theme.of(context).accentColor,fontSize: ResponsiveWidget.isMediumScreen(context)? 16:20),
      ));
}
Widget appTextButton(
  BuildContext context,
  String title,
  Alignment alignment,
  double fontSize,
  bool type, {
  VoidCallback? onPressed,
}) {
  return Container(
      alignment: alignment,
      child: TextButton(
          child: type == true
              ? AppMediumFont(       context,
                  msg: title,
                  color: Theme.of(context).accentColor,
                  fontSize: fontSize,
                  textAlign: TextAlign.center)
              : AppMediumFont(       context,
                  msg: title,
                  color: Theme.of(context).accentColor,
                  fontSize: fontSize,
                  textAlign: TextAlign.center),
          onPressed: onPressed));
}

Widget socialNetworkButton(String image, GestureTapCallback? ontap,BuildContext context) {
  return GestureDetector(
    onTap: ontap,
    child: Image(
      image: AssetImage(image),
      fit: BoxFit.fill,
      height:ResponsiveWidget.isMediumScreen(context)?35 : 45,
      width: ResponsiveWidget.isMediumScreen(context)?50:60,
    ),
  );
}
Widget textButton(BuildContext context, String title,
    {VoidCallback? onApply}) {
  return GestureDetector(
    onTap: onApply,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      // decoration: buttonDecoration,
      child: AppBoldFont(context,msg: title, fontSize: 14, color: TEXT_COLOR),
    ),
  );
}