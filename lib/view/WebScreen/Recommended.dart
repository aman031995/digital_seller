import 'package:flutter/material.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/TrendingVideos.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
class Recommended extends StatefulWidget {
  const Recommended({Key? key}) : super(key: key);

  @override
  State<Recommended> createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            SizedBox(height: 15),
            Stack(
              children: [
                Image.asset("images/Recommended.png",height: SizeConfig.screenHeight/2,width:  SizeConfig.screenWidth,fit: BoxFit.fill),
                Positioned(
                    top:SizeConfig.screenHeight/4.2 ,left:SizeConfig.screenWidth*0.02,
                    child: AppBoldFont(
                  msg: "Tittle of Movie/video",fontSize: 45,color: Colors.white
                )),
                Positioned(
                    top:SizeConfig.screenHeight/3.5,left: SizeConfig.screenWidth*0.02,
                    child: AppLightFont(msg: " Details about time and duration",fontSize: 18,color: Colors.white)),
                Positioned(
                    top:SizeConfig.screenHeight/3.2,left: SizeConfig.screenWidth*0.02,

                    child:Row(
                  children: [
                    Image.asset("images/Playbtn.png",height: 40,width: 130,),
                    OutlinedButton.icon(
                        onPressed: () {},
                        icon:
                        Image.asset('images/add.png', height: 16, width:16),
                        label: Text(
                          'Watchlist',
                          style: TextStyle(color: Colors.white, fontSize:18),
                        ))
                  ],
                )),
                Positioned(
                  top:SizeConfig.screenHeight/2.8,left: SizeConfig.screenWidth*0.02,
                  child: Container(
                    width: SizeConfig.screenWidth*0.39,
                    child: AppLightFont(
                       color: Colors.white,
                        msg: "Lorem Ipsum is simply dummy text of the printing and typesetting industryLorem Ipsum has been the industry's standard dummy text ever since the 1500s,when an unknown printer took a galley of type and scrambled it to make a typespecimen book"),
                  ),
                )
              ],
            ),
            SizedBox(height: 25),
            TrendingVideos(Videos: "Recommmended Videos"),
            SizedBox(height: 40),
            footerDesktop()
          ],

        ),
      ),
    );
  }
}
