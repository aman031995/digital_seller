import 'package:TychoStream/main.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/Products/CategoryFilterWidget.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/getAppBar.dart';
import 'package:TychoStream/view/WebScreen/NotificationScreen.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
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
import '../../AppRouter.gr.dart';

@RoutePage()
class ProductListGallery extends StatefulWidget {
  final List<String>? discountdata;
  ProductListGallery({
    @QueryParam() this.discountdata,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductListGallery> createState() => _ProductListGalleryState();
}

class _ProductListGalleryState extends State<ProductListGallery> {
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
              widget.discountdata?[0] ?? "");
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
                        return
                          viewmodel.productListModel?.productList != null
                              ?   GestureDetector(
                onTap: () {
                  if (isLogins == true) {
                    isLogins = false;
                  }
                  if (isSearch == true) {
                    isSearch = false;
                  }
                  if(isnotification==true){
                    isnotification=false;

                  }
                },
                child: Scaffold(
                    appBar: ResponsiveWidget.isMediumScreen(context)
                        ? homePageTopBar(
                            context,
                            _scaffoldKey,
                            cartViewModel.cartItemCount,
                            homeViewModel,
                            profileViewModel,
                        model
                          )
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
                              if (isLogins == true) {
                                isLogins = false;
                              }
                              if (isSearch == true) {
                                isSearch = false;
                              }
                              if(isnotification==true){
                                isnotification=false;

                              }
                              context.router.push(FavouriteListPage());
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
                              if (isLogins == true) {
                                isLogins = false;
                              }
                              if (isSearch == true) {
                                isSearch = false;
                              }
                              if(isnotification==true){
                                isnotification=false;

                              }
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
                      body: viewmodel.productListModel?.productList != null
                          ? (viewmodel.productListModel?.productList?.length ?? 0) > 0
                              ? Stack(
                                  children: [
                                    SingleChildScrollView(
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
                                                        crossAxisCount: 2,
                                                        childAspectRatio: ResponsiveWidget.isSmallScreen(context) ? 0.6:0.90,mainAxisSpacing: 3,crossAxisSpacing: 3
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
                                                        return productListItems(
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
                                                  CategoryFilterScreen(items: [],),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          alignment: Alignment.topLeft,
                                                          padding: EdgeInsets.only(top: 30, right: 20),
                                                          width: SizeConfig.screenWidth /1.75,
                                                          child: catrgoryTopSortWidget(context)),
                                                      Container(
                                                          width: SizeConfig.screenWidth / 1.75,
                                                          child: GridView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 30,
                                                                    right: 5),
                                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                                mainAxisSpacing:
                                                                    15,
                                                                mainAxisExtent:
                                                                    500,
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
                                                              return productListItems(
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
                                            ? SizedBox(height: 50)
                                            : SizedBox(height: 100),
                                        ResponsiveWidget.isMediumScreen(context)
                                            ? footerMobile(context,homeViewModel)
                                            : footerDesktop()
                                      ],
                                    )),
                                    ResponsiveWidget.isMediumScreen(context)
                                        ? Container()
                                        : isnotification == true
                                        ?    Positioned(
                                        top:  0,
                                        right:  SizeConfig
                                            .screenWidth *
                                            0.20,
                                        child: notification(notificationViewModel,context,_scrollController)):Container(),
                                    ResponsiveWidget.isMediumScreen(context)
                                        ? Container()
                                        : isLogins == true
                                            ? Positioned(
                                                top: 0,
                                                right: 180,
                                                child: profile(context,
                                                    setState, profileViewModel))
                                            : Container(),
                                    ResponsiveWidget.isMediumScreen(context)
                                        ? Container()
                                        : isSearch == true
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
                              : Stack(
                        children: [
                          noDataFoundMessage(
                              context,StringConstant.noProductAdded,homeViewModel),
                          ResponsiveWidget.isMediumScreen(context)
                              ? Container()
                              : isnotification == true
                              ?    Positioned(
                              top:  0,
                              right:  SizeConfig
                                  .screenWidth *
                                  0.20,
                              child: notification(notificationViewModel,context,_scrollController)):Container(),
                          ResponsiveWidget
                              .isMediumScreen(context)
                              ?Container(): isLogins == true
                              ? Positioned(
                              top: 0,
                              right:  180,
                              child: profile(context,
                                  setState, profileViewModel))
                              : Container(),
                          ResponsiveWidget
                              .isMediumScreen(context)
                              ? Container():   isSearch == true
                              ? Positioned(
                              top:  SizeConfig.screenWidth *
                                  0.001,
                              right:  SizeConfig.screenWidth *
                                  0.20,
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
                          : Center(
                              child: ThreeArchedCircle(size: 45.0),
                            ),
                    )),
              ): Container(
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
      width:  ResponsiveWidget
          .isMediumScreen(context)
          ?SizeConfig.screenWidth:SizeConfig.screenWidth/4,
      child: NumberPaginator(
        numberPages: viewmodel
            .productListModel!
            .pagination!
            .lastPage!,
        config:
        NumberPaginatorUIConfig(
          mode: ContentDisplayMode
              .numbers,
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

            AppIndicator
                .loadingIndicator(
                context);

              widget.discountdata?.length == null
                  ? cartViewModel.getProductList(context, index + 1,(result, isSuccess){
                    if(isSuccess){
                      scrollController1.jumpTo(0);}


              })

                  : cartViewModel.getOfferDiscountList(
                  context,
                  widget.discountdata?[1] ?? "",
                  index +
                      1,
                  widget.discountdata?[0] ?? "");


            // _currentPage = index;
          });
        },
      ),
    );
 }
}
