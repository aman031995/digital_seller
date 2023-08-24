import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:TychoStream/utilities/AppColor.dart';

class ToastMessage {
  static void message(String? message,BuildContext context) {
    Fluttertoast.showToast(
        msg: message!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        webPosition: "center",
        webBgColor:  "radial-gradient(circle, rgba(0,0,0,1) 0%, rgba(89,93,88,1) 0%)",
        backgroundColor: TOAST_COLOR,
        textColor: WHITE_COLOR,
        fontSize: 18.0
    );
  }
}

