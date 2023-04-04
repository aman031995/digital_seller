class UserInfoModel {
  int? id;
  String? userId;
  String? name;
  String? phone;
  String? email;
  String? profilePic;
  String? address;
  bool? isVerified;
  bool? isDeleted;
  String? loginToken;
  bool? isSocial;
  bool? firstTimeSocial;
  bool? isRegistered;

  UserInfoModel(
      {this.id,
        this.userId,
        this.name,
        this.phone,
        this.email,
        this.profilePic,
        this.address,
        this.isVerified,
        this.isDeleted,
        this.loginToken,
        this.isSocial,
        this.firstTimeSocial,
        this.isRegistered});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    profilePic = json['profilePic'];
    address = json['address'];
    isVerified = json['isVerified'];
    isDeleted = json['isDeleted'];
    loginToken = json['loginToken'];
    isSocial = json['is_social'];
    firstTimeSocial = json['first_time_social'];
    isRegistered = json['isRegistered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['profilePic'] = this.profilePic;
    data['address'] = this.address;
    data['isVerified'] = this.isVerified;
    data['isDeleted'] = this.isDeleted;
    data['loginToken'] = this.loginToken;
    data['is_social'] = this.isSocial;
    data['first_time_social'] = this.firstTimeSocial;
    data['isRegistered'] = this.isRegistered;
    return data;
  }
}