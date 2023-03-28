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
import 'package:tycho_streams/utilities/three_arched_circle.dart';
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
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
class Privacy extends StatefulWidget {
   Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  HomeViewModel homeViewModel = HomeViewModel();
  ScrollController _scrollController = ScrollController();
  ScrollController scrollController = ScrollController();
  bool isSearch = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final ProfileViewModel profileViewModel = ProfileViewModel();
  int pageNum = 1;
  @override
  void initState() {
    profileViewModel.getTermsPrivacy(context);
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
              ChangeNotifierProvider<ProfileViewModel>(
                  create: (BuildContext context) => profileViewModel,
                  child: Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
                    return    profilemodel.termsPrivacyModel!=null? GestureDetector(
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


                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        appBar:  ResponsiveWidget.isMediumScreen(context)
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
                                      AssetsConstants.icProfile,
                                      height: 30,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.screenWidth * .02),
                                ],
                              ),
                            )),
                        body:


                        Scaffold(
                          key: _scaffoldKey,
                          drawer: AppMenu(homeViewModel: viewmodel),
                          body: SingleChildScrollView(
                            child: Stack(
                              children: [
                                Center(
                                  child:  Column(
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        AppBoldFont(context, msg: '${profilemodel.termsPrivacyModel?[0].pageTitle}',fontSize:ResponsiveWidget.isMediumScreen(context)
                                            ? 18:20),
                                        SizedBox(height: 10),
                                        SingleChildScrollView(
                                          child: Container(
                                            width: ResponsiveWidget.isMediumScreen(context)
                                                ? SizeConfig.screenWidth/1.2   :SizeConfig.screenWidth/2.2,
                                            margin: const EdgeInsets.only(
                                                left: 25, right: 25, top: 15, bottom: 10),
                                            child: AppRegularFont(
                                              context,
                                              msg: '${profilemodel.termsPrivacyModel?[0].pageDescription}',
                                              fontSize: ResponsiveWidget.isMediumScreen(context)
                                                  ?16:18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: ResponsiveWidget.isMediumScreen(context)?300:600),
                                       // ResponsiveWidget.isMediumScreen(context)? footerMobile(context):footerDesktop(),

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
                        ),
                      ),
                    ):
                    Container(
                        height: SizeConfig.screenHeight * 1.5,
                        child: Center(
                          child:
                          ThreeArchedCircle( size: 45.0),
                        ) );



                  }));}));
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
                            borderRadius: BorderRadius.circular(2)
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
