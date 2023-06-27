
import 'package:TychoStream/model/data/product_list_model.dart';

class OrderDataModel {
  Pagination? pagination;
  List<OrderList>? orderList;

  OrderDataModel({this.pagination, this.orderList});

  OrderDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['orderList'] != null) {
      orderList = <OrderList>[];
      json['orderList'].forEach((v) {
        orderList!.add(new OrderList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.orderList != null) {
      data['orderList'] = this.orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? current;
  int? numberPerPage;
  bool? hasPrevious;
  int? previous;
  bool? hasNext;
  int? next;
  int? lastPage;

  Pagination(
      {this.current,
        this.numberPerPage,
        this.hasPrevious,
        this.previous,
        this.hasNext,
        this.next,
        this.lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    numberPerPage = json['numberPerPage'];
    hasPrevious = json['has_previous'];
    previous = json['previous'];
    hasNext = json['has_next'];
    next = json['next'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current'] = this.current;
    data['numberPerPage'] = this.numberPerPage;
    data['has_previous'] = this.hasPrevious;
    data['previous'] = this.previous;
    data['has_next'] = this.hasNext;
    data['next'] = this.next;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class OrderList {
  String? appId;
  String? userId;
  String? orderId;
  String? totalPrice;
  String? discountedprice;
  String? shippingCharge;
  String? totalPaidAmount;
  ShippingAddress? shippingAddress;
  String? orderStatus;
  String? orderDate;
  List<ItemDetails>? itemDetails;

  OrderList(
      {this.appId,
        this.userId,
        this.orderId,
        this.totalPrice,
        this.discountedprice,
        this.shippingCharge,
        this.totalPaidAmount,
        this.shippingAddress,
        this.orderStatus,
        this.orderDate,
        this.itemDetails});

  OrderList.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    userId = json['userId'];
    orderId = json['orderId'];
    totalPrice = json['totalPrice'];
    discountedprice = json['discountedprice'];
    shippingCharge = json['shippingCharge'];
    totalPaidAmount = json['totalPaidAmount'];
    shippingAddress = json['shippingAddress'] != null
        ? new ShippingAddress.fromJson(json['shippingAddress'])
        : null;
    orderStatus = json['orderStatus'];
    orderDate = json['orderDate'];
    if (json['itemDetails'] != null) {
      itemDetails = <ItemDetails>[];
      json['itemDetails'].forEach((v) {
        itemDetails!.add(new ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appId'] = this.appId;
    data['userId'] = this.userId;
    data['orderId'] = this.orderId;
    data['totalPrice'] = this.totalPrice;
    data['discountedprice'] = this.discountedprice;
    data['shippingCharge'] = this.shippingCharge;
    data['totalPaidAmount'] = this.totalPaidAmount;
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress!.toJson();
    }
    data['orderStatus'] = this.orderStatus;
    data['orderDate'] = this.orderDate;
    if (this.itemDetails != null) {
      data['itemDetails'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShippingAddress {
  String? addressId;
  String? appId;
  String? userId;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? firstAddress;
  String? secondAddress;
  String? pinCode;
  String? state;
  String? cityName;
  String? country;

  ShippingAddress(
      {this.addressId,
        this.appId,
        this.userId,
        this.firstName,
        this.lastName,
        this.mobileNumber,
        this.email,
        this.firstAddress,
        this.secondAddress,
        this.pinCode,
        this.state,
        this.cityName,
        this.country});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    addressId = json['addressId'];
    appId = json['appId'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    firstAddress = json['firstAddress'];
    secondAddress = json['secondAddress'];
    pinCode = json['pinCode'];
    state = json['state'];
    cityName = json['cityName'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressId'] = this.addressId;
    data['appId'] = this.appId;
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['mobileNumber'] = this.mobileNumber;
    data['email'] = this.email;
    data['firstAddress'] = this.firstAddress;
    data['secondAddress'] = this.secondAddress;
    data['pinCode'] = this.pinCode;
    data['state'] = this.state;
    data['cityName'] = this.cityName;
    data['country'] = this.country;
    return data;
  }
}

class ItemDetails {
  String? appId;
  String? categoryId;
  String? categoryName;
  Null? subCategoryId;
  String? subCategoryName;
  String? productId;
  String? productName;
  String? productTypeName;
  ProductDetails? productDetails;
  List<Null>? productReviews;
  List<ProductSkuDetails>? productSkuDetails;
  int? cartQuantity;

  ItemDetails(
      {this.appId,
        this.categoryId,
        this.categoryName,
        this.subCategoryId,
        this.subCategoryName,
        this.productId,
        this.productName,
        this.productTypeName,
        this.productDetails,
        this.productReviews,
        this.productSkuDetails,
        this.cartQuantity});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    subCategoryId = json['subCategoryId'];
    subCategoryName = json['subCategoryName'];
    productId = json['productId'];
    productName = json['productName'];
    productTypeName = json['productTypeName'];
    productDetails = json['productDetails'] != null
        ? new ProductDetails.fromJson(json['productDetails'])
        : null;
    if (json['productReviews'] != null) {
      // productReviews = <Null>[];
      // json['productReviews'].forEach((v) {
      //   productReviews!.add(new Null.fromJson(v));
      // });
    }
    if (json['productSkuDetails'] != null) {
      productSkuDetails = <ProductSkuDetails>[];
      json['productSkuDetails'].forEach((v) {
        productSkuDetails!.add(new ProductSkuDetails.fromJson(v));
      });
    }
    cartQuantity = json['cartQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appId'] = this.appId;
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['subCategoryId'] = this.subCategoryId;
    data['subCategoryName'] = this.subCategoryName;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productTypeName'] = this.productTypeName;
    if (this.productDetails != null) {
      data['productDetails'] = this.productDetails!.toJson();
    }
    if (this.productReviews != null) {
      // data['productReviews'] =
      //     this.productReviews!.map((v) => v.toJson()).toList();
    }
    if (this.productSkuDetails != null) {
      data['productSkuDetails'] =
          this.productSkuDetails!.map((v) => v.toJson()).toList();
    }
    data['cartQuantity'] = this.cartQuantity;
    return data;
  }
}

