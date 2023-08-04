import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utilities/AppTextButton.dart';

class footerDesktop extends StatefulWidget {
  const footerDesktop({Key? key}) : super(key: key);

  @override
  State<footerDesktop> createState() => _footerDesktopState();
}

class _footerDesktopState extends State<footerDesktop> {
 HomeViewModel homeViewModel=HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      height: 200,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 30, left: SizeConfig.screenWidth * 0.04, right: SizeConfig.screenWidth * 0.04, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          footerLeftWidgetContent(context),
          SizedBox(width: 150,),
          footerMiddleWidgetContent(context),
          SizedBox(width: 20,),
          Container(child: footerRightWidgetContent(context)),
          SizedBox(width: 50,),
          Container(
              alignment: Alignment.bottomCenter,
              // margin: EdgeInsets.only(left: 120, right: 120, bottom: 5),
              // width: SizeConfig.screenWidth / 6.5,
              child: GlobalVariable.isLightTheme == true ?
              Image.network("https://eacademyeducation.com:8011/logo/dark_logo.png", fit: BoxFit.fill, width: SizeConfig.screenWidth * 0.1) :
              Image.network("https://eacademyeducation.com:8011/logo/lite_logo.png", fit: BoxFit.fill, width: SizeConfig.screenWidth * 0.1)),
        ],
      ),
    );
  }

  Widget footerRightWidgetContent(BuildContext context){
    return Column(
      children: [
        Container(
          width: 226,
          child: appTextButton(context, "Download Now", Alignment.center,
              Theme.of(context).scaffoldBackgroundColor, 17, false),
        ),
        SizedBox(height: 25,),
        Container(
          child: Row(
            children: [
              GestureDetector(
                  onTap: () async{
                    const url = 'https://apps.apple.com/tt/app/scanamaze/id1613520722';
                    if (await canLaunch(url)) {
                      await launch(url);
                      print('object');
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Image.asset("images/apple.png", height: 35, width: 108)),
              SizedBox(width: 10,),
              GestureDetector(
                onTap: () async{
                  const url = 'https://play.google.com/store/apps/details?id=com.tycho.scanamaze';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Image.asset("images/google.png", height: 35, width: 108),),
            ],
          ),
        )
      ],
    );
  }

  Widget footerMiddleWidgetContent(BuildContext context){
    return  Column(
      children: [
        Container(
          width: 150,
          child: appTextButton(context, "Connect With Us", Alignment.center,
              Theme.of(context).scaffoldBackgroundColor, 17, false),
        ),
        SizedBox(height: 25,),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  child: Image.asset("images/ic_fb.png",
                      height: 33,width: 30, color: Theme.of(context).scaffoldBackgroundColor),
                  onTap: () async {
                    const url = 'https://www.facebook.com';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
              SizedBox(width: MediaQuery.of(context).size.width * .01),
              GestureDetector(
                  child: Image.asset("images/ic_instgram.png",
                      height: 33,width: 30, color: Theme.of(context).scaffoldBackgroundColor),
                  onTap: () async {
                    const url = 'https://www.instagram.com';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
              SizedBox(width: MediaQuery.of(context).size.width * .01),
              GestureDetector(
                  child: Image.asset("images/ic_twitter.png",
                      height: 33,width: 30, color: Theme.of(context).scaffoldBackgroundColor),
                  onTap: () async {
                    const url =
                        'https://twitter.com/i/flow/login?input_flow_data=%7B%22requested_variant%22%3A%22eyJsYW5nIjoiZW4ifQ%3D%3D%22%7D';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget footerLeftWidgetContent(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: SizeConfig.screenWidth / 2,
          child: Row(
            children: [
              AppButton(context, 'About Us',onPressed: () {
                setState(() {
                  // GoRouter.of(context).pushNamed(RoutesName.AboutUsPage);
                });
              }),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              AppButton(context, 'Terms Of Use', onPressed: () {
              //  context.pushRoute(Terms());
                homeViewModel.openWebHtmlView(context, 'terms_condition',
                    title: 'Terms And Condition');
                // GoRouter.of(context).pushNamed(RoutesName.Terms);
              }),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              AppButton(context, 'Privacy Policy', onPressed: () {
                homeViewModel.openWebHtmlView(context, 'privacy_policy',
                    title: 'Privacy Policy');
              }),
              // Container(width: MediaQuery.of(context).size.width * .02),
              // AppButton(context, 'FAQ', onPressed: () {
              //    context.pushRoute(FAQ());
              // }),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              AppButton(context, 'Helpdesk', onPressed: () {
                homeViewModel.openWebHtmlView(
                    context, 'return_policy',
                    title: 'Return Policy');
              }),
              // SizedBox(width: ResponsiveWidget.isMediumScreen(context)? SizeConfig.screenWidth * 0.22 : SizeConfig.screenWidth * 0.32,),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: SizeConfig.screenWidth / 2,
          child: AppMediumFont(context,
              msg:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante",
              fontSize: 14, color: Theme.of(context).scaffoldBackgroundColor, lineBetweenSpace: 1.5 ),
        ),
      ],
    );
  }
}



Widget footerMobile(BuildContext context) {
  return Container(
    color: Theme.of(context).canvasColor,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.only(bottom: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            AppButton(context, 'About Us', onPressed: () {
            //  GoRouter.of(context).pushNamed(RoutesName.AboutUsPage);
            }),
            AppButton(context, 'Terms Of Use', onPressed: () {
              context.pushRoute(Terms());

            }),
            AppButton(context, 'PrivacyPolicy', onPressed: () {
              context.pushRoute(Privacy());
            }),
            MediaQuery.of(context).size.width < 417
                ? Container()
                : AppButton(context, 'FAQ', onPressed: () {
              context.pushRoute(FAQ());
                  }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            MediaQuery.of(context).size.width < 417
                ? AppButton(context, 'FAQ', onPressed: () {

                  })
                : Container(),
          ],
        ),
        SizedBox(height: 10),
        Container(
            padding: EdgeInsets.only(left: 15),
            child: AppMediumFont(context,
                msg:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante, velmolestie enim tincidunt ac. Aenean erat justo, fringilla cursus ligula ac, accumsan Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante',
                fontSize: 14,color: Theme.of(context).scaffoldBackgroundColor)

            //Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante, velmolestie enim tincidunt ac. Aenean erat justo, fringilla cursus ligula ac, accumsan Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante",style: TextStyle(color:  fontSize: 14)),
            ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 15),
            Column(
              children: [
                AppBoldFont(context,
                    fontWeight: FontWeight.w200,
                    msg: "Connect With Us",color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 16),
                SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                        child: Image.asset(AssetsConstants.icFacebook,
                            height: 30, color: Theme.of(context).scaffoldBackgroundColor),
                        onTap: () async {
                          const url = 'https://www.facebook.com';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                    SizedBox(width: SizeConfig.screenWidth * 0.05),
                    GestureDetector(
                        child: Image.asset("images/ic_instgram.png",
                            height: 30, color: Theme.of(context).scaffoldBackgroundColor),
                        onTap: () async {
                          const url = 'https://www.instagram.com';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                AppBoldFont(context,
                    fontWeight: FontWeight.w200,
                    msg: "Download Now",color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 16),
                SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          const url = 'https://apps.apple.com/tt/app/scanamaze/id1613520722';
                          if (await canLaunch(url)) {
                            await launch(url);
                            print('object');
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Image.asset("images/apple.png", height: 30)),
                    SizedBox(width: SizeConfig.screenWidth * 0.01),
                    GestureDetector(
                        onTap: () async {
                          const url = 'https://play.google.com/store/apps/details?id=com.tycho.scanamaze';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Image.asset("images/google.png", height: 30)),
                  ],
                )
              ],
            ),
            SizedBox(width: 15),
          ],
        ),
      ],
    ),
  );
}

