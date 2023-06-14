import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/build_indicator.dart';
import 'package:TychoStream/utilities/color_dropdown.dart';
import 'package:TychoStream/utilities/size_dropdown.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppRouter.gr.dart';

@RoutePage()
class ProductDetailPage extends StatefulWidget {
  final List<String>? productdata;
  final String? productId;
    ProductDetailPage(
      {
        @PathParam('productId') this.productId,
        @QueryParam() this.productdata,
        Key? key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int currentIndex = 0;
  CartViewModel cartView = CartViewModel();
  String? checkInternet;
  int? selectedSizeIndex;
  int? selectedMaterialIndex;
  int? selectedStyleIndex;
  int? selectedUnitIndex;
  String? chosenSize;
  String prodId = '';
  String variantId = '';
  String colorName='';
  String sizeName = '';
  bool isfab = false;
  String? token;
  List<Widget> cardWidgets = [];
  var proDetails;

  void initState() {
    getProductDetails();
    super.initState();
  }

  getProductDetails(){
    if(widget.productdata?.length ==1){
      cartView.getProductListCategory(
          context, widget.productId ?? "", widget.productdata?[0] ?? "", 1);
    } else {
      if (widget.productId != null)
         cartView.updatecolorName(context,'');
      cartView.updateCartCount(context, widget.productdata?[0] ?? '');
        cartView.getProductDetails(
            context,
            widget.productId ?? '',
            widget.productdata?[1] ?? '',
            widget.productdata?[2] ?? "",
            '');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });

    return
      checkInternet == "Offline"
          ? NOInternetScreen()
          : ChangeNotifierProvider.value(
        value: cartView,
        child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
          return Scaffold(
                appBar: getAppBarWithBackBtn(
                  title: "Product Details",
                    context: context,
                    isBackBtn: false,
                    isShopping: true,
                    isFavourite: false,
                    itemCount: viewmodel.cartItemCount,
                    onCartPressed: () {
                      context.router.push(CartDetail(
                          itemCount: '${viewmodel.cartItemCount}'
                      ));
                    },
                    onBackPressed: () {
                    }),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
           body: viewmodel.productListDetails != null ?
           SingleChildScrollView(child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(margin: EdgeInsets.only(top: SizeConfig.screenHeight*0.02),
               width: SizeConfig.screenWidth/3.5,
               child: Stack(children: [
                 CarouselSlider(
                     options: CarouselOptions(
                         height: SizeConfig.screenHeight / 1.35,
                         enableInfiniteScroll: viewmodel.productListDetails?.productDetails?.productImages?.length==1?false:true,
                         reverse: false,
                         viewportFraction: 1,
                         onPageChanged: (index, reason) {
                           setState(() {
                             currentIndex = index;
                           });
                         }),
                     items: viewmodel
                         .productListDetails?.productDetails?.productImages
                         ?.map((i) {
                       return Builder(builder: (BuildContext context) {
                         return Container(
                           width: SizeConfig.screenWidth/1.2,
                           child: CachedNetworkImage(
                               imageUrl: '${i}',
                               fit: BoxFit.fill,
                               placeholder: (context, url) => Center(
                                   child: CircularProgressIndicator(
                                       color:
                                       Theme.of(context).primaryColor))),
                         );
                       });
                     }).toList()),
                 viewmodel.productListDetails?.productDetails?.productImages?.length == 1 ? Container() :
                 Positioned(
                     bottom: 10,
                     left: 1,
                     right: 1,
                     child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: buildIndicator(
                             viewmodel.productListDetails?.productDetails
                                 ?.productImages,
                             currentIndex,
                             context))),
                 Positioned(
                     right: 10, top: 5,
                     child: Container(
                         decoration: BoxDecoration(
                             shape: BoxShape.circle,
                             color: Theme.of(context).canvasColor),
                         height: 35,
                         width: 35,
                         child: IconButton(
                           icon: Icon(Icons.share),
                             onPressed: () {}))),
                 Positioned(
                     right: 10,
                     top: 45,
                     child: GestureDetector(
                         onTap: () {
                           if (token == 'null'){
                             _backBtnHandling(prodId);
                           } else {
                             // viewmodel.addToFavourite(
                             //   context,
                             //   "${viewmodel.productListDetails?.productId}",
                             //   "${viewmodel.productListDetails?.productDetails?.productColor}",
                             //   viewmodel.productListDetails?.productDetails
                             //       ?.isFavorite ==
                             //       true
                             //       ? false
                             //       : true,
                             //   'productDetail');
                           }
                           },
                         child: Container(
                             decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Theme.of(context).canvasColor),
                             height: 35,
                             width: 35,
                             child: Icon(Icons.favorite,
                                 color: viewmodel.productListDetails
                                     ?.productDetails?.isFavorite ==
                                     true
                                     ? Colors.red
                                     : GREY_COLOR,
                                 size: 25))))
               ])),
           Container(
               margin: EdgeInsets.only(left: 20,top: SizeConfig.screenHeight*0.02),
               padding: EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
               child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Container(
                         width: SizeConfig.screenWidth/4,
                         child: AppBoldFont(context, msg: viewmodel.productListDetails?.productDetails?.productVariantTitle ?? '', fontSize: 22)),
                     SizedBox(height: 10),
                     Container(
                         width: SizeConfig.screenWidth/4,
                         child: AppMediumFont(
                           context,
                           msg:
                           "${viewmodel.productListDetails?.productLongDesc ?? ''}",
                           fontSize: 18.0,
                         )),
                     SizedBox(height: 10),
                     AppBoldFont(context,
                         msg: "₹ "
                             "${viewmodel.productListDetails?.productDetails?.productDiscountPrice ?? ''}",
                         fontSize: 18),
                     SizedBox(height: 5),
                     Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           viewmodel.productListDetails?.productDetails
                               ?.productPrice !=
                               ''
                               ? AppMediumFont(context,
                               msg: "₹ "
                                   "${viewmodel.productListDetails?.productDetails?.productPrice ?? ''}",
                               textDecoration:
                               TextDecoration.lineThrough,
                               fontSize: 16)
                               : SizedBox(),
                           SizedBox(width: 8.0),
                           AppMediumFont(context,
                               msg: viewmodel
                                   .productListDetails
                                   ?.productDetails
                                   ?.productDiscountPercent !=
                                   ''
                                   ? "${viewmodel.productListDetails?.productDetails?.productDiscountPercent}" +
                                   '% OFF'
                                   : '',
                               fontSize: 16)
                         ]),
                     SizedBox(height: 20),
                      productColor(viewmodel.productListDetails),
                     productSize(viewmodel.productListDetails),
                     productMaterial(viewmodel.productListDetails),
                     productUnit(viewmodel.productListDetails),
                     productStyle(viewmodel.productListDetails),

                     bottomNavigationButton()
                   ]))
         ],
       ))
         : Center(child: ThreeArchedCircle(size: 45.0)));
        })
      );
  }

  //product Size
  productSize(ProductList? productListDetails) {
    return Column(
      children: productListDetails?.productSkuDetails?.map((element){
        return element.data != null && element.variationKey == 'size' ? Container(
            padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
            width: SizeConfig.screenWidth/7,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBoldFont(context,
                      msg: StringConstant.size + cartView.selectedSizeName,
                      fontSize: 18),
                  SizedBox(height: 8),
                  // if(element.data != null)
                  element.data!.length > 4
                      ? Container(
                    width: SizeConfig.screenWidth/9,
                    color: TRANSPARENT_COLOR, height: 50,
                    child: SizeDropDown(
                      hintText: element.variationName,
                      chosenValue: chosenSize,
                      onChanged: (m) {
                        chosenSize = m;
                        onSizeSelected(chosenSize, productListDetails);
                        element.data?.forEach((e) {
                          if(chosenSize == e.name){
                            cartView.updatesizeName(context,  e.name ?? '');
                          }
                        });
                      },
                      sizeList: element.data!,
                    ),
                  ) :
                  Container(
                      height: 50,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: element.data?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  selectedSizeIndex = index;
                                  onSizeSelected(element.data?[index].name, cartView.productListDetails!);
                                  cartView.updatesizeName(context, "${element.data?[index].name}");
                                },
                                child: Container(
                                  width: 55,
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.only(right: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: selectedSizeIndex != index ? TRANSPARENT_COLOR : Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(10)),
                                        border: Border.all(
                                            color: Theme.of(context).canvasColor,
                                            width: 2)),
                                    child: AppBoldFont(
                                      context,
                                      msg: "${element.data?[index].name}",
                                      fontSize: 14.0,
                                      color: Theme.of(context).canvasColor,
                                    )));
                          }))
                ])) : SizedBox();
      }).toList() ?? [],
    );
  }
  //product material
  productMaterial(ProductList? productListDetails) {
    return Column(
      children: productListDetails?.productSkuDetails?.map((element){
        return element.data != null && element.variationKey == 'material_type' ? Container(
            padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
            width: SizeConfig.screenWidth/5,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBoldFont(context,
                      msg: element.variationName! + ' : ' +cartView.selectedMaterialName,
                      fontSize: 18),
                  SizedBox(height: 8),
                  // if(element.data != null)
                  element.data!.length > 4
                      ? Container(
                    width: SizeConfig.screenWidth/9,
                    color: TRANSPARENT_COLOR, height: 50,
                    child: SizeDropDown(
                      hintText: 'Select Material',
                      chosenValue: chosenSize,
                      onChanged: (m) {
                        chosenSize = m;
                        onMaterialSelected(chosenSize, productListDetails);
                        element.data?.forEach((e) {
                          if(chosenSize == e.name){
                            cartView.updateMaterialName(context, e.name ?? '');
                          }
                        });
                      },
                      sizeList: element.data!,
                    ),
                  ) :
                  Container(
                      height: 50,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: element.data?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  selectedMaterialIndex = index;
                                  onMaterialSelected(element.data?[index].name, cartView.productListDetails!);
                                  cartView.updateMaterialName(context, "${element.data?[index].name}");
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(right: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(10)),
                                        shape: BoxShape.rectangle,
                                        color: selectedMaterialIndex != index ? TRANSPARENT_COLOR : Theme.of(context).primaryColor,
                                        border: Border.all(
                                            color: Theme.of(context).canvasColor,
                                            width: 2)),
                                    child: AppBoldFont(
                                      context,
                                      msg: "${element.data?[index].name}",
                                      fontSize: 14.0,
                                      color: Theme.of(context).canvasColor,
                                    )));
                          }))
                ])) : SizedBox();
      }).toList() ?? [],
    );
  }
  // product style
  productStyle(ProductList? productListDetails) {
    return Column(
      children: productListDetails?.productSkuDetails?.map((element){
        return element.data != null && element.variationKey == 'style' ? Card(
            child: Container(
                padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
                width: SizeConfig.screenWidth/7,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBoldFont(context,
                          msg: element.variationName! + 'cartView.selectedSizeName',
                          fontSize: 18),
                      SizedBox(height: 8),
                      // if(element.data != null)
                      element.data!.length > 4
                          ? Container(color: TRANSPARENT_COLOR, height: 50,
                        child: SizeDropDown(
                          hintText: 'Select Style',
                          chosenValue: chosenSize,
                          onChanged: (m) {
                            chosenSize = m;
                            onStyleSelected(chosenSize, productListDetails);
                            element.data?.forEach((e) {
                              if(chosenSize == e.name){
                                cartView.updateStyleName(context,  e.name ?? '');
                              }
                            });
                          },
                          sizeList: element.data!,
                        ),
                      ) :
                      Container(
                          height: 50,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: element.data?.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      selectedStyleIndex = index;
                                      onStyleSelected(element.data?[index].name, cartView.productListDetails!);
                                      cartView.updateStyleName(context, "${element.data?[index].name}");
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.only(right: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: selectedStyleIndex != index ? TRANSPARENT_COLOR : Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(10)),
                                            border: Border.all(
                                                color: Theme.of(context).canvasColor,
                                                width: 2)),
                                        child: AppBoldFont(
                                          context,
                                          msg: "${element.data?[index].name}",
                                          fontSize: 14.0,
                                          color: Theme.of(context).canvasColor,
                                        )));
                              }))
                    ]))) : SizedBox();
      }).toList() ?? [],
    );
  }
  // product unit
  productUnit(ProductList? productListDetails) {
    return Column(
      children: productListDetails?.productSkuDetails?.map((element){
        return element.data != null && element.variationKey == 'unit_count'? Card(
            child: Container(
                padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
                width: SizeConfig.screenWidth/7,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBoldFont(context,
                          msg: element.variationName! + 'cartView.selectedSizeName',
                          fontSize: 18),
                      SizedBox(height: 8),
                      // if(element.data != null)
                      element.data!.length > 4
                          ? Container(
                        width: SizeConfig.screenWidth/9,
                        color: TRANSPARENT_COLOR, height: 50,
                        child: SizeDropDown(
                          hintText: 'Select Unit',
                          chosenValue: chosenSize,
                          onChanged: (m) {
                            chosenSize = m;
                            onUnitSelected(chosenSize, productListDetails);
                            element.data?.forEach((e) {
                              if(chosenSize == e.name){
                                cartView.updateUnitCountName(context,  e.name ?? '');
                              }
                            });
                          },
                          sizeList: element.data!,
                        ),
                      ) :
                      Container(
                          height: 50,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: element.data?.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      selectedUnitIndex = index;
                                      onUnitSelected(element.data?[index].name, cartView.productListDetails!);
                                      cartView.updateUnitCountName(context, "${element.data?[index].name}");
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.only(right: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: selectedUnitIndex != index ? TRANSPARENT_COLOR : Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(10)),
                                            border: Border.all(
                                                color: Theme.of(context).canvasColor,
                                                width: 2)),
                                        child: AppBoldFont(
                                          context,
                                          msg: "${element.data?[index].name}",
                                          fontSize: 14.0,
                                          color: Theme.of(context).canvasColor,
                                        )));
                              }))
                    ]))) : SizedBox();
      }).toList() ?? [],
    );
  }
  // product color
  productColor(ProductList? productListDetails) {
    return Column(
      children: productListDetails?.productSkuDetails?.map((element){
        return element.data != null && element.variationKey == 'color' ?
        Container(
            padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
            width: SizeConfig.screenWidth/7,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBoldFont(context, msg: element.variationName! + ": "+ cartView.selectedColorName, fontSize: 18),
                  SizedBox(height: 5),
                  element.data!.length > 4
                      ? Container(
                      width: SizeConfig.screenWidth/9,
                      color: TRANSPARENT_COLOR,
                      height: 50,

                      child: ColorDropDown(
                         chosenValue: cartView.selectedColorName,
                        hintText: 'Select Color',
                        onChanged: (m) {

                          onColorSelected(m, productListDetails);
                          cartView.selectedColorName = m;
                          cartView.updatecolorName(context, cartView.selectedColorName);
                          element.data?.forEach((element) {
                            if(element.name == cartView.selectedColorName){
                              cartView.updatecolorName(context, cartView.selectedColorName);
                            }
                          });
                        },
                        colorData: element.data,
                      ))
                      : Container(
                      height: 50,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: element.data?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  onColorSelected(element.data?[index].name, cartView.productListDetails!);
                                  cartView.updatecolorName(context, element.data?[index].name ?? '');
                                },
                                child: Container(
                                    height: 35,
                                    width: 45,
                                    margin: EdgeInsets.only(right: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: (element.data?[index].val)?.toColor(),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black,
                                            width: cartView.selectedColorName ==  element.data?[index].name ? 3 : 1))));
                          }))
                ])) : SizedBox();
      }).toList() ?? [],
    );
  }


  onColorSelected(String? colorName, ProductList productDetails) {
    if (cartView.selectedColorName != colorName) {
      cartView.updatesizeName(context, "",);
      selectedSizeIndex = null;
      selectedStyleIndex = null;
      selectedMaterialIndex = null;
      selectedUnitIndex = null;
      chosenSize = null;
      cartView.isAddedToCart = false;
      AppIndicator.loadingIndicator(context);
      getProductUpdateDetails(colorName, "", productDetails);
    }
  }

  onSizeSelected(String? sizeName, ProductList product) {
    if (cartView.selectedSizeName != sizeName) {
      cartView.isAddedToCart = false;
      AppIndicator.loadingIndicator(context);
      getProductUpdateDetails(cartView.selectedColorName, sizeName, product);
    }
  }

  onStyleSelected(String? styleName, ProductList product) {
    if (cartView.selectedStyleName != styleName) {
      cartView.isAddedToCart = false;
      AppIndicator.loadingIndicator(context);
      getProductUpdateDetails(cartView.selectedColorName, styleName, product);
    }
  }

  onMaterialSelected(String? materialName, ProductList product) {
    if (cartView.selectedMaterialName != materialName) {
      cartView.isAddedToCart = false;
      AppIndicator.loadingIndicator(context);
      getProductUpdateDetails(cartView.selectedColorName, materialName, product);
    }
  }

  onUnitSelected(String? unitName, ProductList product) {
    if (cartView.selectedUnitCountName != unitName) {
      cartView.isAddedToCart = false;
      AppIndicator.loadingIndicator(context);
      getProductUpdateDetails(cartView.selectedColorName, unitName, product);
    }
  }

  getProductUpdateDetails(String? colorName, sizeName, ProductList product){
    cartView.getProductDetails(
          context, widget.productId ?? prodId, product.productDetails?.variantId ?? '', colorName ?? '', sizeName ?? '');

  }

  // this method is called when navigate to this page using dynamic link
  receivedArgumentsNotification() {
    if (ModalRoute.of(context)?.settings.arguments != null && prodId == '') {
      final Map<String, dynamic> data =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      prodId = data['prodId'];
      variantId = data['variantId'];
      colorName = data['colorName'];
      cartView.getProductDetails(context, prodId, variantId,colorName,"");
      cartView.updatecolorName(
          context,
          colorName);
    }
  }

  // give toast according to the empty field
  addToBagButtonPressed() {
    cartView.productListDetails?.productSkuDetails?.forEach((e){
      if(e.data != null){
        if ((e.data!.length > 4 && chosenSize == null) || (e.data!.length <= 4 && selectedSizeIndex == null)) {
          ToastMessage.message('Select Size');
        } else {
          cartView.addToCart(
              cartView.productListDetails?.productId ?? '',
              "1",
              cartView.productListDetails?.productDetails?.variantId ?? '',
              false,
              context, (result, isSuccess) {});
        }
      }
    });
  }

  //Bottom Navigation
  bottomNavigationButton() {
    return Container(
        height: 80,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).cardColor),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ))),
              child: AppBoldFont(context,
                  msg: (cartView.isAddedToCart == true ||
                      cartView.productListDetails?.productDetails
                          ?.isAddToCart ==
                          true) &&
                      (selectedSizeIndex != null || chosenSize != null)
                      ? "Go to Cart"
                      : "Add to Bag",
                  fontSize: 16),
              onPressed: () {
                if (token == 'null'){
                  _backBtnHandling(prodId);
                }
                else if (cartView.productListDetails?.productDetails?.isAvailable == true) {
                  (cartView.isAddedToCart == true || cartView.productListDetails?.productDetails?.isAddToCart == true) &&
                      (selectedSizeIndex != null || chosenSize != null)
                      ?
                  context.router.push(CartDetail(
                    itemCount: '${cartView.cartItemCount}'
                  ))
                  // GoRouter.of(context).pushNamed(RoutesName.CartDetails, queryParameters: {
                  //   'itemCount':'${cartView.cartItemCount}',
                  // })
                  // AppNavigator.push(
                  //     context,
                  //     CartDetail(itemCount: cartView.cartItemCount,),
                  //     screenName: RouteBuilder.cartDetail,
                  //     function: (value) {
                  //       if (value != cartView.cartItemCount) {
                  //         // update cart count after page callback
                  //         cartView.updateCartCount(context, value);
                  //         AppIndicator.loadingIndicator(context);
                  //         cartView.getProductDetails(context, widget.items?.productId ?? '', '', cartView.selectedColorId, '');
                  //       }
                  //     })

                      : addToBagButtonPressed();
                }
              }),
              SizedBox(width: 5),
              ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),
                      ))),
              child: AppBoldFont(context,
                  msg: "WishList", fontSize: 16),
              onPressed: () {
                if (token == 'null'){
                  _backBtnHandling(prodId);
                }
                else if (cartView.productListDetails?.productDetails?.isAvailable == true) {
                  context.router.push(FavouriteListPage());
                  // AppNavigator.push(
                  //     context,
                  //     FavouriteListPage(
                  //         callback: (value) {
                  //           if (value == false) {
                  //             AppIndicator.loadingIndicator(context);
                  //             cartView.getProductDetails(context, widget.items?.productId ?? '', '', cartView.selectedColorId, '');
                  //           }
                  //         }),
                  //     screenName: RouteBuilder.Favourite,
                  //     function: (v) {
                  //       cartView.updateCartCount(context, v);
                  //       AppIndicator.loadingIndicator(context);
                  //       cartView.getProductDetails(context, widget.items?.productId ?? '', '', cartView.selectedColorId, '');
                  //     });
                }
              })
        ]));
  }

  void _backBtnHandling(String prodId) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token').toString();
    if(prodId != '' && token != 'null'){
      // AppNavigator.pushReplacement(context, BottomNavigationWidget());
    } else if (token == 'null'){
      ToastMessage.message("Please Login");
      // AppNavigator.pushReplacement(context, LoginScreen());
    } else {
      Navigator.pop(context, cartView.cartItemCount);

    }
  }
}
