
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
  String? orderItemId;
  String? productId;
  String? productName;
  String? variantId;
  VariationSku? variationSku;
  List<String>? productImages;
  String? shippingCharge;
  int? quantity;
  String? productFinalPrice;
  String? orderDate;
  String? orderStatus;
  int? orderStatusId;
  ShippingAddress? shippingAddress;
  String? deliveryDate;
  OrderTracking? orderTracking;

  OrderList(
      {this.appId,
        this.userId,
        this.orderId,
        this.orderItemId,
        this.productId,
        this.productName,
        this.variantId,
        this.variationSku,
        this.productImages,
        this.shippingCharge,
        this.quantity,
        this.productFinalPrice,
        this.orderDate,
        this.orderStatus,
        this.orderStatusId,
        this.shippingAddress,
        this.deliveryDate,
        this.orderTracking});

  OrderList.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    userId = json['userId'];
    orderId = json['orderId'];
    orderItemId = json['orderItemId'];
    productId = json['productId'];
    productName = json['productName'];
    variantId = json['variantId'];
    variationSku = json['variationSku'] != null
        ? new VariationSku.fromJson(json['variationSku'])
        : null;
    productImages = json['productImages'].cast<String>();
    shippingCharge = json['shippingCharge'];
    quantity = json['quantity'];
    productFinalPrice = json['productFinalPrice'];
    orderDate = json['orderDate'];
    orderStatus = json['orderStatus'];
    orderStatusId = json['orderStatusId'];
    shippingAddress = json['shippingAddress'] != null
        ? new ShippingAddress.fromJson(json['shippingAddress'])
        : null;
    deliveryDate = json['deliveryDate'];
    orderTracking = json['orderTracking'] != null
        ? new OrderTracking.fromJson(json['orderTracking'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appId'] = this.appId;
    data['userId'] = this.userId;
    data['orderId'] = this.orderId;
    data['orderItemId'] = this.orderItemId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['variantId'] = this.variantId;
    if (this.variationSku != null) {
      data['variationSku'] = this.variationSku!.toJson();
    }
    data['productImages'] = this.productImages;
    data['shippingCharge'] = this.shippingCharge;
    data['quantity'] = this.quantity;
    data['productFinalPrice'] = this.productFinalPrice;
    data['orderDate'] = this.orderDate;
    data['orderStatus'] = this.orderStatus;
    data['orderStatusId'] = this.orderStatusId;
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress!.toJson();
    }
    if (this.orderTracking != null) {
      data['orderTracking'] = this.orderTracking!.toJson();
    }
    return data;
  }
}

class VariationSku {
  Size? size;
  Size? color;
  Size? materialType;

  VariationSku({this.size, this.color, this.materialType});

  VariationSku.fromJson(Map<String, dynamic> json) {
    size = json['size'] != null ? new Size.fromJson(json['size']) : null;
    color = json['color'] != null ? new Size.fromJson(json['color']) : null;
    materialType = json['material_type'] != null
        ? new Size.fromJson(json['material_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.size != null) {
      data['size'] = this.size!.toJson();
    }
    if (this.color != null) {
      data['color'] = this.color!.toJson();
    }
    if (this.materialType != null) {
      data['material_type'] = this.materialType!.toJson();
    }
    return data;
  }
}

class Size {
  String? name;
  String? val;

  Size({this.name, this.val});

  Size.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    val = json['val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['val'] = this.val;
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

class OrderTracking {
  int? activeIndex;
  List<TrackStatus>? trackStatus;

  OrderTracking({this.activeIndex, this.trackStatus});

  OrderTracking.fromJson(Map<String, dynamic> json) {
    activeIndex = json['active_index'];
    if (json['track_status'] != null) {
      trackStatus = <TrackStatus>[];
      json['track_status'].forEach((v) {
        trackStatus!.add(new TrackStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active_index'] = this.activeIndex;
    if (this.trackStatus != null) {
      data['track_status'] = this.trackStatus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrackStatus {
  int? id;
  String? displayOrder;

  TrackStatus({this.id, this.displayOrder});

  TrackStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayOrder = json['display_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['display_order'] = this.displayOrder;
    return data;
  }
}
