import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/DesktopAppBar.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight( ResponsiveWidget.isMediumScreen(context)? 50:70),
          child: DesktopAppBar()

      ),
      drawer: MobileMenu(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Container(width: MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height/4,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                  color: Colors.black),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetsConstants.icLogo,
                    width: ResponsiveWidget.isMediumScreen(context)
                        ? MediaQuery.of(context).size.width/4
                        : MediaQuery.of(context).size.width/4,
                    height: ResponsiveWidget.isMediumScreen(context)
                        ?  MediaQuery.of(context).size.height/10
                        :  MediaQuery.of(context).size.height/10,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                  Text("Tycho Stream Website",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),)
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.02),
            Container(
              width: MediaQuery.of(context).size.width/1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBoldFont(
                      context,fontWeight: FontWeight.w600,
                      fontSize:
                          ResponsiveWidget.isMediumScreen(context) ? 15 : 30,
                      msg: "ORIGINAL. EXCLUSIVE. PREMIUM.",
                      color: Colors.black),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                  AppRegularFont(
                      context,maxLines: 5,
                      fontSize:
                          ResponsiveWidget.isMediumScreen(context) ? 10 : 20,
                    
                      msg:
                          "Alifbata, a subsidiary of Balaji Telefilms Limited, is the Group’s foray into the Digital Entertainment space. After conquering television and making a strong mark in films, Balaji Telefilms aims to reach out directly to individual audiences, by providing them with original, exclusive and tailor-made shows, that they can access at their fingertips."),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02),
                  AppBoldFont(
                    context,fontWeight: FontWeight.w600,
                    fontSize:
                        ResponsiveWidget.isMediumScreen(context) ? 15 : 30,
                    msg: "WHAT'S IN STORE? FRESH STORIES. LIKE NEVER BEFORE.",
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                  AppRegularFont(
                      context,maxLines: 5,
                      fontSize:
                          ResponsiveWidget.isMediumScreen(context) ? 10 : 20,
                      msg:
                          "Alifbata offers fresh, original and exclusive stories. Tailored especially for Indians across the globe, the platform hosts premium, high quality shows featuring popular celebrities, acclaimed writers, and award winning directors, making Alifbata a true alternative to mainstream entertainment."),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02),
                  AppBoldFont(
                    context,fontWeight: FontWeight.w600,
                    fontSize:
                        ResponsiveWidget.isMediumScreen(context) ? 15 : 30,
                    
                    msg: "STORIES FOR EVERYONE",
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                  AppRegularFont(
                      context,maxLines: 5,
                      fontSize:
                          ResponsiveWidget.isMediumScreen(context) ? 10 : 20,
                      
                      msg:
                          "With stories from different worlds, in genres ranging from thrillers, mystery and crime to drama, comedy and romance; Alifbata has shows for everyone, from college going youngsters to professionals with families."),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02),
                  AppBoldFont(
                    context,fontWeight: FontWeight.w600,
                    fontSize:
                        ResponsiveWidget.isMediumScreen(context) ? 15 : 30,
                    
                    msg: "REGION NO BAR",
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                  AppRegularFont(
                      context,maxLines: 5,
                      fontSize:
                          ResponsiveWidget.isMediumScreen(context) ? 10 : 20,
                      
                      msg:
                          "Alifbata will host shows in various languages, catering to our regional language speakers, both in India and abroad."),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02),
                  AppBoldFont(
                    context,fontWeight: FontWeight.w600,
                    fontSize:
                        ResponsiveWidget.isMediumScreen(context) ? 15 : 30,
                    
                    msg: "TECHNOLOGY, YOUR ENABLER",
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                  AppRegularFont(
                      context,maxLines: 5,
                      fontSize:
                          ResponsiveWidget.isMediumScreen(context) ? 10 : 20,
                      
                      msg:
                          "Alifbata is a subscription based video on demand (SVOD) service. Available across multiple interfaces ranging from desktops, laptops, tablets, smart-phones to internet-ready television, Alifbata marries state-of-the-art technology with gripping storytelling."),
                ],
              ),
            ),
            SizedBox(height:ResponsiveWidget.isMediumScreen(context)?40: 70),
            ResponsiveWidget.isMediumScreen(context)?   footerMobile(context):    footerDesktop()
          ]),
        ),
      ),
    );
  }
}
