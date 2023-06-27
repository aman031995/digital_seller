
class BannerDataModel {
  Pagination? pagination;
  List<BannerList>? bannerList;

  BannerDataModel({this.pagination, this.bannerList});

  BannerDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['bannerList'] != null) {
      bannerList = <BannerList>[];
      json['bannerList'].forEach((v) {
        bannerList!.add(new BannerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.bannerList != null) {
      data['bannerList'] = this.bannerList!.map((v) => v.toJson()).toList();
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

class BannerList {
  int? id;
  String? appId;
  String? bannerId;
  String? catId;
  String? productId;
  String? bannerUrl;
  String? bannerTitle;
  String? bannerDescription;
  String? videoUrl;
  String? bannerType;
  bool? isDeleted;

  BannerList(
      {this.id,
        this.appId,
        this.bannerId,
        this.catId,
        this.productId,
        this.bannerUrl,
        this.bannerTitle,
        this.bannerDescription,
        this.videoUrl,
        this.bannerType,
        this.isDeleted});

  BannerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appId = json['appId'];
    bannerId = json['bannerId'];
    catId = json['catId'];
    productId = json['productId'];
    bannerUrl = json['bannerUrl'];
    bannerTitle = json['bannerTitle'];
    bannerDescription = json['bannerDescription'];
    videoUrl = json['videoUrl'];
    bannerType = json['bannerType'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appId'] = this.appId;
    data['bannerId'] = this.bannerId;
    data['catId'] = this.catId;
    data['productId'] = this.productId;
    data['bannerUrl'] = this.bannerUrl;
    data['bannerTitle'] = this.bannerTitle;
    data['bannerDescription'] = this.bannerDescription;
    data['videoUrl'] = this.videoUrl;
    data['bannerType'] = this.bannerType;
    data['isDeleted'] = this.isDeleted;
    return data;
  }
}