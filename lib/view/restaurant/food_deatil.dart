import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/product/productSkuDetailView.dart';
import 'package:TychoStream/view/WebScreen/product/product_details.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppRouter.gr.dart';

class foodDetail extends StatefulWidget {
  ProductList? items;
  Function? callback;


  foodDetail({Key? key,this.items,this.callback}) : super(key: key);

  @override
  State<foodDetail> createState() => _foodDetailState();
}

class _foodDetailState extends State<foodDetail> {

  CartViewModel cartView = CartViewModel();

  HomeViewModel homeViewModel = HomeViewModel();
  int currentIndex = 0;



  @override
  void initState() {
    getProductDetails(widget.items?.productDetails?.defaultVariationSku);
    super.initState();
  }
  getProductDetails(DefaultVariationSku? prod) {
    cartView.getProductDetails(
          context,
          widget.items?.productId ?? '',
          '${prod?.size?.name == null ? '' : prod?.size?.name}',
          '${prod?.color?.name == null ? '' : prod?.color?.name}',
          '${prod?.style?.name == null ? '' : prod?.style?.name}',
          '${prod?.unitCount?.name == null ? '' : prod?.unitCount?.name}',
          '${prod?.materialType?.name == null ? '' : prod?.materialType?.name}');
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider.value(
            value: cartView,
            child: Consumer<CartViewModel>(builder: (context, cartviewmodel, _) {
              return cartviewmodel.productListDetails != null ?
      AlertDialog(
          elevation: 10,
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.all(10),
          backgroundColor: Theme.of(context).cardColor,
          content:  Container(
            width: SizeConfig.screenWidth/3,
            child: SingleChildScrollView(
              child: Stack(
                children: [

                  Column(
                    children: [

                      Container(
                        width: SizeConfig.screenWidth,
                        height:ResponsiveWidget.isMediumScreen(context) ?  SizeConfig.screenHeight / 1.8 : SizeConfig.screenHeight/2.8,
                        color: Colors.white,
                        child: CarouselSlider(
                            options: CarouselOptions(
                                height:ResponsiveWidget.isMediumScreen(context) ?  SizeConfig.screenHeight / 1.8 : SizeConfig.screenHeight/2.8,
                                enableInfiniteScroll: cartviewmodel.productListDetails?.productDetails?.productImages?.length == 1
                                    ? false
                                    : true,
                                reverse: false,
                                viewportFraction: 2,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                }),
                            items: cartviewmodel.productListDetails?.productDetails?.productImages?.map((i) {
                              return Builder(builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    //AppNavigator.push(context, FullImage(imageUrl: i ?? ''));
                                  },
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    child: CachedNetworkImage(
                                        imageUrl: i ,fit: BoxFit.contain,
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))),
                                  ),
                                );
                              });
                            }).toList())),
                      SizedBox(height: 12),
                      Container(
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppBoldFont(context, msg: cartviewmodel.productListDetails?.productDetails?.productVariantTitle ?? '', fontSize: 22),
                              SizedBox(height: 8),
                              AppMediumFont(
                                context,color: Theme.of(context).canvasColor.withOpacity(0.8),
                                msg:
                                "${cartviewmodel.productListDetails?.productShortDesc ?? ''}",
                                fontSize: 16.0,
                              ),
                              SizedBox(height: 8),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    cartviewmodel.productListDetails?.productDetails
                                        ?.productPrice !=
                                        ''
                                        ? AppMediumFont(context,
                                        msg: "₹ "
                                            "${cartviewmodel.productListDetails?.productDetails?.productPrice ?? ''}",
                                        textDecoration:
                                        TextDecoration.lineThrough,
                                        fontSize: 16)
                                        : SizedBox(),
                                    SizedBox(width: 8.0), AppBoldFont(context,
                                        msg: "₹ "
                                            "${cartviewmodel.productListDetails?.productDetails?.productDiscountPrice ?? ''}",
                                        fontSize: 18),SizedBox(width: 8.0),
                                    AppMediumFont(context,
                                        msg: cartviewmodel
                                            .productListDetails
                                            ?.productDetails
                                            ?.productDiscountPercent !=
                                            ''
                                            ? "${cartviewmodel.productListDetails?.productDetails?.productDiscountPercent}" +
                                            '% OFF'
                                            : '',color: GREEN,
                                        fontSize: 18)
                                  ]),
                              SizedBox(height: 8),
                              AppBoldFont(context,color:Theme.of(context).canvasColor,
                                  msg: StringConstant.descriptionText, fontSize: 16),
                              SizedBox(height: 8),
                              ReadMoreText(
                                '${cartView.productListDetails?.productLongDesc}',
                                trimLines: 2,
                                style: TextStyle(color: Theme.of(context).canvasColor.withOpacity(0.8)),
                                colorClickableText: Theme.of(context).primaryColor,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '...Read more',
                                trimExpandedText: ' Less',
                              ),
                              SizedBox(height: 6),
                            ]),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: ProductSkuView(
                            selected: true,
                            skuDetails: cartviewmodel.productListDetails?.productSkuDetails,
                            cartView: cartviewmodel,
                            productList: cartviewmodel.productListDetails?.productDetails?.defaultVariationSku),
                      ),
                      cartviewmodel.productListDetails?.productDetails?.inStock == true
                          ?(cartviewmodel.productListDetails?.productDetails?.quantityLeft ?? 0) > 0 ?
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(horizontal:ResponsiveWidget.isMediumScreen(context)
                                      ?40: 40, vertical: ResponsiveWidget.isMediumScreen(context)
                                      ?20:20)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ResponsiveWidget.isMediumScreen(context)
                                        ?0:5.0),
                                  ))),
                          child: AppBoldFont(context,
                              msg: (cartView.isAddedToCart == true || cartView.productListDetails?.productDetails
                                  ?.isAddToCart ==
                                  true)
                                  ? StringConstant.goToCart
                                  : StringConstant.addToBag,color: Theme.of(context).hintColor,
                              fontSize: 16),
                          onPressed: ()async{                          closeAppbarProperty();
                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                          if (sharedPreferences.getString('token') == null){
                            showDialog(
                                context: context,
                                builder:
                                    (BuildContext context) {
                                  return  LoginUp(
                                    product: true,
                                  );
                                });
                          }

                        else if(cartView.productListDetails?.productDetails?.isAvailable == true) {
                            closeAppbarProperty();

                            (cartView.isAddedToCart == true || cartView.productListDetails?.productDetails?.isAddToCart == true)
                                ?
                            context.router.push(CartDetail(
                                itemCount: '${cartView.cartItemCount}'
                            ))

                                : addToBagButtonPressed();
                          }
                          }):
                      OutofStock(context):
                      OutofStock(context),
                      SizedBox(height: 16),

                    ],
                  ),
                  Positioned(
                      top: 1,right: 1,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          cartView.isAddedToCart == true? widget.callback!(true):widget.callback!(false);
                        },
                        child: Container(
                            alignment: Alignment.topRight,
                            child:Image.asset(AssetsConstants.icCross, color: Theme.of(context).canvasColor,width:ResponsiveWidget.isMediumScreen(context)?20: 25,height:ResponsiveWidget.isMediumScreen(context)?20: 25)),
                      )),
                ],
              ),
            ),
          )) :
      Center(child: ThreeArchedCircle(size: 45.0));
    }));
    }
  addToBagButtonPressed() {
    cartView.addToCart(
        cartView.productListDetails?.productId ?? '',
        "1",
        cartView.productListDetails?.productDetails?.variantId ?? '',
        false,
        context, (result, isSuccess) {});

  }

// regex to check whether enter detail is phoneNumber or email
}