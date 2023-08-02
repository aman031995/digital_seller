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
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/Products/shipping_address_page.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import '../../AppRouter.gr.dart';
import '../../utilities/StringConstants.dart';

@RoutePage()
class AddressListPage extends StatefulWidget {
   bool? buynow;
  AddressListPage(
      {Key? key,
        @PathParam('buynow') this.buynow})
      : super(key: key);

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  CartViewModel cartViewModel = CartViewModel();
  String? checkInternet;
  int activeStep = 0;
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
  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    cartViewModel.getAddressList(context);
     if(widget.buynow==true){
  Map<String, dynamic> json = jsonDecode(SessionStorageHelper.getValue("token").toString());
   cartListData = CartListDataModel.fromJson(json);
}
else{
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
    return  checkInternet == "Offline"
        ? NOInternetScreen()
        :
    ChangeNotifierProvider.value(
        value: cartViewModel,
        child: Consumer<CartViewModel>(builder: (context, cartViewData, _) {
          cartViewModel.addressListModel?.length==0?0  : addressId=cartViewModel.addressListModel?[0].addressId;
          return
            Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: getAppBarWithBackBtn(
          title:" Payment Page",
          context: context,
          isBackBtn: false,
          onBackPressed: () {
            Navigator.pop(context);
          }),
      body:  (cartViewData.addressListModel != null && widget.buynow == false) || widget.buynow == true
                    ?  SingleChildScrollView(
                      child:

                      ResponsiveWidget.isMediumScreen(context)
                          ?  Column(
                        children: [
                          cartPageViewIndicator(context,1),
                          // Address Button
                          AddressButton(context, () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return  ShippingAddressPage(isAlreadyAdded: false);
                                });
                          }),
                          cartViewData
                              .addressListModel?.length==0?Container(): Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenHeight - 500,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: cartViewData
                                    .addressListModel?.length,
                                itemBuilder: (context, index) {
                                  final addressItem = cartViewData.addressListModel?[index];
                                  cartViewData.selectedAddress = cartViewData.addressListModel?[cartViewData.selectedAddressIndex];
                                  return Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 8,top: 8,bottom: 10),
                                        margin:EdgeInsets.only(left: 5,right: 5,top: 8),
                                        color: Theme.of(context).cardColor,
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                cartViewData.selectedAddressIndex = index;
                                                cartViewData.selectedAddress = cartViewData.addressListModel?[cartViewData.selectedAddressIndex];
                                                addressId=cartViewData.selectedAddress?.addressId;
                                              },
                                              child: radioTileButton(cartViewData.selectedAddressIndex , index,),
                                            ),
                                            SizedBox(width: 10),
                                            InkWell(
                                              onTap: () {
                                                cartViewData.selectedAddressIndex = index;

                                                cartViewData.selectedAddress = cartViewData.addressListModel?[cartViewData.selectedAddressIndex];
                                                addressId=cartViewData.selectedAddress?.addressId;
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisSize:
                                                MainAxisSize.max,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .end,
                                                children: <Widget>[
                                                  AppMediumFont(context,
                                                      msg: (addressItem?.firstName?.toUpperCase() ?? '') +
                                                          " " +
                                                          (addressItem?.lastName?.toUpperCase() ?? ''),
                                                      color: Theme.of(context).canvasColor,
                                                      fontSize: 14.0),


                                                  Container(
                                                    margin: EdgeInsets.only(top: 1),
                                                    width: SizeConfig.screenWidth*0.25,
                                                    child: AppRegularFont(context,
                                                        msg: (addressItem?.firstAddress ?? '') +
                                                            ", " +
                                                            (addressItem?.secondAddress ??
                                                                '') +
                                                            ", " +
                                                            (addressItem?.cityName ?? '') +", " +
                                                            "\n" +
                                                            (addressItem?.state ?? '') +
                                                            " - " +
                                                            (addressItem?.pinCode.toString() ?? '') +
                                                            "\n" +"\n"+
                                                            (addressItem?.mobileNumber ?? ''),
                                                        color: Theme.of(context).canvasColor,
                                                        fontSize: 14.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          right: 20,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              size: 18,
                                              color:
                                              Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            onPressed: () {
                                              cartViewModel.deleteAddress(context,cartViewData.addressListModel?[index].addressId ?? "").whenComplete(() => {
                                                cartViewData.selectedAddressIndex=0
                                              });
                                            },
                                          )),
                                      Positioned(
                                          bottom: 0,
                                          right: 50,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                size: 18,
                                                color:
                                                Theme.of(context).primaryColor,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return  ShippingAddressPage(isAlreadyAdded: true,
                                                        addressId: cartViewData.addressListModel?[index].addressId,
                                                        firstName: cartViewData.addressListModel?[index].firstName,
                                                        lastName: cartViewData.addressListModel?[index].lastName,
                                                        mobileNumber: cartViewData.addressListModel?[index].mobileNumber,
                                                        email: cartViewData.addressListModel?[index].email,
                                                        firstAddress: cartViewData.addressListModel?[index].firstAddress,
                                                        secondAddress: cartViewData.addressListModel?[index].secondAddress,
                                                        state: cartViewData.addressListModel?[index].state,
                                                        cityName: cartViewData.addressListModel?[index].cityName,
                                                        pinCode: cartViewData.addressListModel?[index].pinCode,
                                                      );
                                                    });
                                              })
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          // Card(
                          //   child: Container(
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       mainAxisSize: MainAxisSize.max,
                          //       mainAxisAlignment: MainAxisAlignment.end,
                          //       children: <Widget>[
                          //         Padding(
                          //             padding:
                          //             EdgeInsets.only(left: 10, top: 10,bottom: 10),
                          //             child: AppBoldFont(context,
                          //                 msg: "SelectPayment",
                          //                 fontSize: 16.0)),
                          //         Divider(
                          //           height: 1,
                          //           color:
                          //           Theme.of(context).canvasColor,
                          //         ),
                          //         Theme(
                          //             data: ThemeData(
                          //               unselectedWidgetColor:
                          //               Theme.of(context).canvasColor,
                          //             ),
                          //             child: RadioListTile(
                          //               value: 1,
                          //               groupValue: selectedRadioTile,
                          //               title: AppBoldFont(context,
                          //                   msg: StringConstant.cardWalletsText,
                          //                   fontSize: 14.0),
                          //               onChanged: (val) {
                          //                 print("Radio Tile pressed $val");
                          //                 if (val == 1) {
                          //                   setSelectedRadioTile(1);
                          //                 }
                          //                 setState(() {
                          //                   google_pay = true;
                          //                 });
                          //               },
                          //               activeColor:
                          //               Theme.of(context).primaryColor,
                          //               selected: google_pay,
                          //             )),
                          //         SizedBox(height: 5)
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Container(
                            color: Theme.of(context).cardColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 20, top: 8, bottom: 10),
                                    child: AppBoldFont(context, msg: StringConstant.selectPayment)),
                                Divider(
                                  color: Theme.of(context).canvasColor,
                                  thickness: 0.2,
                                  height: 1,
                                ),
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor:
                                    Theme.of(context).canvasColor,
                                  ),
                                  child: RadioListTile(
                                    tileColor: Theme.of(context).canvasColor,
                                    value: 1, dense: true,
                                    groupValue: selectedRadioTile,
                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                    visualDensity: VisualDensity.compact,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    title: AppBoldFont(context,
                                        msg: StringConstant.cardWalletsText,
                                        fontSize: 14.0),
                                    onChanged: (val) {
                                      print("Radio Tile pressed $val");
                                      if (val == 1) {
                                        setSelectedRadioTile(1);
                                      }
                                      setState(() {
                                        google_pay = true;
                                        cod = false;
                                      });
                                    },
                                    activeColor: Theme.of(context).primaryColor,
                                    selected: google_pay,
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).canvasColor,
                                  thickness: 0.2,
                                  height: 1,
                                ),
                                GlobalVariable.cod==true?
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor:
                                    Theme.of(context).canvasColor,
                                  ),
                                  child: RadioListTile(
                                    visualDensity: VisualDensity.compact,
                                    tileColor: Theme.of(context).canvasColor,
                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                    dense: true,
                                    value: 2, groupValue: selectedRadioTile,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    title: AppBoldFont(context,
                                        msg: 'COD (Cash On Delivery)',
                                        fontSize: 14.0),
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
                                ):
                                SizedBox(),

                              ],
                            ),
                          ),
                          // Total Bill detail
                          widget.buynow==true? Card(
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
                          ):
                          Card(
                            child: Column(
                                children: cartViewModel.cartListData!.checkoutDetails!
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
                          ),
                         // billCardMobile(context,cartViewModel),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Material(
                                color:
                                Theme.of(context).scaffoldBackgroundColor,
                                child: Checkbox(
                                  checkColor: Theme.of(context).primaryColor,
                                  activeColor: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(0.8),
                                  side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(
                                        width: 1.0,
                                        color: Theme.of(context)
                                            .canvasColor
                                            .withOpacity(0.8)),
                                  ),
                                  value: agree,
                                  onChanged: (value) {
                                    setState(() {
                                      agree = value!;
                                    });
                                  },
                                ),
                              ),
                              AppMediumFont(context,
                                  msg: "Accept ", fontSize: 16.0),
                              InkWell(
                                  onTap: () {

                                  },
                                  child: AppMediumFont(context,
                                      msg: "Return Policy",
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16.0)),
                              AppRegularFont(context,
                                  msg: " and ", fontSize: 16.0),
                              InkWell(
                                  onTap: () {

                                  },
                                  child: AppMediumFont(context,
                                      msg: "Terms Of Use",
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16.0)),
                            ],
                          ),
                          SizedBox(height: 10),
                          // ElevatedButton(onPressed: (){
                          //   if (google_pay != true) {
                          //     ToastMessage.message(StringConstant.selectPaymentOption);
                          //   } else if (agree == false) {
                          //     ToastMessage.message(StringConstant.acceptReturnPolicy);
                          //   }
                          //   else if (cartViewModel.addressListModel?.length ==0) {
                          //     ToastMessage.message("please add address");
                          //   }
                          //   else if ((cod == true || google_pay == true) && (agree == true)) {
                          //     var amount = 10;
                          //     //double.parse(cartViewModel.cartListData?.checkoutDetails?.totalPayableAmount ?? '1');
                          //     if (amount != 0 && cartViewModel.addressListModel?.length!=0) {
                          //      // widget.buynow==true?createOrder(cartListData?.cartList?[0].productId ?? "",cartListData?.cartList?[0].productDetails?.variantId ??'',cartListData?.checkoutDetails?.totalItems.toString() ??"",context):  createOrder('','','',context);
                          //       widget.buynow==true?createOrder(cartListData?.cartList?[0].productId ?? "",cartListData?.cartList?[0].productDetails?.variantId ??'',cartListData?.checkoutDetails?.elementAt(0)
                          //           .value ??
                          //           "",context):  createOrder('','','',context);
                          //
                          //     }
                          //   }
                          //
                          // }, child: Text("checkout",style: TextStyle(fontSize: 18),)),

                         SizedBox(height: 10),
                          footerMobile(context)
                        ],
                      ):
                      Column(
                        children: [
                          cartPageViewIndicator(context,1),
                          // Address Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  AddressButton(context, () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return  ShippingAddressPage(isAlreadyAdded: false);
                                        });
                                  }),
                                  // Address Details
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    width: SizeConfig.screenWidth*0.30,
                                    height: SizeConfig.screenHeight - 300,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: cartViewData
                                            .addressListModel?.length,
                                        itemBuilder: (context, index) {
                                          final addressItem = cartViewData.addressListModel?[index];
                                          cartViewData.selectedAddress = cartViewData.addressListModel?[cartViewData.selectedAddressIndex];
                                          return Stack(
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth*0.30,
                                                padding: EdgeInsets.only(left: 8,top: 8,bottom: 10),
                                                margin:EdgeInsets.only(left: 5,right: 5,top: 8),
                                                color: Theme.of(context).cardColor,
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: (){
                                                        cartViewData.selectedAddressIndex = index;
                                                        cartViewData.selectedAddress = cartViewData.addressListModel?[cartViewData.selectedAddressIndex];
                                                        addressId=cartViewData.selectedAddress?.addressId;
                                                      },
                                                      child: radioTileButton(cartViewData.selectedAddressIndex , index,),
                                                    ),
                                                    SizedBox(width: 10),
                                                    InkWell(
                                                      onTap: () {
                                                        cartViewData.selectedAddressIndex = index;

                                                        cartViewData.selectedAddress = cartViewData.addressListModel?[cartViewData.selectedAddressIndex];
                                                        addressId=cartViewData.selectedAddress?.addressId;
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisSize:
                                                        MainAxisSize.max,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .end,
                                                        children: <Widget>[
                                                          AppMediumFont(context,
                                                              msg: (addressItem?.firstName?.toUpperCase() ?? '') +
                                                                  " " +
                                                                  (addressItem?.lastName?.toUpperCase() ?? ''),
                                                              color: Theme.of(context).canvasColor,
                                                              fontSize: 14.0),


                                                          Container(
                                                            margin: EdgeInsets.only(top: 1),
                                                            width: SizeConfig.screenWidth*0.25,
                                                            child: AppRegularFont(context,
                                                                msg: (addressItem?.firstAddress ?? '') +
                                                                    ", " +
                                                                    (addressItem?.secondAddress ??
                                                                        '') +
                                                                    ", " +
                                                                    (addressItem?.cityName ?? '') +", " +
                                                                    "\n" +
                                                                    (addressItem?.state ?? '') +
                                                                    " - " +
                                                                    (addressItem?.pinCode.toString() ?? '') +
                                                                    "\n" +"\n"+
                                                                    (addressItem?.mobileNumber ?? ''),
                                                                color: Theme.of(context).canvasColor,
                                                                fontSize: 14.0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: 0,
                                                  right: 20,
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: 18,
                                                      color:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    onPressed: () {
                                                      cartViewModel.deleteAddress(context,cartViewData.addressListModel?[index].addressId ?? "").whenComplete(() => {
                                                        cartViewData.selectedAddressIndex=0
                                                      });
                                                    },
                                                  )),
                                              Positioned(
                                                  bottom: 0,
                                                  right: 50,
                                                  child: IconButton(
                                                      icon: Icon(
                                                        Icons.edit,
                                                        size: 18,
                                                        color:
                                                        Theme.of(context).primaryColor,
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return  ShippingAddressPage(isAlreadyAdded: true,
                                                              addressId: cartViewData.addressListModel?[index].addressId,
                                                              firstName: cartViewData.addressListModel?[index].firstName,
                                                              lastName: cartViewData.addressListModel?[index].lastName,
                                                                mobileNumber: cartViewData.addressListModel?[index].mobileNumber,
                                                                email: cartViewData.addressListModel?[index].email,
                                                                firstAddress: cartViewData.addressListModel?[index].firstAddress,
                                                                secondAddress: cartViewData.addressListModel?[index].secondAddress,
                                                                state: cartViewData.addressListModel?[index].state,
                                                                cityName: cartViewData.addressListModel?[index].cityName,
                                                                pinCode: cartViewData.addressListModel?[index].pinCode,
                                                              );
                                                            });
                                                      })
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ],
                              ),
                              Column(children: [

                                SizedBox(height: 5),
                                // Total Bill detail
                               widget.buynow==true? Card(
                                 elevation: 0.2,
                                 child: Column(
                                     children:  cartListData!.checkoutDetails!
                                         .map((e){
                                       return Container(
                                         width: SizeConfig.screenWidth/3.22,
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
                               ):
                                Card(
                                  elevation: 0.2,
                                 child: Column(
                                     children: cartViewModel.cartListData!.checkoutDetails!
                                         .map((e){
                                       return Container(
                                         width: SizeConfig.screenWidth/3.22,
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
                              //   Card(
                              //     elevation: 0.2,
                              //   child: Container(
                              //     width: SizeConfig.screenWidth/3.22,
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       mainAxisSize: MainAxisSize.max,
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       children: <Widget>[
                              //         Padding(
                              //             padding:
                              //             EdgeInsets.only(left: 10, top: 10,bottom: 10),
                              //             child: AppBoldFont(context,
                              //                 msg: "SelectPayment",
                              //                 fontSize: 16.0)),
                              //         Divider(
                              //           height: 1,
                              //           color:
                              //           Theme.of(context).canvasColor,
                              //         ),
                              //         Theme(
                              //             data: ThemeData(
                              //               unselectedWidgetColor:
                              //               Theme.of(context).canvasColor,
                              //             ),
                              //             child: RadioListTile(
                              //               value: 1,
                              //               groupValue: selectedRadioTile,
                              //               title: AppBoldFont(context,
                              //                   msg: StringConstant.cardWalletsText,
                              //                   fontSize: 14.0),
                              //               onChanged: (val) {
                              //                 print("Radio Tile pressed $val");
                              //                 if (val == 1) {
                              //                   setSelectedRadioTile(1);
                              //                 }
                              //                 setState(() {
                              //                   google_pay = true;
                              //                 });
                              //               },
                              //               activeColor:
                              //               Theme.of(context).primaryColor,
                              //               selected: google_pay,
                              //             )),
                              //         SizedBox(height: 5)
                              //       ],
                              //     ),
                              //   ),
                              // ),

                                Container(
                                  width: SizeConfig.screenWidth/3.22,
                                  color: Theme.of(context).cardColor,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(left: 20, top: 8, bottom: 10),
                                          child: AppBoldFont(context, msg: StringConstant.selectPayment)),
                                      Divider(
                                        color: Theme.of(context).canvasColor,
                                        thickness: 0.2,
                                        height: 1,
                                      ),
                                      Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor:
                                          Theme.of(context).canvasColor,
                                        ),
                                        child: RadioListTile(
                                          tileColor: Theme.of(context).canvasColor,
                                          value: 1, dense: true,
                                          groupValue: selectedRadioTile,
                                          materialTapTargetSize: MaterialTapTargetSize.padded,
                                          visualDensity: VisualDensity.compact,
                                          contentPadding: EdgeInsets.only(left: 8),
                                          title: AppBoldFont(context,
                                              msg: StringConstant.cardWalletsText,
                                              fontSize: 14.0),
                                          onChanged: (val) {
                                            print("Radio Tile pressed $val");
                                            if (val == 1) {
                                              setSelectedRadioTile(1);
                                            }
                                            setState(() {
                                              google_pay = true;
                                              cod = false;
                                            });
                                          },
                                          activeColor: Theme.of(context).primaryColor,
                                          selected: google_pay,
                                        ),
                                      ),
                                      Divider(
                                        color: Theme.of(context).canvasColor,
                                        thickness: 0.2,
                                        height: 1,
                                      ),

                                      GlobalVariable.cod==true? Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor:
                                          Theme.of(context).canvasColor,
                                        ),
                                        child: RadioListTile(
                                          visualDensity: VisualDensity.compact,
                                          tileColor: Theme.of(context).canvasColor,
                                          materialTapTargetSize: MaterialTapTargetSize.padded,
                                          dense: true,
                                          value: 2, groupValue: selectedRadioTile,
                                          contentPadding: EdgeInsets.only(left: 8),
                                          title: AppBoldFont(context,
                                              msg: 'COD (Cash On Delivery)',
                                              fontSize: 14.0),
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
                                      ):SizedBox()

                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Material(
                                      color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                      child: Checkbox(
                                        checkColor: Theme.of(context).primaryColor,
                                        activeColor: Theme.of(context)
                                            .canvasColor
                                            .withOpacity(0.8),
                                        side: MaterialStateBorderSide.resolveWith(
                                              (states) => BorderSide(
                                              width: 1.0,
                                              color: Theme.of(context)
                                                  .canvasColor
                                                  .withOpacity(0.8)),
                                        ),
                                        value: agree,
                                        onChanged: (value) {
                                          setState(() {
                                            agree = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    AppMediumFont(context,
                                        msg: "Accept ", fontSize: 16.0),
                                    InkWell(
                                        onTap: () {

                                        },
                                        child: AppMediumFont(context,
                                            msg: "Return Policy",
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 16.0)),
                                    AppRegularFont(context,
                                        msg: " and ", fontSize: 16.0),
                                    InkWell(
                                        onTap: () {

                                        },
                                        child: AppMediumFont(context,
                                            msg: "Terms Of Use",
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 16.0)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                ElevatedButton(onPressed: (){
                                  if (agree != true) {
                                    ToastMessage.message(StringConstant.acceptReturnPolicy);
                                  } else if ((google_pay == true) && (agree == true)) {
                                    widget.buynow==true?
                                    createOrder("online",cartListData?.cartList?[0].productId ?? "",cartListData?.cartList?[0].productDetails?.variantId ??'',cartListData?.checkoutDetails?.elementAt(0)
                                        .value ??
                                        "",context,addressId: addressId):
                                    createOrder("online",'','','',context,addressId: addressId);
                                  } else if ((cod == true) && (agree == true)){
                                    print('order with cod options');
                                    widget.buynow==true?
          createOrder("cod",cartListData?.cartList?[0].productId ?? "",cartListData?.cartList?[0].productDetails?.variantId ??'',cartListData?.checkoutDetails?.elementAt(0)
              .value ??
          "",context,addressId: addressId):
          createOrder("cod",'','','',context,addressId: addressId);
                                  }

                                  else {
                                    ToastMessage.message(StringConstant.selectPaymentOption);
                                  }},
                      //
                      // if (google_pay != true) {
                      //   ToastMessage.message(StringConstant.selectPaymentOption);
                      // } else if (agree == false) {
                      //   ToastMessage.message(StringConstant.acceptReturnPolicy);
                      // }
                      // else if (cartViewModel.addressListModel?.length ==0) {
                      //   ToastMessage.message("please add address");
                      // }
                      // else if ((cod == true || google_pay == true) && (agree == true)) {
                      //   var amount=10;
                      // //  var amount = double.parse(cartViewModel.cartListData?.checkoutDetails?.totalPayableAmount ?? '1');
                      //    if (amount != 0 && cartViewModel.addressListModel?.length!=0) {
                      //
                      //
                      //
                      //   }
                      // }

                      child: Text("checkout",style: TextStyle(fontSize: 18),))

                              ],)
                            ],
                          ),
                          SizedBox(height: 50),
                          footerDesktop()
                        ],
                      ),
                    )

                    : Center(
                        child: ThreeArchedCircle(size: 45.0),
                      ));
              }));
  }

  // payment selection
  setSelectedRadioTile(int val) {
    selectedRadioTile = val;
  }

  Future<void> createOrder(String paymentMethod,String productId,String variantId,String quantity,BuildContext context,{String? addressId, String? gateway}) async {
    AppIndicator.loadingIndicator(context);
    _cartRepo.createOrder(paymentMethod,productId,variantId,quantity, gateway,context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        _createOrderModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        if(paymentMethod == "online"){
          openPaymentGateway(_createOrderModel);
        }
      // openPaymentGateway(_createOrderModel);
        else{
        cartViewModel.placeOrder(context,  addressId ?? '', '',"",
            paymentMethod,
            widget.buynow==true?cartListData?.cartList![0].productId ?? "":'',
            widget.buynow==true?cartListData?.cartList![0].productDetails?.variantId ?? "" :'',
            widget.buynow==true?cartListData?.checkoutDetails!.elementAt(0).value ?? "":'',
            'Success');
      }

      }
    });
  }

  void openPaymentGateway(CreateOrderModel? createOrderModel) async{
    double total=double.parse(createOrderModel?.total ??"");
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
    // razorPay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    cartViewModel.paymentResponse(
        context,
        createOrderModel?.receipt ?? '',
        response.orderId,
        response.paymentId,
        'Success',
        '',
        addressId ?? '');

    cartViewModel.placeOrder(context,  addressId ?? '', response.paymentId,
        response.orderId, 'Online',
        widget.buynow==true?cartListData?.cartList![0].productId ?? "":'',
        widget.buynow==true?cartListData?.cartList![0].productDetails?.variantId ?? "" :'',
        widget.buynow==true?cartListData?.checkoutDetails!.elementAt(0).value ?? "":'',
        'Success');

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response.message);
    print('Error Response: $response');
    Fluttertoast.showToast(msg: "ERROR: ${response.code} - ${response.message!}", toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ${response.walletName!}", toastLength: Toast.LENGTH_SHORT);
  }
  radioTileButton(int? selectedAddressIndex, int index){
    return CircleAvatar(
      radius: 12,
      backgroundColor: Theme.of(context).canvasColor,
      child: CircleAvatar(
        radius: 10,
        backgroundColor: WHITE_COLOR,
        child: CircleAvatar(
          radius: 8,
          backgroundColor: selectedAddressIndex == index? Theme.of(context).primaryColor: WHITE_COLOR,
        ),
      ),
    );
  }
}
