import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/EmailNotificationPage.dart';
import 'package:TychoStream/view/WebScreen/OnHover.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
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
  AutoScrollController controller1 = AutoScrollController();
  TextEditingController emailController = TextEditingController();

  int counter1 = 4;
  late AutoScrollController controller;
  int counter = 4;
  List<String> images = [
    'images/Frame1.webp',
    'images/Frame2.webp',
    'images/Frame3.webp',
    'images/Frame4.webp',
    'images/Frame5.webp',
    'images/Frame6.webp',
    'images/Frame7.webp',
    'images/Frame8.webp'
  ];

  void initState() {
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
    User();
    homeViewModel.getAppConfig(context);
    cartViewModel.getCartCount(context);
    cartViewModel.getProductCategoryLists(context);
    cartViewModel.getRecommendedViewData(context);
    cartViewModel.getOfferDiscount(context);
    super.initState();
  }

  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    names = sharedPreferences.get('name').toString();
    if (sharedPreferences.get('token') != null) {
      cartViewModel.getRecentView(context);
      profileViewModel.getProfileDetails(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);

    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });
    return checkInternet == "Offline"
        ? NOInternetScreen()
        : ChangeNotifierProvider.value(
            value: profileViewModel,
            child: Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
              return ChangeNotifierProvider.value(
                  value: homeViewModel,
                  child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
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
                            extendBodyBehindAppBar:  ResponsiveWidget.isMediumScreen(context)
                                ? false:true,
                            appBar: ResponsiveWidget.isMediumScreen(context)
                                ? homePageTopBar(context, _scaffoldKey,
                                    cartViewModel.cartItemCount,
                              viewmodel,
                              profilemodel,)
                                : getAppBar(
                                    context,
                                    viewmodel,
                                    profilemodel,
                                    cartViewModel.cartItemCount,
                                    1,
                                    searchController, () async {
                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    if (sharedPreferences.get('token') ==
                                        null) {
                                      showDialog(
                                          context: context,
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
                                      context.router.push(FavouriteListPage());
                                    }
                                  }, () async {
                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    if (sharedPreferences.getString('token') ==
                                        null) {
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
                                          itemCount:
                                              '${cartViewModel.cartItemCount}'));
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
                                              SizedBox(
                                                  height: ResponsiveWidget
                                                          .isMediumScreen(
                                                              context)
                                                      ? 12
                                                      : 24),

                                              ///category product list............

                                              (cartViewModel.categoryListModel
                                                  ?.length ??
                                                  0) >
                                                  0
                                                  ?CategoryList(
                                                  context, cartViewModel):SizedBox(),

                                              SizedBox(
                                                  height: ResponsiveWidget
                                                          .isMediumScreen(
                                                              context)
                                                      ? 12
                                                      : 24),

                                              //Recommend product .................

                                              (cartViewModel.recommendedView
                                                  ?.length ??
                                                  0) >
                                                  0
                                                  ?   Container(
                                                height: ResponsiveWidget
                                                        .isMediumScreen(context)
                                                    ? 275
                                                    : SizeConfig.screenWidth *
                                                        0.37,
                                                margin: EdgeInsets.zero,
                                                padding: EdgeInsets.only(
                                                    left: ResponsiveWidget
                                                            .isMediumScreen(
                                                                context)
                                                        ? 8
                                                        : SizeConfig
                                                                .screenWidth *
                                                            0.11,
                                                    right: ResponsiveWidget
                                                            .isMediumScreen(
                                                                context)
                                                        ? 8
                                                        : SizeConfig
                                                                .screenWidth *
                                                            0.11,
                                                    top: ResponsiveWidget
                                                            .isMediumScreen(
                                                                context)
                                                        ? 8
                                                        : 20),
                                                color: Theme.of(context)
                                                    .cardColor
                                                    .withOpacity(0.6),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,

                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: ResponsiveWidget
                                                                  .isMediumScreen(
                                                                      context)
                                                              ? 8
                                                              : SizeConfig
                                                                      .screenWidth *
                                                                  0.01,
                                                          right: SizeConfig
                                                                  .screenWidth *
                                                              0.01),
                                                      child: Container(
                                                        alignment: Alignment.topLeft,
                                                        child: AppBoldFont(
                                                            context,textAlign: TextAlign.left,
                                                            msg: StringConstant
                                                                .Recommended,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: ResponsiveWidget
                                                                    .isMediumScreen(
                                                                        context)
                                                                ? 14
                                                                : 18),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: SizeConfig
                                                                .screenWidth *
                                                            0.01),
                                                    Stack(
                                                      children: [
                                                        Container(
                                                            padding: EdgeInsets.only(
                                                                left: ResponsiveWidget.isMediumScreen(context)
                                                                    ? 8
                                                                    : SizeConfig.screenWidth *
                                                                        0.01,
                                                                right: ResponsiveWidget.isMediumScreen(context)
                                                                    ? 8
                                                                    : SizeConfig.screenWidth *
                                                                        0.01),
                                                            height: ResponsiveWidget.isMediumScreen(context)
                                                                ? 235
                                                                : SizeConfig
                                                                        .screenWidth *
                                                                    0.32,
                                                            child: ListView
                                                                .builder(
                                                                    reverse:
                                                                        false,
                                                                    controller:
                                                                        controller,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.horizontal,
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
                                                                              return InkWell(
                                                                                onTap: () {
                                                                                  if (isLogins == true) {
                                                                                    isLogins = false;
                                                                                    setState(() {});
                                                                                  }
                                                                                  if (isSearch == true) {
                                                                                    isSearch = false;
                                                                                    setState(() {});
                                                                                  }
                                                                                  context.router.push(ProductDetailPage(
                                                                                    productName: '${cartViewModel.recommendedView?[position].productName?.replaceAll(' ', '')}',
                                                                                    productdata: [
                                                                                      '${cartViewModel.recommendedView?[position].productId}',
                                                                                      '${cartViewModel.cartItemCount}',
                                                                                      '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.size?.name}',
                                                                                      '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.color?.name}',
                                                                                      '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.style?.name}',
                                                                                      '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.unitCount?.name}',
                                                                                      '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.materialType?.name}',

                                                                                    ],
                                                                                  ));
                                                                                },
                                                                                child: Card(
                                                                                  elevation: isHovered == true ? 10 : 0.1,
                                                                                  margin: EdgeInsets.only(right:ResponsiveWidget.isMediumScreen(context) ? 10 : 20),

                                                                                  child: Container(
                                                                                    width: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.18,
                                                                                    decoration: BoxDecoration(
                                                                                      color: Theme.of(context).cardColor,
                                                                                    ),
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,

                                                                                      children: [
                                                                                        CachedNetworkImage(
                                                                                            imageUrl: '${cartViewModel.recommendedView?[position].productDetails?.productImages?[0]}',
                                                                                            fit: BoxFit.cover,
                                                                                            height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.228,
                                                                                            imageBuilder: (context, imageProvider) => Container(
                                                                                                  decoration: BoxDecoration(
                                                                                                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                                                  ),
                                                                                                ),
                                                                                            placeholder: (context, url) => Container(height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.23, child: Center(child: CircularProgressIndicator(color: Colors.grey)))),
                                                                                        SizedBox(height: 8),
                                                                                        AppBoldFont(maxLines: 1, context, msg: " "+"${getRecommendedViewTitle(position, cartViewModel)}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 18),
                                                                                        SizedBox(height: 2),
                                                                                        AppBoldFont(maxLines: 1, context, msg: "₹" + "${cartViewModel.recommendedView?[position].productDetails?.productDiscountPrice}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 18),
                                                                                        SizedBox(height:10),
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            context.router.push(ProductDetailPage(
                                                                                              productName: '${cartViewModel.recommendedView?[position].productName?.replaceAll(' ', '')}',
                                                                                              productdata: [
                                                                                                '${cartViewModel.recommendedView?[position].productId}',
                                                                                                '${cartViewModel.cartItemCount}',
                                                                                                '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.size?.name}',
                                                                                                '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.color?.name}',
                                                                                                '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.style?.name}',
                                                                                                '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.unitCount?.name}',
                                                                                                '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.materialType?.name}',
                                                                                              ],
                                                                                            ));
                                                                                          },
                                                                                          child: Container(
                                                                                            width: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.18,
                                                                                            height: ResponsiveWidget.isMediumScreen(context) ? 30 : SizeConfig.screenWidth * 0.027,
                                                                                            alignment: Alignment.center,
                                                                                            margin: EdgeInsets.only(left: 16,right: 16),
                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.5), border: Border.all(width: 1, color: Theme.of(context).canvasColor)),
                                                                                            child: AppBoldFont(context, msg: StringConstant.buynow, fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.w700),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(height: 10),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                            hovered: Matrix4.identity()
                                                                              ..translate(0, 0, 0),
                                                                          ));
                                                                    })),
                                                        ResponsiveWidget.isMediumScreen(context)
                                                            ?Container():    Positioned(
                                                            top: ResponsiveWidget
                                                                    .isMediumScreen(
                                                                        context)
                                                                ? 50
                                                                : SizeConfig
                                                                        .screenWidth *
                                                                    0.10,
                                                            right: 1,
                                                            child: counter ==
                                                                    cartViewModel
                                                                        .recommendedView
                                                                        ?.length
                                                                ? Container()
                                                                : InkWell(
                                                                    child:
                                                                        Container(
                                                                      width: ResponsiveWidget.isMediumScreen(
                                                                              context)
                                                                          ? 25
                                                                          : 40,
                                                                      height: ResponsiveWidget.isMediumScreen(
                                                                              context)
                                                                          ? 20
                                                                          : 35,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.8),
                                                                      child: Icon(
                                                                          Icons
                                                                              .arrow_forward_ios_rounded,
                                                                          size: ResponsiveWidget.isMediumScreen(context)
                                                                              ? 18
                                                                              : 25,
                                                                          color:
                                                                              Theme.of(context).canvasColor),
                                                                    ),
                                                                    onTap: () {
                                                                      _nextCounter();
                                                                      setState(
                                                                          () {
                                                                            // counter++;
                                                                          });
                                                                    })),
                                                        ResponsiveWidget.isMediumScreen(context)
                                                            ?Container():  Positioned(
                                                            top: ResponsiveWidget
                                                                    .isMediumScreen(
                                                                        context)
                                                                ? 50
                                                                : SizeConfig
                                                                        .screenWidth *
                                                                    0.10,
                                                            child: counter == 4
                                                                ? Container()
                                                                : InkWell(
                                                                    child:
                                                                        Container(
                                                                      width: ResponsiveWidget.isMediumScreen(
                                                                              context)
                                                                          ? 25
                                                                          : 40,
                                                                      height: ResponsiveWidget.isMediumScreen(
                                                                              context)
                                                                          ? 20
                                                                          : 35,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.8),
                                                                      child: Icon(
                                                                          Icons
                                                                              .arrow_back_ios_new_outlined,
                                                                          size: ResponsiveWidget.isMediumScreen(context)
                                                                              ? 18
                                                                              : 25, color: Theme.of(context).canvasColor),
                                                                    ),
                                                                    onTap: () {
                                                                      _prev();
                                                                      if(counter != 0)
                                                                      setState(
                                                                          () {
                                                                      });
                                                                    }))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ):SizedBox(),

                                              SizedBox(
                                                  height: ResponsiveWidget
                                                          .isMediumScreen(
                                                              context)
                                                      ? 12
                                                      : 24),

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
                                                          ? 260
                                                          : SizeConfig
                                                                  .screenWidth *
                                                              0.32,
                                                      padding: EdgeInsets.only(
                                                          left: ResponsiveWidget
                                                                  .isMediumScreen(
                                                                      context)
                                                              ? 8
                                                              : SizeConfig
                                                                      .screenWidth *
                                                                  0.11,
                                                          right: ResponsiveWidget
                                                                  .isMediumScreen(
                                                                      context)
                                                              ? 8
                                                              : SizeConfig
                                                                      .screenWidth *
                                                                  0.11,
                                                          top: 20),
                                                      child: Stack(
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,

                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.only(
                                                                    left: ResponsiveWidget.isMediumScreen(
                                                                            context)
                                                                        ? 8
                                                                        : SizeConfig.screenWidth *
                                                                            0.01,
                                                                    right: ResponsiveWidget.isMediumScreen(
                                                                            context)
                                                                        ? 4
                                                                        : SizeConfig.screenWidth *
                                                                            0.01),
                                                                child: Container(
                                                                  alignment: Alignment.topLeft,
                                                                  child: AppBoldFont(
                                                                      context,
                                                                      textAlign: TextAlign.left,
                                                                      msg: StringConstant
                                                                          .RecentView,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          ResponsiveWidget.isMediumScreen(context)
                                                                              ? 14
                                                                              : 18),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: SizeConfig
                                                                      .screenWidth *
                                                                      0.01),
                                                              Container(
                                                                  height: ResponsiveWidget.isMediumScreen(
                                                                          context)
                                                                      ? 200
                                                                      : SizeConfig
                                                                              .screenWidth *
                                                                          0.27,
                                                                  width: SizeConfig
                                                                      .screenWidth,
                                                                  padding: EdgeInsets.only(
                                                                      left: ResponsiveWidget.isMediumScreen(context)
                                                                          ? 8
                                                                          : SizeConfig.screenWidth *
                                                                              0.01,
                                                                      right: ResponsiveWidget.isMediumScreen(
                                                                              context)
                                                                          ? 8
                                                                          : SizeConfig.screenWidth *
                                                                              0.01),
                                                                  child: ListView.builder(
                                                                      reverse: false,
                                                                      controller: controller1,
                                                                      padding: EdgeInsets.zero,
                                                                      scrollDirection: Axis.horizontal,
                                                                      itemCount: cartViewModel.recentView?.length,
                                                                      itemBuilder: (context, position) {
                                                                        return AutoScrollTag(
                                                                            key: ValueKey(
                                                                                position),
                                                                            controller:
                                                                                controller1,
                                                                            index:
                                                                                position,
                                                                            child:
                                                                                OnHover(
                                                                              builder: (isHovered) {
                                                                                return InkWell(
                                                                                  onTap: () {
                                                                                    if (isLogins == true) {
                                                                                      isLogins = false;
                                                                                      setState(() {});
                                                                                    }
                                                                                    if (isSearch == true) {
                                                                                      isSearch = false;
                                                                                      setState(() {});
                                                                                    }
                                                                                    context.router.push(ProductDetailPage(
                                                                                      productName: '${cartViewModel.recentView?[position].productName}',
                                                                                      productdata: [
                                                                                        '${cartViewModel.recentView?[position].productId}',
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
                                                                                    elevation: isHovered == true ? 10 : 0.1,
                                                                                    margin: EdgeInsets.only(right:ResponsiveWidget.isMediumScreen(context) ? 10 : 20),

                                                                                    child: Container(
                                                                                      width: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.18,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Theme.of(context).cardColor,
                                                                                      ),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,

                                                                                        children: [
                                                                                          CachedNetworkImage(
                                                                                              imageUrl: '${cartViewModel.recentView?[position].productDetails?.productImages?[0]}',
                                                                                              fit: BoxFit.fill,
                                                                                              height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.228,
                                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                                                    ),
                                                                                                  ),
                                                                                              placeholder: (context, url) => Container(height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenHeight / 2.1, child: Center(child: CircularProgressIndicator(color: Colors.grey)))),
                                                                                          SizedBox(height: 10),
                                                                                          AppBoldFont(context, msg:" "+ "${getRecentViewTitle(position, cartViewModel)}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 18, maxLines: 1),
                                                                                           SizedBox(height: 10)
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              hovered: Matrix4.identity()..translate(0, 0, 0),
                                                                            ));
                                                                      }))
                                                            ],
                                                          ),
                                                          ResponsiveWidget.isMediumScreen(context)
                                                              ?Container():  Positioned(
                                                              top: ResponsiveWidget
                                                                      .isMediumScreen(
                                                                          context)
                                                                  ? 70
                                                                  : SizeConfig
                                                                          .screenWidth *
                                                                      0.10,
                                                              right: 0.5,
                                                              child: cartViewModel
                                                                  .recentView
                                                                  !.length>4?counter1 ==
                                                                      cartViewModel
                                                                          .recentView
                                                                          ?.length
                                                                  ? Container()
                                                                  : InkWell(
                                                                      child:
                                                                          Container(
                                                                        width: ResponsiveWidget.isMediumScreen(context)
                                                                            ? 25
                                                                            : 40,
                                                                        height: ResponsiveWidget.isMediumScreen(context)
                                                                            ? 20
                                                                            : 35,
                                                                        color: Theme.of(context)
                                                                            .cardColor
                                                                            .withOpacity(0.8),
                                                                        child: Icon(
                                                                            Icons
                                                                                .arrow_forward_ios_rounded,
                                                                            size: ResponsiveWidget.isMediumScreen(context)
                                                                                ? 18
                                                                                : 25, color:
                                                                        Theme.of(context).canvasColor)
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        _nextCounter1();
                                                                        setState(
                                                                            () {});
                                                                      }):Container()),
                                                          ResponsiveWidget.isMediumScreen(context)
                                                              ?Container():   Positioned(
                                                              top: ResponsiveWidget
                                                                      .isMediumScreen(
                                                                          context)
                                                                  ? 70
                                                                  : SizeConfig
                                                                          .screenWidth *
                                                                      0.10,
                                                              child: counter1 == 4
                                                                  ? Container()
                                                                  : InkWell(
                                                                      child:
                                                                          Container(
                                                                        width: ResponsiveWidget.isMediumScreen(context)
                                                                            ? 25
                                                                            : 40,
                                                                        height: ResponsiveWidget.isMediumScreen(context)
                                                                            ? 20
                                                                            : 35,
                                                                        color: Theme.of(context)
                                                                            .cardColor
                                                                            .withOpacity(0.8),
                                                                        child: Icon(
                                                                            Icons
                                                                                .arrow_back_ios_new_outlined,
                                                                            size: ResponsiveWidget.isMediumScreen(context)
                                                                                ? 18
                                                                                : 25, color:
                                                                        Theme.of(context).canvasColor)
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        _prev1();
                                                                        if(counter != 0)
                                                                          setState(
                                                                                  () {
                                                                              });
                                                                      }))
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),

                                              SizedBox(
                                                  height: ResponsiveWidget
                                                          .isMediumScreen(
                                                              context)
                                                      ? 12
                                                      : 24),

                                              // what we offer.....

                                              offerList(context),
                                              SizedBox(
                                                  height: ResponsiveWidget
                                                      .isMediumScreen(
                                                      context)
                                                      ? 12
                                                      : 24),
                                              (cartViewModel.offerDiscountModel
                                                  ?.length ??
                                                  0) >
                                                  0
                                                  ?   _discountView(cartViewModel):SizedBox(),

                                              SizedBox(
                                                  height: ResponsiveWidget
                                                          .isMediumScreen(
                                                              context)
                                                      ? 12
                                                      : 24),

                                              Image.asset(
                                                AssetsConstants.icbanner,
                                                width: SizeConfig.screenWidth,
                                                height: SizeConfig.screenWidth *
                                                    0.28,
                                                fit: BoxFit.fill,
                                              ),

                                              SizedBox(
                                                  height: ResponsiveWidget
                                                          .isMediumScreen(
                                                              context)
                                                      ? 12
                                                      : 24),

                                              Center(
                                                child: Container(
                                                  width: SizeConfig.screenWidth,
                                                  margin: EdgeInsets.zero,
                                                  color: Theme.of(context)
                                                      .cardColor
                                                      .withOpacity(0.6),
                                                  padding: EdgeInsets.only(
                                                      left: ResponsiveWidget
                                                              .isMediumScreen(
                                                                  context)
                                                          ? 8
                                                          : SizeConfig
                                                                  .screenWidth *
                                                              0.01,
                                                      right: ResponsiveWidget
                                                              .isMediumScreen(
                                                                  context)
                                                          ? 0
                                                          : SizeConfig
                                                                  .screenWidth *
                                                              0.01,
                                                      top: 20,
                                                      bottom: 20),
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      childAspectRatio: 0.78,
                                                    ),
                                                    itemCount: images.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                          onTap: () {
                                                            if (isLogins ==
                                                                true) {
                                                              isLogins = false;
                                                              setState(() {});
                                                            }
                                                            if (isSearch ==
                                                                true) {
                                                              isSearch = false;
                                                              setState(() {});
                                                            }
                                                            context.router.push(
                                                                ProductListGallery());
                                                          },
                                                          child: OnHover(
                                                            builder:
                                                                (isHovered) {
                                                              return Card(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  elevation:
                                                                      isHovered == true
                                                                          ? 20
                                                                          : 0,
                                                                  margin: EdgeInsets.only(
                                                                      right: ResponsiveWidget.isMediumScreen(
                                                                              context)
                                                                          ? 8
                                                                          : 16,
                                                                      bottom: ResponsiveWidget.isMediumScreen(
                                                                              context)
                                                                          ? 8
                                                                          : 16),
                                                                  child: Image
                                                                      .asset(
                                                                    images[
                                                                        index],
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ));
                                                            },
                                                            hovered: Matrix4
                                                                .identity()
                                                              ..translate(
                                                                  0, 0, 0),
                                                          ));
                                                    },
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                  height: ResponsiveWidget
                                                          .isMediumScreen(
                                                              context)
                                                      ? 12
                                                      : 24),

                                              // getLatestUpdate(context),

                                              SizedBox(
                                                  height: ResponsiveWidget
                                                          .isMediumScreen(
                                                              context)
                                                      ? 12
                                                      : 24),

                                              emailNotificationUpdatePage(
                                                  context,emailController,authVM),

                                              ResponsiveWidget.isMediumScreen(
                                                      context)
                                                  ? footerMobile(context,homeViewModel)
                                                  : footerDesktop(),
                                            ],
                                          ),
                                        ),

                                        ResponsiveWidget.isMediumScreen(context)
                                            ? Container()
                                            : isLogins == true
                                                ? Positioned(
                                                    top: 70,
                                                    right: 180,
                                                    child: profile(context,
                                                        setState, profilemodel))
                                                : Container(),
                                        ResponsiveWidget.isMediumScreen(context)
                                            ? Container()
                                            : isSearch == true
                                                ? Positioned(
                                                    top:  SizeConfig
                                                                .screenWidth *
                                                            0.041,
                                                    right:  SizeConfig
                                                                .screenWidth *
                                                            0.20,
                                                    child: searchList(
                                                        context,
                                                        viewmodel,
                                                        scrollController,
                                                        searchController!,
                                                        cartViewModel
                                                            .cartItemCount))
                                                : Container()
                                      ],
                                    ))));
                  }));
            }));
  }

  _discountView(CartViewModel cartview) {
    return ChangeNotifierProvider.value(value: cartViewModel,
        child: Consumer<CartViewModel>(
          builder: (context, homeVM, _){
            return Container(
              width: SizeConfig.screenWidth,
              color: Theme.of(context).primaryColor.withOpacity(0.5),

              margin: EdgeInsets.zero,
              height: ResponsiveWidget
                  .isMediumScreen(
                  context)
                  ? 300
                  : SizeConfig
                  .screenWidth *
                  0.31,
              padding: EdgeInsets.only(
                  left: ResponsiveWidget
                      .isMediumScreen(
                      context)
                      ? 8
                      : SizeConfig
                      .screenWidth *
                      0.12,
                  right: ResponsiveWidget
                      .isMediumScreen(
                      context)
                      ? 8
                      : SizeConfig
                      .screenWidth *
                      0.11,
                  top: ResponsiveWidget
                      .isMediumScreen(
                      context)
                      ?10: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: AppBoldFont(context, msg: 'Discounts for You', fontWeight:
                    FontWeight
                        .w700,textAlign: TextAlign.left,
                        fontSize:
                        ResponsiveWidget.isMediumScreen(context)
                            ? 16
                            : 22),
                  ),
                  SizedBox(height: 10),
                  Container(
                     height: ResponsiveWidget.isMediumScreen(context) ? 230 : SizeConfig.screenWidth * 0.27,
                      width: SizeConfig
                          .screenWidth,


                      child: ListView.builder(
                        reverse: false,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                          itemCount: cartview.offerDiscountModel?.length,
                        itemBuilder: (context, position) {
                          return OnHover(
                              builder: (isHovered) {
                                return InkWell(
                                    onTap: () {
                                  if (isLogins == true) {
                                    isLogins = false;
                                    setState(() {});
                                  }
                                  if (isSearch == true) {
                                    isSearch = false;
                                    setState(() {});
                                  }
                                  context.router.push(ProductListGallery(
                                    discountdata: ["${cartview.offerDiscountModel?[position].categoryId}","${cartview.offerDiscountModel?[position].discountPercentage}"]
                                  ));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right:ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
                                  width: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.18,
                                  child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            CachedNetworkImage(
                                                height: ResponsiveWidget.isMediumScreen(context) ? 180 : SizeConfig.screenWidth * 0.22,
                                                width: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.22,
                                                imageUrl: '${cartview.offerDiscountModel?[position].images}',
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) => Center(
                                                    child: CircularProgressIndicator(color: Colors.grey))),
                                            SizedBox(height: 8),
                                            AppBoldFont(context, msg: "${cartview.offerDiscountModel?[position].title}", color: Theme.of(context).canvasColor,fontSize: ResponsiveWidget.isMediumScreen(context) ? 14:18),
                                            SizedBox(height: 4),
                                            AppRegularFont(context, msg: "Min. ${cartview.offerDiscountModel?[position].discountPercentage}% Off", color: GREEN, fontSize: ResponsiveWidget.isMediumScreen(context) ? 14:18)


                                          ],
                                        ),
                                ));
                                },hovered: Matrix4.identity()..translate(0, 0, 0),

                          );})),
                ],
              ),
            );
          },
        ));
  }

  Future _nextCounter() async {
    setState(() => counter = (counter + 1));
    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.end);
    controller.highlight(counter);
  }

  Future _prev() async {
    setState(() => counter = (counter - 1));
    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.end);
    controller.highlight(counter);
  }

  Future _nextCounter1() async {
    setState(() => counter1 = (counter1 + 1));
    await controller1.scrollToIndex(counter1,
        preferPosition: AutoScrollPosition.end);
    controller1.highlight(counter1);
  }

  Future _prev1() async {
    setState(() => counter1 = (counter1 - 1));

    await controller1.scrollToIndex(counter1,
        preferPosition: AutoScrollPosition.begin);
    controller1.highlight(counter1);
  }
}
