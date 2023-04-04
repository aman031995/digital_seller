class OrderDataModel {
  String? appId;
  String? userId;
  String? subTotal;
  String? discount;
  String? shippingCharge;
  String? total;
  String? orderStatus;
  ShippingAddress? shippingAddress;
  ShippingAddress? billingAddress;
  List<Items>? items;

  OrderDataModel(
      {this.appId,
        this.userId,
        this.subTotal,
        this.discount,
        this.shippingCharge,
        this.total,
        this.orderStatus,
        this.shippingAddress,
        this.billingAddress,
        this.items});

  OrderDataModel.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    userId = json['user_id'];
    subTotal = json['sub_total'];
    discount = json['discount'];
    shippingCharge = json['shipping_charge'];
    total = json['total'];
    orderStatus = json['order_status'];
    shippingAddress = json['shipping_address'] != null
        ? new ShippingAddress.fromJson(json['shipping_address'])
        : null;
    billingAddress = json['billing_address'] != null
        ? new ShippingAddress.fromJson(json['billing_address'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['user_id'] = this.userId;
    data['sub_total'] = this.subTotal;
    data['discount'] = this.discount;
    data['shipping_charge'] = this.shippingCharge;
    data['total'] = this.total;
    data['order_status'] = this.orderStatus;
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    if (this.billingAddress != null) {
      data['billing_address'] = this.billingAddress!.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShippingAddress {
  int? id;
  String? addressId;
  String? userId;
  String? appId;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? firstAddress;
  String? secondAddress;
  int? pinCode;
  String? state;
  String? cityName;
  String? country;
  int? isDeleted;

  ShippingAddress(
      {this.id,
        this.addressId,
        this.userId,
        this.appId,
        this.firstName,
        this.lastName,
        this.mobileNumber,
        this.email,
        this.firstAddress,
        this.secondAddress,
        this.pinCode,
        this.state,
        this.cityName,
        this.country,
        this.isDeleted});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressId = json['address_id'];
    userId = json['user_id'];
    appId = json['app_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    firstAddress = json['first_address'];
    secondAddress = json['second_address'];
    pinCode = json['pin_code'];
    state = json['state'];
    cityName = json['city_name'];
    country = json['country'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_id'] = this.addressId;
    data['user_id'] = this.userId;
    data['app_id'] = this.appId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['first_address'] = this.firstAddress;
    data['second_address'] = this.secondAddress;
    data['pin_code'] = this.pinCode;
    data['state'] = this.state;
    data['city_name'] = this.cityName;
    data['country'] = this.country;
    data['is_deleted'] = this.isDeleted;
    return data;
  }
}

class Items {
  String? productCode;
  String? productName;
  String? imagePath;
  String? description;
  String? productId;
  String? size;
  String? color;
  String? productPrice;
  int? qty;
  String? discount;
  String? total;
  String? shippingCharge;

  Items(
      {this.productCode,
        this.productName,
        this.imagePath,
        this.description,
        this.productId,
        this.size,
        this.color,
        this.productPrice,
        this.qty,
        this.discount,
        this.total,
        this.shippingCharge});

  Items.fromJson(Map<String, dynamic> json) {
    productCode = json['product_code'];
    productName = json['product_name'];
    imagePath = json['image_path'];
    description = json['description'];
    productId = json['product_id'];
    size = json['size'];
    color = json['color'];
    productPrice = json['product_price'];
    qty = json['qty'];
    discount = json['discount'];
    total = json['total'];
    shippingCharge = json['shipping_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_code'] = this.productCode;
    data['product_name'] = this.productName;
    data['image_path'] = this.imagePath;
    data['description'] = this.description;
    data['product_id'] = this.productId;
    data['size'] = this.size;
    data['color'] = this.color;
    data['product_price'] = this.productPrice;
    data['qty'] = this.qty;
    data['discount'] = this.discount;
    data['total'] = this.total;
    data['shipping_charge'] = this.shippingCharge;
    return data;
  }
}