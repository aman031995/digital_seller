import 'package:TychoStream/model/data/order_data_model.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/order_view_model.dart';
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
  @override
  void initState() {
    orderView.getOrderDetail(context,widget.orderItem?.orderId ??" ");

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return ChangeNotifierProvider.value(
        value: orderView,
        child: Consumer<OrderViewModel>(builder: (context, orderView, _) {
          return AlertDialog(
              elevation: 8,
              backgroundColor:Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
              contentPadding: EdgeInsets.zero,
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              content: checkInternet == "Offline"
                  ? NOInternetScreen()
                  : SingleChildScrollView(
                    child: Container(
                      width: 500,
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      AppMediumFont(context,
                          msg: StringConstant.orderDetailed+' - ${widget.orderItem?.orderId}'),
                      SingleChildScrollView(
                        child: Container(
                          height: 190.0* widget.orderItem!.itemDetails!.length,
                          child: ListView.builder(
                            itemCount: widget.orderItem?.itemDetails?.length,
                              physics:ScrollPhysics(),
                              itemBuilder: (context,index){
                            return itemView(index);
                          }),
                        ),
                      ),
                      shippingDetails(),
                      priceDetails(),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                ),
              ),
                  )
            // : Center(child: ThreeArchedCircle(size: 45.0)),
          );
        }));
  }
  //ItemsView Method
  itemView(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Theme
              .of(context)
              .cardColor
              .withOpacity(0.9),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),

      height: 170,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 10, bottom: 10),
       padding: EdgeInsets.only(left: 20,top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 300,
                    child: AppBoldFont(context,
                        msg: '${widget.orderItem?.itemDetails?[index].productDetails?.productVariantTitle}', fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      AppMediumFont(
                          context,
                          msg: "₹" +
                              "${widget.orderItem?.itemDetails?[index].productDetails?.productDiscountPrice}",
                          fontSize: 16.0),
                      SizedBox(width: 5),

                      AppMediumFont(
                          context,
                          msg: "${widget.orderItem?.itemDetails?[index].productDetails?.productPrice}",
                          textDecoration:
                          TextDecoration
                              .lineThrough,
                          fontSize: 14.0),
                      SizedBox(width: 5),
                      AppMediumFont(
                          context,
                          msg: "${widget.orderItem?.itemDetails?[index].productDetails?.productDiscountPercent}" +
                              r" % OFF",
                          color: Colors
                              .green,
                          fontSize: 14.0),
                      SizedBox(width: 5),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AppRegularFont(context,
                      msg: "Size"+'- ${widget.orderItem?.itemDetails?[index].productDetails?.productSize}', fontSize: 16.0),
                  SizedBox(
                    height: 5,
                  ),
                  AppRegularFont(context,
                      msg: "color"+'- ${widget.orderItem?.itemDetails?[index].productDetails?.productColor}', fontSize: 16.0),
                  SizedBox(
                    height: 5,
                  ),
                  AppRegularFont(context,
                      msg: "Qty"+'- ${widget.orderItem?.itemDetails?[index].cartQuantity}', fontSize: 16.0),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
              InkWell(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network('${widget.orderItem?.itemDetails?[index].productDetails?.productImages?[0]}',
                      height: 150,
                      width: 150,fit: BoxFit.fill,
                    ),
                  )),
              SizedBox(width: 10)
            ],
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
                  .cardColor,
              thickness: 1,
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
  priceDetails() {
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
              AppBoldFont(context, msg: StringConstant.priceDetails),
              Divider(color: Theme
                  .of(context)
                  .cardColor, thickness: 1),
              priceDetailWidget(
                  context, StringConstant.basePrice, "₹ " + '${widget.orderItem?.totalPrice}'),
              SizedBox(height: 3),
              priceDetailWidget(
                  context, StringConstant.discountedPrice, "₹ " +'${widget.orderItem?.discountedprice}'),
              SizedBox(height: 3),
              priceDetailWidget(context, StringConstant.shipping, "₹ " + '${widget.orderItem?.shippingCharge}'),
              SizedBox(height: 5),
              Divider(
                height: 1,
                thickness: 0.6,
                color: Theme
                    .of(context)
                    .canvasColor,
              ),
              SizedBox(height: 5),
              priceDetailWidget(
                  context, StringConstant.totalAmount, "₹ " + '${widget.orderItem?.totalPaidAmount}'),
              SizedBox(height: 8)
            ]));
  }

}
