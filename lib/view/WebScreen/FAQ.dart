
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
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

import 'dart:html' as html;

import 'package:tycho_streams/view/widgets/app_menu.dart';
import 'package:tycho_streams/view/widgets/search_view.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
class FAQ extends StatefulWidget {


  FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  HomeViewModel homeViewModel = HomeViewModel();
  ScrollController _scrollController = ScrollController();
  TextEditingController? searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isSearch = false;
  int pageNum = 1;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  void initState() {
    // homeViewModel.getAppConfigData(context);
    searchController?.addListener(() {
      homeViewModel.getSearchData(
          context, '${searchController?.text}', pageNum);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return
      ChangeNotifierProvider(
          create: (BuildContext context) => homeViewModel,
          child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
      return

      GestureDetector(
        onTap: (){
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: homePageTopBar(),
          body: Scaffold(
    key: _scaffoldKey,
            // drawer: AppMenu(homeViewModel: viewmodel),

            body: GestureDetector(
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
              child:
              Stack(
                children: [
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.screenHeight * .09),
                                          AppBoldFont(
                                            context,fontWeight: FontWeight.w700,
                                            fontSize: ResponsiveWidget.isMediumScreen(context)? 18:22,
                                            msg: "How can we help you ?",
                                          ),
                                          SizedBox(height: SizeConfig.screenHeight * .04),
                                          Container(
                                            height: SizeConfig.screenHeight * .05,
                                              width: ResponsiveWidget.isMediumScreen(context)?250 :SizeConfig.screenWidth * .35,
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
                                          SizedBox(height:ResponsiveWidget.isMediumScreen(context)? 15:SizeConfig.screenHeight * .04),
                                          AppBoldFont(
                                            context,fontWeight: FontWeight.w600,
                                            fontSize:ResponsiveWidget.isMediumScreen(context)?16: 22,
                                            msg: "Getting Started",
                                          ),
                                          SizedBox(height: SizeConfig.screenHeight * .01),
                                          AppRegularFont(context,textAlign: TextAlign.center,
                                              msg:
                                                  "Lorem Ipsum is simply dummy text of the printing and type setting industry.",
                                              fontSize:ResponsiveWidget.isMediumScreen(context)?14: 18),
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
                                       //   ResponsiveWidget.isMediumScreen(context)?   footerMobile(context): footerDesktop()
                                        ],
                                      ),


                        ),
                  ),
                  isLogins == true
                      ? profile(context, setState)
                      : Container(),
                  if (homeViewModel.searchDataModel != null)
                    searchView(context, homeViewModel, isSearch, _scrollController, homeViewModel, searchController!, setState)
                ],

          ),
            ),
    ),
        ),
      );}));
  }


  homePageTopBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).cardColor,
      title: Row(children: <Widget>[
        GestureDetector(
            onTap: (){
              GoRouter.of(context).pushNamed(RoutesName.home);
            },
            child: Image.asset(AssetsConstants.icLogo,width: ResponsiveWidget.isMediumScreen(context) ? 35:45, height:ResponsiveWidget.isMediumScreen(context) ? 35: 45)),
        SizedBox(width: SizeConfig.screenWidth*0.04),
        AppBoldFont(context,msg:"FAQ",fontSize:ResponsiveWidget.isMediumScreen(context) ? 16: 20, fontWeight: FontWeight.w700),
      ]),
      actions: [
        GestureDetector(
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
          child: Row(
            children: [
              appTextButton(context, names!, Alignment.center, Theme.of(context).canvasColor,ResponsiveWidget.isMediumScreen(context)
                  ?16: 18, true),
              Image.asset(
                AssetsConstants.icProfile,
                height:ResponsiveWidget.isMediumScreen(context)
                    ?20: 30,
                color: Theme.of(context).canvasColor,
              ),
            ],
          ),
        ),
        SizedBox(width: SizeConfig.screenWidth*0.04),
      ],
    );
  }
}
Widget dropdown(List<String> txt,BuildContext context) {
  return Container(
    height: SizeConfig.screenHeight * .05,
    width: ResponsiveWidget.isMediumScreen(context)?350:700,
    margin: EdgeInsets.only(bottom: 20,left: 10,right: 10),
    child: DropdownButtonFormField2(
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