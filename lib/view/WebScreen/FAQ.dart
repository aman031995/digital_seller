
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/DesktopAppBar.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';

import 'dart:html' as html;

import 'package:tycho_streams/view/widgets/app_menu.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
class FAQ extends StatefulWidget {


  FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return
      ChangeNotifierProvider(
          create: (BuildContext context) => homeViewModel,
          child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
      return

      Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(preferredSize: Size.fromHeight( ResponsiveWidget.isMediumScreen(context)?50:80),
           child: DesktopAppBar()
        ),
        drawer: AppMenu(homeViewModel: viewmodel),

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
    );}));
  }
}
Widget dropdown(List<String> txt,BuildContext context) {
  return Container(
    height: SizeConfig.screenHeight * .05,
    width: ResponsiveWidget.isMediumScreen(context)?380:800,
    margin: EdgeInsets.only(bottom: 20,left: 10,right: 10),
    child: DropdownButtonFormField2(
      // buttonStyleData: ButtonStyleData(
      //   height: 50,
      //   width: 160,
      //   padding: const EdgeInsets.only(left: 14, right: 14),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(14),
      //     border: Border.all(
      //       color: Colors.black26,
      //     ),
      //     color: Colors.redAccent,
      //   ),
      //   elevation: 2,
      // ),
      dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.redAccent,
          ),
          ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).cardColor,
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
        style: TextStyle(fontSize:ResponsiveWidget.isMediumScreen(context)?14: 18, color: Theme.of(context).canvasColor.withOpacity(0.8),),
      ),
isExpanded: true,
      items: txt
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: ResponsiveWidget.isMediumScreen(context)?14:18, color:Theme.of(context).canvasColor.withOpacity(0.8),),
        ),
      ))
          .toList(),
      onChanged: (String? value) {
//selectedValue = value.toString();
      },
    ),
  );
}