import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:flutter/material.dart';


Widget noDataFoundMessage(BuildContext context, String message){
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: 70),
        height: SizeConfig.screenHeight * 0.3,
        width: SizeConfig.screenWidth * 0.90,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Theme.of(context).scaffoldBackgroundColor,
          )
        ]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'images/ic_NotFoundLogo.png',
                height: SizeConfig.screenHeight * 0.2,
                width: 300,
              ),
            ),
            AppBoldFont(
                context,msg: message,
                fontSize: 16,
                color: Theme.of(context).canvasColor,textAlign: TextAlign.center),
          ],
        ),
      ),
      // Align(
      //   alignment: Alignment.bottomCenter,
      //   child: Padding(
      //       padding: const EdgeInsets.only(top: 40, bottom: 20),
      //       child: appButton(
      //           context,
      //           StringConstant.tryAgain,
      //           SizeConfig.screenWidth * 0.85,
      //           60,
      //           LIGHT_THEME_COLOR,
      //           WHITE_COLOR,
      //           20,
      //           10,
      //           true,
      //           onTap: null)),
      // )
    ],
  );
}
