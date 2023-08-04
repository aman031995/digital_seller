import 'package:TychoStream/model/data/order_data_model.dart';
import 'package:TychoStream/model/data/order_detail_model.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/order_view_model.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class OrderDetails extends StatefulWidget {
  OrderList? orderItem;
  OrderDetails({Key? key,this.orderItem}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final OrderViewModel orderView = OrderViewModel();
  String? checkInternet;

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
                child: Container(
                      width: 500,height: 810,
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      itemView(order),
                      shippingDetails(),
                      priceDetails(order.orderDetailModel),
                      Container(
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
                              activeIndex: orderView.orderDetailModel!.orderTracking!.activeIndex! -1 ?? 1,
                              barThickness: 2,
                              stepperList:_stepperList(context,orderView.orderDetailModel)

                          )),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
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
      return order.orderDetailModel!.variationSku!.materialType!.name! ?? "";
    }

    // if (widget.orderItem!.itemDetails![index].productDetails!.defaultVariationSku!.materialType!.name!.length > 35) {
    //   return widget.orderItem?.itemDetails?[index].productDetails?.defaultVariationSku?.materialType?.name!.replaceRange(
    //       35, widget.orderItem?.itemDetails?[index].productDetails?.defaultVariationSku?.materialType?.name!.length, '...');
    // } else {
    //   return widget.orderItem?.itemDetails?[index].productDetails?.defaultVariationSku?.materialType?.name ?? "";
    // }
  }

  String? getTitle(OrderViewModel order) {
    if(order.orderDetailModel!.productName!.length > 35) {
      return order.orderDetailModel!.productName!.replaceRange(35, order.orderDetailModel!.productName!.length, '...');
    } else {
      return order.orderDetailModel!.productName! ?? "";
    }

    // if (widget.orderItem!.itemDetails![index].productDetails!.productVariantTitle!.length > 35) {
    //   return widget.orderItem!.itemDetails![index].productDetails!.productVariantTitle!.replaceRange(
    //       35, widget.orderItem!.itemDetails![index].productDetails!.productVariantTitle!.length, '...');
    // } else {
    //   return widget.orderItem!.itemDetails![index].productDetails!.productVariantTitle! ?? "";
    // }
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

  priceView(OrderViewModel order) {
    return Row(
      children: [
        // AppMediumFont(
        //     context,
        //     // msg: "₹" + "${widget.orderItem?.itemDetails?[index].productDetails?.productPrice}",
        //     msg: "₹" + "${order.orderDetailModel?.totalPaidAmount}",
        //     textDecoration: TextDecoration.lineThrough,
        //     fontSize: 16.0),
        // SizedBox(width: SizeConfig.safeBlockVertical * 1),
        AppMediumFont(
            context,
            msg: "₹" + "${order.orderDetailModel?.productFinalPrice}",
            fontSize: 16.0),
        SizedBox(width: SizeConfig.safeBlockVertical * 1),
        // AppMediumFont(
        //     context,
        //     msg: "${widget.orderItem?.itemDetails?[index].productDetails?.productDiscountPercent}" + r"%OFF",
        //     color:GREEN, fontSize: 12.0),
      ],
    );
  }
  //ItemsView Method
  itemView(OrderViewModel order) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.9),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      width:500,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 10, bottom: 4),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 15),
            child: productDetailTopView(order),
          ),
          Divider(
            color: Theme.of(context).canvasColor,
            thickness: 0.2,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 15),
            margin: EdgeInsets.only(top: 10.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width:300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBoldFont(context,maxLines: 2, msg: getTitle(order), fontSize: 14.0),
                      SizedBox(height: 5),
                      priceView(order),
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
                                    // text: '${widget.orderItem?.itemDetails?[index].productDetails?.defaultVariationSku?.color?.name}',
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
                                    // text: '${widget.orderItem?.itemDetails?[index].productDetails?.defaultVariationSku?.size?.name}',
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
                      // child: Image.network('${widget.orderItem?.itemDetails?[index].productDetails?.productImages?[0]}',
                      child: Image.network('${order.orderDetailModel?.productImages?[0] ?? ""}',
                        height: 120,
                        width: 120,fit: BoxFit.fill,
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
  shippingDetails() {
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
        // padding: EdgeInsets.only(left: 20, right: 20),
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
                  msg: '${widget.orderItem?.shippingAddress?.firstName}' +' ${widget.orderItem?.shippingAddress?.lastName}'
                      "\n" +
                      '${widget.orderItem?.shippingAddress?.firstAddress},' +
                      "\n" +
                      '${widget.orderItem?.shippingAddress?.secondAddress},'+
                      "\n" +
                      '${widget.orderItem?.shippingAddress?.cityName},' +'${widget.orderItem?.shippingAddress?.state},'
                      "\n" +
                      '${widget.orderItem?.shippingAddress?.pinCode},'
                      "\n" +
                      "Phone: ${widget.orderItem?.shippingAddress?.mobileNumber}"),
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

    // return finalCheckOut?.map((e){
    //   priceDetailWidget(context, e.name ?? "", e.value ?? "");
    // }).toList();
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
}
