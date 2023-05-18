import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utilities/SizeConfig.dart';


class CartDetail extends StatefulWidget {
  String? itemCount;
  Function? callback;

  CartDetail({Key? key, this.itemCount, this.callback}) : super(key: key);

  @override
  State<CartDetail> createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  final CartViewModel cartViewData = CartViewModel();
  final validation = ValidationBloc();
  TextEditingController applyPromoCode = TextEditingController();
  String? checkInternet;
  int activeStep = 0;

  @override
  void initState() {
    cartViewData.updateCartCount(context, widget.itemCount ?? '');
    cartViewData.getCartListData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: getAppBarWithBackBtn(
            title: "Cart Details",
            context: context,
            isBackBtn:false,
            onBackPressed: () {
              Navigator.pop(context, cartViewData.cartItemCount);
            }),
        // bottomNavigationBar:
        //     (cartViewData.cartListData?.cartList?.length ?? 0) > 0 &&
        //             cartViewData.cartListData != null
        //         ? ChangeNotifierProvider<CartViewModel>(
        //             create: (BuildContext context) => cartViewData,
        //             child: Consumer<CartViewModel>(
        //                 builder: (context, cartViewData, _) {
        //               return Container(
        //                 height: 60,
        //                 child: checkoutButton(
        //                     context, StringConstant.continueText, cartViewData,
        //                     () {
        //                   AppNavigator.push(
        //                       context,
        //                       AddressListPage(
        //                           checkOutData: cartViewData.cartListData),
        //                       screenName: RouteBuilder.AddressListPage);
        //                 }),
        //               );
        //             }))
        //         : SizedBox(
        //             height: 1,
        //           ),
        body:  ChangeNotifierProvider<CartViewModel>(
                create: (BuildContext context) => cartViewData,
                child: Consumer<CartViewModel>(
                    builder: (context, cartViewData, _) {
                  return WillPopScope(
                      onWillPop: _willPopCallback,
                      child: cartViewData.cartListData != null
                          ? cartViewData.cartListData!.cartList!.length > 0
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      cartPageViewIndicator(context, 0, activeStep),
                                      SizedBox(height: 10),
                                      //   items card
                                      Container(
                                        child: ListView.builder(
                                          itemCount: cartViewData.cartListData?.cartList?.length ?? 0,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final itemInCart = cartViewData.cartListData?.cartList?[index];
                                            return Card(
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
                                                          // AppNavigator.push(
                                                          //     context,
                                                          //     ProductDetailPage(
                                                          //       items: itemInCart,
                                                          //
                                                          //       itemCount: cartViewData.cartItemCount,
                                                          //     ),
                                                          //     screenName: RouteBuilder.productDetails,
                                                          //     function: (v) {
                                                          //   cartViewData.updateCartCount(context, v);
                                                          // });
                                                        },
                                                        child: Container(
                                                          height: 120,
                                                          width: SizeConfig.screenWidth * 0.4,
                                                          color: WHITE_COLOR,
                                                          margin: EdgeInsets.only(left: 5, top: 5, right: 8, bottom: 5),
                                                          child: Image.network(
                                                            itemInCart?.productDetails?.productImages?[0] ?? "",
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                          children: [
                                                        GestureDetector(
                                                          child: itemInCart?.cartQuantity == 1
                                                              ? Card(
                                                              elevation: 3,
                                                                child: Container(
                                                                    padding: const EdgeInsets.all(4.0),
                                                                    child: Icon(Icons.delete, size: 20)),
                                                              )
                                                              : Card(
                                                            elevation:3,
                                                                child: Container(
                                                                    height: 17,
                                                                    width: 17,
                                                                    padding: const EdgeInsets.all(1.0),
                                                                  margin: const EdgeInsets.all(5.0),
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: BLACK_COLOR,
                                                                    ),
                                                                    child: Icon(Icons.remove, size: 13.0, color: WHITE_COLOR,
                                                                    ),
                                                                  ),
                                                              ),
                                                          onTap: () async {
                                                            if (cartViewData.deactiveQuantity == false) {
                                                              cartViewData.deactiveQuantity = true;
                                                              itemInCart?.cartQuantity = (itemInCart.cartQuantity ?? 1) - 1;
                                                              if (itemInCart!.cartQuantity! > 0) {
                                                                cartViewData.addToCart(itemInCart.productId ?? '',
                                                                    itemInCart.cartQuantity.toString(),
                                                                    itemInCart.productDetails?.variantId ?? '',
                                                                    true, context,
                                                                    (result, isSuccess) {});
                                                              } else {
                                                                if (itemInCart.cartQuantity == 0)
                                                                  cartViewData.removeProductFromCart(
                                                                      context,
                                                                      itemInCart.productDetails?.variantId ?? "", index);
                                                              }
                                                            }
                                                          },
                                                        ),
                                                        Container(
                                                          height:24,
                                                          alignment: Alignment.center,
                                                          color: Colors.grey.withOpacity(0.4),
                                                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                                            child: AppBoldFont(
                                                                context,
                                                                color: BLACK_COLOR,
                                                                msg: itemInCart?.cartQuantity.toString() ?? "",
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
                                                                color: BLACK_COLOR,),
                                                              child: Icon(
                                                                Icons.add,
                                                                size: 13.0,
                                                                color: WHITE_COLOR,
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            if (cartViewData.activeQuantity == false) {
                                                              cartViewData.activeQuantity = true;
                                                              itemInCart?.cartQuantity = (itemInCart.cartQuantity ?? 1) + 1;
                                                              cartViewData.addToCart(
                                                                  itemInCart?.productId ?? '',
                                                                  itemInCart?.cartQuantity.toString() ?? '1',
                                                                  itemInCart?.productDetails?.variantId ?? '',
                                                                  true, context,
                                                                  (result, isSuccess) {});
                                                            }
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
                                                      AppMediumFont(
                                                          color: BLACK_COLOR,
                                                          context,
                                                          msg: itemInCart?.productName,
                                                          fontSize: 16.0),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          AppMediumFont(context,
                                                              msg: "₹" + " ${itemInCart?.productDetails?.productDiscountPrice}",
                                                              color: BLACK_COLOR,
                                                              fontSize: 16.0),
                                                          SizedBox(
                                                            width: SizeConfig.safeBlockVertical * 1,
                                                          ),
                                                          AppMediumFont(context,
                                                              color: BLACK_COLOR,
                                                              msg: itemInCart?.productDetails?.productPrice.toString() ?? "",
                                                              textDecoration: TextDecoration.lineThrough,
                                                              fontSize: 12.0),
                                                          SizedBox(
                                                            width: SizeConfig.safeBlockVertical * 1,
                                                          ),
                                                          AppMediumFont(context,
                                                              msg: "${itemInCart?.productDetails?.productDiscountPercent}" + r" % OFF",
                                                              color: Colors.green,
                                                              fontSize: 12.0),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      AppMediumFont(context,
                                                          color: BLACK_COLOR,
                                                          msg: "Color : " +(itemInCart?.productDetails?.productColor ?? ""),
                                                          fontSize: 13.0),
                                                      SizedBox(height: 5),
                                                      AppMediumFont(context,
                                                          color: BLACK_COLOR,
                                                          msg: "Size : " + (itemInCart?.productDetails?.productSize ?? ''),
                                                          fontSize: 13.0),
                                                      SizedBox(height: 15),
                                                      Row(
                                                        children: [
                                                          // GestureDetector(
                                                          //   onTap: () {
                                                          //     cartViewData.addToFavourite(
                                                          //         context,
                                                          //         "${cartViewData.cartListData?.cartList?[index].productId}",
                                                          //         "${cartViewData.cartListData?.cartList?[index].productDetails?.productColorId}",
                                                          //         cartViewData
                                                          //                     .cartListData
                                                          //                     ?.cartList?[index]
                                                          //                     .productDetails
                                                          //                     ?.isFavorite ==
                                                          //                 true
                                                          //             ? false
                                                          //             : true,
                                                          //         'cartDetail',listIndex: index);
                                                          //   },
                                                          //   child: Container(
                                                          //     padding:
                                                          //         EdgeInsets
                                                          //             .all(5),
                                                          //     decoration:
                                                          //         BoxDecoration(
                                                          //             borderRadius:
                                                          //                 BorderRadius.circular(
                                                          //                     8),
                                                          //             color:
                                                          //             // cartViewData.cartListData?.cartList?[index].productDetails?.isFavorite ==
                                                          //             //         true
                                                          //             //     ? RED_COLOR
                                                          //             //     :
                                                          //             WHITE_COLOR,
                                                          //             border:
                                                          //                 Border
                                                          //                     .all(
                                                          //               width:
                                                          //                   1,
                                                          //               color:
                                                          //                   BLACK_COLOR,
                                                          //             )),
                                                          //     child: AppRegularFont(
                                                          //         context,
                                                          //         color:
                                                          //             BLACK_COLOR,
                                                          //         msg: StringConstant
                                                          //             .wishlist,
                                                          //         fontSize:
                                                          //             14.0),
                                                          //   ),
                                                          // ),
                                                          // SizedBox(width: 10),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              cartViewData.removeProductFromCart(
                                                                  context,
                                                                  itemInCart?.productDetails?.variantId ??"",
                                                                  index);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      border: Border.all(
                                                                        width: 1,
                                                                        color: BLACK_COLOR,
                                                                      )),
                                                              child: AppRegularFont(
                                                                  context,
                                                                  color: BLACK_COLOR,
                                                                  msg: "remove",
                                                                  fontSize: 14.0),
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
                                      SizedBox(height: 2),
                                      promoCodeView(),
                                      //    bill Card details
                                      billCard(context, cartViewData)
                                    ],
                                  ),
                                )
                              : Center(
                                  )
                          : Center(
                              child: Container(
                                  child: ThreeArchedCircle(size: 45.0)),
                            ));
                })));
  }

  promoCodeView() {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5,top: 10),
      padding: EdgeInsets.only(left: 5, right: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
               // margin: const EdgeInsets.all(10),
                width: SizeConfig.screenWidth * 0.65,
                height: 80,
                alignment: Alignment.center,
                child: StreamBuilder(builder: (context, snapshot) {
                  return AppTextField(
                    maxLine: 1,
                    controller: applyPromoCode,
                    labelText: "applyPromoCode",
                    textCapitalization: TextCapitalization.words,
                    isShowCountryCode: true,
                    isShowPassword: false,
                    secureText: false,
                    maxLength: 30,
                    keyBoardType: TextInputType.name,
                    errorText:
                        snapshot.hasError ? snapshot.error.toString() : null,
                    onChanged: (m) {
                      validation.sinkFirstName.add(m);
                      setState(() {});
                    },
                    onSubmitted: (m) {},
                    isTick: null,
                  );
                }),
              ),
              ElevatedButton(
                child: AppBoldFont(context,
                    msg: "applyCodebutton", fontSize: 14.0),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).canvasColor,
            thickness: 1,
          ),
          TextButton(
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ApplyPromocode()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBoldFont(context,
                    msg:" viewAllCoupon", fontSize: 14.0),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Theme.of(context).canvasColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context, cartViewData.cartItemCount);
    return Future.value(true);
  }
}
Widget cartPageViewIndicator(BuildContext context,int pageIndex,int activeStep){
  return Container(
    child: EasyStepper(
      activeStep: pageIndex,
      lineLength: SizeConfig.screenWidth * 0.18,
      lineSpace: 0,
      lineType: LineType.normal,
      defaultLineColor: Colors.white,
      finishedStepBackgroundColor: Theme.of(context).primaryColor ,
      activeStepBackgroundColor: Theme.of(context).primaryColor,
      finishedLineColor: Theme.of(context).primaryColor,
      activeStepTextColor: Theme.of(context).canvasColor,
      finishedStepTextColor: Theme.of(context).primaryColor,
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: 13,
      showStepBorder: false,
      lineDotRadius: 1.5,
      steps: [
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 7,
              backgroundColor: activeStep >= 0
                  ? Theme.of(context).primaryColor
                  : Colors.white,
            ),
          ),
          title: 'My Cart',
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 7,
              backgroundColor: activeStep >= 1
                  ? Theme.of(context)
                  .primaryColor
                  : Colors.white,
            ),
          ),
          title: 'Choose Address',
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 7,
              backgroundColor: activeStep >= 2
                  ? Theme.of(context)
                  .primaryColor
                  : Colors.white,
            ),
          ),
          title: 'Payment',
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 7,
              backgroundColor: activeStep >= 3
                  ? Theme.of(context)
                  .primaryColor
                  : Colors.white,
            ),
          ),
          title: 'Order Placed',
        ),
      ],
      onStepReached: (index) {
        activeStep = index;
      },
    ),
  ) ;
}
//PriceDetailWidget Method
Widget priceDetailWidget(BuildContext context,String str1, String val) {
  return Container(
    padding: EdgeInsets.only(left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppRegularFont(context, msg: str1, fontSize: 16.0),
        AppRegularFont(context, msg: val, fontSize: 16.0)
      ],
    ),
  );
}

//BillCard Method
Widget billCard(BuildContext context,CartViewModel cartViewData){
  return  Card(
    child: Column(
      children: [
        SizedBox(height: 8),
        priceDetailWidget(context,StringConstant.totalItems,cartViewData.cartListData?.checkoutDetails?.totalItems.toString() ?? ''),
        SizedBox(height: 8),
        priceDetailWidget(context,StringConstant.basePrice,"₹ " +
            (cartViewData.cartListData?.checkoutDetails?.cartTotalPrice.toString() ?? '')),
        SizedBox(height: 8),
        priceDetailWidget(context,StringConstant.discountedPrice, "₹ " +
            (cartViewData.cartListData?.checkoutDetails?.discountedPrice.toString() ?? "")),
        SizedBox(height: 8),
        priceDetailWidget(context,StringConstant.shipping,"₹ " +
            (cartViewData.cartListData?.checkoutDetails?.deliveryCharge.toString() ?? "")),
        SizedBox(height: 8),
        Divider(height: 1, color: Theme.of(context).canvasColor,),
        SizedBox(height: 8),
        priceDetailWidget(context,StringConstant.amountPayable,"₹" + (cartViewData.cartListData?.checkoutDetails?.totalPayableAmount.toString() ?? "")),
        SizedBox(height: 8)
      ],
    ),
  );
}