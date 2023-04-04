class CheckOutDataModel {
  int? itemsCount;
  String? price;
  String? discount;
  String? deliveryCharge;
  String? totalAmount;
  List<Address>? address;

  CheckOutDataModel(
      {this.itemsCount,
        this.price,
        this.discount,
        this.deliveryCharge,
        this.totalAmount,
      this.address});

  CheckOutDataModel.fromJson(Map<String, dynamic> json) {
    itemsCount = json['items_count'];
    price = json['price'];
    discount = json['discount'];
    deliveryCharge = json['delivery_charge'];
    totalAmount = json['total_amount'];
    if (json['address'] != null) {
      address = <Address>[];
      json['address'].forEach((v) {
        address!.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['items_count'] = this.itemsCount;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['delivery_charge'] = this.deliveryCharge;
    data['total_amount'] = this.totalAmount;
    if (this.address != null) {
      data['address'] = this.address!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
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
  String? createdAt;
  String? updatedAt;

  Address(
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
        this.isDeleted,
        this.createdAt,
        this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}