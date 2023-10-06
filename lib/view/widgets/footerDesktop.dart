import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:provider/provider.dart';
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
  void initState() {
    homeViewModel.getAppConfig(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider.value(
        value: homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _){
          return Container(
      color: Theme.of(context).canvasColor,
      height: ResponsiveWidget.isSmallScreen(context)
          ?240:250,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
          bottom: 10,
          left: SizeConfig.screenWidth * 0.04,
          right: SizeConfig.screenWidth * 0.04,
          top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              footerLeftWidgetContent(context),
              SizedBox(
                width: 150,
              ),
              footerMiddleWidgetContent(context,homeViewModel),
              SizedBox(
                width: 20,
              ),
              Container(child: footerRightWidgetContent(context)),

            ],
          ),
          SizedBox(height: 15),
          Container(
              alignment: Alignment.bottomRight,
              child: GlobalVariable.isLightTheme == true
                  ? Image.network(StringConstant.digitalSellerDarklogo,
                      fit: BoxFit.fill,width: SizeConfig.screenWidth*0.12,height: 50)
                  : Image.network(StringConstant.digitalSellerLitelogo,
                      fit: BoxFit.fill,width: SizeConfig.screenWidth*0.12,height: 50)),
        ],
      ),
    );}));
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
            // InkWell(
            //     onTap: () async {
            //       const url =
            //           'https://apps.apple.com/tt/app/scanamaze/id1613520722';
            //       if (await canLaunch(url)) {
            //         await launch(url);
            //         print('object');
            //       } else {
            //         throw 'Could not launch $url';
            //       }
            //     },
            //     child: Image.asset(AssetsConstants.icApple,
            //         height: 35)),
            SizedBox(width: 5),
            InkWell(
              onTap: () async {
                var url = StringConstant.playestoreurl;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Image.asset(AssetsConstants.icPlaystore,  color: Theme.of(context).scaffoldBackgroundColor,
                  height: 35),
            ),
          ],
        )
      ],
    );
  }

  Widget footerMiddleWidgetContent(BuildContext context, HomeViewModel homeViewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 160,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * .013),

              InkWell(
                  child: Image.asset(AssetsConstants.icFacebook,
                      height: 33,
                      width: 30,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  onTap: () async {
                  String url = homeViewModel.appConfigModel?.androidConfig?.socialMedia?.facebook?.url ?? "";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
              SizedBox(width: MediaQuery.of(context).size.width * .01),
              InkWell(
                  child: Image.asset(AssetsConstants.ic_instagram,
                      height: 33,
                      width: 30,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  onTap: () async {
                    String url = homeViewModel.appConfigModel?.androidConfig?.socialMedia?.instagram?.url ?? "";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
              SizedBox(width: MediaQuery.of(context).size.width * .01),
              // InkWell(
              //     child: Image.asset("images/ic_twitter.png",
              //         height: 33,
              //         width: 30,
              //         color: Theme.of(context).scaffoldBackgroundColor),
              //     onTap: () async {
              //       String url = homeViewModel.appConfigModel?.androidConfig?.socialMedia?.twitter?.url ?? "";
              //
              //       if (await canLaunch(url)) {
              //         await launch(url);
              //       } else {
              //         throw 'Could not launch $url';
              //       }
              //     }),
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

Widget footerMobile(BuildContext context,HomeViewModel homeViewModel) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width:5),
                    GestureDetector(
                        child: Image.asset(AssetsConstants.icFacebook,
                            height: 30,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        onTap: () async {
                          String url = homeViewModel.appConfigModel?.androidConfig?.socialMedia?.facebook?.url ?? "";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                    SizedBox(width:5),
                    GestureDetector(
                        child: Image.asset(AssetsConstants.ic_instagram,
                            height: 30,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        onTap: () async {
                          String url = homeViewModel.appConfigModel?.androidConfig?.socialMedia?.instagram?.url ?? "";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                    SizedBox(width:5),
                    // InkWell(
                    //     child: Image.asset("images/ic_twitter.png",
                    //         height: 33,
                    //         width: 30,
                    //         color: Theme.of(context).scaffoldBackgroundColor),
                    //     onTap: () async {
                    //       String url = homeViewModel.appConfigModel?.androidConfig?.socialMedia?.twitter?.url ?? "";
                    //       if (await canLaunch(url)) {
                    //         await launch(url);
                    //       } else {
                    //         throw 'Could not launch $url';
                    //       }
                    //     }),
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
                    // GestureDetector(
                    //     onTap: () async {
                    //       const url =
                    //           'https://apps.apple.com/tt/app/scanamaze/id1613520722';
                    //       if (await canLaunch(url)) {
                    //         await launch(url);
                    //         print('object');
                    //       } else {
                    //         throw 'Could not launch $url';
                    //       }
                    //     },
                    //     child:
                    //         Image.asset(AssetsConstants.icApple, height: 30)),
                    SizedBox(width: SizeConfig.screenWidth * 0.01),
                    GestureDetector(
                        onTap: () async {
                          var url = StringConstant.playestoreurl;

                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child:
                            Image.asset(AssetsConstants.icPlaystore,   color: Theme.of(context).scaffoldBackgroundColor,height: 30)),
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
                fit: BoxFit.fill, width: 150)
                : Image.network(StringConstant.digitalSellerLitelogo,
                fit: BoxFit.fill, width: 150)),
        SizedBox(height: 10),

      ],
    ),
  );
}
