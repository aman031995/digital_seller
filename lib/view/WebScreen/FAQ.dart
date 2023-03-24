
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
    homeViewModel.getAppConfigData(context);
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
          appBar:
          ResponsiveWidget.isMediumScreen(context)
              ? homePageTopBar()
              :
          PreferredSize(preferredSize: Size.fromHeight( 60),
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
          body: Scaffold(
    key: _scaffoldKey,
            drawer: AppMenu(homeViewModel: viewmodel),

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
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        title: Stack(children: <Widget>[
          Container(
              child: Row(children: [
                GestureDetector(
                    onTap: () {
                      names == "null"
                          ? showDialog(context: context, barrierColor: Colors.black87, builder: (BuildContext context) {return const SignUp();}):

                      _scaffoldKey.currentState?.isDrawerOpen == false?
                      _scaffoldKey.currentState?.openDrawer()
                          :
                      _scaffoldKey.currentState?.openEndDrawer();

                    },
                    child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Color(0xff001726),
                        ),
                        child: Image.asset(
                          'images/ic_menu.png',
                          height: 25,
                          width: 25,
                        ))),
                Container(
                    height: 45,
                    width: SizeConfig.screenWidth * 0.58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: TRANSPARENT_COLOR, width: 1.0),
                    ),
                    child: AppTextField(
                        controller: searchController,
                        maxLine: searchController!.text.length > 2 ? 2 : 1,
                        textCapitalization: TextCapitalization.words,
                        secureText: false,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        maxLength: 30,
                        labelText: 'Search videos, shorts, products',
                        keyBoardType: TextInputType.text,
                        onChanged: (m) {
                          isSearch = true;
                        },
                        isTick: null)),
                names == "null"
                    ? ElevatedButton(onPressed: (){
                  showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder:
                          (BuildContext context) {
                        return const SignUp();
                      });

                }, child:Text(
                  "Sign Up",style: TextStyle(
                    color: Theme.of(context).canvasColor,fontSize: 16,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily
                ),
                ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).cardColor),
                        overlayColor: MaterialStateColor
                            .resolveWith((states) =>
                        Theme.of(context).primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(Size(90, 35)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    5.0
                                )))
                    ))
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
                  child: Row(
                    children: [
                      SizedBox(width: SizeConfig.screenWidth*0.1),
                      Image.asset(
                        'images/LoginUser.png',
                        height: 30,
                        color:
                        Theme
                            .of(context)
                            .canvasColor,
                      ),
                    ],
                  ),
                ),
              ]))
        ]));
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