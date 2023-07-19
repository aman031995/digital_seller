import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
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
  ScrollController _scrollController = ScrollController();
  String? checkInternet;
  int pageNum = 1;bool isfab = false;
  @override
  void initState() {
    cartViewModel.getCartCount(context);
    cartViewModel.getFavList(context, pageNum);
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
    // receivedArgumentsNotification();
    return
      checkInternet == "Offline"
          ? NOInternetScreen()
          : ChangeNotifierProvider.value(
          value: cartViewModel,
          child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
            return
       Scaffold(
      appBar: getAppBarWithBackBtn(
          context: context,
          itemCount: viewmodel.cartItemCount,
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
                itemCount: '${viewmodel.cartItemCount}'
            ));
            // AppNavigator.push(
            //     context, CartDetail(itemCount: viewmodel.cartItemCount),
            //     screenName: RouteBuilder.cartDetail, function: (v) {
            //   viewmodel.updateCartCount(context, v);
            // });
          },
          onBackPressed: () {
            // Navigator.pop(context, viewmodel.cartItemCount);
            // widget.callback!(viewmodel.productListDetails?.productDetails?.variantId,isfab);
            // // Navigator.pop(context, true);
            // widget.callback!(viewmodel.favouriteCallback);
          }),
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: viewmodel.productListModel?.productList != null
          ? viewmodel.productListModel!.productList!.length > 0
          ?ResponsiveWidget.isMediumScreen(context)
          ?
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: SizeConfig.screenHeight/1.1,
              child: Stack(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                  padding: EdgeInsets.all(8),
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.65,
                       ),
                    itemCount:
                    viewmodel.productListModel?.productList?.length,
                    itemBuilder: (context, index) {
                      _scrollController.addListener(() {
                        if (_scrollController.position.pixels ==
                            _scrollController.position.maxScrollExtent) {
                          viewmodel.onPagination(context, viewmodel.lastPage, viewmodel.nextPage, viewmodel.isLoading, 'productList');
                        }
                      });
                      final productListData = viewmodel
                          .productListModel?.productList?[index];
                      return productListItems(context,
                          productListData, index, viewmodel);
                    },
                  ),
                  viewmodel.isLoading == true
                      ? Container(
                      margin: EdgeInsets.only(top: SizeConfig.screenHeight/1.3),
                      alignment: Alignment.bottomCenter,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ))
                      : SizedBox()
                ],
              ),
            ),
            SizedBox(height: 50),
            footerMobile(context)
          ],
        ),
      ):
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              height: SizeConfig.screenHeight/1.1,
              width: SizeConfig.screenWidth / 2,
              child: Stack(
                children: [
                  Center(
                    child: GridView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,mainAxisExtent: 350,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10),
                      itemCount:
                      viewmodel.productListModel?.productList?.length,
                      itemBuilder: (context, index) {
                        _scrollController.addListener(() {
                          if (_scrollController.position.pixels ==
                              _scrollController.position.maxScrollExtent) {
                            viewmodel.onPagination(context, viewmodel.lastPage, viewmodel.nextPage, viewmodel.isLoading, 'favouriteList');
                          }
                        });
                        final productListData = viewmodel
                            .productListModel?.productList?[index];
                        return productListItems(context,
                            productListData, index, viewmodel);
                      },
                    ),
                  ),
                  viewmodel.isLoading == true
                      ? Container(
                      margin: EdgeInsets.only(top: SizeConfig.screenHeight/1.3),
                      alignment: Alignment.bottomCenter,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ))
                      : SizedBox()
                ],
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
    );}));
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
                  productdata: [
                    '${viewmodel.cartItemCount}',
                    '${productListData?.productDetails?.defaultVariationSku?.size?.name}',
                    '${productListData?.productDetails?.defaultVariationSku?.color?.name}',
                    '${productListData?.productDetails?.defaultVariationSku?.style?.name}',
                    '${productListData?.productDetails?.defaultVariationSku?.unitCount?.name}',
                    '${productListData?.productDetails?.defaultVariationSku?.materialType?.name}',
                    //'${productListData?.productDetails?.defaultVariationSku?.materialType?.name}'
                  ],
                ) ,
              );

            },
            child: Container(
              color: Theme.of(context).cardColor.withOpacity(0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 90,
                    child: ImageSlider(
                        images: productListData?.productDetails?.productImages,
                    ),
                  ),
                  Expanded(
                      flex: 26,
                      child: productGalleryTitleSection(context, productListData, true))
                ],
              ),
            )),
        Positioned(
            right: 10,
            top: 5,
            child: GestureDetector(
                onTap: () {
                  final isFav =
                  productListData!
                      .productDetails!
                      .isFavorite =
                  !productListData
                      .productDetails!
                      .isFavorite!;
                  isfab = isFav;
                  viewmodel.addToFavourite(
                      context,
                      "${productListData.productId}",
                      "${productListData.productDetails?.variantId}",
                      isFav,
                      'productList');
                  // viewmodel.addToFavourite(
                  //     context,
                  //     "${productListData?.productId}",
                  //     "${productListData?.productDetails?.productColor}",
                  //     productListData?.productDetails
                  //         ?.isFavorite ==
                  //         true
                  //         ? false
                  //         : true,
                  //     'favouriteList');
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
                            : Colors.white,
                        size: 25))))
      ],
    );
  }
}
