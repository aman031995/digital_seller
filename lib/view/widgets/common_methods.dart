
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

  // // upload image function
  // static uploadImageVideo(BuildContext context, ProfileViewModel viewmodel) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) =>
  //           PhotoAndVideoPopUp(onCameraSelection: () {
  //             GetImageFile.pickImage(ImageSource.camera, context,
  //                 (result, isSuccess) {
  //               if (isSuccess) {
  //                 viewmodel.imageUpload(context, result);
  //               }
  //             });
  //           }, onGallerySelection: () {
  //             GetImageFile.pickImage(ImageSource.gallery, context,
  //                 (result, isSuccess) {
  //               if (isSuccess) {
  //                 viewmodel.imageUpload(context, result);
  //               }
  //             });
  //           }));
  // }
}
Widget cartPageViewIndicator(BuildContext context,int pageIndex,int activeStep){
  return Container(
    child: EasyStepper(
      activeStep: pageIndex,
      lineLength: SizeConfig.screenWidth * 0.10,
      lineSpace: 0,
      lineType: LineType.normal,
      defaultLineColor: Theme.of(context).canvasColor.withOpacity(0.6),
      finishedStepBackgroundColor: Theme.of(context).primaryColor ,
      activeStepBackgroundColor: Theme.of(context).primaryColor,
      finishedLineColor: Theme.of(context).primaryColor,
      activeStepTextColor: Theme.of(context).canvasColor,
      finishedStepTextColor: Theme.of(context).primaryColor,
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: 13,
      showStepBorder: false,
      lineDotRadius: 1.5,
      steps: [
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: activeStep >= 0
                ? Colors.white :Theme.of(context).canvasColor.withOpacity(0.6),
            child: CircleAvatar(
              radius: 7,
              backgroundColor: activeStep >= 0
                  ? Theme.of(context).primaryColor
                  :  Theme.of(context).canvasColor.withOpacity(0.6),
            ),
          ),
          title: 'My Cart',
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor:  activeStep >= 1
                ? Colors.white :Theme.of(context).canvasColor.withOpacity(0.6),
            child: CircleAvatar(
              radius: 7,
              backgroundColor: activeStep >= 1
                  ? Theme.of(context)
                  .primaryColor
                  : Colors.white,
            ),
          ),
          title: 'Payment',
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor:  activeStep >= 2
                ? Colors.white :Theme.of(context).canvasColor.withOpacity(0.6),
            child: CircleAvatar(
              radius: 7,
              backgroundColor: activeStep >= 2
                  ? Theme.of(context)
                  .primaryColor
                  : Colors.white,
            ),
          ),
          title: 'Order Placed',
        ),
      ],
      onStepReached: (index) {
        activeStep = index;
      },
    ),
  ) ;
}
//PriceDetailWidget Method
Widget priceDetailWidget(BuildContext context,String str1, String val) {
  return Container(
    padding: EdgeInsets.only(left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppRegularFont(context, msg: str1, fontSize: 16.0),
        AppRegularFont(context, msg: val, fontSize: 16.0)
      ],
    ),
  );
}

//CheckOut button
Widget checkoutButton(BuildContext context,String msg,CartViewModel cartViewData,  VoidCallback? onTap,){
  return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(
                      5.0))),
          margin: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                    child: AppMediumFont(
                        context,
                        msg: StringConstant.total + "₹" +
                            (cartViewData.cartListData?.checkoutDetails?.totalPayableAmount.toString() ?? ""),
                        fontSize: 16.0)),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius:
                    BorderRadius.only(topRight:
                    Radius.circular(5.0),
                      bottomRight:
                      Radius.circular(5.0),
                    ),
                  ),
                  child: InkWell(
                    onTap: onTap,
                    child: Center(
                        child: AppMediumFont(context, msg: msg, fontSize: 16.0)),
                  ),
                  height: SizeConfig.safeBlockVertical * 6,
                ),
              ),
            ],
          )));
}

//BillCard Method
Widget billCard(BuildContext context,CartViewModel cartViewData){
  return  Card(
    child: Container(
      width: SizeConfig.screenWidth*0.24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          priceDetailWidget(context,StringConstant.totalItems,cartViewData.cartListData?.checkoutDetails?.totalItems.toString() ?? ''),
          SizedBox(height: 15),
          priceDetailWidget(context,StringConstant.basePrice,"₹ " +
              (cartViewData.cartListData?.checkoutDetails?.cartTotalPrice.toString() ?? '')),
          SizedBox(height: 15),
          priceDetailWidget(context,StringConstant.discountedPrice, "₹ " +
              (cartViewData.cartListData?.checkoutDetails?.discountedPrice.toString() ?? "")),
          SizedBox(height: 15),
          priceDetailWidget(context,StringConstant.shipping,"₹ " +
              (cartViewData.cartListData?.checkoutDetails?.deliveryCharge.toString() ?? "")),
          SizedBox(height: 15),
          Divider(height: 1, color: Theme.of(context).canvasColor,),
          SizedBox(height: 15),
          priceDetailWidget(context,StringConstant.amountPayable,"₹" + (cartViewData.cartListData?.checkoutDetails?.totalPayableAmount.toString() ?? "")),
          SizedBox(height: 15),
        ],
      ),
    ),
  );
}

//BillCard Method
Widget billCardMobile(BuildContext context,CartViewModel cartViewData){
  return  Card(
    child: Container(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          priceDetailWidget(context,StringConstant.totalItems,cartViewData.cartListData?.checkoutDetails?.totalItems.toString() ?? ''),
          SizedBox(height: 15),
          priceDetailWidget(context,StringConstant.basePrice,"₹ " +
              (cartViewData.cartListData?.checkoutDetails?.cartTotalPrice.toString() ?? '')),
          SizedBox(height: 15),
          priceDetailWidget(context,StringConstant.discountedPrice, "₹ " +
              (cartViewData.cartListData?.checkoutDetails?.discountedPrice.toString() ?? "")),
          SizedBox(height: 15),
          priceDetailWidget(context,StringConstant.shipping,"₹ " +
              (cartViewData.cartListData?.checkoutDetails?.deliveryCharge.toString() ?? "")),
          SizedBox(height: 15),
          Divider(height: 1, color: Theme.of(context).canvasColor,),
          SizedBox(height: 15),
          priceDetailWidget(context,StringConstant.amountPayable,"₹" + (cartViewData.cartListData?.checkoutDetails?.totalPayableAmount.toString() ?? "")),
          SizedBox(height: 15),
        ],
      ),
    ),
  );
}