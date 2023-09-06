import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/Profile/order_details.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/getAppBar.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/order_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppRouter.gr.dart';
import '../../main.dart';
import '../../utilities/StringConstants.dart';

@RoutePage()
class MyOrderPage extends StatefulWidget {
  const MyOrderPage({Key? key}) : super(key: key);
  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}
class _MyOrderPageState extends State<MyOrderPage> {

  final OrderViewModel orderView = OrderViewModel();
  int pageNum = 1;
  String? checkInternet;
  ScrollController scrollController = ScrollController();
  HomeViewModel homeViewModel = HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ProfileViewModel profileViewModel = ProfileViewModel();
  CartViewModel cartViewModel = CartViewModel();
  TextEditingController? searchController = TextEditingController();

  @override
  void initState() {
    orderView.getOrderList(context, pageNum);
    homeViewModel.getAppConfig(context);
    cartViewModel.getCartCount(context);
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
    return ChangeNotifierProvider.value(
      value: orderView,
      child: Consumer<OrderViewModel>(builder: (context, orderview, _) {
        return GestureDetector(
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
              backgroundColor: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              appBar: ResponsiveWidget.isMediumScreen(context)
                  ? homePageTopBar(
                  context, _scaffoldKey, cartViewModel.cartItemCount,homeViewModel,
                profileViewModel,)
                  : getAppBar(
                  context,
                  homeViewModel,
                  profileViewModel,
                  cartViewModel.cartItemCount,
                  1,
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
                  if (isLogins == true) {
                    isLogins = false;
                    setState(() {});
                  }
                  if (isSearch == true) {
                    isSearch = false;
                    setState(() {});
                  }
                  context.router.push(FavouriteListPage());
                }
              }, () async {
                SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
                if (sharedPreferences
                    .getString('token') == null) {
                  showDialog(
                      context: context,
                      barrierColor: Theme
                          .of(context)
                          .canvasColor
                          .withOpacity(0.6),
                      builder: (BuildContext context) {
                        return LoginUp(
                          product: true,
                        );
                      });
                } else {
                  if (isLogins == true) {
                    isLogins = false;
                    setState(() {});
                  }
                  if (isSearch == true) {
                    isSearch = false;
                    setState(() {});
                  }
                  context.router.push(CartDetail(
                      itemCount:
                      '${cartViewModel.cartItemCount}'));
                }
              }),
              body:Scaffold(
                  extendBodyBehindAppBar: true,
                  key: _scaffoldKey,
                  backgroundColor: Theme.of(context)
                      .scaffoldBackgroundColor,
                  drawer:
                  ResponsiveWidget.isMediumScreen(context)
                      ? AppMenu()
                      : SizedBox(),
                  body: checkInternet == "Offline"
                  ? NOInternetScreen()
                  : orderview.orderData != null ?
                  orderView.orderData!.orderList!.length > 0?  Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                              height:  ResponsiveWidget.isMediumScreen(context)
                                  ?SizeConfig.screenHeight/1.2:SizeConfig.screenHeight*1.2,
                              width: ResponsiveWidget.isMediumScreen(context)
                                  ? SizeConfig.screenWidth : SizeConfig
                                  .screenWidth / 1.5,
                              child: ListView.builder(
                                  padding: EdgeInsets.only(bottom: 20),
                                 controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount: orderview.orderData?.orderList
                                      ?.length,
                                  itemBuilder: (context, index) {
                                    scrollController.addListener(() {
                                      if (scrollController.position.pixels ==
                                          scrollController.position
                                              .maxScrollExtent) {
                                        orderView.onPagination(
                                            context,
                                            orderView.lastPage,
                                            orderView.nextPage,
                                            orderView.isLoading
                                        );
                                      }
                                    });
                                    return InkWell(
                                          onTap: () {
                                            if (isLogins == true) {
                                              isLogins = false;
                                              setState(() {});
                                            }
                                            if (isSearch == true) {
                                              isSearch = false;
                                              setState(() {});
                                            }
                                            showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context) {
                                                  return OrderDetails(
                                                      orderItem: orderView.orderData
                                                          ?.orderList?[index],
                                                  callback: (v){
                                                        if(v==true){
                                                          setState(() { orderView.getOrderList(context, pageNum);
                                                          });
                                                        }
                                                  });
                                                });
                                          },
                                          child: orderView.orderData!.orderList!
                                              .isEmpty
                                              ?
                                          Center(
                                              child:
                                              noDataFoundMessage(context,
                                                  StringConstant.noOrderAvailable,homeViewModel))
                                              :
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Theme
                                                    .of(context)
                                                    .cardColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0))),
                                            width: ResponsiveWidget.isMediumScreen(
                                                context)
                                                ? SizeConfig.screenWidth / 1.2
                                                : SizeConfig.screenWidth / 2.5,
                                            height: ResponsiveWidget.isMediumScreen(
                                                context)
                                                ? 140 : SizeConfig.screenHeight / 4,
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(top: 12,
                                                bottom: 12,
                                                left: 12,
                                                right: 12),
                                            padding: EdgeInsets.only(left: 10,
                                                right: 20,
                                                top: 20,
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                InkWell(
                                                    onTap: () {},
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(8.0),
                                                      child: Image.network(
                                                        orderView.orderData
                                                            ?.orderList?[index]
                                                            .productImages?[0]
                                                            ?? " ",
                                                        height: ResponsiveWidget
                                                            .isMediumScreen(context)
                                                            ? 100 : SizeConfig
                                                            .screenWidth / 2,
                                                        fit: BoxFit.fill,
                                                        width: ResponsiveWidget
                                                            .isMediumScreen(context)
                                                            ? 100 : SizeConfig
                                                            .screenWidth / 8,
                                                      ),
                                                    )),
                                                SizedBox(width: 12),
                                                Container(
                                                  width: ResponsiveWidget
                                                      .isMediumScreen(context)
                                                      ? SizeConfig.screenWidth / 2
                                                      :  SizeConfig
                                                      .screenWidth / 6,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      SizedBox(height: 18),
                                                      AppMediumFont(context,
                                                          msg: StringConstant
                                                              .orderDetailed +
                                                              "-${orderView
                                                                  .orderData
                                                                  ?.orderList?[index]
                                                                  .orderId}",
                                                          fontSize: ResponsiveWidget
                                                              .isMediumScreen(
                                                              context)
                                                              ? 14 : 16.0),
                                                      AppMediumFont(context,
                                                          msg:
                                                          orderView.orderData
                                                              ?.orderList?[index]
                                                              .productName,
                                                          fontSize: ResponsiveWidget
                                                              .isMediumScreen(
                                                              context)
                                                              ? 14 : 16.0,
                                                          maxLines: 1),
                                                      SizedBox(height: 5),
                                                      AppMediumFont(context,
                                                          msg: orderView.orderData
                                                              ?.orderList?[index]
                                                              .orderStatus,
                                                          fontSize: 16.0),
                                                      SizedBox(height: 5),
                                                      AppMediumFont(context,
                                                          msg: orderView.orderData
                                                              ?.orderList?[index]
                                                              .orderDate,
                                                          fontSize: 16.0)
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        );
                                  })),
                        ),
                        SizedBox(height: 40),
                        ResponsiveWidget.isMediumScreen(context)
                            ? footerMobile(context,homeViewModel) : footerDesktop()
                      ],
                    ),
                  ),
                  ResponsiveWidget
                      .isMediumScreen(context)
                      ? Container(): isLogins == true
                      ? Positioned(
                      top:0,
                      right: 180,
                      child: profile(context,
                          setState, profileViewModel))
                      : Container(),
                  ResponsiveWidget
                      .isMediumScreen(context)
                      ? Container():
                  isSearch == true
                      ? Positioned(
                      top:  1,
                      right: SizeConfig.screenWidth *
                          0.20,
                      child: searchList(
                          context,
                          homeViewModel,
                          scrollController,
                          searchController!,
                          cartViewModel
                              .cartItemCount))
                      : Container(),
                  orderview.isLoading == true ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.bottomCenter,
                      child: CircularProgressIndicator(
                          color: Theme
                              .of(context)
                              .primaryColor))
                      : SizedBox()
                ],
              ):
                  Stack(
                    children: [
                      noDataFoundMessage(
                          context,StringConstant.noOrderAvailable,homeViewModel),
                      ResponsiveWidget
                          .isMediumScreen(context)
                          ?Container(): isLogins == true
                          ? Positioned(
                          top: 0,
                          right:  180,
                          child: profile(context,
                              setState, profileViewModel))
                          : Container(),
                      ResponsiveWidget
                          .isMediumScreen(context)
                          ? Container():   isSearch == true
                          ? Positioned(
                          top:  SizeConfig.screenWidth *
                              0.001,
                          right:  SizeConfig.screenWidth *
                              0.20,
                          child: searchList(
                              context,
                              homeViewModel,
                              scrollController,
                              searchController!,
                              cartViewModel
                                  .cartItemCount))
                          : Container()
                    ],
                  ) : Center(child: ThreeArchedCircle(size: 45.0))),
        ));
      },
      ),
    );
  }
}
