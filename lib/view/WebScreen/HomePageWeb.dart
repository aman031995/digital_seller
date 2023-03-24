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
    homeViewModel.getTrayData(context);
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
    names = sharedPreferences.get('name').toString() ?? " ";
  }

  // @override
  // void dispose() {
  //
  //   searchController?.clear();
  //   super.dispose();
  // }

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
                key: _scaffoldKey,
                drawer: ResponsiveWidget.isMediumScreen(context)
                    ? Container()
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
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(children: [
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
                        child: Image.asset(
                          'images/ic_menu.png',
                          height: 32,
                          width: 32,
                        ))),
                SizedBox(width: 3.0),
                GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(RoutesName.home);
                    },
                    child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Color(0xff001726),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          AssetsConstants.icLogo,
                          height: 50,
                          width: 50,
                        ))),
                Container(
                    height: 55,
                    width: SizeConfig.screenWidth * 0.64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: TRANSPARENT_COLOR, width: 2.0),
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
                SizedBox(width: 3.0),
              ]))
        ]));
  }
}
