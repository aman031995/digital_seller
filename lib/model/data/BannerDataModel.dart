class BannerDataModel {
  Pagination? pagination;
  List<CarouselList>? carouselList;

  BannerDataModel({this.pagination, this.carouselList});

  BannerDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['carouselList'] != null) {
      carouselList = <CarouselList>[];
      json['carouselList'].forEach((v) {
        carouselList!.add(new CarouselList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.carouselList != null) {
      data['carouselList'] = this.carouselList!.map((v) => v.toJson()).toList();
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

class CarouselList {
  int? id;
  String? appId;
  String? carouselId;
  String? image;
  String? title;
  String? description;
  String? link;
  String? bannerImage;
  String? bannerUrl;
  String? bannerType;
  String? videoUrl;
  String? productId;
  String? categoryId;

  CarouselList(
      {this.id,
        this.appId,
        this.carouselId,
        this.image,
        this.title,
        this.description,
        this.link,
        this.bannerImage,
        this.bannerUrl,
        this.bannerType,
        this.videoUrl,
        this.productId,
        this.categoryId});

  CarouselList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appId = json['appId'];
    carouselId = json['carouselId'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    link = json['link'];
    bannerImage = json['bannerImage'];
    bannerUrl = json['bannerUrl'];
    bannerType = json['bannerType'];
    videoUrl = json['videoUrl'];
    productId = json['productId'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appId'] = this.appId;
    data['carouselId'] = this.carouselId;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    data['link'] = this.link;
    data['bannerImage'] = this.bannerImage;
    data['bannerUrl'] = this.bannerUrl;
    data['bannerType'] = this.bannerType;
    data['videoUrl'] = this.videoUrl;
    data['productId'] = this.productId;
    data['categoryId'] = this.categoryId;
    return data;
  }
}
