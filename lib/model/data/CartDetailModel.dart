import 'package:tycho_streams/model/data/BannerDataModel.dart';

class CartListDataModel {
  Pagination? pagination;
  List<CartDetailModel>? cartList;

  CartListDataModel({this.pagination, this.cartList});

  CartListDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['cartList'] != null) {
      cartList = <CartDetailModel>[];
      json['cartList'].forEach((v) {
        cartList!.add(new CartDetailModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.cartList != null) {
      data['cartList'] = this.cartList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class CartDetailModel {
  int? id;
  String? userId;
  String? cartId;
  String? productId;
  String? productName;
  String? productImage;
  String? price;
  String? color;
  int? quantity;

  CartDetailModel(
      {this.id,
        this.userId,
        this.cartId,
        this.productId,
        this.productName,
        this.productImage,
        this.price,
        this.color,
        this.quantity});

  CartDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    cartId = json['cartId'];
    productId = json['productId'];
    productName = json['productName'];
    productImage = json['productImage'];
    price = json['price'];
    color = json['color'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['cartId'] = this.cartId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productImage'] = this.productImage;
    data['price'] = this.price;
    data['color'] = this.color;
    data['quantity'] = this.quantity;
    return data;
  }
}