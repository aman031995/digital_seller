import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:permission_handler/permission_handler.dart';

var alert;
class AppDialog {

  static permissionPopUp(BuildContext context, bool isCamera) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: BG_COLOR,
      title: AppBoldFont(
          msg: isCamera == true ? StringConstant.cameraPer : StringConstant.galleryPer,
          maxLines: 2,
          color: TEXT_COLOR,
          fontSize: 16),
      content: AppRegularFont(
          maxLines: 2,
          msg: isCamera == true ? StringConstant.cameraPerMessage : StringConstant.galleryPerMessage,
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
              dialogueButton(StringConstant.cancel, RED_COLOR, onTap: () {
                Navigator.of(context).pop();
              }),
              Container(
                width: 2,
                height: 35,
                color: DIVIDER_COLOR,
              ),
              dialogueButton(StringConstant.settings, THEME_COLOR, onTap: () {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: BG_COLOR,
          actions: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: textView(title!, 16, WHITE_COLOR),
            ),
            const SizedBox(height: 10),
            const Divider(color: DIVIDER_COLOR, thickness: 2),
            Container(
              padding: const EdgeInsets.only(left: 1, right: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: dialogueButton(text1, Colors.white60, onTap: onCameraTap)),
                  Container(
                    width: 2,
                    height: 35,
                    color: DIVIDER_COLOR,
                  ),
                  Expanded(child: dialogueButton(text2, Colors.white60, onTap: onVideoTap))
                ],
              ),
            ),
          ],
        ),
      ],
    );
    showDialog(context: context, builder: (BuildContext context) {return alert;});
  }

  static deleteDialogue(BuildContext context, {VoidCallback? onTap}) {
    Stack(
      children: [
        alert = AlertDialog(
          backgroundColor: LIGHT_THEME_BACKGROUND,
          title: AppBoldFont(msg: StringConstant.deleteAccountTitle, fontSize: 22,color: TEXT_COLOR,textAlign: TextAlign.center),
          titlePadding: EdgeInsets.only(left: 20,right: 20,top: 10),
          content: AppRegularFont(msg: StringConstant.deleteAccountMessage, fontSize: 14,color: TEXT_COLOR,textAlign: TextAlign.center,maxLines: 2),
          contentPadding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 15),
          actions: [
            Container(
              width: SizeConfig.screenWidth! * 0.8,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cancelButton(35, 110, StringConstant.cancel, () {
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
                  SizedBox(
                    width: 14,
                  ),
                  confirmButton(35, 110, StringConstant.confirm, onTap!),
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
}

textView(String msg, double fontSize, Color color) {
  return Center(
      child: AppRegularFont(
          textAlign: TextAlign.center,
          msg: msg,
          color: color,
          fontSize: fontSize)
  );
}

dialogueButton(String msg, Color color, {VoidCallback? onTap}) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
          color: TRANSPARENT_COLOR,
          alignment: Alignment.center,
          width: 145,
          height: 45,
          child: AppRegularFont(msg: msg, color: color, fontSize: 18)));
}

positiveBtn(double height, double width, String msg, Color color,
    VoidCallback callback) {
  return GestureDetector(
      onTap: callback,
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: AppBoldFont(msg: msg, color: color),
          )
      )
  );
}

negativeBtn(double height, double width, String msg, VoidCallback callback) {
  return GestureDetector(
      onTap: callback,
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: BLACK_COLOR, width: 1.5)),
          child: Center(
            child: AppRegularFont(msg: msg, color: BLACK_COLOR),
          )
      )
  );
}

confirmButton(double height, double width, String msg, VoidCallback callback) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: THEME_COLOR,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: AppRegularFont(msg: msg, color: WHITE_COLOR),
      ),
    ),
  );
}

cancelButton(double height, double width, String msg, VoidCallback callback) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: RED_COLOR, width: 1.5)),
      child: Center(
        child: AppRegularFont(msg: msg, color: RED_COLOR),
      ),
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
        color: WHITE_COLOR,
        borderRadius: BorderRadius.circular(8.0),
      ),
      // decoration: buttonDecoration,
      child: AppBoldFont(msg: title, fontSize: 14, color: TEXT_COLOR),
    ),
  );
}
