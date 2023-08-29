import 'dart:convert';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/getAppBar.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppRouter.gr.dart';


@RoutePage()
class BuynowCart extends StatefulWidget {
  BuynowCart({Key? key}) : super(key: key);

  @override
  State<BuynowCart> createState() => _BuynowCartState();
}

class _BuynowCartState extends State<BuynowCart> {
  final validation = ValidationBloc();
  String? checkInternet;
  int activeStep = 0;
  CartListDataModel? cartListData;
  final CartViewModel cartViewData = CartViewModel();
  HomeViewModel homeViewModel=HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  ProfileViewModel profileViewModel = ProfileViewModel();
  TextEditingController? searchController = TextEditingController();
  @override
  void initState() {
    homeViewModel.getAppConfig(context);
    cartViewData.getCartCount(context);
    Map<String, dynamic> json = jsonDecode(SessionStorageHelper.getValue("token").toString());
   cartListData = CartListDataModel.fromJson(json);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider.value(
        value: homeViewModel,
        child:
        Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
      return

      cartListData?.cartList !=null? Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar:ResponsiveWidget.isMediumScreen(context)
            ? homePageTopBar(context, _scaffoldKey,cartViewData.cartItemCount,homeViewModel, profileViewModel,)
            : getAppBar(
            context,
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
              setState(() {});
            }
            if (isSearch == true) {
              isSearch = false;
              setState(() {});
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
        body: checkInternet == "Offline"
            ? NOInternetScreen()
            : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                      child: Column(
                        children: [
                          cartPageViewIndicator(context, 0),
                          ResponsiveWidget.isMediumScreen(context)
                              ?SizedBox(height: 0):SizedBox(height: 4),
                          ResponsiveWidget.isMediumScreen(context)
                              ? Container(
                            width: SizeConfig.screenWidth,
                            child: Card(
                              elevation: 0.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                        },
                                        child: Container(
                                          height: 120,
                                          width: 120,
                                          margin: EdgeInsets.only(
                                              left: 5, top: 5, right: 8, bottom: 5),
                                          child: Image.network(
                                              cartListData?.cartList?[0].productDetails?.productImages?[0] ?? ""
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        margin: EdgeInsets.only(left: 5, top: 5, right: 8, bottom: 5),
                                        width: 120,
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
                                                int value= int.parse(cartListData!.checkoutDetails!.elementAt(0).value ?? "");
                                                print(value);
                                                value=value-1;
                                                if(value >= 1){
                                                cartListData?.checkoutDetails?.elementAt(0).value =value.toString();
                                                  cartViewData.buyNow(
                                                     cartListData?.cartList?[0].productId ??"",
                                                      cartListData!.checkoutDetails!.elementAt(0).value.toString(),  cartListData?.cartList?[0].productDetails?.variantId,
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
                                            child: AppBoldFont(context,textAlign: TextAlign.center,
                                                color: Theme.of(context).canvasColor,
                                                msg: cartListData?.checkoutDetails?.elementAt(0).value ?? "",
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
                                                  int value= int.parse(cartListData!.checkoutDetails!.elementAt(0).value ?? "");
                                                  print(value);
                                                  value=value+1;
                                                cartListData?.checkoutDetails?.elementAt(0).value =value.toString();
                                                  cartViewData.buyNow(
                                                     cartListData?.cartList?[0].productId ??"",
                                                      cartListData!.checkoutDetails!.elementAt(0).value.toString(),  cartListData?.cartList?[0].productDetails?.variantId,
                                                      false, context);
                                                }
                                            ),
                                          )
                                        ]),
                                      ),
                                      SizedBox(height: 10)
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15),
                                      Container(
                                        width: SizeConfig.screenWidth * 0.50,
                                        child: AppMediumFont(
                                            color: Theme.of(context).canvasColor,
                                            context,maxLines: 2,
                                            msg:cartListData?.cartList?[0].productName,
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          AppMediumFont(context,
                                              msg: "₹" +
                                                  " ${cartListData?.cartList?[0].productDetails?.productDiscountPrice}",
                                              color: Theme.of(context).canvasColor.withOpacity(0.8),
                                              fontSize: 18.0),
                                          SizedBox(width: 5),
                                          AppMediumFont(context,
                                              color: Theme.of(context).canvasColor.withOpacity(0.8),
                                              msg:"₹" +
                                                  "${
                                                     cartListData
                                                          ?.cartList?[0]
                                                          .productDetails
                                                          ?.productPrice
                                                          .toString()
                                                  }",
                                              textDecoration:
                                              TextDecoration.lineThrough,
                                              fontSize: 16.0),
                                          SizedBox(width: 5),
                                          AppMediumFont(context,
                                              msg:
                                              "${cartListData?.cartList?[0].productDetails?.productDiscountPercent}" +
                                                  r"%OFF",
                                              color: GREEN,
                                              fontSize: 14.0),
                                        ],
                                      ),
                                     cartListData?.cartList?[0].productDetails
                                          ?.defaultVariationSku?.color?.name !=
                                          null
                                          ? RichText(
                                          text: TextSpan(
                                              text: 'Color  :  ',
                                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                                  text: '${cartListData?.cartList?[0].productDetails?.defaultVariationSku?.color?.name}',
                                                )
                                              ]
                                          ))
                                          : SizedBox(),
                                     cartListData?.cartList?[0].productDetails
                                          ?.defaultVariationSku?.size?.name !=
                                          null
                                          ?  RichText(
                                          text: TextSpan(
                                              text: 'Size  :  ',
                                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                                  text: '${cartListData?.cartList?[0].productDetails?.defaultVariationSku?.size?.name}',
                                                )
                                              ]
                                          ))
                                          : SizedBox(),
                                     cartListData?.cartList?[0].productDetails
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
                                                  text: '${cartListData?.cartList?[0].productDetails?.defaultVariationSku?.style?.name}',
                                                )
                                              ]
                                          ))
                                          : SizedBox(),
                                      cartListData
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
                                                    cartListData!.cartList![0].productDetails!.defaultVariationSku!.materialType!.name!.length > 35 ?
                                                     cartListData!.cartList![0].productDetails!.defaultVariationSku!.materialType?.name!.replaceRange(35, cartListData?.cartList?[0].productDetails!.defaultVariationSku!.materialType?.name?.length, '...') : cartListData?.cartList?[0].productDetails!.defaultVariationSku!.materialType?.name ?? ""
                                                  }',                                        )
                                              ]
                                          ))
                                          : SizedBox(),
                                      cartListData
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
                                                  text: '${cartListData?.cartList?[0].productDetails?.defaultVariationSku?.unitCount?.name}',
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
                          )
                              :  Container(
                            color: Theme.of(context).cardColor,
                            width: SizeConfig.screenWidth/3,
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
                                        height: 150,
                                        margin: EdgeInsets.only(
                                            left: 12, top: 12, right: 8, bottom: 5),
                                        child: Image.network(
                                          cartListData?.cartList?[0].productDetails?.productImages?[0] ?? ""
                                          ,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      margin: EdgeInsets.only(left: 12, top: 12, right: 8, bottom: 5),
                                      width: 120,
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
                                              int value= int.parse(cartListData!.checkoutDetails!.elementAt(0).value ?? "");
                                              print(value);
                                              value=value-1;
                                              if(value >= 1){
                                                cartListData?.checkoutDetails?.elementAt(0).value =value.toString();
                                                cartViewData.buyNow(
                                                    cartListData?.cartList?[0].productId ??"",
                                                    cartListData!.checkoutDetails!.elementAt(0).value.toString(),  cartListData?.cartList?[0].productDetails?.variantId,
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
                                              msg: cartListData?.checkoutDetails?.elementAt(0).value ?? "",
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
                                                int value= int.parse(cartListData!.checkoutDetails!.elementAt(0).value ?? "");
                                                print(value);
                                                value=value+1;
                                                cartListData?.checkoutDetails?.elementAt(0).value =value.toString();
                                                cartViewData.buyNow(
                                                    cartListData?.cartList?[0].productId ??"",
                                                    cartListData!.checkoutDetails!.elementAt(0).value.toString(),  cartListData?.cartList?[0].productDetails?.variantId,
                                                    false, context);
                                              }
                                          ),
                                        )
                                      ]),
                                    ),
                                    SizedBox(height: 10)
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 15),
                                    Container(
                                      width: SizeConfig.screenWidth /4.5,
                                      child: AppMediumFont(
                                          color: Theme.of(context).canvasColor,
                                          context,
                                          msg:cartListData?.cartList?[0].productName,
                                          fontSize: 16.0),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        AppMediumFont(context,
                                            msg: "₹" +
                                                " ${cartListData?.cartList?[0].productDetails?.productDiscountPrice}",
                                            color: Theme.of(context).canvasColor.withOpacity(0.9),
                                            fontSize: 18.0),
                                        SizedBox(width: 5),
                                        AppMediumFont(context,
                                            color: Theme.of(context).canvasColor.withOpacity(0.8),
                                            msg:"₹" +
                                                "${
                                                    cartListData
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
                                            "${cartListData?.cartList?[0].productDetails?.productDiscountPercent}" +
                                                r"%OFF",
                                            color: GREEN,
                                            fontSize: 18.0),
                                      ],
                                    ),
                                    cartListData?.cartList?[0].productDetails
                                        ?.defaultVariationSku?.color?.name !=
                                        null
                                        ? RichText(
                                        text: TextSpan(
                                            text: 'Color  :  ',
                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                            children: <InlineSpan>[
                                              TextSpan(
                                                style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                                text: '${cartListData?.cartList?[0].productDetails?.defaultVariationSku?.color?.name}',
                                              )
                                            ]
                                        ))
                                        : SizedBox(),
                                    cartListData?.cartList?[0].productDetails
                                        ?.defaultVariationSku?.size?.name !=
                                        null
                                        ?  RichText(
                                        text: TextSpan(
                                            text: 'Size  :  ',
                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                            children: <InlineSpan>[
                                              TextSpan(
                                                style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                                text: '${cartListData?.cartList?[0].productDetails?.defaultVariationSku?.size?.name}',
                                              )
                                            ]
                                        ))
                                        : SizedBox(),
                                    cartListData?.cartList?[0].productDetails
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
                                                text: '${cartListData?.cartList?[0].productDetails?.defaultVariationSku?.style?.name}',
                                              )
                                            ]
                                        ))
                                        : SizedBox(),
                                    cartListData
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
                                                    cartListData!.cartList![0].productDetails!.defaultVariationSku!.materialType!.name!.length > 35 ?
                                                    cartListData!.cartList![0].productDetails!.defaultVariationSku!.materialType?.name!.replaceRange(35, cartListData?.cartList?[0].productDetails!.defaultVariationSku!.materialType?.name?.length, '...') : cartListData?.cartList?[0].productDetails!.defaultVariationSku!.materialType?.name ?? ""
                                                }',                                        )
                                            ]
                                        ))
                                        : SizedBox(),
                                    cartListData
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
                                                text: '${cartListData?.cartList?[0].productDetails?.defaultVariationSku?.unitCount?.name}',
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
                          ResponsiveWidget.isMediumScreen(context)
                              ?SizedBox(height: 0):SizedBox(height: 8),
                          ResponsiveWidget.isMediumScreen(context)
                              ?  Container(
                          color: Theme.of(context).cardColor,
                            child: Column(
                                children:  cartListData!.checkoutDetails!
                                    .map((e){
                                  return Container(
                                    width: SizeConfig.screenWidth,
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
                          )
                              :  Container(
                            padding: EdgeInsets.only(top: 4, bottom: 10),
                            color: Theme.of(context).cardColor,
                            child: Column(
                                children:  cartListData!.checkoutDetails!
                                    .map((e){
                                  return Container(
                                    width: SizeConfig.screenWidth/3,
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
                          ResponsiveWidget.isMediumScreen(context)
                              ?  Container(
                              height: 50,
                              decoration:BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(4)
                              ) ,
                              width: SizeConfig.screenWidth/1.2,
                              child: InkWell(
                                onTap: () { if (isLogins == true) {
                                  isLogins = false;
                                  setState(() {});
                                }
                                if (isSearch == true) {
                                  isSearch = false;
                                  setState(() {});
                                }
                                  context.router.push(
                                      AddressListPage(
                                        buynow: true
                                      )
                                  );
                                },
                                child: Center(
                                    child: AppMediumFont(context,
                                        msg: "CONTINUE",
                                        fontSize: 15.0,
                                        color: Colors.white)),
                              ))
                              :Container(
                              height: 50,
                              decoration:BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(4)
                              ) ,
                              width: SizeConfig.screenWidth/5.2,
                              child: InkWell(
                                onTap: () { if (isLogins == true) {
                                  isLogins = false;
                                  setState(() {});
                                }
                                if (isSearch == true) {
                                  isSearch = false;
                                  setState(() {});
                                }
                                  context.router.push(
                                      AddressListPage(
                                          buynow: true
                                      )
                                  );
                                },
                                child: Center(
                                    child: AppMediumFont(context,
                                        msg: "CONTINUE",
                                        fontSize: 15.0,
                                        color:Theme.of(context).hintColor)),
                              )),
                          ResponsiveWidget.isMediumScreen(context)
                              ? SizedBox(height: 50):SizedBox(height: 300),
                          ResponsiveWidget.isMediumScreen(context)
                              ?footerMobile(context):footerDesktop()
                        ],
                      ),
                    ),
                ),
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
                        homeViewModel,
                        searchController!,
                        cartViewData
                            .cartItemCount))
                    : Container()
              ],
            )))
    :Center(child: CircularProgressIndicator());}));
  }

}
