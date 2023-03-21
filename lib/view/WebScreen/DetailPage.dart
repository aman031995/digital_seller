import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/YoutubeAppDemo.dart';
import 'package:tycho_streams/view/WebScreen/DesktopAppBar.dart';
import 'package:tycho_streams/view/WebScreen/EditProfile.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';


import 'package:tycho_streams/view/WebScreen/MovieDetailTitleSection.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/widgets/search_view.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

import '../widgets/app_menu.dart';


class DetailPage extends StatefulWidget {
  String? movieID;
String? VideoId;
String? Title;
String? Desc;
  DetailPage({this.movieID,this.Desc,this.Title,this.VideoId});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<DetailPage> {
  String url='';
  HomeViewModel homeViewModel = HomeViewModel();
  ScrollController _scrollController = ScrollController();
  TextEditingController? searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isSearch = false;
  int pageNum = 1;
  @override
  void initState() {
    setState((){
     url = 'https://www.youtube.com/embed/${widget.movieID}';
    });
    homeViewModel.getAppConfigData(context);
    searchController?.addListener(() {
      homeViewModel.getSearchData(
          context, '${searchController?.text}', pageNum);
    });
    super.initState();
  }
  void dispose() {
    _scrollController.dispose();
    searchController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
      return
        Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight( ResponsiveWidget.isMediumScreen(context)? 50:55),
            child: Container(
              height: 55,
              color: Theme.of(context).cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 40),
                  Image.asset(AssetsConstants.icLogo, height: 40),
                  Expanded(child: SizedBox(width: SizeConfig.screenWidth * .12)),
                  AppButton(context, 'Home', onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(RoutesName.home);
                  }),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                  AppButton(context, 'Contact US',
                      onPressed: () {
                        GoRouter.of(context).pushNamed(
                          RoutesName.ContactUsPage,
                        );
                      }),
                  Expanded(
                      child: SizedBox(
                          width: SizeConfig.screenWidth * .12)),
                  Container(
                      height: 45,
                      width: SizeConfig.screenWidth / 4.2,
                      alignment: Alignment.center,
                      child: AppTextField(
                          controller: searchController,
                          maxLine: searchController!.text.length > 2 ? 2 : 1,
                          textCapitalization:
                          TextCapitalization.words,
                          secureText: false,
                          floatingLabelBehavior:
                          FloatingLabelBehavior.never,
                          maxLength: 30,
                          labelText:
                          'Search videos, shorts, products',
                          keyBoardType: TextInputType.text,
                          onChanged: (m) {
                            isSearch = true;
                          },
                          isTick: null)),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                  names == "null"
                      ? OutlinedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder:
                                (BuildContext context) {
                              return const SignUp();
                            });
                      },
                      style: ButtonStyle(
                        overlayColor:
                        MaterialStateColor.resolveWith(
                                (states) =>
                            Theme.of(context)
                                .primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(
                            Size.fromHeight(30)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    5.0))),
                      ),
                      child: appTextButton(
                          context,
                          'SignUp',
                          Alignment.center,
                          Theme.of(context).canvasColor,
                          18,
                          true))
                      : appTextButton(
                      context,
                      names!,
                      Alignment.center,
                      Theme.of(context).canvasColor,
                      18,
                      true,
                      onPressed: () {}),
                  names == "null"
                      ? SizedBox(
                      width: SizeConfig.screenWidth * .01)
                      : const SizedBox(),
                  names == "null"
                      ? OutlinedButton(
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
                        overlayColor:
                        MaterialStateColor.resolveWith(
                                (states) =>
                            Theme.of(context)
                                .primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(
                            Size.fromHeight(30)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    5.0))),
                      ),
                      child: appTextButton(
                          context,
                          'Login',
                          Alignment.center,
                          Theme.of(context).canvasColor,
                          18,
                          true))
                      : GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogins = true;
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
            )),
        drawer: ResponsiveWidget.isMediumScreen(context) ?AppMenu(homeViewModel: viewmodel):Container(),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body:    GestureDetector(
            onTap: () {
              if (isSearch == true) {
                isSearch = false;
                setState(() {});
              }
            },
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                           width: SizeConfig.screenWidth/1.3,
                           height: ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenWidth /2.47:SizeConfig.screenWidth /2.959,
                           child: YoutubeAppDemo(videoID: widget.movieID)
                       ),
                          MovieDetailTitleSection(
                              isWall: true, movieDetailModel: widget.VideoId,Title: widget.Title,Desc: widget.Desc,),
                        SizedBox(height: 80),
                        ResponsiveWidget.isMediumScreen(context)? footerMobile(context):footerDesktop(),

                      ],
                    ),
                  ),
                  isLogins == true
                      ? Positioned(
                      top: 50,
                      right: 20,
                      child: Container(
                        height: 80, width: 150,
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            appTextButton(
                                context,
                                "My Account",
                                Alignment.center,
                                Theme.of(context).canvasColor,
                                18,
                                false, onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditProfile();
                                  });
                              setState(() {
                                isLogins = false;
                              });
                            }),
                            SizedBox(height: 5),
                            Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            SizedBox(height: 5),
                            appTextButton(
                                context,
                                "LogOut",
                                Alignment.center,
                                Theme.of(context).canvasColor,
                                18,
                                false, onPressed: () {
                              setState(() {
                                authVM.logoutButtonPressed(context);
                                isLogins = false;
                                isLogin=false;
                              });
                            }),
                          ],
                        ),
                        color: Theme.of(context).cardColor,
                        // height: 20,width: 20,
                      ))
                      : Container(),
                  if (homeViewModel.searchDataModel != null)
                    searchView(context, homeViewModel, isSearch, _scrollController, homeViewModel, searchController!, setState)
                ],
              ),
            ),
          )
        );
        }
        )
    );
  }


}
