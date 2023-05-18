import 'package:TychoStream/model/data/product_list_model.dart';


class CartListDataModel {
  List<ProductList>? cartList;
  CheckoutDetails? checkoutDetails;

  CartListDataModel({this.cartList, this.checkoutDetails});

  CartListDataModel.fromJson(Map<String, dynamic> json) {
    if (json['cartList'] != null) {
      cartList = <ProductList>[];
      json['cartList'].forEach((v) {
        cartList!.add(new ProductList.fromJson(v));
      });
    }
    checkoutDetails = json['checkoutDetails'] != null
        ? new CheckoutDetails.fromJson(json['checkoutDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cartList != null) {
      data['cartList'] = this.cartList!.map((v) => v.toJson()).toList();
    }
    if (this.checkoutDetails != null) {
      data['checkoutDetails'] = this.checkoutDetails!.toJson();
    }
    return data;
  }
}

class CheckoutDetails {
  int? totalItems;
  String? cartTotalPrice;
  String? discountedPrice;
  String? deliveryCharge;
  String? totalPayableAmount;

  CheckoutDetails(
      {this.totalItems,
        this.cartTotalPrice,
        this.discountedPrice,
        this.deliveryCharge,
        this.totalPayableAmount});

  CheckoutDetails.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    cartTotalPrice = json['cartTotalPrice'];
    discountedPrice = json['discountedPrice'];
    deliveryCharge = json['deliveryCharge'];
    totalPayableAmount = json['totalPayableAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalItems'] = this.totalItems;
    data['cartTotalPrice'] = this.cartTotalPrice;
    data['discountedPrice'] = this.discountedPrice;
    data['deliveryCharge'] = this.deliveryCharge;
    data['totalPayableAmount'] = this.totalPayableAmount;
    return data;
  }
}

class ItemCountModel {
  int? count;

  ItemCountModel({this.count});

  ItemCountModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}
