import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/getAppBar.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utilities/SizeConfig.dart';
import '../WebScreen/LoginUp.dart';

@RoutePage()
class CartDetail extends StatefulWidget {
  final String? itemCount;
  Function? callback;

  CartDetail({Key? key, @PathParam('itemCount') this.itemCount, this.callback})
      : super(key: key);

  @override
  State<CartDetail> createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  CartViewModel cartViewData = CartViewModel();
  final validation = ValidationBloc();
  TextEditingController applyPromoCode = TextEditingController();
  String? checkInternet;
  int activeStep = 0;

  @override
  void initState() {
    SessionStorageHelper.removeValue('token');

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
              return Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: getAppBarWithBackBtn(
                      title: StringConstant.cartDetail,
                      context: context,
                      isBackBtn: false,
                      onBackPressed: () {
                        Navigator.pop(context);
                      }),
                  // appBar:getAppBar(context,homeViewModel,profileViewModel,cartViewData.cartItemCount, () async {
                  //   SharedPreferences sharedPreferences =
                  //   await SharedPreferences.getInstance();
                  //   token = sharedPreferences.getString('token').toString();
                  //   if (token == 'null') {
                  //     showDialog(
                  //         context: context,
                  //         barrierColor:
                  //         Theme.of(context).canvasColor.withOpacity(0.6),
                  //         builder: (BuildContext context) {
                  //           return LoginUp(
                  //             product: true,
                  //           );
                  //         });
                  //     // _backBtnHandling(prodId);
                  //   } else {
                  //     context.router.push(FavouriteListPage());
                  //   }
                  // },
                  //         ()async{
                  //       SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  //       token = sharedPreferences.getString('token').toString();
                  //       if (token == 'null'){
                  //         showDialog(
                  //             context: context,
                  //             barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
                  //             builder:
                  //                 (BuildContext context) {
                  //               return  LoginUp(
                  //                 product: true,
                  //               );
                  //             });
                  //       } else{
                  //         context.router.push(CartDetail(
                  //             itemCount: '${cartViewData.cartItemCount}'
                  //         ));
                  //       }}),
                  body: cartViewData.cartListData != null
                      ? cartViewData.cartListData!.cartList!.length > 0
                          ? ResponsiveWidget.isMediumScreen(context)
                              ? SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      cartPageViewIndicator(context, 0),
                                      SizedBox(height: 10),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: ListView.builder(
                                          itemCount: cartViewData.cartListData
                                                  ?.cartList?.length ??
                                              0,
                                          shrinkWrap: true,
                                          physics: ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final itemInCart = cartViewData
                                                .cartListData?.cartList?[index];
                                            return Container(
                                              color:
                                                  Theme.of(context).cardColor,
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 120,
                                                        width: 150,
                                                        margin: EdgeInsets.only(
                                                            top: 5,
                                                            right: 8,
                                                            bottom: 5),
                                                        child: Image.network(
                                                          fit: BoxFit.fill,
                                                          itemInCart
                                                                  ?.productDetails
                                                                  ?.productImages?[0] ??
                                                              "",
                                                        ),
                                                      ),

                                                      Container(
                                                        height: 30,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Theme.of(
                                                                        context)
                                                                    .canvasColor
                                                                    .withOpacity(
                                                                        0.2),
                                                                width: 1)),
                                                        margin: EdgeInsets.only(
                                                            left: 5,
                                                            top: 5,
                                                            right: 8,
                                                            bottom: 5),
                                                        child: Row(children: [
                                                          Expanded(
                                                            flex: 25,
                                                            child:
                                                                GestureDetector(
                                                              child: itemInCart
                                                                          ?.cartQuantity ==
                                                                      1
                                                                  ? Container(
                                                                      child:
                                                                          Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 18,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .canvasColor,
                                                                    ))
                                                                  : Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .canvasColor,
                                                                      size:
                                                                          18.0),
                                                              onTap: () async {
                                                                if (cartViewData
                                                                        .deactiveQuantity ==
                                                                    false) {
                                                                  cartViewData
                                                                          .deactiveQuantity =
                                                                      true;
                                                                  itemInCart
                                                                          ?.cartQuantity =
                                                                      (itemInCart.cartQuantity ??
                                                                              1) -
                                                                          1;
                                                                  if (itemInCart!
                                                                          .cartQuantity! >
                                                                      0) {
                                                                    cartViewData.addToCart(
                                                                        itemInCart.productId ??
                                                                            '',
                                                                        itemInCart
                                                                            .cartQuantity
                                                                            .toString(),
                                                                        itemInCart.productDetails?.variantId ??
                                                                            '',
                                                                        true,
                                                                        context,
                                                                        (result,
                                                                            isSuccess) {});
                                                                  } else {
                                                                    if (itemInCart
                                                                            .cartQuantity ==
                                                                        0)
                                                                      cartViewData.removeProductFromCart(
                                                                          context,
                                                                          itemInCart.productDetails?.variantId ??
                                                                              "",
                                                                          index);
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                              height: 30,
                                                              width: 1,
                                                              color: Theme.of(
                                                                      context)
                                                                  .canvasColor
                                                                  .withOpacity(
                                                                      0.2)),
                                                          Expanded(
                                                            flex: 50,
                                                            child: Container(
                                                                height: 24,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding: EdgeInsets.only(
                                                                    left: 20.0,
                                                                    right:
                                                                        20.0),
                                                                child: AppBoldFont(
                                                                    context,
                                                                    color: Theme
                                                                            .of(
                                                                                context)
                                                                        .canvasColor,
                                                                    msg: itemInCart
                                                                            ?.cartQuantity
                                                                            .toString() ??
                                                                        "",
                                                                    fontSize:
                                                                        16.0)),
                                                          ),
                                                          Container(
                                                              height: 30,
                                                              width: 1,
                                                              color: Theme.of(
                                                                      context)
                                                                  .canvasColor
                                                                  .withOpacity(
                                                                      0.2)),
                                                          Expanded(
                                                            flex: 25,
                                                            child:
                                                                GestureDetector(
                                                              child: Icon(
                                                                Icons.add,
                                                                size: 18.0,
                                                                color: Theme.of(
                                                                        context)
                                                                    .canvasColor,
                                                              ),
                                                              onTap: () {
                                                                if (cartViewData
                                                                        .activeQuantity ==
                                                                    false) {
                                                                  cartViewData
                                                                          .activeQuantity =
                                                                      true;
                                                                  itemInCart
                                                                          ?.cartQuantity =
                                                                      (itemInCart.cartQuantity ??
                                                                              1) +
                                                                          1;
                                                                  cartViewData.addToCart(
                                                                      itemInCart
                                                                              ?.productId ??
                                                                          '',
                                                                      itemInCart
                                                                              ?.cartQuantity
                                                                              .toString() ??
                                                                          '1',
                                                                      itemInCart
                                                                              ?.productDetails
                                                                              ?.variantId ??
                                                                          '',
                                                                      true,
                                                                      context,
                                                                      (result,
                                                                          isSuccess) {});
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ]),
                                                      ),
                                                      // Row(
                                                      //     children: [
                                                      //       GestureDetector(
                                                      //         child: itemInCart?.cartQuantity == 1
                                                      //             ? Card(
                                                      //           elevation: 3,
                                                      //           child: Container(
                                                      //               padding: const EdgeInsets.all(4.0),
                                                      //               child: Icon(Icons.delete, size: 20)),
                                                      //         )
                                                      //             : Card(
                                                      //           elevation:3,
                                                      //           child: Container(
                                                      //             height: 17,
                                                      //             width: 17,
                                                      //             padding: const EdgeInsets.all(1.0),
                                                      //             margin: const EdgeInsets.all(5.0),
                                                      //             decoration: BoxDecoration(
                                                      //               shape: BoxShape.circle,
                                                      //               color: Theme.of(context).canvasColor,
                                                      //             ),
                                                      //             child: Icon(Icons.remove, size: 13.0, color: WHITE_COLOR,
                                                      //             ),
                                                      //           ),
                                                      //         ),
                                                      //         onTap: () async {
                                                      //           if (cartViewData.deactiveQuantity == false) {
                                                      //             cartViewData.deactiveQuantity = true;
                                                      //             itemInCart?.cartQuantity = (itemInCart.cartQuantity ?? 1) - 1;
                                                      //             if (itemInCart!.cartQuantity! > 0) {
                                                      //               cartViewData.addToCart(itemInCart.productId ?? '',
                                                      //                   itemInCart.cartQuantity.toString(),
                                                      //                   itemInCart.productDetails?.variantId ?? '',
                                                      //                   true, context,
                                                      //                       (result, isSuccess) {});
                                                      //             } else {
                                                      //               if (itemInCart.cartQuantity == 0)
                                                      //                 cartViewData.removeProductFromCart(
                                                      //                     context,
                                                      //                     itemInCart.productDetails?.variantId ?? "", index);
                                                      //             }
                                                      //           }
                                                      //         },
                                                      //       ),
                                                      //       Container(
                                                      //           height:24,
                                                      //           alignment: Alignment.center,
                                                      //           color: Colors.grey.withOpacity(0.4),
                                                      //           padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                                      //           child: AppBoldFont(
                                                      //               context,
                                                      //               color: Theme.of(context).canvasColor,
                                                      //               msg: itemInCart?.cartQuantity.toString() ?? "",
                                                      //               fontSize: 16.0)),
                                                      //       GestureDetector(
                                                      //         child: Card(
                                                      //           elevation: 3,
                                                      //           child: Container(
                                                      //             height: 17,
                                                      //             width: 17,
                                                      //             padding: const EdgeInsets.all(1.0),
                                                      //             margin: const EdgeInsets.all(4.0),
                                                      //             decoration: BoxDecoration(
                                                      //               shape: BoxShape.circle,
                                                      //               color: Theme.of(context).canvasColor,),
                                                      //             child: Icon(
                                                      //               Icons.add,
                                                      //               size: 13.0,
                                                      //               color: WHITE_COLOR,
                                                      //             ),
                                                      //           ),
                                                      //         ),
                                                      //         onTap: () {
                                                      //           if (cartViewData.activeQuantity == false) {
                                                      //             cartViewData.activeQuantity = true;
                                                      //             itemInCart?.cartQuantity = (itemInCart.cartQuantity ?? 1) + 1;
                                                      //             cartViewData.addToCart(
                                                      //                 itemInCart?.productId ?? '',
                                                      //                 itemInCart?.cartQuantity.toString() ?? '1',
                                                      //                 itemInCart?.productDetails?.variantId ?? '',
                                                      //                 true, context,
                                                      //                     (result, isSuccess) {});
                                                      //           }
                                                      //         },
                                                      //       ),
                                                      //     ]),
                                                      SizedBox(height: 10)
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 15),
                                                      Container(
                                                        width: SizeConfig
                                                                .screenWidth *
                                                            0.50,
                                                        child: AppMediumFont(
                                                            color: Theme.of(
                                                                    context)
                                                                .canvasColor,
                                                            context,
                                                            msg: itemInCart
                                                                ?.productDetails
                                                                ?.productVariantTitle,
                                                            fontSize: 18.0),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          AppMediumFont(context,
                                                              msg: "₹" +
                                                                  " ${itemInCart?.productDetails?.productDiscountPrice}",
                                                              color: Theme.of(
                                                                      context)
                                                                  .canvasColor,
                                                              fontSize: 16.0),
                                                          SizedBox(
                                                            width: SizeConfig
                                                                    .safeBlockVertical *
                                                                1,
                                                          ),
                                                          AppMediumFont(context,
                                                              color: Theme.of(
                                                                      context)
                                                                  .canvasColor,
                                                              msg: itemInCart
                                                                      ?.productDetails
                                                                      ?.productPrice
                                                                      .toString() ??
                                                                  "",
                                                              textDecoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              fontSize: 12.0),
                                                          SizedBox(
                                                            width: SizeConfig
                                                                    .safeBlockVertical *
                                                                1,
                                                          ),
                                                          AppMediumFont(context,
                                                              msg:
                                                                  "${itemInCart?.productDetails?.productDiscountPercent}" +
                                                                      r" % OFF",
                                                              color: GREEN,
                                                              fontSize: 12.0),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      itemInCart
                                                          ?.productSelectedSku
                                                          ?.color
                                                          ?.name !=
                                                          null
                                                          ? AppMediumFont(
                                                          context,
                                                          maxLines: 1,
                                                          msg: "color" +
                                                              '- ${itemInCart?.productSelectedSku?.color?.name}',
                                                          color: Theme.of(
                                                              context)
                                                              .canvasColor,
                                                          fontSize:
                                                          16.0)
                                                          : SizedBox(),
                                                      itemInCart
                                                          ?.productSelectedSku
                                                          ?.size
                                                          ?.name !=
                                                          null
                                                          ? AppMediumFont(
                                                          context,
                                                          maxLines: 1,
                                                          msg: "size" +
                                                              '- ${itemInCart?.productSelectedSku?.size?.name}',
                                                          color: Theme.of(
                                                              context)
                                                              .canvasColor,
                                                          fontSize:
                                                          16.0)
                                                          : SizedBox(),
                                                      itemInCart
                                                          ?.productSelectedSku
                                                          ?.style
                                                          ?.name !=
                                                          null
                                                          ? AppMediumFont(
                                                          context,
                                                          maxLines: 1,
                                                          msg: "style" +
                                                              '- ${itemInCart?.productSelectedSku?.style?.name}',
                                                          color: Theme.of(
                                                              context)
                                                              .canvasColor,
                                                          fontSize:
                                                          16.0)
                                                          : SizedBox(),
                                                      itemInCart
                                                          ?.productSelectedSku
                                                          ?.materialType
                                                          ?.name !=
                                                          null
                                                          ? AppMediumFont(
                                                          context,
                                                          maxLines: 2,
                                                          msg: "MaterialType" +
                                                              '- ${itemInCart!.productSelectedSku!.materialType!.name!.length > 35 ? itemInCart.productSelectedSku?.materialType?.name!.replaceRange(35, itemInCart.productSelectedSku?.materialType?.name?.length, '...') : itemInCart.productSelectedSku?.materialType?.name ?? ""}',
                                                          color: Theme.of(
                                                              context)
                                                              .canvasColor,
                                                          fontSize:
                                                          16.0)
                                                          : SizedBox(),
                                                      itemInCart
                                                          ?.productSelectedSku
                                                          ?.unitCount
                                                          ?.name !=
                                                          null
                                                          ? AppMediumFont(
                                                          context,
                                                          color: Theme.of(
                                                              context)
                                                              .canvasColor,
                                                          maxLines: 1,
                                                          msg: "UnitCount" +
                                                              '- ${itemInCart?.productSelectedSku?.unitCount?.name}',
                                                          fontSize:
                                                          16.0)
                                                          : SizedBox(),
                                                      SizedBox(height: 15),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              cartViewData.removeProductFromCart(
                                                                  context,
                                                                  itemInCart
                                                                          ?.productDetails
                                                                          ?.variantId ??
                                                                      "",
                                                                  index);
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            2),
                                                              ),
                                                              child: AppRegularFont(
                                                                  context,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor,
                                                                  msg: StringConstant
                                                                      .remove,
                                                                  fontSize:
                                                                      14.0),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          Card(
                                            child: Column(
                                                children: cartViewData
                                                    .cartListData!
                                                    .checkoutDetails!
                                                    .map((e) {
                                              return Column(
                                                children: [
                                                  SizedBox(height: 8),
                                                  priceDetailWidget(
                                                      context,
                                                      e.name ?? "",
                                                      e.value ?? ""),
                                                  SizedBox(height: 8)
                                                ],
                                              );
                                            }).toList()),
                                          ),
                                          //billCardMobile(context, cartViewData),
                                          SizedBox(height: 10),
                                          (cartViewData.cartListData?.cartList
                                                              ?.length ??
                                                          0) >
                                                      0 &&
                                                  cartViewData.cartListData !=
                                                      null
                                              ? ChangeNotifierProvider<
                                                      CartViewModel>(
                                                  create:
                                                      (BuildContext context) =>
                                                          cartViewData,
                                                  child:
                                                      Consumer<CartViewModel>(
                                                          builder: (context,
                                                              cartViewData, _) {
                                                    return Container(
                                                      height: 50,
                                                      margin: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      width: SizeConfig
                                                          .screenWidth,
                                                      child: checkoutButton(
                                                          context,
                                                          StringConstant
                                                              .continueText,
                                                          cartViewData, () {
                                                        context.router.push(
                                                            AddressListPage(
                                                                buynow: false));
                                                        // GoRouter.of(context).pushNamed(RoutesName.AddressListPage);
                                                        // AppNavigator.push(
                                                        //     context,
                                                        //     AddressListPage(
                                                        //         checkOutData: cartViewData.cartListData),
                                                        //     screenName: RouteBuilder.AddressListPage);
                                                      }),
                                                    );
                                                  }))
                                              : SizedBox(
                                                  height: 1,
                                                ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      footerMobile(context)
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      cartPageViewIndicator(
                                        context,
                                        0,
                                      ),
                                      SizedBox(height: 10),
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
                                                final itemInCart = cartViewData
                                                    .cartListData
                                                    ?.cartList?[index];
                                                return Container(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: 200,
                                                            width: SizeConfig
                                                                    .screenWidth *
                                                                0.14,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    right: 8,
                                                                    bottom: 5),
                                                            child:
                                                                Image.network(
                                                              itemInCart
                                                                      ?.productDetails
                                                                      ?.productImages?[0] ??
                                                                  "",
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 30,
                                                            width: 120,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .canvasColor
                                                                        .withOpacity(
                                                                            0.2),
                                                                    width: 1)),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5,
                                                                    top: 5,
                                                                    right: 8,
                                                                    bottom: 5),
                                                            child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 25,
                                                                    child:
                                                                        GestureDetector(
                                                                      child: itemInCart?.cartQuantity ==
                                                                              1
                                                                          ? Container(
                                                                              child: Icon(Icons.delete, color: Theme.of(context).canvasColor, size: 18))
                                                                          : Icon(Icons.remove, color: Theme.of(context).canvasColor, size: 18.0),
                                                                      onTap:
                                                                          () async {
                                                                        if (cartViewData.deactiveQuantity ==
                                                                            false) {
                                                                          cartViewData.deactiveQuantity =
                                                                              true;
                                                                          itemInCart
                                                                              ?.cartQuantity = (itemInCart.cartQuantity ??
                                                                                  1) -
                                                                              1;
                                                                          if (itemInCart!.cartQuantity! >
                                                                              0) {
                                                                            cartViewData.addToCart(
                                                                                itemInCart.productId ?? '',
                                                                                itemInCart.cartQuantity.toString(),
                                                                                itemInCart.productDetails?.variantId ?? '',
                                                                                true,
                                                                                context,
                                                                                (result, isSuccess) {});
                                                                          } else {
                                                                            if (itemInCart.cartQuantity ==
                                                                                0)
                                                                              cartViewData.removeProductFromCart(context, itemInCart.productDetails?.variantId ?? "", index);
                                                                          }
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      height:
                                                                          30,
                                                                      width: 1,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .canvasColor
                                                                          .withOpacity(
                                                                              0.2)),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child: AppBoldFont(
                                                                        context,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        color: Theme.of(context)
                                                                            .canvasColor,
                                                                        msg: itemInCart?.cartQuantity.toString() ??
                                                                            "",
                                                                        fontSize:
                                                                            16.0),
                                                                  ),
                                                                  Container(
                                                                      height:
                                                                          30,
                                                                      width: 1,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .canvasColor
                                                                          .withOpacity(
                                                                              0.2)),
                                                                  Expanded(
                                                                    flex: 25,
                                                                    child:
                                                                        GestureDetector(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            18.0,
                                                                        color: Theme.of(context)
                                                                            .canvasColor,
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        if (cartViewData.activeQuantity ==
                                                                            false) {
                                                                          cartViewData.activeQuantity =
                                                                              true;
                                                                          itemInCart
                                                                              ?.cartQuantity = (itemInCart.cartQuantity ??
                                                                                  1) +
                                                                              1;
                                                                          cartViewData.addToCart(
                                                                              itemInCart?.productId ?? '',
                                                                              itemInCart?.cartQuantity.toString() ?? '1',
                                                                              itemInCart?.productDetails?.variantId ?? '',
                                                                              true,
                                                                              context,
                                                                              (result, isSuccess) {});
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                          SizedBox(height: 10)
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(height: 15),
                                                          Container(
                                                            width: SizeConfig
                                                                    .screenWidth *
                                                                0.15,
                                                            child: AppMediumFont(
                                                                color: Theme.of(
                                                                        context)
                                                                    .canvasColor,
                                                                context,
                                                                msg: itemInCart
                                                                    ?.productDetails
                                                                    ?.productVariantTitle,
                                                                fontSize: 18.0),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: SizeConfig
                                                                        .safeBlockVertical *
                                                                    1,
                                                              ),
                                                              AppMediumFont(
                                                                  context,
                                                                  color: Theme
                                                                          .of(
                                                                              context)
                                                                      .canvasColor,
                                                                  msg: "₹" +
                                                                      "${itemInCart?.productDetails?.productPrice}",
                                                                  textDecoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize:
                                                                      12.0),
                                                              SizedBox(
                                                                width: SizeConfig
                                                                        .safeBlockVertical *
                                                                    1,
                                                              ),
                                                              AppBoldFont(
                                                                  context,
                                                                  msg: "₹" +
                                                                      " ${itemInCart?.productDetails?.productDiscountPrice}",
                                                                  color: Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  fontSize:
                                                                      16.0),
                                                              SizedBox(
                                                                width: SizeConfig
                                                                        .safeBlockVertical *
                                                                    1,
                                                              ),
                                                              AppMediumFont(
                                                                  context,
                                                                  msg: "${itemInCart?.productDetails?.productDiscountPercent}" +
                                                                      r" % OFF",
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize:
                                                                      12.0),
                                                              SizedBox(
                                                                width: SizeConfig
                                                                        .safeBlockVertical *
                                                                    1,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5),
                                                          itemInCart
                                                                      ?.productSelectedSku
                                                                      ?.color
                                                                      ?.name !=
                                                                  null
                                                              ? AppMediumFont(
                                                                  context,
                                                                  maxLines: 1,
                                                                  msg: "color" +
                                                                      '- ${itemInCart?.productSelectedSku?.color?.name}',
                                                                  color: Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  fontSize:
                                                                      16.0)
                                                              : SizedBox(),
                                                          itemInCart
                                                                      ?.productSelectedSku
                                                                      ?.size
                                                                      ?.name !=
                                                                  null
                                                              ? AppMediumFont(
                                                                  context,
                                                                  maxLines: 1,
                                                                  msg: "size" +
                                                                      '- ${itemInCart?.productSelectedSku?.size?.name}',
                                                                  color: Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  fontSize:
                                                                      16.0)
                                                              : SizedBox(),
                                                          itemInCart
                                                                      ?.productSelectedSku
                                                                      ?.style
                                                                      ?.name !=
                                                                  null
                                                              ? AppMediumFont(
                                                                  context,
                                                                  maxLines: 1,
                                                                  msg: "style" +
                                                                      '- ${itemInCart?.productSelectedSku?.style?.name}',
                                                                  color: Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  fontSize:
                                                                      16.0)
                                                              : SizedBox(),
                                                          itemInCart
                                                                      ?.productSelectedSku
                                                                      ?.materialType
                                                                      ?.name !=
                                                                  null
                                                              ? AppMediumFont(
                                                                  context,
                                                                  maxLines: 2,
                                                                  msg: "MaterialType" +
                                                                      '- ${itemInCart!.productSelectedSku!.materialType!.name!.length > 35 ? itemInCart.productSelectedSku?.materialType?.name!.replaceRange(35, itemInCart.productSelectedSku?.materialType?.name?.length, '...') : itemInCart.productSelectedSku?.materialType?.name ?? ""}',
                                                                  color: Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  fontSize:
                                                                      16.0)
                                                              : SizedBox(),
                                                          itemInCart
                                                                      ?.productSelectedSku
                                                                      ?.unitCount
                                                                      ?.name !=
                                                                  null
                                                              ? AppMediumFont(
                                                                  context,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  maxLines: 1,
                                                                  msg: "UnitCount" +
                                                                      '- ${itemInCart?.productSelectedSku?.unitCount?.name}',
                                                                  fontSize:
                                                                      16.0)
                                                              : SizedBox(),
                                                          SizedBox(height: 15),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              cartViewData.removeProductFromCart(
                                                                  context,
                                                                  itemInCart
                                                                          ?.productDetails
                                                                          ?.variantId ??
                                                                      "",
                                                                  index);
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            2),
                                                              ),
                                                              child: AppRegularFont(
                                                                  context,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor,
                                                                  msg: StringConstant
                                                                      .remove,
                                                                  fontSize:
                                                                      14.0),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 5),
                                              Card(
                                                child: Column(
                                                    children: cartViewData
                                                        .cartListData!
                                                        .checkoutDetails!
                                                        .map((e) {
                                                  return Container(
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.30,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 8),
                                                        priceDetailWidget(
                                                            context,
                                                            e.name ?? "",
                                                            e.value ?? ""),
                                                        SizedBox(height: 8)
                                                      ],
                                                    ),
                                                  );
                                                }).toList()),
                                              ),
                                              //billCard(context, cartViewData),
                                              SizedBox(height: 10),
                                              Center(
                                                child: checkoutButton(
                                                    context,
                                                    StringConstant.continueText,
                                                    cartViewData, () {
                                                  context.router.push(
                                                      AddressListPage(
                                                          buynow: false));
                                                }),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      footerDesktop()
                                      // promoCodeView(),
                                      //    bill Card details
                                    ],
                                  ),
                                )
                          : Center(
                              child: noDataFoundMessage(
                                  context, StringConstant.noItemInCart))
                      : Center(
                          child:
                              Container(child: ThreeArchedCircle(size: 45.0)),
                        ));
            }));
  }
}
