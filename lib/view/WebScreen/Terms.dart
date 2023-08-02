import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';


@RoutePage()
class Terms extends StatefulWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
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
    // homeViewModel.getAppConfig(context);
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
          return  profilemodel.termsPrivacyModel!=null? GestureDetector(
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
              appBar: homePageTopBar(),
              body: Scaffold(
                key: _scaffoldKey,
                body: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Center(
                        child:  Column(
                            children: <Widget>[
                              SizedBox(height: 10),
                              AppBoldFont(context, msg: '${profilemodel.termsPrivacyModel?[1].pageTitle}',fontSize:ResponsiveWidget.isMediumScreen(context)
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
                                    msg: '${profilemodel.termsPrivacyModel?[1].pageDescription}',
                                    fontSize: ResponsiveWidget.isMediumScreen(context)
                                        ?16:18,
                                  ),
                                ),
                              ),
                              SizedBox(height: ResponsiveWidget.isMediumScreen(context)?300:600),
                              //ResponsiveWidget.isMediumScreen(context)? footerMobile(context):footerDesktop(),

                            ]),
                      ),
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
      backgroundColor: Theme.of(context).cardColor,
      title: Row(children: <Widget>[
        GestureDetector(
            onTap: (){
              GoRouter.of(context).pushNamed(RoutesName.home);
            },
            child: Image.asset(AssetsConstants.icLogo,width: ResponsiveWidget.isMediumScreen(context) ? 35:45, height:ResponsiveWidget.isMediumScreen(context) ? 35: 45)),
        SizedBox(width: SizeConfig.screenWidth*0.04),
        AppBoldFont(context,msg:"Terms and condition",fontSize:ResponsiveWidget.isMediumScreen(context) ? 16: 20, fontWeight: FontWeight.w700),
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
