import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
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
class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  HomeViewModel homeViewModel = HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
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
  void dispose() {
    _scrollController.dispose();
    searchController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return  ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
      return
        GestureDetector(
          onTap: (){
            if (isSearch == true)  {
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
            appBar:  ResponsiveWidget.isMediumScreen(context)
                ? homePageTopBar()
                :  PreferredSize(preferredSize: Size.fromHeight( 60),
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
                            if (isSearch == true) {
                              isSearch = false;
                              searchController?.clear();
                              setState(() {});
                            }
                            isLogins = true;
                          });
                        },
                        child: Image.asset(
                          AssetsConstants.icProfile,
                          height: 30,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      SizedBox(width: SizeConfig.screenWidth * .02),
                    ],
                  ),
                )),
            drawer: AppMenu(homeViewModel: viewmodel),
            body:  GestureDetector(
              onTap: () {
                if (isSearch == true) {
                  isSearch = false;

                  setState(() {});
                }  if( isLogins == true){
                  isLogins=false;
                  setState(() {

                  });
                }
              },
              child: Stack(
              children: [
                SingleChildScrollView(
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
                        // ResponsiveWidget.isMediumScreen(context)?   footerMobile(context):   footerDesktop(),

                      ],
                    ),
                  ),
                ),
                isLogins == true
                    ? Positioned(
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      height: 90,
                      width: 150,
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          appTextButton(
                              context,
                              "My Account",
                              Alignment.centerLeft,
                              Theme.of(context).canvasColor,
                              18,
                              false, onPressed: () {
                            isProfile = true;
                            if (isProfile == true) {
                              GoRouter.of(context).pushNamed(
                                RoutesName.EditProfille,
                              );
                            }
                            if (isSearch == true) {
                              isSearch = false;
                              searchController?.clear();
                              setState(() {});
                            }
                            setState(() {
                              isLogins = false;
                            });
                          }),
                          SizedBox(height: 5),
                          Container(
                            height: 1,
                            color: Colors.black,
                          ),
                          SizedBox(height: 5),
                          appTextButton(
                              context,
                              "LogOut",
                              Alignment.centerLeft,
                              Theme.of(context).canvasColor,
                              18,
                              false, onPressed: () {
                            setState(() {
                              authVM
                                  .logoutButtonPressed(context);
                              isLogins = false;
                              if (isSearch == true) {
                                isSearch = false;
                                searchController?.clear();
                                setState(() {});
                              }
                            });
                          }),
                        ],
                      ),
                      color: Theme.of(context).cardColor,
                      // height: 20,width: 20,
                    ))
                    : Container(),
                if (homeViewModel.searchDataModel != null)
                  searchView(context, homeViewModel, isSearch, _scrollController, homeViewModel, searchController!, setState)
              ],
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
                        AssetsConstants.icProfile,
                        height: 30,
                        color: Theme.of(context).canvasColor,
                      ),
                    ],
                  ),
                ),
              ]))
        ]));
  }
}
