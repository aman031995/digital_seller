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
import 'package:TychoStream/view/WebScreen/product/image_slider.dart';
import 'package:TychoStream/view/WebScreen/product/shipping_address_page.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/effect/OnHover.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonMethods {
  // break the given urls
  static Future<Uri> breakUrls(String url) async {
    var mappedUrl = Uri.parse(url);
    return mappedUrl;
  }
}

List<String> sortDropDownList = [
  "Recommended",
  "What's New",
  "Popularity",
  "Better Discount",
  "Price: High to Low",
  "Price: Low to High",
  "Customers Rating"
];

Widget cartPageViewIndicator(BuildContext context, int activeStep) {
  return Container(
      margin: EdgeInsets.only(
          bottom: 10,
          left: ResponsiveWidget.isMediumScreen(context)
              ? 16
              : SizeConfig.screenHeight * 0.5,
          right: ResponsiveWidget.isMediumScreen(context)
              ? 16
              : SizeConfig.screenHeight * 0.5,
          top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          stepView(context, "Step 1 \n${StringConstant.myCart}", activeStep, 0),
          Icon(Icons.arrow_forward_ios_sharp,
              size: 10,
              color: activeStep >= 0
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).canvasColor.withOpacity(0.8)),
          stepView(
              context, "Step 2 \n${StringConstant.payment}", activeStep, 1),
          Icon(
            Icons.arrow_forward_ios_sharp,
            size: 10,
            color: activeStep >= 2
                ? Theme.of(context).primaryColor
                : Theme.of(context).canvasColor.withOpacity(0.8),
          ),
          stepView(
              context, "Step 3 \n${StringConstant.orderPlaced}", activeStep, 2),
        ],
      ));
}

Widget stepView(BuildContext context, String title, int activeStep, int index) {
  return AppBoldFont(context,
      msg: title,
      fontWeight: FontWeight.w600,
      color: activeStep >= index
          ? Theme.of(context).primaryColor
          : Theme.of(context).canvasColor.withOpacity(0.8),
      fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 16);
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
                msg: str1 + ":",
                fontSize: 16.0,
                color: Theme.of(context).canvasColor)
            : AppRegularFont(context,
                msg: str1 + ":",
                fontSize: 16.0,
                color: Theme.of(context).canvasColor),
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
                    : Theme.of(context).canvasColor.withOpacity(0.8))
      ],
    ),
  );
}

//CheckOut button
Widget checkoutButton(
  BuildContext context,
  String msg,
  CartViewModel cartViewData,
  VoidCallback? onTap,
) {
  return Container(
    alignment: Alignment.center,
    width: SizeConfig.screenWidth * 0.24,
    decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(4)),
    child: InkWell(
      onTap: onTap,
      child: Center(
          child: AppMediumFont(context,
              msg: msg, fontSize: 16.0, color: Theme.of(context).hintColor)),
    ),
    height: 50,
  );
}

Widget profile(
    BuildContext context, setState, ProfileViewModel profileViewModel) {
  final authVM = Provider.of<AuthViewModel>(context);
  return Container(
    width: 150,
    color: Theme.of(context).cardColor,
    child: Column(
      children: [
        SizedBox(height: 5),
        appTextButton(context, StringConstant.myAccount, Alignment.centerLeft,
            Theme.of(context).canvasColor, 18, false, onPressed: () {
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
        appTextButton(context, StringConstant.myOrder, Alignment.centerLeft,
            Theme.of(context).canvasColor, 18, false, onPressed: () {
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
        appTextButton(context, StringConstant.logout, Alignment.centerLeft,
            Theme.of(context).canvasColor, 18, false, onPressed: () {
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

Widget productGalleryTitleSection(
    BuildContext context, ProductList? productListData, bool favbourite) {
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
Widget productListItems(BuildContext context, ProductList? productListData,
    int index, CartViewModel viewmodel,
    {bool? favouritepage}) {
  return OnHover(
    builder: (isHovered) {
      return InkWell(
          onTap: () {
            if (isLogins == true) {
              isLogins = false;
            }
            if (isSearch == true) {
              isSearch = false;
            }
            if(isnotification==true){
              isnotification=false;
            }
            context.router.push(
              ProductDetailPage(
                productName:
                    '${productListData?.productName?.replaceAll(' ', '')}',
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
                        color: Theme.of(context).canvasColor.withOpacity(0.15),
                        blurRadius: 10.0,
                        spreadRadius: 7,
                        offset: Offset(2, 2),
                      ),
                      BoxShadow(
                        color: Theme.of(context).canvasColor.withOpacity(0.12),
                        blurRadius: 7.0,
                        spreadRadius: 5,
                        offset: Offset(2, 2),
                      ),
                      BoxShadow(
                        color: Theme.of(context).canvasColor.withOpacity(0.10),
                        blurRadius: 4.0,
                        spreadRadius: 3,
                        offset: Offset(2, 2),
                      ),
                      BoxShadow(
                        color: Theme.of(context).canvasColor.withOpacity(0.09),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  )
                : BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
            // margin: EdgeInsets.only(right: ResponsiveWidget.isMediumScreen(context) ? 0 : 16),
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
                    top: 1,
                    right: -5,
                    child: IconButton(
                        iconSize: 40,
                        icon: Image.asset(
                          productListData?.productDetails?.isFavorite == true
                              ? AssetsConstants.ic_wishlistSelect
                              : AssetsConstants.ic_wishlistUnselect,
                        ),
                        onPressed: () async {
                          if (isLogins == true) {
                            isLogins = false;
                          }
                          if (isSearch == true) {
                            isSearch = false;
                          }
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          if (sharedPreferences.getString('token') == null) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return LoginUp(
                                    product: true,
                                  );
                                });
                          } else {
                              final isFav = productListData!.productDetails!.isFavorite = !productListData.productDetails!.isFavorite!;
                              viewmodel.addToFavourite(
                                context,
                                "${productListData.productId}",
                                "${productListData.productDetails?.variantId}",
                                isFav,
                                '');
                          }
                        }))

              ],
            ),
          ));
    },
    hovered: Matrix4.identity()..translate(0, 0, 0),
  );
}

Widget cardDeatils(BuildContext context, ProductList itemInCart, int index,
    CartViewModel cartViewData) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          itemInCart.productDetails?.inStock == true ?
          (itemInCart.productDetails?.quantityLeft ?? 0) > 0 ?
           Container(
            height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context) ? 120:150 : SizeConfig.screenWidth * 0.11,
            width: ResponsiveWidget.isMediumScreen(context)
                ?  ResponsiveWidget.isSmallScreen(context) ? 120:150
                : SizeConfig.screenWidth * 0.11,
            margin: EdgeInsets.only(top: 12, right: 8, left: 12, bottom: 5),
            child: Image.network(
              itemInCart.productDetails?.productImages?[0] ?? "",
              fit: BoxFit.fill,
            ),
          ):
          Banner(
            message:StringConstant.OutofStock,
            location: BannerLocation.topStart,
            color: Colors.red,
            child: Container(height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context) ? 120:150 : 200,
                width: ResponsiveWidget.isMediumScreen(context)
                    ?  ResponsiveWidget.isSmallScreen(context) ? 120:150
                    : SizeConfig.screenWidth * 0.11,
                margin: EdgeInsets.only(top: 12, right: 8, left: 12, bottom: 5),
                child: Image.network(
                    itemInCart.productDetails?.productImages?[0] ?? "",
                    fit: BoxFit.fill)),
          ):
          Banner(
            message:StringConstant.OutofStock,
            location: BannerLocation.topStart,
            color: Colors.red,
            child: Container(height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context) ? 120:150 : 200,
                width: ResponsiveWidget.isMediumScreen(context)
                    ?  ResponsiveWidget.isSmallScreen(context) ? 120:150
                    : SizeConfig.screenWidth * 0.11,
                margin: EdgeInsets.only(top: 12, right: 8, left: 12, bottom: 5),
                child: Image.network(
                    itemInCart.productDetails?.productImages?[0] ?? "",
                    fit: BoxFit.fill)),
          ),
          itemInCart.productDetails?.inStock == true ?  Container(
            height: 30,
            width: ResponsiveWidget.isMediumScreen(context)
                ?  ResponsiveWidget.isSmallScreen(context) ? 120:150
                : SizeConfig.screenWidth * 0.11,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).canvasColor.withOpacity(0.2),
                    width: 1)),
            margin: EdgeInsets.only(left: 12, top: 5, right: 8, bottom: 5),
            child: Row(children: [
              Expanded(
                flex: 25,
                child: GestureDetector(
                  child: itemInCart.cartQuantity == 1
                      ? Container(
                          child: Icon(Icons.delete,
                              color: Theme.of(context).canvasColor, size: 18))
                      : Icon(Icons.remove,
                          color: Theme.of(context).canvasColor, size: 18.0),
                  onTap: () async {
                    if (cartViewData.deactiveQuantity == false) {
                      cartViewData.deactiveQuantity = true;
                      itemInCart.cartQuantity =
                          (itemInCart.cartQuantity ?? 1) - 1;
                      if (itemInCart.cartQuantity! > 0) {
                        cartViewData.addToCart(
                            itemInCart.productId ?? '',
                            itemInCart.cartQuantity.toString(),
                            itemInCart.productDetails?.variantId ?? '',
                            true,
                            context,
                            (result, isSuccess) {});
                      } else {
                        if (itemInCart.cartQuantity == 0)
                          cartViewData.removeProductFromCart(
                              context,
                              itemInCart.productDetails?.variantId ?? "",
                              index);
                      }
                    }
                  },
                ),
              ),
              Container(
                  height: 30,
                  width: 1,
                  color: Theme.of(context).canvasColor.withOpacity(0.2)),
              Expanded(
                flex: 50,
                child: AppBoldFont(context,
                    textAlign: TextAlign.center,
                    color: Theme.of(context).canvasColor,
                    msg: itemInCart.cartQuantity.toString(),
                    fontSize: 16.0),
              ),
              Container(
                  height: 30,
                  width: 1,
                  color: Theme.of(context).canvasColor.withOpacity(0.2)),
              Expanded(
                flex: 25,
                child: GestureDetector(
                  child: Icon(
                    Icons.add,
                    size: 18.0,
                    color: Theme.of(context).canvasColor,
                  ),
                  onTap: () {
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
                            "Sorry only ${itemInCart.productDetails?.quantityLeft} quantity is left.",
                            context);
                      }
                    }
                  },
                ),
              ),
            ]),
          ):Container(),
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
                ? SizeConfig.screenWidth * 0.50
                : SizeConfig.screenWidth * 0.15,
            child: AppMediumFont(
                color: Theme.of(context).canvasColor,
                context,
                msg: itemInCart.productDetails?.productVariantTitle,
                fontSize: 18.0),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              AppMediumFont(context,
                  color: Theme.of(context).canvasColor,
                  msg: "₹" + "${itemInCart.productDetails?.productPrice}",
                  textDecoration: TextDecoration.lineThrough,
                  fontSize:
                      ResponsiveWidget.isMediumScreen(context) ? 12.0 : 14),
              SizedBox(
                width: SizeConfig.safeBlockVertical * 1,
              ),
              AppBoldFont(context,
                  msg: "₹" +
                      " ${itemInCart.productDetails?.productDiscountPrice}",
                  color: Theme.of(context).canvasColor,
                  fontSize: 16.0),
              SizedBox(
                width: SizeConfig.safeBlockVertical * 1,
              ),
              AppMediumFont(context,
                  msg: "${itemInCart.productDetails?.productDiscountPercent}" +
                      r" % OFF",
                  color: GREEN,
                  fontSize:
                      ResponsiveWidget.isMediumScreen(context) ? 12.0 : 14),
              SizedBox(
                width: SizeConfig.safeBlockVertical * 1,
              ),
            ],
          ),
          SizedBox(height: 5),
          itemInCart.productSelectedSku?.color?.name != null
              ? AppMediumFont(context,
                  maxLines: 1,
                  msg: "Color" +
                      '- ${itemInCart.productSelectedSku?.color?.name}',
                  color: Theme.of(context).canvasColor,
                  fontSize: 16.0)
              : SizedBox(),
          itemInCart.productSelectedSku?.size?.name != null
              ? AppMediumFont(context,
                  maxLines: 1,
                  msg:
                      "Size" + '- ${itemInCart.productSelectedSku?.size?.name}',
                  color: Theme.of(context).canvasColor,
                  fontSize: 16.0)
              : SizedBox(),
          itemInCart.productSelectedSku?.style?.name != null
              ? AppMediumFont(context,
                  maxLines: 1,
                  msg: "Style" +
                      '- ${itemInCart.productSelectedSku?.style?.name}',
                  color: Theme.of(context).canvasColor,
                  fontSize: 16.0)
              : SizedBox(),
          itemInCart.productSelectedSku?.materialType?.name != null
              ? AppMediumFont(context,
                  maxLines: 2,
                  msg: "MaterialType" +
                      '- ${itemInCart.productSelectedSku!.materialType!.name!.length > 35 ? itemInCart.productSelectedSku?.materialType?.name!.replaceRange(35, itemInCart.productSelectedSku?.materialType?.name?.length, '...') : itemInCart.productSelectedSku?.materialType?.name ?? ""}',
                  color: Theme.of(context).canvasColor,
                  fontSize: 16.0)
              : SizedBox(),
          itemInCart.productSelectedSku?.unitCount?.name != null
              ? AppMediumFont(context,
                  color: Theme.of(context).canvasColor,
                  maxLines: 1,
                  msg: "UnitCount" +
                      '- ${itemInCart.productSelectedSku?.unitCount?.name}',
                  fontSize: 16.0)
              : SizedBox(),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () async {
              cartViewData.removeProductFromCart(
                  context, itemInCart.productDetails?.variantId ?? "", index);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
              child: AppRegularFont(context,
                  color: Theme.of(context).hintColor,
                  msg: StringConstant.remove,
                  fontSize: 14.0),
            ),
          ),
          SizedBox(height: 5),
        ],
      )
    ],
  );
}

Widget pricedetails(BuildContext context, CartViewModel cartViewData) {
  return Column(
      children: cartViewData.cartListData!.checkoutDetails!.map((e) {
    return Container(

      width: ResponsiveWidget.isMediumScreen(context)
          ? SizeConfig.screenWidth
          : SizeConfig.screenWidth / 3.22,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          SizedBox(height: 8),
          priceDetailWidget(context, e.name ?? "", e.value ?? ""),
          SizedBox(height: 8)
        ],
      ),
    );
  }).toList());
}

Widget addressDetails(
    BuildContext context, String? addressId, CartViewModel cartViewData) {
  return Container(
    // height: ResponsiveWidget.isMediumScreen(context)
    //     ?ResponsiveWidget.isSmallScreen(context) ?SizeConfig.screenHeight-290:SizeConfig.screenHeight/7.8:SizeConfig.screenHeight/2,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
    margin: EdgeInsets.only(bottom: 8),
    width: ResponsiveWidget.isMediumScreen(context) ? SizeConfig.screenWidth : SizeConfig.screenWidth * 0.30,
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: cartViewData.addressListModel?.length,
        itemBuilder: (context, index) {
          final addressItem = cartViewData.addressListModel?[index];
          cartViewData.selectedAddress =
              cartViewData.addressListModel?[cartViewData.selectedAddressIndex];
          return Stack(
            children: [
              Container(
                width: ResponsiveWidget.isMediumScreen(context)
                    ? SizeConfig.screenWidth
                    : SizeConfig.screenWidth * 0.30,
                padding: EdgeInsets.only(left: 8, top: 8, bottom: 10),
                margin: EdgeInsets.only(
                    left: ResponsiveWidget.isMediumScreen(context) ? 0 : 5,
                    right: ResponsiveWidget.isMediumScreen(context) ? 0 : 5,
                    top: 8),
                color: Theme.of(context).cardColor,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        cartViewData.selectedAddressIndex = index;
                        cartViewData.selectedAddress =
                            cartViewData.addressListModel?[
                                cartViewData.selectedAddressIndex];
                        addressId = cartViewData.selectedAddress?.addressId;
                      },
                      child: radioTileButton(
                        context,
                        cartViewData.selectedAddressIndex,
                        index,
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        cartViewData.selectedAddressIndex = index;

                        cartViewData.selectedAddress =
                            cartViewData.addressListModel?[
                                cartViewData.selectedAddressIndex];
                        addressId = cartViewData.selectedAddress?.addressId;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: ResponsiveWidget.isMediumScreen(context) ? SizeConfig.screenWidth/1.14:SizeConfig.screenWidth * 0.25,
                            child: AppMediumFont(context,
                                msg: (addressItem?.firstName?.toUpperCase() ??
                                        '') +
                                    " " +
                                    (addressItem?.lastName?.toUpperCase() ?? ''),
                                color: Theme.of(context).canvasColor,
                                fontSize: 14.0),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 1),
                            width:ResponsiveWidget.isMediumScreen(context) ? SizeConfig.screenWidth/1.14 : SizeConfig.screenWidth * 0.25,
                            child: AppRegularFont(context,
                                msg: (addressItem?.firstAddress ?? '') +
                                    ", " +
                                    (addressItem?.secondAddress ?? '') +
                                    ", " +(addressItem?.landmark ?? "")+  ", " +
                                    (addressItem?.cityName ?? '') +
                                    "\n" +
                                    (addressItem?.state ?? '') +
                                    " - " +
                                    (addressItem?.pinCode.toString() ?? '') +
                                    "\n" +
                                    "\n" +
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
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      cartViewData
                          .deleteAddress(
                              context,
                              cartViewData.addressListModel?[index].addressId ??
                                  "")
                          .whenComplete(
                              () => {cartViewData.selectedAddressIndex = 0});
                    },
                  )),
              Positioned(
                  bottom: 0,
                  right: 50,
                  child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ShippingAddressPage(
                                isAlreadyAdded: true,
                                addressId: cartViewData
                                    .addressListModel?[index].addressId,
                                firstName: cartViewData
                                    .addressListModel?[index].firstName,
                                lastName: cartViewData
                                    .addressListModel?[index].lastName,
                                mobileNumber: cartViewData
                                    .addressListModel?[index].mobileNumber,
                                email:
                                    cartViewData.addressListModel?[index].email,
                                firstAddress: cartViewData
                                    .addressListModel?[index].firstAddress,
                                secondAddress: cartViewData
                                    .addressListModel?[index].secondAddress,
                                state:
                                    cartViewData.addressListModel?[index].state,
                                cityName: cartViewData
                                    .addressListModel?[index].cityName,
                                pinCode: cartViewData
                                    .addressListModel?[index].pinCode,
                                landmark: cartViewData.addressListModel?[index].landmark,
                              );
                            });
                      })),
            ],
          );
        }),
  );
}

radioTileButton(BuildContext context, int? selectedAddressIndex, int index) {
  return CircleAvatar(
    radius: 12,
    backgroundColor: Theme.of(context).canvasColor,
    child: CircleAvatar(
      radius: 10,
      backgroundColor: WHITE_COLOR,
      child: CircleAvatar(
        radius: 8,
        backgroundColor: selectedAddressIndex == index
            ? Theme.of(context).primaryColor
            : WHITE_COLOR,
      ),
    ),
  );
}

Widget CategoryList(BuildContext context, CartViewModel cartViewModel) {
  return Container(
    margin: EdgeInsets.zero,
    color: Theme.of(context).cardColor.withOpacity(0.6),
    padding: EdgeInsets.only(
        left: ResponsiveWidget.isMediumScreen(context)
            ? 16
            : SizeConfig.screenWidth * 0.12,
        right: ResponsiveWidget.isMediumScreen(context)
            ? 4
            : SizeConfig.screenWidth * 0.12,
        top: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context)
            ? 4:8 : 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: AppBoldFont(context,
              textAlign: TextAlign.left,
              msg: StringConstant.categoryList,
              fontWeight: FontWeight.w700,
              fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 18),
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.01),
        Container(
            height: ResponsiveWidget.isMediumScreen(context)
                ?ResponsiveWidget.isSmallScreen(context)
                ?  150:SizeConfig.screenHeight*0.22
                : SizeConfig.screenWidth * 0.22,
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                reverse: false,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: cartViewModel.categoryListModel?.length,
                itemBuilder: (context, position) {
                  return InkWell(
                    onTap: () {
                      if (isLogins == true) {
                        isLogins = false;
                      }
                      if (isSearch == true) {
                        isSearch = false;
                      }
                      if (isnotification == true) {
                        isnotification = false;
                      }
                      cartViewModel.categoryListModel?[position].subcategories
                                  ?.length ==
                              0
                          ? context.router.push(SubcategoryProductList(
                              SubcategoryProductName: cartViewModel
                                  .categoryListModel?[position].categoryId))
                          : context.router.push(CategorySubcategoryProduct(
                              CategoryName: cartViewModel
                                  .categoryListModel?[position].categoryId));
                    },
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context)
                          ?4:8:10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).cardColor,
                            radius: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context) ? 50:SizeConfig.screenHeight*0.085
                                : ResponsiveWidget.isSmallScreen(context) ?SizeConfig.screenWidth * 0.080:SizeConfig.screenWidth * 0.075,
                            child: CachedNetworkImage(
                                imageUrl: cartViewModel
                                        .categoryListModel?[position]
                                        .imageUrl ??
                                    "",
                                fit: BoxFit.fill,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.grey,strokeWidth: 2))),
                          ),
                          SizedBox(
                              height: ResponsiveWidget.isMediumScreen(context)
                                  ? 2
                                  : SizeConfig.screenHeight * 0.01),
                          Container(
                            width: ResponsiveWidget.isMediumScreen(context)
                                ? 100
                                : SizeConfig.screenHeight * 0.3,
                            // color: Theme.of(context)
                            //     .primaryColor,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: AppBoldFont(
                                maxLines: 1,
                                context,
                                msg:ResponsiveWidget.isMediumScreen(context) ?getCategoryViewTitleMobile(position, cartViewModel) :getCategoryViewTitle(position,cartViewModel) ?? "",
                                fontSize:
                                    ResponsiveWidget.isMediumScreen(context)
                                        ? 14
                                        : 18,
                                color: Theme.of(context).canvasColor),
                          ),
                          SizedBox(
                              height: ResponsiveWidget.isMediumScreen(context)
                                  ? 2
                                  : SizeConfig.screenHeight * 0.01),
                        ],
                      ),
                    ),
                  );
                })),
      ],
    ),
  );
}

Widget offerList(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(
      left: ResponsiveWidget.isMediumScreen(context)
          ? 16
          : SizeConfig.screenWidth * 0.12,
      right: ResponsiveWidget.isMediumScreen(context)
          ? 8
          : SizeConfig.screenWidth * 0.12,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: AppBoldFont(context,
              textAlign: TextAlign.left,
              msg: StringConstant.WhatWeoffer,
              fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 18,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(right: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                whatWeOfferWidget(
                    context,
                    AssetsConstants.icSupport,
                    StringConstant.offerOnTimeDelivery,
                    StringConstant.offerDelivery),
                whatWeOfferWidget(
                    context,
                    AssetsConstants.icCreditCard,
                    StringConstant.offerSecurePayment,
                    StringConstant.offerSecure),
                whatWeOfferWidget(context, AssetsConstants.icTimer,
                    StringConstant.offerSupport, StringConstant.offerSupporText),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget whatWeOfferWidget(
    BuildContext context, String img, String heading, String msg) {
  return Container(
    padding: EdgeInsets.all(ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
    margin: EdgeInsets.only(
        right: ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
    height: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context)
        ?130:160 : 250,
    width: ResponsiveWidget.isMediumScreen(context)
        ?  ResponsiveWidget.isSmallScreen(context)
        ?200: SizeConfig.screenHeight/4.2
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

Widget catrgoryTopSortWidget(BuildContext context) {
  return Container(
    height: 50,
    color: Theme.of(context).cardColor,
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: AppRegularFont(context,
              msg: "1240 Item found", color: Theme.of(context).canvasColor),
        ),
        Expanded(
            child: SizedBox(
          width: SizeConfig.screenWidth / 8,
        )),
        Container(child: dropdown(sortDropDownList, context))
      ],
    ),
  );
}

Widget dropdown(List<String> txt, BuildContext context) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: AppRegularFont(context,
            msg: "Sort By",
            color: Theme.of(context).canvasColor,
            fontWeight: FontWeight.w500),
      ),
      SizedBox(
        width: 15,
      ),
      Container(
        height: SizeConfig.screenHeight * .04,
        color: Theme.of(context).cardColor.withOpacity(0.8),
        width: ResponsiveWidget.isMediumScreen(context) ? 150 : 200,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: DropdownButtonFormField2(
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).cardColor,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).primaryColor.withOpacity(0.2)),
            ),
            contentPadding: EdgeInsets.only(bottom: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          //isExpanded: true,
          hint: Text(
            txt[0],
            style: TextStyle(
              fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 14,
              color: Theme.of(context).canvasColor.withOpacity(0.4),
            ),
          ),
          isExpanded: true,
          items: txt
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                          fontSize: ResponsiveWidget.isMediumScreen(context)
                              ? 12
                              : 14,
                          color: Theme.of(context).canvasColor),
                    ),
                  ))
              .toList(),
          onChanged: (String? value) {},
        ),
      ),
    ],
  );
}

//homepage methods
Widget  discountView(CartViewModel cartview) {
  return  Consumer<CartViewModel>(
    builder: (context, homeVM, _){
      return Container(
        width: SizeConfig.screenWidth,
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        margin: EdgeInsets.zero,
        height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context)
            ?300:SizeConfig.screenHeight/4: SizeConfig.screenWidth * 0.29,
        padding: EdgeInsets.only(
            left: ResponsiveWidget
                .isMediumScreen(
                context)
                ? ResponsiveWidget.isSmallScreen(context)
                ?8:12
                : SizeConfig
                .screenWidth *
                0.12,
            right: ResponsiveWidget
                .isMediumScreen(
                context)
                ? 8
                : SizeConfig
                .screenWidth *
                0.11,
            top: ResponsiveWidget
                .isMediumScreen(
                context)
                ?10: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: AppBoldFont(context, msg:StringConstant.discout , fontWeight:
              FontWeight
                  .w700,textAlign: TextAlign.left,
                  fontSize:
                  ResponsiveWidget.isMediumScreen(context)
                      ? 16
                      : 22),
            ),
            SizedBox(height: 10),
            Container(
                height: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context) ?230: SizeConfig.screenHeight/5  : SizeConfig.screenWidth * 0.25,
                width: SizeConfig
                    .screenWidth,


                child: ListView.builder(
                    reverse: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: cartview.offerDiscountModel?.length,
                    itemBuilder: (context, position) {
                      return InkWell(
                          onTap: () {
                            if (isLogins == true) {
                              isLogins = false;
                            }
                            if (isSearch == true) {
                              isSearch = false;
                            }
                            if (isnotification == true) {
                              isnotification = false;
                            }
                            context.router.push(ProductListGallery(
                                discountdata: ["${cartview.offerDiscountModel?[position].categoryId}","${cartview.offerDiscountModel?[position].discountPercentage}"]
                            ));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right:ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
                            width: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context)
                                ?140:SizeConfig.screenHeight/5.8 : SizeConfig.screenWidth * 0.18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                    height: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context)
                                        ?180:SizeConfig.screenHeight/6: SizeConfig.screenWidth * 0.20,
                                    width: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context)
                                        ?140:SizeConfig.screenHeight/5.8: SizeConfig.screenWidth * 0.20,
                                    imageUrl: '${cartview.offerDiscountModel?[position].images}',
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2))),
                                SizedBox(height: 8),
                                AppBoldFont(context, msg: "${cartview.offerDiscountModel?[position].title}", color: Theme.of(context).canvasColor,fontSize: ResponsiveWidget.isMediumScreen(context) ? 14:18),
                                SizedBox(height: 4),
                                AppRegularFont(context, msg: "Up To. ${cartview.offerDiscountModel?[position].discountPercentage}% Off", color: GREEN, fontSize: ResponsiveWidget.isMediumScreen(context) ? 14:18)


                              ],
                            ),
                          ));})),
          ],
        ),
      );
    },
  );
}

Widget gallery(BuildContext context,List images){
  return  Center(
    child: Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.zero,
      color: Theme.of(context)
          .cardColor
          .withOpacity(0.6),
      padding: EdgeInsets.only(
          left: ResponsiveWidget
              .isMediumScreen(
              context)
              ? 8
              : SizeConfig
              .screenWidth *
              0.01,
          right: ResponsiveWidget
              .isMediumScreen(
              context)
              ? 0
              : SizeConfig
              .screenWidth *
              0.01,
          top: 20,
          bottom: 20),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics:
        BouncingScrollPhysics(),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.78,
        ),
        itemCount: images.length,
        itemBuilder:
            (context, index) {
          return InkWell(
              onTap: () {
                if (isLogins ==
                    true) {
                  isLogins = false;
                }
                if (isSearch ==
                    true) {
                  isSearch = false;
                }
                if (isnotification == true) {
                  isnotification = false;
                }
                context.router.push(
                    ProductListGallery());
              },
              child: OnHover(
                builder:
                    (isHovered) {
                  return Card(
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            20),
                      ),
                      elevation:
                      isHovered == true
                          ? 20
                          : 0,
                      margin: EdgeInsets.only(
                          right: ResponsiveWidget.isMediumScreen(
                              context)
                              ? 8
                              : 16,
                          bottom: ResponsiveWidget.isMediumScreen(
                              context)
                              ? 8
                              : 16),
                      child: Image
                          .asset(
                        images[
                        index],
                        fit: BoxFit
                            .fill,
                      ));
                },
                hovered: Matrix4
                    .identity()
                  ..translate(
                      0, 0, 0),
              ));
        },
      ),
    ),
  );
}

Widget recommeded(BuildContext context,controller,cartViewModel){
  return     Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.only(
            left: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.01,
            right: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.01),
        alignment: Alignment.topLeft,
        child: AppBoldFont(
            context,textAlign: TextAlign.left,
            msg: StringConstant.Recommended,
            fontWeight: FontWeight.w700,
            fontSize: ResponsiveWidget.isMediumScreen(context)? 14 : 18),
      ),
      SizedBox(
          height: SizeConfig.screenWidth * 0.01),
      Container(
          padding: EdgeInsets.only(left: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.01,
              right: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.01),
          height: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context)
              ?235 :SizeConfig.screenHeight/4.5: SizeConfig.screenWidth * 0.32,
          child: ListView.builder(
              reverse: false,
              controller: controller,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: cartViewModel.recommendedView?.length,
              itemBuilder: (context, position) {
                return AutoScrollTag(
                    key: ValueKey(position),
                    controller: controller,
                    index: position,
                    child: OnHover(
                      builder: (isHovered) {
                        return InkWell(
                          onTap: () {
                            if (isLogins == true) {
                              isLogins = false;

                            }
                            if (isSearch == true) {
                              isSearch = false;

                            }
                            if (isnotification == true) {
                              isnotification = false;

                            }
                            context.router.push(ProductDetailPage(
                              productName: '${cartViewModel.recommendedView?[position].productName?.replaceAll(' ', '')}',
                              productdata: [
                                '${cartViewModel.recommendedView?[position].productId}',
                                '${cartViewModel.cartItemCount}',
                                '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.size?.name}',
                                '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.color?.name}',
                                '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.style?.name}',
                                '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.unitCount?.name}',
                                '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.materialType?.name}',

                              ],
                            ));
                          },
                          child: Card(
                            elevation: isHovered == true ? 10 : 0.0,
                            margin: EdgeInsets.only(right:ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
                            child: Container(
                              width: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context)
                                  ?140:SizeConfig.screenHeight/6 : SizeConfig.screenWidth * 0.18,
                              decoration: BoxDecoration(color: Theme.of(context).cardColor),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                      imageUrl: '${cartViewModel.recommendedView?[position].productDetails?.productImages?[0]}',
                                      fit: BoxFit.cover,
                                      height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context)
                                          ?140: SizeConfig.screenHeight/6.5 : SizeConfig.screenWidth * 0.228,
                                      imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover))),
                                      placeholder: (context, url) => Container(height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.23, child: Center(child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2)))),
                                  SizedBox(height: 8),
                                  AppBoldFont(maxLines: 1, context, msg: " "+"${getRecommendedViewTitle(position, cartViewModel)}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 18),
                                  SizedBox(height: 2),
                                  AppBoldFont(maxLines: 1, context, msg: "₹" + "${cartViewModel.recommendedView?[position].productDetails?.productDiscountPrice}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 18),
                                  SizedBox(height:10),
                                  InkWell(
                                    onTap: () {
                                      context.router.push(ProductDetailPage(
                                        productName: '${cartViewModel.recommendedView?[position].productName?.replaceAll(' ', '')}',
                                        productdata: [
                                          '${cartViewModel.recommendedView?[position].productId}',
                                          '${cartViewModel.cartItemCount}',
                                          '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.size?.name}',
                                          '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.color?.name}',
                                          '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.style?.name}',
                                          '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.unitCount?.name}',
                                          '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.materialType?.name}',
                                        ],
                                      ));
                                    },
                                    child: Container(
                                      width: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.18,
                                      height: ResponsiveWidget.isMediumScreen(context) ? 30 : SizeConfig.screenWidth * 0.027,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: 16,right: 16),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.2), border: Border.all(width: 1, color: Theme.of(context).canvasColor)),
                                      child: AppBoldFont(context, msg: StringConstant.buynow, fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      hovered: Matrix4.identity()
                        ..translate(0, 0, 0),
                    ));
              })),
    ],
  );
}

Widget recentView(BuildContext context,controller1,cartViewModel){
  return  Column(mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
          padding: EdgeInsets.only(
              left: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.01,
              right: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.01),
          alignment: Alignment.topLeft,
          child: AppBoldFont(
              context, textAlign: TextAlign.left,
              msg: StringConstant.RecentView,
              fontWeight: FontWeight.w700,
              fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 18)
      ),
      SizedBox(height: SizeConfig.screenWidth * 0.01),
      Container(
          height: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context) ?200: SizeConfig.screenHeight/6.2
              : SizeConfig.screenWidth * 0.27,
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(
              left: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.01,
              right: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.01),
          child: ListView.builder(
              reverse: false,
              controller: controller1,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: cartViewModel.recentView?.length,
              itemBuilder: (context, position) {
                return AutoScrollTag(
                    key: ValueKey(position),
                    controller: controller1,
                    index: position,
                    child: OnHover(
                      builder: (isHovered) {
                        return InkWell(
                          onTap: () {
                            if (isLogins == true) {
                              isLogins = false;
                            }
                            if (isSearch == true) {
                              isSearch = false;
                            }
                            if (isnotification == true) {
                              isnotification = false;
                            }
                            context.router.push(ProductDetailPage(
                              productName: '${cartViewModel.recentView?[position].productName}',
                              productdata: [
                                '${cartViewModel.recentView?[position].productId}',
                                '${cartViewModel.cartItemCount}',
                                '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.size?.name}',
                                '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.color?.name}',
                                '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.style?.name}',
                                '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.unitCount?.name}',
                                '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.materialType?.name}',
                              ],
                            ));
                          },
                          child: Card(
                            elevation: isHovered == true ? 10 : 0.0,
                            margin: EdgeInsets.only(right:ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
                            child: Container(
                              width: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context) ?140: SizeConfig.screenHeight/6.5 : SizeConfig.screenWidth * 0.18,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                      imageUrl: '${cartViewModel.recentView?[position].productDetails?.productImages?[0]}',
                                      fit: BoxFit.contain,
                                      height: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context) ?140: SizeConfig.screenHeight/7.5 : SizeConfig.screenWidth * 0.228,
                                      imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenHeight / 2.1, child: Center(child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2)))),
                                  SizedBox(height: 10),
                                  AppBoldFont(context, msg:" "+ "${getRecentViewTitle(position, cartViewModel)}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 18, maxLines: 1),
                                  SizedBox(height: 10)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      hovered: Matrix4.identity()..translate(0, 0, 0),
                    ));
              }))
    ],
  );
}

//Product deatils

Widget favoritebutton(BuildContext context,CartViewModel viewmodel,{double? top}){
  return Positioned(
    right: -5,
    top: top,
    child:IconButton(
        iconSize: 45,
        icon: Image.asset(
          viewmodel.productListDetails
              ?.productDetails?.isFavorite ==
              true
              ? AssetsConstants.ic_wishlistSelect
              : AssetsConstants.ic_wishlistUnselect,
        ),
        onPressed: ()async{
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.getString('token')== null){
            showDialog(
                context: context,
                builder:
                    (BuildContext context) {
                  return  LoginUp(
                    product: true,
                  );
                });
          } else {
            final isFav =
            viewmodel.productListDetails?.productDetails!.isFavorite = !viewmodel.productListDetails!.productDetails!.isFavorite!;
            viewmodel.addToFavourite(
                context,
                "${viewmodel.productListDetails?.productId}",
                "${viewmodel.productListDetails?.productDetails?.variantId}",
                isFav!,
                'productList');
          }
        }),


  );
}

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
String? getSimilarTitle(int position, CartViewModel cartview) {
  if ((cartview.productListModel?.productList?[position].productDetails?.productVariantTitle
      ?.length ??
      0) >
      35) {
    return cartview.productListModel?.productList?[position].productDetails?.productVariantTitle
        ?.replaceRange(
        35,
        cartview.productListModel?.productList?[position].productDetails
            ?.productVariantTitle?.length,
        '...');
  } else {
    return cartview.productListModel?.productList?[position].productDetails?.productVariantTitle ??
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
    return cartview.recentView?[position].productDetails?.productVariantTitle ??
        "";
  }
}

String? getCategoryViewTitle(int position, CartViewModel cartview) {
  if ((cartview.categoryListModel?[position].categoryTitle?.length ?? 0) > 35) {
    return cartview.categoryListModel?[position].categoryTitle
        ?.replaceRange(
        35,
        cartview.categoryListModel?[position].categoryTitle
            ?.length,
        '...');
  } else {
    return cartview.categoryListModel?[position].categoryTitle ??
        "";
  }
}
String? getCategoryViewTitleMobile(int position, CartViewModel cartview) {
  if ((cartview.categoryListModel?[position].categoryTitle?.length ?? 0) > 12) {
    return cartview.categoryListModel?[position].categoryTitle
        ?.replaceRange(
        12,
        cartview.categoryListModel?[position].categoryTitle
            ?.length,
        '...');
  } else {
    return cartview.categoryListModel?[position].categoryTitle ??
        "";
  }
}