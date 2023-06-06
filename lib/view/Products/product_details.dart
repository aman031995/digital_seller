import 'dart:convert';

import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/build_indicator.dart';
import 'package:TychoStream/utilities/color_dropdown.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/size_dropdown.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AppRouter.gr.dart';

@RoutePage()
class ProductDetailPage extends StatefulWidget {
  final List<String>? productdata;
  final String? productId;
    ProductDetailPage(
      {
        @PathParam('productId') this.productId,
        @QueryParam() this.productdata,
        Key? key}) : super(key: key);

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
  String colorName='';
  String sizeName = '';
  bool isfab = false;
  List _items = [];
  String? token;

  @override
  void initState() {
    _checkUser();
    super.initState();
    cartView.updatecolorName(context, widget.productdata?[2] ?? '');
    cartView.updateCartCount(context, widget.productdata?[0] ?? ''); //update cart count value
    // get productDetail by id
    //0 =count,1var,2color
    if (widget.productId != null)
      cartView.getProductDetails(
          context,
          widget.productId ?? '',
          widget.productdata?[1] ?? '',
          widget.productdata?[2] ?? '',
          '');
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
            : Scaffold(
                appBar: getAppBarWithBackBtn(
                  title: "Product Details",
                    context: context,
                    isBackBtn: false,
                    isShopping: true,
                    isFavourite: false,
                    itemCount: cartView.cartItemCount,
                    onCartPressed: () {
                      context.router.push(CartDetail(
                          itemCount: '${cartView.cartItemCount}'
                      ));
                    },
                    onBackPressed: () {

                    }),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                // bottomNavigationBar: cartView.productListDetails != null
                //     ? bottomNavigationButton()
                //     : SizedBox(height: 1),

     body:
     cartView.productListDetails != null
         ? ResponsiveWidget.isMediumScreen(context)
         ? SingleChildScrollView(
       child: Container(
         margin: EdgeInsets.only(left: 10,top: SizeConfig.screenHeight*0.02,right: 10),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Stack(children: [
               CarouselSlider(
                   options: CarouselOptions(
                       height: SizeConfig.screenHeight /2.23,
                       enableInfiniteScroll: cartView.productListDetails?.productDetails?.productImages?.length==1?false:true,
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
                         width: SizeConfig.screenWidth,
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
               cartView.productListDetails?.productDetails?.productImages?.length == 1 ? Container() : Positioned(
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
                   right: 10, top: 5,
                   child: Container(
                       decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: Theme.of(context).canvasColor),
                       height: 35,
                       width: 35,
                       child: IconButton(
                           icon: Icon(Icons.share),
                           // icon: Image.asset(
                           //   AssetsConstants.ic_ShareIcon,
                           //   height: 30,
                           //   width: 30,
                           // ),
                           onPressed: () {
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
                             "${cartView.productListDetails?.productDetails?.productColor}",
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
             ]),
             SizedBox(height: 10),
             Container(
                 width: SizeConfig.screenWidth/1.1,
                 child: AppBoldFont(context, msg: cartView.productListDetails?.productDetails?.productVariantTitle ?? '', fontSize: 20)),
             SizedBox(height: 10),
             Container(
                 width: SizeConfig.screenWidth/1.1,
                 child: AppMediumFont(
                   context,
                   msg:
                   "${cartView.productListDetails?.productLongDesc ?? ''}",
                   fontSize: 18.0,
                 )),
             SizedBox(height: 10),
             AppBoldFont(context,
                 msg: "₹ "
                     "${cartView.productListDetails?.productDetails?.productDiscountPrice ?? ''}",
                 fontSize: 18),
             SizedBox(height: 5),
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
             Column(
               children: cartView.productListDetails?.productSkuDetails?.map((element){
                 return element.colorData != null ? Container(
                     padding: EdgeInsets.only(left: 5, top: 5, right: 10, bottom: 5),
                     width: SizeConfig.screenWidth/1.5,
                     child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           AppBoldFont(context, msg: StringConstant.color + '${cartView.selectedColorName}', fontSize: 18),
                           SizedBox(height: 5),
                           element.colorData!.length > 4
                               ? Container(
                               color: TRANSPARENT_COLOR,
                               height: 50,  width: SizeConfig.screenWidth/2.5,
                               child: ColorDropDown(
                                 // hintText: 'Select Color',
                                 chosenValue: cartView.selectedColorName,
                                 onChanged: (m) {
                                   onColorSelected(m);
                                   cartView.selectedColorName = m;
                                   cartView.updatecolorName(context, cartView.selectedColorName);
                                   element.colorData?.forEach((element) {
                                     if(element.name == cartView.selectedColorName){
                                       cartView.updatecolorName(context, cartView.selectedColorName);
                                     }
                                   });
                                 },
                                 colorData: element.colorData,
                               ))
                               : Container(
                               height: 50,
                               child: ListView.builder(
                                   scrollDirection: Axis.horizontal,
                                   itemCount: element.colorData?.length,
                                   itemBuilder: (context, index) {
                                     return InkWell(
                                         onTap: () {
                                           // onColorSelected(cartView.productListDetails?.productSkuDetails?.colorDetails?[index].colorName);
                                           onColorSelected(element.colorData?[index].name);
                                           cartView.updatecolorName(context, element.colorData?[index].name ?? '');
                                         },
                                         child: Container(
                                             height: 35,
                                             width: 35,
                                             margin: EdgeInsets.only(right: 10),
                                             alignment: Alignment.center,
                                             decoration: BoxDecoration(
                                                 color: (element.colorData?[index].val?.hex)?.toColor(),
                                                 shape: BoxShape.circle,
                                                 border: Border.all(
                                                     color: Colors.black,
                                                     width: cartView.selectedColorName ==  element.colorData?[index].name ? 3 : 1))));
                                   }))
                         ])) : SizedBox();
               }).toList() ?? [],
             ),
             SizedBox(height: 10),
             Column(
               children: cartView.productListDetails?.productSkuDetails?.map((element){
                 return element.data != null ? Container(
                     padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
                     width: SizeConfig.screenWidth/1.5,
                     child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           AppBoldFont(context,
                               msg: StringConstant.size + cartView.selectedSizeName,
                               fontSize: 18),
                           SizedBox(height: 8),
                           if(element.data != null)
                             element.data!.length > 4
                                 ? Container(
                               width: SizeConfig.screenWidth/2.5,
                               color: TRANSPARENT_COLOR, height: 50,
                               child: SizeDropDown(
                                 hintText: element.variationName,
                                 chosenValue: chosenSize,
                                 onChanged: (m) {
                                   chosenSize = m;
                                   onSizeSelected(chosenSize);
                                   element.data?.forEach((e) {
                                     if(chosenSize == e.val){
                                       cartView.updatesizeName(context,  e.val ?? '');
                                     }
                                   });

                                   // cartView.productListDetails?.productSkuDetails
                                   //     ?.sizeDetails?.forEach((element) {
                                   //   if (chosenSize == element.sizeName) {
                                   //     cartView.updatesizeName(context,  element.sizeName ?? '');
                                   //   }
                                   // });
                                 },
                                 sizeList: element.data!,
                               ),
                             ) :
                             Container(
                                 height: 50,
                                 child: ListView.builder(
                                     scrollDirection: Axis.horizontal,
                                     itemCount: element.data?.length,
                                     itemBuilder: (context, index) {
                                       return InkWell(
                                           onTap: () {
                                             selectedSizeIndex = index;
                                             // cartView.updatesizeName(context,"${cartView.productListDetails?.productSkuDetails?.sizeDetails?[index].sizeName}");
                                             // onSizeSelected(cartView.productListDetails?.productSkuDetails?.sizeDetails?[index].sizeName);
                                             onSizeSelected(element.data?[index].name);
                                             cartView.updatesizeName(context, "${element.data?[index].name}");
                                           },
                                           child: Container(
                                               height: 40,
                                               width: 40,
                                               margin: EdgeInsets.only(right: 10),
                                               alignment: Alignment.center,
                                               decoration: BoxDecoration(
                                                   shape: BoxShape.circle,
                                                   color: selectedSizeIndex != index ? TRANSPARENT_COLOR : Theme.of(context).primaryColor,
                                                   border: Border.all(
                                                       color: Theme.of(context).canvasColor,
                                                       width: 2)),
                                               child: AppBoldFont(
                                                 context,
                                                 msg:
                                                 "${element.data?[index].name}",
                                                 fontSize: 14.0,
                                                 color: Theme.of(context).canvasColor,
                                               )));
                                     }))
                         ])) : SizedBox();
               }).toList() ?? [],
             ),
             bottomNavigationButton()
           ],
         ),
       ),
     ):
     SingleChildScrollView(
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(margin: EdgeInsets.only(left: SizeConfig.screenWidth*0.16,top: SizeConfig.screenHeight*0.02),
               width: SizeConfig.screenWidth/2.5,
               child: Stack(children: [
                 CarouselSlider(
                     options: CarouselOptions(
                         height: SizeConfig.screenHeight / 1.25,
                         enableInfiniteScroll: cartView.productListDetails?.productDetails?.productImages?.length==1?false:true,
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
                           width: SizeConfig.screenWidth,
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
                 cartView.productListDetails?.productDetails?.productImages?.length == 1 ? Container() : Positioned(
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
                     right: 10, top: 5,
                     child: Container(
                         decoration: BoxDecoration(
                             shape: BoxShape.circle,
                             color: Theme.of(context).canvasColor),
                         height: 35,
                         width: 35,
                         child: IconButton(
                           icon: Icon(Icons.share),
                             // icon: Image.asset(
                             //   AssetsConstants.ic_ShareIcon,
                             //   height: 30,
                             //   width: 30,
                             // ),
                             onPressed: () {
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
                               "${cartView.productListDetails?.productDetails?.productColor}",
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
               ])),
           Container(
               margin: EdgeInsets.only(left: 20,top: SizeConfig.screenHeight*0.02),
               padding: EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
               child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Container(
                         width: SizeConfig.screenWidth/4,
                         child: AppBoldFont(context, msg: cartView.productListDetails?.productDetails?.productVariantTitle ?? '', fontSize: 22)),
                     SizedBox(height: 10),
                     Container(
                         width: SizeConfig.screenWidth/4,
                         child: AppMediumFont(
                           context,
                           msg:
                           "${cartView.productListDetails?.productLongDesc ?? ''}",
                           fontSize: 18.0,
                         )),
                     SizedBox(height: 10),
                     AppBoldFont(context,
                         msg: "₹ "
                             "${cartView.productListDetails?.productDetails?.productDiscountPrice ?? ''}",
                         fontSize: 18),
                     SizedBox(height: 5),
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
                     Column(
                       children: cartView.productListDetails?.productSkuDetails?.map((element){
                         return element.colorData != null ? Container(
                             padding: EdgeInsets.only(left: 5, top: 5, right: 10, bottom: 5),
                             width: SizeConfig.screenWidth/4,
                             child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   AppBoldFont(context, msg: StringConstant.color + '${cartView.selectedColorName}', fontSize: 18),
                                   SizedBox(height: 5),
                                   element.colorData!.length > 4
                                       ? Container(
                                       color: TRANSPARENT_COLOR,
                                       height: 50,  width: SizeConfig.screenWidth*0.09,
                                       child: ColorDropDown(
                                         // hintText: 'Select Color',
                                         chosenValue: cartView.selectedColorName,
                                         onChanged: (m) {
                                           onColorSelected(m);
                                           cartView.selectedColorName = m;
                                           cartView.updatecolorName(context, cartView.selectedColorName);
                                           element.colorData?.forEach((element) {
                                             if(element.name == cartView.selectedColorName){
                                               cartView.updatecolorName(context, cartView.selectedColorName);
                                             }
                                           });
                                         },
                                         colorData: element.colorData,
                                       ))
                                       : Container(
                                       height: 50,
                                       child: ListView.builder(
                                           scrollDirection: Axis.horizontal,
                                           itemCount: element.colorData?.length,
                                           itemBuilder: (context, index) {
                                             return InkWell(
                                                 onTap: () {
                                                   // onColorSelected(cartView.productListDetails?.productSkuDetails?.colorDetails?[index].colorName);
                                                   onColorSelected(element.colorData?[index].name);
                                                   cartView.updatecolorName(context, element.colorData?[index].name ?? '');
                                                 },
                                                 child: Container(
                                                     height: 35,
                                                     width: 35,
                                                     margin: EdgeInsets.only(right: 10),
                                                     alignment: Alignment.center,
                                                     decoration: BoxDecoration(
                                                         color: (element.colorData?[index].val?.hex)?.toColor(),
                                                         shape: BoxShape.circle,
                                                         border: Border.all(
                                                             color: Colors.black,
                                                             width: cartView.selectedColorName ==  element.colorData?[index].name ? 3 : 1))));
                                           }))
                                 ])) : SizedBox();
                       }).toList() ?? [],
                     ),
                     SizedBox(height: 10),
                     Column(
                       children: cartView.productListDetails?.productSkuDetails?.map((element){
                         return element.data != null ? Container(
                             padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
                             width: SizeConfig.screenWidth/4,
                             child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   AppBoldFont(context,
                                       msg: StringConstant.size + cartView.selectedSizeName,
                                       fontSize: 18),
                                   SizedBox(height: 8),
                                   if(element.data != null)
                                     element.data!.length > 4
                                         ? Container(
                                       width: SizeConfig.screenWidth*0.09,
                                       color: TRANSPARENT_COLOR, height: 50,
                                       child: SizeDropDown(
                                         hintText: element.variationName,
                                         chosenValue: chosenSize,
                                         onChanged: (m) {
                                           chosenSize = m;
                                           onSizeSelected(chosenSize);
                                           element.data?.forEach((e) {
                                             if(chosenSize == e.val){
                                               cartView.updatesizeName(context,  e.val ?? '');
                                             }
                                           });

                                           // cartView.productListDetails?.productSkuDetails
                                           //     ?.sizeDetails?.forEach((element) {
                                           //   if (chosenSize == element.sizeName) {
                                           //     cartView.updatesizeName(context,  element.sizeName ?? '');
                                           //   }
                                           // });
                                         },
                                         sizeList: element.data!,
                                       ),
                                     ) :
                                     Container(
                                         height: 50,
                                         child: ListView.builder(
                                             scrollDirection: Axis.horizontal,
                                             itemCount: element.data?.length,
                                             itemBuilder: (context, index) {
                                               return InkWell(
                                                   onTap: () {
                                                     selectedSizeIndex = index;
                                                     // cartView.updatesizeName(context,"${cartView.productListDetails?.productSkuDetails?.sizeDetails?[index].sizeName}");
                                                     // onSizeSelected(cartView.productListDetails?.productSkuDetails?.sizeDetails?[index].sizeName);
                                                     onSizeSelected(element.data?[index].name);
                                                     cartView.updatesizeName(context, "${element.data?[index].name}");
                                                   },
                                                   child: Container(
                                                       height: 40,
                                                       width: 40,
                                                       margin: EdgeInsets.only(right: 10),
                                                       alignment: Alignment.center,
                                                       decoration: BoxDecoration(
                                                           shape: BoxShape.circle,
                                                           color: selectedSizeIndex != index ? TRANSPARENT_COLOR : Theme.of(context).primaryColor,
                                                           border: Border.all(
                                                               color: Theme.of(context).canvasColor,
                                                               width: 2)),
                                                       child: AppBoldFont(
                                                         context,
                                                         msg:
                                                         "${element.data?[index].name}",
                                                         fontSize: 14.0,
                                                         color: Theme.of(context).canvasColor,
                                                       )));
                                             }))
                                 ])) : SizedBox();
                       }).toList() ?? [],
                     ),
                     bottomNavigationButton()
                   ]))
         ],
       ),
     ):
     Center(child: ThreeArchedCircle(size: 45.0))
      );
    }

// WillPopScope(
//               onWillPop: _willPopCallback,
//               child: Scaffold(
//                   appBar: getAppBarWithBackBtn(
//                       context: context,
//                       isBackBtn: false,
//                       isShopping: true,
//                       isFavourite: false,
//                       itemCount: cartView.cartItemCount,
//                       onCartPressed: () {
//                         GoRouter.of(context).pushNamed(RoutesName.CartDetails, queryParameters: {
//                           'itemCount':'${cartView.cartItemCount}',
//                         });
//                       },
//                       onBackPressed: () {
//                         _backBtnHandling(prodId);
//                       }),
//                   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                   // bottomNavigationBar: cartView.productListDetails != null
//                   //     ? bottomNavigationButton()
//                   //     : SizedBox(height: 1),
//                   body: cartView.productListDetails != null
//                       ? SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(width: SizeConfig.screenWidth*0.14),
//                             productDetailImageView(cartView),
//                             productTitle(cartView)
//                           ],),
//                           SizedBox(height: 50),
//                           footerDesktop()
//                         ],
//                       )
//               ) : Center(child: ThreeArchedCircle(size: 45.0))));
  // Mobile BackButton Method
  Future<bool> _willPopCallback() async {
    _backBtnHandling(prodId);
    return Future.value(true);
  }

  // // Product Title and Price
  // productTitle(CartViewModel cartView) {
  //   return
  //     Container(
  //       margin: EdgeInsets.only(left: 20,top: 10),
  //       padding: EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
  //       child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //                 width: SizeConfig.screenWidth/5,
  //                 child: AppBoldFont(context, msg: cartView.productListDetails?.productDetails?.productVariantTitle ?? '', fontSize: 22)),
  //            SizedBox(height: 10),
  //             Container(
  //                 width: SizeConfig.screenWidth/5,
  //                 child: AppMediumFont(
  //                   context,
  //                   msg:
  //                   "${cartView.productListDetails?.productLongDesc ?? ''}",
  //                   fontSize: 18.0,
  //                 )),
  //             SizedBox(height: 10),
  //             AppBoldFont(context,
  //                 msg: "₹ "
  //                     "${cartView.productListDetails?.productDetails?.productDiscountPrice ?? ''}",
  //                 fontSize: 18),
  //             SizedBox(height: 5),
  //             Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   cartView.productListDetails?.productDetails
  //                       ?.productPrice !=
  //                       ''
  //                       ? AppMediumFont(context,
  //                       msg: "₹ "
  //                           "${cartView.productListDetails?.productDetails?.productPrice ?? ''}",
  //                       textDecoration:
  //                       TextDecoration.lineThrough,
  //                       fontSize: 16)
  //                       : SizedBox(),
  //                   SizedBox(width: 8.0),
  //                   AppMediumFont(context,
  //                       msg: cartView
  //                           .productListDetails
  //                           ?.productDetails
  //                           ?.productDiscountPercent !=
  //                           ''
  //                           ? "${cartView.productListDetails?.productDetails?.productDiscountPercent}" +
  //                           '% OFF'
  //                           : '',
  //                       fontSize: 16)
  //                 ]),
  //             SizedBox(height: 20),
  //             Column(
  //               children: cartView.productListDetails?.productSkuDetails?.map((element){
  //                 return element.colorData != null ? Container(
  //                     padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
  //                     width: SizeConfig.screenWidth/4,
  //                     child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           AppBoldFont(context, msg: StringConstant.color + '${cartView.selectedColorName}', fontSize: 18),
  //                           SizedBox(height: 5),
  //                           element.colorData!.length > 4
  //                               ? Container(
  //                               color: TRANSPARENT_COLOR,
  //                               height: 50,  width: SizeConfig.screenWidth*0.09,
  //                               child: ColorDropDown(
  //                                 // hintText: 'Select Color',
  //                                 chosenValue: cartView.selectedColorName,
  //                                 onChanged: (m) {
  //                                   onColorSelected(m);
  //                                   cartView.selectedColorName = m;
  //                                   cartView.updatecolorName(context, cartView.selectedColorName);
  //                                   element.colorData?.forEach((element) {
  //                                     if(element.name == cartView.selectedColorName){
  //                                       cartView.updatecolorName(context, cartView.selectedColorName);
  //                                     }
  //                                   });
  //                                 },
  //                                 colorData: element.colorData,
  //                               ))
  //                               : Container(
  //                               height: 50,
  //                               child: ListView.builder(
  //                                   scrollDirection: Axis.horizontal,
  //                                   itemCount: element.colorData?.length,
  //                                   itemBuilder: (context, index) {
  //                                     return InkWell(
  //                                         onTap: () {
  //                                           // onColorSelected(cartView.productListDetails?.productSkuDetails?.colorDetails?[index].colorName);
  //                                           onColorSelected(element.colorData?[index].name);
  //                                           cartView.updatecolorName(context, element.colorData?[index].name ?? '');
  //                                         },
  //                                         child: Container(
  //                                             height: 35,
  //                                             width: 35,
  //                                             margin: EdgeInsets.only(right: 10),
  //                                             alignment: Alignment.center,
  //                                             decoration: BoxDecoration(
  //                                                 color: (element.colorData?[index].val?.hex)?.toColor(),
  //                                                 shape: BoxShape.circle,
  //                                                 border: Border.all(
  //                                                     color: Colors.black,
  //                                                     width: cartView.selectedColorName ==  element.colorData?[index].name ? 3 : 1))));
  //                                   }))
  //                         ])) : SizedBox();
  //               }).toList() ?? [],
  //             ),
  //             SizedBox(height: 10),
  //             Column(
  //               children: cartView.productListDetails?.productSkuDetails?.map((element){
  //                 return element.data != null ? Container(
  //                     padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
  //                     width: SizeConfig.screenWidth/4,
  //                     child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           AppBoldFont(context,
  //                               msg: StringConstant.size + cartView.selectedSizeName,
  //                               fontSize: 18),
  //                           SizedBox(height: 8),
  //                           if(element.data != null)
  //                             element.data!.length > 4
  //                                 ? Container(
  //                               width: SizeConfig.screenWidth*0.09,
  //                               color: TRANSPARENT_COLOR, height: 50,
  //                               child: SizeDropDown(
  //                                 hintText: element.variationName,
  //                                 chosenValue: chosenSize,
  //                                 onChanged: (m) {
  //                                   chosenSize = m;
  //                                   onSizeSelected(chosenSize);
  //                                   element.data?.forEach((e) {
  //                                     if(chosenSize == e.val){
  //                                       cartView.updatesizeName(context,  e.val ?? '');
  //                                     }
  //                                   });
  //
  //                                   // cartView.productListDetails?.productSkuDetails
  //                                   //     ?.sizeDetails?.forEach((element) {
  //                                   //   if (chosenSize == element.sizeName) {
  //                                   //     cartView.updatesizeName(context,  element.sizeName ?? '');
  //                                   //   }
  //                                   // });
  //                                 },
  //                                 sizeList: element.data!,
  //                               ),
  //                             ) :
  //                             Container(
  //                                 height: 50,
  //                                 child: ListView.builder(
  //                                     scrollDirection: Axis.horizontal,
  //                                     itemCount: element.data?.length,
  //                                     itemBuilder: (context, index) {
  //                                       return InkWell(
  //                                           onTap: () {
  //                                             selectedSizeIndex = index;
  //                                             // cartView.updatesizeName(context,"${cartView.productListDetails?.productSkuDetails?.sizeDetails?[index].sizeName}");
  //                                             // onSizeSelected(cartView.productListDetails?.productSkuDetails?.sizeDetails?[index].sizeName);
  //                                             onSizeSelected(element.data?[index].name);
  //                                             cartView.updatesizeName(context, "${element.data?[index].name}");
  //                                           },
  //                                           child: Container(
  //                                               height: 40,
  //                                               width: 40,
  //                                               margin: EdgeInsets.only(right: 10),
  //                                               alignment: Alignment.center,
  //                                               decoration: BoxDecoration(
  //                                                   shape: BoxShape.circle,
  //                                                   color: selectedSizeIndex != index ? TRANSPARENT_COLOR : Theme.of(context).primaryColor,
  //                                                   border: Border.all(
  //                                                       color: Theme.of(context).canvasColor,
  //                                                       width: 2)),
  //                                               child: AppBoldFont(
  //                                                 context,
  //                                                 msg:
  //                                                 "${element.data?[index].name}",
  //                                                 fontSize: 14.0,
  //                                                 color: Theme.of(context).canvasColor,
  //                                               )));
  //                                     }))
  //                         ])) : SizedBox();
  //               }).toList() ?? [],
  //             ),
  //             bottomNavigationButton()
  //           ]));
  // }
  //
  // productDetailImageView(CartViewModel cartView) {
  //   return  Card(
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(5)
  //         ),
  //           width: SizeConfig.screenWidth/2.5,
  //           child: Stack(children: [
  //             CarouselSlider(
  //                 options: CarouselOptions(
  //                     height: SizeConfig.screenHeight / 1.2,
  //                     enableInfiniteScroll: cartView
  //                         .productListDetails?.productDetails?.productImages?.length ==1?false :true,
  //                     reverse: false,
  //                     viewportFraction: 1,
  //                     onPageChanged: (index, reason) {
  //                       setState(() {
  //                         currentIndex = index;
  //                       });
  //                     }),
  //                 items: cartView
  //                     .productListDetails?.productDetails?.productImages
  //                     ?.map((i) {
  //                   return Builder(builder: (BuildContext context) {
  //                     return Container(
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(5)
  //                       ),
  //                       width: SizeConfig.screenWidth/2.2,
  //                       child: CachedNetworkImage(
  //                           imageUrl: '${i}',
  //                           fit: BoxFit.fill,
  //                           placeholder: (context, url) => Center(
  //                               child: CircularProgressIndicator(
  //                                   color:
  //                                   Theme.of(context).primaryColor))),
  //                     );
  //                   });
  //                 }).toList()),
  //             cartView
  //                 .productListDetails?.productDetails?.productImages?.length==1?Container()   :Positioned(
  //                 bottom: 10,
  //                 left: 1,
  //                 right: 1,
  //                 child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: buildIndicator(
  //                         cartView.productListDetails?.productDetails
  //                             ?.productImages,
  //                         currentIndex,
  //                         context))),
  //             Positioned(
  //                 right: 10,
  //                 child: Container(
  //                     decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: Theme.of(context).canvasColor),
  //                     height: 35,
  //                     width: 35,
  //                     child: IconButton(
  //                         icon: Icon(Icons.share_outlined),
  //                         onPressed: () {
  //                           // FirebaseDynamicLinksData.createDynamicLink(
  //                           //     context,
  //                           //     true,
  //                           //     '/product_detail?productId=${cartView.productListDetails?.productId ?? ""}'
  //                           //         '&variantId=${cartView.productListDetails?.productDetails?.variantId}'
  //                           //         '&colorId=${cartView.productListDetails?.productDetails?.productColorId}'
  //                           //         '&colorName=${cartView.productListDetails?.productDetails?.productColor}'
  //                           // );
  //                         }))),
  //             Positioned(
  //                 right: 10,
  //                 top: 45,
  //                 child: GestureDetector(
  //                     onTap: () {
  //                       if (token == 'null'){
  //                         _backBtnHandling(prodId);
  //                       } else {cartView.addToFavourite(
  //                           context,
  //                           "${cartView.productListDetails?.productId}",
  //                           "${cartView.productListDetails?.productDetails?.productColor}",
  //                           cartView.productListDetails?.productDetails?.isFavorite == true ? false : true,
  //                           'productDetail');}
  //
  //                     },
  //                     child: Container(
  //                         decoration: BoxDecoration(
  //                             shape: BoxShape.circle,
  //                             color: Theme.of(context).canvasColor),
  //                         height: 35,
  //                         width: 35,
  //                         child: Icon(Icons.favorite,
  //                             color: cartView.productListDetails
  //                                 ?.productDetails?.isFavorite ==
  //                                 true
  //                                 ? Colors.red
  //                                 : GREY_COLOR,
  //                             size: 25))))
  //           ])));
  // }

  onColorSelected(String? colorName) {
    if (cartView.selectedColorName != colorName) {
      cartView.updatesizeName(context, "");
      selectedSizeIndex = null;
      chosenSize = null;
      cartView.isAddedToCart = false;
      AppIndicator.loadingIndicator(context);
      cartView.getProductDetails(
          context, widget.productId ?? prodId, "", colorName ?? " ", '');
    }
  }

  onSizeSelected(String? sizeName) {
    if (cartView.selectedSizeName != sizeName) {
      cartView.isAddedToCart = false;
      AppIndicator.loadingIndicator(context);
      cartView.getProductDetails(context, widget.productId ?? prodId, '',
          cartView.selectedColorName, sizeName ?? '');
    }
  }

  // this method is called when navigate to this page using dynamic link
  receivedArgumentsNotification() {
    if (ModalRoute.of(context)?.settings.arguments != null && prodId == '') {
      final Map<String, dynamic> data =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      prodId = data['prodId'];
      variantId = data['variantId'];
      colorName = data['colorName'];
      cartView.getProductDetails(context, prodId, variantId,colorName,"");
      cartView.updatecolorName(
          context,
          colorName);
    }
  }

  // give toast according to the empty field
  addToBagButtonPressed() {
    cartView.productListDetails?.productSkuDetails?.forEach((e){
      if(e.data != null){
        if ((e.data!.length > 4 && chosenSize == null) || (e.data!.length <= 4 && selectedSizeIndex == null)) {
          ToastMessage.message('Select Size');
        } else {
          cartView.addToCart(
              cartView.productListDetails?.productId ?? '',
              "1",
              cartView.productListDetails?.productDetails?.variantId ?? '',
              false,
              context, (result, isSuccess) {});
        }
      }
    });
  }

  //Bottom Navigation
  bottomNavigationButton() {
    return Container(

        height: 80,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).cardColor),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ))),
              child: AppBoldFont(context,
                  msg: (cartView.isAddedToCart == true ||
                      cartView.productListDetails?.productDetails
                          ?.isAddToCart ==
                          true) &&
                      (selectedSizeIndex != null || chosenSize != null)
                      ? "Go to Cart"
                      : "Add to Bag",
                  fontSize: 16),
              onPressed: () {
                if (token == 'null'){
                  _backBtnHandling(prodId);
                }
                else if (cartView.productListDetails?.productDetails?.isAvailable == true) {
                  (cartView.isAddedToCart == true || cartView.productListDetails?.productDetails?.isAddToCart == true) &&
                      (selectedSizeIndex != null || chosenSize != null)
                      ?
                  context.router.push(CartDetail(
                    itemCount: '${cartView.cartItemCount}'
                  ))
                  // GoRouter.of(context).pushNamed(RoutesName.CartDetails, queryParameters: {
                  //   'itemCount':'${cartView.cartItemCount}',
                  // })
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
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),
                      ))),
              child: AppBoldFont(context,
                  msg: "WishList", fontSize: 16),
              onPressed: () {
                if (token == 'null'){
                  _backBtnHandling(prodId);
                }
                else if (cartView.productListDetails?.productDetails?.isAvailable == true) {
                  context.router.push(FavouriteListPage());
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

    }
  }

  void _checkUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token').toString();
  }
}
