import 'dart:math';

import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/OnHover.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/view/WebScreen/CommonCarousel.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import '../../AppRouter.gr.dart';
import '../../main.dart';
import 'getAppBar.dart';

@RoutePage()
class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  HomeViewModel homeViewModel = HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  ProfileViewModel profileViewModel = ProfileViewModel();
  String? checkInternet;
  CartViewModel cartViewModel = CartViewModel();
  TextEditingController? searchController = TextEditingController();
   AutoScrollController controller1=AutoScrollController();
  int counter1 = 4;
  late AutoScrollController controller;
  int counter = 4;
  List<String> images=['images/Frame27.png','images/Frame28.png','images/Frame29.png','images/Frame30.png','images/Frame31.png','images/Frame32.png','images/Frame33.png','images/Frame34.png'];

  void initState() {
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
    User();
    homeViewModel.getAppConfig(context);
    cartViewModel.getCartCount(context);
    cartViewModel.getProductCategoryList(context, 1);
    cartViewModel.getRecommendedViewData(context);
    profileViewModel.getProfileDetails(context);
    super.initState();
  }

  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.get('token') != null) {
      cartViewModel.getRecentView(context);
    }
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
            value: profileViewModel,
            child:
                Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
              return ChangeNotifierProvider.value(
                  value: homeViewModel,
                  child:
                      Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
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
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            extendBodyBehindAppBar: true,
                            appBar: ResponsiveWidget.isMediumScreen(context)
                                ? homePageTopBar(context, _scaffoldKey)
                                : getAppBar(
                                    context,
                                    viewmodel,
                                    profilemodel,
                                    cartViewModel.cartItemCount,
                                    searchController, () async {
                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    if (sharedPreferences.get('token') !=
                                        null) {
                                      showDialog(
                                          context: context,
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
                                    token = sharedPreferences
                                        .getString('token')
                                        .toString();
                                    if (token == 'null') {
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
                                      context.router.push(CartDetail(
                                          itemCount:
                                              '${cartViewModel.cartItemCount}'));
                                    }
                                  }),
                            body: checkInternet == "Offline"
                                ? NOInternetScreen()
                                : Scaffold(
                                    extendBodyBehindAppBar: true,
                                    key: _scaffoldKey,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    drawer:
                                        ResponsiveWidget.isMediumScreen(context)
                                            ? AppMenu()
                                            : SizedBox(),
                                    body: Stack(
                                      children: [
                                        SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonCarousel(),
                                              SizedBox(height: 24),
                                              ///category product list............

                                              Container(
                                                margin: EdgeInsets.zero,
                                                color: Theme.of(context)
                                                    .cardColor
                                                    .withOpacity(0.6),
                                                padding: EdgeInsets.only(
                                                    left:
                                                        SizeConfig.screenWidth *
                                                            0.12,
                                                    right:
                                                        SizeConfig.screenWidth *
                                                            0.12,
                                                    top: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppBoldFont(context,
                                                        msg:
                                                            "What are you looking for?",
                                                        fontSize: ResponsiveWidget
                                                                .isMediumScreen(
                                                                    context)
                                                            ? 14
                                                            : 18),
                                                    SizedBox(
                                                        height: SizeConfig
                                                                .screenHeight *
                                                            0.01),
                                                    Container(
                                                        height: SizeConfig
                                                                .screenWidth *
                                                            0.2,
                                                        child: ListView.builder(
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            reverse: false,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount: cartViewModel
                                                                .categoryListModel
                                                                ?.length,
                                                            itemBuilder:
                                                                (context,
                                                                    position) {
                                                              return GestureDetector(
                                                                onTap: () {},
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              16),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      CircleAvatar(
                                                                        radius: SizeConfig.screenWidth *
                                                                            0.08,
                                                                        child: CachedNetworkImage(
                                                                            imageUrl: cartViewModel.categoryListModel?[position].imageUrl ?? "",
                                                                            fit: BoxFit.fill,
                                                                            imageBuilder: (context, imageProvider) => Container(
                                                                                  decoration: BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                    image: DecorationImage(
                                                                                      image: imageProvider,
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey))),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              SizeConfig.screenHeight * 0.01),
                                                                      Container(
                                                                        width: SizeConfig.screenHeight *
                                                                            0.15,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            bottom:
                                                                                5),
                                                                        child: AppBoldFont(
                                                                            maxLines:
                                                                                1,
                                                                            context,
                                                                            msg: cartViewModel.categoryListModel?[position].categoryTitle ??
                                                                                "",
                                                                            fontSize: ResponsiveWidget.isMediumScreen(context)
                                                                                ? 14
                                                                                : 18,
                                                                            color:
                                                                                Theme.of(context).hintColor),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              SizeConfig.screenHeight * 0.01),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            })),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: 24),

                                              //Recommend product .................

                                              Container(
                                                height: ResponsiveWidget
                                                        .isMediumScreen(context)
                                                    ? 185
                                                    : SizeConfig.screenWidth *
                                                        0.32,
                                                margin: EdgeInsets.zero,
                                                padding: EdgeInsets.only(
                                                    left:
                                                        SizeConfig.screenWidth *
                                                            0.11,
                                                    right:
                                                        SizeConfig.screenWidth *
                                                            0.11,
                                                    top: 20),
                                                color: Theme.of(context)
                                                    .cardColor
                                                    .withOpacity(0.6),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .screenWidth *
                                                              0.01,
                                                          right: SizeConfig
                                                                  .screenWidth *
                                                              0.01),
                                                      child: AppBoldFont(
                                                          context,
                                                          msg: StringConstant
                                                              .Recommended,
                                                          fontSize: ResponsiveWidget
                                                                  .isMediumScreen(
                                                                      context)
                                                              ? 14
                                                              : 18),
                                                    ),
                                                    SizedBox(
                                                        height: SizeConfig
                                                                .screenWidth *
                                                            0.01),
                                                    Stack(
                                                      children: [
                                                        Container(
                                                            padding: EdgeInsets.only(
                                                                left: SizeConfig
                                                                        .screenWidth *
                                                                    0.01,
                                                                right: SizeConfig
                                                                        .screenWidth *
                                                                    0.01),
                                                            height: ResponsiveWidget.isMediumScreen(context)
                                                                ? 185
                                                                : SizeConfig
                                                                        .screenWidth *
                                                                    0.28,
                                                            child: ListView.builder(
                                                                reverse: false,
                                                                controller: controller,
                                                                padding: EdgeInsets.zero,
                                                                shrinkWrap: true,
                                                                scrollDirection: Axis.horizontal,
                                                                itemCount: cartViewModel.recommendedView?.length,
                                                                itemBuilder: (context, position) {
                                                                  return AutoScrollTag(
                                                                      key: ValueKey(
                                                                          position),
                                                                      controller:
                                                                          controller,
                                                                      index:
                                                                          position,
                                                                      child:
                                                                          OnHover(
                                                                        builder:
                                                                            (isHovered) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {


                                                                              context.router.push(ProductDetailPage(
                                                                                productId: '${cartViewModel.recommendedView?[position].productId}',
                                                                                productdata: [
                                                                                  '${cartViewModel.cartItemCount}',
                                                                                  '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.size?.name}',
                                                                                  '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.color?.name}',
                                                                                  '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.style?.name}',
                                                                                  '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.unitCount?.name}',
                                                                                  '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.materialType?.name}',
                                                                                ],
                                                                              ));
                                                                            },
                                                                            child:
                                                                                Card(
                                                                                  elevation:isHovered == true?10: 0.1,
                                                                                  margin: EdgeInsets.all(10),
                                                                                  child: Container(
                                                                              //height: ResponsiveWidget.isMediumScreen(context) ? 140 :SizeConfig.screenWidth * 0.23,
                                                                              width: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.18,
                                                                              decoration: BoxDecoration(
                                                                                  color: Theme.of(context).cardColor,
                                                                              ),
                                                                              child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    CachedNetworkImage(
                                                                                        imageUrl: '${cartViewModel.recommendedView?[position].productDetails?.productImages?[0]}',
                                                                                        fit: BoxFit.fill,
                                                                                        height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.228,
                                                                                        imageBuilder: (context, imageProvider) => Container(
                                                                                              decoration: BoxDecoration(
                                                                                                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                                                                              ),
                                                                                            ),
                                                                                        placeholder: (context, url) => Container(height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.23, child: Center(child: CircularProgressIndicator(color: Colors.grey)))),
                                                                                    SizedBox(height: SizeConfig.screenWidth * 0.001),
                                                                                    AppBoldFont(maxLines: 1, context, msg: " ${getRecommendedViewTitle(position, cartViewModel)}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 18),
                                                                                    SizedBox(height: SizeConfig.screenWidth * 0.002),
                                                                                    AppBoldFont(maxLines: 1, context, msg: " ₹" + "${cartViewModel.recommendedView?[position].productDetails?.productDiscountPrice}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 18),
                                                                                    SizedBox(height: SizeConfig.screenWidth * 0.005),
                                                                                  ],
                                                                              ),
                                                                            ),
                                                                                ),
                                                                          );
                                                                        },
                                                                        hovered: Matrix4
                                                                            .identity()
                                                                          ..translate(
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      ));
                                                                })),
                                                        Positioned(
                                                            top: SizeConfig
                                                                    .screenWidth *
                                                                0.10,
                                                            right: 2,
                                                            child: InkWell(
                                                                child:
                                                                    Container(
                                                                  width: 40,
                                                                  height: 35,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor
                                                                      .withOpacity(
                                                                          0.8),
                                                                  child: Icon(Icons
                                                                      .arrow_forward_ios_rounded),
                                                                ),
                                                                onTap: () {
                                                                  _nextCounter();
                                                                  setState(
                                                                      () {});
                                                                })),
                                                        Positioned(
                                                            top: SizeConfig
                                                                    .screenWidth *
                                                                0.10,
                                                            child: InkWell(
                                                                child:
                                                                    Container(
                                                                  width: 40,
                                                                  height: 35,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor
                                                                      .withOpacity(
                                                                          0.8),
                                                                  child: Icon(Icons
                                                                      .arrow_back_ios_new_outlined),
                                                                ),
                                                                onTap: () {
                                                                  _prev();
                                                                  setState(() {
                                                                    counter = 4;
                                                                  });
                                                                }))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: 24),

                                              //recent view images .......

                                              (cartViewModel.recentView
                                                              ?.length ??
                                                          0) >
                                                      0
                                                  ? Container(
                                                      margin: EdgeInsets.zero,
                                                      color: Theme.of(context)
                                                          .cardColor
                                                          .withOpacity(0.6),
                                                      height: ResponsiveWidget
                                                              .isMediumScreen(
                                                                  context)
                                                          ? 185
                                                          : SizeConfig
                                                                  .screenWidth *
                                                              0.31,
                                                      padding: EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .screenWidth *
                                                              0.11,
                                                          right: SizeConfig
                                                                  .screenWidth *
                                                              0.11,
                                                          top: 20),
                                                      child: Stack(
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.only(
                                                                    left: SizeConfig
                                                                        .screenWidth *
                                                                        0.01,
                                                                    right: SizeConfig
                                                                        .screenWidth *
                                                                        0.01),
                                                                child: AppBoldFont(context,
                                                                    msg: StringConstant
                                                                        .RecentView,
                                                                    fontSize: ResponsiveWidget
                                                                            .isMediumScreen(
                                                                                context)
                                                                        ? 14
                                                                        : 18),
                                                              ),
                                                              SizedBox(
                                                                  height: SizeConfig
                                                                          .screenWidth *
                                                                      0.002),
                                                              Container(
                                                                  height: ResponsiveWidget
                                                                          .isMediumScreen(
                                                                              context)
                                                                      ? 200
                                                                      : SizeConfig
                                                                              .screenWidth *
                                                                          0.26,
                                                                  width: SizeConfig
                                                                      .screenWidth,
                                                                  padding: EdgeInsets.only(
                                                                      left: SizeConfig
                                                                          .screenWidth *
                                                                          0.01,
                                                                      right: SizeConfig
                                                                          .screenWidth *
                                                                          0.01),
                                                                  child: ListView
                                                                      .builder(
                                                                          reverse:
                                                                              false,
                                                                          controller: controller1,
                                                                          padding:
                                                                              EdgeInsets
                                                                                  .zero,
                                                                          scrollDirection:
                                                                              Axis
                                                                                  .horizontal,
                                                                          itemCount: cartViewModel
                                                                              .recentView
                                                                              ?.length,
                                                                          itemBuilder:
                                                                              (context,
                                                                                  position) {
                                                                            return

                                                                              AutoScrollTag(
                                                                                key: ValueKey(
                                                                                position),
                                                                                controller: controller1,
                                                                                index:
                                                                                position,
                                                                                child:   OnHover(
                                                                              builder:
                                                                                  (isHovered) {
                                                                                return GestureDetector(
                                                                                  onTap: () {
                                                                                    context.router.push(ProductDetailPage(
                                                                                      productId: '${cartViewModel.recentView?[position].productId}',
                                                                                      productdata: [
                                                                                        '${cartViewModel.cartItemCount}',
                                                                                        '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.size?.name}',
                                                                                        '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.color?.name}',
                                                                                        '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.style?.name}',
                                                                                        '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.unitCount?.name}',
                                                                                        '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.materialType?.name}',
                                                                                      ],
                                                                                    ));
                                                                                  },
                                                                                  child: Card(
                                                                                    elevation:isHovered == true?10: 0.1,
                                                                                    margin: EdgeInsets.all(10),
                                                                                    child: Container(
                                                                                      width: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.18,
                                                                                      // height: ResponsiveWidget.isMediumScreen(context) ? 185 : SizeConfig.screenWidth / 2.65,
                                                                                      decoration: BoxDecoration(
                                                                                              color: Theme.of(context).cardColor,
                                                                                            ),
                                                                                      //margin: EdgeInsets.only(right: 16),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          CachedNetworkImage(
                                                                                              imageUrl: '${cartViewModel.recentView?[position].productDetails?.productImages?[0]}',
                                                                                              fit: BoxFit.fill,
                                                                                              height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.228,
                                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                                                                                    ),
                                                                                                  ),
                                                                                              placeholder: (context, url) => Container(height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenHeight / 2.1, child: Center(child: CircularProgressIndicator(color: Colors.grey)))),
                                                                                          SizedBox(height: 2),
                                                                                          AppBoldFont(context, msg: " ${getRecentViewTitle(position, cartViewModel)}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 18, maxLines: 1),
                                                                                          // SizedBox(height: 10)
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              hovered: Matrix4
                                                                                  .identity()
                                                                                ..translate(
                                                                                    0,
                                                                                    0,
                                                                                    0),
                                                                                ) );
                                                                          }))
                                                            ],
                                                          ),
                                                          Positioned(
                                                              top: SizeConfig
                                                                  .screenWidth *
                                                                  0.10,
                                                              right: 2,
                                                              child: InkWell(
                                                                  child:
                                                                  Container(
                                                                    width: 40,
                                                                    height: 35,
                                                                    color: Theme.of(
                                                                        context)
                                                                        .cardColor
                                                                        .withOpacity(
                                                                        0.8),
                                                                    child: Icon(Icons
                                                                        .arrow_forward_ios_rounded),
                                                                  ),
                                                                  onTap: () {
                                                                    _nextCounter1();
                                                                    setState(
                                                                            () {});
                                                                  })),
                                                          Positioned(
                                                              top: SizeConfig
                                                                  .screenWidth *
                                                                  0.10,
                                                              child: InkWell(
                                                                  child:
                                                                  Container(
                                                                    width: 40,
                                                                    height: 35,
                                                                    color: Theme.of(
                                                                        context)
                                                                        .cardColor
                                                                        .withOpacity(
                                                                        0.8),
                                                                    child: Icon(Icons
                                                                        .arrow_back_ios_new_outlined),
                                                                  ),
                                                                  onTap: () {
                                                                    _prev1();
                                                                    setState(() {
                                                                      counter = 4;
                                                                    });
                                                                  }))
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),

                                              SizedBox(height: 24),
                                              // what we offer.....

                                              Container(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        SizeConfig.screenWidth *
                                                            0.12,
                                                    right:
                                                        SizeConfig.screenWidth *
                                                            0.12,),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppBoldFont(context,
                                                        msg: StringConstant
                                                            .WhatWeoffer,
                                                        fontSize: ResponsiveWidget
                                                                .isMediumScreen(
                                                                    context)
                                                            ? 14
                                                            : 18),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            whatWeOfferWidget(
                                                                AssetsConstants
                                                                    .icSupport,
                                                                StringConstant
                                                                    .offerOnTimeDelivery,
                                                                StringConstant
                                                                    .offerContent),
                                                            whatWeOfferWidget(
                                                                AssetsConstants
                                                                    .icCreditCard,
                                                                StringConstant
                                                                    .offerSecurePayment,
                                                                StringConstant
                                                                    .offerContent),
                                                            whatWeOfferWidget(
                                                                AssetsConstants
                                                                    .icTimer,
                                                                StringConstant
                                                                    .offerSupport,
                                                                StringConstant
                                                                    .offerContent),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: 24),
                                              Image.asset(AssetsConstants.icbanner,width: SizeConfig.screenWidth,height: SizeConfig.screenWidth*0.25,fit: BoxFit.fill,),
                                              SizedBox(height: 24),
                                              Center(
                                                child: Container(
                                             width: SizeConfig.screenWidth,
                                                  margin: EdgeInsets.zero,
                                                  color: Theme.of(context)
                                                      .cardColor
                                                      .withOpacity(0.6),
                                                  padding: EdgeInsets.only(
                                                      left:
                                                      SizeConfig.screenWidth *
                                                          0.12,
                                                      right:
                                                      SizeConfig.screenWidth *
                                                          0.12,
                                                      top: 20,bottom: 20),
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    physics:
                                                    BouncingScrollPhysics(),
                                                    gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      childAspectRatio: 0.65,
                                                    ),
                                                    itemCount:images.length,
                                                    itemBuilder: (context, index) {

                                                      return GestureDetector(
                                                        onTap: (){
                                                          context.router
                                                              .push(
                                                                  ProductListGallery());
                                                        },
                                                        child:  OnHover(
                        builder:
                        (isHovered) {
                                                        
                                       return        Card(

                                         elevation:isHovered==true?20: 0,
                                           margin: EdgeInsets.only(right: 16,bottom: 16),
                                           child: Image.asset(images[index],fit: BoxFit.fill,));},  hovered: Matrix4
                                                            .identity()
                                                          ..translate(
                                                              0,
                                                              0,
                                                              0),
                                                        ) );
                                                      
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 24),
                                              getLatestUpdate(),

                                              SizedBox(height: 24),

                                              ResponsiveWidget.isMediumScreen(
                                                      context)
                                                  ? footerMobile(context)
                                                  : footerDesktop(),
                                            ],
                                          ),
                                        ),
                                        isLogins == true
                                            ? Positioned(
                                                top: ResponsiveWidget
                                                        .isMediumScreen(context)
                                                    ? 45
                                                    : 80,
                                                right: ResponsiveWidget
                                                        .isMediumScreen(context)
                                                    ? 20
                                                    : 35,
                                                child: profile(context,
                                                    setState, profilemodel))
                                            : Container(),
                                        isSearch == true
                                            ? Positioned(
                                                top: ResponsiveWidget
                                                        .isMediumScreen(context)
                                                    ? 0
                                                    : SizeConfig.screenWidth *
                                                        0.041,
                                                right: ResponsiveWidget
                                                        .isMediumScreen(context)
                                                    ? 0
                                                    : SizeConfig.screenWidth *
                                                        0.15,
                                                child: searchList(
                                                    context,
                                                    viewmodel,
                                                    scrollController,
                                                    homeViewModel,
                                                    searchController!,
                                                    cartViewModel
                                                        .cartItemCount))
                                            : Container()
                                      ],
                                    ))));
                  }));
            }));
  }

  Future _nextCounter() async {
    setState(() => counter = (counter + 1));
    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.end);
    controller.highlight(counter);
  }

  Future _prev() async {
    setState(() {
      counter = 0;
    });
    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(counter);
  }
  Future _nextCounter1() async {
    setState(() => counter1 = (counter1 + 1));
    await controller1.scrollToIndex(counter1,
        preferPosition: AutoScrollPosition.end);
    controller1.highlight(counter1);
  }

  Future _prev1() async {
    setState(() {
      counter1 = 0;
    });
    await controller1.scrollToIndex(counter1,
        preferPosition: AutoScrollPosition.begin);
    controller1.highlight(counter1);
  }

  String? getRecommendedViewTitle(int position, CartViewModel cartview) {
    if ((cartview.recommendedView?[position].productDetails?.productVariantTitle
                ?.length ??
            0) >
        18) {
      return cartview
          .recommendedView?[position].productDetails?.productVariantTitle
          ?.replaceRange(
              18,
              cartview.recommendedView?[position].productDetails
                  ?.productVariantTitle?.length,
              '...');
    } else {
      return cartview
              .recommendedView?[position].productDetails?.productVariantTitle ??
          "";
    }
  }

  String? getRecentViewTitle(int position, CartViewModel cartview) {
    if ((cartview.recentView?[position].productDetails?.productVariantTitle
                ?.length ??
            0) >
        18) {
      return cartview.recentView?[position].productDetails?.productVariantTitle
          ?.replaceRange(
              18,
              cartview.recentView?[position].productDetails?.productVariantTitle
                  ?.length,
              '...');
    } else {
      return cartview
              .recentView?[position].productDetails?.productVariantTitle ??
          "";
    }
  }

  Widget whatWeOfferWidget(String img, String heading, String msg) {
    return Container(
      padding:
          EdgeInsets.all(ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
      margin: EdgeInsets.only(
          right: ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
      height: ResponsiveWidget.isMediumScreen(context) ? 150 : 250,
      width: ResponsiveWidget.isMediumScreen(context) ? 250 : 397,
      color: Theme.of(context).cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            img,
            width: ResponsiveWidget.isMediumScreen(context) ? 30 : 72,
            height: ResponsiveWidget.isMediumScreen(context) ? 30 : 72,
          ),
          SizedBox(
            height: ResponsiveWidget.isMediumScreen(context) ? 10 : 20,
          ),
          AppBoldFont(context,
              msg: heading,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 16),
          SizedBox(
            height: ResponsiveWidget.isMediumScreen(context) ? 7 : 15,
          ),
          AppRegularFont(context,
              msg: msg,
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 16),
        ],
      ),
    );
  }

  Widget getLatestUpdate() {
    return Stack(
      children: [
        Image.asset(
          AssetsConstants.icNewUpdate,
          height: ResponsiveWidget.isMediumScreen(context) ? 150 : 300,
          width: SizeConfig.screenWidth,
          fit: BoxFit.fill,
        ),
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                top: ResponsiveWidget.isMediumScreen(context) ? 70 : 120),
            child: AppBoldFont(context,
                msg: StringConstant.getLatestupdate,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveWidget.isMediumScreen(context) ? 18 : 30,
                color: Colors.white,
                textAlign: TextAlign.center)),
      ],
    );
  }
}
