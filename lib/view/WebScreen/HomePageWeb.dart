import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/CommonCarousel.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/TopList.dart';
import 'package:tycho_streams/view/WebScreen/TrendingVideos.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar:  PreferredSize(preferredSize: Size.fromHeight(60),
        child: Container(
          padding: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 40),
                Image.asset(AssetsConstants.icLogo,height: 40),
                Expanded(child: SizedBox(width: SizeConfig.screenWidth*.12)),
                AppBoldFont(msg: 'Home', color: BLACK_COLOR, fontSize: 20),
                SizedBox(width: SizeConfig.screenWidth*.02),
                AppBoldFont(msg: 'Upcoming', color: BLACK_COLOR, fontSize: 20),
                SizedBox(width: SizeConfig.screenWidth*.02),
                AppBoldFont(msg: 'Contact US', color: BLACK_COLOR, fontSize: 20),
                Expanded(child: SizedBox(width: SizeConfig.screenWidth*.12)),
                Image.asset(AssetsConstants.icSearch,height: 40),SizedBox(width: SizeConfig.screenWidth*.02),
                GestureDetector(
                    onTap: (){
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.black87,
                          builder: (BuildContext context) {
                            return SignUp();
                          });
                    },
                    child: Image.asset(AssetsConstants.icSignup,height: 40)),SizedBox(width: SizeConfig.screenWidth*.01),
                GestureDetector(
                    onTap: (){

                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.black87,
                          builder: (BuildContext context) {
                            return LoginUp();
                          });
                    },
                    child: Image.asset(AssetsConstants.icLogin,height: 40)),SizedBox(width: SizeConfig.screenWidth*.02),
              ],
            ),
          )
      ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
                children: [
                  CommonCarousel(),
                  TrendingVideos(Videos:"TrendingVideos"),
                  TrendingVideos(Videos:"LateshMoviews"),
                  TopList(),
                  SizedBox(height: 40),
                  footerDesktop()

                ],
              )
          ),
        )
    );
  }
}
