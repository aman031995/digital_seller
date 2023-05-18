import 'package:TychoStream/model/data/BannerDataModel.dart';

class PromoCodeDataModel {
  Pagination? pagination;
  List<PromocodeList>? promocodeList;

  PromoCodeDataModel({this.pagination, this.promocodeList});

  PromoCodeDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['promocodeList'] != null) {
      promocodeList = <PromocodeList>[];
      json['promocodeList'].forEach((v) {
        promocodeList!.add(new PromocodeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.promocodeList != null) {
      data['promocodeList'] =
          this.promocodeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromocodeList {
  int? couponId;
  String? clientId;
  String? appId;
  String? productId;
  String? categoryId;
  String? promoCodeFor;
  bool? isFirstTimeUser;
  bool? isFreeShipping;
  String? discountTitle;
  String? promoCode;
  String? discount;
  String? description;
  String? toDate;
  String? fromDate;
  int? totalUsageCount;
  int? maxTotalUsageCount;
  int? minCartValue;
  int? maxUsagePerUser;
  bool? isActive;

  PromocodeList(
      {this.couponId,
        this.clientId,
        this.appId,
        this.productId,
        this.categoryId,
        this.promoCodeFor,
        this.isFirstTimeUser,
        this.isFreeShipping,
        this.discountTitle,
        this.promoCode,
        this.discount,
        this.description,
        this.toDate,
        this.fromDate,
        this.totalUsageCount,
        this.maxTotalUsageCount,
        this.minCartValue,
        this.maxUsagePerUser,
        this.isActive});

  PromocodeList.fromJson(Map<String, dynamic> json) {
    couponId = json['couponId'];
    clientId = json['clientId'];
    appId = json['appId'];
    productId = json['productId'];
    categoryId = json['categoryId'];
    promoCodeFor = json['promoCodeFor'];
    isFirstTimeUser = json['isFirstTimeUser'];
    isFreeShipping = json['isFreeShipping'];
    discountTitle = json['discountTitle'];
    promoCode = json['promoCode'];
    discount = json['discount'];
    description = json['description'];
    toDate = json['toDate'];
    fromDate = json['fromDate'];
    totalUsageCount = json['totalUsageCount'];
    maxTotalUsageCount = json['maxTotalUsageCount'];
    minCartValue = json['minCartValue'];
    maxUsagePerUser = json['maxUsagePerUser'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponId'] = this.couponId;
    data['clientId'] = this.clientId;
    data['appId'] = this.appId;
    data['productId'] = this.productId;
    data['categoryId'] = this.categoryId;
    data['promoCodeFor'] = this.promoCodeFor;
    data['isFirstTimeUser'] = this.isFirstTimeUser;
    data['isFreeShipping'] = this.isFreeShipping;
    data['discountTitle'] = this.discountTitle;
    data['promoCode'] = this.promoCode;
    data['discount'] = this.discount;
    data['description'] = this.description;
    data['toDate'] = this.toDate;
    data['fromDate'] = this.fromDate;
    data['totalUsageCount'] = this.totalUsageCount;
    data['maxTotalUsageCount'] = this.maxTotalUsageCount;
    data['minCartValue'] = this.minCartValue;
    data['maxUsagePerUser'] = this.maxUsagePerUser;
    data['isActive'] = this.isActive;
    return data;
  }
}