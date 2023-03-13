
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/DesktopAppBar.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';

import 'dart:html' as html;
class FAQ extends StatefulWidget {


  FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(preferredSize: Size.fromHeight( ResponsiveWidget.isMediumScreen(context)?50:80),
           child: DesktopAppBar()
        ),
      body: SingleChildScrollView(
        child:
        Center(
          child: Column(
                            children: [
                              SizedBox(height: SizeConfig.screenHeight * .09),
                              AppBoldFont(
                                context,fontWeight: FontWeight.w700,
                                fontSize: ResponsiveWidget.isMediumScreen(context)? 30:50,
                                msg: "How can we help you ?",
                              ),
                              SizedBox(height: SizeConfig.screenHeight * .04),
                              Container(
                                height: SizeConfig.screenHeight * .05,
                                  width: SizeConfig.screenWidth * .35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  border: Border.all(color:Colors.black)
                                ),
                                child: TextField(

                                  decoration: new InputDecoration(
                                    filled: true,
                                    fillColor:Colors.white,
                                    iconColor:  Colors.black,
                                    contentPadding: EdgeInsets.only(top: 2),
                                    prefixIcon: Icon(Icons.search,color: Colors.black ),
                                    hintText: "Start typing your search...",
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),borderSide: BorderSide.none),
                                  ),
                                  onChanged: null,
                                  onSubmitted: null,
                                ),
                              ),
                              SizedBox(height: SizeConfig.screenHeight * .04),
                              AppBoldFont(
                                context,fontWeight: FontWeight.w600,
                                fontSize:ResponsiveWidget.isMediumScreen(context)?16: 36,
                                msg: "Getting Started",
                              ),
                              SizedBox(height: SizeConfig.screenHeight * .01),
                              AppRegularFont(context,
                                  msg:
                                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                                  fontSize:ResponsiveWidget.isMediumScreen(context)?10: 20),
                              SizedBox(height: SizeConfig.screenHeight * .02),
                              dropdown([
                                'How do i cancel my subscription?',
                                'I found incorrect/outdated in',
                                'I need help with my Food online',
                                "There is a photo/review that ",
                                "The website/app are not working .",
                                "I would like to give feedback.",
                              ],context),
                              dropdown([
                                'How do i cancel my subscription?',
                                'I found incorrect/outdated in',
                                'I need help with my Food online',
                                "There is a photo/review that ",
                                "The website/app are not working .",
                                "I would like to give feedback.",
                              ],context),
                              dropdown([
                                'How do i cancel my subscription?',
                                'I found incorrect/outdated in',
                                'I need help with my Food online',
                                "There is a photo/review that ",
                                "The website/app are not working .",
                                "I would like to give feedback.",
                              ],context),
                              dropdown([
                                'How do i cancel my subscription?',
                                'I found incorrect/outdated in',
                                'I need help with my Food online',
                                "There is a photo/review that ",
                                "The website/app are not working .",
                                "I would like to give feedback.",
                              ],context),
                              dropdown([
                                'How do i cancel my subscription?',
                                'I found incorrect/outdated in',
                                'I need help with my Food online',
                                "There is a photo/review that ",
                                "The website/app are not working .",
                                "I would like to give feedback.",
                              ],context),
                              SizedBox(height:ResponsiveWidget.isMediumScreen(context)?40: 70),
                              ResponsiveWidget.isMediumScreen(context)?   footerMobile(context): footerDesktop()
                            ],
                          ),


            ),
      ),
    );
  }
  // Desktopappbar(){
  //   return Container(
  //     color: Color(0xff00060E),
  //     child:  Row(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(width: SizeConfig.screenWidth*.03),
  //         Image.asset("images/TychoStreamA.png",height: 50),
  //         Container(width: SizeConfig.screenWidth*.02),
  //         TextButton(
  //             onPressed: () {},
  //             style: ButtonStyle(
  //                 overlayColor: MaterialStateColor.resolveWith(
  //                         (states) => Color(0xffA31621))),
  //             child: const Text(
  //               'Home',
  //               style: TextStyle(color:  fontSize: 20),
  //             )),
  //         Container(width: MediaQuery.of(context).size.width*.02),
  //         TextButton(
  //             onPressed: () {},
  //             style: ButtonStyle(
  //                 overlayColor: MaterialStateColor.resolveWith(
  //                         (states) => Color(0xffA31621))),
  //             child: const Text('Episodes',
  //                 style: TextStyle(color:  fontSize: 20))),
  //         Container(width:  MediaQuery.of(context).size.width*.02),
  //         TextButton(
  //             onPressed: () {},
  //             style: ButtonStyle(
  //                 overlayColor: MaterialStateColor.resolveWith(
  //                         (states) => Color(0xffA31621))),
  //             child: const Text('Upcoming',
  //                 style: TextStyle(color:  fontSize: 20))),
  //         Container(width:  MediaQuery.of(context).size.width*.02),
  //         TextButton(
  //             onPressed: () {},
  //             style: ButtonStyle(
  //                 overlayColor: MaterialStateColor.resolveWith(
  //                         (states) => Color(0xffA31621))),
  //             child: const Text('Services',
  //                 style: TextStyle(color:  fontSize: 20))),
  //         Container(width:  MediaQuery.of(context).size.width*.02),
  //         TextButton(
  //             onPressed: () {},
  //             style: ButtonStyle(
  //                 overlayColor: MaterialStateColor.resolveWith(
  //                         (states) => Color(0xffA31621))),
  //             child: const Text('Contact Us',
  //                 style: TextStyle(color:  fontSize: 20))),
  //         Expanded(child: Container(width: MediaQuery.of(context).size.width*.43)),
  //         Container(
  //           height: 40,width:SizeConfig.screenWidth*.19,
  //           child: TextField(
  //             style: TextStyle(color: Colors.white),
  //             decoration: new InputDecoration(
  //
  //               enabledBorder: UnderlineInputBorder(
  //                 borderSide: BorderSide(color:  width: 2),
  //               ),
  //               focusedBorder: UnderlineInputBorder(
  //                 borderSide: BorderSide(color:  width: 2),
  //               ),
  //
  //               iconColor:
  //               contentPadding: EdgeInsets.only(top: 2),
  //               suffixIcon: Icon(Icons.search,color: Colors.white70,size: 24,),
  //               hintText: "Search videos, episodes...",
  //               hintStyle: TextStyle(color: Colors.white70),
  //             ),
  //             onChanged:null,
  //             onSubmitted: null,
  //           ),
  //         ),
  //         Container(width: SizeConfig.screenWidth*.03),   SizedBox(width: 20),
  //         TextButton(
  //             style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
  //             child: Container(
  //               alignment: Alignment.center,
  //               height: 40,
  //               child: getMediumStyleText(
  //                 msg: 'LOGIN',
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w500,
  //                 ),
  //             ),
  //             onPressed: null),
  //         SizedBox(width: 20),
  //         TextButton(
  //             style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xffC10B10))),
  //             child: Container(
  //               alignment: Alignment.center,
  //               height: 40,
  //               child: getMediumStyleText(
  //                   msg: 'SUBSCRIPTION',
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.white),
  //             ),
  //             onPressed: null),
  //         SizedBox(width: SizeConfig.screenWidth*.03),
  //       ],
  //     ),
  //   );
  // }
}
Widget dropdown(List<String> txt,BuildContext context) {
  return Container(
    height: SizeConfig.screenHeight * .08,
    width: ResponsiveWidget.isMediumScreen(context)?380:800,
    margin: EdgeInsets.only(bottom: 20,left: 10,right: 10),
    child: DropdownButtonFormField2(

      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        // isDense: true,
        contentPadding: EdgeInsets.only(bottom: 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      //isExpanded: true,
      hint: Text(
        txt[0],
        style: TextStyle(fontSize:ResponsiveWidget.isMediumScreen(context)?14: 28, color: Colors.black87),
      ),

      items: txt
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: ResponsiveWidget.isMediumScreen(context)?14:18, color: Colors.black87),
        ),
      ))
          .toList(),
      onChanged: (String? value) {
//selectedValue = value.toString();
      },
    ),
  );
}