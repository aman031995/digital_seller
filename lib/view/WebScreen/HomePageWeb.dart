import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/CommonCarousel.dart';
import 'package:tycho_streams/view/WebScreen/EditProfile.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/widgets/video_listpage.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

import '../../main.dart';

bool isLogin = false;
bool isLogins=false;
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
  TextEditingController? searchController = TextEditingController();
  @override
  bool isSearch = false;
  int pageNum = 1;
  void initState() {
    homeViewModel.getAppConfigData(context);
    searchController?.addListener(() {
      homeViewModel.getSearchData(
          context, '${searchController?.text}', pageNum);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: ResponsiveWidget.isMediumScreen(context) ? AppBar(
                      backgroundColor: Theme.of(context).cardColor,
                      iconTheme: const IconThemeData(color: Colors.white, size: 28),
                      title: Image.asset(
                        AssetsConstants.icLogo,
                        height: 50,
                      ),
                      actions: [
                          Container(
                            height: 15,
                            width: SizeConfig.screenWidth / 1.8,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: TRANSPARENT_COLOR, width: 2.0),
                            ),
                            child: AppTextField(
                              controller: searchController,
                              maxLine:
                                  searchController!.text.length > 2 ? 2 : 1,
                              textCapitalization: TextCapitalization.words,
                              secureText: false,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              maxLength: 30,
                              labelText: 'Search videos, shorts, products',
                              keyBoardType: TextInputType.text,
                              onChanged: (m) {
                                isSearch = true;
                              },
                              isTick: null,
                            ),
                          ),
                          const SizedBox(width: 15)
                        ]):null,
              key: _scaffoldKey,
              drawer: ResponsiveWidget.isMediumScreen(context) ? MobileMenu(context) : Container(),
              body: Stack(
                children: [

                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonCarousel(),
                        VideoListPage(),
                      ],
                    ),
                  ),
                  ResponsiveWidget.isMediumScreen(context)
                      ? Container()   :
                  Container(
                    height: 60,
                    color: Theme.of(context).cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 40),
                        Image.asset(AssetsConstants.icLogo, height: 40),
                        Expanded(
                            child: SizedBox(
                                width: SizeConfig.screenWidth * .12)),
                        appTextButton(context, 'Home', Alignment.center, Theme.of(context).canvasColor,18, true,onPressed:  () {
              GoRouter.of(context)
                  .pushNamed(RoutesName.home);
            }),
                        SizedBox(width: SizeConfig.screenWidth * .02),
                        appTextButton(context, 'Upcoming', Alignment.center,Theme.of(context).canvasColor, 18, true,onPressed:  () {
                          GoRouter.of(context)
                              .pushNamed(RoutesName.home);
                        }),
                        SizedBox(width: SizeConfig.screenWidth * .02),

                        appTextButton(context,  'Contact US', Alignment.center,Theme.of(context).canvasColor, 18, true,onPressed:  () {
                          GoRouter.of(context).pushNamed(
                            RoutesName.ContactUsPage,
                          );
                        }),
                        Expanded(child: SizedBox(width: SizeConfig.screenWidth * .12)),
                        Container(
                          height: 55,
                          width: SizeConfig.screenWidth / 2.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(border: Border.all(color: TRANSPARENT_COLOR, width: 2.0)),
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
                            isTick: null,
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * .02),
                        names == "null"
                            ? OutlinedButton(
                          onPressed:  () {
                            showDialog(
                                context: context,
                                barrierColor: Colors.black87,
                                builder: (BuildContext context) {
                                  return const SignUp();
                                });
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size.fromHeight(40)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                          ),
                          child:appTextButton(context,  'SignUp', Alignment.center,Theme.of(context).canvasColor, 18, true))
                            :  appTextButton(context,  names!, Alignment.center,Theme.of(context).canvasColor, 18, true,onPressed:  () {
                        }),
                        names == "null"
                            ? SizedBox(width: SizeConfig.screenWidth * .01)
                            : const SizedBox(),
                        names == "null"
                            ? OutlinedButton(
                          onPressed:  () {
                            showDialog(
                                context: context,
                                barrierColor: Colors.black87,
                                builder: (BuildContext context) {
                                  return const LoginUp();
                                });
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size.fromHeight(40)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.black,
                                    width: 5,
                                    style: BorderStyle.solid
                                ),
                                borderRadius: BorderRadius.circular(5.0)
                            )),
                          ),
                          child:  appTextButton(context,  'Login', Alignment.center, Theme.of(context).canvasColor,18, true)
                        )
                            :  GestureDetector(
                          onTap: (){
                           setState(() {
                             isLogins=true;
                           });
                          },
                            child: Image.asset(
                                'images/LoginUser.png',
                                height: 30,
                                color:
                                Theme.of(context).accentColor,

                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * .02),
                      ],
                    ),
                  ),
                  isLogins==true?   Positioned(
                      top: 50,right: 20,
                      child: Container(
                    height: 80,width: 150,
                     child:Column(
                       children: [
                         SizedBox(height: 5),
                    appTextButton(context, "My Account", Alignment.center, Theme.of(context).canvasColor,18, false,onPressed: (){
                      showDialog(
                                context: context,
                                barrierColor: Colors.black87,
                                builder: (BuildContext context) {
                                  return  EditProfile();
                                });
                      setState(() {

                        isLogins=false;
                      });
                    }),
                         SizedBox(height: 5),
                         Container(
                           height: 1,color: Colors.black,
                         ),
                         SizedBox(height: 5),
                         appTextButton(context, "LogOut", Alignment.center, Theme.of(context).canvasColor,18, false,onPressed: (){
                           setState(() {
                             authVM.logoutButtonPressed(context);
                             isLogins=false;
                           });
                         }),
                       ],
                     ),
                     color: Colors.pink,
                     // height: 20,width: 20,
                   )):Container(),

                  if (viewmodel.searchDataModel != null)
                    searchView(viewmodel)
                ],
              ));
        }));
  }

  searchView(HomeViewModel viewmodel) {
    return viewmodel.searchDataModel!.searchList!.isNotEmpty && isSearch == true
        ? Padding(
            padding: EdgeInsets.only(left: 15,right: 15,top: 70),
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  onNotification(notification, viewmodel.lastPage,
                      viewmodel.nextPage, searchController?.text ?? '');
                }
                return false;
              },
              child: Stack(
                children: [
                  Container(
                      height: 350,
                      decoration: BoxDecoration(
                          color: viewmodel.searchDataModel != null &&
                                  isSearch == true
                              ? WHITE_COLOR
                              : TRANSPARENT_COLOR,
                          borderRadius: BorderRadius.circular(8)),
                      child: ListView.builder(
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () async {
                                isSearch = false;
                                GoRouter.of(context).pushNamed(
                                    RoutesName.DeatilPage,
                                    queryParams: {
                                      'movieID':
                                          '${viewmodel.searchDataModel?.searchList?[index].youtubeVideoId}',
                                      'VideoId':
                                          '${viewmodel.searchDataModel?.searchList?[index].videoId}',
                                      'Title':
                                          '${viewmodel.searchDataModel?.searchList?[index].videoTitle}',
                                      'Desc':
                                          '${viewmodel.searchDataModel?.searchList?[index].videoDescription}'
                                    });
                              },
                              child: ListTile(
                                  title: AppMediumFont(context,
                                      msg: viewmodel.searchDataModel
                                          ?.searchList?[index].videoTitle)),
                            );
                          },
                          itemCount:
                              viewmodel.searchDataModel?.searchList?.length)),
                  homeViewModel.isLoading == true
                      ? Positioned(
                          bottom: 7,
                          left: 1,
                          right: 1,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ))
                      : const SizedBox()
                ],
              ),
            ),
          )
        : Container();
  }

  onNotification(ScrollNotification notification, int lastPage, int nextPage,
      String searchData) {
    if (nextPage <= lastPage) {
      homeViewModel.runIndicator(context);
      homeViewModel.getSearchData(context, searchData, nextPage);
    }
  }
}

Widget MobileMenu(BuildContext context) {
  final authVM = Provider.of<AuthViewModel>(context);
  return MultiLevelDrawer(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    rippleColor: Theme.of(context).primaryColorDark,
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
          const SizedBox(
            height: 10,
          ),
        ],
      )),
    ),
    children: [
      MLMenuItem(
          trailing: Icon(Icons.arrow_right,
              color: Theme.of(context).primaryColorLight),
          leading: Icon(
            Icons.home_filled,
            color: Theme.of(context).primaryColorLight,
          ),
          content: Text(" Home",
              style: TextStyle(color: Theme.of(context).primaryColorLight)),
          onClick: () {
            GoRouter.of(context).pushNamed(RoutesName.home);
          }),
      names == "null"
          ? MLMenuItem(
              trailing: Icon(Icons.login_sharp,
                  color: Theme.of(context).primaryColorLight),
              leading: Icon(
                Icons.upcoming_sharp,
                color: Theme.of(context).primaryColorLight,
              ),
              content: Text(" Login",
                  style: TextStyle(color: Theme.of(context).primaryColorLight)),
              onClick: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierColor: Colors.black87,
                    builder: (BuildContext context) {
                      return const LoginUp();
                    });
              })
          : MLMenuItem(
              trailing: Icon(Icons.login_outlined,
                  color: Theme.of(context).primaryColorLight),
              leading: Icon(
                Icons.upcoming_sharp,
                color: Theme.of(context).primaryColorLight,
              ),
              content: Text("Logout",
                  style: TextStyle(color: Theme.of(context).primaryColorLight)),
              onClick: () {
                authVM.logoutButtonPressed(context);
              },
            ),
      MLMenuItem(
          leading: Icon(
            Icons.contacts,
            color: Theme.of(context).primaryColorLight,
          ),
          trailing: Icon(Icons.arrow_right,
              color: Theme.of(context).primaryColorLight),
          content: Text(" Contact Us",
              style: TextStyle(color: Theme.of(context).primaryColorLight)),
          onClick: () {}),
    ],
  );
}
