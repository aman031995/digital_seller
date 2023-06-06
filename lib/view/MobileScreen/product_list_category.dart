import 'package:TychoStream/model/data/BannerDataModel.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/Products/image_slider.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../AppRouter.gr.dart';
import '../../Utilities/AssetsConstants.dart';

class ProductListMobileGallery extends StatefulWidget {
  @override
  State<ProductListMobileGallery> createState() => _ProductListGalleryState();
}

class _ProductListGalleryState extends State<ProductListMobileGallery> {
  CartViewModel cartViewModel = CartViewModel();
  String? checkInternet;

  @override
  void initState() {
    cartViewModel.getProductListData(context);
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
                  // GoRouter.of(context).pushNamed(RoutesName.CartDetails, queryParameters: {
                  //   'itemCount':'${viewmodel.cartItemCount}',
                  // });
                  context.router.push(CartDetail(
                      itemCount: '${viewmodel.cartItemCount}'
                  ));
                },
                onFavPressed: (){
                  context.router.push(FavouriteListPage());
                  // GoRouter.of(context).pushNamed(RoutesName.fav);
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.58),
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
              },
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
  double productList(){
    int count=(cartViewModel.productListModel!.productList!.length/4).ceil();
    return 350.0 * count;
  }
  Widget productListItems(
      ProductList? productListData, int index, CartViewModel viewmodel) {
    return  Card(
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
                height: 210.0,
              ),

            ],
          ),
          productGalleryTitleSection(context, productListData,false),
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
