import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/model/data/order_data_model.dart';
import 'package:TychoStream/model/data/order_detail_model.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/order_history/bottom_nav_button.dart';
import 'package:TychoStream/view/widgets/AppDialog.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/viewmodel/order_view_model.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  OrderList? orderItem;
   Function? callback;
   OrderDetails({Key? key,this.orderItem,this.callback}) : super(key: key);
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final OrderViewModel orderView = OrderViewModel();
  String? checkInternet;
bool? isCancel;
  void initState() {
    orderView.getOrderDetails(context, '${widget.orderItem?.orderItemId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: orderView,
        child: Consumer<OrderViewModel>(builder: (context, order, _) {
          return AlertDialog(
              elevation: 0.8,
              buttonPadding: EdgeInsets.zero,
              actionsPadding: EdgeInsets.zero,
              backgroundColor:Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
              contentPadding: EdgeInsets.zero,
              content: order.orderDetailModel!=null? SingleChildScrollView(
                child:
             Container(
                      width: 500,
                  margin: EdgeInsets.only(left: ResponsiveWidget.isMediumScreen(context)
                      ?10:15.0, right:ResponsiveWidget.isMediumScreen(context)
                      ?10: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            child: Container(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    widget.callback!(isCancel);

                                  }, icon: Image.asset(AssetsConstants.icCross, color: Theme.of(context).canvasColor)),
                            ),
                          )
                        ],
                      ),


                      itemView(order),
                       shippingDetails(order),
                       priceDetails(order.orderDetailModel),
                      order.orderDetailModel?.orderStatus == "Failed" ?
                      Container() :  Container(
                          margin: EdgeInsets.only(top: 8, bottom: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor.withOpacity(0.9),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          padding: EdgeInsets.only(left: 20),
                          child: AnotherStepper(
                              stepperDirection: Axis.vertical,
                              iconWidth: 25,
                              iconHeight: 25,
                              activeBarColor: GREEN,
                              inActiveBarColor: Theme.of(context).canvasColor.withOpacity(0.4),
                              inverted: false,
                              verticalGap: 20,
                              activeIndex: orderView.orderDetailModel!.orderTracking!.activeIndex! -1,
                              barThickness: 2,
                              stepperList:_stepperList(context,orderView.orderDetailModel)

                          )),
                      order.orderDetailModel?.orderStatus == 'Order Confirmed' ?
                      BottomNavButton(needHelpTap: () {

                        context.router.push(ContactUs());
                      },
                          cancelTap: (){
                            cancelTap(orderView, order.orderDetailModel);

                          } )
                          : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              )

             : Container(
                  width: 500,height: 800,
                  child: Center(child: ThreeArchedCircle(size: 45.0))),
          );
        }));
  }

  String? getMaterialType(OrderViewModel order) {
    if(order.orderDetailModel!.variationSku!.materialType!.name!.length > 35) {
      return order.orderDetailModel!.variationSku!.materialType!.name!.replaceRange(35, order.orderDetailModel!.variationSku!.materialType!.name!.length, '...');
    } else {
      return order.orderDetailModel!.variationSku!.materialType!.name!;
    }

  }

  String? getTitle(OrderViewModel order) {
    if(order.orderDetailModel!.productName!.length > 35) {
      return order.orderDetailModel!.productName!.replaceRange(35, order.orderDetailModel!.productName!.length, '...');
    } else {
      return order.orderDetailModel!.productName! ;
    }
  }

  productDetailTopView(OrderViewModel order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppBoldFont(context, msg: StringConstant.orderDetailed+'-${order.orderDetailModel?.orderId}', fontSize: 13),
        AppRegularFont(context, msg: '${order.orderDetailModel?.orderDate}', fontSize: 13)
      ],
    );
  }
  productDetailTopViewMobile(OrderViewModel order) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBoldFont(context, msg: StringConstant.orderDetailed+'-${order.orderDetailModel?.orderId}', fontSize: 13),
        AppRegularFont(context, msg: '${order.orderDetailModel?.orderDate}', fontSize: 13)
      ],
    );
  }

  priceView(OrderViewModel order) {
    return Row(
      children: [
        AppMediumFont(
            context,
            msg: "₹" + "${order.orderDetailModel?.productFinalPrice}",
            fontSize: 16.0),

      ],
    );
  }
  //ItemsView Method
  itemView(OrderViewModel order) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.9),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      width:ResponsiveWidget.isMediumScreen(context)
          ?SizeConfig.screenWidth:500,
      margin: EdgeInsets.only( bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: EdgeInsets.only(top: 10, left: ResponsiveWidget.isMediumScreen(context)
                ?10:20, right:ResponsiveWidget.isMediumScreen(context)
                ?0: 15),
            child:ResponsiveWidget.isMediumScreen(context)
                ?productDetailTopViewMobile(order): productDetailTopView(order),
          ),
          Divider(
            color: Theme.of(context).canvasColor,
            thickness: 0.2,
          ),
          Container(
            padding: EdgeInsets.only(left:ResponsiveWidget.isMediumScreen(context)
                ?10: 20, right: ResponsiveWidget.isMediumScreen(context)
                ?8:15),
            margin: EdgeInsets.only(top: 10.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width:ResponsiveWidget.isMediumScreen(context)
                      ?150:300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBoldFont(context,maxLines: 2, msg: getTitle(order), fontSize: 14.0),
                      SizedBox(height: 5),
                      AppMediumFont(
                          context,
                          msg: "₹" + "${order.orderDetailModel?.productFinalPrice}",
                          fontSize: 16.0),
                      AppRegularFont(context, msg:"Quantity - "+ "${orderView.orderDetailModel?.quantity}", fontSize: 16.0),
                      order.orderDetailModel?.variationSku?.color?.name != null ?
                      RichText(
                          text: TextSpan(
                              text:
                              'Color  :  ',
                              style: TextStyle(
                                  fontSize:
                                  16,
                                  fontWeight:
                                  FontWeight
                                      .w400,
                                  color: Theme.of(context).canvasColor,
                                  fontFamily: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.fontFamily),
                              children: <InlineSpan>[
                                TextSpan(
                                    style: TextStyle(
                                        fontSize:
                                        16,
                                        fontWeight: FontWeight
                                            .w400,
                                        color: Theme.of(context).canvasColor.withOpacity(
                                            0.7),
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.fontFamily),
                                    text: '${order.orderDetailModel?.variationSku?.color?.name}'
                                )
                              ]))
                          : SizedBox(),
                      order.orderDetailModel?.variationSku?.size?.name != null ?
                      RichText(
                          text: TextSpan(
                              text:
                              'Size  :  ',
                              style: TextStyle(
                                  fontSize:
                                  16,
                                  fontWeight:
                                  FontWeight.w400,
                                  color: Theme.of(context).canvasColor,
                                  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                              children: <InlineSpan>[
                                TextSpan(
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).canvasColor.withOpacity(0.7),
                                        fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                    text: '${order.orderDetailModel?.variationSku?.size?.name}'
                                )
                              ]))
                          : SizedBox(),
                      order.orderDetailModel?.variationSku?.style?.name != null ?
                      RichText(
                          text: TextSpan(
                              text:
                              'Style  :  ',
                              style: TextStyle(
                                  fontSize:
                                  16,
                                  fontWeight:
                                  FontWeight
                                      .w400,
                                  color:Theme.of(context).canvasColor,
                                  fontFamily: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.fontFamily),
                              children: <InlineSpan>[
                                TextSpan(
                                  style: TextStyle(
                                      fontSize:
                                      16,
                                      fontWeight: FontWeight
                                          .w400,
                                      color: Theme.of(context).canvasColor.withOpacity(
                                          0.7),
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.fontFamily),
                                  text: '${order.orderDetailModel?.variationSku?.style?.name}',
                                )
                              ]))
                          : SizedBox(),
                      order.orderDetailModel?.variationSku?.materialType?.name != null ?
                      RichText(
                          text: TextSpan(
                              text: 'MaterialType  :  ',
                              style: TextStyle(fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).canvasColor,
                                  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                              children: <InlineSpan>[
                                TextSpan(
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w400,
                                      color: Theme.of(context).canvasColor.withOpacity(0.7),
                                      fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                                  text: '${getMaterialType(order)}',
                                )
                              ]))
                          : SizedBox(),
                      order.orderDetailModel?.variationSku?.unitCount?.name != null ?
                      RichText(
                          text: TextSpan(
                              text:
                              'UnitCount  :  ',
                              style: TextStyle(
                                  fontSize:
                                  16,
                                  fontWeight:
                                  FontWeight
                                      .w400,
                                  color:Theme.of(context).canvasColor,
                                  fontFamily: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.fontFamily),
                              children: <InlineSpan>[
                                TextSpan(
                                  style: TextStyle(
                                      fontSize:
                                      16,
                                      fontWeight: FontWeight
                                          .w400,
                                      color: Theme.of(context).canvasColor.withOpacity(
                                          0.7),
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.fontFamily),
                                  text: '${order.orderDetailModel?.variationSku?.unitCount?.name}',
                                )
                              ]))
                          : SizedBox(),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
                InkWell(
                    onTap: (){},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.network('${order.orderDetailModel?.productImages?[0] ?? ""}',
                        height:ResponsiveWidget.isMediumScreen(context)
                            ?60: 120,
                        width: ResponsiveWidget.isMediumScreen(context)
                            ?60:120,fit: BoxFit.fill,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }


  //Shipping Details Method
  shippingDetails(OrderViewModel order) {
    return Container(
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .cardColor
                .withOpacity(0.9),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        width: SizeConfig.screenWidth,
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            AppBoldFont(context, msg: StringConstant.shippingDetails),
            Divider(
              color: Theme
                  .of(context)
                  .canvasColor,
              thickness: 0.2,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: AppMediumFont(context,
                  msg: '${order.orderDetailModel?.shippingAddress?.firstName}' +' ${order.orderDetailModel?.shippingAddress?.lastName}'
                      "\n" +
                      '${order.orderDetailModel?.shippingAddress?.firstAddress},' +
                      "\n" +
                      '${order.orderDetailModel?.shippingAddress?.secondAddress},'+'${order.orderDetailModel?.shippingAddress?.landmark},'
                      "\n" +
                      '${order.orderDetailModel?.shippingAddress?.cityName}, ' +'${order.orderDetailModel?.shippingAddress?.state},'+
                      "\n" +
                      '${order.orderDetailModel?.shippingAddress?.pinCode},'
                      "\n" +
                      "Phone:- ${order.orderDetailModel?.shippingAddress?.mobileNumber}"),
            ),
            SizedBox(height: 10),
          ],
        ));
  }
  //Price Details Method
  priceDetails(OrderDetailModel? orderDetailModel) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Theme.of(context).cardColor.withOpacity(0.9),
        ),
        width: SizeConfig.screenWidth,
        alignment: Alignment.topLeft,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(padding: EdgeInsets.only(left: 20, right: 20,top: 8,bottom: 8), child: AppBoldFont(context, msg: StringConstant.priceDetails)),
              Divider(
                color: Theme.of(context).canvasColor,
                thickness: 0.2,
                height: 1,
              ),
              SizedBox(height: 8),

              Container(child: _priceList(orderDetailModel?.checkoutDetails)),
              SizedBox(height: 8)
            ]));
  }
  _priceList(List<FinalCheckOut>? finalCheckOut){
    return Column(
        children: finalCheckOut!.map((e) {
          return Column(
            children: [
              priceDetailWidget(
                  context,
                  e.name ?? "",
                  e.value ?? ""),
            ],
          );
        }).toList());
  }

  List<StepperData> _stepperList(BuildContext context, OrderDetailModel? orderView) {
    return orderView?.orderTracking?.trackStatus?.map((e) {
      return StepperData(
        title: StepperText('${e.displayOrder}',
          textStyle: TextStyle(color: (orderView.orderTracking!.activeIndex! >= e.id!) ?
          Theme.of(context).canvasColor :
          Theme.of(context).canvasColor.withOpacity(0.4),),
        ),
        iconWidget: CircleAvatar(
          radius: 10,
          backgroundColor: e.displayOrder == 'Cancelled' ? RED_COLOR : (orderView.orderTracking!.activeIndex! >= e.id!) ? GREEN : Theme.of(context).canvasColor.withOpacity(0.4),
          child: e.displayOrder == 'Cancelled' ? Icon(Icons.close_outlined, size: 20, color: Theme.of(context).hintColor) : Icon(Icons.done, size: 20, color: Theme.of(context).hintColor),
        ),
      );
    }).toList() ?? []; // Use the null-aware operator to handle null case
  }
  void cancelTap(OrderViewModel orderView, OrderDetailModel? orderDetailModel) {
    AppDialog.cancelOrder(context, onTap: (){
      orderView.cancelOrder(context, orderDetailModel?.orderId ?? '',orderDetailModel?.orderItemId ?? '');
      isCancel = true;
      Navigator.of(context, rootNavigator: true).pop();
    });

  }

}
