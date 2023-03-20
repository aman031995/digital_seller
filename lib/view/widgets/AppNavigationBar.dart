import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';

AppBar getAppBarWithBackBtn(
    {String? title, bool? isBackBtn, required BuildContext context}) {
  return AppBar(
    elevation: 0,
    leading: isBackBtn == true
        ? GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Container(
              width: 500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 1),
                  Expanded(
                    child: Container(
                        height: 15,
                        width: 15,
                        child: Image.asset(AssetsConstants.icBackArrow,
                            color: BLACK_COLOR, width: 15, height: 15)),
                  ),
                  SizedBox(width: 3),
                  title == ''
                      ? AppMediumFont(
                      context,msg: 'Back',
                          color: TEXT_COLOR,
                          fontSize: 17,
                          textAlign: TextAlign.start)
                      : Container(),
                ],
              ),
            ),
          )
        : Container(),
    centerTitle: true,
    title: AppRegularFont(
        context,msg: title ?? '',
        color: TEXT_COLOR,
        fontSize: 17,
        textAlign: TextAlign.start),
    backgroundColor: Theme.of(context).cardColor,
  );
}
