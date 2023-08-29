class OfferDiscountModel {
  int? id;
  String? appId;
  String? title;
  String? discountPercentage;
  String? images;
  String? isDeleted;
  String? isEnable;
  String? categoryId;

  OfferDiscountModel(
      {this.id,
        this.appId,
        this.title,
        this.discountPercentage,
        this.images,
        this.isDeleted,
        this.isEnable,
        this.categoryId});

  OfferDiscountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appId = json['appId'];
    title = json['title'];
    discountPercentage = json['discountPercentage'];
    images = json['images'];
    isDeleted = json['is_deleted'];
    isEnable = json['isEnable'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appId'] = this.appId;
    data['title'] = this.title;
    data['discountPercentage'] = this.discountPercentage;
    data['images'] = this.images;
    data['is_deleted'] = this.isDeleted;
    data['isEnable'] = this.isEnable;
    data['categoryId'] = this.categoryId;
    return data;
  }
}
