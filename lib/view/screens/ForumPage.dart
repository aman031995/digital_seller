import 'package:flutter/material.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';

class ForumViewPage extends StatefulWidget {
  const ForumViewPage({Key? key}) : super(key: key);

  @override
  State<ForumViewPage> createState() => _ForumViewPageState();
}

class _ForumViewPageState extends State<ForumViewPage> {
  List<String> imageView = [
    "assets/images/ic_SceneryView.png",
    "assets/images/ic_SceneryOne.png",
  ];

  List<String> textContent = [
    "#Memory#Cool#Nicepic#Mountain \n#Snow#Peace",
    "#Hungry#Yummmy#love#Foodies#Test \n#Bestforever",
  ];

  List<String> userName = ["DeVogs", "Jhon"];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: getAppBarWithBackBtn(
          context: context, isBackBtn: false, title: StringConstant.forumTitle),
      body: forumPageViewList(
          context, SizeConfig.screenHeight, SizeConfig.screenWidth),
    );
  }

  Widget forumPageViewList(
      BuildContext context, double _height, double _width) {
    return Container(
        child: SingleChildScrollView(
      child: Column(children: [
        Stack(
          children: [
            Container(
                height: SizeConfig.screenHeight - 160,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    scrollDirection: Axis.vertical,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return forumViewDetail(index);
                    })),
          ],
        )
      ]),
    ));
  }

  Widget forumViewDetail(int index) {
    return Container(
      height: SizeConfig.screenHeight * 0.44,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      decoration: forumBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                  child: Image.asset(AssetsConstants.icKids),
                ),
                SizedBox(
                  width: 5,
                ),
                AppBoldFont(
                    msg: userName[index],
                    color: BLACK_COLOR,
                    fontSize: 16,
                    textAlign: TextAlign.start),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10, top: 10),
            child: AppMediumFont(
                msg: textContent[index],
                color: FORUM_TEXT_COLOR,
                fontSize: 17,
                textAlign: TextAlign.start),
          ),
          Container(
            height: 200,
            margin: EdgeInsets.only(left: 10, right: 10, top: 5),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imageView[index]),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10.0)),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Image.asset(AssetsConstants.ic_ForumLikeButton),
                SizedBox(
                  width: 10,
                ),
                Image.asset(AssetsConstants.ic_ShareIcon),
                SizedBox(
                  width: 240,
                ),
                Image.asset(AssetsConstants.ic_SaveIcon),
                SizedBox(
                  width: 10,
                ),
                Image.asset(AssetsConstants.ic_SendButtonIcon),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration forumBoxDecoration() {
    return BoxDecoration(
      color: WHITE_COLOR,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        new BoxShadow(
          color: BLACK_COLOR.withOpacity(0.2),
          spreadRadius: 1.5,
          blurRadius: 1.5,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}
