import 'package:TychoStream/model/data/product_list_model.dart';

import 'package:TychoStream/model/data/product_list_model.dart';


class CartListDataModel {
  List<ProductList>? cartList;
  List<CheckoutDetails>? checkoutDetails;

  CartListDataModel({this.cartList, this.checkoutDetails});

  CartListDataModel.fromJson(Map<String, dynamic> json) {
    if (json['cartList'] != null) {
      cartList = <ProductList>[];
      json['cartList'].forEach((v) {
        cartList!.add(new ProductList.fromJson(v));
      });
    }
    if (json['checkoutDetails'] != null) {
      checkoutDetails = <CheckoutDetails>[];
      json['checkoutDetails'].forEach((v) {
        checkoutDetails!.add(new CheckoutDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cartList != null) {
      data['cartList'] = this.cartList!.map((v) => v.toJson()).toList();
    }
    if (this.checkoutDetails != null) {
      data['checkoutDetails'] =
          this.checkoutDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class CheckoutDetails {
  String? name;
  String? value;

  CheckoutDetails({this.name, this.value});

  CheckoutDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }}

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
