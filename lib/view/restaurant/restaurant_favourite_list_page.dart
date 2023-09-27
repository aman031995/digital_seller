import 'package:TychoStream/main.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
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
class RestaurantFavouriteListPage extends StatefulWidget {
  RestaurantFavouriteListPage({Key? key}) : super(key: key);

  @override
  State<RestaurantFavouriteListPage> createState() => _RestaurantFavouriteListPageState();
}

class _RestaurantFavouriteListPageState extends State<RestaurantFavouriteListPage> {
  CartViewModel cartViewModel = CartViewModel();
  ScrollController scrollController = ScrollController();
  String? checkInternet;
  int pageNum = 1;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  HomeViewModel homeViewModel = HomeViewModel();
  ProfileViewModel profileViewModel = ProfileViewModel();
  TextEditingController? searchController = TextEditingController();
  NotificationViewModel notificationViewModel = NotificationViewModel();
  ScrollController _scrollController = ScrollController();
  ScrollController scrollController1 = ScrollController();



  @override
  void initState() {
    homeViewModel.getAppConfig(context);
    cartViewModel.getCartCount(context);
    cartViewModel.getFavList(context, pageNum,(result, isSuccess){});
    notificationViewModel.getNotificationCountText(context);

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
              return ChangeNotifierProvider.value(
                  value: notificationViewModel,
                  child: Consumer<NotificationViewModel>(
                      builder: (context, model, _) {return GestureDetector(
                onTap: () {
                  closeAppbarProperty();

                },
                child: Scaffold(
                    appBar: ResponsiveWidget.isMediumScreen(context)
                        ? homePageTopBar(context, _scaffoldKey, viewmodel.cartItemCount,homeViewModel, profileViewModel,model)
                        : getAppBar(
                            context,model,
                            homeViewModel,
                            profileViewModel,
                            viewmodel.cartItemCount,1,
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
                                  itemCount: '${viewmodel.cartItemCount}'));
                            }
                          }),
                    body: Scaffold(
                      extendBodyBehindAppBar: true,
                      key: _scaffoldKey,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      drawer:
                      ResponsiveWidget.isMediumScreen(context)
                          ? AppMenu()
                          : SizedBox(),
                      body:  Stack(
                                  children: [
                                    viewmodel.productListModel?.productList != null
                                        ? viewmodel.productListModel!.productList!.length > 0
                                        ?SingleChildScrollView(
                                      controller: scrollController1,
                                      child: Column(
                                        children: [
                                          ResponsiveWidget.isMediumScreen(
                                                  context)
                                              ? Container(
                                            margin: EdgeInsets.only(right: 12,left: 12,top: 12),
                                            child: GridView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:ResponsiveWidget.isSmallScreen(context) ? 2:3,
                                                      childAspectRatio: ResponsiveWidget.isSmallScreen(context) ? 0.65:0.80,mainAxisSpacing: 5,crossAxisSpacing: 5
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
                                                          viewmodel,favouritepage: true);
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  width: SizeConfig.screenWidth,
                                                  margin: EdgeInsets.only(
                                                      left: SizeConfig
                                                              .screenWidth *
                                                          0.13,
                                                      right: SizeConfig
                                                              .screenWidth *
                                                          0.13),
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    padding: EdgeInsets.only(top: 30),
                                                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                        mainAxisSpacing:
                                                        10,crossAxisSpacing: 10,
                                                            mainAxisExtent: 500,
                                                            maxCrossAxisExtent:
                                                                400),
                                                    itemCount: viewmodel
                                                        .productListModel
                                                        ?.productList
                                                        ?.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final productListData =
                                                          cartViewModel
                                                              .productListModel
                                                              ?.productList?[index];
                                                      return productListItems(
                                                          context,
                                                          productListData,
                                                          index,
                                                          viewmodel,favouritepage: true);
                                                    },
                                                  ),
                                                ),

                                          onPagination(viewmodel),
                                          ResponsiveWidget.isMediumScreen(
                                                  context)
                                              ?   SizedBox(height:ResponsiveWidget.isSmallScreen(context)
                                              ? 50:150)
                                              : SizedBox(height: 200),
                                          ResponsiveWidget.isMediumScreen(
                                                  context)
                                              ? footerMobile(context,homeViewModel)
                                              : footerDesktop(),
                                        ],
                                      ),
                                    ): noDataFoundMessage(
                                        context,StringConstant.noProductFound,homeViewModel): Center(
                                      child: ThreeArchedCircle(size: 45.0),
                                    ),
                                    ResponsiveWidget.isMediumScreen(context)
                                        ? Container()
                                        : GlobalVariable.isnotification == true
                                        ?    Positioned(
                                        top:  0,
                                        right:  SizeConfig
                                            .screenWidth *
                                            0.20,
                                        child: notification(notificationViewModel,context,_scrollController)):Container(),
                                    ResponsiveWidget
                                        .isMediumScreen(context)
                                        ?Container():    GlobalVariable.isLogins == true
                                        ? Positioned(
                                            top: 0,
                                            right:  180,
                                            child: profile(context, setState,
                                                profileViewModel))
                                        : Container(),

                                    ResponsiveWidget
                                        .isMediumScreen(context)
                                        ? Container():   GlobalVariable.isSearch == true
                                        ? Positioned(
                                            top: SizeConfig.screenWidth * 0.001,
                                            right:  SizeConfig.screenWidth * 0.20,
                                            child: searchList(
                                                context,
                                                homeViewModel,
                                                scrollController,
                                                searchController!,
                                                cartViewModel.cartItemCount))
                                        : Container(),
                                  ],
                                )


                    )),
              );
            }));
  }));
  }

  onPagination( CartViewModel viewmodel){
    return  viewmodel.productListModel!.pagination!.lastPage==1?Container():   Container(
      height: 40,
      margin: EdgeInsets.only(
          right: 12,
          left: 12,
          top: 20),
      width:ResponsiveWidget.isMediumScreen(context)
          ?viewmodel.productListModel!.pagination!.lastPage! < 4?SizeConfig.screenWidth/1.6  : SizeConfig.screenWidth:SizeConfig.screenWidth/4,
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
        initialPage: 0,
        onPageChange:
            (int index) {
          setState(() {
            AppIndicator.loadingIndicator(context);
            cartViewModel.getFavList(context, index + 1,(result, isSuccess){
              if(isSuccess){
                scrollController1.jumpTo(0);}
            });
          });
        },
      ),
    );
  }
}
