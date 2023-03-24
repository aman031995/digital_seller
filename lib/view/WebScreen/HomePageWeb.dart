import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/WebScreen/CommonCarousel.dart';
import 'package:tycho_streams/view/WebScreen/EditProfile.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/widgets/search_view.dart';
import 'package:tycho_streams/view/widgets/video_listpage.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

import '../../main.dart';
import '../widgets/app_menu.dart';
class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  // final _controller = SidebarXController(selectedIndex: 0);
  HomeViewModel homeViewModel = HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  ScrollController _scrollController = ScrollController();
  int pageNum = 1;

  void initState() {
    homeViewModel.getAppConfigData(context);
    searchController?.addListener(() {
      homeViewModel.getSearchData(
          context, '${searchController?.text}', pageNum);
    });
    User();
    super.initState();
  }

  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    names = sharedPreferences.get('name').toString();
    image=sharedPreferences.get('profileImg').toString();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return viewmodel != null
              ? GestureDetector(
            onTap: () {
              names == "null"
                  ? showDialog(
                  context: context,
                  barrierColor: Colors.black87,
                  builder: (BuildContext context) {
                    return const SignUp();
                  })
                  : null;
              if (isSearch == true) {
                isSearch = false;
                setState(() {});
              }
              if (isLogins == true) {
                isLogins = false;
                setState(() {});
              }
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: ResponsiveWidget.isMediumScreen(context)
                  ? homePageTopBar()
                  :  PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Header(context,setState)),
              body: Scaffold(

                  key: _scaffoldKey,
                  drawer: ResponsiveWidget.isMediumScreen(context)
                      ?AppMenu(homeViewModel: viewmodel)
                      :AppMenu(homeViewModel: viewmodel),
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
                          ? profile(context, setState)
                          : Container(),
                      if (viewmodel.searchDataModel != null)
                        searchView(
                            context,
                            viewmodel,
                            isSearch,
                            _scrollController,
                            homeViewModel,
                            searchController!,
                            setState)
                    ],
                  )),
            ),
          )
              : Container(
              height: SizeConfig.screenHeight * 1.5,
              child: Center(
                child:
                ThreeArchedCircle( size: 45.0),
              ) );
        }));
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
                          borderRadius: BorderRadius.circular(5)
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
                    //   CachedNetworkImage(
                    //     placeholder: (context, url) => const CircularProgressIndicator(),
                    //     imageUrl: image!,
                    //     height: 30,
                    //   )
                    ],
                  ),
                ),
              ]))
        ]));
  }
}
