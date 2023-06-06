import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/Profile/order_details.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utilities/StringConstants.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({Key? key}) : super(key: key);

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {

  final OrderViewModel orderView = OrderViewModel();

  String? checkInternet;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  void initState() {
    orderView.getOrderList(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: orderView,
      child: Consumer<OrderViewModel>(builder: (context, orderview, _) {
        return

          Scaffold(
            key: _scaffoldKey,
              backgroundColor: Theme
                  .of(context)
                  .backgroundColor,
              appBar: getAppBarWithBackBtn(
                  title: StringConstant.myOrders,
                  isBackBtn: false,
                  context: context,
                  isShopping: false,
                  itemCount: "0",
                  onCartPressed: () {},
                  onBackPressed: () {
                    Navigator.pop(context, true);
                  }),


              body: checkInternet == "Offline"
                  ? NOInternetScreen()
                  : orderview.orderData !=null?
              SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                          height: SizeConfig.screenHeight/1.2,
                          width: SizeConfig.screenWidth/3.5,
                          child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 20),
                              itemCount: orderview.orderData?.orderList?.length,
                              itemBuilder: (context, index) {
                                return
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return OrderDetails(orderItem: orderView.orderData?.orderList?[index]);
                                      // AppNavigator.push(context, OrderDetails(orderItem: orderView.orderData?.orderList?[index]));
                                    });},
                                    child: orderView.orderData!.orderList![index]
                                        .itemDetails!.isEmpty ?
                                    Center(
                                        child:
                                        noDataFoundMessage(context,
                                            StringConstant.noOrderAvailable)) :
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Theme
                                              .of(context)
                                              .cardColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      width: 200,
                                      height: SizeConfig.screenHeight/6,
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(top: 10, bottom: 10,left: 10,right: 10),
                                      padding: EdgeInsets.only(left: 10, right: 20,top: 20,bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          InkWell(
                                              onTap: () {},
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(8.0),
                                                child: Image.network(
                                                  orderView.orderData
                                                      ?.orderList?[index]
                                                      .itemDetails?[0]
                                                      .productDetails
                                                      ?.productImages?[0] ?? " ",
                                                  height: 200, fit: BoxFit.fill,
                                                  width: 150,
                                                ),
                                              )),
                                          SizedBox(width: 8),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              SizedBox(height:5),
                                              AppMediumFont(context,
                                                  msg: StringConstant
                                                      .orderDetailed +
                                                      "-${orderView.orderData
                                                          ?.orderList?[index]
                                                          .orderId}",
                                                  fontSize: 16.0),
                                              Container(
                                                width: SizeConfig.screenWidth*0.15,
                                                child: AppMediumFont(context,
                                                    msg:
                                                    orderView.orderData
                                                        ?.orderList?[index]
                                                        .itemDetails?[0]
                                                        .productDetails
                                                        ?.productVariantTitle,
                                                    fontSize: 18.0),
                                              ),
                                              SizedBox(height:5),
                                              AppMediumFont(context,
                                                  msg: orderView.orderData
                                                      ?.orderList?[index]
                                                      .orderStatus,
                                                  fontSize: 16.0)
                                            ],
                                          ),
                                          InkWell(
                                              onTap: () {
                                                // AppNavigator.push(context, OrderDetails(orderItem: orderView.orderData?.orderList?[index]));
                                              },
                                              child: ClipRRect(
                                                child: Icon(
                                                  Icons.forward, size: 20,
                                                  color: Theme
                                                      .of(context)
                                                      .canvasColor,),
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                              })),
                    ),
                    footerDesktop()
                  ],
                ),
              ): Center(child: ThreeArchedCircle(size: 45.0)));
      },
      ),


    );
  }


}
