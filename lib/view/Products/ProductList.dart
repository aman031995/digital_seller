import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
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
import '../../utilities/AssetsConstants.dart';

@RoutePage()
class ProductListGallery extends StatefulWidget {
  @override
  State<ProductListGallery> createState() => _ProductListGalleryState();
}
class _ProductListGalleryState extends State<ProductListGallery> {
  CartViewModel cartViewModel = CartViewModel();
  ScrollController _scrollController = ScrollController();
  String? checkInternet;
  int pageNum = 1;


  void initState() {
    cartViewModel.getProductListData(context,pageNum);
    cartViewModel.getCartCount(context);
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
    return checkInternet == "Offline"
        ? NOInternetScreen()
        :ChangeNotifierProvider<CartViewModel>(
        create: (BuildContext context) => cartViewModel,
        child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
          return  Scaffold(
            appBar: getAppBarWithBackBtn(
                context: context,
                itemCount: viewmodel.cartItemCount,
                isShopping: true,
                isBackBtn: false,
                isFavourite: true,
                title: StringConstant.forumTitle,
                onCartPressed: () {
                  context.router.push(CartDetail(
                      itemCount: '${viewmodel.cartItemCount}'
                  ));
                },
                onFavPressed: (){
                  context.router.push(FavouriteListPage());
                },
                onBackPressed: () {
                }),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: viewmodel.productListModel?.productList != null
                ? viewmodel.productListModel!.productList!.length > 0
                ? ResponsiveWidget.isMediumScreen(context)
                ?
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height:SizeConfig.screenHeight,
                    child: Stack(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.56,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
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
                            margin: EdgeInsets.only(top: SizeConfig.screenHeight/1.2),
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
                      Container(
                        height:SizeConfig.screenHeight/1.1,
                        width: SizeConfig.screenWidth/2,
                        child: Stack(
                          children: [
                            Center(
                            child: GridView.builder(
                                    shrinkWrap: true,
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(),

              padding: EdgeInsets.only(top: 30),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 280,mainAxisExtent: 320,mainAxisSpacing: 10.0,crossAxisSpacing: 10),
              itemCount: viewmodel.productListModel?.productList?.length,
              itemBuilder: (context, index) {
                _scrollController.addListener(() {
                  if (_scrollController.position.pixels ==
                            _scrollController.position.maxScrollExtent) {
                    viewmodel.onPagination(context, viewmodel.lastPage, viewmodel.nextPage, viewmodel.isLoading, 'productList');
                  }
                });
                            final productListData = cartViewModel
                                .productListModel?.productList?[index];
                            return productListItems(context,
                                productListData, index, viewmodel);
              },
            )),
                            viewmodel.isLoading == true
                                ? Container(
                                margin: EdgeInsets.only(top: SizeConfig.screenHeight/1.15),
                                alignment: Alignment.bottomCenter,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ))
                                : SizedBox()
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
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

  Widget productListItems(BuildContext context,
      ProductList? productListData, int index, CartViewModel viewmodel) {
    return  Stack(
      children: [
        GestureDetector(
            onTap: () {
              context.router.push(
                ProductDetailPage(
                   productId: '${productListData?.productId}',
                  productdata: ['${viewmodel.cartItemCount}','${productListData?.productDetails?.variantId}','${productListData?.productDetails?.productColor}'],
                ) ,
              );
            },
            child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Theme.of(context).cardColor.withOpacity(0.7),
            ),
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
      cartViewModel.getProductList(context,pageNum);
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
