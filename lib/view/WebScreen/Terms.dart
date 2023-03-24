import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/DesktopAppBar.dart';
import 'package:tycho_streams/view/WebScreen/EditProfile.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/widgets/app_menu.dart';
import 'package:tycho_streams/view/widgets/search_view.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
class Terms extends StatefulWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  HomeViewModel homeViewModel = HomeViewModel();
  ScrollController _scrollController = ScrollController();
  TextEditingController? searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isSearch = false;
  int pageNum = 1;
  @override
  void initState() {
    homeViewModel.getAppConfigData(context);
    searchController?.addListener(() {
      homeViewModel.getSearchData(
          context, '${searchController?.text}', pageNum);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return

      ChangeNotifierProvider(
          create: (BuildContext context) => homeViewModel,
          child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
      return
      GestureDetector(
        onTap: () {
            if (isSearch == true) {
              isSearch = false;
              searchController?.clear();
              setState(() {});
            }
            if( isLogins == true){
              isLogins=false;
              setState(() {

              });
            }
        },
        child: Scaffold(
          drawer: AppMenu(homeViewModel: viewmodel),

          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar:  PreferredSize(preferredSize: Size.fromHeight( 60),
            child: Container(
              height: 55,
              color: Theme.of(context).cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 40),
                  Image.asset(AssetsConstants.icLogo, height: 40),
                  Expanded(child: SizedBox(width: SizeConfig.screenWidth * .12)),
                  AppButton(context, 'Home', onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(RoutesName.home);
                  }),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                  AppButton(context, 'Contact US',
                      onPressed: () {
                        GoRouter.of(context).pushNamed(
                          RoutesName.Contact,
                        );
                      }),
                  Expanded(
                      child: SizedBox(
                          width: SizeConfig.screenWidth * .12)),
                  Container(
                      height: 45,
                      width: SizeConfig.screenWidth / 4.2,
                      alignment: Alignment.center,
                      child: AppTextField(
                          controller: searchController,
                          maxLine: searchController!.text.length > 2 ? 2 : 1,
                          textCapitalization:
                          TextCapitalization.words,
                          secureText: false,
                          floatingLabelBehavior:
                          FloatingLabelBehavior.never,
                          maxLength: 30,
                          labelText:
                          'Search videos, shorts, products',
                          keyBoardType: TextInputType.text,
                          onChanged: (m) {
                            isSearch = true;

                              if( isLogins == true){
                                isLogins=false;
                                setState(() {

                                });
                              }
                          },
                          isTick: null)),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                  names == "null"
                      ? OutlinedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder:
                                (BuildContext context) {
                              return const SignUp();
                            });
                      },
                      style: ButtonStyle(
                        overlayColor:
                        MaterialStateColor.resolveWith(
                                (states) =>
                            Theme.of(context)
                                .primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(
                            Size.fromHeight(30)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    5.0))),
                      ),
                      child: appTextButton(
                          context,
                          'SignUp',
                          Alignment.center,
                          Theme.of(context).canvasColor,
                          18,
                          true))
                      : appTextButton(
                      context,
                      names!,
                      Alignment.center,
                      Theme.of(context).canvasColor,
                      18,
                      true,
                      onPressed: () {
                          if (isSearch == true) {
                            isSearch = false;
                            searchController?.clear();
                            setState(() {});
                          }

                      }),
                  names == "null"
                      ? SizedBox(
                      width: SizeConfig.screenWidth * .01)
                      : const SizedBox(),
                  names == "null"
                      ? OutlinedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder:
                                (BuildContext context) {
                              return const LoginUp();
                            });
                      },
                      style: ButtonStyle(
                        overlayColor:
                        MaterialStateColor.resolveWith(
                                (states) =>
                            Theme.of(context)
                                .primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(
                            Size.fromHeight(30)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    5.0))),
                      ),
                      child: appTextButton(
                          context,
                          'Login',
                          Alignment.center,
                          Theme.of(context).canvasColor,
                          18,
                          true))
                      : GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogins = true;

                          if (isSearch == true) {
                            isSearch = false;
                            searchController?.clear();
                            setState(() {});
                          }

                      });
                    },
                    child: Image.asset(
                      'images/LoginUser.png',
                      height: 30,
                      color:
                      Theme.of(context).accentColor,
                    ),
                  ),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                ],
              ),
            )),
        body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                          width: SizeConfig.screenWidth * .65,
                          child: Column(
                            children: [
                              AppBoldFont(
                                  context,msg: "TERMS OF USE",
                                  fontSize:ResponsiveWidget.isMediumScreen(context)?20: 30,

                                  fontWeight: FontWeight.w500),
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: SizeConfig.screenHeight * 0.03),

                                        AppBoldFont(
                                            context,
                                            msg: "1. ELIGIBILITY", fontSize:ResponsiveWidget.isMediumScreen(context)?16: 24),
                                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                                        Container(
                                          padding: EdgeInsets.only(left: 35),
                                          child: AppRegularFont(
                                              context,maxLines: 6,
                                              fontSize:ResponsiveWidget.isMediumScreen(context)?14: 20,
                                              msg:
                                              "1.1. Android and Web users with existing subscriptions purchased directly through the platform may be eligible to participate and avail the benefit of this Referral Program as shall be intimated by  Users with subscriptions purchased from third parties through iOS, BSNL, Jio STB, Tata Sky Binge or as part of a bundle pack are not eligible to participate or avail the benefit of this Referral Program."                        ),
                                        ),  SizedBox(height: SizeConfig.screenHeight * 0.02),
                                        AppBoldFont(context,
                                            msg: "2. HOW THE REFERRAL PROGRAM WORKS", fontSize:ResponsiveWidget.isMediumScreen(context)?16:  24),
                                        SizedBox(height: SizeConfig.screenHeight * 0.01),
                                        Container(
                                            padding: EdgeInsets.only(left: 35),
                                            child: AppRegularFont(
                                                context,maxLines: 6,
                                                fontSize: ResponsiveWidget.isMediumScreen(context)?14:20,
                                                msg:
                                                "2.1. This Referral Program enables Referrers to share a unique referral link/ Referral coupon code as may be made available to the Referrer by  to friends, family or any other personal connections through various means of communication, including Email, Text messages, WhatsApp and other Social media platforms."
                                            )),
                                        SizedBox(height: 3),
                                        Container(
                                            padding: EdgeInsets.only(left: 35),
                                            child: AppRegularFont(
                                                context,maxLines: 6,
                                                fontSize:ResponsiveWidget.isMediumScreen(context)?14: 20,
                                                msg:
                                                "2.2. Any person who purchasessubscription through this Referral link/ Referral coupon code is termed as  and upon successful purchase of the subscription, both Referrer and Referee receive a complimentary extension to their subscription and the duration of such complimentary extension shall be dependent of the subscription purchased by the Referee(s) and shall be intimated to the Referee me of purchase of the subscription and making available of the respectively "                            )),  SizedBox(height: SizeConfig.screenHeight * 0.02),
                                        AppBoldFont(
                                            context,msg: "3. VALID REFERRAL",fontSize:ResponsiveWidget.isMediumScreen(context)?16: 24),
                                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                                        Container(
                                            padding: EdgeInsets.only(left: 35),
                                            child: AppRegularFont(
                                                context,maxLines: 6,
                                                fontSize: ResponsiveWidget.isMediumScreen(context)?14:20,
                                                msg:
                                                "3.1. In order to qualify as a Valid Referral and avail Benefit, the Referee must not be an existing or subscriber and must purchase a fresh subscription through the Referral Link/ Referral coupon code."
                                            )
                                        ),  SizedBox(height: SizeConfig.screenHeight * 0.02),
                                        AppBoldFont(
                                            context,msg: "4. GOVERNING LAW AND JURISDICTION",  fontSize: ResponsiveWidget.isMediumScreen(context)?16:24),
                                        SizedBox(height: SizeConfig.screenHeight * 0.01),
                                        Container(
                                            padding: EdgeInsets.only(left: 35),
                                            child: AppRegularFont(
                                                context,maxLines: 6,
                                                fontSize:ResponsiveWidget.isMediumScreen(context)?14: 20,
                                                msg:
                                                "10.1. These Terms and Conditions shall be governed by the laws of India, without giving effect to any choice of law or conflict of law rules. These Terms and Conditions would be modified / discontinued based on the prevailing law /regulation at any point of time and shall be under no liability or obligation or continue implementation of the Referral Program till such time the terms are modified as per the prevailing/ amended law at that point of time. In the event, that the Referral Program cannot be continued without total compliance of the prevailing law at any point of time, this Referral Program shall be deemed to be terminated forthwith from the date when the amended law restricting / prohibiting the Referral Program comes into force."
                                            )
                                        ),
                                        SizedBox(height: SizeConfig.screenHeight * 0.01),
                                        Container(
                                            padding: EdgeInsets.only(left: 35),
                                            child: AppRegularFont(
                                                context,maxLines: 6,
                                                fontSize:ResponsiveWidget.isMediumScreen(context)?14: 20,
                                                msg:
                                                "10.2. To the extent permitted by applicable law, the Referrer agrees that any and all disputes, claims, and causes of action arising out of or relating to these Terms and Conditions shall be resolved individually, without resort to any form of class action, and exclusively by the Courts of Mumbai."                              )
                                        ),  SizedBox(height: SizeConfig.screenHeight * 0.01),
                                        AppRegularFont(
                                          context,fontSize:ResponsiveWidget.isMediumScreen(context)?14: 20,
                                          maxLines: 7,
                                          msg:
                                          "PLEASE READ. YOUR USE OF THE DIGITAL  OTT PLATFORM IS SUBJECT TO THESE TERMS OF USE AND OUR PRIVACY POLICY. BY USING THE SITE, YOU CONSENT TO THE COLLECTION AND USE OF YOUR DATA IN ACCORDANCE WITH OUR PRIVACY POLICY",
                                        ),
                                        SizedBox(height: SizeConfig.screenHeight * 0.03),
                                        AppRegularFont(
                                            context,fontSize:ResponsiveWidget.isMediumScreen(context)?14: 20,
                                            maxLines: 25,
                                            msg:
                                            "These Terms of Use (“Terms”) applies to the  Media Entertainment Limited digital platforms including without limitation and other related websites, mobile applications and other online features that link to this Terms (each a “Site(s). These Terms shall apply to the websites, web pages, digital platforms, interactive features, applications, widgets, blogs, social networks, etc., ernative reality worlds or features, or other online or wireless offerings that post a link to these Terms, whether accessed via computer, mobile device or other technology, manner or means. The Site(s)are offered by  These Terms govern your rights and responsibilities in connection with the particular Site(s) that you are using. The term Site(s) includes the content on that Site(s) all of our services provided on or through that Site(s)(the “Services”), and any software that we make available on or through that Site (the ”Software”), unless otherwise specified. You “use” the Site(s) anytime you access (via computer, mobile device or other devices, etc.), view, link to or from, or otherwise interact or communicate with or connect to, the Site(s) (or any parts thereof) or interact or communicate with other users through the Site(s) (including, without limitation, on message boards, chat rooms and other communities established on the App(s)). Your use of the Site(s) (or any part thereof) signifies your agreement to be bound by these Terms and the which is hereby incorporated by this reference into these Terms. These Terms constitute a legally binding agreement between you and services that allow for the sharing of such content with third party(ies) and access to and or view the video, audio, and other content through such Site(s). free of charge which may include advertisements or commercials or (b) via subscription through payment of a subscription fee or (c) a pay-per-view model with or withoutcommercials or (d) with a combination of the foregoing, on the Service (including the Subscription Services). Some of the content made available on the Service is being provided for free and there are no subscription charges for the usage of the Service. However, the reserves the right to adopt any method of monetization through the Service in the future as it deems fit")
                                        ,SizedBox(height: SizeConfig.screenHeight * 0.03),
                                        AppRegularFont(
                                            context,fontSize: ResponsiveWidget.isMediumScreen(context)?14:20,
                                            maxLines: 7,
                                            msg:
                                            "reserves the right at its sole discretion, to change, modify or add to these Terms or to the Privacy Policy, in whole or in part, at any time. Changes to these Terms or the Privacy Policy will be effective when posted. You agree to review these Terms and the Privacy Policy periodically to become aware of any changes App(s) or any part thereof after any changes to these Terms or the Privacy Policy are posted will be considered acceptance of those changes and will constitute your agreement to be bound thereby. If you object to any such changes, your sole recourse will be to stop using the Site(s)."                        ),


                                      ]
                                  )
                              )
                            ],
                          )),
                      SizedBox(height:ResponsiveWidget.isMediumScreen(context)?40: 70),
                      ResponsiveWidget.isMediumScreen(context)?   footerMobile(context): footerDesktop()
                    ]),
              ),
              isLogins == true
                  ? profile(context, setState)
                  : Container(),
              if (homeViewModel.searchDataModel != null)
                searchView(context, homeViewModel, isSearch, _scrollController, homeViewModel, searchController!, setState)
            ],

        ),
    ),
      );}));
  }
}
