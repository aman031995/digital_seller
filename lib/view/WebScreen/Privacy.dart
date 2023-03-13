import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/DesktopAppBar.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return
      Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(preferredSize: Size.fromHeight( ResponsiveWidget.isMediumScreen(context)? 50:70),
            child: DesktopAppBar()),
        body: SingleChildScrollView(

        child: Center(
          child: Column(
            children: [
              SizedBox(height: 15),
              Container(
                  width: SizeConfig.screenWidth * .65,
                  child: Column(children: [
                    AppBoldFont(
                        context,msg: "PRIVACY POLICY",
                        fontSize:ResponsiveWidget.isMediumScreen(context)?15: 30,
                        fontWeight: FontWeight.w500),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppRegularFont(
                            context,fontSize: ResponsiveWidget.isMediumScreen(context)?12:24,
                            msg:
                            "© 2022 TychoStream Pictures Networks India Private Limited. All rights reserved.",
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.03),
                          AppBoldFont(context,msg: "1. Application", fontSize:ResponsiveWidget.isMediumScreen(context)?12: 24),
                          SizedBox(height: SizeConfig.screenHeight * 0.01),
                          Container(
                            padding: EdgeInsets.only(left: 35),
                            child: AppRegularFont(
                                context,maxLines: 6,
                                fontSize: ResponsiveWidget.isMediumScreen(context)?10:20,
                                msg:
                                "This Privacy Policy is applicable to personally identifiable information collected, processed, stored and used in connection with or via an dedicated application of the said URL accessible on Users’ mobile phones / tablets / other devices connected to the internet  operated by  Pictures Networks India Private Limited  having its office at Interface Building , India. This policy is in addition to the Privacy Policy incorporated otherwise on the URL."),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.02),
                          AppBoldFont(context,msg: "2. Services", fontSize: ResponsiveWidget.isMediumScreen(context)?12:24),
                          SizedBox(height: SizeConfig.screenHeight * 0.01),
                          Container(
                            padding: EdgeInsets.only(left: 35),
                            child: AppRegularFont(
                                context,maxLines: 6,
                                fontSize:ResponsiveWidget.isMediumScreen(context)?10: 20,
                                msg:
                                "To facilitate your viewership and access of the content on the Site, the content may have been packaged by SPN differently, wherein the Content or Services may be accessible free of charge which may include advertisements or commercials or via a subscription model or a pay-per-view model with or without advertisements / commercials or with a combination of the foregoing."),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.02),
                          AppBoldFont(context,
                              msg: "3. Types of Information collected", fontSize:ResponsiveWidget.isMediumScreen(context)?12: 24),
                          SizedBox(height: SizeConfig.screenHeight * 0.01),
                          Container(
                            padding: EdgeInsets.only(left: 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppBoldFont(context,
                                    msg: "3.1 Information You Provide", fontSize: ResponsiveWidget.isMediumScreen(context)?10:22),
                                SizedBox(height: 2),
                                AppRegularFont(
                                  context,maxLines: 6,
                                  fontSize:ResponsiveWidget.isMediumScreen(context)?10: 20,
                                  msg:
                                  "In order to use the Site and the services offered, Users must create an account with SPN  Creating the SPN Account may require the User to provide inter alia the following personal information associated with the User, including but not limited to his / her name; gender; residential address, including city / state / province (if applicable), postal code, country, and region; phone and mobile number, e-mail address; preferred language; and login name and password ",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.01),
                          Container(
                            padding: EdgeInsets.only(left: 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppBoldFont(context,
                                    msg: "3.2 Automatic Information Collection",
                                    fontSize: ResponsiveWidget.isMediumScreen(context)?10:22),
                                SizedBox(height: 2),
                                AppRegularFont(
                                    context,maxLines: 6,
                                    fontSize: ResponsiveWidget.isMediumScreen(context)?10:20,
                                    msg:
                                    "SPN may use a variety of technologies that automatically or passively collect information about how the Site is accessed and used  Usage Information may consist inter alia of the following data about your visit to the Site: content viewed, date and time of view, content listed on watch-later-list; followed content; favoured content; access type depending on the model of services described hereinabove, number of website hits, type of computer operating system including the type of internet browser and internet service provider. Usage Information is generally non-identifying in nature, but SPN may associate the same with other information collected and hence treats it as Personal Information."),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.01),
                          Container(
                            padding: EdgeInsets.only(left: 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppBoldFont(context,
                                    msg: "3.3 Cookies and Web Beacons", fontSize: ResponsiveWidget.isMediumScreen(context)?10:22),
                                SizedBox(height: 2),
                                AppRegularFont(
                                    context,maxLines: 6,
                                    fontSize:ResponsiveWidget.isMediumScreen(context)?10:20,
                                    msg:
                                    "SPN may use a variety of technologies that automatically or passively collect information about how the Site is accessed and used  Usage Information may consist inter alia of the following data about your visit to the Site: content viewed, date and time of view, content listed on watch-later-list; followed content; favoured content; access type depending on the model of services described hereinabove, number of website hits, type of computer operating system including the type of internet browser and internet service provider. Usage Information is generally non-identifying in nature, but SPN may associate the same with other information collected and hence treats it as Personal Information."),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.01),
                          AppBoldFont(
                            context,msg:
                            "4.NOTIFICATION OF CHANGES OF THE PRIVACY POLICY",
                            fontSize:ResponsiveWidget.isMediumScreen(context)?12: 24, ),
                          SizedBox(height: SizeConfig.screenHeight * 0.01),
                          Container(
                            padding: EdgeInsets.only(left: 35),
                            child: AppRegularFont(
                                context,maxLines: 6,
                                fontSize:ResponsiveWidget.isMediumScreen(context)?10: 20,
                                msg:
                                "SPN reserves the right, at its sole discretion, to change, modify, add or remove any portion of the Privacy Policy in whole or in part, at any time. Changes to the Privacy Policy will be effective when posted. You agree to review the Privacy Policy periodically to become aware of any changes. The use of the Site after any changes to the Privacy Policy are posted will be considered acceptance of those changes by you and will constitute your agreement to be bound thereby. If you object to any such changes, your sole recourse will be to stop using the Site."),
                          )
                        ],
                      ),
                    ),



                  ])),
              SizedBox(height:ResponsiveWidget.isMediumScreen(context)?40: 70),
              ResponsiveWidget.isMediumScreen(context)?   footerMobile(context):    footerDesktop()
            ],
          ),
        ),
    ),
      );
  }
}