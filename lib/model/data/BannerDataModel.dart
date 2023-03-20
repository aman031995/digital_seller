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
  String? clientId;
  String? bannerId;
  String? bannerFile;
  String? bannerTitle;
  String? bannerDescription;
  String? bannerUrl;

  BannerList(
      {this.id,
        this.appId,
        this.clientId,
        this.bannerId,
        this.bannerFile,
        this.bannerTitle,
        this.bannerDescription,
        this.bannerUrl});

  BannerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appId = json['appId'];
    clientId = json['clientId'];
    bannerId = json['bannerId'];
    bannerFile = json['bannerFile'];
    bannerTitle = json['bannerTitle'];
    bannerDescription = json['bannerDescription'];
    bannerUrl = json['bannerUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appId'] = this.appId;
    data['clientId'] = this.clientId;
    data['bannerId'] = this.bannerId;
    data['bannerFile'] = this.bannerFile;
    data['bannerTitle'] = this.bannerTitle;
    data['bannerDescription'] = this.bannerDescription;
    data['bannerUrl'] = this.bannerUrl;
    return data;
  }
}