import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../utilities/AppTextButton.dart';

class footerDesktop extends StatefulWidget {
  const footerDesktop({Key? key}) : super(key: key);

  @override
  State<footerDesktop> createState() => _footerDesktopState();
}

class _footerDesktopState extends State<footerDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                SizedBox(width: 50),
                Expanded(child: SizedBox(width: SizeConfig.screenWidth*0.02)),
                appTextButton(context, "About Us", Alignment.center,
                    Colors.white, 20, false),
                appTextButton(context, "Term Of Conditon", Alignment.center,
                    Colors.white, 20, false),
                appTextButton(context, "Privacy Policy", Alignment.center,
                    Colors.white, 20, false),
                appTextButton(context, "FAQ", Alignment.center,
                    Colors.white, 20, false),
                appTextButton(context, "Helpdesk", Alignment.center,
                    Colors.white, 20, false),
                Expanded(
                    flex: 15,
                    child: SizedBox(width: SizeConfig.screenWidth*0.22)),
                appTextButton(context, "Connect With Us", Alignment.center,
                    Colors.white, 20, false),
                SizedBox(width: 30),
                appTextButton(context, "Download Now", Alignment.center,
                    Colors.white, 20, false),
                Expanded(
                    flex: 5,
                    child: SizedBox(width: SizeConfig.screenWidth*0.12)),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.only(left:  MediaQuery.of(context).size.width * .06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante, vel",style: TextStyle(color:Colors.white,fontSize: 18)),
                  Row(
                    children: [
                      Text("molestie enim tincidunt ac. Aenean erat justo, fringilla cursus ligula ac, accumsan",style: TextStyle(color:  Colors.white,fontSize: 18))
                      ,Expanded(
                          flex: 8,
                          child: SizedBox(width: SizeConfig.screenWidth * .27)),
                      GestureDetector(
                          child: Image.asset("images/ic_fb.png", height: 38, color:Colors.white),
                          onTap: () async {
                            const url = 'https://www.facebook.com';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }),
                      SizedBox(width: SizeConfig.screenWidth * .01),
                      GestureDetector(
                          child: Image.asset("images/ic_instgram.png", height: 38,color:  Colors.white,),
                          onTap: () async {
                            const url = 'https://www.instagram.com';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }),
                      SizedBox(width: SizeConfig.screenWidth * .01),
                      GestureDetector(
                          child: Image.asset("images/ic_twitter.png", height: 38,color:
                          Colors.white),
                          onTap: () async {
                            const url =
                                'https://twitter.com/i/flow/login?input_flow_data=%7B%22requested_variant%22%3A%22eyJsYW5nIjoiZW4ifQ%3D%3D%22%7D';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }),
                      SizedBox(width: SizeConfig.screenWidth * 0.01),
                      Image.asset("images/apple.png", height: 40),
                      Image.asset("images/google.png", height: 40),
                      Expanded(
                          flex: 2,
                          child: SizedBox(width: SizeConfig.screenWidth * .05)),
                    ],
                  ),
                  Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante",style: TextStyle(color: Colors.white,fontSize: 18)),
                ],
              ),
            )
          ],
        ));
  }
}
