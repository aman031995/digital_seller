import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:flutter/material.dart';


class NOInternetScreen extends StatelessWidget {
  bool? isBackButton;
  NOInternetScreen({Key? key, this.isBackButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isBackButton == true ? getAppBarWithBackBtn(
          title: "",
          isBackBtn: true,
          context: context,
          onBackPressed: () {
            Navigator.pop(context, true);
          }) : null,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 180, left: 35, right: 35),
          child: Column(
            children: [
              Image.asset(
                "images/ic_error.png",
                height: 100,
                width: 100,
              ),
              SizedBox(height: 25),
              AppMediumFont(
                  context,
                  msg: StringConstant.noInternet,
                  fontSize: 16,color: Theme.of(context).canvasColor,
                  textAlign: TextAlign.center,
                  maxLines: 3)
            ],
          ),
        ),
      ),
    );
  }
}
