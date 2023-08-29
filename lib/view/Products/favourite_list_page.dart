import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
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
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  HomeViewModel homeViewModel = HomeViewModel();
  ProfileViewModel profileViewModel = ProfileViewModel();
  TextEditingController? searchController = TextEditingController();

  @override
  void initState() {
    homeViewModel.getAppConfig(context);
    // profileViewModel.getUserDetails(context);
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
                  if (isSearch == true) {
                    isSearch = false;
                    setState(() {});
                  }
                },
                child: Scaffold(
                    appBar: ResponsiveWidget.isMediumScreen(context)
                        ? homePageTopBar(context, _scaffoldKey, viewmodel.cartItemCount,homeViewModel, profileViewModel,)
                        : getAppBar(
                            context,
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
                              if (isLogins == true) {
                                isLogins = false;
                                setState(() {});
                              }
                              if (isSearch == true) {
                                isSearch = false;
                                setState(() {});
                              }


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
                                setState(() {});
                              }
                              if (isSearch == true) {
                                isSearch = false;
                                setState(() {});
                              }
                              context.router.push(CartDetail(
                                  itemCount: '${viewmodel.cartItemCount}'));
                            }
                          }),
                    body: Scaffold(

                      extendBodyBehindAppBar: true,
                      key: _scaffoldKey,
                      backgroundColor: Theme.of(context)
                          .scaffoldBackgroundColor,
                      drawer:
                      ResponsiveWidget.isMediumScreen(context)
                          ? AppMenu()
                          : SizedBox(),
                      body: viewmodel.productListModel?.productList != null
                          ? viewmodel.productListModel!.productList!.length > 0
                              ? Stack(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ResponsiveWidget.isMediumScreen(
                                                  context)
                                              ? Container(
                                                  height:
                                                      SizeConfig.screenHeight /
                                                          1.1,
                                            margin: EdgeInsets.only(right: 12,left: 12,top: 12),

                                            child: GridView.builder(
                                                    shrinkWrap: true,
                                                    controller:
                                                        _scrollController,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      childAspectRatio: 0.65,
                                                    ),
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
                                                              viewmodel
                                                                  .lastPage,
                                                              viewmodel
                                                                  .nextPage,
                                                              viewmodel
                                                                  .isLoading,
                                                              'productList');
                                                        }
                                                      });
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
                                                    controller:
                                                        _scrollController,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    padding: EdgeInsets.only(
                                                        top: 30),
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
                                                              viewmodel
                                                                  .lastPage,
                                                              viewmodel
                                                                  .nextPage,
                                                              viewmodel
                                                                  .isLoading,
                                                              'productList');
                                                        }
                                                      });
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
                                          ResponsiveWidget.isMediumScreen(
                                                  context)
                                              ? SizedBox(height: 50)
                                              : SizedBox(height: 200),
                                          ResponsiveWidget.isMediumScreen(
                                                  context)
                                              ? footerMobile(context)
                                              : footerDesktop(),
                                        ],
                                      ),
                                    ),
                                    ResponsiveWidget
                                        .isMediumScreen(context)
                                        ?Container():    isLogins == true
                                        ? Positioned(
                                            top: 0,
                                            right:  180,
                                            child: profile(context, setState,
                                                profileViewModel))
                                        : Container(),
                                    ResponsiveWidget
                                        .isMediumScreen(context)
                                        ? Container():   isSearch == true
                                        ? Positioned(
                                            top: 0,
                                            right:  SizeConfig.screenWidth * 0.20,
                                            child: searchList(
                                                context,
                                                homeViewModel,
                                                scrollController,
                                                homeViewModel,
                                                searchController!,
                                                cartViewModel.cartItemCount))
                                        : Container(),
                                    viewmodel.isLoading == true
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                top: ResponsiveWidget
                                                        .isMediumScreen(context)
                                                    ? 50
                                                    : SizeConfig.screenHeight /
                                                        1.3),
                                            alignment: Alignment.bottomCenter,
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ))
                                        : SizedBox()
                                  ],
                                )
                              : Stack(
                                children: [
                                  noDataFoundMessage(
                                      context,StringConstant.noProductFound),
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
                                      top: ResponsiveWidget
                                          .isMediumScreen(context)
                                          ? 0
                                          : SizeConfig.screenWidth *
                                          0.001,
                                      right: ResponsiveWidget
                                          .isMediumScreen(context)
                                          ? 0
                                          : SizeConfig.screenWidth *
                                          0.15,
                                      child: searchList(
                                          context,
                                          homeViewModel,
                                          scrollController,
                                          homeViewModel,
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
              );
            }));
  }
}
