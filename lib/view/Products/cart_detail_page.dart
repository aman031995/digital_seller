import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/getAppBar.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/data/product_list_model.dart';
import '../../utilities/SizeConfig.dart';

@RoutePage()
class CartDetail extends StatefulWidget {
  final String? itemCount;

  CartDetail({Key? key, @PathParam('itemCount') this.itemCount})
      : super(key: key);

  @override
  State<CartDetail> createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  CartViewModel cartViewData = CartViewModel();
  final validation = ValidationBloc();
  String? checkInternet;
  HomeViewModel homeViewModel=HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  ProfileViewModel profileViewModel = ProfileViewModel();
  TextEditingController? searchController = TextEditingController();

  @override
  void initState() {
    homeViewModel.getAppConfig(context);
    SessionStorageHelper.removeValue('token');
    SessionStorageHelper.removeValue('payment');
    cartViewData.getCartCount(context);
    cartViewData.updateCartCount(context, widget.itemCount ?? '');
    cartViewData.getCartListData(context);
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
    return checkInternet == "Offline"
        ? NOInternetScreen()
        : ChangeNotifierProvider.value(
            value: cartViewData,
            child: Consumer<CartViewModel>(builder: (context, cartViewData, _) {
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
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    appBar:  ResponsiveWidget.isMediumScreen(context)
                        ? homePageTopBar(context, _scaffoldKey, cartViewData.cartItemCount,homeViewModel, profileViewModel,)
                        : getAppBar(
                        context,
                        homeViewModel,
                        profileViewModel,
                        cartViewData.cartItemCount,1,
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
                        if (isLogins == true) {
                          isLogins = false;
                          setState(() {});
                        }
                        if (isSearch == true) {
                          isSearch = false;
                          setState(() {});
                        }

                      }
                    }),

              body: Scaffold(
                  extendBodyBehindAppBar: true,
              key: _scaffoldKey,
              drawer:
              ResponsiveWidget.isMediumScreen(context)
              ? AppMenu() : SizedBox(),
                    body: cartViewData.cartListData != null
                        ? cartViewData.cartListData!.cartList!.length > 0
                            ? Stack(
                              children: [
                                SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            cartPageViewIndicator(context, 0),
                                            SizedBox(height: 10),
                                            ResponsiveWidget.isMediumScreen(context)
                                                ? Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(1)),
                                              child: ListView.builder(
                                                itemCount: cartViewData.cartListData?.cartList?.length ?? 0,
                                                shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                physics: ScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  final itemInCart = cartViewData
                                                      .cartListData?.cartList?[index];
                                                  return Container(
                                                    color: Theme.of(context).cardColor,
                                                      margin: EdgeInsets.only(bottom: 5,left: ResponsiveWidget.isSmallScreen(context) ? 10:16,right: ResponsiveWidget.isSmallScreen(context) ? 10:16),
                                                    child:cardDeatils(context,itemInCart!,index,cartViewData)
                                                  );
                                                },
                                              ),
                                            ):
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(5)),
                                                width:
                                                SizeConfig.screenWidth * 0.30,
                                                height:
                                                SizeConfig.screenHeight / 1.2,
                                                child: ListView.builder(
                                                  itemCount: cartViewData
                                                      .cartListData
                                                      ?.cartList
                                                      ?.length ??
                                                      0,
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    final itemInCart = cartViewData.cartListData?.cartList?[index];
                                                    return Container(
                                                      color: Theme.of(context).cardColor,
                                                      margin: EdgeInsets.only(bottom: 5,right: 15),
                                                      child:cardDeatils(context,itemInCart!,index,cartViewData)
                                                    );
                                                  },
                                                )),
                                                SizedBox(width: 5),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    pricedetails(context,cartViewData),
                                                    SizedBox(height: 10),
                                                    Center(
                                                      child: checkoutButton(
                                                          context,
                                                          StringConstant.continueText,
                                                          cartViewData, () { if (isLogins == true) {
                                                        isLogins = false;
                                                        setState(() {});
                                                      }
                                                      if (isSearch == true) {
                                                        isSearch = false;
                                                        setState(() {});
                                                      }
                                                      if(hasOutOfStockItems(cartViewData.cartListData!.cartList!)){
                                                          ToastMessage.message(StringConstant.removeOutofStock,context);
                                                      } else {
                                                        if(hasOutOfQuantityLeft(cartViewData.cartListData!.cartList!)){
                                                          ToastMessage.message(StringConstant.removeOutofStock,context);
                                                        }
                                                        else{ context.router.push(
                                                            AddressListPage(
                                                                buynow: false)) ;}
                                                        }
                                                      }),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            ResponsiveWidget.isMediumScreen(context)
                                                ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 5),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: ResponsiveWidget.isSmallScreen(context) ? 10:16, right: ResponsiveWidget.isSmallScreen(context) ? 10:16),
                                                    child: pricedetails(context,cartViewData)),
                                                SizedBox(height: 10),
                                                 Container(
                                                    height: 50,
                                                    margin: EdgeInsets.only(
                                                        left: ResponsiveWidget.isSmallScreen(context) ? 20:26, right: ResponsiveWidget.isSmallScreen(context) ? 20:26),
                                                    width: SizeConfig
                                                        .screenWidth,
                                                    child: checkoutButton(
                                                        context,
                                                        StringConstant
                                                            .continueText,
                                                        cartViewData, () { if (isLogins == true) {
                                                      isLogins = false;
                                                      setState(() {});
                                                    }
                                                    if (isSearch == true) {
                                                      isSearch = false;
                                                      setState(() {});
                                                    }
                                                    if(hasOutOfStockItems(cartViewData.cartListData!.cartList!)){

                                                        ToastMessage.message(StringConstant.removeOutofStock,context);

                                                    } else {
                                                      if(hasOutOfQuantityLeft(cartViewData.cartListData!.cartList!)){
                                                        ToastMessage.message(StringConstant.removeOutofStock,context);
                                                      }
                                                      else{
                                                        context.router.push(
                                                            AddressListPage(
                                                                buynow: false)) ;
                                                      }
                                                       }
                                                    }),
                                                )
                                              ],
                                            ):SizedBox(height: 20),
                                            SizedBox(height: 30),
                                            ResponsiveWidget.isMediumScreen(context)
                                                ?  footerMobile(context,homeViewModel):footerDesktop()
                                          ],
                                        ),
                                      ),
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
                                    top: SizeConfig.screenWidth *
                                        0.001,
                                    right: SizeConfig.screenWidth *
                                        0.20,
                                    child: searchList(
                                        context,
                                        homeViewModel,
                                        scrollController,
                                        searchController!,
                                        cartViewData
                                            .cartItemCount))
                                    : Container()
                              ],
                            )

                            : Stack(
                              children: [
                                noDataFoundMessage(
                                    context, StringConstant.noItemInCart,homeViewModel),
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
                                    top: ResponsiveWidget
                                        .isMediumScreen(context)
                                        ? 0
                                        : SizeConfig.screenWidth *
                                        0.001,
                                    right: ResponsiveWidget
                                        .isMediumScreen(context)
                                        ? 0
                                        : SizeConfig.screenWidth *
                                        0.15,
                                    child: searchList(
                                        context,
                                        homeViewModel,
                                        scrollController,
                                        searchController!,
                                        cartViewData
                                            .cartItemCount))
                                    : Container()
                              ],
                            )
                        : Center(
                            child:
                                Container(child: ThreeArchedCircle(size: 45.0)),
                          )
                ),
              ));
            })
    );
  }
  bool hasOutOfStockItems(List<ProductList> cartList) {
    for (var item in cartList) {
      if (!item.productDetails!.inStock!) {
        return true;
      }
    }
    return false;
  }
}

bool hasOutOfQuantityLeft(List<ProductList> cartList) {
  for (var item in cartList) {
    if ((item.productDetails!.quantityLeft ?? 0) < 1) {
      return true;
    }
  }
  return false;
}

