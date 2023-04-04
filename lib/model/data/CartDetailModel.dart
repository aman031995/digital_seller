import 'package:TychoStream/model/data/checkoutDataModel.dart';
import 'package:TychoStream/model/data/checkoutDataModel.dart';

class CartListDataModel {
  List<CartDetailModel>? cartList;
  int? count;
  CheckOutDataModel? checkOut;

  CartListDataModel({this.cartList, this.count,this.checkOut});

  CartListDataModel.fromJson(Map<String, dynamic> json) {
    if (json['cartList'] != null) {
      cartList = <CartDetailModel>[];
      json['cartList'].forEach((v) {
        cartList!.add(new CartDetailModel.fromJson(v));
      });
    }
    count = json['count'];
    checkOut = json['checkOut'] != null
        ? new CheckOutDataModel.fromJson(json['checkOut'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cartList != null) {
      data['cartList'] = this.cartList!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    if (this.checkOut != null) {
      data['checkOut'] = this.checkOut!.toJson();
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
  String? imagePath;
  String? price;
  String? color;
  String? size;
  int? quantity;
  String? discountedPrice;
  String? discountPercent;

  CartDetailModel(
      {this.id,
      this.userId,
      this.cartId,
      this.productId,
      this.productName,
      this.imagePath,
      this.price,
      this.color,
      this.size,
      this.quantity,
      this.discountPercent,this.discountedPrice});

  CartDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    cartId = json['cartId'];
    productId = json['productId'];
    productName = json['productName'];
    imagePath = json['imagePath'];
    price = json['price'];
    color = json['color'];
    size = json['size'];
    quantity = json['quantity'];
    discountPercent = json['discountPercent'];
    discountedPrice = json['discountedPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['cartId'] = this.cartId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['imagePath'] = this.imagePath;
    data['price'] = this.price;
    data['color'] = this.color;
    data['size'] = this.size;
    data['quantity'] = this.quantity;
    data['discountPercent'] = this.discountPercent;
    data['discountedPrice'] = this.discountedPrice;
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
