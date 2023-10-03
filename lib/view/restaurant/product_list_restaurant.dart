import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/services/session_storage.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/effect/OnHover.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
import 'package:TychoStream/view/restaurant/food_deatil.dart';
import 'package:TychoStream/view/restaurant/restaurant_image_slider.dart';
import 'package:TychoStream/view/widgets/NotificationScreen.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/footerDesktop.dart';
import 'package:TychoStream/view/widgets/getAppBar.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/notification_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../AppRouter.gr.dart';

@RoutePage()
class ProductListRestaurantGallery extends StatefulWidget {
  final List<String>? discountdata;
  ProductListRestaurantGallery({
    @QueryParam() this.discountdata,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductListRestaurantGallery> createState() => _ProductListRestaurantGalleryState();
}

class _ProductListRestaurantGalleryState extends State<ProductListRestaurantGallery> {
  CartViewModel cartViewModel = CartViewModel();
  String? checkInternet;
  int pageNum = 1;
  HomeViewModel homeViewModel = HomeViewModel();
  ProfileViewModel profileViewModel = ProfileViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  TextEditingController? searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  NotificationViewModel notificationViewModel = NotificationViewModel();
  ScrollController _scrollController = ScrollController();
  ScrollController scrollController1 = ScrollController();

  void initState() {
    homeViewModel.getAppConfig(context);
    getProduct();
    notificationViewModel.getNotificationCountText(context);
    cartViewModel.getCartCount(context);
    super.initState();
  }

  getProduct() {
    widget.discountdata?.length == null
          ? cartViewModel.getProductList(context,  SessionStorageHelper.getValue("pageList").toString()=="null"?1:int.parse(SessionStorageHelper.getValue("pageList").toString()),(result, isSuccess){})
          : cartViewModel.getOfferDiscountList(
              context,
              widget.discountdata?[1] ?? "",
              pageNum,
              widget.discountdata?[0] ?? "",(result, isSuccess){});
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
        : ChangeNotifierProvider.value(
            value: cartViewModel,
            child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
              return ChangeNotifierProvider.value(
                  value: notificationViewModel,
                  child: Consumer<NotificationViewModel>(
                      builder: (context, model, _) {
                        return viewmodel.productListModel?.productList != null
                              ?   GestureDetector(
                                onTap: () {
                                  closeAppbarProperty();

                                },
                           child: Scaffold(
                          appBar: ResponsiveWidget.isMediumScreen(context)
                        ? homePageTopBar(
                            context,
                            _scaffoldKey,
                            cartViewModel.cartItemCount,
                            homeViewModel,
                            profileViewModel, model )
                        : getAppBar(
                            context,model,
                            homeViewModel,
                            profileViewModel,
                            cartViewModel.cartItemCount,
                            1,
                            searchController, () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            if (sharedPreferences.getString('token') == null) {
                              showDialog(
                                  context: context,
                                  barrierColor: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(0.6),
                                  builder: (BuildContext context) {
                                    return LoginUp(
                                      product: true,
                                    );
                                  });
                            } else {
                              closeAppbarProperty();

                              context.router.push(RestaurantFavouriteListPage());
                            }
                          }, () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            if (sharedPreferences.getString('token') == null) {
                              showDialog(
                                  context: context,
                                  barrierColor: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(0.6),
                                  builder: (BuildContext context) {
                                    return LoginUp(
                                      product: true,
                                    );
                                  });
                            } else {
                              closeAppbarProperty();

                              context.router.push(CartDetail(
                                  itemCount: '${cartViewModel.cartItemCount}'));
                            }
                          }),
                    body: Scaffold(
                      extendBodyBehindAppBar: true,
                      key: _scaffoldKey,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      drawer: ResponsiveWidget.isMediumScreen(context)
                          ? AppMenu()
                          : SizedBox(),
                      body:  Stack(
                                  children: [
                                    viewmodel.productListModel?.productList != null
                                        ? (viewmodel.productListModel?.productList?.length ?? 0) > 0
                                        ?  SingleChildScrollView(
                                      controller: scrollController1,
                                        child: Column(
                                      children: [
                                        ResponsiveWidget.isMediumScreen(context)
                                            ? Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 12,
                                                        left: 12,
                                                        top: 12),
                                                    width:
                                                        SizeConfig.screenWidth,
                                                    child: GridView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount:ResponsiveWidget.isSmallScreen(context) ? 2:3,
                                                        childAspectRatio: ResponsiveWidget.isSmallScreen(context) ? 0.85:0.80,mainAxisSpacing: 5,crossAxisSpacing: 5
                                                      ),
                                                      itemCount: viewmodel
                                                          .productListModel
                                                          ?.productList
                                                          ?.length,
                                                      itemBuilder:
                                                          (context, index) {

                                                        final productListData =
                                                            viewmodel
                                                                .productListModel
                                                                ?.productList?[index];
                                                        return productListRestaurantItems(
                                                            context,
                                                            productListData,
                                                            index,
                                                            viewmodel);
                                                      },
                                                    ),
                                                  ),
                                                  onPagination(viewmodel)
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // CategoryFilterScreen(items: []),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      // Container(
                                                      //     alignment: Alignment.topLeft,
                                                      //     padding: EdgeInsets.only(top: 30, right: 20),
                                                      //     width: SizeConfig.screenWidth /1.75,
                                                      //     child: catrgoryTopSortWidget(context)),
                                                      Container(
                                                          width: SizeConfig.screenWidth/1.38,
                                                          child: GridView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            padding: EdgeInsets.only(top: 10),
                                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                                mainAxisSpacing:
                                                                10,crossAxisSpacing: 10,
                                                                mainAxisExtent:
                                                                    300,
                                                                maxCrossAxisExtent:
                                                                    400),
                                                            itemCount: viewmodel
                                                                .productListModel
                                                                ?.productList
                                                                ?.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {

                                                              final productListData =
                                                                  viewmodel
                                                                      .productListModel
                                                                      ?.productList?[index];
                                                              return productListRestaurantItems(
                                                                  context,
                                                                  productListData,
                                                                  index,
                                                                  viewmodel);
                                                            },
                                                          )),
                                                      onPagination(viewmodel)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                        ResponsiveWidget.isMediumScreen(context)
                                            ?   SizedBox(height:ResponsiveWidget.isSmallScreen(context)
                                            ? 50:100)
                                            : SizedBox(height: 120),
                                        ResponsiveWidget.isMediumScreen(context)
                                            ? footerMobile(context,homeViewModel)
                                            : footerDesktop()
                                      ],
                                    )):
                                    noDataFoundMessage(context,StringConstant.noProductAdded,homeViewModel) :
                                    Center(child: ThreeArchedCircle(size: 45.0)),
                                    ResponsiveWidget.isMediumScreen(context)
                                        ? Container()
                                        : GlobalVariable.isnotification == true
                                        ?    Positioned(
                                        top:  0,
                                        right:  SizeConfig
                                            .screenWidth *
                                            0.20,
                                        child: notification(notificationViewModel,context,_scrollController)):Container(),
                                    ResponsiveWidget.isMediumScreen(context)
                                        ? Container()
                                        : GlobalVariable.isLogins == true
                                            ? Positioned(
                                                top: 0,
                                                right: 180,
                                                child: profile(context,
                                                    setState, profileViewModel))
                                            : Container(),
                                    ResponsiveWidget.isMediumScreen(context)
                                        ? Container()
                                        : GlobalVariable.isSearch == true
                                            ? Positioned(
                                                top: 1,
                                                right: ResponsiveWidget
                                                        .isMediumScreen(context)
                                                    ? 0
                                                    : SizeConfig.screenWidth * 0.20,
                                                child: searchList(
                                                    context,
                                                    homeViewModel,
                                                    scrollController,
                                                    searchController!,
                                                    cartViewModel
                                                        .cartItemCount))
                                            : Container()
                                  ],
                                )
                    ))
                        )
                            : Container(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenHeight,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Center(
                              child: ThreeArchedCircle(size: 45.0),
                            ),
                          );
                      }));
            }));
  }

 onPagination(CartViewModel viewmodel){
    return viewmodel.productListModel!.pagination!.lastPage==1?Container():   Container(
      height: 40,
      margin: EdgeInsets.only(
          right: 12,
          left: 12,
          top: 20),
      width:  ResponsiveWidget.isMediumScreen(context) ?viewmodel.productListModel!.pagination!.lastPage! < 4?SizeConfig.screenWidth/1.6  :ResponsiveWidget.isSmallScreen(context) ?SizeConfig.screenWidth:SizeConfig.screenWidth/1.4:

      viewmodel.productListModel!.pagination!.lastPage! < 4?SizeConfig.screenWidth/5:SizeConfig.screenWidth/4,
      child: NumberPaginator(
        numberPages: viewmodel.productListModel!.pagination!.lastPage!,
        config:
        NumberPaginatorUIConfig(
          mode: ContentDisplayMode.numbers,
          height: 40,
          contentPadding:
          EdgeInsets.zero,
          buttonShape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius
                .circular(4),
          ),
          buttonSelectedForegroundColor:
          Theme.of(context)
              .canvasColor,
          buttonUnselectedForegroundColor:
          Theme.of(context)
              .canvasColor
              .withOpacity(
              0.8),
          buttonUnselectedBackgroundColor:
          Theme.of(context)
              .cardColor
              .withOpacity(
              0.8),
          buttonSelectedBackgroundColor:
          Theme.of(context)
              .primaryColor
              .withOpacity(
              0.8),
        ),
        initialPage: viewmodel.productListModel!.pagination!.current!-1,
        onPageChange:
            (int index) {
          setState(() {
            AppIndicator.loadingIndicator(context);
            widget.discountdata?.length == null
                  ? cartViewModel.getProductList(context, index + 1,(result, isSuccess){
                    if(isSuccess){scrollController1.jumpTo(0);}})

                  : cartViewModel.getOfferDiscountList(
                  context,
                  widget.discountdata?[1] ?? "",
                  index +
                      1,
                  widget.discountdata?[0] ?? "",(result, isSuccess){
                    if(isSuccess){
                      scrollController1.jumpTo(0);
                    }
              });
          });
        },
      ),
    );
 }
}
//ProductListItems ......
Widget productListRestaurantItems(BuildContext context, ProductList? productListData,
    int index, CartViewModel viewmodel,
    {bool? favouritepage}) {
  return OnHover(
    builder: (isHovered) {
      return InkWell(
          onTap: () {
            closeAppbarProperty();
            if (productListData?.productDetails?.isAvailable == true) {
              // SessionStorageHelper.removeValue("itemCount");
              // context.router.push(BuynowCart(
              //     buynow: ['${cartViewModel.recommendedView?[position].productId}','${cartViewModel.recommendedView?[position].productDetails?.variantId}']
              // ));

              showDialog(
                  context: context,
                  barrierColor: Theme.of(context)
                      .canvasColor
                      .withOpacity(0.6),
                  builder: (BuildContext context) {
                    return foodDetail(
                        items:productListData ,
                        callback: (v){
                          if(v==true){
                            viewmodel.getCartCount(context);
                          }
                        } );
                  });
            }
            // context.router.push(
            //   ProductDetailPage(
            //     productName:
            //     '${productListData?.productName?.replaceAll(' ', '')}',
            //     productdata: [
            //       '${productListData?.productId}',
            //       '${viewmodel.cartItemCount}',
            //       '${productListData?.productDetails?.defaultVariationSku?.size?.name}',
            //       '${productListData?.productDetails?.defaultVariationSku?.color?.name}',
            //       '${productListData?.productDetails?.defaultVariationSku?.style?.name}',
            //       '${productListData?.productDetails?.defaultVariationSku?.unitCount?.name}',
            //       '${productListData?.productDetails?.defaultVariationSku?.materialType?.name}',
            //     ],
            //   ),
            // );
          },
          child: Container(
            decoration: isHovered == true
                ? BoxDecoration(
              color: Theme.of(context).cardColor,              borderRadius: BorderRadius.circular(10),

                boxShadow: [
                BoxShadow(
                  color: Theme.of(context).canvasColor.withOpacity(0.15),
                  blurRadius: 10.0,
                  spreadRadius: 7,
                  offset: Offset(2, 2),
                ),
                BoxShadow(
                  color: Theme.of(context).canvasColor.withOpacity(0.12),
                  blurRadius: 7.0,
                  spreadRadius: 5,
                  offset: Offset(2, 2),
                ),
                BoxShadow(
                  color: Theme.of(context).canvasColor.withOpacity(0.10),
                  blurRadius: 4.0,
                  spreadRadius: 3,
                  offset: Offset(2, 2),
                ),
                BoxShadow(
                  color: Theme.of(context).canvasColor.withOpacity(0.09),
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                  offset: Offset(2, 2),
                ),
              ],
            )
                : BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10)
            ),
            // margin: EdgeInsets.only(right: ResponsiveWidget.isMediumScreen(context) ? 0 : 16),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ImageSlider(
                      images: productListData?.productDetails?.productImages,
                    ),
                    productGalleryTitleSection(context, productListData, true)
                  ],
                ),
                Positioned(
                    top: 1,
                    right: -5,
                    child: IconButton(
                        iconSize: 40,
                        icon: Image.asset(
                          productListData?.productDetails?.isFavorite == true
                              ? AssetsConstants.ic_wishlistSelect
                              : AssetsConstants.ic_wishlistUnselect,
                        ),
                        onPressed: () async {
                          closeAppbarProperty();

                          SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                          if (sharedPreferences.getString('token') == null) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return LoginUp(
                                    product: true,
                                  );
                                });
                          } else {
                            final isFav = productListData!.productDetails!.isFavorite = !productListData.productDetails!.isFavorite!;
                            viewmodel.addToFavourite(
                                context,
                                "${productListData.productId}",
                                "${productListData.productDetails?.variantId}",
                                isFav,
                                '');
                          }
                        }))

              ],
            ),
          ));
    },
    hovered: Matrix4.identity()..translate(0, 0, 0),
  );
}