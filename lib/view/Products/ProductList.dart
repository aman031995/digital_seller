import 'package:TychoStream/Utilities/AssetsConstants.dart';
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
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/Products/CategoryFilterWidget.dart';
import 'package:TychoStream/view/Products/image_slider.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/OnHover.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/getAppBar.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppRouter.gr.dart';
import '../widgets/search_view.dart';

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
  HomeViewModel homeViewModel = HomeViewModel();
  ProfileViewModel profileViewModel = ProfileViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  TextEditingController? searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<String> sortDropDownList = ["Recommended", "What's New", "Popularity", "Better Discount", "Price: High to Low", "Price: Low to High", "Customers Rating"];


  void initState() {
    homeViewModel.getAppConfig(context);
    profileViewModel.getUserDetails(context);
    cartViewModel.getProductListData(context, pageNum);
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
                },
                child: Scaffold(
                  appBar:  ResponsiveWidget.isMediumScreen(context)
                      ? homePageTopBar(context,_scaffoldKey):getAppBar(context, homeViewModel, profileViewModel,
                      cartViewModel.cartItemCount, searchController,() async {
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
                      context.router.push(FavouriteListPage());
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
                      context.router.push(CartDetail(
                          itemCount: '${cartViewModel.cartItemCount}'));
                    }
                  }),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: viewmodel.productListModel?.productList != null
                      ? viewmodel.productListModel!.productList!.length > 0
                          ? ResponsiveWidget.isMediumScreen(context)
                              ? Scaffold(
                    extendBodyBehindAppBar: true,
                    key: _scaffoldKey,
                    backgroundColor: Theme.of(context).backgroundColor,
                    drawer: ResponsiveWidget.isMediumScreen(context)
                        ? AppMenu():SizedBox(),

                                body: Stack(
                                  children: [
                                    SingleChildScrollView(
                                        child: Column(
                                        children: [
                                          Container(
                                            height: SizeConfig.screenHeight,
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              controller: _scrollController,
                                              padding: EdgeInsets.all(8),
                                              physics: BouncingScrollPhysics(),
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.68,
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
                                          ),
                                          SizedBox(height: 50),
                                          footerMobile(context)
                                        ],
                                      )),
                                    viewmodel.isLoading == true
                                        ? Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                        alignment:
                                        Alignment.bottomCenter,
                                        child:
                                        CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .primaryColor,
                                        ))
                                        : SizedBox(),
                                    isLogins == true
                                        ? Positioned(
                                        top: 0,
                                        right: 10,
                                        child: profile(context, setState,
                                            profileViewModel))
                                        : Container(),
                                  ],
                                ),
                              )
                              : Stack(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth / 6.5,
                                                height: SizeConfig.screenHeight * 2,
                                                child: CategoryFilterScreen(items: [],),
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.only(top: 30,),
                                                      width: SizeConfig.screenWidth/2.03,
                                                      color: Theme.of(context).cardColor,
                                                      child: catrgoryTopSortWidget()),
                                                  Container(
                                                    width: SizeConfig.screenWidth/2,
                                                    child: GridView.builder(
                                                      shrinkWrap: true,
                                                      controller: _scrollController,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      padding:
                                                          EdgeInsets.only(top: 30),
                                                      gridDelegate:
                                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                                              mainAxisSpacing: 15,
                                                              mainAxisExtent: 470,
                                                              maxCrossAxisExtent:
                                                                  350),
                                                      itemCount: viewmodel
                                                          .productListModel
                                                          ?.productList
                                                          ?.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        _scrollController
                                                            .addListener(() {
                                                          if (_scrollController
                                                                  .position
                                                                  .pixels ==
                                                              _scrollController
                                                                  .position
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
                                                            cartViewModel
                                                                    .productListModel
                                                                    ?.productList?[
                                                                index];
                                                        return productListItems(
                                                            context,
                                                            productListData,
                                                            index,
                                                            viewmodel);
                                                      },
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 100),
                                          footerDesktop()
                                        ],
                                      ),
                                    ),
                                    viewmodel.isLoading == true
                                        ? Container(
                                        alignment: Alignment
                                            .bottomCenter,
                                        child:
                                        CircularProgressIndicator(
                                          color:
                                          Theme.of(context)
                                              .primaryColor,
                                        ))
                                        : SizedBox(),
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
                                        right: ResponsiveWidget.isMediumScreen(context) ? 0:SizeConfig.screenWidth*0.09,

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



  Widget catrgoryTopSortWidget(){
    return Container(
      height: SizeConfig.screenHeight * 0.05,
      child: Row(
        children: [
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: AppRegularFont(context, msg: "1240 Item found", color: Theme.of(context).canvasColor),
          ),
          Expanded(child: SizedBox(width: SizeConfig.screenWidth/ 8,)),
          Container(
              child: dropdown(sortDropDownList, context))
        ],
      ),
    );
  }

  Widget dropdown(List<String> txt,BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: AppRegularFont(context, msg: "Sort By", color: Theme.of(context).canvasColor, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 15,),
        Container(
          height: SizeConfig.screenHeight * .04,
          width: ResponsiveWidget.isMediumScreen(context)? 150:200,
          margin: EdgeInsets.only(left: 10,right: 10),
          child: DropdownButtonFormField2(

            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(14),
                color: Theme.of(context).cardColor.withOpacity(0.8),

              ),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).cardColor.withOpacity(0.9),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.2)),
              ),
              // isDense: true,
              contentPadding: EdgeInsets.only(bottom: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            //isExpanded: true,
            hint: Text(
              txt[0],
              style: TextStyle(fontSize:ResponsiveWidget.isMediumScreen(context)?12: 14, color: Theme.of(context).canvasColor.withOpacity(0.4),),
            ),
            isExpanded: true,
            items: txt
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(fontSize: ResponsiveWidget.isMediumScreen(context)?12:14, color:Theme.of(context).canvasColor.withOpacity(0.6),),
              ),
            ))
                .toList(),
            onChanged: (String? value) {
//selectedValue = value.toString();
            },
          ),
        ),
      ],
    );
  }


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
              margin: EdgeInsets.only(right: ResponsiveWidget.isMediumScreen(context)
                  ?0:16),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ImageSlider(
                        images: productListData?.productDetails?.productImages,
                      ),
                      productGalleryTitleSection(
                          context, productListData, false)
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
                        onPressed: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          token =
                              sharedPreferences.getString('token').toString();
                          if (token == 'null') {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return LoginUp(
                                    product: true,
                                  );
                                });
                            // _backBtnHandling(prodId);
                          } else {
                            final isFav = productListData!
                                    .productDetails!.isFavorite =
                                !productListData.productDetails!.isFavorite!;
                            viewmodel.addToFavourite(
                                context,
                                "${productListData.productId}",
                                "${productListData.productDetails?.variantId}",
                                isFav,
                                'productList');
                          }
                        },
                      ))
                ],
              ),
            ));
      },
      hovered: Matrix4.identity()..translate(0, 0, 0),
    );
  }

  // this method is called when navigate to this page using dynamic link
  receivedArgumentsNotification() {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final Map<String, dynamic> data =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      cartViewModel.getProductList(context, pageNum);
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
  }
}

Widget productGalleryTitleSection(
    BuildContext context, ProductList? productListData, bool favbourite) {
  return Container(
    height: 60,
    padding: const EdgeInsets.only(
      left: 8.0,
      top: 8,
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
          msg: favbourite == true
              ? getFavTitle(productListData) ?? ''
              : getNameTitle(productListData) ?? '',
          fontSize: 18.0,
        ),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FittedBox(
                child: AppMediumFont(context,
                    msg: "₹" '${productListData?.productDetails?.productPrice}',
                    fontSize:
                        ResponsiveWidget.isMediumScreen(context) ? 14 : 18.0,
                    color: Theme.of(context).canvasColor.withOpacity(0.6),
                    textDecoration: TextDecoration.lineThrough)),
            SizedBox(width: 4.0),
            FittedBox(
                child: AppMediumFont(
              context,
              color: Theme.of(context).canvasColor.withOpacity(0.9),
              msg: "₹"
                  '${productListData?.productDetails?.productDiscountPrice}',
              fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 18.0,
            )),
            SizedBox(width: 4.0),
            FittedBox(
                child: AppMediumFont(context,
                    fontSize:
                        ResponsiveWidget.isMediumScreen(context) ? 14 : 16.0,
                    msg:
                        '${productListData?.productDetails?.productDiscountPercent}' +
                            '%OFF',
                    color: GREEN)),
          ],
        ),
        SizedBox(height: 3)
      ],
    ),
  );
}
