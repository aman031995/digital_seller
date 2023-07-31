// import 'package:TychoStream/network/AppNetwork.dart';
// import 'package:TychoStream/utilities/Responsive.dart';
// import 'package:TychoStream/utilities/SizeConfig.dart';
// import 'package:TychoStream/utilities/TextHelper.dart';
// import 'package:TychoStream/utilities/three_arched_circle.dart';
// import 'package:TychoStream/view/Profile/order_details.dart';
// import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
// import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
// import 'package:TychoStream/view/widgets/no_data_found_page.dart';
// import 'package:TychoStream/view/widgets/no_internet.dart';
// import 'package:TychoStream/viewmodel/order_view_model.dart';
// import 'package:auto_route/annotations.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../utilities/StringConstants.dart';
// @RoutePage()
// class MyOrderPage extends StatefulWidget {
//   const MyOrderPage({Key? key}) : super(key: key);
//
//   @override
//   State<MyOrderPage> createState() => _MyOrderPageState();
// }
//
// class _MyOrderPageState extends State<MyOrderPage> {
//
//   final OrderViewModel orderView = OrderViewModel();
//   int pageNum=1;
//   String? checkInternet;
//   ScrollController scrollController = new ScrollController();
//   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
//   @override
//   void initState() {
//     orderView.getOrderList(context,pageNum);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     AppNetwork.checkInternet((isSuccess, result) {
//       setState(() {
//         checkInternet = result;
//       });
//     });
//     return ChangeNotifierProvider.value(
//       value: orderView,
//       child: Consumer<OrderViewModel>(builder: (context, orderview, _) {
//         return Scaffold(
//             key: _scaffoldKey,
//               backgroundColor: Theme.of(context).backgroundColor,
//               appBar: getAppBarWithBackBtn(
//                   title: StringConstant.myOrders,
//                   isBackBtn: false,
//                   context: context,
//                   isShopping: false,
//                   itemCount: "0",
//                   onCartPressed: () {},
//                   onBackPressed: () {}),
//               body: checkInternet == "Offline"
//                   ? NOInternetScreen()
//                   : orderview.orderData !=null?
//               SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         Center(
//                           child: Container(
//                               color: Theme.of(context).scaffoldBackgroundColor,
//                                  height: SizeConfig.screenHeight,
//                               width: ResponsiveWidget.isMediumScreen(context)
//                        ? SizeConfig.screenWidth:SizeConfig.screenWidth/3.5,
//                               child: ListView.builder(
//                                   padding: EdgeInsets.only(bottom: 20),
//                                   controller: scrollController,
//                                   itemCount: orderview.orderData?.orderList?.length,
//                                   itemBuilder: (context, index) {
//                                     scrollController.addListener(() {
//                                       if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
//                                         orderView.onPagination(
//                                             context,
//                                             orderView.lastPage,
//                                             orderView.nextPage,
//                                             orderView.isLoading
//                                         );
//                                       }
//                                     });
//                                     return
//                                       GestureDetector(
//                                         onTap: () {
//                                           showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return OrderDetails(orderItem: orderView.orderData?.orderList?[index]);
//                                         });},
//                                         child: orderView.orderData!.orderList![index]
//                                             .itemDetails!.isEmpty ?
//                                         Center(
//                                             child:
//                                             noDataFoundMessage(context,
//                                                 StringConstant.noOrderAvailable)) :
//                                         Container(
//                                           decoration: BoxDecoration(
//                                               color: Theme
//                                                   .of(context)
//                                                   .cardColor,
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(5.0))),
//                                           width:ResponsiveWidget.isMediumScreen(context)
//                                               ?  SizeConfig.screenWidth/1.2: 200,
//                                           height: ResponsiveWidget.isMediumScreen(context)
//                                               ?140 :SizeConfig.screenHeight/6,
//                                           alignment: Alignment.topLeft,
//                                           margin: EdgeInsets.only(top: 12, bottom: 12,left: 12,right: 12),
//                                           padding: EdgeInsets.only(left: 10, right: 20,top: 20,bottom: 10),
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment
//                                                 .start,
//                                             crossAxisAlignment: CrossAxisAlignment
//                                                 .start,
//                                             children: [
//                                               InkWell(
//                                                   onTap: () {},
//                                                   child: ClipRRect(
//                                                     borderRadius: BorderRadius
//                                                         .circular(8.0),
//                                                     child: Image.network(
//                                                       orderView.orderData
//                                                           ?.orderList?[index]
//                                                           .itemDetails?[0]
//                                                           .productDetails
//                                                           ?.productImages?[0] ?? " ",
//                                                       height:ResponsiveWidget.isMediumScreen(context)
//                                                           ?100: 200, fit: BoxFit.fill,
//                                                       width: ResponsiveWidget.isMediumScreen(context)
//                                                           ?100:150,
//                                                     ),
//                                                   )),
//                                               SizedBox(width: 8),
//                                               Container(
//                                                 width: ResponsiveWidget.isMediumScreen(context)
//                                                     ?SizeConfig.screenWidth/2:200,
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment
//                                                       .start,
//                                                   crossAxisAlignment: CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     SizedBox(height:5),
//                                                     AppMediumFont(context,
//                                                         msg: StringConstant
//                                                             .orderDetailed +
//                                                             "-${orderView.orderData
//                                                                 ?.orderList?[index]
//                                                                 .orderId}",
//                                                         fontSize:ResponsiveWidget.isMediumScreen(context)
//                                                             ?14: 16.0),
//                                                     AppMediumFont(context,
//                                                         msg:
//                                                         orderView.orderData
//                                                             ?.orderList?[index]
//                                                             .itemDetails?[0]
//                                                             .productDetails
//                                                             ?.productVariantTitle,
//                                                         fontSize: ResponsiveWidget.isMediumScreen(context)
//                                                             ?14:16.0,maxLines: 2),
//                                                     SizedBox(height:5),
//                                                     AppMediumFont(context,
//                                                         msg: orderView.orderData
//                                                             ?.orderList?[index]
//                                                             .orderStatus,
//                                                         fontSize: 16.0),
//                                                     SizedBox(height:5),
//                                                     AppMediumFont(context,
//                                                         msg: orderView.orderData
//                                                             ?.orderList?[index].orderDate,
//                                                         fontSize: 16.0)
//                                                   ],
//                                                 ),
//                                               ),
//
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                   })),
//                         ),
//                         orderView.isLoading == true
//                             ? Container(
//                             margin: EdgeInsets.only(top:  SizeConfig.screenHeight/1.3),
//                             alignment: Alignment.bottomCenter,
//                             child: CircularProgressIndicator(
//                                 color:
//                                 Theme.of(context).primaryColor))
//                             : SizedBox()
//                       ],
//                     ),
//                     footerDesktop()
//                   ],
//                 ),
//               ): Center(child: ThreeArchedCircle(size: 45.0)));
//       },
//       ),
//     );}}
