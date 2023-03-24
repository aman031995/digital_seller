import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tycho_streams/view/widgets/PinEntryTextFiled.dart';

var alert;

class AppDialog {
  static permissionPopUp(BuildContext context, bool isCamera) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: BG_COLOR,
      title: AppBoldFont(
          context,msg: isCamera == true
          ? StringConstant.cameraPer
          : StringConstant.galleryPer,
          maxLines: 2,
          color: TEXT_COLOR,
          fontSize: 16),
      content: AppRegularFont(
          context,maxLines: 2,
          msg: isCamera == true
              ? StringConstant.cameraPerMessage
              : StringConstant.galleryPerMessage,
          color: TEXT_COLOR,
          fontSize: 16),
      actions: <Widget>[
        const Divider(
          color: DIVIDER_COLOR,
          thickness: 2,
        ),
        Container(
          padding: const EdgeInsets.only(left: 1, right: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              dialogueButton(context,StringConstant.cancel, RED_COLOR, onTap: () {
                Navigator.of(context).pop();
              }),
              Container(
                width: 2,
                height: 35,
                color: DIVIDER_COLOR,
              ),
              dialogueButton(context,StringConstant.settings, Theme.of(context).primaryColor, onTap: () {
                openAppSettings();
              })
            ],
          ),
        ),
      ],
    );
  }

  static galleryOptionDialog(BuildContext context,
      {VoidCallback? onCameraTap, onVideoTap, String? title, text1, text2}) {
    Stack(
      children: [
        alert = AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: BG_COLOR,
          actions: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: textView(title!, 16, WHITE_COLOR,context),
            ),
            const SizedBox(height: 10),
            const Divider(color: DIVIDER_COLOR, thickness: 2),
            Container(
              padding: const EdgeInsets.only(left: 1, right: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: dialogueButton(context,text1, Colors.white60,
                          onTap: onCameraTap)),
                  Container(
                    width: 2,
                    height: 35,
                    color: DIVIDER_COLOR,
                  ),
                  Expanded(
                      child: dialogueButton(context,text2, Colors.white60,
                          onTap: onVideoTap))
                ],
              ),
            ),
          ],
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  static deleteDialogue(BuildContext context, {VoidCallback? onTap}) {
    Stack(
      children: [
        alert = AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: AppBoldFont(
              context,msg: StringConstant.deleteAccountTitle,
              fontSize: 22,
              color: Theme.of(context).primaryColor,
              textAlign: TextAlign.center),
          titlePadding: EdgeInsets.only(left: 20, right: 20, top: 10),
          content: AppRegularFont(
              context,msg: StringConstant.deleteAccountMessage,
              fontSize: 14,
              color: Theme.of(context).primaryColor,
              textAlign: TextAlign.center,
              maxLines: 2),
          contentPadding:
          EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
          actions: [
            Container(
              width: SizeConfig.screenWidth * 0.8,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cancelButton(context,35, 110, StringConstant.cancel, () {
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
                  SizedBox(
                    width: 14,
                  ),
                  confirmButton(context,35, 110, StringConstant.confirm, onTap!),
                ],
              ),
            )
          ],
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
                SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.topCenter,
                      child: AppBoldFont(context,
                          msg: msg,
                          fontSize: 26,
                          color: TEXT_COLOR)),
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
                            color: TEXT_COLOR,
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
          // actions: [
          //   Container(
          //       margin: EdgeInsets.only(left: 1,bottom: 6),
          //       padding: EdgeInsets.only(left: 8,),
          //       alignment: Alignment.centerLeft,
          //       width: SizeConfig.screenWidth * 0.8,
          //       child: Row(children: [
          //         AppRegularFont(
          //             context,msg: StringConstant.didntGetCode,
          //             fontSize: 14,
          //             color: TEXT_COLOR,
          //             textAlign: TextAlign.center,
          //             maxLines: 2),
          //         TextButton(onPressed: resendOtp, child: Text('Resend'))
          //       ])),
          //   Container(
          //     alignment: Alignment.center,
          //     width: SizeConfig.screenWidth * 0.8,
          //     margin: EdgeInsets.only(left: 1, right: 1),
          //     padding: EdgeInsets.all(8),
          //     child: confirmButton(context,35, 110, StringConstant.confirm, onTap!),
          //   )
          // ],
        );;
      },
    );
  }
}

textView(String msg, double fontSize, Color color,BuildContext context) {
  return Center(
      child: AppRegularFont(
          context,
          textAlign: TextAlign.center,
          msg: msg,
          color: color,
          fontSize: fontSize));
}

dialogueButton(BuildContext context,String msg, Color color, {VoidCallback? onTap}) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          alignment: Alignment.center,
          width: 145,
          height: 45,
          child: AppRegularFont(context,msg: msg, color: color, fontSize: 18)));
}
Widget textButton(BuildContext context, String title, {VoidCallback? onApply}) {
  return GestureDetector(
    onTap: onApply,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: WHITE_COLOR,
        borderRadius: BorderRadius.circular(8.0),
      ),
      // decoration: buttonDecoration,
      child: AppBoldFont(  context,msg: title, fontSize: 14, color: TEXT_COLOR),
    ),
  );
}

// positiveBtn(double height, double width, String msg, Color color,
//     VoidCallback callback) {
//   return GestureDetector(
//       onTap: callback,
//       child: Container(
//           height: height,
//           width: width,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Center(
//             child: AppBoldFont(  context,msg: msg, color: color),
//           )));
// }

// negativeBtn(double height, double width, String msg, VoidCallback callback) {
//   return GestureDetector(
//       onTap: callback,
//       child: Container(
//           height: height,
//           width: width,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: BLACK_COLOR, width: 1.5)),
//           child: Center(
//             child: AppRegularFont(context,msg: msg, color: BLACK_COLOR),
//           )));
// }

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
        child: AppRegularFont(context,msg: msg, color: Theme.of(context).canvasColor,fontSize: ResponsiveWidget.isMediumScreen(context)?16:22),
      ),
    ),
  );
}

cancelButton(BuildContext context,double height, double width, String msg, VoidCallback callback) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: RED_COLOR, width: 1.5)),
      child: Center(
        child: AppRegularFont(context,msg: msg, color: RED_COLOR),
      ),
    ),
  );
}


