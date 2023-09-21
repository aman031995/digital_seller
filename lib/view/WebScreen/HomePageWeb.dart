import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/view/WebScreen/EmailNotificationPage.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/notification_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/view/WebScreen/CommonCarousel.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import '../../AppRouter.gr.dart';
import '../../main.dart';
import 'getAppBar.dart';
import 'NotificationScreen.dart';

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
  TextEditingController searchController = TextEditingController();
  AutoScrollController controller1 = AutoScrollController();
  AutoScrollController controller = AutoScrollController();
  TextEditingController emailController = TextEditingController();
  NotificationViewModel notificationViewModel = NotificationViewModel();
  ScrollController _scrollController = ScrollController();
  int counter1 = 4;
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
    controller1 = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
    User();
    homeViewModel.getAppConfig(context);
    cartViewModel.getCartCount(context);
    cartViewModel.getProductCategoryLists(context);
    cartViewModel.getRecommendedViewData(context);
    cartViewModel.getOfferDiscount(context);
    notificationViewModel.getNotificationCountText(context);

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
                   return ChangeNotifierProvider.value(
                        value: notificationViewModel,
                        child: Consumer<NotificationViewModel>(
                            builder: (context, model, _) {  return GestureDetector(
                        onTap: () {
                          if (isLogins == true) {
                            isLogins = false;
                          }
                          if (isSearch == true) {
                            isSearch = false;
                          }
                          if (isnotification == true) {
                            isnotification = false;
                          }
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
                                      if (isLogins == true) {
                                        isLogins = false;
                                      }
                                      if (isSearch == true) {
                                        isSearch = false;
                                      }
                                      if (isnotification == true) {
                                        isnotification = false;
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
                                      }
                                      if (isSearch == true) {
                                        isSearch = false;
                                      }
                                      if (isnotification == true) {
                                        isnotification = false;
                                      }
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
                                              (cartViewModel.categoryListModel?.length ?? 0) > 0 ?CategoryList(context, cartViewModel):SizedBox(),
                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),
                                              //Recommend product .................
                                              (cartViewModel.recommendedView?.length ?? 0) > 0
                                                  ?   Container(
                                                height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context)
                                                    ?275 :SizeConfig.screenHeight/3.9 : SizeConfig.screenWidth * 0.37,
                                                margin: EdgeInsets.zero,
                                                padding: EdgeInsets.only(
                                                    left: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.11,
                                                    right: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.11,
                                                    top: ResponsiveWidget.isMediumScreen(context) ? 8 : 20),
                                                color: Theme.of(context).cardColor.withOpacity(0.6),
                                                child: Stack(
                                                  children: [
                                                    recommeded(context,controller,cartViewModel),
                                                    ResponsiveWidget.isMediumScreen(context)
                                                        ?Container():    Positioned(
                                                        top:  SizeConfig.screenWidth * 0.15,
                                                        right: 1,
                                                        child: counter == cartViewModel.recommendedView?.length
                                                            ? Container()
                                                            : InkWell(child: Container(
                                                          width: 40,
                                                          height: 35,
                                                          color: Theme.of(context).cardColor.withOpacity(0.8),
                                                          child: Icon(
                                                              Icons.arrow_forward_ios_rounded,
                                                              size:  25,
                                                              color: Theme.of(context).canvasColor),
                                                        ),
                                                            onTap: () {
                                                              _nextCounter();
                                                              setState(() {});
                                                            })),
                                                    ResponsiveWidget.isMediumScreen(context)
                                                        ?Container():  Positioned(
                                                        top: SizeConfig.screenWidth * 0.15,
                                                        child: counter == 4 ? Container()
                                                            : InkWell(
                                                            child: Container(
                                                              width: 40,
                                                              height: 35,
                                                              color: Theme.of(context).cardColor.withOpacity(0.8),
                                                              child: Icon(
                                                                  Icons.arrow_back_ios_new_outlined,
                                                                  size: 25, color: Theme.of(context).canvasColor),
                                                            ),
                                                            onTap: () {
                                                              _prev();
                                                              setState(() {});
                                                            }))
                                                  ],
                                                ),
                                              ):SizedBox(),

                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),

                                              //recent view images .......
                                              (cartViewModel.recentView?.length ?? 0) > 0
                                                  ? Container(margin: EdgeInsets.zero,
                                                      color: Theme.of(context).cardColor.withOpacity(0.6),
                                                      height: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context) ?260: SizeConfig.screenHeight/5  : SizeConfig.screenWidth * 0.32,
                                                      padding: EdgeInsets.only(left: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.11,
                                                          right: ResponsiveWidget.isMediumScreen(context) ? 8 : SizeConfig.screenWidth * 0.11, top:ResponsiveWidget.isMediumScreen(context) ? 8 : 20),
                                                      child: Stack(
                                                        children: [
                                                          recentView(context,controller1,cartViewModel),
                                                          ResponsiveWidget.isMediumScreen(context)
                                                              ?Container():
                                                          Positioned(
                                                              top:  SizeConfig
                                                                          .screenWidth *
                                                                      0.10,
                                                              right: 0.5,
                                                              child: cartViewModel.recentView!.length>4 ? counter1 == cartViewModel.recentView?.length ? Container() : InkWell(
                                                                      child:
                                                                          Container(
                                                                        width: 40,
                                                                        height:  35,
                                                                        color: Theme.of(context).cardColor.withOpacity(0.8),
                                                                        child: Icon(
                                                                            Icons
                                                                                .arrow_forward_ios_rounded,
                                                                            size:  25, color:
                                                                        Theme.of(context).canvasColor)
                                                                      ),
                                                                      onTap: () {
                                                                        _nextCounter1();
                                                                      }):
                                                              Container()),
                                                          ResponsiveWidget.isMediumScreen(context)
                                                              ?Container():   Positioned(
                                                              top: SizeConfig
                                                                          .screenWidth *
                                                                      0.10,
                                                              child: counter1==4
                                                                  ? Container()
                                                                  : InkWell(
                                                                      child:
                                                                          Container(
                                                                        width: 40,
                                                                        height: 35,
                                                                        color: Theme.of(context)
                                                                            .cardColor
                                                                            .withOpacity(0.8),
                                                                        child: Icon(
                                                                            Icons
                                                                                .arrow_back_ios_new_outlined,
                                                                            size:  25, color:
                                                                        Theme.of(context).canvasColor)
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        _prev1();
                                                                      }))
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),

                                              // what we offer.....
                                              offerList(context),
                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? ResponsiveWidget.isSmallScreen(context)
                                                  ?12:16 : 24),
                                              //Discount product List .......
                                              (cartViewModel.offerDiscountModel?.length ?? 0) > 0 ?   discountView(cartViewModel):SizedBox(),

                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),

                                              Image.asset(AssetsConstants.icbanner, width: SizeConfig.screenWidth, height: SizeConfig.screenWidth * 0.25, fit: BoxFit.fill),

                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),
                                                   // gallery view .........
                                              gallery(context,images),

                                              SizedBox(height: ResponsiveWidget.isMediumScreen(context) ? 12 : 24),

                                               //emailNotification method ......
                                              emailNotificationUpdatePage(context,emailController,authVM),
                                              //footer method.......

                                              ResponsiveWidget.isMediumScreen(context) ? footerMobile(context,homeViewModel) : footerDesktop(),
                                            ],
                                          ),
                                        ),

                                        ResponsiveWidget.isMediumScreen(context)
                                            ? Container()
                                            : isLogins == true
                                                ? Positioned(
                                                    top: 1,
                                                    right: 180,
                                                    child: profile(context,
                                                        setState, profilemodel))
                                                : Container(),
                                        ResponsiveWidget.isMediumScreen(context)
                                            ? Container()
                                            : isSearch == true
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
                                            : isnotification == true
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

