import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/CommonCarousel.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/OnHover.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/TopList.dart';
import 'package:tycho_streams/view/WebScreen/TrendingVideos.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/screens/login_screen.dart';
import 'package:tycho_streams/view/widgets/video_listpage.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
bool isLogin=false;
class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  ProfileViewModel profileViewModel = ProfileViewModel();

String name="a";

  @override
  void initState() {
    getUserDetail();
    super.initState();
    getUserDetail();
    User();

  }
  static final data = ['Lion', 'Tiger', 'Shark', 'Snake', 'Bear','Crocodile','Monkey'];
  String initial = data.first.toString();
  String? selectedValue;
  List _isHovering = [false, false, false, false, false];
  getUserDetail() {
    if(isLogin != false){
    profileViewModel.getProfileDetails(context);
  }}
  String dropdownvalue = 'Item 1';
  final List<String> genderItems = [
    'My Acount',
    'Logout'

  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider<ProfileViewModel>(
        create: (BuildContext context) => profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, viewmodel, _) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              body: Stack(
                children: [

                  SingleChildScrollView(
                    child: Column(
                      children: [
                     SizedBox(height: 50),
                    CommonCarousel(),
                    VideoListPage(),
                    footerDesktop()
                      ],
                    ),
                  ),
                  Container(
                    height: 70,color: Colors.white,
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
                              Navigator.pop(context);
                                 showDialog(
                                  context: context,
                                  barrierDismissible: true,
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
                              Navigator.pop(context);
                              name=="a"?

                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
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
        }));
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
}
// class Pref{
// Future remove(String Msg)  async{
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   sharedPreferences.remove(Msg);
// }
// }

