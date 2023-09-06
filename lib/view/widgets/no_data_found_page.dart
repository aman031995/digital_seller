import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:flutter/material.dart';


Widget noDataFoundMessage(BuildContext context, String message,HomeViewModel homeViewModel){
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 70,bottom: 100),
          height: SizeConfig.screenHeight * 0.4,
          width: SizeConfig.screenWidth * 0.90,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).scaffoldBackgroundColor,
            )
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
        SizedBox(height: 150),
        ResponsiveWidget.isMediumScreen(
            context)
            ? footerMobile(context,homeViewModel)
            : footerDesktop(),
      ],
    ),
  );
}
