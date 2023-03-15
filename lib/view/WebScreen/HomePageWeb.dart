import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
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
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/CommonCarousel.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/widgets/video_listpage.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
import 'package:universal_html/html.dart' as html;
bool isLogin=false;
String name="a";
class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  final List<String> genderItems = ['My Acount', 'Logout'];
  HomeViewModel homeViewModel = HomeViewModel();
  TextEditingController? editingController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  void initState() {
    homeViewModel.getAppConfigData(context);


    super.initState();
  }


  Future<bool> _willPopScopeCall() async {
// code to show toast or modal
    return true; // return true to exit app or return false to cancel exit
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return   WillPopScope( onWillPop:_willPopScopeCall,
    child:ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:ResponsiveWidget.isMediumScreen(context)? AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color:Colors.black,  size: 28),
        title:  Image.asset(AssetsConstants.icLogo,height: 50,),
        actions: [
          Container(
              height: 15,
              width:SizeConfig.screenWidth/1.8,
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


          SizedBox(width: 15)
        ]):
      PreferredSize(child: Container(
        height:70,color: Theme.of(context).primaryColor,
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
                context,msg: 'Home', fontSize: 20),
            SizedBox(width: SizeConfig.screenWidth * .02),
            AppBoldFont(
                context,msg: 'Upcoming', fontSize: 20),
            SizedBox(width: SizeConfig.screenWidth * .02),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/contactUs');
              },
              child: AppBoldFont(
                  context,msg: 'Contact US',
                  fontSize: 20),
            ),
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
            ): AppBoldFont(
                context,msg: name, fontSize: 40),

            //Text(name,style: TextStyle(color:  fontSize: 40),),

            name=="a"? SizedBox(width: SizeConfig.screenWidth * .01):SizedBox(),
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
                  hint: Image.asset('images/LoginUser.png', height: 40,color:Theme.of(context).accentColor,),
iconStyleData: IconStyleData(
  iconDisabledColor: Colors.transparent,
  iconEnabledColor: Colors.transparent

),
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border:InputBorder.none
                  ),
                  isExpanded: true,
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
                        authVM.logoutButtonPressed(context);
                        name="a";
                        setState(() {
                          
                        });
                        break;
                    }     // selectedValue = value.toString();
                  },
                ),
              ),),
            SizedBox(width: SizeConfig.screenWidth * .02),
          ],
        ),
      ), preferredSize: Size.fromHeight(80)),
        key: _scaffoldKey,
      drawer:ResponsiveWidget.isMediumScreen(context)?MobileMenu(context):Container() ,
      body:  Stack(
            children: [

              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                CommonCarousel(),
                VideoListPage(),
                    // name=="a"?  ResponsiveWidget.isMediumScreen(context)?   Container(
                    //   margin:  EdgeInsets.only(top: 120)  ,
                    //     height: 300,child: footerMobile(context)): Container(height:200,child: footerDesktop()): Container()
                  ],
                ),
              ),
             // ResponsiveWidget.isMediumScreen(context)?Container()         :


            ],
          ));})));
  }

  // logoutButtonPressed() async {
  //   AppDataManager.deleteSavedDetails();
  //   CacheDataManager.clearCachedData();
  //   GoRouter.of(context).pushNamed(RoutesName.home);
  // }
  // User() async{
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   name=sharedPreferences.get('name').toString() ?? " ";
  //   name=="null"? name="a":name;
  //   print(name);
  // }
  Widget MobileMenu(BuildContext context){
    final authVM = Provider.of<AuthViewModel>(context);
    return MultiLevelDrawer(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      rippleColor:Theme.of(context).primaryColorDark,
      subMenuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      divisionColor: Theme.of(context).primaryColorLight,
      header: Container(
        height: 150,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  AssetsConstants.icLogo,
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                //  Text("Alif Baata",style: TextStyle(color: Theme.of(context).primaryColorLight))
              ],
            )),
      ),
      children: [
        MLMenuItem(
            trailing: Icon(Icons.arrow_right,color: Theme.of(context).primaryColorLight),
            leading: Icon(Icons.home_filled,color: Theme.of(context).primaryColorLight,),
            content: Text(" Home",style: TextStyle(color: Theme.of(context).primaryColorLight)),
            onClick: (){

            }),
        name=="a"?   MLMenuItem(
            trailing: Icon(Icons.login_sharp,color: Theme.of(context).primaryColorLight),
            leading: Icon(Icons.upcoming_sharp,color: Theme.of(context).primaryColorLight,),

            content: Text(" Login",style: TextStyle(color: Theme.of(context).primaryColorLight)),
            onClick: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  barrierDismissible:false,
                  barrierColor: Colors.black87,
                  builder: (BuildContext context) {
                    return LoginUp();
                  }
              );
            }):MLMenuItem(
          trailing: Icon(Icons.login_outlined,color: Theme.of(context).primaryColorLight),
          leading: Icon(Icons.upcoming_sharp,color: Theme.of(context).primaryColorLight,),

          content: Text("Logout",style: TextStyle(color: Theme.of(context).primaryColorLight)),
          onClick: () {
            authVM.logoutButtonPressed(context);
            name="a";
            setState(() {

            });
          },
        ),

        MLMenuItem(
            leading: Icon(Icons.contacts,color: Theme.of(context).primaryColorLight,),
            trailing: Icon(Icons.arrow_right,color: Theme.of(context).primaryColorLight),
            content:Text(" Contact Us",style: TextStyle(color: Theme.of(context).primaryColorLight)),
            onClick: () {

            }),
      ],
    );
  }

}


