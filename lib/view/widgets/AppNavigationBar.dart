import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';

AppBar getAppBarWithBackBtn(String title) {
  return AppBar(
    elevation: 0,
    leading: Builder(
      builder: (context) => IconButton(
        icon: Image.asset(AssetsConstants.icBack,
            color: TEXT_COLOR, width: 18, height: 18),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
    ),
    centerTitle: true,
    title: AppRegularFont(msg: title, color: TEXT_COLOR, fontSize: 17),
    backgroundColor: WHITE_COLOR,
  );
}
