import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:flutter/material.dart';


class NOInternetScreen extends StatelessWidget {
  bool? isBackButton;
  NOInternetScreen({Key? key, this.isBackButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsConstants.ic_noInternet,
              height:ResponsiveWidget.isMediumScreen(context)
                  ?150 :300,
              width: ResponsiveWidget.isMediumScreen(context)
                  ?80 :200,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.all(10),
              child: AppMediumFont(
                  context,
                  msg: StringConstant.noInternet,
                  fontSize: 18,color:Colors.red,
                  textAlign: TextAlign.center,
                  maxLines: 3),
            )
          ],
        ),
      ),
    );
  }
}
