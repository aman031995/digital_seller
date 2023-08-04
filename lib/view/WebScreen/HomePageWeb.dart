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

  void initState() {
    homeViewModel.getAppConfig(context);
    User();
    cartViewModel.getCartCount(context);
    cartViewModel.getProductCategoryList(context,1);
    cartViewModel.getRecommendedViewData(context);
    profileViewModel.getProfileDetails(context);
    super.initState();
  }

  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    names = sharedPreferences.get('name').toString();
    if (sharedPreferences.get('token') != null){
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
        child: Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
      return ChangeNotifierProvider.value(
        value: homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return
            GestureDetector(
                onTap: () {
                  if (isLogins == true) {
                    isLogins = false;
                    setState(() {});
                  }
                  if(isSearch==true){
                    isSearch=false;
                    setState(() {

                    });
                  }
                },
                child: Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    extendBodyBehindAppBar: true,
                  appBar: ResponsiveWidget.isMediumScreen(context)
                      ? homePageTopBar(context,_scaffoldKey)
                      : getAppBar(context,viewmodel,profilemodel,cartViewModel.cartItemCount,searchController, () async {
                SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
                token = sharedPreferences.getString('token').toString();
                if (token == 'null') {
                showDialog(
                context: context,
                barrierColor:
                Theme.of(context).canvasColor.withOpacity(0.6),
                builder: (BuildContext context) {
                return LoginUp(
                product: true,
                );
                });
                // _backBtnHandling(prodId);
                } else {
                context.router.push(FavouriteListPage());
                }
                },
                          ()async{
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    token = sharedPreferences.getString('token').toString();
                    if (token == 'null'){
                      showDialog(
                          context: context,
                          barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
                          builder:
                              (BuildContext context) {
                            return  LoginUp(
                              product: true,
                            );
                          });
                    } else{
                      context.router.push(CartDetail(
                          itemCount: '${cartViewModel.cartItemCount}'
                      ));
                    }}),

          body: checkInternet == "Offline"
                   ?  NOInternetScreen()
                     : Scaffold(
              extendBodyBehindAppBar: true,
                       key: _scaffoldKey,
                     backgroundColor: Theme.of(context).backgroundColor,
                          drawer: ResponsiveWidget.isMediumScreen(context)
                              ? AppMenu():SizedBox(),
              body:
              Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonCarousel(),
                                SizedBox(height: 10),
                                Container(
                                 margin: EdgeInsets.zero,
                                    color: Theme.of(context).cardColor.withOpacity(0.6),
                                 padding: EdgeInsets.only(left:ResponsiveWidget.isMediumScreen(context)
                                     ?16: 40,right:ResponsiveWidget.isMediumScreen(context)
                                     ?16: 40,bottom: 0,top: 20),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Container(child: AppBoldFont(context, msg: "What are you looking for?", fontSize:ResponsiveWidget.isMediumScreen(context)
                                         ?14:18)),
                                     SizedBox(height:SizeConfig.screenHeight*0.01),

                                     //subcategory page tap-----

                                     Container(
                                         height:  ResponsiveWidget.isMediumScreen(context)
                                             ? 150:250,
                                         child: ListView.builder(
                                             physics: BouncingScrollPhysics(),
                                             reverse: false,
                                             padding: EdgeInsets.zero,
                                             scrollDirection: Axis.horizontal,
                                             itemCount: cartViewModel.categoryListModel?.length,
                                             itemBuilder: (context, position) {
                                               return GestureDetector(
                                                 onTap: (){
                                                   // if(cartview.categoryListModel![position].subcategories!.isNotEmpty){
                                                   //   Navigator.push(context, CupertinoPageRoute(
                                                   //       builder: (_) => ProductSubcategoryView(
                                                   //         categoryList: cartview.categoryListModel![position].subcategories,
                                                   //         title: cartview.categoryListModel![position].categoryTitle,
                                                   //       )));
                                                   // } else {
                                                   //   AppNavigator.push(context, ProductListGallery(
                                                   //     catId: cartview.categoryListModel![position].categoryId,
                                                   //     categoryTitle: cartview.categoryListModel![position].categoryTitle,
                                                   //   ));
                                                   // }
                                                 },
                                                 child: Container(
                                                   margin: EdgeInsets.only(right: 16),
                                                   child: Column(
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       CircleAvatar(
                                                         backgroundColor: Theme.of(context).cardColor,
                                                         radius:  ResponsiveWidget.isMediumScreen(context)
                                                             ?55:100,
                                                         child: CachedNetworkImage(
                                                             imageUrl: cartViewModel.categoryListModel?[position].imageUrl ?? "", fit: BoxFit.fill,
                                                             imageBuilder: (context, imageProvider) => Container(
                                                               decoration: BoxDecoration(
                                                                 shape: BoxShape.circle,
                                                                 image: DecorationImage(
                                                                     image: imageProvider, fit: BoxFit.cover),
                                                               ),
                                                             ),
                                                             placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey))),
                                                       ),
                                                       SizedBox(height: SizeConfig.screenHeight*0.01),
                                                       AppBoldFont(maxLines: 1,context, msg: cartViewModel.categoryListModel?[position].categoryTitle ?? "",fontSize: ResponsiveWidget.isMediumScreen(context) ?14:16),
                                                       SizedBox(height: SizeConfig.screenHeight*0.01),
                                                     ],
                                                   ),
                                                 ),
                                               );
                                             })),
                                   ],
                                 ),
                               ),
                                SizedBox(height: 10),
                                Container(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.only(left:ResponsiveWidget.isMediumScreen(context)
                                      ?16: 40,right:ResponsiveWidget.isMediumScreen(context)
                                      ?16: 40,bottom: 20,top: 20),
                                  color: Theme.of(context).cardColor.withOpacity(0.6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppBoldFont(context, msg: "Recommended for You ",fontSize: ResponsiveWidget.isMediumScreen(context) ?14: 18),
                                      SizedBox(height: SizeConfig.screenHeight*0.01),
                                      Container(
                                          height: ResponsiveWidget.isMediumScreen(context)
                                              ?185: SizeConfig.screenHeight/1.9,
                                          width: SizeConfig.screenWidth,
                                          child: ListView.builder(
                                              reverse: false,
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: cartViewModel.recommendedView?.length,
                                              itemBuilder: (context, position) {
                                                return  GestureDetector(
                                                    onTap: () {
                                                      context.router.push(ProductListGallery());
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(right: 16),
                                                      height: ResponsiveWidget.isMediumScreen(context)
                                                          ?185: SizeConfig.screenHeight/1.9,
                                                      width: ResponsiveWidget.isMediumScreen(context) ?140:SizeConfig.screenHeight/2.8,
                                                      decoration:BoxDecoration(
                                                        color: Theme.of(context).cardColor,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          CachedNetworkImage(
                                                              imageUrl: '${cartViewModel.recommendedView?[position].productDetails?.productImages?[0]}', fit: BoxFit.fill,
                                                              imageBuilder: (context, imageProvider) => Container(
                                                                height:  ResponsiveWidget.isMediumScreen(context) ?140: SizeConfig.screenHeight/2.1,
                                                                width: ResponsiveWidget.isMediumScreen(context) ?140:SizeConfig.screenHeight/2.8,
                                                                margin: EdgeInsets.only(bottom: 8),
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: imageProvider, fit: BoxFit.fill),
                                                                ),
                                                              ),
                                                              placeholder: (context, url) => Container(
                                                                  height:  ResponsiveWidget.isMediumScreen(context) ?140: SizeConfig.screenHeight/2.1,
                                                                  child: Center(child: CircularProgressIndicator(color: Colors.grey)))),
                                                          AppBoldFont(maxLines: 1,context, msg:getRecommendedViewTitle(position, cartViewModel),fontSize:ResponsiveWidget.isMediumScreen(context)
                                                              ?14 :18),
                                                          SizedBox(height: 10)

                                                        ],
                                                      ),
                                                    ),
                                                  );

                                              }))
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                (cartViewModel.recentView?.length ??0)>0 ?
                                Container(
                                  margin: EdgeInsets.zero,
                                  color: Theme.of(context).cardColor.withOpacity(0.6),
                                  padding: EdgeInsets.only(left:ResponsiveWidget.isMediumScreen(context)
                                      ?16: 40,right:ResponsiveWidget.isMediumScreen(context)
                                      ?16: 40,bottom: 20,top: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       AppBoldFont(context, msg:"Recently Viewed",fontSize: ResponsiveWidget.isMediumScreen(context) ?14:18),
                                      SizedBox(height: SizeConfig.screenHeight*0.02),
                                      Container(
                                          height:ResponsiveWidget.isMediumScreen(context)
                                              ?200: SizeConfig.screenHeight/2.65,
                                          width: SizeConfig.screenWidth,
                                          child: ListView.builder(
                                              reverse: false,
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: cartViewModel.recentView?.length,
                                              itemBuilder: (context, position) {
                                                return
                                                  OnHover(builder: (isHovered) {
                                                    return
                                                  GestureDetector(
                                                  onTap: (){
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
                                                  child: Container(
                                                    width: ResponsiveWidget.isMediumScreen(context)
                                                        ?140:SizeConfig.screenHeight/4,
                                                    height:ResponsiveWidget.isMediumScreen(context)
                                                      ?185: SizeConfig.screenHeight/2.65,
                                                    decoration:isHovered==true? BoxDecoration(
                                                      color: Theme.of(context).cardColor,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Theme.of(context).canvasColor.withOpacity(0.15),
                                                            blurRadius: 10.0,
                                                            spreadRadius: 7,
                                                          offset: Offset(2, 2),
                                                        ),
                                                        BoxShadow(
                                                            color: Theme.of(context).canvasColor.withOpacity(0.12),
                                                            blurRadius: 7.0,
                                                            spreadRadius: 5,
                                                          offset: Offset(2, 2),
                                                        ),
                                                        BoxShadow(
                                                            color: Theme.of(context).canvasColor.withOpacity(0.10),
                                                            blurRadius: 4.0,
                                                            spreadRadius: 3,
                                                          offset: Offset(2, 2),
                                                        ),
                                                        BoxShadow(
                                                            color: Theme.of(context).canvasColor.withOpacity(0.09),
                                                            blurRadius: 1.0,
                                                            spreadRadius: 1.0,
                                                          offset: Offset(2, 2),
                                                        ),
                                                      ],
                                                    ):BoxDecoration(
                                                      color: Theme.of(context).cardColor,
                                                    ),
                                                    margin: EdgeInsets.only(right: 16),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,

                                                      children: [
                                                        CachedNetworkImage(
                                                            imageUrl: '${cartViewModel.recentView?[position].productDetails?.productImages?[0]}', fit: BoxFit.fill,
                                                            imageBuilder: (context, imageProvider) => Container(
                                                              margin: EdgeInsets.only(bottom:8),
                                                              height:  ResponsiveWidget.isMediumScreen(context)
                                                                  ?140:SizeConfig.screenHeight/3,
                                                              width: ResponsiveWidget.isMediumScreen(context)
                                                                ?140:SizeConfig.screenHeight/4,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: imageProvider, fit: BoxFit.fill),
                                                              ),
                                                            ),
                                                            placeholder: (context, url) => Container(
                                                                height:  ResponsiveWidget.isMediumScreen(context) ?140: SizeConfig.screenHeight/2.1,
                                                               child: Center(child: CircularProgressIndicator(color: Colors.grey)))),

                                                        AppBoldFont(context, msg:getRecentViewTitle(position,cartViewModel),fontSize:ResponsiveWidget.isMediumScreen(context)
                                                            ?14: 18,maxLines: 1),
                                                        SizedBox(height:  10)

                                                      ],
                                                    ),
                                                  ),
                                                );
                                                },
                                                  hovered : Matrix4.identity()..translate(0,0,0),
                                                );
                                              }))
                                    ],
                                  ),
                                ):
                                SizedBox(),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.only(left:ResponsiveWidget.isMediumScreen(context)
                                      ?16: 40,right:ResponsiveWidget.isMediumScreen(context)
                                      ?16: 40,bottom: 20,top: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppBoldFont(context, msg:"What We Offer !",fontSize: ResponsiveWidget.isMediumScreen(context) ?14:18),
                                      SizedBox(height: 10,),
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                                whatWeOfferWidget(AssetsConstants.icSupport,StringConstant.offerOnTimeDelivery ,StringConstant.offerContent),
                                              whatWeOfferWidget(AssetsConstants.icCreditCard,StringConstant.offerSecurePayment , StringConstant.offerContent),
                                              whatWeOfferWidget(AssetsConstants.icTimer, StringConstant.offerSupport, StringConstant.offerContent),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                getLatestUpdate(),
                                SizedBox(height: 16),
                                ResponsiveWidget.isMediumScreen(context)
                                    ?footerMobile(context): footerDesktop(),
                              ],
                            ),
                          ),
                          isLogins == true
                              ? Positioned(
                              top:ResponsiveWidget.isMediumScreen(context)
                                  ?45: 80,right: ResponsiveWidget.isMediumScreen(context)
                              ?20:35,
                              child: profile(context, setState,profilemodel))
                              : Container(),

                          isSearch==true?
                          Positioned(
                              top: ResponsiveWidget.isMediumScreen(context) ? 0:SizeConfig.screenWidth*0.041,
                              right: ResponsiveWidget.isMediumScreen(context) ? 0:SizeConfig.screenWidth*0.15,
                              child: searchList(context, viewmodel, scrollController,homeViewModel, searchController!,cartViewModel.cartItemCount))
                              : Container()

                        ],
                      )))

              );}
        )
      );}
        )
    );
  }
  String? getRecommendedViewTitle(int position,CartViewModel cartview) {
    if ((cartview.recommendedView?[position].productDetails?.productVariantTitle?.length ?? 0 )> 18) {
      return cartview.recommendedView?[position].productDetails?.productVariantTitle?.replaceRange(
          18        , cartview.recommendedView?[position].productDetails?.productVariantTitle?.length,'...');
    } else {
      return cartview.recommendedView?[position].productDetails?.productVariantTitle ?? "";
    }
  }
  String? getRecentViewTitle(int position,CartViewModel cartview) {
    if ((cartview.recentView?[position].productDetails?.productVariantTitle?.length ?? 0) > 18) {
      return cartview.recentView?[position].productDetails?.productVariantTitle?.replaceRange(
          18, cartview.recentView?[position].productDetails?.productVariantTitle?.length, '...');
    } else {
      return cartview.recentView?[position].productDetails?.productVariantTitle ?? "";
    }
  }
  
  Widget whatWeOfferWidget(String img, String heading, String msg){
    return Container(
      padding:  EdgeInsets.all(ResponsiveWidget.isMediumScreen(context)
          ?10:20),
      margin: EdgeInsets.only(right:ResponsiveWidget.isMediumScreen(context)
          ?10: 20),
      height:ResponsiveWidget.isMediumScreen(context)
          ?150: 250,
      width:ResponsiveWidget.isMediumScreen(context)
          ?250: 397,
      color:  Theme.of(context).cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset( img, width: ResponsiveWidget.isMediumScreen(context)
              ?30:72, height:ResponsiveWidget.isMediumScreen(context)
              ?30: 72,),
          SizedBox(height:ResponsiveWidget.isMediumScreen(context)
              ?10: 20,),
          AppBoldFont(context, msg: heading, fontWeight: FontWeight.w600, fontSize:ResponsiveWidget.isMediumScreen(context)
              ?14: 16),
          SizedBox(height: ResponsiveWidget.isMediumScreen(context)
              ?7:15,),
          AppRegularFont(context, msg: msg, fontWeight: FontWeight.w400, fontSize: ResponsiveWidget.isMediumScreen(context)
              ?12:16),
        ],
      ),
    );
  }

  Widget getLatestUpdate( ){
    return Stack(

      children: [
        Image.asset( AssetsConstants.icNewUpdate, height: ResponsiveWidget.isMediumScreen(context)
            ?150:300, width: SizeConfig.screenWidth,fit: BoxFit.fill,),
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: ResponsiveWidget.isMediumScreen(context)
                ?70:120),
            child: AppBoldFont(context, msg: StringConstant.getLatestupdate, fontWeight: FontWeight.w500, fontSize:ResponsiveWidget.isMediumScreen(context)
                ?18: 30,color: Colors.white,textAlign: TextAlign.center)),

      ],
    );
  }

  Widget getLatestUpdateRowTextField(){
    return Row(

    );
  }
}
