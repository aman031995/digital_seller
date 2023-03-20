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
    Color textColor,
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
        color: isSelected == true ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.6),
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
                color: isSelected == true ? WHITE_COLOR : textColor,
                fontSize: fontSize,
                textAlign: TextAlign.center),
            SizedBox(width: 5,),
            Image.asset("images/ic_ForwordArrow.png", width: 15, height: 15,color:Theme.of(context).canvasColor),
          ],
        ),
      ),
    ),
  );
}

Widget backButton({required VoidCallback onTap,required BuildContext context}) {
  return Container(
    margin: EdgeInsets.only(left: 20, bottom: 5),
    height: 53,
    width: 120,
    child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).canvasColor,
        ),
        //icon data for elevated button
        label: AppMediumFont(
            context,msg: 'Back', fontSize: 17, color: Theme.of(context).canvasColor),
        //label text
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        )),
  );
}

Widget appTextButton(
    BuildContext context,
    String title,
    Alignment alignment,
    Color textColor,
    double fontSize,
    bool type, {
      VoidCallback? onPressed,
    }) {
  return Container(
      alignment: alignment,
      child: TextButton(
          child: type == true
              ? AppBoldFont(
              context,msg: title,
              color: textColor,
              fontSize: fontSize,
              textAlign: TextAlign.center)
              : AppBoldFont(
              context,  msg: title,
              color: textColor,
              fontSize: fontSize,
              textAlign: TextAlign.center),
          onPressed: onPressed));
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
        style: TextStyle(color:Theme.of(context).canvasColor,fontSize: ResponsiveWidget.isMediumScreen(context)? 16:20),
      ));
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
      child: AppBoldFont(context,msg: title, fontSize:ResponsiveWidget.isMediumScreen(context)? 14:18, color: TEXT_COLOR),
    ),
  );
}