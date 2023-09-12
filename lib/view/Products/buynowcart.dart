import 'package:TychoStream/main.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/getAppBar.dart';
import 'package:TychoStream/view/WebScreen/NotificationScreen.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/notification_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppRouter.gr.dart';

@RoutePage()
class BuynowCart extends StatefulWidget {
  final List<String>? buynow;
  BuynowCart({ @QueryParam() this.buynow,Key? key}) : super(key: key);
  @override
  State<BuynowCart> createState() => _BuynowCartState();
}

class _BuynowCartState extends State<BuynowCart> {
  String? checkInternet;
 CartViewModel cartViewData = CartViewModel();
  HomeViewModel homeViewModel=HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  ProfileViewModel profileViewModel = ProfileViewModel();
  TextEditingController? searchController = TextEditingController();
  NotificationViewModel notificationViewModel = NotificationViewModel();
  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    homeViewModel.getAppConfig(context);
    cartViewData.getCartCount(context);
    notificationViewModel.getNotificationCountText(context);
    cartViewData.buyNow(widget.buynow?[0] ?? "", SessionStorageHelper.getValue("itemCount").toString()=="null"?'1':SessionStorageHelper.getValue("itemCount").toString(), widget.buynow?[1], true, context);
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
    return  ChangeNotifierProvider.value(
        value: cartViewData,
        child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
      return ChangeNotifierProvider.value(
          value: notificationViewModel,
          child: Consumer<NotificationViewModel>(
              builder: (context, model, _) {
                return viewmodel.cartListData != null?
                Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar:ResponsiveWidget.isMediumScreen(context)
            ? homePageTopBar(context, _scaffoldKey,cartViewData.cartItemCount,homeViewModel, profileViewModel,model)
            : getAppBar(
            context,model,
            homeViewModel,
            profileViewModel,
            cartViewData.cartItemCount,1,
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
            if(isnotification==true){
              isnotification=false;

            }
            context.router.push(FavouriteListPage());
          }
        }, () async {
          SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') == null) {
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
            if(isnotification==true){
              isnotification=false;

            }
            context.router.push(CartDetail(
                itemCount:
                '${cartViewData.cartItemCount}'));
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
                  child: Container(
                      child: Column(
                        children: [
                          cartPageViewIndicator(context, 0),
                        SizedBox(height: 4),
                      Container(
                            color: Theme.of(context).cardColor,
                            width:ResponsiveWidget.isMediumScreen(context) ?  SizeConfig.screenWidth/1.1:SizeConfig.screenWidth/3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: ResponsiveWidget.isMediumScreen(context) ?  ResponsiveWidget.isSmallScreen(context) ? 120:150 : SizeConfig.screenWidth * 0.11,
                                        width: ResponsiveWidget.isMediumScreen(context)
                                            ?  ResponsiveWidget.isSmallScreen(context) ? 120:150
                                            : SizeConfig.screenWidth * 0.11,
                                        margin: EdgeInsets.only(
                                            left: 12, top: 12, right: 8, bottom: 5),
                                        child: Image.network(
                                          viewmodel.cartListData?.cartList?[0].productDetails?.productImages?[0] ?? "",fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    viewmodel.cartListData?.cartList?[0].productDetails?.inStock == true ?
                                    Container(
                                      height: 30,
                                      margin: EdgeInsets.only(left: 12, top: 12, right: 8, bottom: 5),
                                      width: ResponsiveWidget.isMediumScreen(context)
                                          ?  ResponsiveWidget.isSmallScreen(context) ? 120:150
                                          : SizeConfig.screenWidth * 0.11,
                                      decoration:BoxDecoration(
                                          border: Border.all(color: Theme.of(context).canvasColor.withOpacity(0.2),width: 1)
                                      ),
                                      child: Row(children: [
                                        Expanded(
                                          flex: 25,
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.remove,
                                              size: 18.0,
                                              color: Colors.grey,
                                            ),
                                            onTap: () async {
                                              int value= int.parse(viewmodel.cartListData!.checkoutDetails!.elementAt(0).value ?? "");
                                              print(value);
                                              value=value-1;
                                              if(value >= 1){
                                                AppIndicator.loadingIndicator(context);
                                                viewmodel.cartListData?.checkoutDetails?.elementAt(0).value =value.toString();
                                                cartViewData.buyNow(
                                                    viewmodel.cartListData?.cartList?[0].productId ??"",
                                                    viewmodel.cartListData!.checkoutDetails!.elementAt(0).value.toString(),  viewmodel.cartListData?.cartList?[0].productDetails?.variantId,
                                                    false, context);
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                            height: 30,width: 1,
                                            color: Theme.of(context).canvasColor.withOpacity(0.2)
                                        ),
                                        Expanded(
                                          flex: 50,
                                          child: AppBoldFont(context,
                                              textAlign: TextAlign.center,
                                              color: Theme.of(context).canvasColor,
                                              msg: viewmodel.cartListData?.checkoutDetails?.elementAt(0).value ?? "",
                                              fontSize: 16.0),
                                        ),
                                        Container(
                                            height: 30,width: 1,
                                            color: Theme.of(context).canvasColor.withOpacity(0.2)
                                        ),
                                        Expanded(
                                          flex: 25,
                                          child: GestureDetector(
                                              child: Icon(
                                                Icons.add,
                                                size: 18.0,
                                                color: Colors.grey,
                                              ),
                                              onTap: () {
                                                if (( viewmodel.cartListData?.cartList?[0].productDetails?.quantityLeft)! > int.parse(viewmodel.cartListData!.checkoutDetails!.elementAt(0).value ?? "")) {
                                                    AppIndicator.loadingIndicator(context);
                                                    int value= int.parse(viewmodel.cartListData!.checkoutDetails!.elementAt(0).value ?? "");
                                                    print(value);
                                                    value=value+1;
                                                    viewmodel.cartListData?.checkoutDetails?.elementAt(0).value =value.toString();
                                                    cartViewData.buyNow(
                                                        viewmodel. cartListData?.cartList?[0].productId ??"",
                                                        viewmodel.cartListData!.checkoutDetails!.elementAt(0).value.toString(),  viewmodel.cartListData?.cartList?[0].productDetails?.variantId,
                                                        false, context);

                                                  } else {
                                                    ToastMessage.message(
                                                        "Sorry only ${ viewmodel.cartListData?.cartList?[0].productDetails?.quantityLeft} quantity is left.",
                                                        context);
                                                  }

                                              }
                                          ),
                                        )
                                      ]),
                                    ):SizedBox(),
                                    SizedBox(height: 10)
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 15),
                                    Container(
                                      width: SizeConfig.screenWidth /4.8,
                                      child: AppMediumFont(
                                          color: Theme.of(context).canvasColor,
                                          context,
                                          msg:viewmodel.cartListData?.cartList?[0].productName,
                                          fontSize: 16.0),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        AppMediumFont(context,
                                            msg: "₹" +
                                                " ${viewmodel.cartListData?.cartList?[0].productDetails?.productDiscountPrice}",
                                            color: Theme.of(context).canvasColor.withOpacity(0.9),
                                            fontSize: 18.0),
                                        SizedBox(width: 5),
                                        AppMediumFont(context,
                                            color: Theme.of(context).canvasColor.withOpacity(0.8),
                                            msg:"₹" +
                                                "${
                                                    viewmodel.cartListData
                                                        ?.cartList?[0]
                                                        .productDetails
                                                        ?.productPrice
                                                        .toString()
                                                }",
                                            textDecoration:
                                            TextDecoration.lineThrough,
                                            fontSize: 18.0),
                                        SizedBox(width: 5),
                                        AppMediumFont(context,
                                            msg:
                                            "${viewmodel.cartListData?.cartList?[0].productDetails?.productDiscountPercent}" +
                                                r"%OFF",
                                            color: GREEN,
                                            fontSize: 18.0),
                                      ],
                                    ),
                                    viewmodel.cartListData?.cartList?[0].productDetails
                                        ?.defaultVariationSku?.color?.name !=
                                        null
                                        ? RichText(
                                        text: TextSpan(
                                            text: 'Color  :  ',
                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                            children: <InlineSpan>[
                                              TextSpan(
                                                style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                                text: '${viewmodel.cartListData?.cartList?[0].productDetails?.defaultVariationSku?.color?.name}',
                                              )
                                            ]
                                        ))
                                        : SizedBox(),
                                    viewmodel.cartListData?.cartList?[0].productDetails
                                        ?.defaultVariationSku?.size?.name !=
                                        null
                                        ?  RichText(
                                        text: TextSpan(
                                            text: 'Size  :  ',
                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                            children: <InlineSpan>[
                                              TextSpan(
                                                style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                                text: '${viewmodel.cartListData?.cartList?[0].productDetails?.defaultVariationSku?.size?.name}',
                                              )
                                            ]
                                        ))
                                        : SizedBox(),
                                    viewmodel.cartListData?.cartList?[0].productDetails
                                        ?.defaultVariationSku?.style?.name !=
                                        null
                                        ?
                                    RichText(
                                        text: TextSpan(
                                            text: 'Style  :  ',
                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                            children: <InlineSpan>[
                                              TextSpan(
                                                style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                                text: '${viewmodel.cartListData?.cartList?[0].productDetails?.defaultVariationSku?.style?.name}',
                                              )
                                            ]
                                        ))
                                        : SizedBox(),
                                    viewmodel.cartListData
                                        ?.cartList?[0]
                                        .productDetails
                                        ?.defaultVariationSku
                                        ?.materialType
                                        ?.name !=
                                        null
                                        ?  RichText(
                                        text: TextSpan(
                                            text: 'MaterialType  :  ',
                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                            children: <InlineSpan>[
                                              TextSpan(
                                                style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                                text: '${
                                                    viewmodel.cartListData!.cartList![0].productDetails!.defaultVariationSku!.materialType!.name!.length > 35 ?
                                                    viewmodel.cartListData!.cartList![0].productDetails!.defaultVariationSku!.materialType?.name!.replaceRange(35, viewmodel.cartListData?.cartList?[0].productDetails!.defaultVariationSku!.materialType?.name?.length, '...') : viewmodel.cartListData?.cartList?[0].productDetails!.defaultVariationSku!.materialType?.name ?? ""
                                                }',                                        )
                                            ]
                                        ))
                                        : SizedBox(),
                                    viewmodel. cartListData
                                        ?.cartList?[0]
                                        .productDetails
                                        ?.defaultVariationSku
                                        ?.unitCount
                                        ?.name !=
                                        null
                                        ?
                                    RichText(
                                        text: TextSpan(
                                            text: 'UnitCount  :  ',
                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                            children: <InlineSpan>[
                                              TextSpan(
                                                style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                                text: '${viewmodel.cartListData?.cartList?[0].productDetails?.defaultVariationSku?.unitCount?.name}',
                                              )
                                            ]
                                        ))
                                        : SizedBox(),
                                    SizedBox(height: 15),
                                  ],
                                )
                              ],
                            ),
                          ),
                 SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.only(top: 4, bottom: 10),
                            color: Theme.of(context).cardColor,
                            child: Column(
                                children:  viewmodel.cartListData!.checkoutDetails!
                                    .map((e){
                                  return Container(
                                    width: ResponsiveWidget.isMediumScreen(context)
                                        ?SizeConfig.screenWidth/1.1:SizeConfig.screenWidth/3,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 8),
                                        e.name=='Total items'?  priceDetailWidget(context, e.name ?? "", "1"):
                                        priceDetailWidget(context, e.name ?? "", e.value ??""),
                                        SizedBox(height: 8)
                                      ],
                                    ),
                                  );
                                } ).toList()
                            ),
                          ),
                          SizedBox(height: 15),
                        Container(
                              height: 50,
                              decoration:BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(4)
                              ) ,
                              width: ResponsiveWidget.isMediumScreen(context)
                                  ?SizeConfig.screenWidth/1.2: SizeConfig.screenWidth/5.2,
                              child: InkWell(
                                onTap: () {
                                  if (isLogins == true) {
                                  isLogins = false;
                                }
                                if (isSearch == true) {
                                  isSearch = false;
                                }
                                if(isnotification==true){
                                  isnotification=false;

                                }
                                  context.router.push(BuynowAddress()
                                  );
                                },
                                child: Center(
                                    child: AppMediumFont(context,
                                        msg:StringConstant.continueText,
                                        fontSize: 15.0,
                                        color:Theme.of(context).hintColor)),
                              )),
                          ResponsiveWidget.isMediumScreen(context)
                              ? SizedBox(height: ResponsiveWidget.isSmallScreen(context)
                              ? 50:SizeConfig.screenHeight/4):SizedBox(height: 300),
                          ResponsiveWidget.isMediumScreen(context)
                              ?footerMobile(context,homeViewModel):footerDesktop()
                        ],
                      ),
                    ),
                ),
                ResponsiveWidget.isMediumScreen(context)
                    ? Container()
                    : isnotification == true
                    ?    Positioned(
                    top:  0,
                    right:  SizeConfig
                        .screenWidth *
                        0.20,
                    child: notification(notificationViewModel,context,_scrollController)):Container(),
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
                    ? Container():isSearch == true
                    ? Positioned(
                    top: SizeConfig.screenWidth *
                        0.001,
                    right:  SizeConfig.screenWidth *
                        0.20,
                    child: searchList(
                        context,
                        homeViewModel,
                        scrollController,
                        searchController!,
                        cartViewData
                            .cartItemCount))
                    : Container()
              ],
            )))
    :Container( width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            color:Theme.of(context).scaffoldBackgroundColor,child: Center(child: ThreeArchedCircle(size: 45.0)));}));
        }));
  }

}
