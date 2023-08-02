import 'package:TychoStream/model/data/AppConfigModel.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/WebScreen/CommonCarousel.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/widgets/search_view.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import '../../AppRouter.gr.dart';
import '../../main.dart';
import '../MobileScreen/menu/app_menu.dart';


class HomePageMobile extends StatefulWidget {
  const HomePageMobile({Key? key}) : super(key: key);
  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  HomeViewModel homeViewModel = HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  ProfileViewModel profileViewModel = ProfileViewModel();
  String? checkInternet;

  void initState() {
    homeViewModel.getAppConfig(context);
    User();
    profileViewModel.getUserDetails(context);
    super.initState();

  }

  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    names = sharedPreferences.get('name').toString();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });
    return checkInternet == "Offline"
        ? NOInternetScreen()
        : ChangeNotifierProvider.value(
        value: profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
          return ChangeNotifierProvider.value(
              value: homeViewModel,
              child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
                return
                  GestureDetector(
                    onTap: (){
                      if(isSearch==true){
                        isSearch=false;
                        searchController?.clear();
                      }
                      if(isLogins == true){
                        isLogins=false;
                      }
                    },
                    child: Scaffold(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      appBar: homePageTopBar(),

                      body: Scaffold(
                          key: _scaffoldKey,
                          backgroundColor: Theme.of(context).backgroundColor,
                          drawer: AppMenu(),
                          body: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonCarousel(),
                                    //VideoListPage()
                                  ],
                                ),
                              ),
                              isLogins == true
                                  ? profile(context, setState,profilemodel)
                                  : Container(),

                              isSearch==true?
                              searchList(context, viewmodel, scrollController,homeViewModel, searchController!)
                                  : Container()

                            ],
                          )),
                    ),
                  );}
              )
          );}));
  }

  // method for handling bottom nav clicks
  getPages(BottomNavigation navItem) {
    Uri url = Uri.parse(navItem.url ?? '');
    if(url.path == RoutesName.homepageweb){
      return reloadPage();
    }  else if (url.path == RoutesName.productPage){
      return context.router.push(ProductListGallery());
    }
    else if(url.path==RoutesName.profilePage){
      context.pushRoute(EditProfile(
          isEmailVerified: '${profileViewModel.userInfoModel?.isPhoneVerified}',
          isPhoneVerified: '${profileViewModel.userInfoModel?.isEmailVerified}'
      ));
    }
  }

  homePageTopBar() {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme
            .of(context)
            .cardColor,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () async{
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    if (sharedPreferences.get('token') != null){
                      if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                        _scaffoldKey.currentState?.openDrawer();
                      } else {
                        _scaffoldKey.currentState?.openEndDrawer();
                      }
                    }
                    else{
                      ToastMessage.message("please Login");
                    }
                  },
                  child: Container(
                      height: 35,
                      width: 35,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xff001726),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Icon(Icons.menu_outlined))),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  if(isSearch==true){
                    isSearch=false;
                    searchController?.clear();
                  }
                  if( isLogins == true){
                    isLogins=false;
                    setState(() {

                    });
                  }
                  context.pushRoute(ProductListGallery());
                },
                child: Container(height: 30,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,width: 1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: appTextButton(
                      context,
                      'ProductList',
                      Alignment.center,
                      Theme
                          .of(context)
                          .canvasColor,
                      14,
                      true),
                ),
              ),
              SizedBox(width: 5),
              GestureDetector(
                  onTap: () {
                    context.pushRoute(SearchPage());
                    // GoRouter.of(context).pushNamed(RoutesName.SearchPage);
                  },
                  child: Icon(Icons.search_sharp,size: 30)
              ),
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
                          .primaryColor.withOpacity(0.4)),
                      fixedSize:
                      MaterialStateProperty.all(
                          Size.fromHeight(30)),
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
                          14,
                          true),
                    ],
                  ))
                  :
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLogins = true;
                    if (isSearch == true) {
                      isSearch = false;
                      searchController?.clear();
                    }
                  });
                },
                child: Image.asset(
                  AssetsConstants.icProfile,
                  height: 30,
                  color: Theme
                      .of(context)
                      .canvasColor,
                ),
              ),
            ]));
  }
}
