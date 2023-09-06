import 'dart:convert';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/model/data/create_order_model.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/CartDetalRepository.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/Products/shipping_address_page.dart';
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
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppRouter.gr.dart';
import '../../utilities/StringConstants.dart';

@RoutePage()
class AddressListPage extends StatefulWidget {
  bool? buynow;

  AddressListPage({Key? key, @PathParam('buynow') this.buynow})
      : super(key: key);

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  CartViewModel cartViewModel = CartViewModel();
  String? checkInternet;
  late Razorpay _razorpay;
  int selectedRadioTile = 0;
  bool google_pay = false;
  bool cod = false;
  bool agree = false;
  String? addressId;
  CartListDataModel? cartListData;
  final _cartRepo = CartDetailRepository();

  CreateOrderModel? _createOrderModel;

  CreateOrderModel? get createOrderModel => _createOrderModel;
  HomeViewModel homeViewModel = HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  ProfileViewModel profileViewModel = ProfileViewModel();
  TextEditingController? searchController = TextEditingController();

  @override
  void initState() {
    _razorpay = Razorpay();
    cartViewModel.getCartCount(context);
    homeViewModel.getAppConfig(context);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    cartViewModel.getAddressList(context);
    if (widget.buynow == true) {
      Map<String, dynamic> json =
          jsonDecode(SessionStorageHelper.getValue("buynow").toString());
      cartListData = CartListDataModel.fromJson(json);
    } else {
      cartViewModel.getCartListData(context);
    }

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
    return checkInternet == "Offline"
        ? NOInternetScreen()
        : ChangeNotifierProvider.value(
            value: cartViewModel,
            child: Consumer<CartViewModel>(builder: (context, cartViewData, _) {
              cartViewModel.addressListModel?.length == 0 ? 0 : addressId = cartViewModel.addressListModel?[0].addressId;
              return (cartViewData.addressListModel != null &&
                          cartViewData.cartListData != null) ||
                      widget.buynow == true
                  ? GestureDetector(
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
                        appBar: ResponsiveWidget.isMediumScreen(context)
                            ? homePageTopBar(
                                context,
                                _scaffoldKey,
                                cartViewData.cartItemCount,
                                homeViewModel,
                                profileViewModel,
                              )
                            : getAppBar(
                                context,
                                homeViewModel,
                                profileViewModel,
                                cartViewData.cartItemCount,
                                1,
                                searchController, () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                if (sharedPreferences.get('token') == null) {
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
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            drawer: ResponsiveWidget.isMediumScreen(context)
                                ? AppMenu()
                                : SizedBox(),
                            body:
                                (cartViewData.addressListModel != null &&
                                            widget.buynow == false) ||
                                        widget.buynow == true
                                    ? Stack(
                                        children: [
                                          SingleChildScrollView(
                                            child:
                                                ResponsiveWidget.isMediumScreen(
                                                        context)
                                                    ? Column(
                                                        children: [
                                                          cartPageViewIndicator(
                                                              context, 1),
                                                          AddressButton(context,
                                                              () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return ShippingAddressPage(
                                                                      isAlreadyAdded:
                                                                          false);
                                                                });
                                                          }),
                                                          cartViewData.addressListModel
                                                                      ?.length ==
                                                                  0
                                                              ? Container()
                                                              : addressDetails(
                                                                  context,
                                                                  addressId,
                                                                  cartViewData),
                                                          Container(
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: <Widget>[
                                                                Container(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            20,
                                                                        top: 8,
                                                                        bottom:
                                                                            10),
                                                                    child: AppBoldFont(
                                                                        context,
                                                                        msg: StringConstant
                                                                            .selectPayment)),
                                                                Divider(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  thickness:
                                                                      0.2,
                                                                  height: 1,
                                                                ),
                                                                Theme(
                                                                  data:
                                                                      ThemeData(
                                                                    unselectedWidgetColor:
                                                                        Theme.of(context)
                                                                            .canvasColor,
                                                                  ),
                                                                  child:
                                                                      RadioListTile(
                                                                    tileColor: Theme.of(
                                                                            context)
                                                                        .canvasColor,
                                                                    value: 1,
                                                                    dense: true,
                                                                    groupValue:
                                                                        selectedRadioTile,
                                                                    materialTapTargetSize:
                                                                        MaterialTapTargetSize
                                                                            .padded,
                                                                    visualDensity:
                                                                        VisualDensity
                                                                            .compact,
                                                                    contentPadding:
                                                                        EdgeInsets.only(
                                                                            left:
                                                                                8),
                                                                    title: AppBoldFont(
                                                                        context,
                                                                        msg: StringConstant
                                                                            .cardWalletsText,
                                                                        fontSize:
                                                                            14.0),
                                                                    onChanged:
                                                                        (val) {
                                                                      print(
                                                                          "Radio Tile pressed $val");
                                                                      if (val ==
                                                                          1) {
                                                                        setSelectedRadioTile(
                                                                            1);
                                                                      }
                                                                      setState(
                                                                          () {
                                                                        google_pay =
                                                                            true;
                                                                        cod =
                                                                            false;
                                                                      });
                                                                    },
                                                                    activeColor:
                                                                        Theme.of(context)
                                                                            .primaryColor,
                                                                    selected:
                                                                        google_pay,
                                                                  ),
                                                                ),
                                                                Divider(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  thickness:
                                                                      0.2,
                                                                  height: 1,
                                                                ),
                                                                GlobalVariable
                                                                            .cod ==
                                                                        true
                                                                    ? Theme(
                                                                        data:
                                                                            ThemeData(
                                                                          unselectedWidgetColor:
                                                                              Theme.of(context).canvasColor,
                                                                        ),
                                                                        child:
                                                                            RadioListTile(
                                                                          visualDensity:
                                                                              VisualDensity.compact,
                                                                          tileColor:
                                                                              Theme.of(context).canvasColor,
                                                                          materialTapTargetSize:
                                                                              MaterialTapTargetSize.padded,
                                                                          dense:
                                                                              true,
                                                                          value:
                                                                              2,
                                                                          groupValue:
                                                                              selectedRadioTile,
                                                                          contentPadding:
                                                                              EdgeInsets.only(left: 8),
                                                                          title: AppBoldFont(
                                                                              context,
                                                                              msg: StringConstant.COD,
                                                                              fontSize: 14.0),
                                                                          onChanged:
                                                                              (val) {
                                                                            print("Radio Tile pressed $val");
                                                                            if (val ==
                                                                                2) {
                                                                              setSelectedRadioTile(2);
                                                                            }
                                                                            setState(() {
                                                                              cod = true;
                                                                              google_pay = false;
                                                                            });
                                                                          },
                                                                          activeColor:
                                                                              Theme.of(context).primaryColor,
                                                                          selected:
                                                                              cod,
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          widget.buynow == true
                                                              ? Column(
                                                                  children: cartListData!
                                                                      .checkoutDetails!
                                                                      .map((e) {
                                                                  return Container(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .cardColor,
                                                                    width: SizeConfig
                                                                        .screenWidth,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                8),
                                                                        e.name ==
                                                                                'Total items'
                                                                            ? priceDetailWidget(
                                                                                context,
                                                                                e.name ?? "",
                                                                                "1")
                                                                            : priceDetailWidget(context, e.name ?? "", e.value ?? ""),
                                                                        SizedBox(
                                                                            height:
                                                                                8)
                                                                      ],
                                                                    ),
                                                                  );
                                                                }).toList())
                                                              : Container(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                  child: pricedetails(
                                                                      context,
                                                                      cartViewData)),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            children: [
                                                              Material(
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor,
                                                                child: Checkbox(
                                                                  checkColor: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  activeColor: Theme.of(
                                                                          context)
                                                                      .canvasColor
                                                                      .withOpacity(
                                                                          0.8),
                                                                  side: MaterialStateBorderSide
                                                                      .resolveWith(
                                                                    (states) => BorderSide(
                                                                        width:
                                                                            1.0,
                                                                        color: Theme.of(context)
                                                                            .canvasColor
                                                                            .withOpacity(0.8)),
                                                                  ),
                                                                  value: agree,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      agree =
                                                                          value!;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              AppMediumFont(
                                                                  context,
                                                                  msg: StringConstant
                                                                      .Accept,
                                                                  fontSize:
                                                                      16.0),
                                                              InkWell(
                                                                  onTap: () {
                                                                    context.router.push(WebHtmlPage(
                                                                        title:
                                                                            'ReturnPolicy',
                                                                        html:
                                                                            'return_policy'));
                                                                  },
                                                                  child: AppMediumFont(
                                                                      context,
                                                                      msg: StringConstant
                                                                          .returnPolicy,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      fontSize:
                                                                          16.0)),
                                                              AppRegularFont(
                                                                  context,
                                                                  msg: " and ",
                                                                  fontSize:
                                                                      16.0),
                                                              InkWell(
                                                                  onTap: () {
                                                                    context.router.push(WebHtmlPage(
                                                                        title:
                                                                            'TermsAndCondition',
                                                                        html:
                                                                            'terms_condition'));
                                                                  },
                                                                  child: AppMediumFont(
                                                                      context,
                                                                      msg: StringConstant
                                                                          .TermsOfuse,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      fontSize:
                                                                          16.0)),
                                                            ],
                                                          ),
                                                          SizedBox(height: 20),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                if (agree !=
                                                                    true) {
                                                                  ToastMessage.message(
                                                                      StringConstant
                                                                          .acceptReturnPolicy,
                                                                      context);
                                                                }else if( cartViewModel.addressListModel?.length == 0){
                                                                  ToastMessage.message(StringConstant.pleaseAddaddress, context);
                                                                } else if ((google_pay ==
                                                                        true) &&
                                                                    (agree ==
                                                                        true)) {
                                                                  widget.buynow ==
                                                                          true
                                                                      ? createOrder(
                                                                          "online",
                                                                          cartListData?.cartList?[0].productId ??
                                                                              "",
                                                                          cartListData?.cartList?[0].productDetails?.variantId ??
                                                                              '',
                                                                          cartListData?.checkoutDetails?.elementAt(0).value ??
                                                                              "",
                                                                          context,
                                                                          addressId:
                                                                              addressId,
                                                                          gateway:
                                                                              GlobalVariable.payGatewayName,
                                                                        )
                                                                      : createOrder(
                                                                          "online",
                                                                          '',
                                                                          '',
                                                                          '',
                                                                          context,
                                                                          addressId:
                                                                              addressId,
                                                                          gateway:
                                                                              GlobalVariable.payGatewayName,
                                                                        );
                                                                } else if ((cod ==
                                                                        true) &&
                                                                    (agree ==
                                                                        true)) {
                                                                  widget.buynow ==
                                                                          true
                                                                      ? createOrder(
                                                                          "cod",
                                                                          cartListData?.cartList?[0].productId ??
                                                                              "",
                                                                          cartListData?.cartList?[0].productDetails?.variantId ??
                                                                              '',
                                                                          cartListData?.checkoutDetails?.elementAt(0).value ??
                                                                              "",
                                                                          context,
                                                                          addressId:
                                                                              addressId)
                                                                      : createOrder(
                                                                          "cod",
                                                                          '',
                                                                          '',
                                                                          '',
                                                                          context,
                                                                          addressId:
                                                                              addressId);
                                                                } else {
                                                                  ToastMessage.message(
                                                                      StringConstant
                                                                          .selectPaymentOption,
                                                                      context);
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          50,
                                                                      vertical:
                                                                          20),
                                                                  backgroundColor:
                                                                      Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                              child: Text(
                                                                  StringConstant
                                                                      .checkout,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .hintColor))),
                                                          SizedBox(height: 20),
                                                          footerMobile(context,
                                                              homeViewModel)
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          cartPageViewIndicator(
                                                              context, 1),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              cartViewData.addressListModel !=
                                                                      null
                                                                  ? Column(
                                                                      children: [
                                                                        AddressButton(
                                                                            context,
                                                                            () {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return ShippingAddressPage(isAlreadyAdded: false);
                                                                              });
                                                                        }),
                                                                        cartViewData.addressListModel?.length ==
                                                                                0
                                                                            ? Container()
                                                                            : addressDetails(
                                                                                context,
                                                                                addressId,
                                                                                cartViewData)
                                                                      ],
                                                                    )
                                                                  : Container(
                                                                      width: ResponsiveWidget.isMediumScreen(
                                                                              context)
                                                                          ? SizeConfig.screenWidth /
                                                                              0.5
                                                                          : SizeConfig.screenWidth *
                                                                              0.30,
                                                                      child: ThreeArchedCircle(
                                                                          size:
                                                                              45.0),
                                                                    ),
                                                              Column(
                                                                children: [
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  widget.buynow ==
                                                                          true
                                                                      ? Column(
                                                                          children: cartListData!.checkoutDetails!.map(
                                                                              (e) {
                                                                          return Container(
                                                                            color:
                                                                                Theme.of(context).cardColor,
                                                                            width:
                                                                                SizeConfig.screenWidth / 3.22,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                SizedBox(height: 8),
                                                                                e.name == 'Total items' ? priceDetailWidget(context, e.name ?? "", "1") : priceDetailWidget(context, e.name ?? "", e.value ?? ""),
                                                                                SizedBox(height: 8)
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }).toList())
                                                                      : Container(
                                                                          color: Theme.of(context)
                                                                              .cardColor,
                                                                          child: pricedetails(
                                                                              context,
                                                                              cartViewData)),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Container(
                                                                    width: SizeConfig
                                                                            .screenWidth /
                                                                        3.22,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .cardColor,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: <Widget>[
                                                                        Container(
                                                                            padding: EdgeInsets.only(
                                                                                left: 20,
                                                                                top: 8,
                                                                                bottom: 10),
                                                                            child: AppBoldFont(context, msg: StringConstant.selectPayment)),
                                                                        Divider(
                                                                          color:
                                                                              Theme.of(context).canvasColor,
                                                                          thickness:
                                                                              0.2,
                                                                          height:
                                                                              1,
                                                                        ),
                                                                        Theme(
                                                                          data:
                                                                              ThemeData(
                                                                            unselectedWidgetColor:
                                                                                Theme.of(context).canvasColor,
                                                                          ),
                                                                          child:
                                                                              RadioListTile(
                                                                            tileColor:
                                                                                Theme.of(context).canvasColor,
                                                                            value:
                                                                                1,
                                                                            dense:
                                                                                true,
                                                                            groupValue:
                                                                                selectedRadioTile,
                                                                            materialTapTargetSize:
                                                                                MaterialTapTargetSize.padded,
                                                                            visualDensity:
                                                                                VisualDensity.compact,
                                                                            contentPadding:
                                                                                EdgeInsets.only(left: 8),
                                                                            title: AppBoldFont(context,
                                                                                msg: StringConstant.cardWalletsText,
                                                                                fontSize: 14.0),
                                                                            onChanged:
                                                                                (val) {
                                                                              print("Radio Tile pressed $val");
                                                                              if (val == 1) {
                                                                                setSelectedRadioTile(1);
                                                                              }
                                                                              setState(() {
                                                                                google_pay = true;
                                                                                cod = false;
                                                                              });
                                                                            },
                                                                            activeColor:
                                                                                Theme.of(context).primaryColor,
                                                                            selected:
                                                                                google_pay,
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          color:
                                                                              Theme.of(context).canvasColor,
                                                                          thickness:
                                                                              0.2,
                                                                          height:
                                                                              1,
                                                                        ),
                                                                        GlobalVariable.cod ==
                                                                                true
                                                                            ? Theme(
                                                                                data: ThemeData(
                                                                                  unselectedWidgetColor: Theme.of(context).canvasColor,
                                                                                ),
                                                                                child: RadioListTile(
                                                                                  visualDensity: VisualDensity.compact,
                                                                                  tileColor: Theme.of(context).canvasColor,
                                                                                  materialTapTargetSize: MaterialTapTargetSize.padded,
                                                                                  dense: true,
                                                                                  value: 2,
                                                                                  groupValue: selectedRadioTile,
                                                                                  contentPadding: EdgeInsets.only(left: 8),
                                                                                  title: AppBoldFont(context, msg: StringConstant.COD, fontSize: 14.0),
                                                                                  onChanged: (val) {
                                                                                    print("Radio Tile pressed $val");
                                                                                    if (val == 2) {
                                                                                      setSelectedRadioTile(2);
                                                                                    }
                                                                                    setState(() {
                                                                                      cod = true;
                                                                                      google_pay = false;
                                                                                    });
                                                                                  },
                                                                                  activeColor: Theme.of(context).primaryColor,
                                                                                  selected: cod,
                                                                                ),
                                                                              )
                                                                            : SizedBox()
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Material(
                                                                        color: Theme.of(context)
                                                                            .scaffoldBackgroundColor,
                                                                        child:
                                                                            Checkbox(
                                                                          checkColor:
                                                                              Theme.of(context).primaryColor,
                                                                          activeColor: Theme.of(context)
                                                                              .canvasColor
                                                                              .withOpacity(0.8),
                                                                          side:
                                                                              MaterialStateBorderSide.resolveWith(
                                                                            (states) =>
                                                                                BorderSide(width: 1.0, color: Theme.of(context).canvasColor.withOpacity(0.8)),
                                                                          ),
                                                                          value:
                                                                              agree,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              agree = value!;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                      AppMediumFont(
                                                                          context,
                                                                          msg: StringConstant
                                                                              .Accept,
                                                                          fontSize:
                                                                              16.0),
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            context.router.push(WebHtmlPage(
                                                                                title: 'ReturnPolicy',
                                                                                html: 'return_policy'));
                                                                          },
                                                                          child: AppMediumFont(
                                                                              context,
                                                                              msg: StringConstant.returnPolicy,
                                                                              color: Theme.of(context).primaryColor,
                                                                              fontSize: 16.0)),
                                                                      AppRegularFont(
                                                                          context,
                                                                          msg:
                                                                              " and ",
                                                                          fontSize:
                                                                              16.0),
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            context.router.push(WebHtmlPage(
                                                                                title: 'TermsAndCondition',
                                                                                html: 'terms_condition'));
                                                                          },
                                                                          child: AppMediumFont(
                                                                              context,
                                                                              msg: StringConstant.TermsOfuse,
                                                                              color: Theme.of(context).primaryColor,
                                                                              fontSize: 16.0)),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (agree != true) {
                                                                          ToastMessage.message(StringConstant.acceptReturnPolicy, context);
                                                                        } else if( cartViewModel.addressListModel?.length == 0){
                                                                          ToastMessage.message(StringConstant.pleaseAddaddress, context);
                                                                        }
                                                                        else if ((google_pay == true) &&
                                                                            (agree ==
                                                                                true)) {
                                                                          widget.buynow == true
                                                                              ? createOrder(
                                                                                  "online",
                                                                                  cartListData?.cartList?[0].productId ?? "",
                                                                                  cartListData?.cartList?[0].productDetails?.variantId ?? '',
                                                                                  cartListData?.checkoutDetails?.elementAt(0).value ?? "",
                                                                                  context,
                                                                                  addressId: addressId,
                                                                                  gateway: GlobalVariable.payGatewayName,
                                                                                )
                                                                              : createOrder(
                                                                                  "online",
                                                                                  '',
                                                                                  '',
                                                                                  '',
                                                                                  context,
                                                                                  addressId: addressId,
                                                                                  gateway: GlobalVariable.payGatewayName,
                                                                                );
                                                                        } else if ((cod ==
                                                                                true) &&
                                                                            (agree ==
                                                                                true)) {
                                                                          widget.buynow == true
                                                                              ? createOrder("cod", cartListData?.cartList?[0].productId ?? "", cartListData?.cartList?[0].productDetails?.variantId ?? '', cartListData?.checkoutDetails?.elementAt(0).value ?? "", context, addressId: addressId)
                                                                              : createOrder("cod", '', '', '', context, addressId: addressId);
                                                                        } else {
                                                                          ToastMessage.message(
                                                                              StringConstant.selectPaymentOption,
                                                                              context);
                                                                        }
                                                                      },
                                                                      style:
                                                                          ButtonStyle(
                                                                              backgroundColor: MaterialStateProperty.all(Theme.of(context)
                                                                                  .primaryColor),
                                                                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                                                  horizontal:
                                                                                      80,
                                                                                  vertical:
                                                                                      20)),
                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                  RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(ResponsiveWidget.isMediumScreen(context) ? 0 : 5.0),
                                                                              ))),
                                                                      child: AppBoldFont(
                                                                          context,
                                                                          msg: StringConstant
                                                                              .checkout,
                                                                          color: Theme.of(context)
                                                                              .hintColor,
                                                                          fontSize:
                                                                              18))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          ResponsiveWidget
                                                                  .isMediumScreen(
                                                                      context)
                                                              ? SizedBox(
                                                                  height: 50)
                                                              : SizedBox(
                                                                  height: 300),
                                                          footerDesktop()
                                                        ],
                                                      ),
                                          ),
                                          ResponsiveWidget.isMediumScreen(
                                                  context)
                                              ? Container()
                                              : isLogins == true
                                                  ? Positioned(
                                                      top: 0,
                                                      right: 180,
                                                      child: profile(
                                                          context,
                                                          setState,
                                                          profileViewModel))
                                                  : Container(),
                                          ResponsiveWidget.isMediumScreen(
                                                  context)
                                              ? Container()
                                              : isSearch == true
                                                  ? Positioned(
                                                      top: SizeConfig
                                                              .screenWidth *
                                                          0.001,
                                                      right: SizeConfig
                                                              .screenWidth *
                                                          0.20,
                                                      child: searchList(
                                                          context,
                                                          homeViewModel,
                                                          scrollController,
                                                          searchController!,
                                                          cartViewModel
                                                              .cartItemCount))
                                                  : Container()
                                        ],
                                      )
                                    : Center(
                                        child: ThreeArchedCircle(size: 45.0),
                                      )),
                      ))
                  : Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Center(
                        child: ThreeArchedCircle(size: 45.0),
                      ),
                    );
            }));
  }

  // payment selection
  setSelectedRadioTile(int val) {
    selectedRadioTile = val;
  }

  Future<void> createOrder(String paymentMethod, String productId,
      String variantId, String quantity, BuildContext context,
      {String? addressId, String? gateway}) async {
    AppIndicator.loadingIndicator(context);
    _cartRepo.createOrder(
        paymentMethod, productId, variantId, quantity, gateway, context,
        (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        _createOrderModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        if (paymentMethod == "online") {
          if (gateway == "stripe") {
            cartViewModel.createPaymentIntent(context, createOrderModel,
                addressId, productId, variantId, quantity);
          } else if (gateway == "razorpay") {
            openPaymentGateway(_createOrderModel);
          }
        } else {
          cartViewModel.placeOrder(
              context,
              addressId ?? '',
              '',
              "",
              paymentMethod,
              widget.buynow == true
                  ? cartListData?.cartList![0].productId ?? ""
                  : '',
              widget.buynow == true
                  ? cartListData?.cartList![0].productDetails?.variantId ?? ""
                  : '',
              widget.buynow == true
                  ? cartListData?.checkoutDetails!.elementAt(0).value ?? ""
                  : '',
              'Success');
        }
      }
    });
  }

  void openPaymentGateway(CreateOrderModel? createOrderModel) async {
    double total = double.parse(createOrderModel?.total ?? "");
    print(total);
    var options = {
      'key': createOrderModel?.key,
      'amount': createOrderModel?.total,
      //createOrderModel?.total,
      'receipt': createOrderModel?.receipt,
      'name': createOrderModel?.name ?? '',
      'image': createOrderModel?.image ?? '',
      'order_id': createOrderModel?.paymentOrderId,
      'retry': {
        'enabled': createOrderModel?.retryEnabled ?? false,
        'max_count': createOrderModel?.retryMaxCount ?? 1
      },
      'send_sms_hash': createOrderModel?.sendSmsHash ?? false,
      'description': createOrderModel?.description ?? '',
      'timeout': createOrderModel?.timeout ?? 60 * 5,
      'prefill': {
        'contact': createOrderModel?.contact ?? '',
        'email': createOrderModel?.email ?? '',
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    cartViewModel.paymentResponse(context, createOrderModel?.receipt ?? '',
        response.orderId, response.paymentId, 'Success', '', addressId ?? '');

    cartViewModel.placeOrder(
        context,
        addressId ?? '',
        response.paymentId,
        response.orderId,
        'Online',
        widget.buynow == true ? cartListData?.cartList![0].productId ?? "" : '',
        widget.buynow == true
            ? cartListData?.cartList![0].productDetails?.variantId ?? ""
            : '',
        widget.buynow == true
            ? cartListData?.checkoutDetails!.elementAt(0).value ?? ""
            : '',
        'Success');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response.message);
    print('Error Response: $response');
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }
}
