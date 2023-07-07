import 'dart:convert';

import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../AppRouter.gr.dart';


@RoutePage()
class BuynowCart extends StatefulWidget {
  BuynowCart({Key? key}) : super(key: key);

  @override
  State<BuynowCart> createState() => _BuynowCartState();
}

class _BuynowCartState extends State<BuynowCart> {
  final validation = ValidationBloc();
  String? checkInternet;
  int activeStep = 0;
  CartListDataModel? cartListData;
  final CartViewModel cartViewData = CartViewModel();
  @override
  void initState() {
    Map<String, dynamic> json = jsonDecode(SessionStorageHelper.getValue("token").toString());
   cartListData = CartListDataModel.fromJson(json);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: getAppBarWithBackBtn(
            title: StringConstant.cartDetail,
            context: context,
            isBackBtn: false,
            onBackPressed: () {
              Navigator.pop(context);
            }),

        body: checkInternet == "Offline"
            ? NOInternetScreen()
            : Container(
                child: Column(
                  children: [
                    cartPageViewIndicator(context, 0, activeStep),
                    Container(
                      width: SizeConfig.screenWidth/3,
                      child: Card(
                        color: WHITE_COLOR,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                  },
                                  child: Container(
                                    height: 120,
                                    width: 120,
                                    color: WHITE_COLOR,
                                    margin: EdgeInsets.only(
                                        left: 5, top: 5, right: 8, bottom: 5),
                                    child: Image.network(
                                        cartListData?.cartList?[0].productDetails?.productImages?[0] ?? ""
                                      // cartdata['cartList'][0]['productDetails']['productImages'][0]
                                      // widget.cartListData?.cartList?[0].productDetails?.productImages?[0] ??
                                      //     "",
                                    ),
                                  ),
                                ),
                                Row(children: [
                                  GestureDetector(
                                    child: Card(
                                      elevation: 3,
                                      child: Container(
                                        height: 17,
                                        width: 17,
                                        padding: const EdgeInsets.all(1.0),
                                        margin: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: BLACK_COLOR,
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          size: 13.0,
                                          color: WHITE_COLOR,
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      // if (cartViewData.deactiveQuantity == false) {
                                      //   cartViewData.deactiveQuantity = true;
                                      //   itemInCart?.cartQuantity = (itemInCart.cartQuantity ?? 1) - 1;
                                      //   if (itemInCart!.cartQuantity! > 0) {
                                      //     cartViewData.addToCart(itemInCart.productId ?? '',
                                      //         itemInCart.cartQuantity.toString(),
                                      //         itemInCart.productDetails?.variantId ?? '',
                                      //         true, context,
                                      //             (result, isSuccess) {});
                                      //   } else {
                                      //     if (itemInCart.cartQuantity == 0)
                                      //       cartViewData.removeProductFromCart(
                                      //           context,
                                      //           itemInCart.productDetails?.variantId ?? "", index);
                                      //   }
                                      // }
                                      if(cartListData?.checkoutDetails?.totalItems!=1){
                                       cartListData?.checkoutDetails?.totalItems=(cartListData?.checkoutDetails?.totalItems ?? 1) -1;
                                        cartViewData.buyNow(
                                            cartListData?.cartList?[0].productId ??"",
                                           cartListData!.checkoutDetails!.totalItems.toString(), cartListData?.cartList?[0].productDetails?.variantId,
                                            false, context);
                                      }

                                    },
                                  ),
                                  Container(
                                      height: 24,
                                      alignment: Alignment.center,
                                      color: Colors.grey.withOpacity(0.4),
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: AppBoldFont(context,
                                          color: BLACK_COLOR,
                                          msg:cartListData?.checkoutDetails?.totalItems.toString()

                                          //cartdata['checkoutDetails']['totalItems'].toString()
                                         // widget.cartListData?.checkoutDetails?.totalItems.toString() ??
                                              ,
                                          fontSize: 16.0)),
                                  GestureDetector(
                                    child: Card(
                                      elevation: 3,
                                      child: Container(
                                        height: 17,
                                        width: 17,
                                        padding: const EdgeInsets.all(1.0),
                                        margin: const EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: BLACK_COLOR,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 13.0,
                                          color: WHITE_COLOR,
                                        ),
                                      ),
                                    ),
                                    onTap: () {

                                       cartListData?.checkoutDetails?.totalItems=(cartListData?.checkoutDetails?.totalItems ?? 1)+1;
                                        cartViewData.buyNow(
                                            cartListData?.cartList?[0].productId ??"",
                                         cartListData!.checkoutDetails!.totalItems.toString(),cartListData?.cartList?[0].productDetails?.variantId,
                                            false, context);

                                    },
                                  ),
                                ]),
                                SizedBox(height: 10)
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15),
                                Container(
                                  width: SizeConfig.screenWidth /4,
                                  child: AppMediumFont(
                                      color: BLACK_COLOR,
                                      context,
                                      msg:cartListData?.cartList?[0].productName,
                                     // cartdata['cartList'][0]['productName'],
                                     // widget.cartListData?.cartList?[0].productName,
                                      fontSize: 16.0),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    AppMediumFont(context,
                                        msg: "₹" +

                                             " ${cartListData?.cartList?[0].productDetails?.productDiscountPrice}",
                                        color: BLACK_COLOR,
                                        fontSize: 16.0),
                                    SizedBox(
                                      width:10,
                                    ),
                                    AppMediumFont(context,
                                        color: BLACK_COLOR,
                                        msg: "₹" +
                                            "${cartListData?.cartList?[0].productDetails!.productPrice.toString()}",

                                        textDecoration:
                                            TextDecoration.lineThrough,
                                        fontSize: 12.0),
                                    SizedBox(
                                      width: SizeConfig.safeBlockVertical * 1,
                                    ),
                                    AppMediumFont(context,
                                        msg:
                                            "${cartListData?.cartList?[0].productDetails?.productDiscountPercent}"
                                                +
                                                r" % OFF",
                                        color:Colors.green,
                                        fontSize: 12.0),
                                  ],
                                ),
                                cartListData?.cartList?[0].productDetails?.defaultVariationSku?.color?.name !=
                                        null
                                    ? AppMediumFont(context,
                                        maxLines: 1,
                                        msg: "color" +
                                            ' - '+ (cartListData?.cartList?[0].productDetails?.defaultVariationSku?.color?.name ?? ""),
                                        color: BLACK_COLOR,
                                        fontSize: 14.0)
                                    : SizedBox(),
                                cartListData?.cartList?[0].productDetails?.defaultVariationSku?.size?.name !=
                                        null
                                    ? AppMediumFont(context,
                                        maxLines: 1,
                                        msg: "size" +
                                            ' - '+ (cartListData?.cartList?[0].productDetails?.defaultVariationSku?.size?.name ?? ""),
                                        color: BLACK_COLOR,
                                        fontSize: 14.0)
                                    : SizedBox(),
                                cartListData?.cartList?[0].productDetails?.defaultVariationSku?.style?.name !=
                                        null
                                    ? AppMediumFont(context,
                                        maxLines: 1,
                                        msg: "style" +
                                            ' - '+ (cartListData?.cartList?[0].productDetails?.defaultVariationSku?.style?.name ?? ""),
                                        color: BLACK_COLOR,
                                        fontSize: 14.0)
                                    : SizedBox(),
                                cartListData?.cartList?[0].productDetails?.defaultVariationSku?.materialType?.name!=
                                        null
                                    ? AppMediumFont(context,
                                        maxLines: 2,
                                        msg: "MaterialType" +
                                            '- ${cartListData!.cartList![0].productDetails!.defaultVariationSku!.materialType!.name!.length > 35 ? cartListData!.cartList![0].productDetails!.defaultVariationSku!.materialType?.name!.replaceRange(35, cartListData?.cartList?[0].productDetails!.defaultVariationSku!.materialType?.name?.length, '...') : cartListData?.cartList?[0].productDetails!.defaultVariationSku!.materialType?.name ?? ""}',
                                        color: BLACK_COLOR,
                                        fontSize: 14.0)
                                    : SizedBox(),
                            cartListData
                                            ?.cartList?[0]
                                            .productDetails
                                            ?.defaultVariationSku
                                            ?.unitCount
                                            ?.name !=
                                        null
                                    ? AppMediumFont(context,
                                        color: BLACK_COLOR,
                                        maxLines: 1,
                                        msg: "UnitCount" +
                                            '- ${cartListData?.cartList?[0].productDetails?.defaultVariationSku?.unitCount?.name}',
                                        fontSize: 14.0)
                                    : SizedBox(),
                                SizedBox(height: 15),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth/3,
                      child: Card(
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            priceDetailWidget(
                                context,
                                StringConstant.totalItems,
                               cartListData?.checkoutDetails?.totalItems
                                        .toString() ??
                                    ''),
                            SizedBox(height: 8),
                            priceDetailWidget(
                                context,
                                StringConstant.basePrice,
                                "₹ " +
                                    (cartListData?.checkoutDetails
                                            ?.cartTotalPrice
                                            .toString() ??
                                        '')),
                            SizedBox(height: 8),
                            priceDetailWidget(
                                context,
                                StringConstant.discountedPrice,
                                "₹ " +
                                    (cartListData?.checkoutDetails
                                            ?.discountedPrice
                                            .toString() ??
                                        "")),
                            SizedBox(height: 8),
                            priceDetailWidget(
                                context,
                                StringConstant.shipping,
                                "₹ " +
                                    (cartListData?.checkoutDetails
                                            ?.deliveryCharge
                                            .toString() ??
                                        "")),
                            SizedBox(height: 8),
                            Divider(
                              height: 1,
                              color: Theme.of(context).canvasColor,
                            ),
                            SizedBox(height: 8),
                            priceDetailWidget(
                                context,
                                StringConstant.amountPayable,
                                "₹" +
                                    (cartListData?.checkoutDetails
                                            ?.totalPayableAmount
                                            .toString() ??
                                        "")),
                            SizedBox(height: 8)
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: 60,
                        decoration:BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(4)
                        ) ,
                        width: SizeConfig.screenWidth/5.2,
                        child: Row(
                          children: [
                            Container(
                              width: SizeConfig.screenWidth*0.08,
                              padding: EdgeInsets.all(20),
                              child: AppMediumFont(context,
                                  msg: StringConstant.total +
                                      "₹"+
                                      (cartListData?.checkoutDetails?.totalPayableAmount.toString() ?? ""),
                                  //     ""),
                                  fontSize: 14.0),
                            ),
                            Container(
                              width: SizeConfig.screenWidth/9,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  context.router.push(
                                      AddressListPage(
                                        buynow: true
                                      )
                                  );
                                },
                                child: Center(
                                    child: AppMediumFont(context,
                                        msg: "CONTINUE",
                                        fontSize: 15.0,
                                        color: Colors.white)),
                              ),
                              height: SizeConfig.safeBlockVertical * 6,
                            ),
                          ],
                        )),
                  ],
                ),
              ));
  }

  Future<bool> _willPopCallback() async {
    // Navigator.pop(context, cartViewData.cartItemCount);
    return Future.value(true);
  }
}
