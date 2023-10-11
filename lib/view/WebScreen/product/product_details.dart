import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/services/session_storage.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/build_indicator.dart';
import 'package:TychoStream/utilities/full_image_view.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/product/productSkuDetailView.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
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
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../AppRouter.gr.dart';

@RoutePage()
class ProductDetailPage extends StatefulWidget {
  final List<String>? productdata;
  final String? productName;
  ProductDetailPage(
      {
        @PathParam('productName') this.productName ,
        @QueryParam() this.productdata,
        Key? key, }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int currentIndex = 0;
  CartViewModel cartView = CartViewModel();
  String? checkInternet;
  ScrollController scrollController = ScrollController();
  HomeViewModel homeViewModel = HomeViewModel();
  ProfileViewModel profileViewModel = ProfileViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  TextEditingController? searchController = TextEditingController();
  CartViewModel cartViewModel = CartViewModel();
  NotificationViewModel notificationViewModel = NotificationViewModel();
  ScrollController _scrollController = ScrollController();

  void initState() {
    homeViewModel.getAppConfig(context);
    SessionStorageHelper.removeValue('payment');
    cartView.getCartCount(context);
    getProductDetails();
    notificationViewModel.getNotificationCountText(context);
    super.initState();
  }
  getProductDetails(){
    {
      cartView.updateCartCount(context, widget.productdata?[1] ?? '');
        cartView.getProductDetails(
            context,
            widget.productdata?[0] ?? "",
            widget.productdata?[2] ?? "",
            widget.productdata?[3] ?? "",
            widget.productdata?[4] ?? "",
            widget.productdata?[5] ?? "",
            widget.productdata?[6] ?? "",
            );
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
        value: cartView,
        child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
          return ChangeNotifierProvider.value(
              value: homeViewModel,
              child: Consumer<HomeViewModel>(builder: (context, s, _) {
                return ChangeNotifierProvider.value(
              value: notificationViewModel,
              child: Consumer<NotificationViewModel>(
                  builder: (context, model, _) {
                    return GestureDetector(
            onTap: (){
              closeAppbarProperty();},
            child: Scaffold(
                appBar:ResponsiveWidget.isMediumScreen(context)
                    ? homePageTopBar(context,_scaffoldKey, viewmodel.cartItemCount,homeViewModel, profileViewModel,model):getAppBar(context,model,homeViewModel,profileViewModel,viewmodel.cartItemCount,1,searchController, () async {
                  SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
                  if (sharedPreferences.getString('token')== null) {
                    showDialog(
                        context: context,
                        barrierColor:
                        Theme.of(context).canvasColor.withOpacity(0.6),
                        builder: (BuildContext context) {
                          return LoginUp(
                            product: true,);
                        });
                  } else {
                    closeAppbarProperty();
                    context.router.push(FavouriteListPage());
                  }
                }, ()async{
                      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                      if (sharedPreferences.getString('token')== null){
                        showDialog(
                            context: context,
                            barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
                            builder: (BuildContext context) {
                              return  LoginUp(product: true,);});
                      } else{
                        closeAppbarProperty();
                        context.router.push(CartDetail(
                            itemCount: '${viewmodel.cartItemCount}'
                        ));
                      }}),
              body: Scaffold(
                    extendBodyBehindAppBar: true,
                    key: _scaffoldKey,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    drawer:
                    ResponsiveWidget.isMediumScreen(context)
                        ? AppMenu()
                        : SizedBox(),
                  body: viewmodel.productListDetails != null ?
             ResponsiveWidget.isMediumScreen(context)
                 ?
             Container(
               height: SizeConfig.screenHeight/1.09,
               color: Theme.of(context).cardColor,
               child: Stack(
                 children: [
                   SingleChildScrollView(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Center(
                           child: Container(
                               width: SizeConfig.screenWidth,
                               child: Stack(children: [
                                 CarouselSlider(
                                     options: CarouselOptions(
                                         height: SizeConfig.screenHeight / 1.8,
                                         enableInfiniteScroll: viewmodel.productListDetails?.productDetails?.productImages?.length==1?false:true,
                                         reverse: false,
                                         viewportFraction: 1,
                                         onPageChanged: (index, reason) {
                                           setState(() {
                                             currentIndex = index;
                                           });
                                         }),
                                     items: viewmodel
                                         .productListDetails?.productDetails?.productImages
                                         ?.map((i) {
                                       return Builder(builder: (BuildContext context) {
                                         return Container(
                                           width: SizeConfig.screenWidth,
                                           child: CachedNetworkImage(
                                               imageUrl: '${i}',
                                               fit: BoxFit.fill,
                                               placeholder: (context, url) => Center(
                                                   child: CircularProgressIndicator(
                                                       color:Colors.grey,strokeWidth: 2))),
                                         );
                                       });
                                     }).toList()),
                                 viewmodel.productListDetails?.productDetails?.productImages?.length == 1 ? Container() :
                                 Positioned(
                                     bottom: 10,
                                     left: 1,
                                     right: 1,
                                     child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: buildIndicator(
                                             viewmodel.productListDetails?.productDetails
                                                 ?.productImages,
                                             currentIndex,
                                             context))),
                                 favoritebutton(context,viewmodel,top: 2)
                               ]))),
Container(
  height: 10,
  color: Theme.of(context).scaffoldBackgroundColor,
),
                         Container(
                             width: SizeConfig.screenWidth,
                             color: Theme.of(context).cardColor,
                             padding: EdgeInsets.only(left: 20.0, right: 10, top:ResponsiveWidget.isSmallScreen(context) ?  4:12, bottom: 4),
                             child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   productDescription(viewmodel),
                                   SizedBox(height: 8),
                                   ProductSkuView(
                                       selected: true,
                                       skuDetails: cartView.productListDetails?.productSkuDetails,
                                       cartView: cartView,
                                       productList: cartView.productListDetails?.productDetails?.defaultVariationSku),
                                 ])),
                         SizedBox(height: 12),
                         cartView.productListDetails?.productDetails?.inStock == true ?
                         (cartView.productListDetails?.productDetails?.quantityLeft ?? 0) > 0?
                        bottomNavigationButton():
                         Center(child: OutofStock(context)):
                         Center(child: OutofStock(context)),
                         SizedBox(height:ResponsiveWidget.isSmallScreen(context)
                             ? 20:80),
                         footerMobile(context,homeViewModel),
                       ]
                     )
                   )
                 ]
               )
             ):
             Stack(
               children: [
                 SingleChildScrollView(
                   child: Column(
                     children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                       Container(margin: EdgeInsets.only(top: SizeConfig.screenHeight*0.02),
                           width: SizeConfig.screenWidth/3.5,
                           child: Stack(children: [
                             CarouselSlider(
                                 options: CarouselOptions(
                                     height: SizeConfig.screenWidth / 2.8,
                                     enableInfiniteScroll: viewmodel.productListDetails?.productDetails?.productImages?.length==1?false:true,
                                     reverse: false,
                                     viewportFraction: 1,
                                     onPageChanged: (index, reason) {
                                       setState(() {
                                         currentIndex = index;
                                       });
                                     }),
                                 items: viewmodel
                                     .productListDetails?.productDetails?.productImages
                                     ?.map((i) {
                                   return Builder(builder: (BuildContext context) {
                                     return GestureDetector(
                                       onTap: (){
                                         showDialog(
                                             context: context,
                                             barrierColor: Colors.transparent,
                                             builder: (BuildContext context) {
                                               return FullImage(imageUrl: i );
                                             });
                                       },
                                       child: Container(
                                         width: SizeConfig.screenWidth/1.2,
                                         child: CachedNetworkImage(
                                             imageUrl: '${i}',
                                             fit: BoxFit.fill,
                                             placeholder: (context, url) => Center(
                                                 child: CircularProgressIndicator(
                                                     color: Colors.grey,strokeWidth: 2))),
                                       ));
                                   });
                                 }).toList()),
                             viewmodel.productListDetails?.productDetails?.productImages?.length == 1 ? Container() :
                             Positioned(
                                 bottom: 10,
                                 left: 1,
                                 right: 1,
                                 child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: buildIndicator(
                                         viewmodel.productListDetails?.productDetails
                                             ?.productImages,
                                         currentIndex,
                                         context))),
                             favoritebutton(context,viewmodel,top: 2)
                           ])),
                       Container(
                           width: SizeConfig.screenWidth/3,
                           margin: EdgeInsets.only(left: 20,top: SizeConfig.screenHeight*0.02),
                           padding: EdgeInsets.only(left: 10.0, top: 5),
                           child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 productDescription(viewmodel),
                                 SizedBox(height: 8),
                                 ProductSkuView(
                                     selected: true,
                                     skuDetails: cartView.productListDetails?.productSkuDetails,
                                     cartView: cartView,
                                     productList: cartView.productListDetails?.productDetails?.defaultVariationSku),
                                 cartView.productListDetails?.productDetails?.inStock == true
                                ?(cartView.productListDetails?.productDetails?.quantityLeft ?? 0) > 0 ?
                                 bottomNavigationButton():
                                 OutofStock(context):
                                 OutofStock(context)
                               ]))]),
                       SizedBox(height: 150),
                        footerDesktop()
                     ])),
                 ResponsiveWidget.isMediumScreen(context)
                     ? Container()
                     : GlobalVariable.isnotification == true
                     ? Positioned(
                     top:  0,
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
                     child: profile(context, setState, profileViewModel))
                     : Container(),
                 ResponsiveWidget.isMediumScreen(context)
                     ? Container()
                     : GlobalVariable.isSearch==true?
                 Positioned(top:0,
                     right:SizeConfig.screenWidth*0.20,
                     child: searchList(context, homeViewModel, scrollController, searchController!,cartView.cartItemCount))
                     : Container()])
         : Center(child: ThreeArchedCircle(size: 45.0)))));
        }));}));}));}

  // product Description
  productDescription(CartViewModel cartView) {
    return Container(
      width: SizeConfig.screenWidth,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBoldFont(context, msg: cartView.productListDetails?.productDetails?.productVariantTitle ?? '', fontSize: ResponsiveWidget.isMediumScreen(context)? 14 :22),
            SizedBox(height: 8),
            AppMediumFont(
              context,color: Theme.of(context).canvasColor.withOpacity(0.8),
              msg:
              "${cartView.productListDetails?.productShortDesc ?? ''}",
              fontSize: ResponsiveWidget.isMediumScreen(context)? 12 :16.0
            ),
            SizedBox(height: 8),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cartView.productListDetails?.productDetails
                      ?.productPrice != '' ?AppMediumFont(context,
                      msg: "₹""${cartView.productListDetails?.productDetails?.productPrice ?? ''}",
                      textDecoration:
                      TextDecoration.lineThrough,
                      fontSize:ResponsiveWidget.isMediumScreen(context)? 14 : 16)
                      : SizedBox(),
                  SizedBox(width: 8.0), AppBoldFont(context,
                      msg: "₹ ""${cartView.productListDetails?.productDetails?.productDiscountPrice ?? ''}",
                      fontSize: ResponsiveWidget.isMediumScreen(context)? 14 :18),SizedBox(width: 8.0),
                  AppMediumFont(context,
                      msg: cartView
                          .productListDetails
                          ?.productDetails
                          ?.productDiscountPercent != '' ? "${cartView.productListDetails?.productDetails?.productDiscountPercent}" +
                          '% OFF'
                          : '',color: GREEN,
                      fontSize:ResponsiveWidget.isMediumScreen(context)? 14 : 18)
                ]),
            SizedBox(height: 8),
            AppBoldFont(context,color:Theme.of(context).canvasColor, msg: StringConstant.descriptionText, fontSize: ResponsiveWidget.isMediumScreen(context)? 14 :16),
            SizedBox(height: 8),
            ReadMoreText(
              '${cartView.productListDetails?.productLongDesc}',
              trimLines: 4,
              style: TextStyle(color: Theme.of(context).canvasColor.withOpacity(0.8)),
              colorClickableText: Theme.of(context).primaryColor,
              trimMode: TrimMode.Line,
              trimCollapsedText: '...Read more',
              trimExpandedText: ' Less',
            ),
            SizedBox(height: 6)])
    );
  }

  //ADDtoBagButton
  addToBagButtonPressed() {
    cartView.addToCart(
              cartView.productListDetails?.productId ?? '',
              "1",
              cartView.productListDetails?.productDetails?.variantId ?? '',
              false,
              context, (result, isSuccess) {});

  }

  //Bottom Navigation
  bottomNavigationButton() {
    return Container(
        width:ResponsiveWidget.isMediumScreen(context)
            ?SizeConfig.screenWidth: SizeConfig.screenWidth/4,
        child: Row(
            mainAxisAlignment:  ResponsiveWidget.isMediumScreen(context)
                ?MainAxisAlignment.center:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).cardColor),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveWidget.isMediumScreen(context) ?0:5.0)))),
              child: AppBoldFont(context,
                  msg: (cartView.isAddedToCart == true || cartView.productListDetails?.productDetails?.isAddToCart == true)
                      ? StringConstant.goToCart
                      : StringConstant.addToBag,color: Theme.of(context).canvasColor,
                  fontSize: 16),
              onPressed: ()async{closeAppbarProperty();
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                if (sharedPreferences.getString('token') == null){
                  showDialog(
                      context: context,barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
                      builder: (BuildContext context) {
                        return  LoginUp(
                          product: true);
                      });
                }
                else if(cartView.productListDetails?.productDetails?.isAvailable == true) {
                  closeAppbarProperty();
                  (cartView.isAddedToCart == true || cartView.productListDetails?.productDetails?.isAddToCart == true) ?
                  context.router.push(CartDetail(
                    itemCount: '${cartView.cartItemCount}'))
                      : addToBagButtonPressed();
                }
              }),
              SizedBox(width:ResponsiveWidget.isMediumScreen(context)
                  ?0: 20),
              ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal:ResponsiveWidget.isMediumScreen(context)
                      ?50: 40, vertical:20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveWidget.isMediumScreen(context) ?0:5.0),
                      ))),
              child: AppBoldFont(context, color: Theme.of(context).hintColor,
                  msg: StringConstant.buynow, fontSize: 16),
              onPressed: ()
              async{ closeAppbarProperty();
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                if (sharedPreferences.getString('token') == null){
                  showDialog(
                      context: context,
                      barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
                      builder: (BuildContext context) {
                        return  LoginUp(
                          product: true);});
                }
                else if (cartView.productListDetails?.productDetails?.isAvailable == true) {
                  SessionStorageHelper.removeValue("itemCount");
                  context.router.push(BuynowCart(
                    productName: cartView.productListDetails?.productName?.replaceAll(" ", '-'),
                    buynow: ['${cartView.productListDetails?.productId}',
                      '${cartView.productListDetails?.productDetails?.variantId}']
                  ));
                }
              })
        ]));}}

Widget OutofStock(BuildContext context){
  return  Container(
      height: 50,width: 180,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).primaryColor),
      child: Row(
          children: [
            SizedBox(width: 10),
            Image.asset(AssetsConstants.ic_outOfStock,width: 20,height: 20,color: Theme.of(context).hintColor,),
            SizedBox(width: 10),
            AppBoldFont(context, color: Theme.of(context).hintColor, msg: StringConstant.OutofStock, fontSize: 18,fontWeight: FontWeight.w500),
          ]));
}