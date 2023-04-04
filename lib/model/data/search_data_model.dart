class SearchDataModel {
  Pagination? pagination;
  List<SearchList>? searchList;

  SearchDataModel({this.pagination, this.searchList});

  SearchDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['searchList'] != null) {
      searchList = <SearchList>[];
      json['searchList'].forEach((v) {
        searchList!.add(new SearchList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.searchList != null) {
      data['searchList'] = this.searchList!.map((v) => v.toJson()).toList();
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

class SearchList {
  int? id;
  String? userId;
  String? appId;
  String? videoId;
  String? video;
  String? videoUrl;
  int? videoFor;
  String? videoTitle;
  String? videoDescription;
  String? thumbnail;
  int? videoSource;
  String? publishedAt;
  String? videoCategory;
  bool? isYoutube;
  String? youtubeVideoId;
  int? likeCount;
  String? channelId;
  String? channelName;

  SearchList(
      {this.id,
        this.userId,
        this.appId,
        this.videoId,
        this.video,
        this.videoUrl,
        this.videoFor,
        this.videoTitle,
        this.videoDescription,
        this.thumbnail,
        this.videoSource,
        this.publishedAt,
        this.videoCategory,
        this.isYoutube,
        this.youtubeVideoId,
        this.likeCount,
        this.channelId,
        this.channelName});

  SearchList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    appId = json['appId'];
    videoId = json['videoId'];
    video = json['video'];
    videoUrl = json['videoUrl'];
    videoFor = json['videoFor'];
    videoTitle = json['videoTitle'];
    videoDescription = json['videoDescription'];
    thumbnail = json['thumbnail'];
    videoSource = json['videoSource'];
    publishedAt = json['publishedAt'];
    videoCategory = json['videoCategory'];
    isYoutube = json['isYoutube'];
    youtubeVideoId = json['youtubeVideoId'];
    likeCount = json['likeCount'];
    channelId = json['channelId'];
    channelName = json['channelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['appId'] = this.appId;
    data['videoId'] = this.videoId;
    data['video'] = this.video;
    data['videoUrl'] = this.videoUrl;
    data['videoFor'] = this.videoFor;
    data['videoTitle'] = this.videoTitle;
    data['videoDescription'] = this.videoDescription;
    data['thumbnail'] = this.thumbnail;
    data['videoSource'] = this.videoSource;
    data['publishedAt'] = this.publishedAt;
    data['videoCategory'] = this.videoCategory;
    data['isYoutube'] = this.isYoutube;
    data['youtubeVideoId'] = this.youtubeVideoId;
    data['likeCount'] = this.likeCount;
    data['channelId'] = this.channelId;
    data['channelName'] = this.channelName;
    return data;
  }
}