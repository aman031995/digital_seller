import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/utilities/Responsive.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
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
          SizedBox(width: 30,),
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
              Theme.of(context).canvasColor, 17, false),
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
                child: Image.asset("images/google.png", height: 35, width: 108,),),
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
              Theme.of(context).canvasColor, 17, false),
        ),
        SizedBox(height: 25,),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  child: Image.asset("images/ic_fb.png",
                      height: 33,width: 30, color: Theme.of(context).canvasColor),
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
                      height: 33,width: 30, color: Theme.of(context).canvasColor),
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
                      height: 33,width: 30, color: Theme.of(context).canvasColor),
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
              AppButton(context, 'About Us', onPressed: () {
                setState(() {
                  // GoRouter.of(context).pushNamed(RoutesName.AboutUsPage);
                });
              }),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              AppButton(context, 'Terms Of Use', onPressed: () {
                context.pushRoute(Terms());
                // GoRouter.of(context).pushNamed(RoutesName.Terms);
              }),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              AppButton(context, 'Privacy Policy', onPressed: () {
                context.pushRoute(Privacy());
              }),
              // Container(width: MediaQuery.of(context).size.width * .02),
              // AppButton(context, 'FAQ', onPressed: () {
              //    context.pushRoute(FAQ());
              // }),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              AppButton(context, 'Helpdesk', onPressed: () {
                context.pushRoute(FAQ());
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
              fontSize: 14, color: Theme.of(context).canvasColor, lineBetweenSpace: 1.5 ),
        ),
      ],
    );
  }
}



Widget footerMobile(BuildContext context) {
  return Container(
    color: Theme.of(context).cardColor,
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
                fontSize: 14)

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
                    msg: "Connect With Us",
                    fontSize: 16),
                SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                        child: Image.asset("images/ic_fb.png",
                            height: 38),
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
                            height: 38),
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
                    msg: "Download Now",
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

// Widget footerMobile(BuildContext context){
//   return Container(
//
//     width: SizeConfig.screenWidth,
//     padding: EdgeInsets.only(bottom: 40),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         SizedBox(height: 10),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(width: 10),
//             appTextButton(context, "About Us", Alignment.center,
//                   16, false),
//             appTextButton(context, "Term Of Conditon", Alignment.center,
//                   16, false),
//             appTextButton(context, "Privacy Policy", Alignment.center,
//                   16, false),
//
//
//
//             MediaQuery.of(context).size.width < 417?Container():     appTextButton(context, "FAQ", Alignment.center,
//                  16, false),
//             MediaQuery.of(context).size.width < 490?  Container() :         appTextButton(context, "Helpdesk", Alignment.center,
//                   16, false), SizedBox(width: 25),
//           ],
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(width: 10),
//             MediaQuery.of(context).size.width < 417?    appTextButton(context, "FAQ", Alignment.center,
//                   16, false):Container(),
//             MediaQuery.of(context).size.width < 490?appTextButton(context, "Helpdesk", Alignment.center,
//                   16, false): Container()
//           ],
//         ),
//         SizedBox(height: 10),
//         Container(
//           padding: EdgeInsets.only(left: 15),
//           child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante, velmolestie enim tincidunt ac. Aenean erat justo, fringilla cursus ligula ac, accumsan Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer egestas dapibus ante",style: TextStyle(color:   fontSize: 14)),
//         ),
//         SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(width: 10),
//             Column(
//               children: [
//                 appTextButton(context, "Connect With Us", Alignment.center,
//                  16, false),
//                 SizedBox(height: 8),
//                 Row(
//
//                   children: [
//                     GestureDetector(
//                         child: Image.asset("images/ic_fb.png", height: 38, color:Colors.white),
//                         onTap: () async {
//                           const url = 'https://www.facebook.com';
//                           if (await canLaunch(url)) {
//                             await launch(url);
//                           } else {
//                             throw 'Could not launch $url';
//                           }
//                         }),  SizedBox(width: SizeConfig.screenWidth * 0.01),
//                     GestureDetector(
//                         child: Image.asset("images/ic_instgram.png", height: 38,color:   ),
//                         onTap: () async {
//                           const url = 'https://www.instagram.com';
//                           if (await canLaunch(url)) {
//                             await launch(url);
//                           } else {
//                             throw 'Could not launch $url';
//                           }
//                         }),
//                   ],
//                 ),
//               ],
//             ),
//             Column(
//               children: [
//                 appTextButton(context, "Download Now", Alignment.center,
//                   16, false),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//
//                     Image.asset("images/apple.png", height: 30),  SizedBox(width: SizeConfig.screenWidth * 0.01),
//                     Image.asset("images/google.png", height: 30),
//                   ],
//                 )
//               ],
//             ),
//             SizedBox(width: 15),
//           ],
//         ),
//       ],
//     ),
//
//   );
// }
