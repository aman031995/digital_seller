import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/WebScreen/effect/OnHover.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
import 'package:TychoStream/view/restaurant/food_deatil.dart';
import 'package:TychoStream/view/widgets/NotificationScreen.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/footerDesktop.dart';
import 'package:TychoStream/view/widgets/getAppBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/notification_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/view/widgets/CommonCarousel.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import '../../AppRouter.gr.dart';


@RoutePage()
class HomePageRestaurant extends StatefulWidget {
  const HomePageRestaurant({Key? key}) : super(key: key);

  @override
  State<HomePageRestaurant> createState() => _HomePageRestaurantState();
}

class _HomePageRestaurantState extends State<HomePageRestaurant> {
  HomeViewModel homeViewModel = HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  ProfileViewModel profileViewModel = ProfileViewModel();
  String? checkInternet;
  CartViewModel cartViewModel = CartViewModel();
  TextEditingController searchController = TextEditingController();
  AutoScrollController controller1 = AutoScrollController();
  AutoScrollController controller = AutoScrollController();
  AutoScrollController controller2 = AutoScrollController();

  TextEditingController emailController = TextEditingController();
  NotificationViewModel notificationViewModel = NotificationViewModel();
  ScrollController _scrollController = ScrollController();
  int counter1 = 4;
  int counter = 4;
  int counter2=6;
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
    controller1 = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
    controller2 = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
    User();
    homeViewModel.getAppConfig(context);
    cartViewModel.getCartCount(context);
    cartViewModel.getProductCategoryList(context,1);
    cartViewModel.getRecommendedViewData(context);
    cartViewModel.getOfferDiscount(context);
    notificationViewModel.getNotificationCountText(context);
    super.initState();
  }

  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    GlobalVariable.names = sharedPreferences.get('name').toString();
    if (sharedPreferences.get('token') != null) {
      cartViewModel.getRecentView(context);
      profileViewModel.getProfileDetails(context);
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
            child: Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
              return ChangeNotifierProvider.value(
                  value: homeViewModel,
                  child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
                   return ChangeNotifierProvider.value(
                        value: notificationViewModel,
                        child: Consumer<NotificationViewModel>(
                            builder: (context, model, _) {  return GestureDetector(
                        onTap: () {
                          closeAppbarProperty();

                        },
                        child: Scaffold(
                            extendBodyBehindAppBar:false,
                            appBar: ResponsiveWidget.isMediumScreen(context)
                                ? homePageTopBar(context, _scaffoldKey,
                                    cartViewModel.cartItemCount,
                              viewmodel,
                              profilemodel,notificationViewModel)
                                : getAppBar(
                                    context,
                                    model,
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
                                      closeAppbarProperty();

                                      context.router.push(RestaurantFavouriteListPage());
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
                                      closeAppbarProperty();
                                      context.router.push(CartDetail(
                                          itemCount:
                                              '${cartViewModel.cartItemCount}'));
                                    }
                                  }),
                            body: Scaffold(
                                    extendBodyBehindAppBar: true,
                                    key: _scaffoldKey,
                                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                    drawer: ResponsiveWidget.isMediumScreen(context) ? AppMenu() : SizedBox(),
                                    body: Stack(
                                      children: [
                                        SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CommonCarousel(),
                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),
                                              ///category product list............
                                              (cartViewModel.categoryListModel?.length ?? 0) > 0 ?
                                              Container(
                                                margin: EdgeInsets.zero,
                                                color: Theme.of(context).cardColor.withOpacity(0.5),
                                                padding: EdgeInsets.only(
                                                    left: ResponsiveWidget.isMediumScreen(context)
                                                        ? 16
                                                        : SizeConfig.screenWidth * 0.12,
                                                    right: ResponsiveWidget.isMediumScreen(context)
                                                        ? 4
                                                        : SizeConfig.screenWidth * 0.12,
                                                    top: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context)
                                                        ? 4:8 : 20),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                padding: EdgeInsets.only(
                                                left: ResponsiveWidget.isMediumScreen(context)
                                                    ? 16
                                                    : SizeConfig.screenWidth * 0.018,
                                                right: ResponsiveWidget.isMediumScreen(context)
                                                    ? 4
                                                    : SizeConfig.screenWidth * 0.018),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment.topLeft,
                                                            child: AppBoldFont(context,
                                                                textAlign: TextAlign.left,
                                                                msg: StringConstant.categoryList,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 18),
                                                          ),
                                                          Row(
                                                            children: [
                                                               InkWell(
                                                                  child: Container(
                                                                    width: 40,
                                                                    height: 35,
                                                                    color: Theme.of(context).cardColor,
                                                                    child: Icon(
                                                                        Icons.arrow_back_ios_new_outlined,
                                                                        size: 25, color:cartViewModel.categoryListModel!.length <6? Theme.of(context).canvasColor.withOpacity(0.4) :counter2 <= 6 ? Theme.of(context).canvasColor.withOpacity(0.4):Theme.of(context).canvasColor),
                                                                  ),
                                                                  onTap: () {
                                                                    if(counter2>6){
                                                                      _prev2();
                                                                    }

                                                                    setState(() {});
                                                                  }),
                                                              SizedBox(width: 5),
                                                              InkWell(child: Container(
                                                                width: 40,
                                                                height: 35,
                                                                color: Theme.of(context).cardColor,
                                                                child: Icon(
                                                                    Icons.arrow_forward_ios_rounded,
                                                                    size:  25,
                                                                    color:cartViewModel.categoryListModel!.length <6? Theme.of(context).canvasColor.withOpacity(0.4) : counter2 == cartViewModel.categoryListModel?.length? Theme.of(context).canvasColor.withOpacity(0.4):Theme.of(context).canvasColor),
                                                              ),
                                                                  onTap: () {
                                                                if(counter2 < cartViewModel.categoryListModel!.length)
                                                                    _nextCounter2();
                                                                    setState(() {});
                                                                  }),

                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height:15),
                                                    Container(
                                                        height: ResponsiveWidget.isMediumScreen(context)
                                                            ?ResponsiveWidget.isSmallScreen(context)
                                                            ?  150:SizeConfig.screenHeight*0.25
                                                            : SizeConfig.screenWidth * 0.18,
                                                        child: ListView.builder(
                                                            physics: BouncingScrollPhysics(),
                                                            reverse: false,
                                                            padding: EdgeInsets.zero,
                                                            shrinkWrap: true,

                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: cartViewModel.categoryListModel?.length,
                                                            itemBuilder: (context, position) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  closeAppbarProperty();
                                                                   context.router.push(RestaurantSubcategoryProductList(
                                                                      SubcategoryProductName: cartViewModel
                                                                          .categoryListModel?[position].categoryId));

                                                                },
                                                                child: Container(
                                                                  padding: EdgeInsets.all(ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context)
                                                                      ?4:8:10),
                                                                  child: Column(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundColor: Theme.of(context).cardColor,
                                                                        radius: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context) ? 50:SizeConfig.screenHeight*0.085
                                                                            : ResponsiveWidget.isSmallScreen(context) ?SizeConfig.screenWidth * 0.080:SizeConfig.screenWidth * 0.055,
                                                                        child: CachedNetworkImage(
                                                                            imageUrl: cartViewModel.categoryListModel?[position].imageUrl ?? "",
                                                                            fit: BoxFit.fill,
                                                                            imageBuilder: (context, imageProvider) =>
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                    image: DecorationImage(
                                                                                      image: imageProvider,
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                            placeholder: (context, url) => Center(
                                                                                child: CircularProgressIndicator(
                                                                                    color: Colors.grey,strokeWidth: 2))),
                                                                      ),
                                                                      SizedBox(
                                                                          height: ResponsiveWidget.isMediumScreen(context)
                                                                              ? 2
                                                                              : SizeConfig.screenHeight * 0.01),
                                                                      Container(

                                                                        // color: Theme.of(context)
                                                                        //     .primaryColor,
                                                                        alignment: Alignment.center,
                                                                        padding: EdgeInsets.only(top: 8, bottom: 8),
                                                                        child: AppBoldFont(
                                                                            maxLines: 1,
                                                                            context,
                                                                            msg:ResponsiveWidget.isMediumScreen(context) ?getCategoryViewTitleMobile(position, cartViewModel) :getCategoryViewTitle(position,cartViewModel) ?? "",
                                                                            fontSize:
                                                                            ResponsiveWidget.isMediumScreen(context)
                                                                                ? 14
                                                                                : 18,
                                                                            color: Theme.of(context).canvasColor),
                                                                      ),
                                                                      SizedBox(
                                                                          height: ResponsiveWidget.isMediumScreen(context)
                                                                              ? 2
                                                                              : SizeConfig.screenHeight * 0.01),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            })),
                                                  ],
                                                ),
                                              ):SizedBox(),

                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),
                                              //Recommend product .................
                                              (cartViewModel.recommendedView?.length ?? 0) > 0
                                                  ?   Container(
                                                height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context)
                                                    ?275 :SizeConfig.screenHeight/3.9 : SizeConfig.screenWidth * 0.28,
                                                margin: EdgeInsets.zero,
                                                padding: EdgeInsets.only(
                                                    left: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.12,
                                                    right: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.12,
                                                    top: ResponsiveWidget.isMediumScreen(context) ? 8 : 20),
                                                color: Theme.of(context).cardColor.withOpacity(0.5),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: ResponsiveWidget.isMediumScreen(context)
                                                              ? 16
                                                              : SizeConfig.screenWidth * 0.01,
                                                          right: ResponsiveWidget.isMediumScreen(context)
                                                              ? 4
                                                              : SizeConfig.screenWidth * 0.01),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                        children: [
                                                          AppBoldFont(
                                                              context,textAlign: TextAlign.left,
                                                              msg: StringConstant.Recommended,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: ResponsiveWidget.isMediumScreen(context)? 14 : 18),
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                  child: Container(
                                                                    width: 40,
                                                                    height: 35,
                                                                    color: Theme.of(context).cardColor,
                                                                    child: Icon(
                                                                        Icons.arrow_back_ios_new_outlined,
                                                                        size: 25, color:cartViewModel.recommendedView!.length <4? Theme.of(context).canvasColor.withOpacity(0.4) :counter <= 4 ? Theme.of(context).canvasColor.withOpacity(0.4):Theme.of(context).canvasColor),
                                                                  ),
                                                                  onTap: () {
                                                                    if(counter>4){
                                                                      _prev();
                                                                    }

                                                                    setState(() {});
                                                                  }),
                                                              SizedBox(width: 5),
                                                              InkWell(child: Container(
                                                                width: 40,
                                                                height: 35,
                                                                color: Theme.of(context).cardColor,
                                                                child: Icon(
                                                                    Icons.arrow_forward_ios_rounded,
                                                                    size:  25,
                                                                    color: cartViewModel.recommendedView!.length<4? Theme.of(context).canvasColor.withOpacity(0.4) : counter ==cartViewModel.recommendedView!.length?Theme.of(context).canvasColor.withOpacity(0.4) :Theme.of(context).canvasColor),
                                                              ),
                                                                  onTap: () {
                                                                    if(counter < cartViewModel.recommendedView!.length)
                                                                    {
                                                                      _nextCounter();
                                                                    }

                                                                    setState(() {});
                                                                  }),

                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: SizeConfig.screenWidth * 0.01),
                                                    Container(
                                                        padding: EdgeInsets.only(left: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.015,
                                                            right: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.02),
                                                        height: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context)
                                                            ?235 :SizeConfig.screenHeight/4.5: SizeConfig.screenWidth * 0.218,
                                                        child: ListView.builder(
                                                            reverse: false,
                                                            controller: controller,
                                                            padding: EdgeInsets.all(4),
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: cartViewModel.recommendedView?.length,
                                                            itemBuilder: (context, position) {
                                                              return AutoScrollTag(
                                                                  key: ValueKey(position),
                                                                  controller: controller,
                                                                  index: position,
                                                                  child: OnHover(
                                                                    builder: (isHovered) {
                                                                      return InkWell(
                                                                        onTap: () {
                                                                          closeAppbarProperty();
                                                                            if (cartViewModel.recommendedView?[position].productDetails?.isAvailable == true) {
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
                                                                                      items:cartViewModel.recommendedView?[position] ,
                                                                                          callback: (v){
                                                                                            if(v==true){
                                                                                              setState(() {
                                                                                                cartViewModel.getCartCount(context);
                                                                                              });
                                                                                            }
                                                                                          } );
                                                                                    });
                                                                              }
                                                                           //   }
                                                                          // context.router.push(ProductDetailPage(
                                                                          //   productName: '${cartViewModel.recommendedView?[position].productName?.replaceAll(' ', '')}',
                                                                          //   productdata: [
                                                                          //     '${cartViewModel.recommendedView?[position].productId}',
                                                                          //     '${cartViewModel.cartItemCount}',
                                                                          //     '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.size?.name}',
                                                                          //     '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.color?.name}',
                                                                          //     '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.style?.name}',
                                                                          //     '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.unitCount?.name}',
                                                                          //     '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.materialType?.name}',

                                                                          //   ],
                                                                          // ));
                                                                        },
                                                                        child: Card(
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                                                                          ),
                                                                          elevation: isHovered == true ? 10 : 0.0,
                                                                          child: Container(

                                                                            width: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context)
                                                                                ?140:SizeConfig.screenHeight/6 : SizeConfig.screenWidth * 0.18,
                                                                            decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                                                            borderRadius: BorderRadius.circular(20)),
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                CachedNetworkImage(
                                                                                    imageUrl: '${cartViewModel.recommendedView?[position].productDetails?.productImages?[0]}',
                                                                                    fit: BoxFit.cover,
                                                                                    height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context)
                                                                                        ?140: SizeConfig.screenHeight/6.5 : SizeConfig.screenWidth * 0.12,
                                                                                    imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),image: DecorationImage(image: imageProvider, fit: BoxFit.cover))),
                                                                                    placeholder: (context, url) => Container(height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.23, child: Center(child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2)))),
                                                                                SizedBox(height: 8),
                                                                                AppBoldFont(maxLines: 1, context, msg: " "+"${getRecommendedViewTitle(position, cartViewModel)}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 18),
                                                                                SizedBox(height: 2),
                                                                                AppBoldFont(maxLines: 1, context, msg: "₹" + "${cartViewModel.recommendedView?[position].productDetails?.productDiscountPrice}", fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 18),
                                                                                SizedBox(height:10),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    // context.router.push(ProductDetailPage(
                                                                                    //   productName: '${cartViewModel.recommendedView?[position].productName?.replaceAll(' ', '')}',
                                                                                    //   productdata: [
                                                                                    //     '${cartViewModel.recommendedView?[position].productId}',
                                                                                    //     '${cartViewModel.cartItemCount}',
                                                                                    //     '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.size?.name}',
                                                                                    //     '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.color?.name}',
                                                                                    //     '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.style?.name}',
                                                                                    //     '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.unitCount?.name}',
                                                                                    //     '${cartViewModel.recommendedView?[position].productDetails?.defaultVariationSku?.materialType?.name}',
                                                                                    //   ],
                                                                                    // ));
                                                                                  },
                                                                                  child: Container(
                                                                                    width: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenWidth * 0.18,
                                                                                    height: ResponsiveWidget.isMediumScreen(context) ? 30 : SizeConfig.screenWidth * 0.027,
                                                                                    alignment: Alignment.center,
                                                                                    margin: EdgeInsets.only(left: 16,right: 16),
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: Theme.of(context).canvasColor)),
                                                                                    child: AppBoldFont(context, msg: StringConstant.Ordernow, fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.w700),
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
                                                  ],
                                                ),
                                              ):SizedBox(),
                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),
                                              //recent view images .......
                                              (cartViewModel.recentView?.length ?? 0) > 0
                                                  ? Container(margin: EdgeInsets.zero,
                                                      color: Theme.of(context).cardColor.withOpacity(0.6),
                                                      height: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context) ?260: SizeConfig.screenHeight/5  : SizeConfig.screenWidth * 0.22,
                                                      padding: EdgeInsets.only(left: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.12,
                                                          right: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.12, top:ResponsiveWidget.isMediumScreen(context) ? 8 : 20),
                                                      child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(
                                                              left: ResponsiveWidget.isMediumScreen(context)
                                                                  ? 16
                                                                  : SizeConfig.screenWidth * 0.01,
                                                              right: ResponsiveWidget.isMediumScreen(context)
                                                                  ? 4
                                                                  : SizeConfig.screenWidth * 0.01),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                AppBoldFont(
                                                                    context, textAlign: TextAlign.left,
                                                                    msg: StringConstant.RecentView,
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: ResponsiveWidget.isMediumScreen(context) ? 14 : 18),
                                                                Row(
                                                                  children: [
                                                                    InkWell(
                                                                        child: Container(
                                                                          width: 40,
                                                                          height: 35,
                                                                          color: Theme.of(context).cardColor,
                                                                          child: Icon(
                                                                              Icons.arrow_back_ios_new_outlined,
                                                                              size: 25, color:cartViewModel.recentView!.length <4? Theme.of(context).canvasColor.withOpacity(0.4) :counter1 <= 4 ? Theme.of(context).canvasColor.withOpacity(0.4):Theme.of(context).canvasColor),
                                                                        ),
                                                                        onTap: () {
                                                                        if(counter1>4){
                                                                          _prev1();
                                                                        }

                                                                          setState(() {});
                                                                        }),
                                                                    SizedBox(width: 5),
                                                                    InkWell(child: Container(
                                                                      width: 40,
                                                                      height: 35,
                                                                      color: Theme.of(context).cardColor,
                                                                      child: Icon(
                                                                          Icons.arrow_forward_ios_rounded,
                                                                          size:  25,
                                                                          color: cartViewModel.recentView!.length<4? Theme.of(context).canvasColor.withOpacity(0.4) : counter1 ==cartViewModel.recentView!.length?Theme.of(context).canvasColor.withOpacity(0.4) :Theme.of(context).canvasColor),
                                                                    ),
                                                                        onTap: () {
                                                                      if(counter1 < cartViewModel.recentView!.length)
                                                                        {
                                                                          _nextCounter1();
                                                                        }

                                                                          setState(() {});
                                                                        }),

                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: SizeConfig.screenWidth * 0.01),
                                                          Container(
                                                              height: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context) ?200: SizeConfig.screenHeight/6.2
                                                                  : SizeConfig.screenWidth * 0.16,
                                                              width: SizeConfig.screenWidth,
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                                              padding: EdgeInsets.only(
                                                                  left: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.01,
                                                                  right: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.01),
                                                              child: ListView.builder(
                                                                  reverse: false,
                                                                  controller: controller1,
                                                                  padding: EdgeInsets.zero,
                                                                  scrollDirection: Axis.horizontal,
                                                                  itemCount: cartViewModel.recentView?.length,
                                                                  itemBuilder: (context, position) {
                                                                    return AutoScrollTag(
                                                                        key: ValueKey(position),
                                                                        controller: controller1,
                                                                        index: position,
                                                                        child: OnHover(
                                                                          builder: (isHovered) {
                                                                            return InkWell(
                                                                              onTap: () async {
                                                                                closeAppbarProperty();

                                                                                if (cartViewModel.recentView?[position].productDetails?.isAvailable == true) {
                                                                                  showDialog(
                                                                                      context: context,
                                                                                      barrierColor: Theme.of(context)
                                                                                          .canvasColor
                                                                                          .withOpacity(0.6),
                                                                                      builder: (BuildContext context) {
                                                                                        return foodDetail(
                                                                                          items:cartViewModel.recentView?[position] ,
                                                                                            callback: (v){
                                                                                              if(v==true){
                                                                                                setState(() {
                                                                                                  cartViewModel.getCartCount(context);
                                                                                                });
                                                                                              }
                                                                                            } );
                                                                                      });
                                                                                }
                                                                              },
                                                                              child: Card(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                                                                                ),
                                                                                elevation: isHovered == true ? 10 : 0.0,
                                                                                //margin: EdgeInsets.only(right:ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
                                                                                child: Container(
                                                                                  width: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context) ?140: SizeConfig.screenHeight/6.5 : SizeConfig.screenWidth * 0.20,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Theme.of(context).cardColor,
                                                                                    borderRadius: BorderRadius.circular(20)
                                                                                  ),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      CachedNetworkImage(
                                                                                          imageUrl: '${cartViewModel.recentView?[position].productDetails?.productImages?[0]}',
                                                                                          fit: BoxFit.contain,
                                                                                          height: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context) ?140: SizeConfig.screenHeight/7.5 : SizeConfig.screenWidth * 0.12,
                                                                                          imageBuilder: (context, imageProvider) => Container(
                                                                                            decoration: BoxDecoration(
borderRadius: BorderRadius.circular(20),
                                                                                              image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                                                                            ),
                                                                                          ),
                                                                                          placeholder: (context, url) => Container(height: ResponsiveWidget.isMediumScreen(context) ? 140 : SizeConfig.screenHeight / 2.1, child: Center(child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2)))),
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
                                                    )
                                                  : SizedBox(),
                                              (cartViewModel.recentView?.length ?? 0) > 0
                                                  ? SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24):SizedBox(),

                                              // what we offer.....
                                              offerList(context),
                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context)
                                                  ?12:16 : 24),
                                              //Discount product List .......
                                              (cartViewModel.offerDiscountModel?.length ?? 0) > 0 ?  Container(
                                                width: SizeConfig.screenWidth,
                                                color: Theme.of(context).primaryColor.withOpacity(0.5),
                                                margin: EdgeInsets.zero,
                                                height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context)
                                                    ?300:SizeConfig.screenHeight/4: SizeConfig.screenWidth * 0.22,
                                                padding: EdgeInsets.only(
                                                    left: ResponsiveWidget
                                                        .isMediumScreen(
                                                        context)
                                                        ? ResponsiveWidget.isSmallScreen(context)
                                                        ?8:12
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
                                                      child: AppBoldFont(context, msg:StringConstant.discout , fontWeight:
                                                      FontWeight
                                                          .w700,textAlign: TextAlign.left,
                                                          fontSize:
                                                          ResponsiveWidget.isMediumScreen(context)
                                                              ? 16
                                                              : 22),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                        height: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context) ?230: SizeConfig.screenHeight/5  : SizeConfig.screenWidth * 0.18,
                                                        width: SizeConfig
                                                            .screenWidth,


                                                        child: ListView.builder(
                                                            reverse: false,
                                                            shrinkWrap: true,
                                                            padding: EdgeInsets.zero,
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: cartViewModel.offerDiscountModel?.length,
                                                            itemBuilder: (context, position) {
                                                              return InkWell(
                                                                  onTap: () {
                                                                    closeAppbarProperty();

                                                                    context.router.push(ProductListGallery(
                                                                        discountdata: ["${cartViewModel.offerDiscountModel?[position].categoryId}","${cartViewModel.offerDiscountModel?[position].discountPercentage}"]
                                                                    ));
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(20)
                                                                    ),
                                                                    margin: EdgeInsets.only(right:ResponsiveWidget.isMediumScreen(context) ? 10 : 20),
                                                                    width: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context)
                                                                        ?140:SizeConfig.screenHeight/5.8 : SizeConfig.screenWidth * 0.18,
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        CachedNetworkImage(

                                                                            height: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context)
                                                                                ?180:SizeConfig.screenHeight/6: SizeConfig.screenWidth * 0.13,
                                                                            imageUrl: '${cartViewModel.offerDiscountModel?[position].images}',
                                                                            fit: BoxFit.fill,
                                                                            imageBuilder: (context, imageProvider) =>
                                                                                Container(
                                                                                  height: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context)
                                                                                      ?180:SizeConfig.screenHeight/6: SizeConfig.screenWidth * 0.13,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    image: DecorationImage(
                                                                                      image: imageProvider,
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                            placeholder: (context, url) => Center(
                                                                                child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2))),
                                                                        SizedBox(height: 8),
                                                                        AppBoldFont(context, msg: "${cartViewModel.offerDiscountModel?[position].title}", color: Theme.of(context).canvasColor,fontSize: ResponsiveWidget.isMediumScreen(context) ? 14:18),
                                                                        SizedBox(height: 4),
                                                                        AppRegularFont(context, msg: "Up To. ${cartViewModel.offerDiscountModel?[position].discountPercentage}% Off", color: GREEN, fontSize: ResponsiveWidget.isMediumScreen(context) ? 14:18)


                                                                      ],
                                                                    ),
                                                                  ));})),
                                                  ],
                                                ),
                                              ):SizedBox(),

                                             // SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),

                                             // Image.asset(AssetsConstants.icbanner, width: SizeConfig.screenWidth, height: SizeConfig.screenWidth * 0.25, fit: BoxFit.fill),

                                            //  SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),
                                                   // product-gallery view .........
                                              //gallery(context,images),

                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),

                                               //emailNotification method ......
                                           //   emailNotificationUpdatePage(context,emailController,authVM),
                                              //footer method.......

                                              ResponsiveWidget.isMediumScreen(context) ? footerMobile(context,homeViewModel) : footerDesktop(),
                                            ],
                                          ),
                                        ),

                                        ResponsiveWidget.isMediumScreen(context)
                                            ? Container()
                                            : GlobalVariable.isLogins == true
                                                ? Positioned(
                                                    top: 1,
                                                    right: 180,
                                                    child: profile(context,
                                                        setState, profilemodel))
                                                : Container(),
                                        ResponsiveWidget.isMediumScreen(context)
                                            ? Container()
                                            : GlobalVariable.isSearch == true
                                                ? Positioned(
                                                    top: 1,
                                                    right:  SizeConfig
                                                                .screenWidth *
                                                            0.20,
                                                    child: searchList(
                                                        context,
                                                        viewmodel,
                                                        scrollController,
                                                        searchController,
                                                        cartViewModel
                                                            .cartItemCount))
                                                : Container(),

                                        ResponsiveWidget.isMediumScreen(context)
                                            ? Container()
                                            : GlobalVariable.isnotification == true
                                            ?    Positioned(
                                            top:  1,
                                            right:  SizeConfig
                                                .screenWidth *
                                                0.20,
                                            child: notification(notificationViewModel,context,_scrollController)):Container()
                                      ],
                                    ))));
                  }));
                  }));
            }));
  }

  Future _nextCounter() async {
    setState(() => counter = (counter + 1));
    await controller.scrollToIndex(counter-1,
        preferPosition: AutoScrollPosition.end);
    controller.highlight(counter);
  }

  Future _prev() async {
    setState(() {
      counter =counter-1;
    });
    await controller.scrollToIndex(counter-4,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(counter);
  }

  Future _nextCounter2() async {
    setState(() => counter2 = (counter2 + 1));
    await controller2.scrollToIndex(counter2-1,
        preferPosition: AutoScrollPosition.end);
    controller2.highlight(counter2);
  }

  Future _prev2() async {
    setState(() {
      counter2 =counter2-1;
    });
    await controller2.scrollToIndex(counter2-6,
        preferPosition: AutoScrollPosition.begin);
    controller2.highlight(counter);
  }

  Future _nextCounter1() async {
    setState(() => counter1 = (counter1 + 1));
    await controller1.scrollToIndex(counter1-1,
        preferPosition: AutoScrollPosition.end);
    controller1.highlight(counter1);
  }

  Future _prev1() async {
    setState(() {
      counter1 =counter1-1;
    });

    await controller1.scrollToIndex(counter1-4,
        preferPosition: AutoScrollPosition.begin);
    controller1.highlight(counter1);
  }
}

