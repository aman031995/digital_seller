import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/CommonCarousel.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/OnHover.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/TopList.dart';
import 'package:tycho_streams/view/WebScreen/TrendingVideos.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/screens/login_screen.dart';
import 'package:tycho_streams/view/widgets/app_menu.dart';
import 'package:tycho_streams/view/widgets/video_listpage.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
bool isLogin=false;
String name="a";
class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  ProfileViewModel profileViewModel = ProfileViewModel();
  final List<String> genderItems = ['My Acount', 'Logout'];

  HomeViewModel homeViewModel = HomeViewModel();
  TextEditingController? editingController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  void initState() {
    getUserDetail();
    super.initState();
    getUserDetail();
    User();

  }

  getUserDetail() {
    if(isLogin != false){
    profileViewModel.getProfileDetails(context);
  }}


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar:ResponsiveWidget.isMediumScreen(context)? homePageTopBar():null,
      backgroundColor: WHITE_COLOR,
      extendBodyBehindAppBar: true,
      body: ChangeNotifierProvider<ProfileViewModel>(
          create: (BuildContext context) => profileViewModel,
          child: Consumer<ProfileViewModel>(builder: (context, viewmodel, _) {
            return Scaffold(
                key: _scaffoldKey,
                backgroundColor: WHITE_COLOR,
                drawer:ResponsiveWidget.isMediumScreen(context)?AppMenu(homeViewModel: homeViewModel):Container() ,
                body: Stack(
                  children: [

                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                      CommonCarousel(),
                      VideoListPage(),
                        ],
                      ),
                    ),
                    ResponsiveWidget.isMediumScreen(context)?Container()         :

                    Container(
                      height:70,color: Colors.white,
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 40),
                          Image.asset(AssetsConstants.icLogo, height: 40),
                          Expanded(
                              child:
                              SizedBox(width: SizeConfig.screenWidth * .12)),
                          AppBoldFont(
                              msg: 'Home', color: BLACK_COLOR, fontSize: 20),
                          SizedBox(width: SizeConfig.screenWidth * .02),
                          AppBoldFont(
                              msg: 'Upcoming', color: BLACK_COLOR, fontSize: 20),
                          SizedBox(width: SizeConfig.screenWidth * .02),
                          AppBoldFont(
                              msg: 'Contact US',
                              color: BLACK_COLOR,
                              fontSize: 20),
                          Expanded(
                              child:
                              SizedBox(width: SizeConfig.screenWidth * .12)),
                          Image.asset(AssetsConstants.icSearch, height: 40),
                          SizedBox(width: SizeConfig.screenWidth * .02),
                          name=="a"?
                          GestureDetector(
                              onTap: () {
                                   showDialog(
                                    context: context,
                                    barrierDismissible:false,
                                    barrierColor: Colors.black87,
                                    builder: (BuildContext context) {
                                      return SignUp();
                                    });
                              },
                              child:  Image.asset(AssetsConstants.icSignup, height: 40)
                          ): Text(name,style: TextStyle(color: Colors.black,fontSize: 40),),

                          SizedBox(width: SizeConfig.screenWidth * .01),
                          GestureDetector(
                              onTap: () {
                                name=="a"?

                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    barrierColor: Colors.black87,
                                    builder: (BuildContext context) {
                                      return LoginUp();
                                    }):null;

                              },

                              child:   name=="a"? Image.asset(AssetsConstants.icLogin,
                                  height: 40):   Container(
                                width: 120,
                                child: DropdownButtonFormField2(
                                  hint: Image.asset('images/LoginUser.png', height: 40),
                                  buttonDecoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      border:InputBorder.none
                                  ),
                                  isExpanded: true,
                                  buttonHeight: 60,
                                  buttonPadding: EdgeInsets.only(left: 0, right: 0),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  items: genderItems
                                      .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                  )).toList(),
                                  onChanged: (String? value) {
                                    switch(value) {
                                      case 'My Acount' :
                                        break;
                                      case 'Logout' :
                                        logoutButtonPressed();
                                        break;
                                    }     // selectedValue = value.toString();
                                  },
                                ),
                              ),),
                          SizedBox(width: SizeConfig.screenWidth * .02),
                        ],
                      ),
                    ),
                  ],
                ));
          })),
    );
  }

  logoutButtonPressed() async {
    AppDataManager.deleteSavedDetails();
    CacheDataManager.clearCachedData();
   await Future.delayed(const Duration(milliseconds:100)).then((value) =>Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (route) => false));

  }
  User() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name=sharedPreferences.get('name').toString() ?? " ";
    name=="null"? name="a":name;
    print(name);
  }
  homePageTopBar() {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: WHITE_COLOR,
        title: Stack(children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 25.0, bottom: 25.0),
              child: Row(children: [
                GestureDetector(
                    onTap: () {
                      if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                        _scaffoldKey.currentState?.openDrawer();
                      } else {
                        _scaffoldKey.currentState?.openEndDrawer();
                      }
                    },
                    child: Image.asset(AssetsConstants.icLogo,
                        height: 50, width: 50)),
                  Expanded(child: SizedBox(width: SizeConfig.screenWidth*0.10)),
                Container(
                    height: 50,
                    width: SizeConfig.screenWidth * 0.64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: TRANSPARENT_COLOR, width: 2.0),
                    ),
                    child: new TextField(
                      maxLines: editingController!.text.length > 2 ? 2 : 1,
                      controller: editingController,
                      decoration: new InputDecoration(
                          hintText: StringConstant.search,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintStyle: TextStyle(color: GREY_COLOR)),
                      onChanged: (m) {},
                    )),
                  Expanded(child: SizedBox(width: SizeConfig.screenWidth*0.13)),
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: LIGHT_THEME_COLOR,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.asset(
                      AssetsConstants.icNotification,
                      height: 45,
                      width: 45,
                    ))
              ]))
        ]));
  }
}
// class Pref{
// Future remove(String Msg)  async{
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   sharedPreferences.remove(Msg);
// }
// }

