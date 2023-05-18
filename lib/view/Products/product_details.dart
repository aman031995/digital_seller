import 'dart:convert';

import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/build_indicator.dart';
import 'package:TychoStream/utilities/color_dropdown.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/size_dropdown.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProductDetailPage extends StatefulWidget {
  ProductList? items;
  int? index;
  String? itemCount;
  Function? callback;
String? productColor;
String? productColorId;
String? productId;
String? variantId;
  ProductDetailPage(
      {Key? key, this.items, this.index, this.itemCount, this.variantId,this.productId,this.productColor,this.productColorId,this.callback})
      : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int currentIndex = 0;
  CartViewModel cartView = CartViewModel();
  String? checkInternet;
  int? selectedSizeIndex;
  String? chosenSize;
  String prodId = '';
  String variantId = '';
  String colorId = '';
  String colorName='';
  String sizeId = '';
  bool isfab = false;
  List _items = [];
  String? token;

  @override
  void initState() {
    _checkUser();
    cartView.updateColorId(
        context,
        widget.productColorId ?? " ",
        widget.productColor ?? '');
    cartView.updateCartCount(context, widget.itemCount ?? ''); //update cart count value
    // get productDetail by id
    if (widget.productId != null)
      cartView.getProductDetails(
          context,
          widget.productId ?? '',
          widget.variantId ?? '',
          widget.productColorId ?? '',
          '');
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

    // handle push notification/notification scenerio to show data
    receivedArgumentsNotification();
    return ChangeNotifierProvider<CartViewModel>(
        create: (BuildContext context) => cartView,
        child: Consumer<CartViewModel>(builder: (context, cartView, _) {
          return WillPopScope(
              onWillPop: _willPopCallback,
              child: Scaffold(
                  appBar: getAppBarWithBackBtn(
                      context: context,
                      isBackBtn: false,
                      isShopping: true,
                      isFavourite: false,
                      itemCount: cartView.cartItemCount,
                      onCartPressed: () {
                        GoRouter.of(context).pushNamed(RoutesName.CartDetails, queryParams: {
                          'itemCount':'${cartView.cartItemCount}',
                        });

                      },
                      onBackPressed: () {
                        _backBtnHandling(prodId);
                      }),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  // bottomNavigationBar: cartView.productListDetails != null
                  //     ? bottomNavigationButton()
                  //     : SizedBox(height: 1),
                  body:
                  cartView.productListDetails != null
                      ? SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 10),
                        productDetailImageView(cartView),
                        productTitle(cartView)
                      ],)


              )
                      : Center(child: ThreeArchedCircle(size: 45.0))));
        }));
  }

  // Mobile BackButton Method
  Future<bool> _willPopCallback() async {
    _backBtnHandling(prodId);
    return Future.value(true);
  }

  // Product Title and Price
  productTitle(CartViewModel cartView) {
    return Container(
        margin: EdgeInsets.only(left: 20,top: 10),
        padding: EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(child: AppBoldFont(context, msg: cartView.productListDetails?.productName ?? '', fontSize: 22)),
             SizedBox(height: 5),
              Container(
                  child: AppMediumFont(
                    context,
                    msg:
                    "${cartView.productListDetails?.productLongDesc ?? ''}",
                    fontSize: 18.0,
                  )),
              SizedBox(height: 5),
              AppBoldFont(context,
                  msg: "₹ "
                      "${cartView.productListDetails?.productDetails?.productDiscountPrice ?? ''}",
                  fontSize: 18),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    cartView.productListDetails?.productDetails
                        ?.productPrice !=
                        ''
                        ? AppMediumFont(context,
                        msg: "₹ "
                            "${cartView.productListDetails?.productDetails?.productPrice ?? ''}",
                        textDecoration:
                        TextDecoration.lineThrough,
                        fontSize: 16)
                        : SizedBox(),
                    SizedBox(width: 8.0),
                    AppMediumFont(context,
                        msg: cartView
                            .productListDetails
                            ?.productDetails
                            ?.productDiscountPercent !=
                            ''
                            ? "${cartView.productListDetails?.productDetails?.productDiscountPercent}" +
                            '% OFF'
                            : '',
                        fontSize: 16)
                  ]),
              SizedBox(height: 20),
              AppBoldFont(context,
                  msg: "Color : " +
                      '${cartView.selectedColorName}',
                  fontSize: 18),
              SizedBox(height: 10),
              cartView.productListDetails!.productSkuDetails!.colorDetails!.length > 4
                  ? Container(
                  color: TRANSPARENT_COLOR,
                  height: 50,
                  width: 200,
                  child: ColorDropDown(
                    // hintText: 'Select Color',
                    chosenValue: cartView.selectedColorId,
                    onChanged: (m) {
                      onColorSelected(m);
                      cartView.selectedColorId = m;
                      cartView.updateColorId(
                          context, cartView.selectedColorId, '');
                      cartView.productListDetails?.productSkuDetails
                          ?.colorDetails
                          ?.forEach((element) {
                        if (element.colorId ==
                            cartView.selectedColorId) {
                          cartView.updateColorId(
                              context,
                              cartView.selectedColorId,
                              element.colorName ?? '');
                        }
                      });
                    },
                    colorList: cartView.productListDetails!
                        .productSkuDetails!.colorDetails!,
                  ))
                  : Container(
                  height: 50,width: 150,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cartView.productListDetails
                          ?.productSkuDetails?.colorDetails?.length,
                      itemBuilder: (context, index) {
                        final finalColor = cartView
                            .productListDetails
                            ?.productSkuDetails
                            ?.colorDetails?[index]
                            .colorCode ??
                            '';
                        return InkWell(
                            onTap: () {
                              onColorSelected(cartView
                                  .productListDetails
                                  ?.productSkuDetails
                                  ?.colorDetails?[index]
                                  .colorId);
                              cartView.updateColorId(
                                  context,
                                  cartView
                                      .productListDetails
                                      ?.productSkuDetails
                                      ?.colorDetails?[index]
                                      .colorId ??
                                      '',
                                  cartView
                                      .productListDetails
                                      ?.productSkuDetails
                                      ?.colorDetails?[index]
                                      .colorName ??
                                      '');
                            },
                            child: Container(
                                height: 35,
                                width: 35,
                                margin: EdgeInsets.only(right: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: (finalColor).toColor(),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black,
                                        width: cartView
                                            .selectedColorId ==
                                            cartView
                                                .productListDetails
                                                ?.productSkuDetails
                                                ?.colorDetails?[
                                            index]
                                                .colorId
                                            ? 3
                                            : 1))));
                      })),
              SizedBox(height: 10),
              AppBoldFont(context,
                  msg: 'Size : ' + cartView.selectedSizeName,
                  fontSize: 18),
              SizedBox(height: 10),
              cartView.productListDetails!.productSkuDetails!.sizeDetails!.length > 4
                  ? Container(
                color: TRANSPARENT_COLOR,
                height: 50,
                width: 200,
                child: SizeDropDown(
                  hintText: 'Select Size',
                  chosenValue: chosenSize,
                  onChanged: (m) {
                    chosenSize = m;
                    onSizeSelected(chosenSize);
                    cartView.productListDetails?.productSkuDetails
                        ?.sizeDetails?.forEach((element) {
                      if (chosenSize == element.sizeId) {
                        cartView.updateSizeId(context, chosenSize ?? '', element.sizeName ?? '');
                      }
                    });
                  },
                  sizeList: cartView.productListDetails!.productSkuDetails!.sizeDetails!,
                ),
              ) :
              Container(
                  height: 50,width: 180,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cartView.productListDetails
                          ?.productSkuDetails?.sizeDetails?.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              selectedSizeIndex = index;
                              // cartView.updateSizeId(context,"${cartView.productListDetails?.productSkuDetails?.sizeDetails?[index].sizeId}");
                              onSizeSelected(cartView
                                  .productListDetails
                                  ?.productSkuDetails
                                  ?.sizeDetails?[index]
                                  .sizeId);
                              cartView.updateSizeId(
                                  context,
                                  "${cartView.productListDetails?.productSkuDetails?.sizeDetails?[index].sizeId}",
                                  cartView
                                      .productListDetails
                                      ?.productSkuDetails
                                      ?.sizeDetails?[index]
                                      .sizeName ??
                                      '');
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(right: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selectedSizeIndex != index
                                        ? TRANSPARENT_COLOR
                                        : Theme.of(context)
                                        .primaryColor,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .canvasColor,
                                        width: 2)),
                                child: AppBoldFont(
                                  context,
                                  msg:
                                  "${cartView.productListDetails?.productSkuDetails?.sizeDetails?[index].sizeName}",
                                  fontSize: 14.0,
                                  color: Theme.of(context).canvasColor,
                                )));
                      })),
              bottomNavigationButton()
            ]));
  }

  productDetailImageView(CartViewModel cartView) {
    return  Card(
        child: Container(
            width: SizeConfig.screenWidth/2.5,
            child: Stack(children: [
              CarouselSlider(
                  options: CarouselOptions(
                      height: SizeConfig.screenHeight / 1.2,
                      enableInfiniteScroll: true,
                      reverse: false,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      }),
                  items: cartView
                      .productListDetails?.productDetails?.productImages
                      ?.map((i) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        width: SizeConfig.screenWidth/2.2,
                        child: CachedNetworkImage(
                            imageUrl: '${i}',
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                    color:
                                    Theme.of(context).primaryColor))),
                      );
                    });
                  }).toList()),
              Positioned(
                  bottom: 10,
                  left: 1,
                  right: 1,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildIndicator(
                          cartView.productListDetails?.productDetails
                              ?.productImages,
                          currentIndex,
                          context))),
              Positioned(
                  right: 10,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).canvasColor),
                      height: 35,
                      width: 35,
                      child: IconButton(
                          icon: Icon(Icons.share_outlined),
                          onPressed: () {
                            // FirebaseDynamicLinksData.createDynamicLink(
                            //     context,
                            //     true,
                            //     '/product_detail?productId=${cartView.productListDetails?.productId ?? ""}'
                            //         '&variantId=${cartView.productListDetails?.productDetails?.variantId}'
                            //         '&colorId=${cartView.productListDetails?.productDetails?.productColorId}'
                            //         '&colorName=${cartView.productListDetails?.productDetails?.productColor}'
                            // );
                          }))),
              Positioned(
                  right: 10,
                  top: 45,
                  child: GestureDetector(
                      onTap: () {
                        if (token == 'null'){
                          _backBtnHandling(prodId);
                        } else {cartView.addToFavourite(
                            context,
                            "${cartView.productListDetails?.productId}",
                            "${cartView.productListDetails?.productDetails?.productColorId}",
                            cartView.productListDetails?.productDetails
                                ?.isFavorite ==
                                true
                                ? false
                                : true,
                            'productDetail');}

                      },
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).canvasColor),
                          height: 35,
                          width: 35,
                          child: Icon(Icons.favorite,
                              color: cartView.productListDetails
                                  ?.productDetails?.isFavorite ==
                                  true
                                  ? Colors.red
                                  : GREY_COLOR,
                              size: 25))))
            ])));
  }

  onColorSelected(String? colorId) {
    if (cartView.selectedColorId != colorId) {
      cartView.updateSizeId(context, "", '');
      selectedSizeIndex = null;
      chosenSize = null;
      cartView.isAddedToCart = false;
      AppIndicator.loadingIndicator(context);
      cartView.getProductDetails(
          context, widget.productId ?? prodId, '', colorId ?? '', '');
    }
  }

  onSizeSelected(String? sizeId) {
    if (cartView.selectedSizeId != sizeId) {
      cartView.isAddedToCart = false;
      AppIndicator.loadingIndicator(context);
      cartView.getProductDetails(context, widget.productId ?? prodId, '',
          cartView.selectedColorId, sizeId ?? '');
    }
  }

  // this method is called when navigate to this page using dynamic link
  receivedArgumentsNotification() {
    if (ModalRoute.of(context)?.settings.arguments != null && prodId == '') {
      final Map<String, dynamic> data =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      prodId = data['prodId'];
      variantId = data['variantId'];
      colorId = data['colorId'];
      colorName = data['colorName'];
      cartView.getProductDetails(context, prodId, variantId ?? "", colorId, sizeId);
      cartView.updateColorId(
          context,
          colorId,
          colorName);
    }
  }

  // give toast according to the empty field
  addToBagButtonPressed() {
    if ((cartView.productListDetails!.productSkuDetails!.sizeDetails!.length >
        4 && chosenSize == null) ||
        (cartView.productListDetails!.productSkuDetails!.sizeDetails!.length <=
            4 && selectedSizeIndex == null)) {
      ToastMessage.message('Select Size');
    } else {
      cartView.addToCart(
          cartView.productListDetails?.productId ?? '',
          "1",
          cartView.productListDetails?.productDetails?.variantId ?? '',
          false,
          context,
              (result, isSuccess) {});
    }
  }

  //Bottom Navigation
  bottomNavigationButton() {
    return Container(
      width: SizeConfig.screenWidth/2.5,
        height: 80,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(children: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).cardColor),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ))),
              child: AppBoldFont(context,
                  msg: (cartView.isAddedToCart == true ||
                      cartView.productListDetails?.productDetails
                          ?.isAddToCart ==
                          true) &&
                      (selectedSizeIndex != null || chosenSize != null)
                      ? "go to cart"
                      : "add to bag",
                  fontSize: 14),
              onPressed: () {
                if (token == 'null'){
                  _backBtnHandling(prodId);
                }
                else if (cartView.productListDetails?.productDetails?.isAvailable == true) {
                  (cartView.isAddedToCart == true || cartView.productListDetails?.productDetails?.isAddToCart == true) &&
                      (selectedSizeIndex != null || chosenSize != null)
                      ?  GoRouter.of(context).pushNamed(RoutesName.CartDetails, queryParams: {
                    'itemCount':'${cartView.cartItemCount}',
                  })
                  // AppNavigator.push(
                  //     context,
                  //     CartDetail(itemCount: cartView.cartItemCount,),
                  //     screenName: RouteBuilder.cartDetail,
                  //     function: (value) {
                  //       if (value != cartView.cartItemCount) {
                  //         // update cart count after page callback
                  //         cartView.updateCartCount(context, value);
                  //         AppIndicator.loadingIndicator(context);
                  //         cartView.getProductDetails(context, widget.items?.productId ?? '', '', cartView.selectedColorId, '');
                  //       }
                  //     })

                      : addToBagButtonPressed();
                }
              }),
          SizedBox(width: 5),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0),
                      ))),
              child: AppBoldFont(context,
                  msg: "WishList", fontSize: 14),
              onPressed: () {
                if (token == 'null'){
                  _backBtnHandling(prodId);
                }
                else if (cartView.productListDetails?.productDetails?.isAvailable == true) {
                  GoRouter.of(context).pushNamed(RoutesName.fav);
                  // AppNavigator.push(
                  //     context,
                  //     FavouriteListPage(
                  //         callback: (value) {
                  //           if (value == false) {
                  //             AppIndicator.loadingIndicator(context);
                  //             cartView.getProductDetails(context, widget.items?.productId ?? '', '', cartView.selectedColorId, '');
                  //           }
                  //         }),
                  //     screenName: RouteBuilder.Favourite,
                  //     function: (v) {
                  //       cartView.updateCartCount(context, v);
                  //       AppIndicator.loadingIndicator(context);
                  //       cartView.getProductDetails(context, widget.items?.productId ?? '', '', cartView.selectedColorId, '');
                  //     });
                }
              })
        ]));
  }

  void _backBtnHandling(String prodId) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token').toString();
    if(prodId != '' && token != 'null'){
      // AppNavigator.pushReplacement(context, BottomNavigationWidget());
    } else if (token == 'null'){
      ToastMessage.message("Please Login");
      // AppNavigator.pushReplacement(context, LoginScreen());
    } else {
      Navigator.pop(context, cartView.cartItemCount);
      widget.callback!(false);
    }
  }

  void _checkUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token').toString();
  }
}
