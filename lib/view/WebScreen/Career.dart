import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/DesktopAppBar.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/widgets/app_menu.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
class Career extends StatefulWidget {
  const Career({Key? key}) : super(key: key);

  @override
  State<Career> createState() => _CareerState();
}

class _CareerState extends State<Career> {
  HomeViewModel homeViewModel = HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
      return
        Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(preferredSize: Size.fromHeight( ResponsiveWidget.isMediumScreen(context)? 50:70),
            child: DesktopAppBar()),
        // key: _scaffoldKey,
          drawer: AppMenu(homeViewModel: viewmodel),


          body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height:  ResponsiveWidget.isMediumScreen(context)?  30:70),
              Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                height:  ResponsiveWidget.isMediumScreen(context)? 415 :515,
                width: ResponsiveWidget.isMediumScreen(context)?  SizeConfig.screenWidth/1.15 :SizeConfig.screenWidth * .30,
                decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                        color:Colors.black.withOpacity(
                            0.25), //color of shadow
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 0))
                  ],
                  color: Colors.black
                ),
                child: Column(
                  children: [
                    SizedBox(height: ResponsiveWidget.isMediumScreen(context)? 15:20),
                    AppBoldFont(
                        context,fontWeight: FontWeight.w600,
                        fontSize:ResponsiveWidget.isMediumScreen(context)?15: 30,
                        msg: "Need more help ?",
                        textAlign: TextAlign.center),
                    SizedBox(height: 5),
                    AppRegularFont(context, fontSize:  ResponsiveWidget.isMediumScreen(context)? 13:24,
                        msg: " Please provide your information to help us to connect with you.",
                        textAlign: TextAlign.center
                    ),
                    SizedBox(height:  ResponsiveWidget.isMediumScreen(context)?  20:30),
                    Container(
                      width: ResponsiveWidget.isMediumScreen(context)? SizeConfig.screenWidth/1.18: SizeConfig.screenWidth * .27,
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(

                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:Colors.white,
                              focusedBorder: InputBorder.none,
                              border: OutlineInputBorder(
                                  borderRadius:  BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(color:Colors.black, width: 2 )),
                              labelText: 'Email/Phone',
                              hintStyle: TextStyle(color:Colors.black.withOpacity(0.88)),
                              isDense: true,
                              labelStyle:TextStyle(color: Colors.black.withOpacity(0.88)),
                              //hintText: 'email/Phone',
                            ),
                          ),
                          SizedBox(
                              height: 20),
                          TextField(

                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:  Colors.white,
                                focusedBorder: InputBorder.none,
                                border: OutlineInputBorder(
                                    borderRadius:  BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(color:Colors.black, width: 2 )),
                                hintText: 'Describe',
                                hintStyle: TextStyle(color: Colors.black.withOpacity(0.88)),
                                labelStyle:TextStyle(color: Colors.black.withOpacity(0.88)),
                                labelText: "What is this about?",
                                isDense: true),
                          ),
                          SizedBox(
                              height: SizeConfig.screenHeight * 0.02),
                          AppRegularFont(
                              context,
                              msg: "Describe your issue*"),
                          SizedBox(
                              height: 20),
                          Container(
                            width: ResponsiveWidget.isMediumScreen(context)? SizeConfig.screenWidth/1.18: SizeConfig.screenWidth * .27,
                            height: SizeConfig.screenHeight * 0.12,
                            decoration: BoxDecoration(
                                
                                border: Border.all(
                                    width: 1, color:Colors.white.withOpacity(0.85))),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              appButton(context, "Cancel", ResponsiveWidget.isMediumScreen(context)? SizeConfig.screenWidth * .28:SizeConfig.screenWidth * .11,
                                  ResponsiveWidget.isMediumScreen(context)? SizeConfig.screenHeight * 0.04:40,
                                  Colors.blueAccent,
                                  Theme.of(context).canvasColor,
                                  20,
                                  10, false),
                              appButton(context, "Submit", ResponsiveWidget.isMediumScreen(context)? SizeConfig.screenWidth * .28:SizeConfig.screenWidth * .11,
                                  ResponsiveWidget.isMediumScreen(context)? SizeConfig.screenHeight * 0.04:40,
                                  Colors.blueAccent,
                                  Theme.of(context).canvasColor,
                                  20,
                                  10, false)
                            ],
                          )

                        ],
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 180),
              ResponsiveWidget.isMediumScreen(context)?   footerMobile(context):   footerDesktop(),

            ],
          ),
        ),
    ),
      );}));
  }
}
