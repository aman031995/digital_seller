
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


import 'image_source.dart';

class CommonMethods {

  // break the given urls
  static Future<Uri> breakUrls(String url) async {
    var mappedUrl = Uri.parse(url);
    return mappedUrl;
  }

  // send screen name on analytics
  static setScreenName(String? screenName) {
    if (screenName != null) {
      // firebaseAnalytics?.setCurrentScreen(screenName: screenName);
      print('page saved: $screenName');
    }
  }

}

Widget cartPageViewIndicator(
    BuildContext context,int activeStep) {
  return Container(
      margin: EdgeInsets.only(bottom: 10,left: ResponsiveWidget.isMediumScreen(context)
          ?16:SizeConfig.screenHeight*0.40,right: ResponsiveWidget.isMediumScreen(context)
          ?16:SizeConfig.screenHeight*0.40,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          stepView(context,"Step 1 \n${StringConstant.myCart}",activeStep,0),
          Icon(Icons.arrow_forward_ios_sharp, size: 10,    color: activeStep >= 0
              ? Theme.of(context).primaryColor
              : Theme.of(context).canvasColor.withOpacity(0.8)),
          // stepView(context,"Step 2 \n${StringConstant.chooseAddress}",activeStep,1),
          // Icon(Icons.arrow_forward_ios_sharp, size: 10, color: Theme.of(context).canvasColor),
          stepView(context,"Step 2 \n${StringConstant.payment}",activeStep,1),
          Icon(Icons.arrow_forward_ios_sharp, size: 10,    color: activeStep >= 2
              ? Theme.of(context).primaryColor
              : Theme.of(context).canvasColor.withOpacity(0.8),),
          stepView(context,"Step 3 \n${StringConstant.orderPlaced}",activeStep,2),
        ],
      )

  );
}

Widget stepView(BuildContext context,String title,int activeStep,int index){
  return AppBoldFont(context,
      msg: title,fontWeight: FontWeight.w500,
      color: activeStep >= index
          ? Theme.of(context).primaryColor
          : Theme.of(context).canvasColor.withOpacity(0.8),
      fontSize: 14);
}

//PriceDetailWidget Method
Widget priceDetailWidget(BuildContext context, String str1, String val) {
  return Container(
    padding: EdgeInsets.only(left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        str1 == "Total Amount"
            ? AppBoldFont(context,
            msg: str1 + ":", fontSize: 16.0, color: Theme.of(context).canvasColor)
            : AppRegularFont(context,
            msg: str1 + ":", fontSize: 16.0, color: Theme.of(context).canvasColor),
        str1 == "Total Amount"
            ? AppBoldFont(context,
            msg: "₹" + val,
            fontSize: 16.0,
            color: Theme.of(context).canvasColor.withOpacity(0.9))
            : AppRegularFont(context,
            msg: (str1 == "Total items" ? "" : "₹") + val,
            fontSize: 16.0,
            color: str1.contains("Discount")
                ? Colors.green
                :Theme.of(context).canvasColor.withOpacity(0.8))
      ],
    ),
  );
}


//CheckOut button
Widget checkoutButton(BuildContext context,String msg,CartViewModel cartViewData,  VoidCallback? onTap,){
  return Container(
    alignment: Alignment.center,
    width:SizeConfig.screenWidth*0.24,
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor.withOpacity(0.8),
     borderRadius: BorderRadius.circular(4)
    ),
    child: InkWell(
      onTap: onTap,
      child: Center(
          child: AppMediumFont(context, msg: msg, fontSize: 16.0)),
    ),
    height: 50,
  );
}

