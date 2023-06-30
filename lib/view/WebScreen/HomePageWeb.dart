import 'package:TychoStream/model/data/AppConfigModel.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/view/widgets/video_listpage.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/WebScreen/CommonCarousel.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/widgets/search_view.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import '../../AppRouter.gr.dart';
import '../../main.dart';
import '../MobileScreen/menu/app_menu.dart';

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
  void initState() {
    homeViewModel.getAppConfig(context);
    User();
    cartViewModel.getRecentView(context);
    cartViewModel.getRecommendedView(context);
    profileViewModel.getUserDetails(context);
    super.initState();

  }

  User() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    names = sharedPreferences.get('name').toString();
    image = sharedPreferences.get('profileImg').toString();
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
              onTap: (){
                if(isSearch==true){
                  isSearch=false;
                  searchController?.clear();
                }
                if(isLogins == true){
                  isLogins=false;
                }
              },
                child: Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: ResponsiveWidget.isMediumScreen(context)
                      ? homePageTopBar()
                      : PreferredSize(
                      preferredSize: Size.fromHeight(50),
                      child: Container(
                        color: Theme.of(context).cardColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 25),
                            GestureDetector(
                                onTap: () async{
                                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  if (sharedPreferences.get('token') != null) {
                                    if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                                    _scaffoldKey.currentState?.openDrawer();
                                  } else {
                                    _scaffoldKey.currentState?.openEndDrawer();
                                  }}
                                  else{
                                    ToastMessage.message("Please Login");
                                  }
                                },
                                child: Icon(Icons.menu_outlined)),
                            Expanded(
                              child: SizedBox(
                                  width: SizeConfig.screenWidth * .18),
                            ),
                            viewmodel.appConfigModel!=null?
                            Container(
                            width: 200,height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: viewmodel.appConfigModel!.androidConfig!.bottomNavigation!.map((e) {
                                  return GestureDetector(
                                    onTap: (){
                                      print(e.title);
                                      getPages(e);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.network(e.icon ?? '', width: 20, height: 20),
                                        Text(e.title ?? "")
                                      ],
                                    ),
                                  );
                                }).toList() ,
                              ),
                            ):
                            Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
                            Container(
                              height: 40,
                              width: SizeConfig.screenWidth / 4.9,
                              alignment: Alignment.topCenter,
                              child: AppTextField(
                                  controller: searchController,
                                  textCapitalization:
                                  TextCapitalization.words,
                                  secureText: false,
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  maxLine: searchController!.text.length > 2 ? 2 : 1,
                                  maxLength: null,
                                  labelText: StringConstant.searchItems,
                                  keyBoardType: TextInputType.text,
                                  isSearch: true,
                                  autoFocus: true,
                                  onSubmitted: (v) async{
                                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  if (sharedPreferences.get('token') != null) {
                                 AppIndicator.loadingIndicator(context);
                                    viewmodel.getSearchData(context, searchController?.text ?? '', 1);
                                    isSearch = true;
                                    setState;}
                                  else{
                                    ToastMessage.message("please Login");
                                  }
                                  },
                                  isTick: null),
                            ),
                            SizedBox(
                                width: SizeConfig.screenWidth * .01),
                            names == "null"
                                ? OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierColor: Colors.black87,
                                      builder:
                                          (BuildContext context) {
                                        return  LoginUp();
                                      });
                                },
                                style: ButtonStyle(
                                    overlayColor: MaterialStateColor
                                        .resolveWith((states) =>
                                    Theme
                                        .of(context)
                                        .primaryColor),
                                    fixedSize:
                                    MaterialStateProperty.all(
                                        Size.fromHeight(35)),
                                    side: MaterialStateProperty.all(BorderSide(
                                        color: Theme.of(context).canvasColor,

                                        width: 1.5,
                                        style: BorderStyle.solid),
                                    )
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                        AssetsConstants.icProfile,
                                        width: 20,
                                        height: 20, color: Theme.of(context).canvasColor),
                                    appTextButton(
                                        context,
                                        'SignIn',
                                        Alignment.center,
                                        Theme
                                            .of(context)
                                            .canvasColor,
                                        16,
                                        true),
                                  ],
                                ))
                                :
                            appTextButton(
                                context,
                                names!,
                                Alignment.center,
                                Theme
                                    .of(context)
                                    .canvasColor,
                                18,
                                true,
                                onPressed: () {
                                  isLogins = true;
                                }),
                            names == "null"
                                ? Container()
                                : Image.asset(
                              AssetsConstants.icProfile,
                              height: 30,
                              color: Theme.of(context).canvasColor,
                            ),
                            SizedBox(
                                width: SizeConfig.screenWidth * .02),
                          ],
                        ),
                      )
                  ),
                  body: Scaffold(
                      key: _scaffoldKey,
                      backgroundColor: Theme.of(context).backgroundColor,
                      drawer: AppMenu(),
                      body: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonCarousel(),
                               // VideoListPage()
                                SizedBox(height: ResponsiveWidget.isMediumScreen(context)
                                    ?16:40),
                                Center(
                                  child: Container(
                                      width: ResponsiveWidget.isMediumScreen(context)
                                          ?SizeConfig.screenWidth/1.2: SizeConfig.screenWidth/1.5,
                                      child: AppBoldFont(context, msg: (cartViewModel.recentView?.length ??0)>0? "Recently Viewed":"",fontSize: 18)),
                                ),
                            Center(
                              child: Container(
                                  height: (cartViewModel.recentView?.length ??0)>0 ?ResponsiveWidget.isMediumScreen(context)
                                      ?180: 260 :0,
                                  width: ResponsiveWidget.isMediumScreen(context)
                                      ?SizeConfig.screenWidth/1.2: SizeConfig.screenWidth/1.5 ,
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(top: 4),
                                        reverse: false,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: cartViewModel.recentView?.length,
                                        itemBuilder: (context, position) {
                                          return GestureDetector(
                                            onTap: ()async{

          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            context.router.push(
              ProductDetailPage(
                productId: '${cartViewModel.recentView?[position].productId}',
                productdata: [
                  '${cartViewModel.cartItemCount}',
                  '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.size?.name}',
                  '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.color?.name}',
                  '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.style?.name}',
                  '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.unitCount?.name}',
                  '${cartViewModel.recentView?[position].productDetails?.defaultVariationSku?.materialType?.name}',
                  //'${productListData?.productDetails?.defaultVariationSku?.materialType?.name}'
                ],
              ) ,
            );
          }
          else {
            ToastMessage.message("Please Login User");
          }
                                              // AppNavigator.push(
                                              //     context,
                                              //     ProductDetailPage(
                                              //       items: cartview.recentView?[position],
                                              //       index: position,
                                              //       defalutlike: cartview.recentView?[position].productDetails?.isFavorite,
                                              //       itemCount: cartview.cartItemCount,
                                              //       callback: (prod,value) {
                                              //       },
                                              //     ),
                                              //     screenName: RouteBuilder.productDetails, function: (v) {
                                              //   cartview.updateCartCount(context, v);
                                              // });
                                            },
                                            child: Container(
                                              width: ResponsiveWidget.isMediumScreen(context)
                                                  ?140:180, margin: EdgeInsets.only(right: 12,top: 12,bottom: 2),
                                              child: Column(
                                                children: [
                                                  CachedNetworkImage(
                                                      imageUrl: '${cartViewModel.recentView?[position].productDetails?.productImages?[0]}', fit: BoxFit.fill,
                                                      imageBuilder: (context, imageProvider) => Container(
                                                        margin: EdgeInsets.only(bottom: 2),height:ResponsiveWidget.isMediumScreen(context)
                                                          ? 140:200,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          image: DecorationImage(
                                                              image: imageProvider, fit: BoxFit.cover),
                                                        ),
                                                      ),
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: WHITE_COLOR))),
                                                  AppBoldFont(context, msg:getRecentViewTitle(position,cartViewModel),fontSize: 14,maxLines: 1)
                                                ],
                                              ),
                                            ),
                                          );
                                        }))),
                                SizedBox(height: 16),
                                Center(
                                  child: Container(
                                      width: ResponsiveWidget.isMediumScreen(context)
                                          ?SizeConfig.screenWidth/1.2: SizeConfig.screenWidth/1.5,
                                      child: AppBoldFont(context, msg: "Recommended for You ",fontSize: 18),
                                  )),
                                Center(
                                  child: Container(
                                      height: ResponsiveWidget.isMediumScreen(context)
                                      ?250: 350,
                                      width: ResponsiveWidget.isMediumScreen(context)
                                          ?SizeConfig.screenWidth/1.2: SizeConfig.screenWidth/1.5 ,
                                      child: ListView.builder(
                                          padding: EdgeInsets.only(top: 4),
                                          reverse: false,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: cartViewModel.recommendedView?.length,
                                          itemBuilder: (context, position) {
                                            return GestureDetector(
                                              onTap: () async{

                                                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                                if (sharedPreferences.get('token') != null) {
                                                  context.router.push(ProductListGallery());
                                                }
                                                else {
                                                  ToastMessage.message("Please Login User");
                                                }
                                                // AppNavigator.push(
                                                //     context,
                                                //     ProductListGallery(
                                                //       isRecommended: true,
                                                //     ),
                                                //     screenName: RouteBuilder.productsPage, function: (v) {
                                                //   cartview.updateCartCount(context, v);
                                                // });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(right: 12,top: 12,bottom: 2),width: ResponsiveWidget.isMediumScreen(context)
                                                  ?165:240,
                                                child: Column(
                                                  children: [
                                                    CachedNetworkImage(
                                                        imageUrl: '${cartViewModel.recommendedView?[position].productDetails?.productImages?[0]}', fit: BoxFit.fill,
                                                        imageBuilder: (context, imageProvider) => Container(
                                                          height:  ResponsiveWidget.isMediumScreen(context)
                                                              ?185:250,
                                                          margin: EdgeInsets.only(bottom: 2),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12),
                                                            image: DecorationImage(
                                                                image: imageProvider, fit: BoxFit.fill),
                                                          ),
                                                        ),
                                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey))),
                                                    AppBoldFont(maxLines: 1,context, msg:getRecommendedViewTitle(position, cartViewModel),fontSize: 14)
                                                  ],
                                                ),
                                              ),
                                            );
                                          })),
                                ),
                              ],
                            ),
                          ),
                          isLogins == true
                              ? profile(context, setState,profilemodel)
                              : Container(),

                          isSearch==true?
                          searchList(context, viewmodel, scrollController,homeViewModel, searchController!)
                              : Container()

                        ],
                      )),
                ),
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
  // method for handling bottom nav clicks
  getPages(BottomNavigation navItem) {
    Uri url = Uri.parse(navItem.url ?? '');
    if(url.path == RoutesName.homepageweb){
      return reloadPage();
    }  else if (url.path == RoutesName.productPage){
      return context.router.push(ProductListGallery());
    }
    else if(url.path==RoutesName.profilePage){
      context.pushRoute(EditProfile(
          isEmailVerified: '${profileViewModel.userInfoModel?.isPhoneVerified}',
          isPhoneVerified: '${profileViewModel.userInfoModel?.isEmailVerified}'
      ));
    }
  }

  homePageTopBar() {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme
            .of(context)
            .cardColor,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
          GestureDetector(
              onTap: () async{
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                if (sharedPreferences.get('token') != null){
                  if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                    _scaffoldKey.currentState?.openDrawer();
                  } else {
                    _scaffoldKey.currentState?.openEndDrawer();
                  }
                }
                else{
                  ToastMessage.message("please Login");
                }
                },
              child: Container(
                  height: 35,
                  width: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xff001726),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(Icons.menu_outlined))),
               SizedBox(width: 5),
              GestureDetector(
               onTap: () {
          if(isSearch==true){
            isSearch=false;
            searchController?.clear();
          }
          if( isLogins == true){
            isLogins=false;
            setState(() {

            });
          }
          context.pushRoute(ProductListGallery());
        },
                child: Container(height: 30,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,width: 1),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: appTextButton(
                      context,
                      'ProductList',
                      Alignment.center,
                      Theme
                          .of(context)
                          .canvasColor,
                      14,
                      true),
                ),
              ),
              SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              context.pushRoute(SearchPage());
              // GoRouter.of(context).pushNamed(RoutesName.SearchPage);
            },
            child: Icon(Icons.search_sharp,size: 30)
          ),
          SizedBox(
              width: SizeConfig.screenWidth * .01),
          names == "null"
              ?
          OutlinedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierColor: Colors.black87,
                    builder:
                        (BuildContext context) {
                      return LoginUp();
                    });
              },
              style: ButtonStyle(

                  overlayColor: MaterialStateColor
                      .resolveWith((states) =>
                  Theme
                      .of(context)
                      .primaryColor),
                  fixedSize:
                  MaterialStateProperty.all(
                      Size.fromHeight(30)),
                  side: MaterialStateProperty.all(BorderSide(
                      color: Theme
                          .of(context)
                          .canvasColor,

                      width: 1,
                      style: BorderStyle.solid),
                  )
              ),
              child: Row(
                children: [
                  Image.asset(
                      AssetsConstants.icProfile,
                      width: 20,
                      height: 20, color: Theme
                      .of(context)
                      .canvasColor),
                  appTextButton(
                      context,
                      'SignIn',
                      Alignment.center,
                      Theme
                          .of(context)
                          .canvasColor,
                      14,
                      true),
                ],
              ))
              :
           GestureDetector(
            onTap: () {
              setState(() {
                isLogins = true;
                if (isSearch == true) {
                  isSearch = false;
                  searchController?.clear();
                }
              });
            },
            child: Image.asset(
              AssetsConstants.icProfile,
              height: 30,
              color: Theme
                  .of(context)
                  .canvasColor,
            ),
          ),
        ]));
  }
}
