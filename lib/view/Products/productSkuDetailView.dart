import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/main.dart';

class ProductSkuView extends StatelessWidget {
  List<ProductSkuDetails>? skuDetails;
  CartViewModel? cartView;
  DefaultVariationSku? productList;
  bool? selected;
  ProductSkuView({this.skuDetails, this.cartView, this.productList,this.selected});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: cartView,
        child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
          return Column(
            children: skuDetails!.map((e) {
              return Container(
                  padding: ResponsiveWidget.isMediumScreen(context)
                      ? EdgeInsets.only(bottom: 10) :EdgeInsets.zero,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(child: _text(productList, e, context)),
                        SizedBox(height: 8),
                        Container(
                            height:ResponsiveWidget.isMediumScreen(context)
                                ? 35:45,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: e.data?.length,
                                itemBuilder: (context, index) {
                                  final variationItem = e.data?[index];
                                  final itemName = variationItem?.name;
                                  final selectedProduct = viewmodel.isSelect == true ?
                                  viewmodel.productListDetails?.selectedSku: null;
                                  return GestureDetector(
                                    onTap: () {
                                      if(productList?.color?.name == itemName ||
                                          productList?.size?.name == itemName || productList?.unitCount?.name == itemName || productList?.style?.name == itemName
                                          || productList?.materialType?.name == itemName){
                                      } else {
                                       // viewmodel.checkSelect(context);
                                        onSelected(viewmodel, context, e, itemName, selectedProduct, index);
                                      }
                                      },
                                    child: e.variationKey == 'color'
                                        ? Container(
                                            height: productList?.color?.name == itemName
                                                ? 35
                                                : 35,
                                            width: productList?.color?.name == itemName
                                                ? 35
                                                : 35,
                                            margin:
                                                EdgeInsets.only(right: 15),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: (variationItem?.val)?.toColor(),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color:  productList?.color?.name == itemName ?Theme.of(context).primaryColor.withOpacity(0.8)   :Theme.of(context).canvasColor.withOpacity(0.3),
                                                    width: productList?.color?.name == itemName ? 3 : 1)))
                                        : Container(
                                             padding: EdgeInsets.all(5),
                                            margin: EdgeInsets.only(right: 15),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(10)),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(color:_color(e, context, itemName, selectedProduct, index), width: 2)),
                                            child: AppBoldFont(
                                              context,
                                              msg: "${itemName}",
                                              fontSize: 16.0,
                                              color:_textcolor(e, context, itemName, selectedProduct, index),
                                            )),
                                  );
                                }))
                      ]));
            }).toList(),
          );
        }));
  }

  void onSelected(CartViewModel viewmodel, BuildContext context, ProductSkuDetails prodSku, String? itemName, List<SkuData>? selectedProduct, int index) {
      final productId = viewmodel.productListDetails?.productId;
      cartView?.isAddedToCart = false;
      String? color, size, material, style, unit;
      selectedProduct?.forEach((item) {
        String? name = item.name;
        String? val = item.val;
        if (name == 'color') {
          color = val;
        } else if (name == 'size') {
          size = val;
        } else if (name == 'material_type') {
          material = val;
        } else if(name == 'style'){
          style=val;
        } else if(name=='unit_count'){
          unit=val;
        }
      });
      AppIndicator.loadingIndicator(context);
      if(prodSku.variationKey == 'color'){
        getProductUpdateDetails('${productId}', '${itemName}', '${size ?? ""}', '${material ?? ""}', '${ unit ?? ""}', '${ style ?? ""}', context);
      } else if (prodSku.variationKey == 'style') {
        getProductUpdateDetails('${productId}', '${color ?? ""}', '${size ?? ""}', '${material ?? ""}', '${unit ?? ""}', '${itemName}', context);
      } else if (prodSku.variationKey == 'material_type') {
        getProductUpdateDetails('${productId}', '${color ?? ""}', '${size ?? ""}', '${itemName}', '${unit ?? ""}', '${style ?? ""}', context);
      } else if (prodSku.variationKey == 'size') {
        getProductUpdateDetails('${productId}', '${color ?? ""}', '${itemName}', '${material ?? ""}', '${unit ?? ""}', '${style ?? ""}', context);
      } else if (prodSku.variationKey == 'unit_count') {
        getProductUpdateDetails('${productId}', '${color ?? ""}', '${size ?? ""}', '${material ?? ""}', '${itemName}', '${style ?? ""}', context);
      }
  }

  void getProductUpdateDetails(String productId,String colorName, String sizeName, String materialType, String unit, String style, BuildContext context) {
    cartView?.getProductDetails(
        context, productId, sizeName, colorName == "null" ? "": colorName, style, unit, materialType);
  }

  _text(DefaultVariationSku? defaultProduct, ProductSkuDetails e, BuildContext context) {
    if (e.variationKey == 'color') {
      return RichText(
          text: TextSpan(
              text: '${e.variationName!}  :  ',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
              children: <InlineSpan>[
                TextSpan(
                  style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                  text: '${defaultProduct?.color?.name}',
                )
              ]
          ));

      AppBoldFont(context, msg: e.variationName! + ' : ${defaultProduct?.color?.name}', fontSize: 18);
    } else if (e.variationKey == 'unit_count') {
      return RichText(
          text: TextSpan(
              text: '${e.variationName!}  :  ',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
              children: <InlineSpan>[
                TextSpan(
                  style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                  text: '${defaultProduct?.unitCount?.name}',
                )
              ]
          ));

      // AppBoldFont(context, msg: e.variationName! + ' : ${defaultProduct?.unitCount?.name}', fontSize: 18);
    } else if (e.variationKey == 'size') {
      return RichText(
          text: TextSpan(
              text: '${e.variationName!}  :  ',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
              children: <InlineSpan>[
                TextSpan(
                  style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                  text: '${defaultProduct?.size?.name}',
                )
              ]
          ));

      //AppBoldFont(context, msg: e.variationName! + ' : ${defaultProduct?.size?.name}', fontSize: 18);
    } else if (e.variationKey == 'material_type') {
      return
        RichText(
            text: TextSpan(
                text: '${e.variationName!}  :  ',
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                children: <InlineSpan>[
                  TextSpan(
                    style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                    text: '${defaultProduct?.materialType?.name}',
                  )
                ]
            ));
      //AppBoldFont(context, msg: e.variationName! + ' : ${defaultProduct?.materialType?.name}', fontSize: 18);
    } else if (e.variationKey == 'style') {
      return  RichText(
          text: TextSpan(
              text: '${e.variationName!}  :  ',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Theme.of(context).canvasColor,fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
              children: <InlineSpan>[
                TextSpan(
                  style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color: Theme.of(context).canvasColor.withOpacity(0.7),  fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily),
                  text: '${defaultProduct?.style?.name}',
                )
              ]
          ));
      //AppBoldFont(context, msg: e.variationName! + ' : ${defaultProduct?.style?.name}', fontSize: 18);
    }
  }


  _color(ProductSkuDetails e, BuildContext context, String? itemName, List<SkuData>? selectedProduct, int index) {
    if (e.variationKey == 'unit_count') {
      return productList?.unitCount?.name == itemName ? Theme.of(context).primaryColor.withOpacity(0.8) : Theme.of(context).canvasColor.withOpacity(0.3);
    } else if (e.variationKey == 'size') {
      return productList?.size?.name == itemName ? Theme.of(context).primaryColor.withOpacity(0.8) : Theme.of(context).canvasColor.withOpacity(0.3);
    } else if (e.variationKey == 'material_type') {
      return productList?.materialType?.name == itemName ? Theme.of(context).primaryColor.withOpacity(0.8) : Theme.of(context).canvasColor.withOpacity(0.3);
    } else if (e.variationKey == 'style') {
      return productList?.style?.name == itemName ? Theme.of(context).primaryColor.withOpacity(0.8) : Theme.of(context).canvasColor.withOpacity(0.3);
    } else {
      return TRANSPARENT_COLOR;
    }
  }
  _textcolor(ProductSkuDetails e, BuildContext context, String? itemName, List<SkuData>? selectedProduct, int index) {
    if (e.variationKey == 'unit_count') {
      return productList?.unitCount?.name == itemName ?  Theme.of(context).canvasColor : Theme.of(context).canvasColor.withOpacity(0.3);
    } else if (e.variationKey == 'size') {
      return productList?.size?.name == itemName ?  Theme.of(context).canvasColor : Theme.of(context).canvasColor.withOpacity(0.3);
    } else if (e.variationKey == 'material_type') {
      return productList?.materialType?.name == itemName ?  Theme.of(context).canvasColor: Theme.of(context).canvasColor.withOpacity(0.3);
    } else if (e.variationKey == 'style') {
      return productList?.style?.name == itemName ? Theme.of(context).canvasColor : Theme.of(context).canvasColor.withOpacity(0.3);
    } else {
      return TRANSPARENT_COLOR;
    }
  }
}