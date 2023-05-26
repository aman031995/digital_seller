import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/Products/image_slider.dart';
import 'package:TychoStream/view/Products/product_details.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../utilities/AssetsConstants.dart';

class ProductListGallery extends StatefulWidget {
  ProductListGallery({Key? key}) : super(key: key);

  @override
  State<ProductListGallery> createState() => _ProductListGalleryState();
}

class _ProductListGalleryState extends State<ProductListGallery> {
  CartViewModel cartViewModel = CartViewModel();
  String? checkInternet;

  @override
  void initState() {
    cartViewModel.getCartCount(context);
    cartViewModel.getProductList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });
    // handle push notification/notification scenerio to show data
    receivedArgumentsNotification();
    return ChangeNotifierProvider<CartViewModel>(
        create: (BuildContext context) => cartViewModel,
        child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
          return checkInternet == "Offline"
                ? NOInternetScreen()
                : Scaffold(
            appBar: getAppBarWithBackBtn(
                context: context,
                itemCount: viewmodel.cartItemCount,
                isShopping: true,
                isBackBtn: false,
                isFavourite: true,
                title: StringConstant.forumTitle,
                onCartPressed: () {
                  GoRouter.of(context).pushNamed(RoutesName.CartDetails, queryParams: {
                    'itemCount':'${viewmodel.cartItemCount}',
                  });
                },
                onFavPressed: (){
                  GoRouter.of(context).pushNamed(RoutesName.fav);
                },
                onBackPressed: () {
                  Navigator.pop(context, true);
                }),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: viewmodel.productListModel?.productList != null
                ? viewmodel.productListModel!.productList!.length > 0
                ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                      child: Container(
                        height:SizeConfig.screenHeight/1.2 ,
                        width: SizeConfig.screenWidth/2,
                        child: GridView.builder(
              shrinkWrap: false,
              physics: ScrollPhysics(),
              padding: EdgeInsets.only(top: 30),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 310,mainAxisExtent: 320,mainAxisSpacing: 10.0,crossAxisSpacing: 10),
              itemCount:
              viewmodel.productListModel?.productList?.length,
              itemBuilder: (context, index) {
                        final productListData = cartViewModel
                            .productListModel?.productList?[index];
                        return productListItems(
                            productListData, index, viewmodel);
              },
            ),
                      )),
                      footerDesktop()
                    ],
                  ),
                )
                : Center(
                child: noDataFoundMessage(
                    context, StringConstant.noItemInCart))
                : Center(
              child: ThreeArchedCircle(size: 45.0),
            ),
          );
        }));
  }
  int trayHeight(CartViewModel ViewModel) {
    int count = 0;
    ViewModel.productListModel?.productList?.forEach((element) {
      if (element != null) {
          count += 1;
        }
    });
    return count;
  }
//Positioned(
//                         // right: 10,
//                         top: 5,
//                         child: GestureDetector(
//                             onTap: () {
//                               viewmodel.addToFavourite(
//                                   context,
//                                   "${productListData?.productId}",
//                                   "${productListData?.productDetails?.productColorId}",
//                                   productListData?.productDetails
//                                       ?.isFavorite ==
//                                       true
//                                       ? false
//                                       : true,
//                                   'productList');
//                             },
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Theme.of(context)
//                                         .canvasColor),
//                                 height: 35,
//                                 width: 35,
//                                 child: Icon(Icons.favorite,
//                                     color: productListData
//                                         ?.productDetails
//                                         ?.isFavorite ==
//                                         true
//                                         ? Colors.red
//                                         : GREY_COLOR,
//                                     size: 25))))
  Widget productListItems(
      ProductList? productListData, int index, CartViewModel viewmodel) {
    return  Stack(
      children: [
        GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed(RoutesName.productDetails, queryParams: {
                'itemCount':'${viewmodel.cartItemCount}',
                'productId':'${productListData?.productId}',
                    'variantId':'${productListData?.productDetails?.variantId}',
                'productColor':'${productListData?.productDetails?.productColor}'
              });
            },
            child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Theme.of(context).cardColor.withOpacity(0.7),
            ),

            // margin: EdgeInsets.only(left: 20,right: 20,top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: ImageSlider(
                        images: productListData?.productDetails?.productImages,
                        activeIndex: index),
                    height: 200.0,
                  ),
                  productGalleryTitleSection(context, productListData,false)
                ],
              ),
            )),
        Positioned(
                         right: 10,
                        top: 5,
                        child: GestureDetector(
                            onTap: () {
                              viewmodel.addToFavourite(
                                  context,
                                  "${productListData?.productId}",
                                  "${productListData?.productDetails?.productColor}",
                                  productListData?.productDetails
                                      ?.isFavorite ==
                                      true
                                      ? false
                                      : true,
                                  'productList');
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .canvasColor),
                                height: 35,
                                width: 35,
                                child: Icon(Icons.favorite,
                                    color: productListData
                                        ?.productDetails
                                        ?.isFavorite ==
                                        true
                                        ? Colors.red
                                        : GREY_COLOR,
                                    size: 25))))
      ],
    );
  }

  // this method is called when navigate to this page using dynamic link
  receivedArgumentsNotification() {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final Map<String, dynamic> data =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      cartViewModel.getProductList(context);
    }
  }
}

Widget productGalleryTitleSection(
    BuildContext context, ProductList? productListData,bool favbourite) {
  return Container(
    width: 200,
    padding: const EdgeInsets.only(
      left: 8.0,
      top: 10.0,
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
          msg:favbourite==true?productListData?.productDetails?.productVariantTitle : productListData?.productName ?? '',
          fontSize: 18.0,
        ),
        SizedBox(height: 2),
        AppBoldFont(
          context,
          msg: "₹ "
              '${productListData?.productDetails?.productDiscountPrice}',
          fontSize: 16.0,
        ),SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppMediumFont(context,
                msg: "₹ " '${productListData?.productDetails?.productPrice}',
                fontSize: 16.0,
                textDecoration: TextDecoration.lineThrough
            ),
            SizedBox(width: 8.0),
            AppMediumFont(
              context,
              msg:
              '${productListData?.productDetails?.productDiscountPercent}' +
                  '% OFF',
              fontSize: 14.0,
            ),
          ],
        ),SizedBox(height: 2),
        AppRegularFont(
          context,
          msg: "Color :"
              ' ${productListData?.productDetails?.productColor}',
          fontSize: 14.0,
        ),
        SizedBox(height: 5)
      ],
    ),
  );
}
