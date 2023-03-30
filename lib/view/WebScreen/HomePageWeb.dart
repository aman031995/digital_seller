import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/model/data/app_menu_model.dart';
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
  final _key = GlobalKey<ScaffoldState>();

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
    getMenu();
  }
  getMenu() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.get('oldMenuVersion') == sharedPreferences.get('newMenuVersion')){
      homeViewModel.getAppMenuData(context);
    } else {
      homeViewModel.getAppMenu(context);
    }
  }

  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    names = sharedPreferences.get('name').toString();
    image=sharedPreferences.get('profileImg').toString();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // final isSmallScreen = MediaQuery.of(context).size.width < 1200;
    // final authVM = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          final menuItem = viewmodel.appMenuModel;
          return viewmodel != null
              ? GestureDetector(
            onTap: () {
              names == "null"
                  ? showDialog(
                  context: context,
                  barrierColor: Colors.black87,
                  builder: (BuildContext context) {
                    return const LoginUp();
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
              key: _key,
              appBar: ResponsiveWidget.isMediumScreen(context)
                  ? homePageTopBar()
                  :  PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Header(context,setState)),
              drawer: Drawer(
                width: SizeConfig.screenWidth/2,
                  backgroundColor: Theme.of(context).cardColor,
                  child: viewmodel.appMenuModel != null
                      ? Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          alignment: Alignment.centerLeft,
                          child: Image.asset(AssetsConstants.icLogo, height: 45, width: 45, alignment: Alignment.topLeft,)),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          color: Theme.of(context).cardColor,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: menuItem?.appMenu?.length,
                              itemBuilder: (context, index) {
                                final appMenuItem = menuItem?.appMenu?[index];
                                return InkWell(
                                    onTap: () {
                                      onItemSelection(context, appMenuItem);
                                    },
                                    child: Column(
                                        children: [
                                          appMenuItem!.childNodes!.isNotEmpty ?
                                          Theme(
                                            data: Theme.of(context).copyWith(dividerColor: Theme.of(context).canvasColor.withOpacity(0.2)),
                                            child: ExpansionTile(
                                              // tilePadding: EdgeInsets.only(left: 18, right: 15),
                                                leading: Image.network(appMenuItem.icon ?? '', color: Theme.of(context).canvasColor, height: 20, width: 20),
                                                title: Transform(
                                                    transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                                    child: Text(appMenuItem.title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
                                                iconColor: Theme.of(context).primaryColor,
                                                collapsedIconColor: Theme.of(context).canvasColor,
                                                children: [
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: appMenuItem.childNodes?.length,
                                                      physics: BouncingScrollPhysics(),
                                                      itemBuilder: (BuildContext? context, int index1) {
                                                        return appMenuItem.childNodes![index1].childNodes!.isNotEmpty  ?
                                                        ExpansionTile(
                                                            leading: Image.network(appMenuItem.childNodes?[index1].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                            title: Transform(
                                                                transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                                                child: Text(appMenuItem.childNodes?[index1].title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
                                                            iconColor: Theme.of(context).primaryColor,
                                                            collapsedIconColor: Theme.of(context).canvasColor,
                                                            children: [
                                                              ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: BouncingScrollPhysics(),
                                                                  itemCount: appMenuItem.childNodes?[index1].childNodes?.length,
                                                                  itemBuilder: (BuildContext? context, int index2) {
                                                                    return appMenuItem.childNodes![index1].childNodes![index2].childNodes!.isNotEmpty ? ExpansionTile(
                                                                        leading: Image.network(appMenuItem.childNodes?[index1].childNodes![index2].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                                        title: Transform(
                                                                            transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                                                            child: Text(appMenuItem.childNodes?[index1].childNodes![index2].title ?? '', style: TextStyle(color: Theme.of(context).canvasColor))),
                                                                        iconColor: Theme.of(context).primaryColor,
                                                                        collapsedIconColor: Theme.of(context).canvasColor,
                                                                        children: [
                                                                          ListView.builder(
                                                                              shrinkWrap: true,
                                                                              physics: BouncingScrollPhysics(),
                                                                              itemCount: appMenuItem.childNodes?[index1].childNodes![index2].childNodes?.length,
                                                                              itemBuilder: (BuildContext? context, int index3) {
                                                                                return ListTile(
                                                                                  leading: Image.network(appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                                                  title: Text(appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                                                  minLeadingWidth : 2,
                                                                                  onTap: () {
                                                                                    onItemSelection(context, appMenuItem.childNodes?[index1].childNodes?[index2].childNodes?[index3]);
                                                                                  },
                                                                                );
                                                                              }),
                                                                        ]) :
                                                                    ListTile(
                                                                      leading: Image.network(appMenuItem.childNodes?[index1].childNodes?[index2].icon ?? '', color: Theme.of(context!).canvasColor, height: 20, width: 20),
                                                                      title: Text(appMenuItem.childNodes?[index1].childNodes?[index2].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                                      minLeadingWidth : 2,
                                                                      onTap: () {
                                                                        onItemSelection(context, appMenuItem.childNodes?[index1].childNodes?[index2]);
                                                                      },
                                                                    );
                                                                  }),
                                                            ]) :
                                                        ListTile(
                                                            leading: Image.network(appMenuItem.childNodes?[index1].icon ?? '', color: Theme.of(context!).canvasColor,  height: 20, width: 20),
                                                            title: Text(appMenuItem.childNodes?[index1].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                            minLeadingWidth : 2,
                                                            onTap: () {
                                                              onItemSelection(context, appMenuItem.childNodes?[index1]);
                                                            });
                                                      }),
                                                ]),
                                          ) :
                                          ListTile(
                                              leading: Image.network(appMenuItem.icon ?? '', color: Theme.of(context).canvasColor, height: 20, width: 20),
                                              title: Text(appMenuItem.title ?? '', style: TextStyle(color: Theme.of(context).canvasColor)),
                                              minLeadingWidth : 2,
                                              onTap: () {
                                                onItemSelection(context, appMenuItem);
                                              })
                                        ]
                                    ));
                              })),
                    ],
                  )
                      : Center(
                      child: CircularProgressIndicator(color: Theme.of(context).primaryColor))),
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
  void onItemSelection(BuildContext context, Menu? appMenu) {
    if(appMenu != null){
      if (appMenu.title?.contains('Share') == true) {
        Share.share(appMenu.url ?? '');
      } else if (appMenu.url?.contains('push_notification') == true) {

      } else if (appMenu.url?.contains('terms-and-conditions') == true) {
         GoRouter.of(context).pushNamed(RoutesName.Terms);

      } else if (appMenu.url?.contains('privacy-policy') == true) {
        GoRouter.of(context).pushNamed(RoutesName.Privacy);
      } else if (appMenu.url?.contains('profile') == true) {
        GoRouter.of(context).pushNamed(RoutesName.EditProfille);
        // getPath(appMenu.url ?? '', RoutesName.profilePage).then((routePath) {
        //   if (routePath != null) {
        // Router.neglect(context, () => GoRouter.of(context).pushNamed(RoutesName.EditProfille));
        //     Navigator.pushNamed(context, routePath, arguments: {'title': appMenu.title, 'isBack' : true});
        //   }
        // });
      } else if (appMenu.url?.contains('bottom_navigation') == true){
     GoRouter.of(context).pushNamed(RoutesName.home);

      } else if (appMenu.url?.contains('update_user') == true){
      GoRouter.of(context).pushNamed(RoutesName.EditProfille);

      } else if (appMenu.url?.contains('faqs') == true){
         GoRouter.of(context).pushNamed(RoutesName.FAQ);

      } else if (appMenu.url?.contains('notify_setting') == true){

      }
      else if(appMenu.url?.contains('contact_us')==true){
        GoRouter.of(context).pushNamed(RoutesName.ContactUs);

      }
    }
  }
  homePageTopBar() {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme
            .of(context).cardColor,
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
               ? showDialog(context: context, barrierColor: Colors.black87, builder: (BuildContext context) {return const LoginUp();}):

                 _key.currentState?.isDrawerOpen == false?
                        _key.currentState?.openDrawer()
                     :
                        _key.currentState?.openEndDrawer() ;

                    },
                    child: _key.currentState?.isDrawerOpen == false ? Image.asset(
                      'images/ic_menu.png',
                      height: 25,
                      width: 25,
                    ): Image.asset(
                      AssetsConstants.icLogo,
                      height: 25,
                      width: 25,
                    )),
                Container(
                    height: 45,
                    width: SizeConfig.screenWidth * 0.50,
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
                    ?
                OutlinedButton(
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

                        overlayColor: MaterialStateColor
                            .resolveWith((states) =>
                        Theme
                            .of(context)
                            .primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(
                            Size.fromHeight(35)),
                        side: MaterialStateProperty.all(BorderSide(
                            color: Theme.of(context).canvasColor,

                            width: 1,
                            style: BorderStyle.solid),
                        )
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                            AssetsConstants.icProfile,
                            width: 20,
                            height: 20, color: Theme.of(context).canvasColor),
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
                appTextButton(
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
                  child:  Image.asset(
                    AssetsConstants.icProfile,
                    height: 20,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
                SizedBox(
                    width: SizeConfig.screenWidth * .02),
                GestureDetector(
                  onTap: () {
                  },
                  child:  Image.asset(
                    "images/ic_dots.png",
                    height: 20,
                    color: Theme.of(context).canvasColor,
                  ),
                ),

                SizedBox(
                    width: SizeConfig.screenWidth * .02),
              ]))
        ]));
  }
}
