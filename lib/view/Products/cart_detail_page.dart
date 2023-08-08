import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utilities/SizeConfig.dart';

@RoutePage()
class CartDetail extends StatefulWidget {
  final String? itemCount;
  Function? callback;

  CartDetail({Key? key, @PathParam('itemCount') this.itemCount, this.callback})
      : super(key: key);

  @override
  State<CartDetail> createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  CartViewModel cartViewData = CartViewModel();
  final validation = ValidationBloc();
  TextEditingController applyPromoCode = TextEditingController();
  String? checkInternet;
  int activeStep = 0;

  @override
  void initState() {
    SessionStorageHelper.removeValue('token');
    cartViewData.getCartCount(context);
    cartViewData.updateCartCount(context, widget.itemCount ?? '');
    cartViewData.getCartListData(context);
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
            value: cartViewData,
            child: Consumer<CartViewModel>(builder: (context, cartViewData, _) {
              return Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: getAppBarWithBackBtn(
                      title: StringConstant.cartDetail,
                      context: context,
                      isBackBtn: false,
                      onBackPressed: () {
                        Navigator.pop(context);
                      }),
                  body: cartViewData.cartListData != null
                      ? cartViewData.cartListData!.cartList!.length > 0
                          ? SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      cartPageViewIndicator(context, 0),
                                      SizedBox(height: 10),
                                      ResponsiveWidget.isMediumScreen(context)
                                          ? Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: ListView.builder(
                                          itemCount: cartViewData.cartListData?.cartList?.length ?? 0,
                                          shrinkWrap: true,
                                          physics: ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final itemInCart = cartViewData
                                                .cartListData?.cartList?[index];
                                            return Container(
                                              color: Theme.of(context).cardColor,
                                              margin: EdgeInsets.only(bottom: 5),
                                              child:cardDeatils(context,itemInCart!,index,cartViewData)

                                            );
                                          },
                                        ),
                                      ):
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(5)),
                                            width:
                                            SizeConfig.screenWidth * 0.30,
                                            height:
                                            SizeConfig.screenHeight / 1.2,
                                            child: ListView.builder(
                                              itemCount: cartViewData
                                                  .cartListData
                                                  ?.cartList
                                                  ?.length ??
                                                  0,
                                              shrinkWrap: true,
                                              physics: ScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                final itemInCart = cartViewData.cartListData?.cartList?[index];
                                                return Container(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child:cardDeatils(context,itemInCart!,index,cartViewData)
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              pricedetails(context,cartViewData),
                                              SizedBox(height: 10),
                                              Center(
                                                child: checkoutButton(
                                                    context,
                                                    StringConstant.continueText,
                                                    cartViewData, () {
                                                  context.router.push(
                                                      AddressListPage(
                                                          buynow: false));
                                                }),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      ResponsiveWidget.isMediumScreen(context)
                                          ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          pricedetails(context,cartViewData),
                                          SizedBox(height: 10),
                                           Container(
                                              height: 50,
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              width: SizeConfig
                                                  .screenWidth,
                                              child: checkoutButton(
                                                  context,
                                                  StringConstant
                                                      .continueText,
                                                  cartViewData, () {
                                                context.router.push(
                                                    AddressListPage(
                                                        buynow: false));
                                              }),

                                          )

                                        ],
                                      ):SizedBox(height: 20),
                                      SizedBox(height: 30),
                                      ResponsiveWidget.isMediumScreen(context)
                                          ?  footerMobile(context):footerDesktop()
                                    ],
                                  ),
                                )

                          : Center(
                              child: noDataFoundMessage(
                                  context, StringConstant.noItemInCart))
                      : Center(
                          child:
                              Container(child: ThreeArchedCircle(size: 45.0)),
                        )
              );
            })
    );
  }
}
