import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/Products/ProductList.dart';
import 'package:TychoStream/view/Products/image_slider.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class FavouriteListPage extends StatefulWidget {
  Function? callback;

  FavouriteListPage({Key? key, this.callback}) : super(key: key);

  @override
  State<FavouriteListPage> createState() => _FavouriteListPageState();
}

class _FavouriteListPageState extends State<FavouriteListPage> {
  CartViewModel cartViewModel = CartViewModel();
  String? checkInternet;

  @override
  void initState() {
    cartViewModel.getCartCount(context);
    cartViewModel.getFavList(context);
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
                isFavourite: false,
                onFavPressed: () {},
                title: "Fav",
                onCartPressed: () {
                  GoRouter.of(context).pushNamed(RoutesName.CartDetails, queryParams: {
                    'itemCount':'${viewmodel.cartItemCount}',
                  });
                  // AppNavigator.push(
                  //     context, CartDetail(itemCount: viewmodel.cartItemCount),
                  //     screenName: RouteBuilder.cartDetail, function: (v) {
                  //   viewmodel.updateCartCount(context, v);
                  // });
                },
                onBackPressed: () {
                  Navigator.pop(context, true);
                  widget.callback!(viewmodel.favouriteCallback);
                }),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: viewmodel.productListModel?.productList != null
                ? viewmodel.productListModel!.productList!.length > 0
                    ? GridView.builder(
                        shrinkWrap: true,
              padding: EdgeInsets.only(left: 10),
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5, childAspectRatio: 0.58),
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
                                            'favouriteList');
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

  //ProductListItems
  Widget productListItems(
      ProductList? productListData, int index, CartViewModel viewmodel) {
    return  GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed(RoutesName.productDetails, queryParams: {
                'itemCount':'${viewmodel.cartItemCount}',
                'productId':'${productListData?.productId}',
                'variantId':'${productListData?.productDetails?.variantId}',
                'productColorId':'${productListData?.productDetails?.productColorId}',
                'productColor':'${productListData?.productDetails?.productColor}'
              });
                // AppNavigator.push(
                //     context,
                //     ProductDetailPage(
                //       items: productListData,
                //
                //       itemCount: viewmodel.cartItemCount,
                //       callback: (value) {
                //         if (value == true) {
                //           AppIndicator.loadingIndicator(context);
                //           cartViewModel.getFavList(context);
                //         }
                //       },
                //     ),
                //     screenName: RouteBuilder.productDetails, function: (v) {
                //   viewmodel.updateCartCount(context, v);
                // });
            },
            child: Card(
              elevation: 4.0,
              child: Container(
                height: SizeConfig.screenHeight/3.2,
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
            ));

  }

  receivedArgumentsNotification() {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final Map<String, dynamic> data =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      cartViewModel.getFavList(context);
    }
  }
}
