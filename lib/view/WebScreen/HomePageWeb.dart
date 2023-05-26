import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/model/data/app_menu_model.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/CommonCarousel.dart';
import 'package:TychoStream/view/WebScreen/EditProfile.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/SignUp.dart';
import 'package:TychoStream/view/widgets/search_view.dart';
import 'package:TychoStream/view/widgets/video_listpage.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';

import '../../main.dart';
import '../widgets/app_menu.dart';

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  HomeViewModel homeViewModel = HomeViewModel();
  final _key = GlobalKey<ScaffoldState>();
  int pageNum = 1;
  int pageNums = 1;
  String? checkInternet;
  void initState() {
    homeViewModel.getAppConfigData(context);
    User();
    profileViewModel.getUserDetails(context);
    super.initState();

  }
  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    names = sharedPreferences.get('name').toString();
    image = sharedPreferences.get('profileImg').toString();
  }
  final ProfileViewModel profileViewModel = ProfileViewModel();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });
    return ChangeNotifierProvider.value(
        value: profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
      return ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return
            checkInternet == "Offline"
                ? NOInternetScreen()
                :viewmodel != null
              ? Scaffold(
                backgroundColor: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                key: _key,
                appBar: ResponsiveWidget.isMediumScreen(context)
                    ? homePageTopBar(viewmodel)
                    : PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: Header(context, setState, viewmodel)),
                body: Scaffold(
                    body: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonCarousel(),
                              VideoListPage()
                            ],
                          ),
                        ),
                        isLogins == true
                            ? profile(context, setState,profilemodel)
                            : Container(),

                      ],
                    )),
              )
              : Container(
              height: SizeConfig.screenHeight * 1.5,
              child: Center(
                child:
                ThreeArchedCircle(size: 45.0),
              ));
        }
        )
      );}));
  }



  homePageTopBar(HomeViewModel viewmodel) {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme
            .of(context)
            .cardColor,
        title: Stack(children: <Widget>[
          Container(
              child: Row(children: [

                OutlinedButton(
                    onPressed: () {

                    },
                    style: ButtonStyle(

                        overlayColor: MaterialStateColor
                            .resolveWith((states) =>
                        Theme
                            .of(context)
                            .primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(
                            Size.fromHeight(35)),
                        side: MaterialStateProperty.all(BorderSide(
                            color: Theme
                                .of(context)
                                .canvasColor,

                            width: 1,
                            style: BorderStyle.solid),
                        )
                    ),
                    child: appTextButton(
                        context,
                        'ProductList',
                        Alignment.center,
                        Theme
                            .of(context)
                            .canvasColor,
                        16,
                        true)),
                Container(
                    height: 40,
                    width: SizeConfig.screenWidth * 0.50,
                    alignment: Alignment.center,
                    child: AppTextField(
                        isColor: true,
                        controller: searchController,
                        //maxLine: searchController!.text.length > 2 ? 2 : 1,
                        textCapitalization: TextCapitalization.words,
                        secureText: false,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        maxLength: 30,
                        labelText: 'Search videos, shorts, products',
                        keyBoardType: TextInputType.text,
                        onChanged: (m) {
                          isSearch = true;
                          if (isNotification == true) {
                            isNotification = false;
                            setState(() {

                            });
                          }
                        },
                        isTick: null)),
                SizedBox(
                    width: SizeConfig.screenWidth * .01),
                names == "null"
                    ?
                OutlinedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierColor: Colors.black87,
                          builder:
                              (BuildContext context) {
                            return LoginUp();
                          });
                    },
                    style: ButtonStyle(

                        overlayColor: MaterialStateColor
                            .resolveWith((states) =>
                        Theme
                            .of(context)
                            .primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(
                            Size.fromHeight(35)),
                        side: MaterialStateProperty.all(BorderSide(
                            color: Theme
                                .of(context)
                                .canvasColor,

                            width: 1,
                            style: BorderStyle.solid),
                        )
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                            AssetsConstants.icProfile,
                            width: 20,
                            height: 20, color: Theme
                            .of(context)
                            .canvasColor),
                        appTextButton(
                            context,
                            'SignIn',
                            Alignment.center,
                            Theme
                                .of(context)
                                .canvasColor,
                            16,
                            true),
                      ],
                    ))
                    :
                Expanded(
                  child: appTextButton(
                      context,
                      names!,
                      Alignment.center,
                      Theme
                          .of(context)
                          .canvasColor,
                      16,
                      true,
                      onPressed: () {
                        setState(() {
                          isLogins = true;
                          if (isSearch == true) {
                            isSearch = false;
                            searchController?.clear();
                            setState(() {});
                          }
                        });
                      }),
                ),
                names == "null"
                    ? Container()
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
                    height: 20,
                    color: Theme
                        .of(context)
                        .canvasColor,
                  ),
                ),
                SizedBox(
                    width: SizeConfig.screenWidth * .02),
              ]))
        ]));
  }
}
