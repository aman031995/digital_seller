import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/Products/ProductList.dart';
import 'package:TychoStream/view/Products/image_slider.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/OnHover.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/getAppBar.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  ScrollController scrollController = ScrollController();
  String? checkInternet;
  int pageNum = 1;
  bool isfab = false;
  HomeViewModel homeViewModel = HomeViewModel();
  ProfileViewModel profileViewModel = ProfileViewModel();
  TextEditingController? searchController = TextEditingController();

  @override
  void initState() {
    homeViewModel.getAppConfig(context);
    profileViewModel.getUserDetails(context);
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

    return checkInternet == "Offline"
        ? NOInternetScreen()
        : ChangeNotifierProvider.value(
            value: cartViewModel,
            child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
              return GestureDetector(
                onTap: () {
                  if (isLogins == true) {
                    isLogins = false;
                    setState(() {});
                  }
                  if(isSearch==true){
                    isSearch=false;
                    setState(() {

                    });
                  }
                },
                child: Scaffold(
                  appBar: getAppBar(context, homeViewModel, profileViewModel,
                      viewmodel.cartItemCount,searchController, () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    token = sharedPreferences.getString('token').toString();
                    if (token == 'null') {
                      showDialog(
                          context: context,
                          barrierColor:
                              Theme.of(context).canvasColor.withOpacity(0.6),
                          builder: (BuildContext context) {
                            return LoginUp(
                              product: true,
                            );
                          });
                      // _backBtnHandling(prodId);
                    } else {
                      reloadPage();
                      // context.router.push(FavouriteListPage());
                    }
                  }, () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    token = sharedPreferences.getString('token').toString();
                    if (token == 'null') {
                      showDialog(
                          context: context,
                          barrierColor:
                              Theme.of(context).canvasColor.withOpacity(0.6),
                          builder: (BuildContext context) {
                            return LoginUp(
                              product: true,
                            );
                          });
                    } else {
                      context.router.push(
                          CartDetail(itemCount: '${viewmodel.cartItemCount}'));
                    }
                  }),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: viewmodel.productListModel?.productList != null
                      ? viewmodel.productListModel!.productList!.length > 0
                          ? ResponsiveWidget.isMediumScreen(context)
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: SizeConfig.screenHeight / 1.1,
                                        child: Stack(
                                          children: [
                                            GridView.builder(
                                              shrinkWrap: true,
                                              controller: _scrollController,
                                              padding: EdgeInsets.all(8),
                                              physics: BouncingScrollPhysics(),
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.65,
                                              ),
                                              itemCount: viewmodel
                                                  .productListModel
                                                  ?.productList
                                                  ?.length,
                                              itemBuilder: (context, index) {
                                                _scrollController.addListener(() {
                                                  if (_scrollController
                                                          .position.pixels ==
                                                      _scrollController.position
                                                          .maxScrollExtent) {
                                                    viewmodel.onPagination(
                                                        context,
                                                        viewmodel.lastPage,
                                                        viewmodel.nextPage,
                                                        viewmodel.isLoading,
                                                        'productList');
                                                  }
                                                });
                                                final productListData = viewmodel
                                                    .productListModel
                                                    ?.productList?[index];
                                                return productListItems(
                                                    context,
                                                    productListData,
                                                    index,
                                                    viewmodel);
                                              },
                                            ),
                                            viewmodel.isLoading == true
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: SizeConfig
                                                                .screenHeight /
                                                            1.3),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ))
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 50),
                                      footerMobile(context)
                                    ],
                                  ),
                                )
                              : Stack(
                                children: [
                                  SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            // height:SizeConfig.screenHeight/1.2,
                                            width: SizeConfig.screenWidth,
                                            margin: EdgeInsets.only(
                                                left: SizeConfig.screenWidth * 0.13,
                                                right: SizeConfig.screenWidth * 0.13),
                                            child: Stack(
                                              children: [
                                                GridView.builder(
                                                  shrinkWrap: true,
                                                  controller: _scrollController,
                                                  physics: BouncingScrollPhysics(),
                                                  padding: EdgeInsets.only(top: 30),
                                                  gridDelegate:
                                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                                          mainAxisSpacing: 15,
                                                          mainAxisExtent: 470,
                                                          maxCrossAxisExtent: 350),
                                                  itemCount: viewmodel
                                                      .productListModel
                                                      ?.productList
                                                      ?.length,
                                                  itemBuilder: (context, index) {
                                                    _scrollController.addListener(() {
                                                      if (_scrollController
                                                              .position.pixels ==
                                                          _scrollController.position
                                                              .maxScrollExtent) {
                                                        viewmodel.onPagination(
                                                            context,
                                                            viewmodel.lastPage,
                                                            viewmodel.nextPage,
                                                            viewmodel.isLoading,
                                                            'productList');
                                                      }
                                                    });
                                                    final productListData =
                                                        cartViewModel.productListModel
                                                            ?.productList?[index];
                                                    return productListItems(
                                                        context,
                                                        productListData,
                                                        index,
                                                        viewmodel);
                                                  },
                                                ),
                                                viewmodel.isLoading == true
                                                    ? Container(
                                                        margin:
                                                            EdgeInsets.only(top: 50),
                                                        alignment:
                                                            Alignment.bottomCenter,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                        ))
                                                    : SizedBox()
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: SizeConfig.screenHeight * 0.3),
                                          footerDesktop()
                                        ],
                                      ),
                                    ),
                                  isLogins == true
                                      ? Positioned(
                                      top: 0,
                                      right: 35,
                                      child: profile(context, setState,
                                          profileViewModel))
                                      : Container(),
                                  isSearch==true?
                                  Positioned(
                                      top: ResponsiveWidget.isMediumScreen(context) ? 0:0,
                                      right: ResponsiveWidget.isMediumScreen(context) ? 0:SizeConfig.screenWidth*0.15,

                                      child: searchList(context, homeViewModel, scrollController,homeViewModel, searchController!,cartViewModel.cartItemCount))
                                      : Container()
                                ],
                              )
                          : Center(
                              child: noDataFoundMessage(
                                  context, StringConstant.noItemInCart))
                      : Center(
                          child: ThreeArchedCircle(size: 45.0),
                        ),
                ),
              );
            }));
  }

  //ProductListItems
  Widget productListItems(BuildContext context, ProductList? productListData,
      int index, CartViewModel viewmodel) {
    return OnHover(
      builder: (isHovered) {
        return GestureDetector(
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
                ),
              );
            },
            child: Container(
              decoration: isHovered == true
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).canvasColor.withOpacity(0.15),
                          blurRadius: 10.0,
                          spreadRadius: 7,
                          offset: Offset(2, 2),
                        ),
                        BoxShadow(
                          color:
                              Theme.of(context).canvasColor.withOpacity(0.12),
                          blurRadius: 7.0,
                          spreadRadius: 5,
                          offset: Offset(2, 2),
                        ),
                        BoxShadow(
                          color:
                              Theme.of(context).canvasColor.withOpacity(0.10),
                          blurRadius: 4.0,
                          spreadRadius: 3,
                          offset: Offset(2, 2),
                        ),
                        BoxShadow(
                          color:
                              Theme.of(context).canvasColor.withOpacity(0.09),
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                          offset: Offset(2, 2),
                        ),
                      ],
                    )
                  : BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
              margin: EdgeInsets.only(right: 16),
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
                      right: 10,
                      top: 5,
                      child: IconButton(
                        iconSize: 45,
                        icon: Image.asset(
                          productListData?.productDetails?.isFavorite == true
                              ? AssetsConstants.ic_wishlistSelect
                              : AssetsConstants.ic_wishlistUnselect,
                        ),
                        onPressed: () {
                          final isFav =
                              productListData!.productDetails!.isFavorite =
                                  !productListData.productDetails!.isFavorite!;
                          viewmodel.addToFavourite(
                              context,
                              "${productListData.productId}",
                              "${productListData.productDetails?.variantId}",
                              isFav,
                              'productList');
                        },
                      ))
                ],
              ),
            ));
      },
      hovered: Matrix4.identity()..translate(0, 0, 0),
    );
  }
}
