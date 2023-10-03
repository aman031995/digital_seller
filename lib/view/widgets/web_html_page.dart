import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
import 'package:TychoStream/view/widgets/NotificationScreen.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/footerDesktop.dart';
import 'package:TychoStream/view/widgets/getAppBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/notification_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AppRouter.gr.dart';


@RoutePage()
class WebHtmlPage extends StatefulWidget {

  final String? html;
  final String? title;
  WebHtmlPage({
    @PathParam('title') this.title,
    @QueryParam() this.html,
    Key? key}) : super(key: key);

  @override
  State<WebHtmlPage> createState() => _WebHtmlPageState();
}

class _WebHtmlPageState extends State<WebHtmlPage> {
  String? connectivity;
HomeViewModel homeViewModel=HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  ProfileViewModel profileViewModel = ProfileViewModel();
  CartViewModel cartViewModel = CartViewModel();
  TextEditingController? searchController = TextEditingController();
  String?  checkInternet;
  NotificationViewModel notificationViewModel = NotificationViewModel();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    cartViewModel.getCartCount(context);

    homeViewModel.getAppConfig(context);
    profileViewModel.getProfileDetail(context);
    notificationViewModel.getNotificationCountText(context);
    cartViewModel.getCartCount(context);

    homeViewModel.openWebHtmlView(context, widget.html ?? "", title: widget.title );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });
    return connectivity == 'Offline'
        ? NOInternetScreen()
        : ChangeNotifierProvider.value(
        value: profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
          return ChangeNotifierProvider.value(
              value: homeViewModel,
              child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
                return ChangeNotifierProvider.value(
                    value: notificationViewModel,
                    child: Consumer<NotificationViewModel>(
                        builder: (context, model, _) {
        return    viewmodel.html==''? Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                color:Theme.of(context).scaffoldBackgroundColor,
                child: Center(child: ThreeArchedCircle(size: 45.0))):
            GestureDetector(
           onTap: () {
             if (GlobalVariable.isLogins == true) {
               GlobalVariable.isLogins = false;

             }
             if (GlobalVariable.isSearch == true) {
               GlobalVariable.isSearch = false;
             }
             if(GlobalVariable.isnotification==true){
               GlobalVariable.isnotification=false;
               setState(() {

               });
             }
           },
           child: Scaffold(
        appBar: ResponsiveWidget.isMediumScreen(context)
              ? homePageTopBar(context, _scaffoldKey, cartViewModel.cartItemCount,viewmodel,
          profilemodel,model)
              : getAppBar(
              context,model,
                viewmodel,
            profilemodel,
              cartViewModel.cartItemCount,1,
              searchController, () async {
            SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
            if (sharedPreferences.get('token') ==
                null) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LoginUp(
                      product: true,
                    );
                  });
            } else {
              if (GlobalVariable.isLogins == true) {
                GlobalVariable.isLogins = false;
              }
              if (GlobalVariable.isSearch == true) {
                GlobalVariable.isSearch = false;
              }
              if (GlobalVariable.isSearch == true) {
                GlobalVariable.isSearch = false;
              }
              context.router.push(FavouriteListPage());
            }
        }, () async {
            SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
            if (sharedPreferences
                .getString('token')== null) {
              showDialog(
                  context: context,
                  barrierColor: Theme.of(context)
                      .canvasColor
                      .withOpacity(0.6),
                  builder: (BuildContext context) {
                    return LoginUp(
                      product: true,
                    );
                  });
            } else {
              if (GlobalVariable.isLogins == true) {
                GlobalVariable.isLogins = false;
              }
              if (GlobalVariable.isSearch == true) {
                GlobalVariable.isSearch = false;
              }
              if(GlobalVariable.isnotification==true){
                GlobalVariable.isnotification=false;

              }
              context.router.push(CartDetail(
                  itemCount:
                  '${cartViewModel.cartItemCount}'));
            }
        }),

          body: Scaffold(

          extendBodyBehindAppBar: true,
          key: _scaffoldKey,
          backgroundColor: Theme.of(context)
              .scaffoldBackgroundColor,
          drawer:
          ResponsiveWidget.isMediumScreen(context)
          ? AppMenu()
              : SizedBox(),
        body:
        Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Html(data:viewmodel.html ?? "" , style: {
                    "body": Style(fontSize:ResponsiveWidget.isMediumScreen(
                        context)
                        ?FontSize.medium: FontSize.large,lineHeight: LineHeight.number(ResponsiveWidget.isMediumScreen(
                        context)
                        ?1:2),color: Theme.of(context).canvasColor,padding:HtmlPaddings.only(left: 18,right: 18))
                  }),
                  SizedBox(height: ResponsiveWidget.isMediumScreen(
                      context)
                      ?50:160),
                  ResponsiveWidget.isMediumScreen(
                      context)
                      ? footerMobile(context,homeViewModel)
                      :footerDesktop(),
                ],
              ),
            ),
            ResponsiveWidget.isMediumScreen(context)
                ? Container()
                : GlobalVariable.isnotification == true
                ?    Positioned(
                top:  0,
                right:  SizeConfig
                    .screenWidth *
                    0.20,
                child: notification(notificationViewModel,context,_scrollController)):Container(),
            ResponsiveWidget
                .isMediumScreen(context)
                ?  Container():GlobalVariable.isLogins == true
                ? Positioned(
                top: 0,
                right: SizeConfig.screenWidth *
                    0.13,
                child: profile(context,
                    setState, profilemodel))
                : Container(),
            GlobalVariable.isSearch == true
                ? Positioned(
                top: ResponsiveWidget
                    .isMediumScreen(context)
                    ? 0
                    : SizeConfig.screenWidth *
                    0.002,
                right: ResponsiveWidget
                    .isMediumScreen(context)
                    ? 0
                    : SizeConfig.screenWidth *
                    0.20,
                child: searchList(
                    context,
                    viewmodel,
                    scrollController,
                    searchController!,
                    cartViewModel
                        .cartItemCount))
                : Container()
          ],
        )),
           ));}));}
    ));}));
  }
}
