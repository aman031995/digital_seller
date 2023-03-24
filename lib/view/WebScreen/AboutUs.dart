import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/main.dart';
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

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
    final authVM = Provider.of<AuthViewModel>(context);
    return

      ChangeNotifierProvider(
          create: (BuildContext context) => homeViewModel,
          child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
      return
      GestureDetector(
        onTap: (){
          if (isSearch == true)  {
            isSearch = false;
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
                            RoutesName.ContactUsPage,
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
                          if (isSearch == true)  {
                            isSearch = false;
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
          drawer: AppMenu(homeViewModel: viewmodel),
          body:  Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: Column(children: [
                    Container(width: MediaQuery.of(context).size.width,
                      height:MediaQuery.of(context).size.height/4,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset.centerLeft,
                            end: FractionalOffset.centerRight,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.2),
                            ],
                          ),
                          color: Colors.black),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AssetsConstants.icLogo,
                            width: ResponsiveWidget.isMediumScreen(context)
                                ? MediaQuery.of(context).size.width/4
                                : MediaQuery.of(context).size.width/4,
                            height: ResponsiveWidget.isMediumScreen(context)
                                ?  MediaQuery.of(context).size.height/10
                                :  MediaQuery.of(context).size.height/10,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                          Text("Tycho Stream Website",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),)
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02),
                    Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBoldFont(
                              context,fontWeight: FontWeight.w600,
                              fontSize:
                                  ResponsiveWidget.isMediumScreen(context) ? 15 : 30,
                              msg: "ORIGINAL. EXCLUSIVE. PREMIUM.",
                              color: Colors.black),
                          SizedBox(height: MediaQuery.of(context).size.height*0.01),
                          AppRegularFont(
                              context,maxLines: 5,
                              fontSize:
                                  ResponsiveWidget.isMediumScreen(context) ? 10 : 20,

                              msg:
                                  "Alifbata, a subsidiary of Balaji Telefilms Limited, is the Group’s foray into the Digital Entertainment space. After conquering television and making a strong mark in films, Balaji Telefilms aims to reach out directly to individual audiences, by providing them with original, exclusive and tailor-made shows, that they can access at their fingertips."),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02),
                          AppBoldFont(
                            context,fontWeight: FontWeight.w600,
                            fontSize:
                                ResponsiveWidget.isMediumScreen(context) ? 15 : 30,
                            msg: "WHAT'S IN STORE? FRESH STORIES. LIKE NEVER BEFORE.",
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.01),
                          AppRegularFont(
                              context,maxLines: 5,
                              fontSize:
                                  ResponsiveWidget.isMediumScreen(context) ? 10 : 20,
                              msg:
                                  "Alifbata offers fresh, original and exclusive stories. Tailored especially for Indians across the globe, the platform hosts premium, high quality shows featuring popular celebrities, acclaimed writers, and award winning directors, making Alifbata a true alternative to mainstream entertainment."),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02),
                          AppBoldFont(
                            context,fontWeight: FontWeight.w600,
                            fontSize:
                                ResponsiveWidget.isMediumScreen(context) ? 15 : 30,

                            msg: "STORIES FOR EVERYONE",
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.01),
                          AppRegularFont(
                              context,maxLines: 5,
                              fontSize:
                                  ResponsiveWidget.isMediumScreen(context) ? 10 : 20,

                              msg:
                                  "With stories from different worlds, in genres ranging from thrillers, mystery and crime to drama, comedy and romance; Alifbata has shows for everyone, from college going youngsters to professionals with families."),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02),
                          AppBoldFont(
                            context,fontWeight: FontWeight.w600,
                            fontSize:
                                ResponsiveWidget.isMediumScreen(context) ? 15 : 30,

                            msg: "REGION NO BAR",
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.01),
                          AppRegularFont(
                              context,maxLines: 5,
                              fontSize:
                                  ResponsiveWidget.isMediumScreen(context) ? 10 : 20,

                              msg:
                                  "Alifbata will host shows in various languages, catering to our regional language speakers, both in India and abroad."),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02),
                          AppBoldFont(
                            context,fontWeight: FontWeight.w600,
                            fontSize:
                                ResponsiveWidget.isMediumScreen(context) ? 15 : 30,

                            msg: "TECHNOLOGY, YOUR ENABLER",
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.01),
                          AppRegularFont(
                              context,maxLines: 5,
                              fontSize:
                                  ResponsiveWidget.isMediumScreen(context) ? 10 : 20,

                              msg:
                                  "Alifbata is a subscription based video on demand (SVOD) service. Available across multiple interfaces ranging from desktops, laptops, tablets, smart-phones to internet-ready television, Alifbata marries state-of-the-art technology with gripping storytelling."),
                        ],
                      ),
                    ),
                    SizedBox(height:ResponsiveWidget.isMediumScreen(context)?40: 70),
                    ResponsiveWidget.isMediumScreen(context)?   footerMobile(context):    footerDesktop()
                  ]),
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
      );}));
  }
}
