import 'package:TychoStream/main.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/services/session_storage.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
import 'package:TychoStream/view/restaurant/product_list_restaurant.dart';
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
class RestaurantSubcategoryProductList extends StatefulWidget {
  final String? SubcategoryProductName;

  RestaurantSubcategoryProductList({
    @PathParam('SubcategoryProductName') this.SubcategoryProductName,
    Key? key,
  }) : super(key: key);

  @override
  State<RestaurantSubcategoryProductList> createState() => _RestaurantSubcategoryProductListState();
}

class _RestaurantSubcategoryProductListState extends State<RestaurantSubcategoryProductList> {
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
    notificationViewModel.getNotificationCountText(context);
    homeViewModel.getAppConfig(context);
    getProduct();
    cartViewModel.getCartCount(context);
    super.initState();
  }

  getProduct() {
    cartViewModel.getProductListCategory(context, "", widget.SubcategoryProductName ?? "",  SessionStorageHelper.getValue("pageNum").toString()=="null"?1:int.parse(SessionStorageHelper.getValue("pageNum").toString()),(result, isSuccess){});
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
              child: Consumer<NotificationViewModel>(builder: (context, model, _) {
                return ChangeNotifierProvider.value(
                    value: homeViewModel,
                    child: Consumer<HomeViewModel>(builder: (context, s, _) {
                      return GestureDetector(
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
                  profileViewModel,model
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
                    closeAppbarProperty();

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
                    closeAppbarProperty();

                    context.router.push(CartDetail(
                        itemCount: '${cartViewModel.cartItemCount}'));
                  }
                }),
                body: Scaffold(
                  extendBodyBehindAppBar: true,
                  key: _scaffoldKey,
                  backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor,
                  drawer: ResponsiveWidget.isMediumScreen(context)
                      ? AppMenu()
                      : SizedBox(),
                  body:  Stack(
                    children: [
                      viewmodel.productListModel?.productList != null
                          ? (viewmodel.productListModel?.productList?.length ?? 0) > 0
                          ? SingleChildScrollView(
                        controller: scrollController1,
                          child: Column(
                            children: [
                              ResponsiveWidget.isMediumScreen(context)
                                  ? Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 12, left: 12, top: 12),
                                    width: SizeConfig.screenWidth,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:ResponsiveWidget.isSmallScreen(context) ? 2:3,
                                        childAspectRatio: ResponsiveWidget.isSmallScreen(context) ? 0.85:0.80,mainAxisSpacing: 5,crossAxisSpacing: 5
                                      ),
                                      itemCount: viewmodel.productListModel?.productList?.length,
                                      itemBuilder: (context, index) {
                                        final productListData = viewmodel.productListModel?.productList?[index];
                                        return productListRestaurantItems(
                                            context,
                                            productListData,
                                            index,
                                            viewmodel);
                                      },
                                    ),
                                  ),
                                  onPagination(viewmodel),
                                ],
                              )
                                  : Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  // CategoryFilterScreen(
                                  //   items: [],
                                  // ),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center,
                                    children: [
                                      // Container(
                                      //     alignment:
                                      //     Alignment.topLeft,
                                      //     padding:
                                      //     EdgeInsets.only(
                                      //         top: 30,
                                      //         right: 20),
                                      //     width: SizeConfig
                                      //         .screenWidth /
                                      //         1.75,
                                      //     child:
                                      //     catrgoryTopSortWidget(context)),
                                      Container(
                                          width: ResponsiveWidget.isMediumScreen(context) ?SizeConfig.screenWidth/1.08:SizeConfig.screenWidth/1.38,
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            padding:
                                            EdgeInsets.only(
                                                top: 30,
                                                right: 5),
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
                                      onPagination(viewmodel),
                                    ],
                                  ),
                                ],
                              ),
                              ResponsiveWidget.isMediumScreen(context)
                                  ?   SizedBox(height:ResponsiveWidget.isSmallScreen(context)
                                  ? 50:100)
                                  : SizedBox(height: 100),
                              ResponsiveWidget.isMediumScreen(context)
                                  ? footerMobile(context,homeViewModel)
                                  : footerDesktop()
                            ],
                          )):
                             noDataFoundMessage(context,StringConstant.noProductAdded,homeViewModel):
                      Center(
                        child: ThreeArchedCircle(size: 45.0),
                      ),
                      ResponsiveWidget.isMediumScreen(context)
                          ? Container()
                          : GlobalVariable.isnotification == true
                          ?    Positioned(
                          top:  1,
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
                          right: SizeConfig.screenWidth *
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
                )),
          );
        }));
        })); }));
  }

  onPagination( CartViewModel viewmodel){
    return  viewmodel.productListModel!.pagination!.lastPage==1?Container():   Container(
      height: 40,
      margin: EdgeInsets.only(
          right: 12,
          left: 12,
          top: 20),
      width:ResponsiveWidget.isMediumScreen(context)
          ? viewmodel.productListModel!.pagination!.lastPage! < 4?SizeConfig.screenWidth/1.6  :SizeConfig.screenWidth:      viewmodel.productListModel!.pagination!.lastPage! < 4?SizeConfig.screenWidth/5:SizeConfig.screenWidth/4,
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
        onPageChange: (int index) {
          setState(() {
            AppIndicator.loadingIndicator(context);
            cartViewModel.getProductListCategory(
                context, "", widget.SubcategoryProductName ?? "", index + 1,(result, isSuccess){
              if(isSuccess){
                scrollController1.jumpTo(0);}


            });
          });
        },
      ),
    );
  }
}
