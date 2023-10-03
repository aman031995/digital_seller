import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TychoStream/utilities/Responsive.dart';

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
                color: isSelected == true ? Theme.of(context).hintColor : Theme.of(context).hintColor.withOpacity(0.6),
                fontSize: fontSize,
                textAlign: TextAlign.center),
            // SizedBox(width: 5,),
            // Image.asset("images/ic_ForwordArrow.png", width: 15, height: 15,color:Theme.of(context).canvasColor),
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
            context,msg: 'Back', fontSize: 17,),
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

              context,msg: title,color: textColor,
              fontSize: fontSize,
              textAlign: TextAlign.center)
              : AppBoldFont(
              context,  msg: title,color: textColor,
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
                  (states) => Theme.of(context).primaryColor.withOpacity(0.1))),
      child: AppBoldFont(context, msg: msg, fontSize: ResponsiveWidget.isMediumScreen(context)? 16:17, color: Theme.of(context).scaffoldBackgroundColor ));
      // Text(
      //
      //   msg,
      //   style: TextStyle(color:Theme.of(context).canvasColor,fontSize: ResponsiveWidget.isMediumScreen(context)? 16:18),
      // ));
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
      child: AppBoldFont(context,msg: title, fontSize:ResponsiveWidget.isMediumScreen(context)? 14:18),
    ),
  );
}
//AddressButton Method
Widget AddressButton(BuildContext context,GestureTapCallback? ontap){
  return GestureDetector(
    onTap: ontap,
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8)
          ),
          color: Theme.of(context).canvasColor.withOpacity(0.2))       ,
      width: ResponsiveWidget.isMediumScreen(context) ? SizeConfig.screenWidth/1.05 : SizeConfig.screenWidth * 0.30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBoldFont(context, msg: "Delivery Address",fontSize: 16,color: Theme.of(context).canvasColor),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(5)
            ),
            padding: EdgeInsets.all(6),
            child: AppBoldFont(context,
                msg: "Add New",fontSize: 16,color: Theme.of(context).hintColor),
          ),
        ],
      ),
    ),
  );
}
