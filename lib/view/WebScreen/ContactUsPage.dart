import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:  ResponsiveWidget.isMediumScreen(context)?null:  PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          height:70,color: Theme.of(context).primaryColor,
          padding: EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 40),
              Image.asset(AssetsConstants.icLogo, height: 40),
              Expanded(
                  child:
                  SizedBox(width: SizeConfig.screenWidth * .12)),
              GestureDetector(
                child: AppBoldFont(
                    context,msg: 'Home', color: BLACK_COLOR, fontSize: 20),
                onTap: (){
                  GoRouter.of(context).pushNamed(RoutesName.home);
                },
              ),
              SizedBox(width: SizeConfig.screenWidth * .02),
              AppBoldFont(
                  context,msg: 'Upcoming', color: BLACK_COLOR, fontSize: 20),
              SizedBox(width: SizeConfig.screenWidth * .02),
              GestureDetector(
                child: AppBoldFont(
                    context, msg: 'Contact US',
                    color: BLACK_COLOR,
                    fontSize: 20),
                onTap: (){
                  GoRouter.of(context).pushNamed(RoutesName.ContactUsPage);
                },
              ),
              Expanded(
                  child:
                  SizedBox(width: SizeConfig.screenWidth * .12)),
              Image.asset(AssetsConstants.icSearch, height: 40),
              SizedBox(width: SizeConfig.screenWidth * .08),

            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
                alignment: Alignment.center,
                child: Text('About', style: TextStyle(fontWeight: FontWeight.w600, fontSize: ResponsiveWidget.isMediumScreen(context)?20:42, color: Colors.black),)),
            SizedBox(height: 20),
            Padding(
              padding:  EdgeInsets.only(left: 30,right: 30),
              child: Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularized in the 1960s with the release of Letterset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: ResponsiveWidget.isMediumScreen(context)?14:22, color: Colors.black)),
            ),
            SizedBox(height: 15,),
            Padding(
              padding:  EdgeInsets.only(left: 30,right: 30),
              child: Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularized in the 1960s with the release of Letterset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: ResponsiveWidget.isMediumScreen(context)?14:22, color: Colors.black)),
            ),
            SizedBox(height: 20,),
            Padding(
              padding:  EdgeInsets.only(left: 30,right: 30),
              child: contactUswidget('images/ContactUs1.png', 'A-102, Sec-62, Noida UP 201301'),
            ),
            SizedBox(height: 10),
            Padding(
              padding:  EdgeInsets.only(left: 30,right: 30),
              child: contactUswidget('images/ContactUs.png', 'www.alifbaata.com'),
            ),
            SizedBox(height: 300),
            ResponsiveWidget.isMediumScreen(context)?   footerMobile(context): footerDesktop()
          ],
        ),
      ),
    );
  }
  Widget contactUswidget(var img, String txt){
    return Row(
      children: [
        Image.asset(img, width: 28,height: 44,color:Colors.black),
        SizedBox(width: 10,),
        Text(txt, style: TextStyle(fontWeight: FontWeight.w400, fontSize:ResponsiveWidget.isMediumScreen(context)? 18:38, color:Colors.black)),
      ],
    );
  }
}
