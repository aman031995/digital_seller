import 'package:flutter/material.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/widgets/PinEntryTextFiled.dart';


class AppDialog {

  static verifyOtp(BuildContext context, {String? msg, VoidCallback? onTap,VoidCallback? resendOtp}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            height: 280,
            width: 420,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).cardColor
            ),
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
                children: [
                SizedBox(height: ResponsiveWidget.isMediumScreen(context) ?10:20),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.topCenter,
                      child: AppBoldFont(context,
                          msg: msg, color: Theme.of(context).canvasColor,
                          fontSize:ResponsiveWidget.isMediumScreen(context) ?16: 20,
                         )),
                  SizedBox(height: 20),
                  Container(
                    height: 60,
                    width: 400,
                    child: PinEntryTextFiledView(),
                  ),
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
                        TextButton(onPressed: resendOtp, child: Text('Resend'))
                      ])),
                  Container(
                    alignment: Alignment.center,
                    width: SizeConfig.screenWidth * 0.8,
                    margin: EdgeInsets.only(left: 1, right: 1),
                    padding: EdgeInsets.all(8),
                    child: confirmButton(context,35, 110, StringConstant.confirm, onTap!),
                  )
                ])
          ),
        );
      },
    );
  }
}



confirmButton(BuildContext context,double height, double width, String msg, VoidCallback callback) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: AppRegularFont(context,msg: msg, color: Theme.of(context).hintColor,fontSize: ResponsiveWidget.isMediumScreen(context)?16:22),
      ),
    ),
  );
}



