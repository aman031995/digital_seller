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
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
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
          return Scaffold(
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
                ? GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
                padding: EdgeInsets.only(left: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, childAspectRatio: 0.38),
              itemCount:
              viewmodel.productListModel?.productList?.length,
              itemBuilder: (context, index) {
                final productListData = cartViewModel
                    .productListModel?.productList?[index];
                return Stack(
                  children: [
                    productListItems(
                        productListData, index, viewmodel),
                    Positioned(
                        right: 10,
                        top: 25,
                        child: GestureDetector(
                            onTap: () {
                              viewmodel.addToFavourite(
                                  context,
                                  "${productListData?.productId}",
                                  "${productListData?.productDetails?.productColorId}",
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
              },
            )
                : Center(
                )
                : Center(
              child: ThreeArchedCircle(size: 45.0),
            ),
          );
        }));
  }

  Widget productListItems(
      ProductList? productListData, int index, CartViewModel viewmodel) {
    return productListData?.productDetails?.isAvailable == true
        ? GestureDetector(
        onTap: () {
          GoRouter.of(context).pushNamed(RoutesName.productDetails, queryParams: {
            'itemCount':'${viewmodel.cartItemCount}',
            'productId':'${productListData?.productId}',
                'variantId':'${productListData?.productDetails?.variantId}',
            'productColorId':'${productListData?.productDetails?.productColorId}',
            'productColor':'${productListData?.productDetails?.productColor}'
          });
          //'itemCount'
          //    //itemCount:state.queryParams['itemCount'],
          //     //               productId: state.queryParams['productId'],
          //     //               variantId: state.queryParams['variantId'],
          //     //               productColor: state.queryParams['productColor'],
          //     //               productColorId: state.queryParams['productColorId'],
// Navigator.push(context,   ProductDetailPage(
//   items: productListData,
//   index: index,
//   itemCount: viewmodel.cartItemCount,
//   callback: (value) {
//     if (value == true) {
//       AppIndicator.loadingIndicator(context);
//       cartViewModel.getProductList(context);
//     }
//   },
// ))
        },
        child: Container(
          height: SizeConfig.screenHeight/3.2,
          child: Card(
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: SizeConfig.screenWidth,
                  color: Colors.white,
                  child: ImageSlider(
                      images: productListData?.productDetails?.productImages,
                      activeIndex: index),
                  height: 200.0,
                ),
                productGalleryTitleSection(context, productListData)
              ],
            ),
          ),
        ))
        : Card(
      elevation: 4.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                child: Image.network(
                    "${productListData?.productDetails?.productImages?[0]}"),
                height: 200.0,
              ),
              Positioned(
                  left: 1,
                  right: 1,
                  top: 80,
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.white.withOpacity(0.6),
                    child: Image.asset(
                     ""
                    )
                  ))
            ],
          ),
          productGalleryTitleSection(context, productListData),
        ],
      ),
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
    BuildContext context, ProductList? productListData) {
  return Expanded(
    child: Padding(
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
            maxLines: 2,
            msg: productListData?.productDetails?.productVariantTitle ?? '',
            fontSize: 18.0,
          ),
          AppBoldFont(
            context,
            msg: "₹ "
                '${productListData?.productDetails?.productDiscountPrice}',
            fontSize: 14.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppMediumFont(context,
                  msg: "₹ " '${productListData?.productDetails?.productPrice}',
                  fontSize: 16.0,
                 // textDecoration: TextDecoration.lineThrough
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
          ),
          AppRegularFont(
            context,
            msg: "Color :"
                ' ${productListData?.productDetails?.productColor}',
            fontSize: 14.0,
          ),
          SizedBox(height: 5)
        ],
      ),
    ),
  );
}
