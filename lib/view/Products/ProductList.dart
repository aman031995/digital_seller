import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/Products/image_slider.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppRouter.gr.dart';


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
        :ChangeNotifierProvider.value(
        value: cartViewModel,
        child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
          return  Scaffold(
            appBar: getAppBarWithBackBtn(
                context: context,
                itemCount: viewmodel.cartItemCount,
                isShopping: true,
                isBackBtn: false,
                isFavourite: true,
                title: StringConstant.forumTitle,
                onCartPressed: () async{
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
                  }
                  else{
                    context.router.push(CartDetail(
                        itemCount: '${viewmodel.cartItemCount}'
                    ));
                  }


                },
                onFavPressed: ()async{
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
                  }
                  else{
                  context.router.push(FavouriteListPage(
                  ));
                }},
                onBackPressed: () {
                }),


            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

            body: viewmodel.productListModel?.productList != null
                ? viewmodel.productListModel!.productList!.length > 0
                ? ResponsiveWidget.isMediumScreen(context)
                ? SingleChildScrollView(
                          child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight,
                        child: GridView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          padding: EdgeInsets.all(8),
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.64,
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
                      ),
                      viewmodel.isLoading == true
                          ? Container(
                          margin: EdgeInsets.only(top: SizeConfig.screenHeight/1.5),
                          alignment: Alignment.bottomCenter,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ))
                          : SizedBox()
                    ],
                  ),
                  SizedBox(height: 50),
                footerMobile(context)
                ],
              ))
                :
            SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height:SizeConfig.screenHeight/1.1,
                        width: SizeConfig.screenWidth/2,
                        child: Stack(
                          children: [
                            GridView.builder(
                                    shrinkWrap: true,
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: 30),
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300,mainAxisExtent: 350,mainAxisSpacing: 10.0,crossAxisSpacing: 10),
                              itemCount: viewmodel.productListModel?.productList?.length,
                                        itemBuilder: (context, index) {
                                    _scrollController.addListener(() {
                  if (_scrollController.position.pixels ==
                            _scrollController.position.maxScrollExtent) {
                    viewmodel.onPagination(context, viewmodel.lastPage, viewmodel.nextPage, viewmodel.isLoading, 'productList');
                  }
                });
                            final productListData = cartViewModel.productListModel?.productList?[index];
                            return productListItems(context,
                                productListData, index, viewmodel);
              },
            ),
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
                  productdata: [
                    '${viewmodel.cartItemCount}',
                    '${productListData?.productDetails?.defaultVariationSku?.size?.name}',
                    '${productListData?.productDetails?.defaultVariationSku?.color?.name}',
                    '${productListData?.productDetails?.defaultVariationSku?.style?.name}',
                    '${productListData?.productDetails?.defaultVariationSku?.unitCount?.name}',
                    '${productListData?.productDetails?.defaultVariationSku?.materialType?.name}',
                  ],
                ) ,
              );
            },
            child: Container(

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.8),
            ),
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
                      child: productGalleryTitleSection(context, productListData,false))
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
                              //     'productList');
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
                                        : Colors.white,
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

String? getFavTitle(ProductList? productListData) {
  if (productListData!.productDetails!.productVariantTitle!.length > 40) {
    return productListData.productDetails?.productVariantTitle?.replaceRange(
        40, productListData.productDetails?.productVariantTitle?.length, '...');
  } else {
    return productListData.productDetails?.productVariantTitle ?? "";
  }
}

String? getNameTitle(ProductList? productListData) {
  if (productListData!.productName!.length > 40) {
    return productListData.productName
        ?.replaceRange(40, productListData.productName?.length, '...');
  } else {
    return productListData.productName;
  }}
Widget productGalleryTitleSection(
    BuildContext context, ProductList? productListData,bool favbourite) {
  return Container(
    padding: const EdgeInsets.only(
      left: 8.0,
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
          msg:favbourite==true? getFavTitle(productListData) ?? ''
          : getNameTitle(productListData) ?? '',
          fontSize: 14.0,
        ),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppMediumFont(context,
                msg: "₹" '${productListData?.productDetails?.productPrice}',
                fontSize: ResponsiveWidget.isMediumScreen(context)
                    ?14:16.0,color:Theme.of(context).canvasColor.withOpacity(0.6),
                textDecoration: TextDecoration.lineThrough
            ),
            SizedBox(width: 2.0),
            AppMediumFont(
              context,color:Theme.of(context).canvasColor.withOpacity(0.9),
              msg: "₹"
                  '${productListData?.productDetails?.productDiscountPrice}',
              fontSize:ResponsiveWidget.isMediumScreen(context)
                  ?14:16.0,
            ),
            SizedBox(width: 2.0),
            AppMediumFont(
              context,fontSize:ResponsiveWidget.isMediumScreen(context)
                ?14:16.0,
              msg:
              '${productListData?.productDetails?.productDiscountPercent}'+
                  '%OFF',color: GREEN
            ),
          ],
        ),
        SizedBox(height: 3)
      ],
    ),
  );
}
