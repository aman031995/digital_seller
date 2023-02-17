import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tycho_streams/utilities/AppColor.dart';

class ToastMessage {
  static void message(String? message) {
    Fluttertoast.showToast(
        msg: message!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: TOAST_COLOR,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
