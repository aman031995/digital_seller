import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/services/session_storage.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
import 'package:TychoStream/view/widgets/NotificationScreen.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/footerDesktop.dart';
import 'package:TychoStream/view/widgets/getAppBar.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/notification_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/data/product_list_model.dart';
import '../../../utilities/SizeConfig.dart';

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
  NotificationViewModel notificationViewModel = NotificationViewModel();
  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    homeViewModel.getAppConfig(context);
    SessionStorageHelper.removeValue('token');
    SessionStorageHelper.removeValue('payment');
    cartViewData.getCartCount(context);    notificationViewModel.getNotificationCountText(context);

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
          return ChangeNotifierProvider.value(
              value: notificationViewModel,
              child: Consumer<NotificationViewModel>(
                  builder: (context, model, _) {
                    return ChangeNotifierProvider.value(
                        value: homeViewModel,
                        child: Consumer<HomeViewModel>(builder: (context, s, _) {
                          return GestureDetector(
                              onTap: () {
                                closeAppbarProperty();

                              },
                              child: Scaffold(
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                appBar:  ResponsiveWidget.isMediumScreen(context)
                                    ? homePageTopBar(context, _scaffoldKey, cartViewData.cartItemCount,homeViewModel, profileViewModel,model)
                                    : getAppBar(
                                    context,model,
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
                                    closeAppbarProperty();

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
                                    closeAppbarProperty();

                                  }
                                }),

                                body: Scaffold(
                                    extendBodyBehindAppBar: true,
                                    key: _scaffoldKey,
                                    drawer:
                                    ResponsiveWidget.isMediumScreen(context)
                                        ? AppMenu() : SizedBox(),
                                    body: Stack(
                                      children: [
                                        cartViewData.cartListData != null
                                            ? cartViewData.cartListData!.cartList!.length > 0
                                            ?   SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              cartPageViewIndicator(context, 0),
                                              SizedBox(height: 10),
                                              ResponsiveWidget.isMediumScreen(context)
                                                  ? Container(
                                                width: SizeConfig.screenWidth/1.05,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                                    color: Theme.of(context).cardColor  ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: SizeConfig.screenWidth/1.05,
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).canvasColor.withOpacity(0.2),borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(8),
                                                          topLeft: Radius.circular(8))),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          AppBoldFont(context, msg: StringConstant.cartCollection,color: Theme.of(context).canvasColor),
                                                          SizedBox(width: SizeConfig.screenWidth * 0.16),
                                                          AppBoldFont(context, msg: "Item(${cartViewData.cartListData?.cartList?.length})",color: Theme.of(context).canvasColor)
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: ListView.builder(
                                                        itemCount: cartViewData.cartListData?.cartList?.length ?? 0,
                                                        shrinkWrap: true,
                                                        padding: EdgeInsets.only(bottom: 8,top: 8),
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemBuilder: (context, index) {
                                                          final itemInCart = cartViewData
                                                              .cartListData?.cartList?[index];
                                                          return Container(
                                                              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                                                              margin: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                                                              child:ProductcardDeatils(context,itemInCart!,index,cartViewData)
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
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
                                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                                        color: Theme.of(context).cardColor  ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: SizeConfig.screenWidth * 0.36,
                                                          padding: EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(context).canvasColor.withOpacity(0.2),borderRadius: BorderRadius.only(
                                                              topRight: Radius.circular(8),
                                                              topLeft: Radius.circular(8))),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              AppBoldFont(context, msg: StringConstant.cartCollection,color: Theme.of(context).canvasColor),
                                                              SizedBox(width: SizeConfig.screenWidth * 0.16),
                                                              AppBoldFont(context, msg: "Item(${cartViewData.cartListData?.cartList?.length})",color: Theme.of(context).canvasColor)
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                            width: SizeConfig.screenWidth * 0.36,
                                                            //height: SizeConfig.screenWidth * 0.119 * cartViewData.cartListData!.cartList!.length,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(8),
                                                                    bottomRight: Radius.circular(8)),
                                                                color: Theme.of(context).cardColor),
                                                            child: ListView.builder(
                                                              padding: EdgeInsets.only(left: 12,right: 12,bottom: 8,top: 8),
                                                              itemCount: cartViewData.cartListData?.cartList?.length ?? 0,
                                                              shrinkWrap: true,
                                                              physics:NeverScrollableScrollPhysics(),
                                                              itemBuilder: (context, index) {
                                                                final itemInCart = cartViewData.cartListData?.cartList?[index];
                                                                return Container(
                                                                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                                                                    margin: EdgeInsets.only(bottom: 5),
                                                                    height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context) ? 140:150 : SizeConfig.screenWidth * 0.11,
                                                                    child:ProductcardDeatils(context,itemInCart!,index,cartViewData)
                                                                );
                                                              },
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                                        color: Theme.of(context).cardColor  ),

                                                    width: SizeConfig.screenWidth*0.36,
                                                    padding: EdgeInsets.only(bottom: 12),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: SizeConfig.screenWidth *0.36,
                                                          padding: EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(8),
                                                                  topLeft: Radius.circular(8)),
                                                              color: Theme.of(context).canvasColor.withOpacity(0.2)),
                                                          child: AppBoldFont(context, msg: StringConstant.priceDetails,color: Theme.of(context).canvasColor),
                                                        ),
                                                        pricedetails(context,cartViewData),
                                                        SizedBox(height: 10),
                                                        Center(
                                                          child: checkoutButton(
                                                              context,
                                                              StringConstant.continueText,
                                                              cartViewData, () {                       closeAppbarProperty();

                                                          if(hasOutOfStockItems(cartViewData.cartListData!.cartList!)){
                                                            ToastMessage.message(StringConstant.removeOutofStock,context);
                                                          } else {
                                                            if(hasOutOfQuantityLeft(cartViewData.cartListData!.cartList!)){
                                                              ToastMessage.message(StringConstant.removeOutofStock,context);
                                                            }
                                                            else{ context.router.push(
                                                                AddressListPage()) ;}
                                                          }
                                                          }),
                                                        )
                                                      ],
                                                    ),
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
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                                          color: Theme.of(context).cardColor),
                                                      margin: EdgeInsets.only(
                                                          left:10, right: 10,top: 10),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: SizeConfig.screenWidth,
                                                            padding: EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topRight: Radius.circular(8),
                                                                    topLeft: Radius.circular(8)),
                                                                color: Theme.of(context).canvasColor.withOpacity(0.2)),
                                                            child: AppBoldFont(context, msg: StringConstant.priceDetails,color: Theme.of(context).canvasColor),
                                                          ),
                                                          pricedetails(context,cartViewData),
                                                          SizedBox(height: 10),
                                                        ],
                                                      )),
                                                  SizedBox(height: 30),
                                                  Container(
                                                      height: 50,
                                                      margin: EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      width: SizeConfig.screenWidth,
                                                      child: checkoutButton(
                                                          context,
                                                          StringConstant
                                                              .continueText,
                                                          cartViewData, () {
                                                        closeAppbarProperty();
                                                        if(hasOutOfStockItems(cartViewData.cartListData!.cartList!)){
                                                          ToastMessage.message(StringConstant.removeOutofStock,context);
                                                        } else {
                                                          if(hasOutOfQuantityLeft(cartViewData.cartListData!.cartList!)){
                                                            ToastMessage.message(StringConstant.removeOutofStock,context);
                                                          }
                                                          else{
                                                            context.router.push(AddressListPage()) ;
                                                          }}}))],
                                              ):SizedBox(height: 20),
                                              cartViewData.cartListData!.cartList!.length==1?SizedBox(height: ResponsiveWidget.isMediumScreen(context) ?80: 270) :
                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ?20:MediaQuery.of(context).size.width >1290?80:250),
                                              ResponsiveWidget.isMediumScreen(context)
                                                  ?  footerMobile(context,homeViewModel):footerDesktop()
                                            ],
                                          ),
                                        ):noDataFoundMessage(
                                            context, StringConstant.noItemInCart,homeViewModel): Center(
                                          child:
                                          ThreeArchedCircle(size: 45.0),
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
                                            ?Container(): GlobalVariable.isLogins == true
                                            ? Positioned(
                                            top: 0,
                                            right:  180,
                                            child: profile(context,
                                                setState, profileViewModel))
                                            : Container(),
                                        ResponsiveWidget
                                            .isMediumScreen(context)
                                            ? Container():   GlobalVariable.isSearch == true
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


                                ),
                              ));
                        })
                    );
                  }));
        }));}
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

