import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../AppRouter.gr.dart';
import '../../utilities/AppTextButton.dart';
import '../../utilities/StringConstants.dart';

class footerDesktop extends StatefulWidget {
  const footerDesktop({Key? key}) : super(key: key);

  @override
  State<footerDesktop> createState() => _footerDesktopState();
}

class _footerDesktopState extends State<footerDesktop> {
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      height: 210,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
          bottom: 10,
          left: SizeConfig.screenWidth * 0.04,
          right: SizeConfig.screenWidth * 0.04,
          top: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              footerLeftWidgetContent(context),
              SizedBox(
                width: 150,
              ),
              footerMiddleWidgetContent(context),
              SizedBox(
                width: 20,
              ),
              Container(child: footerRightWidgetContent(context)),

            ],
          ),
          SizedBox(height: 10),
          Container(
              alignment: Alignment.bottomRight,
              child: GlobalVariable.isLightTheme == true
                  ? Image.network(StringConstant.digitalSellerDarklogo,
                      fit: BoxFit.fill, width: SizeConfig.screenWidth * 0.1)
                  : Image.network(StringConstant.digitalSellerLitelogo,
                      fit: BoxFit.fill, width: SizeConfig.screenWidth * 0.1)),
        ],
      ),
    );
  }

  Widget footerRightWidgetContent(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 226,
          child: appTextButton(
              context,
              StringConstant.Download,
              Alignment.center,
              Theme.of(context).scaffoldBackgroundColor,
              17,
              false),
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
                onTap: () async {
                  const url =
                      'https://apps.apple.com/tt/app/scanamaze/id1613520722';
                  if (await canLaunch(url)) {
                    await launch(url);
                    print('object');
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Image.asset(AssetsConstants.icApple,
                    height: 35)),
            SizedBox(width: 5),
            InkWell(
              onTap: () async {
                const url =
                    'https://play.google.com/store/apps/details?id=com.tycho.scanamaze';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Image.asset(AssetsConstants.icGoogle,
                  height: 35),
            ),
          ],
        )
      ],
    );
  }

  Widget footerMiddleWidgetContent(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          child: appTextButton(
              context,
              StringConstant.connectus,
              Alignment.center,
              Theme.of(context).scaffoldBackgroundColor,
              17,
              false),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  child: Image.asset(AssetsConstants.icFacebook,
                      height: 33,
                      width: 30,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  onTap: () async {
                    const url = 'https://www.facebook.com';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
              SizedBox(width: MediaQuery.of(context).size.width * .01),
              InkWell(
                  child: Image.asset("images/ic_instgram.png",
                      height: 33,
                      width: 30,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  onTap: () async {
                    const url = 'https://www.instagram.com';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
              SizedBox(width: MediaQuery.of(context).size.width * .01),
              InkWell(
                  child: Image.asset("images/ic_twitter.png",
                      height: 33,
                      width: 30,
                      color: Theme.of(context).scaffoldBackgroundColor),
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

  Widget footerLeftWidgetContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: SizeConfig.screenWidth / 2,
          child: Row(
            children: [
              AppButton(context, StringConstant.AboutUs, onPressed: () {
                context.router
                    .push(WebHtmlPage(title: 'AboutUs', html: 'about_us'));
              }),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              AppButton(context, StringConstant.TermsOfuse, onPressed: () {
                context.router.push(WebHtmlPage(
                    title: 'TermsAndCondition', html: 'terms_condition'));
              }),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              AppButton(context, StringConstant.privacyPolicy, onPressed: () {
                context.router.push(WebHtmlPage(
                    title: 'PrivacyPolicy', html: 'privacy_policy'));
              }),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              AppButton(context, StringConstant.HelpDesk, onPressed: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                if (sharedPreferences.getString('token') == null) {
                  showDialog(
                      context: context,
                      barrierColor:
                          Theme.of(context).canvasColor.withOpacity(0.6),
                      builder: (BuildContext context) {
                        return LoginUp(
                          product: true,
                        );
                      });
                } else {
                  context.router.push(ContactUs());
                }
              }),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: SizeConfig.screenWidth / 2,
          child: AppMediumFont(context,
              msg: StringConstant.Loremtext,
              fontSize: 14,
              color: Theme.of(context).scaffoldBackgroundColor,
              lineBetweenSpace: 1.5),
        ),
      ],
    );
  }
}

Widget footerMobile(BuildContext context) {
  return Container(
    color: Theme.of(context).canvasColor,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            AppButton(context, StringConstant.AboutUs, onPressed: () {
              context.router
                  .push(WebHtmlPage(title: 'AboutUs', html: 'about_us'));
            }),
            AppButton(context, StringConstant.TermsOfuse, onPressed: () {
              context.router.push(WebHtmlPage(
                  title: 'TermsAndCondition', html: 'terms_condition'));
            }),
            AppButton(context, StringConstant.privacyPolicy, onPressed: () {
              context.router.push(
                  WebHtmlPage(title: 'PrivacyPolicy', html: 'privacy_policy'));
            }),
            MediaQuery.of(context).size.width < 417
                ? Container()
                : AppButton(context, StringConstant.HelpDesk,
                    onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    if (sharedPreferences.getString('token') == null) {
                      showDialog(
                          context: context,
                          barrierColor:
                              Theme.of(context).canvasColor.withOpacity(0.6),
                          builder: (BuildContext context) {
                            return LoginUp(
                              product: true,
                            );
                          });
                    } else {
                      context.router.push(ContactUs());
                    }
                  }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            MediaQuery.of(context).size.width < 417
                ? AppButton(context, StringConstant.HelpDesk,
                    onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    if (sharedPreferences.getString('token') == null) {
                      showDialog(
                          context: context,
                          barrierColor:
                              Theme.of(context).canvasColor.withOpacity(0.6),
                          builder: (BuildContext context) {
                            return LoginUp(
                              product: true,
                            );
                          });
                    } else {
                      context.router.push(ContactUs());
                    }
                  })
                : Container(),
          ],
        ),
        SizedBox(height: 10),
        Container(
            padding: EdgeInsets.only(left: 15, right: 10),
            child: AppMediumFont(context,
                msg: StringConstant.Loremtext,
                fontSize: 14,
                color: Theme.of(context).scaffoldBackgroundColor)),
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
                    msg: StringConstant.connectus,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 16),
                SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                        child: Image.asset(AssetsConstants.icFacebook,
                            height: 30,
                            color: Theme.of(context).scaffoldBackgroundColor),
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
                            height: 30,
                            color: Theme.of(context).scaffoldBackgroundColor),
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
                    msg: StringConstant.Download,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 16),
                SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          const url =
                              'https://apps.apple.com/tt/app/scanamaze/id1613520722';
                          if (await canLaunch(url)) {
                            await launch(url);
                            print('object');
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child:
                            Image.asset(AssetsConstants.icApple, height: 30)),
                    SizedBox(width: SizeConfig.screenWidth * 0.01),
                    GestureDetector(
                        onTap: () async {
                          const url =
                              'https://play.google.com/store/apps/details?id=com.tycho.scanamaze';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child:
                            Image.asset(AssetsConstants.icGoogle, height: 30)),
                  ],
                )
              ],
            ),
            SizedBox(width: 15),
          ],
        ),
        SizedBox(height: 20),

        Container(
          padding: EdgeInsets.only(right: 16),
            alignment: Alignment.bottomRight,
            child: GlobalVariable.isLightTheme == true
                ? Image.network(StringConstant.digitalSellerDarklogo,
                fit: BoxFit.fill, width: 120)
                : Image.network(StringConstant.digitalSellerLitelogo,
                fit: BoxFit.fill, width: 120)),
      ],
    ),
  );
}
