import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/widgets/PinEntryTextFiled.dart';
import 'package:url_launcher/url_launcher.dart';
var alert;


class AppDialog {


  static verifyOtp(BuildContext context, {String? msg, VoidCallback? onTap,VoidCallback? resendOtp}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 8,
          titlePadding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).cardColor,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.all(10),
          content: Container(
              height: SizeConfig.screenHeight / 1.8,
              margin:  EdgeInsets.only(left: ResponsiveWidget.isMediumScreen(context) ?20: 50, right: ResponsiveWidget.isMediumScreen(context) ?20: 50,top: 10),
              width: ResponsiveWidget.isMediumScreen(context) ?SizeConfig.screenWidth :SizeConfig.screenWidth * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).cardColor
            ),
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          child: Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                }, icon: Image.asset(AssetsConstants.icCross, color: Theme.of(context).canvasColor)),
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,

                      child: AppBoldFont(context,
                        msg: StringConstant.verification,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: ResponsiveWidget.isMediumScreen(context) ?8:15),
                    Container(
                        alignment: Alignment.topLeft,
                        child: AppBoldFont(context,
                            msg: msg, color: Theme.of(context).canvasColor,
                            fontSize:16,maxLines: 2
                           )),
                    SizedBox(height: ResponsiveWidget.isMediumScreen(context) ?10:30),
                    Container(
                      height: 60,
                      width: 400,
                      child: PinEntryTextFiledView(),
                    ),
                    SizedBox(height: ResponsiveWidget.isMediumScreen(context) ?5:10),

                    Container(
                        margin: EdgeInsets.only(left: 1,bottom: 6),
                        padding: EdgeInsets.only(left: 8,right: 10),
                        alignment: Alignment.centerRight,
                        width: SizeConfig.screenWidth * 0.8,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppRegularFont(
                              context,msg: StringConstant.didntGetCode,
                              fontSize: 14,
                              color: Theme.of(context).canvasColor,
                              textAlign: TextAlign.center,
                              maxLines: 2),
                          TextButton(onPressed: resendOtp, child: Text(StringConstant.resend))
                        ])),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 1, right: 1),
                      padding: EdgeInsets.all(4),
                      child:

                      confirmButton(context,40, ResponsiveWidget.isMediumScreen(context)
                          ? SizeConfig.screenWidth/1.5  :SizeConfig.screenWidth/7.5, StringConstant.confirm, onTap!),
                    ),
                    SizedBox(height: ResponsiveWidget.isMediumScreen(context)
                        ?20:50),
                    GestureDetector(
                      onTap: () async{
                        const url = 'http://digitalseller.in/';
                        if (await canLaunch(url)) {
                          await launch(url, forceWebView: false, enableJavaScript: true);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Center(
                        child: GlobalVariable.isLightTheme == true ?
                        Image.network(StringConstant.digitalSellerLitelogo, fit: BoxFit.fill, width: 150) :
                        Image.network(StringConstant.digitalSellerDarklogo, fit: BoxFit.fill, width: 150),
                      ),
                    ),
                    SizedBox(height: 5),
                  ]),
            )
          ),
        );
      },
    );
  }
  static cancelOrder(BuildContext context, {VoidCallback? onTap}) {
    Stack(
        children: [
          alert = AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              title: AppBoldFont(context,
                  msg: StringConstant.deleteAccountTitle,
                  fontSize: 22,
                  color: Theme.of(context).primaryColor,
                  textAlign: TextAlign.center),
              titlePadding: EdgeInsets.only(left: 20, right: 20, top: 10),
              content: AppRegularFont(context,
                  msg: StringConstant.cancelYourOrder,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                  maxLines: 2),
              contentPadding:
              EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
              actions: [
                Container(
                    width: 400,
                    padding: EdgeInsets.all(8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          cancelButton(context, 35, 110, StringConstant.discard, () {
                            Navigator.of(context, rootNavigator: true).pop();
                          }),
                          SizedBox(width: 14),
                          confirmButton(context, 35, 110, StringConstant.confirm, onTap!)]))])]
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

//CancelButton Method
cancelButton(BuildContext context, double height, double width, String msg,
    VoidCallback callback) {
  return GestureDetector(
      onTap: callback,
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: RED_COLOR, width: 1.5)),
          child: Center(
              child: AppRegularFont(
                context,
                msg: msg,
              )))
  );
}


confirmButton(BuildContext context,double height, double width, String msg, VoidCallback callback) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: AppRegularFont(context,msg: msg, color: Theme.of(context).hintColor,fontSize: 16),
      ),
    ),
  );
}



