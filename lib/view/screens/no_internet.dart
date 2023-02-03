import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';

class NOInternetScreen extends StatelessWidget {
  const NOInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 180, left: 35, right: 35),
      child: Column(
        children: [
          // Image.asset(
          //   AssetsConstants.ic_error,
          //   height: 50,
          //   width: 50,
          // ),
          SizedBox(height: 25),
          AppMediumFont(
              msg: StringConstant.noInternet,
              color: RED_COLOR,
              fontSize: 21,
              textAlign: TextAlign.center,
              maxLines: 3)
        ],
      ),
    );
  }
}
