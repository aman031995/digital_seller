import 'package:tycho_streams/model/data/BannerDataModel.dart';

class HomePageDataModel {
  Pagination? pagination;
  List<VideoList>? videoList;

  HomePageDataModel({this.pagination, this.videoList});

  HomePageDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['videoList'] != null) {
      videoList = <VideoList>[];
      json['videoList'].forEach((v) {
        videoList!.add(new VideoList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.videoList != null) {
      data['videoList'] = this.videoList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoList {
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
   String?videoCategory;
  bool? isYoutube;
  String? youtubeVideoId;

  VideoList(
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
        this.youtubeVideoId});

  VideoList.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class PlatformMovieData {
  String? key;
  String? pageIndex;
  String? displayTitle;
  List<VideoList>? content;
  List<VideoList>? contentStore;

  PlatformMovieData(String key, String title, List<VideoList> movieContent) {
    this.key = key;
    this.displayTitle = title;
    this.content = movieContent;
    this.contentStore = movieContent;
  }
}
