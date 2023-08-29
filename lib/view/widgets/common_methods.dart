
import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/Products/image_slider.dart';
import 'package:TychoStream/view/Products/shipping_address_page.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/OnHover.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonMethods {

  // break the given urls
  static Future<Uri> breakUrls(String url) async {
    var mappedUrl = Uri.parse(url);
    return mappedUrl;
  }
}

Widget cartPageViewIndicator(BuildContext context,int activeStep) {
  return Container(
      margin: EdgeInsets.only(bottom: 10,left: ResponsiveWidget.isMediumScreen(context)
          ?16:SizeConfig.screenHeight*0.40,right: ResponsiveWidget.isMediumScreen(context)
          ?16:SizeConfig.screenHeight*0.40,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          stepView(context,"Step 1 \n${StringConstant.myCart}",activeStep,0),
          Icon(Icons.arrow_forward_ios_sharp, size: 10,    color: activeStep >= 0
              ? Theme.of(context).primaryColor
              : Theme.of(context).canvasColor.withOpacity(0.8)),
          stepView(context,"Step 2 \n${StringConstant.payment}",activeStep,1),
          Icon(Icons.arrow_forward_ios_sharp, size: 10,    color: activeStep >= 2
              ? Theme.of(context).primaryColor
              : Theme.of(context).canvasColor.withOpacity(0.8),),
          stepView(context,"Step 3 \n${StringConstant.orderPlaced}",activeStep,2),
        ],
      )

  );
}

Widget stepView(BuildContext context,String title,int activeStep,int index){
  return AppBoldFont(context,
      msg: title,fontWeight: FontWeight.w600,
      color: activeStep >= index
          ? Theme.of(context).primaryColor
          : Theme.of(context).canvasColor.withOpacity(0.8),
      fontSize:ResponsiveWidget.isMediumScreen(context)
          ?14: 16);
}
//PriceDetailWidget Method
Widget priceDetailWidget(BuildContext context, String str1, String val) {
  return Container(
    padding: EdgeInsets.only(left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        str1 == "Total Amount"
            ? AppBoldFont(context,
            msg: str1 + ":", fontSize: 16.0, color: Theme.of(context).canvasColor)
            : AppRegularFont(context,
            msg: str1 + ":", fontSize: 16.0, color: Theme.of(context).canvasColor),
        str1 == "Total Amount"
            ? AppBoldFont(context,
            msg: "₹" + val,
            fontSize: 16.0,
            color: Theme.of(context).canvasColor.withOpacity(0.9))
            : AppRegularFont(context,
            msg: (str1 == "Total items" ? "" : "₹") + val,
            fontSize: 16.0,
            color: str1.contains("Discount")
                ? Colors.green
                :Theme.of(context).canvasColor.withOpacity(0.8))
      ],
    ),
  );
}

//CheckOut button
Widget checkoutButton(BuildContext context,String msg,CartViewModel cartViewData,  VoidCallback? onTap,){
  return Container(
    alignment: Alignment.center,
    width:SizeConfig.screenWidth*0.24,
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
     borderRadius: BorderRadius.circular(4)
    ),
    child: InkWell(
      onTap: onTap,
      child: Center(
          child: AppMediumFont(context, msg: msg, fontSize: 16.0,color: Theme.of(context).hintColor)),
    ),
    height: 50,
  );
}

Widget profile(BuildContext context,setState,ProfileViewModel profileViewModel){
  final authVM = Provider.of<AuthViewModel>(context);
  return Container(
    width: 150,
    color: Theme.of(context).cardColor,
    child: Column(
      children: [
        SizedBox(height: 5),
        appTextButton(
            context,
            StringConstant.myAccount,
            Alignment.centerLeft,
            Theme.of(context).canvasColor,
            18,
            false, onPressed: () {
          isProfile = true;
          if (isProfile == true) {
            context.pushRoute(EditProfile());
            isLogins = false;
          }
        }),
        SizedBox(height: 5),
        Container(
          height: 1,
          color: Colors.black,
        ),
        appTextButton(
            context,
           StringConstant.myOrder,
            Alignment.centerLeft,
            Theme.of(context).canvasColor,
            18,
            false, onPressed: () {
          isProfile = true;
          if (isProfile == true) {
            context.pushRoute(MyOrderPage());
            isLogins = false;

          }
        }),
        SizedBox(height: 5),
        Container(
          height: 1,
          color: Colors.black,
        ),
        SizedBox(height: 5),
        appTextButton(
            context,
            StringConstant.logout,
            Alignment.centerLeft,
            Theme.of(context).canvasColor,
            18,
            false, onPressed: () {
          setState(() {
            authVM.logoutButtonPressed(context);
            context.router.stack.clear();
            context.router.dispose();

            isLogins = false;
            if (isSearch == true) {
              isSearch = false;
              setState(() {});
            }
          });
        }),
        SizedBox(height: 5),
      ],
    ),
    // height: 20,width: 20,
  );

}

String? getFavTitle(ProductList? productListData) {
  if (productListData!.productDetails!.productVariantTitle!.length > 40) {
    return productListData.productDetails?.productVariantTitle?.replaceRange(
        40, productListData.productDetails?.productVariantTitle?.length, '...');
  } else {
    return productListData.productDetails?.productVariantTitle ?? "";
  }
}

String? getNameTitle(ProductList? productListData) {
  if (productListData!.productName!.length > 40) {
    return productListData.productName
        ?.replaceRange(40, productListData.productName?.length, '...');
  } else {
    return productListData.productName;
  }
}

Widget productGalleryTitleSection(BuildContext context, ProductList? productListData, bool favbourite) {
  return Container(
    height: 60,
    padding: const EdgeInsets.only(
      left: 8.0,
      top: 8,
      right: 8.0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppBoldFont(
          context,
          maxLines: 1,
          msg: favbourite == true
              ? getFavTitle(productListData) ?? ''
              : getNameTitle(productListData) ?? '',
          fontSize: 18.0,
        ),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FittedBox(
                child: AppMediumFont(context,
                    msg: "₹" '${productListData?.productDetails?.productPrice}',
                    fontSize:
                    ResponsiveWidget.isMediumScreen(context) ? 14 : 18.0,
                    color: Theme.of(context).canvasColor.withOpacity(0.6),
                    textDecoration: TextDecoration.lineThrough)),
            SizedBox(width: 4.0),
            FittedBox(
                child: AppMediumFont(
                  context,
                  color: Theme.of(context).canvasColor.withOpacity(0.9),
                  msg: "₹"
                      '${productListData?.productDetails?.productDiscountPrice}',
                  fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 18.0,
                )),
            SizedBox(width: 4.0),
            FittedBox(
                child: AppMediumFont(context,
                    fontSize:
                    ResponsiveWidget.isMediumScreen(context) ? 14 : 16.0,
                    msg:
                    '${productListData?.productDetails?.productDiscountPercent}' +
                        '%OFF',
                    color: GREEN)),
          ],
        ),
        SizedBox(height: 3)
      ],
    ),
  );
}

//ProductListItems
Widget productListItems(BuildContext context, ProductList? productListData, int index, CartViewModel viewmodel,{bool? favouritepage}) {
  return

    OnHover(
    builder: (isHovered) {
      return InkWell(
          onTap: () { if (isLogins == true) {
            isLogins = false;
          }
          if (isSearch == true) {
            isSearch = false;
          }
            context.router.push(
              ProductDetailPage(
                productName: '${productListData?.productName?.replaceAll(' ', '')}',
                productdata: [
                '${productListData?.productId}',
                  '${viewmodel.cartItemCount}',
                  '${productListData?.productDetails?.defaultVariationSku?.size?.name}',
                  '${productListData?.productDetails?.defaultVariationSku?.color?.name}',
                  '${productListData?.productDetails?.defaultVariationSku?.style?.name}',
                  '${productListData?.productDetails?.defaultVariationSku?.unitCount?.name}',
                  '${productListData?.productDetails?.defaultVariationSku?.materialType?.name}',
                ],
              ),
            );
          },
          child: Container(
            decoration: isHovered == true
                ? BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color:
                  Theme.of(context).canvasColor.withOpacity(0.15),
                  blurRadius: 10.0,
                  spreadRadius: 7,
                  offset: Offset(2, 2),
                ),
                BoxShadow(
                  color:
                  Theme.of(context).canvasColor.withOpacity(0.12),
                  blurRadius: 7.0,
                  spreadRadius: 5,
                  offset: Offset(2, 2),
                ),
                BoxShadow(
                  color:
                  Theme.of(context).canvasColor.withOpacity(0.10),
                  blurRadius: 4.0,
                  spreadRadius: 3,
                  offset: Offset(2, 2),
                ),
                BoxShadow(
                  color:
                  Theme.of(context).canvasColor.withOpacity(0.09),
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                  offset: Offset(2, 2),
                ),
              ],
            )
                : BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            margin: EdgeInsets.only(right: ResponsiveWidget
                .isMediumScreen(
                context)
                ?0: 16),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ImageSlider(
                      images: productListData?.productDetails?.productImages,
                    ),
                    productGalleryTitleSection(context, productListData, true)
                  ],
                ),
                Positioned(
                    top: 1,right: -5,
                    child: IconButton(
                      iconSize: 40,
                      icon: Image.asset(
                        productListData?.productDetails?.isFavorite == true
                            ? AssetsConstants.ic_wishlistSelect
                            : AssetsConstants.ic_wishlistUnselect,
                      ),
                      onPressed: ()   async {
                        if (isLogins == true) {
                          isLogins = false;
                        }
                        if (isSearch == true) {
                          isSearch = false;
                        }
                        SharedPreferences sharedPreferences = await SharedPreferences
                            .getInstance();
                        if (sharedPreferences.getString('token') == null) {
                          showDialog(
                              context: context,
                              builder:
                                  (BuildContext context) {
                                return LoginUp(
                                  product: true,
                                );
                              });
                        }
                        else {
                          final isFav =
                          productListData!.productDetails!.isFavorite =
                          !productListData.productDetails!.isFavorite!;
                          viewmodel.addToFavourite(
                              context,
                              "${productListData.productId}",
                              "${productListData.productDetails?.variantId}",
                              isFav,
                              'productList',favouritepage: favouritepage);
                        }
                      }

                    ))
              ],
            ),
          ));
    },
    hovered: Matrix4.identity()..translate(0, 0, 0),
  );
}

Widget  cardDeatils(BuildContext context,ProductList itemInCart,int index,CartViewModel cartViewData){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height:  ResponsiveWidget.isMediumScreen(context)
                ? 120 : 200,
            width: ResponsiveWidget.isMediumScreen(context)
                ? 120  :SizeConfig
                .screenWidth *
                0.11,
            margin:
            EdgeInsets.only(
                top: 12,
                right: 8,
                left:12,
                bottom: 5),
            child:
            Image.network(
              itemInCart.productDetails?.productImages?[0] ?? "",
              fit: BoxFit.fill,

            ),
          ),
          Container(
            height: 30,
  width: ResponsiveWidget.isMediumScreen(context)
  ? 120  :SizeConfig
      .screenWidth *
  0.11,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).canvasColor.withOpacity(0.2),
                    width: 1)),
            margin:
            EdgeInsets.only(
                left:  12,
                top: 5,
                right: 8,
                bottom: 5),
            child: Row(
                children: [
                  Expanded(
                    flex: 25,
                    child:
                    GestureDetector(
                      child: itemInCart.cartQuantity ==
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
                          itemInCart.cartQuantity = (itemInCart.cartQuantity ?? 1) - 1;
                          if (itemInCart.cartQuantity! >
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
                        msg: itemInCart.cartQuantity.toString() ,
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
                            if (cartViewData.activeQuantity == false) {
                              if ((itemInCart.productDetails?.quantityLeft)! >
                                  (itemInCart.cartQuantity ?? 1)) {
                                cartViewData.activeQuantity = true;
                                itemInCart.cartQuantity =
                                    (itemInCart.cartQuantity ?? 1) + 1;
                                cartViewData.addToCart(
                                    itemInCart.productId ?? '',
                                    itemInCart.cartQuantity.toString() ?? '1',
                                    itemInCart.productDetails?.variantId ?? '',
                                    true,
                                    context,
                                        (result, isSuccess) {});
                              } else {
                                ToastMessage.message(
                                    "Sorry only ${itemInCart.productDetails?.quantityLeft} quantity is left.",context);
                              }
                            }
                        // if (cartViewData.activeQuantity ==
                        //     false) {
                        //   cartViewData.activeQuantity =
                        //   true;
                        //   itemInCart
                        //       .cartQuantity = (itemInCart.cartQuantity ??
                        //       1) +
                        //       1;
                        //   cartViewData.addToCart(
                        //       itemInCart.productId ?? '',
                        //       itemInCart.cartQuantity.toString() ,
                        //       itemInCart.productDetails?.variantId ?? '',
                        //       true,
                        //       context,
                        //           (result, isSuccess) {});
                        // }
                      },
                    ),
                  ),
                ]),
          ),
          SizedBox(height: 10)
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Container(
            width: ResponsiveWidget.isMediumScreen(context)
                ?SizeConfig.screenWidth * 0.50: SizeConfig.screenWidth * 0.15,
            child: AppMediumFont(
                color: Theme.of(context).canvasColor,
                context,
                msg: itemInCart.productDetails
                    ?.productVariantTitle,
                fontSize: 18.0),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              AppMediumFont(
                  context,
                  color: Theme
                      .of(
                      context)
                      .canvasColor,
                  msg: "₹" +
                      "${itemInCart.productDetails?.productPrice}",
                  textDecoration:
                  TextDecoration
                      .lineThrough,
                  fontSize:
                  ResponsiveWidget.isMediumScreen(context)
                      ? 12.0:14),
              SizedBox(
                width: SizeConfig
                    .safeBlockVertical *
                    1,
              ),
              AppBoldFont(
                  context,
                  msg: "₹" +
                      " ${itemInCart.productDetails?.productDiscountPrice}",
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
                  msg: "${itemInCart.productDetails?.productDiscountPercent}" +
                      r" % OFF",
                  color: GREEN,
                  fontSize:
                  ResponsiveWidget.isMediumScreen(context)
                      ? 12.0:14),
              SizedBox(
                width: SizeConfig
                    .safeBlockVertical *
                    1,
              ),
            ],
          ),
          SizedBox(height: 5),
          itemInCart.productSelectedSku
              ?.color
              ?.name !=
              null
              ? AppMediumFont(
              context,
              maxLines: 1,
              msg: "Color" +
                  '- ${itemInCart.productSelectedSku?.color?.name}',
              color: Theme.of(
                  context)
                  .canvasColor,
              fontSize:
              16.0)
              : SizedBox(),
          itemInCart
              .productSelectedSku
              ?.size
              ?.name !=
              null
              ? AppMediumFont(
              context,
              maxLines: 1,
              msg: "Size" +
                  '- ${itemInCart.productSelectedSku?.size?.name}',
              color: Theme.of(
                  context)
                  .canvasColor,
              fontSize:
              16.0)
              : SizedBox(),
          itemInCart
              .productSelectedSku
              ?.style
              ?.name !=
              null
              ? AppMediumFont(
              context,
              maxLines: 1,
              msg: "Style" +
                  '- ${itemInCart.productSelectedSku?.style?.name}',
              color: Theme.of(
                  context)
                  .canvasColor,
              fontSize:
              16.0)
              : SizedBox(),
          itemInCart
              .productSelectedSku
              ?.materialType
              ?.name !=
              null
              ? AppMediumFont(
              context,
              maxLines: 2,
              msg: "MaterialType" +
                  '- ${itemInCart.productSelectedSku!.materialType!.name!.length > 35 ? itemInCart.productSelectedSku?.materialType?.name!.replaceRange(35, itemInCart.productSelectedSku?.materialType?.name?.length, '...') : itemInCart.productSelectedSku?.materialType?.name ?? ""}',
              color: Theme.of(
                  context)
                  .canvasColor,
              fontSize:
              16.0)
              : SizedBox(),
          itemInCart
              .productSelectedSku
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
                  '- ${itemInCart.productSelectedSku?.unitCount?.name}',
              fontSize:
              16.0)
              : SizedBox(),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () async {
              cartViewData.removeProductFromCart(
                  context,
                  itemInCart
                      .productDetails
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
  );
}

Widget pricedetails(BuildContext context,CartViewModel cartViewData){
  return  Column(
      children: cartViewData
          .cartListData!
          .checkoutDetails!
          .map((e) {
        return Container(
          width:ResponsiveWidget.isMediumScreen(context)
              ? SizeConfig.screenWidth:
          SizeConfig.screenWidth /3.22,
          color: Theme.of(context).cardColor,
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
      }).toList());
}

Widget addressDetails(BuildContext context, String? addressId,CartViewModel cartViewData){
  return  Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5)
    ),
    width: ResponsiveWidget.isMediumScreen(context)
        ? SizeConfig.screenWidth:SizeConfig.screenWidth*0.30,
    height:ResponsiveWidget.isMediumScreen(context)
        ?SizeConfig.screenHeight - 500: SizeConfig.screenHeight - 300,
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: cartViewData
            .addressListModel?.length,
        itemBuilder: (context, index) {
          final addressItem = cartViewData.addressListModel?[index];
          cartViewData.selectedAddress = cartViewData.addressListModel?[cartViewData.selectedAddressIndex];
          return Stack(
            children: [
              Container(
                width: ResponsiveWidget.isMediumScreen(context)
                    ? SizeConfig.screenWidth:SizeConfig.screenWidth*0.30,
                padding: EdgeInsets.only(left: 8,top: 8,bottom: 10),
                margin:EdgeInsets.only(left:ResponsiveWidget.isMediumScreen(context)
                    ? 0: 5,right: ResponsiveWidget.isMediumScreen(context)
                    ? 0:5,top: 8),
                color: Theme.of(context).cardColor,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        cartViewData.selectedAddressIndex = index;
                        cartViewData.selectedAddress = cartViewData.addressListModel?[cartViewData.selectedAddressIndex];
                        addressId=cartViewData.selectedAddress?.addressId;
                      },
                      child: radioTileButton(context,cartViewData.selectedAddressIndex , index,),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        cartViewData.selectedAddressIndex = index;

                        cartViewData.selectedAddress = cartViewData.addressListModel?[cartViewData.selectedAddressIndex];
                        addressId=cartViewData.selectedAddress?.addressId;
                      },
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        mainAxisSize:
                        MainAxisSize.max,
                        mainAxisAlignment:
                        MainAxisAlignment
                            .end,
                        children: <Widget>[
                          AppMediumFont(context,
                              msg: (addressItem?.firstName?.toUpperCase() ?? '') +
                                  " " +
                                  (addressItem?.lastName?.toUpperCase() ?? ''),
                              color: Theme.of(context).canvasColor,
                              fontSize: 14.0),


                          Container(
                            margin: EdgeInsets.only(top: 1),
                            width: SizeConfig.screenWidth*0.25,
                            child: AppRegularFont(context,
                                msg: (addressItem?.firstAddress ?? '') +
                                    ", " +
                                    (addressItem?.secondAddress ??
                                        '') +
                                    ", " +
                                    (addressItem?.cityName ?? '') +", " +
                                    "\n" +
                                    (addressItem?.state ?? '') +
                                    " - " +
                                    (addressItem?.pinCode.toString() ?? '') +
                                    "\n" +"\n"+
                                    (addressItem?.mobileNumber ?? ''),
                                color: Theme.of(context).canvasColor,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 20,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 18,
                      color:
                      Theme.of(context)
                          .primaryColor,
                    ),
                    onPressed: () {
                      cartViewData.deleteAddress(context,cartViewData.addressListModel?[index].addressId ?? "").whenComplete(() => {
                        cartViewData.selectedAddressIndex=0
                      });
                    },
                  )),
              Positioned(
                  bottom: 0,
                  right: 50,
                  child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 18,
                        color:
                        Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return  ShippingAddressPage(isAlreadyAdded: true,
                                addressId: cartViewData.addressListModel?[index].addressId,
                                firstName: cartViewData.addressListModel?[index].firstName,
                                lastName: cartViewData.addressListModel?[index].lastName,
                                mobileNumber: cartViewData.addressListModel?[index].mobileNumber,
                                email: cartViewData.addressListModel?[index].email,
                                firstAddress: cartViewData.addressListModel?[index].firstAddress,
                                secondAddress: cartViewData.addressListModel?[index].secondAddress,
                                state: cartViewData.addressListModel?[index].state,
                                cityName: cartViewData.addressListModel?[index].cityName,
                                pinCode: cartViewData.addressListModel?[index].pinCode,
                              );
                            });
                      })
              ),
            ],
          );
        }),
  );
}

radioTileButton(BuildContext context,int? selectedAddressIndex, int index){
  return CircleAvatar(
    radius: 12,
    backgroundColor: Theme.of(context).canvasColor,
    child: CircleAvatar(
      radius: 10,
      backgroundColor: WHITE_COLOR,
      child: CircleAvatar(
        radius: 8,
        backgroundColor: selectedAddressIndex == index? Theme.of(context).primaryColor: WHITE_COLOR,
      ),
    ),
  );
}

Widget CategoryList(BuildContext context,CartViewModel cartViewModel){
  return  Container(
    margin: EdgeInsets.zero,
    color: Theme.of(context)
        .cardColor
        .withOpacity(0.6),
    padding: EdgeInsets.only(
        left: ResponsiveWidget.isMediumScreen(context) ? 16
            : SizeConfig
            .screenWidth *
            0.12,
        right: ResponsiveWidget
            .isMediumScreen(
            context)
            ? 4
            : SizeConfig
            .screenWidth *
            0.12,
        top: ResponsiveWidget
            .isMediumScreen(
            context)
            ? 4
            : 20),
    child: Column(
      mainAxisAlignment:
      MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        AppBoldFont(context,
            msg:
            "What are you looking for?",fontWeight: FontWeight.w700,
            fontSize: ResponsiveWidget
                .isMediumScreen(
                context)
                ? 14
                : 18),
        SizedBox(
            height: SizeConfig
                .screenHeight *
                0.01),
        Container(
            height: ResponsiveWidget
                .isMediumScreen(
                context)
                ? 140
                : SizeConfig
                .screenWidth *
                0.22,
            child: ListView.builder(
                physics:
                BouncingScrollPhysics(),
                reverse: false,
                padding:
                EdgeInsets.zero,
                scrollDirection:
                Axis.horizontal,
                itemCount: cartViewModel
                    .categoryListModel
                    ?.length,
                itemBuilder:
                    (context,
                    position) {
                  return InkWell(
                    onTap: () {
                      if (isLogins == true) {
                        isLogins = false;

                      }
                      if (isSearch == true) {
                        isSearch = false;

                      }
                      context.router.push(
                          CategorySubcategoryProduct(CategoryName: cartViewModel.categoryListModel?[position].categoryId)
                      );
                      },
                    child:
                    Container(
                      margin: EdgeInsets.only(
                          right: ResponsiveWidget.isMediumScreen(
                              context)
                              ? 8
                              : 18,
                          left: ResponsiveWidget.isMediumScreen(
                              context)
                              ? 8
                              : 18),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                        children: [
                          CircleAvatar(
                            radius: ResponsiveWidget.isMediumScreen(context)
                                ? 50
                                : SizeConfig.screenWidth *
                                0.085,
                            child: CachedNetworkImage(
                                imageUrl: cartViewModel.categoryListModel?[position].imageUrl ?? "",
                                fit: BoxFit.fill,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey))),
                          ),
                          SizedBox(
                              height:ResponsiveWidget.isMediumScreen(context)
                                  ? 2:
                              SizeConfig.screenHeight * 0.01),
                          Container(
                            width: ResponsiveWidget.isMediumScreen(context)
                                ?100 : SizeConfig.screenHeight *
                                0.3,
                            // color: Theme.of(context)
                            //     .primaryColor,
                            alignment:
                            Alignment.center,
                            padding: EdgeInsets.only(
                                top:
                                8,
                                bottom:
                                8),
                            child: AppBoldFont(
                                maxLines:
                                1,
                                context,
                                msg: cartViewModel.categoryListModel?[position].categoryTitle ??
                                    "",
                                fontSize: ResponsiveWidget.isMediumScreen(context)
                                    ? 14
                                    : 18,
                                color:
                                Theme.of(context).canvasColor),
                          ),
                          SizedBox(
                              height:
                              ResponsiveWidget.isMediumScreen(context)
                                  ? 2: SizeConfig.screenHeight * 0.01),
                        ],
                      ),
                    ),
                  );
                })),
      ],
    ),
  );
}

Widget offerList(BuildContext context){
  return Container(
    padding: EdgeInsets.only(
      left: ResponsiveWidget
          .isMediumScreen(
          context)
          ? 16
          : SizeConfig.screenWidth *
          0.12,
      right: ResponsiveWidget
          .isMediumScreen(
          context)
          ? 8
          : SizeConfig.screenWidth *
          0.12,
    ),
    child: Column(
      mainAxisAlignment:
      MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        AppBoldFont(context,
            msg: StringConstant
                .WhatWeoffer,
            fontSize: ResponsiveWidget
                .isMediumScreen(
                context)
                ? 14
                : 18,fontWeight: FontWeight.w700),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(
              right: 5),
          child:
          SingleChildScrollView(
            scrollDirection:
            Axis.horizontal,
            child: Row(
              children: [
                whatWeOfferWidget(context,AssetsConstants.icSupport,
                    StringConstant
                        .offerOnTimeDelivery,
                    StringConstant
                        .offerContent),
                whatWeOfferWidget(context,
                    AssetsConstants
                        .icCreditCard,
                    StringConstant
                        .offerSecurePayment,
                    StringConstant
                        .offerContent),
                whatWeOfferWidget(context,
                    AssetsConstants
                        .icTimer,
                    StringConstant
                        .offerSupport,
                    StringConstant
                        .offerContent),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget whatWeOfferWidget(BuildContext context,String img, String heading, String msg) {
  return Container(
    padding:
    EdgeInsets.all(ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
    margin: EdgeInsets.only(
        right: ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
    height: ResponsiveWidget.isMediumScreen(context) ? 130 : 250,
    width: ResponsiveWidget.isMediumScreen(context)
        ? 200
        : SizeConfig.screenWidth * 0.244,
    color: Theme.of(context).cardColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          img,
          width: ResponsiveWidget.isMediumScreen(context) ? 30 : 72,
          height: ResponsiveWidget.isMediumScreen(context) ? 30 : 72,
        ),
        SizedBox(
          height: ResponsiveWidget.isMediumScreen(context) ? 10 : 20,
        ),
        AppBoldFont(context,
            msg: heading,
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 16),
        SizedBox(
          height: ResponsiveWidget.isMediumScreen(context) ? 7 : 15,
        ),
        AppRegularFont(context,
            msg: msg,
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 16),
      ],
    ),
  );
}



// Widget getLatestUpdate(BuildContext context) {
//   return Stack(
//     children: [
//       Image.asset(
//         AssetsConstants.icNewUpdate,
//         height: ResponsiveWidget.isMediumScreen(context) ? 150 : 300,
//         width: SizeConfig.screenWidth,
//         fit: BoxFit.fill,
//       ),
//       Container(
//           alignment: Alignment.center,
//           margin: EdgeInsets.only(
//               top: ResponsiveWidget.isMediumScreen(context) ? 70 : 120),
//           child: AppBoldFont(context,
//               msg: StringConstant.getLatestupdate,
//               fontWeight: FontWeight.w500,
//               fontSize: ResponsiveWidget.isMediumScreen(context) ? 18 : 30,
//               color: Colors.white,
//               textAlign: TextAlign.center)),
//     ],
//   );
// }

String? getRecommendedViewTitle(int position, CartViewModel cartview) {
  if ((cartview.recommendedView?[position].productDetails?.productVariantTitle
      ?.length ??
      0) >
      35) {
    return cartview
        .recommendedView?[position].productDetails?.productVariantTitle
        ?.replaceRange(
        35,
        cartview.recommendedView?[position].productDetails
            ?.productVariantTitle?.length,
        '...');
  } else {
    return cartview
        .recommendedView?[position].productDetails?.productVariantTitle ??
        "";
  }
}

String? getRecentViewTitle(int position, CartViewModel cartview) {
  if ((cartview.recentView?[position].productDetails?.productVariantTitle
      ?.length ??
      0) >
      35) {
    return cartview.recentView?[position].productDetails?.productVariantTitle
        ?.replaceRange(
        35,
        cartview.recentView?[position].productDetails?.productVariantTitle
            ?.length,
        '...');
  } else {
    return cartview
        .recentView?[position].productDetails?.productVariantTitle ??
        "";
  }
}
