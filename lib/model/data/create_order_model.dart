class CreateOrderModel {
  String? appId;
  String? receipt;
  String? userId;
  int? total;
  String? paymentStatus;
  String? paymentOrderId;
  String? paymentMethod;
  String? gateway;
  String? key;
  String? name;
  String? image;
  bool? retryEnabled;
  int? retryMaxCount;
  bool? sendSmsHash;
  String? description;
  int? timeout;
  String? contact;
  String? email;

  CreateOrderModel(
      {this.appId,
      this.receipt,
      this.userId,
      this.total,
      this.paymentStatus,
      this.paymentOrderId,
      this.paymentMethod,
      this.gateway,
      this.key,
      this.name,
      this.image,
      this.retryEnabled,
      this.retryMaxCount,
      this.sendSmsHash,
      this.description,
      this.timeout,
      this.contact,
      this.email});

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    receipt = json['receipt'];
    userId = json['user_id'];
    total = json['total'];
    paymentStatus = json['payment_status'];
    paymentOrderId = json['payment_order_id'];
    paymentMethod = json['payment_method'];
    gateway = json['gateway'];
    key = json['key'];
    name = json['name'];
    image = json['image'];
    retryEnabled = json['retry_enabled'];
    retryMaxCount = json['retry_max_count'];
    sendSmsHash = json['send_sms_hash'];
    description = json['description'];
    timeout = json['timeout'];
    contact = json['contact'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['receipt'] = this.receipt;
    data['user_id'] = this.userId;
    data['total'] = this.total;
    data['payment_status'] = this.paymentStatus;
    data['payment_order_id'] = this.paymentOrderId;
    data['payment_method'] = this.paymentMethod;
    data['gateway'] = this.gateway;
    data['key'] = this.key;
    data['name'] = this.name;
    data['image'] = this.image;
    data['retry_enabled'] = this.retryEnabled;
    data['retry_max_count'] = this.retryMaxCount;
    data['send_sms_hash'] = this.sendSmsHash;
    data['description'] = this.description;
    data['timeout'] = this.timeout;
    data['contact'] = this.contact;
    data['email'] = this.email;
    return data;
  }
}
