import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/CommonCarousel.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/view/widgets/video_listpage.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utilities/AssetsConstants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  HomeViewModel homeViewModel = HomeViewModel();

  String? checkInternet;
  ScrollController scrollController = ScrollController();
  int pageNum = 1;
  final ProfileViewModel profileViewModel = ProfileViewModel();
  int pageNums = 1;

  void initState() {
    homeViewModel.getAppConfigData(context);
    // User();
    profileViewModel.getUserDetails(context);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider.value(
        value: homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return Scaffold(
              appBar: PreferredSize(preferredSize: const Size.fromHeight(55),
                  child: homePageTopBar(context)),
              backgroundColor: Theme.of(context).backgroundColor,
              extendBodyBehindAppBar: true,
              body: checkInternet == "Offline"
                  ? NOInternetScreen()
                  : Scaffold(
                      key: _scaffoldKey,
                      backgroundColor: Theme.of(context).backgroundColor,
                      drawer: AppMenu(),
                      body: SingleChildScrollView(
                          child: SafeArea(
                              child: Column(children: [
                                CommonCarousel(),
                                VideoListPage()
                              ])))));
        }));
  }

  homePageTopBar(BuildContext context) {
    return  AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).backgroundColor,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                            _scaffoldKey.currentState?.openDrawer();
                          } else {
                            _scaffoldKey.currentState?.openEndDrawer();
                          }
                        },
                        child: Container(
                            height: 45,
                            width: 45,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xff001726),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Icon(Icons.menu))),
                    GestureDetector(
                      onTap: () {
                      //  AppNavigator.push(context, SearchPage());
                      },
                      child: Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 5),
                          width: SizeConfig.screenWidth * 0.62,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Theme.of(context).canvasColor.withOpacity(0.5), width: 2.0),
                          ),
                          child: AppRegularFont(context, msg: StringConstant.searchItems)),
                    ),
                    GestureDetector(
                        onTap: () {
                        },
                        child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Color(0xff001726),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.asset(
                               AssetsConstants.icNotification,
                              height: 50,
                              width: 50,
                            )))
                  ]));
        }
  }