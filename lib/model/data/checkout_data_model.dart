class AddressListModel {
  String? addressId;
  String? appId;
  String? userId;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? firstAddress;
  String? secondAddress;
  String? landmark;
  String? pinCode;
  String? state;
  String? cityName;
  String? country;
  AddressListModel(
      {this.addressId,
        this.appId,
        this.userId,
        this.firstName,
        this.lastName,
        this.mobileNumber,
        this.email,
        this.firstAddress,
        this.secondAddress,
        this.landmark,
        this.pinCode,
        this.state,
        this.cityName,
        this.country});
  AddressListModel.fromJson(Map<String, dynamic> json) {
    addressId = json['addressId'];
    appId = json['appId'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    firstAddress = json['firstAddress'];
    secondAddress = json['secondAddress'];
    landmark = json['landmark'];
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
    data['landmark'] = this.landmark;
    data['pinCode'] = this.pinCode;
    data['state'] = this.state;
    data['cityName'] = this.cityName;
    data['country'] = this.country;
    return data;
  }
}