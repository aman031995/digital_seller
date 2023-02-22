

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/OnHover.dart';
import 'package:tycho_streams/view/WebScreen/TrendingVideos.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
class ViewAll extends StatelessWidget {

  ViewAll({Key? key}) : super(key: key);
  List<String> images=["images/Trending1.png","images/Trending2.png","images/Trending3.png","images/Trending4.png","images/Trending5.png","images/Trending1.png",
    "images/Trending1.png","images/Trending2.png","images/Trending3.png","images/Trending4.png","images/Trending5.png","images/Trending1.png",
  ];
  List<String> title=['The Sunset','Mountains hills','Beautiful Beache','Green valley','Black Heads','The Sunset','Mountains hills','Beautiful Beache','Green valley','Black Heads','Mountains hills','Beautiful Beache'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 40),
                  GestureDetector(
                      onTap: (){
                      },
                      child: Image.asset(AssetsConstants.icLogo, height: 40)),
                  Expanded(
                      child: SizedBox(width: SizeConfig.screenWidth * .12)),
                  AppBoldFont(msg: 'Home', color: BLACK_COLOR, fontSize: 20),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                  AppBoldFont(
                      msg: 'Upcoming', color: BLACK_COLOR, fontSize: 20),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                  AppBoldFont(
                      msg: 'Contact US', color: BLACK_COLOR, fontSize: 20),
                  Expanded(
                      child: SizedBox(width: SizeConfig.screenWidth * .12)),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                ],
              ),
            )),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 1200,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
shrinkWrap: true,
                      itemCount: 12,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                       crossAxisCount: 4
                      ),
                      itemBuilder: (BuildContext context, int index){
                        return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/Recommended');
                            } ,
                            child: OnHover(
                              builder: (isHovered) {
                                bool _heigth = isHovered;
                                return Container(
                                  padding: EdgeInsets.only(top: _heigth?0:10,bottom:_heigth?0: 10),
                                  decoration: BoxDecoration(
                                    borderRadius:BorderRadius.circular(5.0),
                                  ),

                                  child: Stack(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                          height: _heigth?330:300,
                                          imageUrl: images[index],
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              placeHoldar(context),
                                          imageBuilder: (context,
                                              imageProvider) =>
                                              Container(
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      5.0),
                                                  image: DecorationImage(
                                                      image:
                                                      imageProvider,
                                                      fit: BoxFit.fill),
                                                ),
                                              )),
                                      Positioned(
                                        bottom:_heigth?40: 50,right:_heigth?30: 35,left: _heigth?20:30,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(AssetsConstants.icplay,height: 22),
                                            Text(title[index],style: TextStyle(fontSize: 22,color: Colors.white)),
                                            SizedBox(width: 22),
                                            Image.asset(AssetsConstants.icadd,height: 20),

                                          ],
                                        ),
                                      ),


                                    ],
                                  ),
                                );
                              },
                              hovered: Matrix4.identity()..translate(0, 0, 0),
                            ));
                      },
                    )),
                SizedBox(height: 40),
                ResponsiveWidget.isMediumScreen(context)? footerMobile(context):footerDesktop()
              ],
            ),
          ),
        ),
    );
  }
}

