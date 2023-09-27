

class NotificationModel {
  Pagination? pagination;
  List<NotificationList>? notificationList;

  NotificationModel({this.pagination, this.notificationList});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['notificationList'] != null) {
      notificationList = <NotificationList>[];
      json['notificationList'].forEach((v) {
        notificationList!.add(new NotificationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.notificationList != null) {
      data['notificationList'] =
          this.notificationList!.map((v) => v.toJson()).toList();
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

class NotificationList {
  int? id;
  String? userId;
  String? notification;
  NotificationText? notificationText;
  String? title;
  String? log;
  bool? read;
  String? clickAction;
  String? productId;
  String? videoId;
  String? clickType;
  String? createdAt;
  String? updatedAt;

  NotificationList(
      {this.id,
        this.userId,
        this.notification,
        this.notificationText,
        this.title,
        this.log,
        this.read,
        this.clickAction,
        this.productId,
        this.videoId,
        this.clickType,
        this.createdAt,
        this.updatedAt});

  NotificationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    notification = json['notification'];
    notificationText = json['notificationText'] != null
        ? new NotificationText.fromJson(json['notificationText'])
        : null;
    title = json['title'];
    log = json['log'];
    read = json['read'];
    clickAction = json['clickAction'];
    productId = json['productId'];
    videoId = json['videoId'];
    clickType = json['clickType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['notification'] = this.notification;
    if (this.notificationText != null) {
      data['notificationText'] = this.notificationText!.toJson();
    }
    data['title'] = this.title;
    data['log'] = this.log;
    data['read'] = this.read;
    data['clickAction'] = this.clickAction;
    data['productId'] = this.productId;
    data['videoId'] = this.videoId;
    data['clickType'] = this.clickType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class NotificationText {
  String? appId;
  String? userId;
  String? orderId;
  String? action;
  String? clickType;

  NotificationText(
      {this.appId, this.userId, this.orderId, this.action, this.clickType});

  NotificationText.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    userId = json['user_id'];
    orderId = json['orderId'];
    action = json['action'];
    clickType = json['clickType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['user_id'] = this.userId;
    data['orderId'] = this.orderId;
    data['action'] = this.action;
    data['clickType'] = this.clickType;
    return data;
  }
}
