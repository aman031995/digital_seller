import 'package:TychoStream/main.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/getAppBar.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/annotations.dart';
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

  @override
  void initState() {
    homeViewModel.getAppConfig(context);
    homeViewModel.openWebHtmlView(context, widget.html ?? "", title: widget.title );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return     ChangeNotifierProvider.value(
        value: homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return connectivity == 'Offline'
              ? NOInternetScreen()
              : viewmodel.html==''? Center(child: ThreeArchedCircle(size: 45.0))    :


         GestureDetector(
           onTap: () {
             if (isLogins == true) {
               isLogins = false;
               setState(() {});
             }
             if (isSearch == true) {
               isSearch = false;
               setState(() {});
             }
           },
           child: Scaffold(
        appBar: ResponsiveWidget.isMediumScreen(context)
              ? homePageTopBar(context, _scaffoldKey, cartViewModel.cartItemCount)
              : getAppBar(
              context,
                viewmodel,
              profileViewModel,
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
        SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Html(data:viewmodel.html ?? "" , style: {
                  "body": Style(fontSize: FontSize.large,lineHeight: LineHeight.number(2),color: Theme.of(context).canvasColor,padding:HtmlPaddings.only(left: 18,right: 18))
                }),
                              SizedBox(height: 50),
                              ResponsiveWidget.isMediumScreen(
                                  context)
                                  ? footerMobile(context)
                                  :footerDesktop(),
                            ],
                          ),
                          ResponsiveWidget
                              .isMediumScreen(context)
                              ?  Container():isLogins == true
                              ? Positioned(
                              top: 80,
                              right: 35,
                              child: profile(context,
                                  setState, profileViewModel))
                              : Container(),
                          isSearch == true
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
                                  0.15,
                              child: searchList(
                                  context,
                                  viewmodel,
                                  scrollController,
                                  homeViewModel,
                                  searchController!,
                                  cartViewModel
                                      .cartItemCount))
                              : Container()
                        ],
                      )
        )),
           ));})
    );
  }
}
