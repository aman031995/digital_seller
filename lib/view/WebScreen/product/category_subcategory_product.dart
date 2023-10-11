import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/services/session_storage.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
import 'package:TychoStream/view/widgets/NotificationScreen.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/footerDesktop.dart';
import 'package:TychoStream/view/widgets/getAppBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/notification_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../AppRouter.gr.dart';

@RoutePage()
class CategorySubcategoryProduct extends StatefulWidget {
  final String? CategoryName;
  CategorySubcategoryProduct({
    @PathParam('CategoryName') this.CategoryName,
    Key? key,
  }) : super(key: key);
  @override
  State<CategorySubcategoryProduct> createState() => _CategorySubcategoryProductState();
}
class _CategorySubcategoryProductState extends State<CategorySubcategoryProduct> {
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

  void initState() {
    homeViewModel.getAppConfig(context);
    getProduct();
    notificationViewModel.getNotificationCountText(context);cartViewModel.getCartCount(context);
    super.initState();
  }
  getProduct() {
    cartViewModel.getCategorySubcategoryProductList(
        context, widget.CategoryName ?? "");
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
                    return  ChangeNotifierProvider.value(
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
                                    if (sharedPreferences.getString('token') ==
                                        null) {
                                      showDialog(
                                          context: context,
                                          barrierColor: Theme.of(context)
                                              .canvasColor
                                              .withOpacity(0.6),
                                          builder: (BuildContext context) {
                                            return LoginUp(product: true);});
                                    } else {
                                      closeAppbarProperty();
                                      context.router.push(FavouriteListPage());
                                    }
                                  }, () async {
                                    SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                    if (sharedPreferences.getString('token') ==
                                        null) {
                                      showDialog(
                                          context: context,
                                          barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
                                          builder: (BuildContext context) {
                                            return LoginUp(product: true);});
                                    } else {
                                      closeAppbarProperty();
                                      context.router.push(CartDetail(
                                          itemCount:
                                          '${cartViewModel.cartItemCount}'));}
                                  }),
                                  body: Scaffold(
                                      extendBodyBehindAppBar: true,
                                      key: _scaffoldKey,
                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                      drawer: ResponsiveWidget.isMediumScreen(context) ? AppMenu() : SizedBox(),
                                      body:viewmodel.CategoryProduct!=null
                                          ?  Stack(
                                          children: [
                                            SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 20),
                                                    Container(
                                                        height: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context) ? 150:200 : SizeConfig.screenWidth * 0.16,
                                                        width: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context) ?SizeConfig.screenWidth/1.08 :SizeConfig.screenWidth/1.03:SizeConfig.screenWidth/1.38,
                                                        margin: EdgeInsets.zero,
                                                        padding: EdgeInsets.zero,
                                                        child: ListView.builder(
                                                            physics: BouncingScrollPhysics(),
                                                            padding: EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                            Axis.horizontal,
                                                            itemCount: viewmodel.CategoryProduct?.subCategoryList?.length,
                                                            itemBuilder: (context, position) {
                                                              return InkWell(
                                                                  onTap: () {
                                                                    closeAppbarProperty();
                                                                    SessionStorageHelper.clearAll();
                                                                    context.router.push(SubcategoryProductList(
                                                                      SubcategoryProductName: viewmodel.CategoryProduct?.subCategoryList?[position].title?.replaceAll(' ', '-'),
                                                                      pd: ["${ viewmodel.CategoryProduct?.subCategoryList?[position].catId}",""]
                                                                    ));
                                                                  },
                                                                  child: Container(
                                                                      color: Theme.of(context).cardColor,
                                                                      padding: EdgeInsets.all(15),
                                                                      margin: EdgeInsets.only(
                                                                          right: ResponsiveWidget.isMediumScreen(context) ? 8 : 18),
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            CircleAvatar(
                                                                              radius: ResponsiveWidget.isMediumScreen(context) ?ResponsiveWidget.isSmallScreen(context) ? 50:70 : SizeConfig.screenWidth * 0.055,
                                                                              child: CachedNetworkImage(
                                                                                  imageUrl: viewmodel.CategoryProduct?.subCategoryList?[position].imageUrl ?? "",
                                                                                  fit: BoxFit.fill,
                                                                                  imageBuilder: (context, imageProvider) => Container(
                                                                                    decoration: BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                      image: DecorationImage(
                                                                                        image: imageProvider,
                                                                                        fit: BoxFit.fill))
                                                                                  ),
                                                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2))),
                                                                            ),
                                                                            SizedBox(height: SizeConfig.screenWidth*0.01),
                                                                            AppBoldFont(maxLines:
                                                                            1,
                                                                                context,
                                                                                msg: viewmodel.CategoryProduct?.subCategoryList?[position].title ??
                                                                                    "",
                                                                                fontSize: ResponsiveWidget.isMediumScreen(context)
                                                                                    ? 14
                                                                                    : 18,
                                                                                color:
                                                                                Theme.of(context).canvasColor)
                                                                          ]))
                                                              );
                                                            })),
                                                    ResponsiveWidget.isMediumScreen(context)
                                                        ? Container(
                                                        margin: EdgeInsets.only(
                                                            right: 12,
                                                            left: 12,
                                                            top: 12),
                                                        width: SizeConfig.screenWidth,
                                                        child: GridView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:ResponsiveWidget.isSmallScreen(context) ?2: 3,
                                                                childAspectRatio:ResponsiveWidget.isSmallScreen(context) ? 0.7:0.8,mainAxisSpacing: 5,crossAxisSpacing: 5
                                                            ),
                                                            itemCount: viewmodel
                                                                .CategoryProduct!
                                                                .productList
                                                                ?.length,
                                                            itemBuilder:
                                                                (context, index) {
                                                              final productListData =
                                                              viewmodel
                                                                  .CategoryProduct!
                                                                  .productList?[index];
                                                              return productListItems(
                                                                  context,
                                                                  productListData,
                                                                  index,
                                                                  viewmodel);
                                                            })
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
                                                              CrossAxisAlignment.center,
                                                              children: [
                                                                // Container(
                                                                //     alignment:
                                                                //         Alignment.topLeft,
                                                                //     padding:
                                                                //         EdgeInsets.only(
                                                                //             top: 30,
                                                                //             right: 20),
                                                                //     width: SizeConfig
                                                                //             .screenWidth /
                                                                //         1.75,
                                                                //     child:
                                                                //         catrgoryTopSortWidget(context)),
                                                                SizedBox(height: 15),
                                                                viewmodel.CategoryProduct!.productList?.length==0?  Container(
                                                                  height: SizeConfig.screenHeight * 0.4,
                                                                  padding: EdgeInsets.only(top: 50),
                                                                  width: SizeConfig.screenWidth / 1.38,
                                                                  decoration: BoxDecoration(boxShadow: [
                                                                    BoxShadow(
                                                                      color: Theme.of(context).scaffoldBackgroundColor,
                                                                    )
                                                                  ]),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(10),
                                                                        child: Image.asset(
                                                                          AssetsConstants.ic_noProductFound,
                                                                          height: SizeConfig.screenHeight * 0.2,
                                                                          width: 300,
                                                                        )
                                                                      ),
                                                                      AppBoldFont(
                                                                          context,msg: StringConstant.nodatafound,
                                                                          fontSize: 16,
                                                                          color: Theme.of(context).canvasColor,textAlign: TextAlign.center),
                                                                    ]
                                                                  )
                                                                ) : Container(
                                                                    width:SizeConfig.screenWidth/1.38,
                                                                    child: GridView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        padding: EdgeInsets.only(top: 30,),
                                                                        gridDelegate:
                                                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                                                            mainAxisSpacing:
                                                                            10,crossAxisSpacing: 10,
                                                                            mainAxisExtent:
                                                                            500,
                                                                            maxCrossAxisExtent:
                                                                            400),
                                                                        itemCount: viewmodel.CategoryProduct!.productList?.length,
                                                                        itemBuilder:
                                                                            (context, index) {
                                                                          final productListData = viewmodel.CategoryProduct!
                                                                              .productList?[index];
                                                                          return productListItems(
                                                                              context,
                                                                              productListData,
                                                                              index,
                                                                              viewmodel);
                                                                        }
                                                                    ))
                                                              ])]
                                                    ),
                                                    ResponsiveWidget.isMediumScreen(context)
                                                        ? SizedBox(height:ResponsiveWidget.isSmallScreen(context)
                                                        ? 50:100)
                                                        : SizedBox(height: 120),
                                                    ResponsiveWidget.isMediumScreen(context)
                                                        ? footerMobile(context,homeViewModel)
                                                        : footerDesktop()
                                                  ],
                                                )),
                                            ResponsiveWidget.isMediumScreen(context)
                                                ? Container()
                                                : GlobalVariable.isnotification == true
                                                ? Positioned(
                                                top:  0,
                                                right:SizeConfig.screenWidth * 0.20,
                                                child: notification(notificationViewModel,context,_scrollController)):Container(),
                                            ResponsiveWidget.isMediumScreen(context)
                                                ? Container()
                                                : GlobalVariable.isLogins == true
                                                ? Positioned(
                                                top: 0,
                                                right: 180,
                                                child: profile(context, setState, profileViewModel))
                                                : Container(),
                                            ResponsiveWidget.isMediumScreen(context)
                                                ? Container()
                                                : GlobalVariable.isSearch == true
                                                ? Positioned(
                                                top: 1,
                                                right: SizeConfig.screenWidth * 0.20,
                                                child: searchList(
                                                    context,
                                                    homeViewModel,
                                                    scrollController,
                                                    searchController!,
                                                    cartViewModel.cartItemCount))
                                                : Container()
                                          ]) :Center(child: ThreeArchedCircle(size: 45.0),
                                      ))));}));
                  }));
        }));
  }
}
