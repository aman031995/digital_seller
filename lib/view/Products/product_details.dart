import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/build_indicator.dart';
import 'package:TychoStream/utilities/color_dropdown.dart';
import 'package:TychoStream/utilities/size_dropdown.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/Products/productSkuDetailView.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
  int? selectedMaterialIndex;
  int? selectedStyleIndex;
  int? selectedUnitIndex;
  String? chosenSize;
  String prodId = '';
  String variantId = '';
  String colorName='';
  String sizeName = '';
  bool isfab = false;
  String? token;
  List<Widget> cardWidgets = [];
  var proDetails;

  void initState() {
    SessionStorageHelper.removeValue('token');
    cartView.getCartCount(context);
    getProductDetails();
    super.initState();
  }

  getProductDetails(){
    if(widget.productdata?.length ==1){
      cartView.getProductListCategory(
          context, widget.productId ?? "", widget.productdata?[0] ?? "", 1);
    } else {
      if (widget.productId != null)
         cartView.updatecolorName(context,'');
      cartView.updateCartCount(context, widget.productdata?[0] ?? '');
        cartView.getProductDetails(
            context,
            widget.productId ?? "",
            widget.productdata?[1] ?? "",
            widget.productdata?[2] ?? "",
            widget.productdata?[3] ?? "",
            widget.productdata?[4] ?? "",
            widget.productdata?[5] ?? "",
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });

    return
      checkInternet == "Offline"
          ? NOInternetScreen()
          : ChangeNotifierProvider.value(
        value: cartView,
        child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
          return Scaffold(
                appBar: getAppBarWithBackBtn(
                  title: "Product Details",
                    context: context,
                    isBackBtn: false,
                    isShopping: true,
                    isFavourite: false,
                    itemCount: viewmodel.cartItemCount,
                    onCartPressed: ()async{
                      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                      token = sharedPreferences.getString('token').toString();
                      if (token == 'null'){
                        showDialog(
                            context: context,
                            barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
                            builder:
                                (BuildContext context) {
                              return  LoginUp(
                                product: true,
                              );
                            });
                        // _backBtnHandling(prodId);
                      } else{
                        context.router.push(CartDetail(
                            itemCount: '${viewmodel.cartItemCount}'
                        ));
                      }

                    },
                    onBackPressed: () {
                    }),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
           body: viewmodel.productListDetails != null ?
           SingleChildScrollView(child:
           ResponsiveWidget.isMediumScreen(context)
               ?
           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Center(
                 child: Container(
                     width: SizeConfig.screenWidth/1.1,
                     child: Stack(children: [
                       CarouselSlider(
                           options: CarouselOptions(
                               height: SizeConfig.screenHeight /2.2,
                               enableInfiniteScroll: viewmodel.productListDetails?.productDetails?.productImages?.length==1?false:true,
                               reverse: false,
                               viewportFraction: 1,
                               onPageChanged: (index, reason) {
                                 setState(() {
                                   currentIndex = index;
                                 });
                               }),
                           items: viewmodel
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
                       viewmodel.productListDetails?.productDetails?.productImages?.length == 1 ? Container() :
                       Positioned(
                           bottom: 10,
                           left: 1,
                           right: 1,
                           child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: buildIndicator(
                                   viewmodel.productListDetails?.productDetails
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
                               child: IconButton(color: Colors.white,
                                   icon: Icon(Icons.share,color: Colors.white,),
                                   onPressed: () {}))),
                       Positioned(
                           right: 10,
                           top: 45,
                           child: GestureDetector(
                               onTap: ()async{
                                 SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                 token = sharedPreferences.getString('token').toString();
                                 if (token == 'null'){
                                   showDialog(
                                       context: context,
                                       barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
                                       builder:
                                           (BuildContext context) {
                                         return  LoginUp(
                                           product: true,
                                         );
                                       });
                                   // _backBtnHandling(prodId);
                                 } else {
                                   final isFav =
                                   viewmodel.productListDetails?.productDetails!.isFavorite = !viewmodel.productListDetails!.productDetails!.isFavorite!;
                                   viewmodel.addToFavourite(
                                       context,
                                       "${viewmodel.productListDetails?.productId}",
                                       "${viewmodel.productListDetails?.productDetails?.variantId}",
                                       isFav!,
                                       'productList');
                                   // viewmodel.addToFavourite(
                                   //   context,
                                   //   "${viewmodel.productListDetails?.productId}",
                                   //   "${viewmodel.productListDetails?.productDetails?.productColor}",
                                   //   viewmodel.productListDetails?.productDetails
                                   //       ?.isFavorite ==
                                   //       true
                                   //       ? false
                                   //       : true,
                                   //   'productDetail');
                                 }
                               },
                               child: Container(
                                   decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       color: Theme.of(context).canvasColor),
                                   height: 35,
                                   width: 35,
                                   child: Icon(Icons.favorite,
                                       color: viewmodel.productListDetails
                                           ?.productDetails?.isFavorite ==
                                           true
                                           ? Colors.red
                                           : Colors.white,
                                       size: 25))))
                     ])),
               ),
               Container(
                   width: SizeConfig.screenWidth,
                   color: Theme.of(context).cardColor,
                   padding: EdgeInsets.only(left: 20.0, right: 10, top: 4, bottom: 4),
                   child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         AppBoldFont(context, msg: viewmodel.productListDetails?.productDetails?.productVariantTitle ?? '', fontSize:
                              16,),
                         // SizedBox(height: 10),
                         AppMediumFont(
                           context, color: Theme.of(context).canvasColor.withOpacity(0.8),
                           msg:
                           "${viewmodel.productListDetails?.productShortDesc ?? ''}",
                           fontSize: 14,
                         ),
                         Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               viewmodel.productListDetails?.productDetails
                                   ?.productPrice !=
                                   ''
                                   ? AppMediumFont(context,color: Colors.black.withOpacity(0.7),
                                   msg: "₹"
                                       "${viewmodel.productListDetails?.productDetails?.productPrice ?? ''}",
                                   textDecoration:
                                   TextDecoration.lineThrough,
                                   fontSize: 14)
                                   : SizedBox(),
                               SizedBox(width: 8.0), AppBoldFont(context,
                                   msg: "₹ "
                                       "${viewmodel.productListDetails?.productDetails?.productDiscountPrice ?? ''}",
                                   fontSize: 16),SizedBox(width: 8.0),
                               AppMediumFont(context,
                                   msg: viewmodel
                                       .productListDetails
                                       ?.productDetails
                                       ?.productDiscountPercent !=
                                       ''
                                       ? "${viewmodel.productListDetails?.productDetails?.productDiscountPercent}" +
                                       '% OFF'
                                       : '',color: GREEN,
                                   fontSize: 16)
                             ]),
                         SizedBox(height: 8),
                         Container(
                           child: ProductSkuView(
                               selected: true,
                               skuDetails: cartView.productListDetails?.productSkuDetails,
                               cartView: cartView,
                               productList: cartView.productListDetails?.productDetails?.defaultVariationSku),
                         ),
                         bottomNavigationButton()
                       ]))
             ],
           ):
           Row(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(margin: EdgeInsets.only(top: SizeConfig.screenHeight*0.02),
               width: SizeConfig.screenWidth/3.5,
               child: Stack(children: [
                 CarouselSlider(
                     options: CarouselOptions(
                         height: SizeConfig.screenHeight / 1.35,
                         enableInfiniteScroll: viewmodel.productListDetails?.productDetails?.productImages?.length==1?false:true,
                         reverse: false,
                         viewportFraction: 1,
                         onPageChanged: (index, reason) {
                           setState(() {
                             currentIndex = index;
                           });
                         }),
                     items: viewmodel
                         .productListDetails?.productDetails?.productImages
                         ?.map((i) {
                       return Builder(builder: (BuildContext context) {
                         return Container(
                           width: SizeConfig.screenWidth/1.2,
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
                 viewmodel.productListDetails?.productDetails?.productImages?.length == 1 ? Container() :
                 Positioned(
                     bottom: 10,
                     left: 1,
                     right: 1,
                     child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: buildIndicator(
                             viewmodel.productListDetails?.productDetails
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
                         child: IconButton(color: Colors.white,
                           icon: Icon(Icons.share,color: Colors.white,),
                             onPressed: () {}))),
                 Positioned(
                     right: 10,
                     top: 45,
                     child: GestureDetector(
                         onTap: ()async{
                           SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                           token = sharedPreferences.getString('token').toString();
                           if (token == 'null'){
                             showDialog(
                                 context: context,
                                 barrierColor: Colors.black87,
                                 builder:
                                     (BuildContext context) {
                                   return  LoginUp(
                                     product: true,
                                   );
                                 });
                             // _backBtnHandling(prodId);
                           } else {
                             final isFav =
                                 viewmodel.productListDetails?.productDetails!.isFavorite = !viewmodel.productListDetails!.productDetails!.isFavorite!;
                             viewmodel.addToFavourite(
                                 context,
                                 "${viewmodel.productListDetails?.productId}",
                                 "${viewmodel.productListDetails?.productDetails?.variantId}",
                                 isFav!,
                                 'productList');
                             // viewmodel.addToFavourite(
                             //   context,
                             //   "${viewmodel.productListDetails?.productId}",
                             //   "${viewmodel.productListDetails?.productDetails?.productColor}",
                             //   viewmodel.productListDetails?.productDetails
                             //       ?.isFavorite ==
                             //       true
                             //       ? false
                             //       : true,
                             //   'productDetail');
                           }
                           },
                         child: Container(
                             decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Theme.of(context).canvasColor),
                             height: 35,
                             width: 35,
                             child: Icon(Icons.favorite,
                                 color: viewmodel.productListDetails
                                     ?.productDetails?.isFavorite ==
                                     true
                                     ? Colors.red
                                     : Colors.white,
                                 size: 25))))
               ])),
           Container(
               width: SizeConfig.screenWidth/3,
               margin: EdgeInsets.only(left: 20,top: SizeConfig.screenHeight*0.02),
               padding: EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
               child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     AppBoldFont(context, msg: viewmodel.productListDetails?.productDetails?.productVariantTitle ?? '', fontSize: 22),
                     // SizedBox(height: 10),
                     AppMediumFont(
                       context,
                       msg:
                       "${viewmodel.productListDetails?.productShortDesc ?? ''}",
                       fontSize: 16.0,
                     ),
                     Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           viewmodel.productListDetails?.productDetails
                               ?.productPrice !=
                               ''
                               ? AppMediumFont(context,
                               msg: "₹ "
                                   "${viewmodel.productListDetails?.productDetails?.productPrice ?? ''}",
                               textDecoration:
                               TextDecoration.lineThrough,
                               fontSize: 16)
                               : SizedBox(),
                           SizedBox(width: 8.0), AppBoldFont(context,
                               msg: "₹ "
                                   "${viewmodel.productListDetails?.productDetails?.productDiscountPrice ?? ''}",
                               fontSize: 18),SizedBox(width: 8.0),
                           AppMediumFont(context,
                               msg: viewmodel
                                   .productListDetails
                                   ?.productDetails
                                   ?.productDiscountPercent !=
                                   ''
                                   ? "${viewmodel.productListDetails?.productDetails?.productDiscountPercent}" +
                                   '% OFF'
                                   : '',color: Colors.green,
                               fontSize: 14)
                         ]),
                     Container(
                       child: ProductSkuView(
                           selected: true,
                           skuDetails: cartView.productListDetails?.productSkuDetails,
                           cartView: cartView,
                           productList: cartView.productListDetails?.productDetails?.defaultVariationSku),
                     ),
                     bottomNavigationButton()
                   ]))
         ],
       )

          )
         : Center(child: ThreeArchedCircle(size: 45.0)));
        })
      );
  }

  getProductUpdateDetails(String? colorName, sizeName, ProductList product){
    // cartView.getProductDetails(
    //       context, widget.productId ?? prodId, product.productDetails?.variantId ?? '', colorName ?? '', sizeName ?? '');

  }

  // this method is called when navigate to this page using dynamic link
  receivedArgumentsNotification() {
    if (ModalRoute.of(context)?.settings.arguments != null && prodId == '') {
      final Map<String, dynamic> data =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      prodId = data['prodId'];
      variantId = data['variantId'];
      colorName = data['colorName'];
     // cartView.getProductDetails(context, prodId, variantId,colorName,"");
      cartView.updatecolorName(
          context,
          colorName);
    }
  }

  // give toast according to the empty field
  addToBagButtonPressed() {

          cartView.addToCart(
              cartView.productListDetails?.productId ?? '',
              "1",
              cartView.productListDetails?.productDetails?.variantId ?? '',
              false,
              context, (result, isSuccess) {});

  }

  //Bottom Navigation
  bottomNavigationButton() {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).cardColor),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal:ResponsiveWidget.isMediumScreen(context)
                          ?20: 40, vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ))),
              child: AppBoldFont(context,
                  msg: (cartView.isAddedToCart == true || cartView.productListDetails?.productDetails
                      ?.isAddToCart ==
                      true)
                      ? "Go to Cart"
                      : "Add to Bag",
                  fontSize: 16),
              onPressed: ()async{
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                token = sharedPreferences.getString('token').toString();
                if (token == 'null'){
                  showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder:
                          (BuildContext context) {
                        return  LoginUp(
                          product: true,
                        );
                      });
                  // _backBtnHandling(prodId);
                }
                else if(cartView.productListDetails?.productDetails?.isAvailable == true) {
                  (cartView.isAddedToCart == true || cartView.productListDetails?.productDetails?.isAddToCart == true)
                      ?
                  context.router.push(CartDetail(
                    itemCount: '${cartView.cartItemCount}'
                  ))

                      : addToBagButtonPressed();
                }
              }),
              SizedBox(width: 5),
              ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: ResponsiveWidget.isMediumScreen(context)
                      ?20: 40, vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),
                      ))),
              child: AppBoldFont(context,
                  msg: " BUYNOW", fontSize: 16,color: Colors.white),
              onPressed: ()async{
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                token = sharedPreferences.getString('token').toString();
                if (token == 'null'){
                  showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder:
                          (BuildContext context) {
                        return  LoginUp(
                          product: true,
                        );
                      });
                 // _backBtnHandling(prodId);
                }
                else if (cartView.productListDetails?.productDetails?.isAvailable == true) {
                  cartView.buyNow(
                      cartView.productListDetails?.productId ?? '',
                      "1", cartView.productListDetails?.productDetails?.variantId,
                      false, context);  //context.router.push(FavouriteListPage());

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
}
