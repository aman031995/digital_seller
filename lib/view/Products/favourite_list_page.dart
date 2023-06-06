import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/Products/ProductList.dart';
import 'package:TychoStream/view/Products/image_slider.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../AppRouter.gr.dart';

@RoutePage()
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
    // receivedArgumentsNotification();
    return checkInternet == "Offline"
        ? NOInternetScreen()
        : Scaffold(
      appBar: getAppBarWithBackBtn(
          context: context,
          itemCount: cartViewModel.cartItemCount,
          isShopping: true,
          isBackBtn: false,
          isFavourite: false,
          onFavPressed: () {},
          title: "Fav",
          onCartPressed: () {
            // GoRouter.of(context).pushNamed(RoutesName.CartDetails, queryParameters: {
            //   'itemCount':'${viewmodel.cartItemCount}',
            // });
            context.router.push(CartDetail(
                itemCount: '${cartViewModel.cartItemCount}'
            ));
            // AppNavigator.push(
            //     context, CartDetail(itemCount: viewmodel.cartItemCount),
            //     screenName: RouteBuilder.cartDetail, function: (v) {
            //   viewmodel.updateCartCount(context, v);
            // });
          },
          onBackPressed: () {
            // Navigator.pop(context, true);
            // widget.callback!(viewmodel.favouriteCallback);
          }),
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: cartViewModel.productListModel?.productList != null
          ? cartViewModel.productListModel!.productList!.length > 0
          ?ResponsiveWidget.isMediumScreen(context)
          ?
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: productListMobile(),
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.62,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount:
                cartViewModel.productListModel?.productList?.length,
                itemBuilder: (context, index) {
                  final productListData = cartViewModel
                      .productListModel?.productList?[index];
                  return productListItems(context,
                      productListData, index, cartViewModel);
                },
              ),
            ),
            SizedBox(height: 50),
            footerMobile(context)
          ],
        ),
      ): SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                height: productList(),
                width: SizeConfig.screenWidth / 2,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      mainAxisExtent: 300,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10),
                  itemCount:
                  cartViewModel.productListModel?.productList?.length,
                  itemBuilder: (context, index) {
                    final productListData = cartViewModel
                        .productListModel?.productList?[index];
                    return productListItems(context,
                        productListData, index, cartViewModel);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
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
  }
  double productList(){
    int count=(cartViewModel.productListModel!.productList!.length/4).ceil();
    return 350.0 * count;
  }
  double productListMobile(){
    int count=(cartViewModel.productListModel!.productList!.length/2).ceil();
    return 320.0 * count;
  }
  //ProductListItems
  Widget productListItems(BuildContext context,ProductList? productListData, int index,
      CartViewModel viewmodel) {
    return Stack(
      children: [
        GestureDetector(
            onTap: () {
              context.router.push(
                ProductDetailPage(
                  productId: '${productListData?.productId}',
                  productdata: ['${viewmodel.cartItemCount}','${productListData?.productDetails?.variantId}','${productListData?.productDetails?.productColor}'],
                ) ,
              );
              // GoRouter.of(context).pushNamed(
              //     RoutesName.productDetails, queryParameters: {
              //   'itemCount': '${viewmodel.cartItemCount}',
              //   'productId': '${productListData?.productId}',
              //   'variantId': '${productListData?.productDetails?.variantId}',
              //   'productColor': '${productListData?.productDetails
              //       ?.productColor}'
              // });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Theme
                  .of(context)
                  .cardColor
                  .withOpacity(0.7),
              ),
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
                  productGalleryTitleSection(context, productListData, true)
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
                      'favouriteList');
                },
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme
                            .of(context)
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
}
  // receivedArgumentsNotification() {
  //   if (ModalRoute.of(context)?.settings.arguments != null) {
  //     final Map<String, dynamic> data =
  //         ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  //     cartViewModel.getFavList(context);
  //   }
  // }
