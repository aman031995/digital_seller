class AppConfigModel {
  int? id;
  String? clientId;
  String? appId;
  String? appName;
  String? appType;
  String? fileBaseUrl;
  AndroidConfig? androidConfig;
  String? iosConfig;

  AppConfigModel(
      {this.id,
        this.clientId,
        this.appId,
        this.appName,
        this.appType,
        this.fileBaseUrl,
        this.androidConfig,
        this.iosConfig});

  AppConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    appId = json['appId'];
    appName = json['appName'];
    appType = json['appType'];
    fileBaseUrl = json['fileBaseUrl'];
    androidConfig = json['androidConfig'] != null
        ? new AndroidConfig.fromJson(json['androidConfig'])
        : null;
    iosConfig = json['iosConfig'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['clientId'] = this.clientId;
    data['appId'] = this.appId;
    data['appName'] = this.appName;
    data['appType'] = this.appType;
    data['fileBaseUrl'] = this.fileBaseUrl;
    if (this.androidConfig != null) {
      data['androidConfig'] = this.androidConfig!.toJson();
    }
    data['iosConfig'] = this.iosConfig;
    return data;
  }
}

class AndroidConfig {
  String? images;
  String? googleServiceFile;
  bool? pushNotification;
  DeviceOrientation? deviceOrientation;
  AppTheme? appTheme;
  FontStyle? fontStyle;
  SocialMedia? socialMedia;
  Localization? localization;
  bool? loginWithPhone;
  int? maxOtp;
  SocialLogin? socialLogin;
  AppVersion? appVersion;
  List<BottomNavigation>? bottomNavigation;

  AndroidConfig(
      {this.images,
        this.googleServiceFile,
        this.pushNotification,
        this.deviceOrientation,
        this.appTheme,
        this.fontStyle,
        this.socialMedia,
        this.localization,
        this.loginWithPhone,
        this.maxOtp,
        this.socialLogin,
        this.appVersion,
        this.bottomNavigation});

  AndroidConfig.fromJson(Map<String, dynamic> json) {
    images = json['images'];
    googleServiceFile = json['googleServiceFile'];
    pushNotification = json['pushNotification'];
    deviceOrientation = json['deviceOrientation'] != null
        ? new DeviceOrientation.fromJson(json['deviceOrientation'])
        : null;
    appTheme = json['appTheme'] != null
        ? new AppTheme.fromJson(json['appTheme'])
        : null;
    fontStyle = json['fontStyle'] != null
        ? new FontStyle.fromJson(json['fontStyle'])
        : null;
    socialMedia = json['socialMedia'] != null
        ? new SocialMedia.fromJson(json['socialMedia'])
        : null;
    localization = json['localization'] != null
        ? new Localization.fromJson(json['localization'])
        : null;
    loginWithPhone = json['loginWithPhone'];
    maxOtp = json['maxOtp'];
    socialLogin = json['socialLogin'] != null
        ? new SocialLogin.fromJson(json['socialLogin'])
        : null;
    appVersion = json['appVersion'] != null
        ? new AppVersion.fromJson(json['appVersion'])
        : null;
    if (json['bottomNavigation'] != null) {
      bottomNavigation = <BottomNavigation>[];
      json['bottomNavigation'].forEach((v) {
        bottomNavigation!.add(new BottomNavigation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['googleServiceFile'] = this.googleServiceFile;
    data['pushNotification'] = this.pushNotification;
    if (this.deviceOrientation != null) {
      data['deviceOrientation'] = this.deviceOrientation!.toJson();
    }
    if (this.appTheme != null) {
      data['appTheme'] = this.appTheme!.toJson();
    }
    if (this.fontStyle != null) {
      data['fontStyle'] = this.fontStyle!.toJson();
    }
    if (this.socialMedia != null) {
      data['socialMedia'] = this.socialMedia!.toJson();
    }
    if (this.localization != null) {
      data['localization'] = this.localization!.toJson();
    }
    data['loginWithPhone'] = this.loginWithPhone;
    data['maxOtp'] = this.maxOtp;
    if (this.socialLogin != null) {
      data['socialLogin'] = this.socialLogin!.toJson();
    }
    if (this.appVersion != null) {
      data['appVersion'] = this.appVersion!.toJson();
    }
    if (this.bottomNavigation != null) {
      data['bottomNavigation'] =
          this.bottomNavigation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeviceOrientation {
  bool? isportrait;

  DeviceOrientation({this.isportrait});

  DeviceOrientation.fromJson(Map<String, dynamic> json) {
    isportrait = json['isportrait'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isportrait'] = this.isportrait;
    return data;
  }
}

class AppTheme {
  ThemeColor? themeColor;
  ThemeColor? primaryColor;
  ThemeColor? secondaryColor;
  ThemeColor? textColor;

  AppTheme(
      {this.themeColor,
        this.primaryColor,
        this.secondaryColor,
        this.textColor});

  AppTheme.fromJson(Map<String, dynamic> json) {
    themeColor = json['themeColor'] != null
        ? new ThemeColor.fromJson(json['themeColor'])
        : null;
    primaryColor = json['primaryColor'] != null
        ? new ThemeColor.fromJson(json['primaryColor'])
        : null;
    secondaryColor = json['secondaryColor'] != null
        ? new ThemeColor.fromJson(json['secondaryColor'])
        : null;
    textColor = json['textColor'] != null
        ? new ThemeColor.fromJson(json['textColor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.themeColor != null) {
      data['themeColor'] = this.themeColor!.toJson();
    }
    if (this.primaryColor != null) {
      data['primaryColor'] = this.primaryColor!.toJson();
    }
    if (this.secondaryColor != null) {
      data['secondaryColor'] = this.secondaryColor!.toJson();
    }
    if (this.textColor != null) {
      data['textColor'] = this.textColor!.toJson();
    }
    return data;
  }
}

class ThemeColor {
  List<int>? rgba;
  String? hex;

  ThemeColor({this.rgba, this.hex});

  ThemeColor.fromJson(Map<String, dynamic> json) {
    rgba = json['rgba'].cast<int>();
    hex = json['hex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rgba'] = this.rgba;
    data['hex'] = this.hex;
    return data;
  }
}

class FontStyle {
  String? fontFamily;

  FontStyle({this.fontFamily});

  FontStyle.fromJson(Map<String, dynamic> json) {
    fontFamily = json['fontFamily'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fontFamily'] = this.fontFamily;
    return data;
  }
}

class SocialMedia {
  SocialMediaUrl? instagram;
  SocialMediaUrl? facebook;
  SocialMediaUrl? youtube;
  SocialMediaUrl? twitter;

  SocialMedia({this.instagram, this.facebook, this.youtube, this.twitter});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    instagram = json['instagram'] != null
        ? new SocialMediaUrl.fromJson(json['instagram'])
        : null;
    facebook = json['facebook'] != null
        ? new SocialMediaUrl.fromJson(json['facebook'])
        : null;
    youtube = json['youtube'] != null
        ? new SocialMediaUrl.fromJson(json['youtube'])
        : null;
    twitter = json['twitter'] != null
        ? new SocialMediaUrl.fromJson(json['twitter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.instagram != null) {
      data['instagram'] = this.instagram!.toJson();
    }
    if (this.facebook != null) {
      data['facebook'] = this.facebook!.toJson();
    }
    if (this.youtube != null) {
      data['youtube'] = this.youtube!.toJson();
    }
    if (this.twitter != null) {
      data['twitter'] = this.twitter!.toJson();
    }
    return data;
  }
}

class SocialMediaUrl {
  String? url;

  SocialMediaUrl({this.url});

  SocialMediaUrl.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}

class Localization {
  String? text;

  Localization({this.text});

  Localization.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}

class SocialLogin {
  SocialLoginData? facebook;
  SocialLoginData? google;

  SocialLogin({this.facebook, this.google});

  SocialLogin.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'] != null
        ? new SocialLoginData.fromJson(json['facebook'])
        : null;
    google =
    json['google'] != null ? new SocialLoginData.fromJson(json['google']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.facebook != null) {
      data['facebook'] = this.facebook!.toJson();
    }
    if (this.google != null) {
      data['google'] = this.google!.toJson();
    }
    return data;
  }
}

class SocialLoginData {
  String? apiKey;
  String? appId;
  String? clientToken;

  SocialLoginData({this.apiKey, this.appId, this.clientToken});

  SocialLoginData.fromJson(Map<String, dynamic> json) {
    apiKey = json['apiKey'];
    appId = json['appId'];
    clientToken = json['clientToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apiKey'] = this.apiKey;
    data['appId'] = this.appId;
    data['clientToken'] = this.clientToken;
    return data;
  }
}

class AppVersion {
  String? version;
  String? url;

  AppVersion({this.version, this.url});

  AppVersion.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['url'] = this.url;
    return data;
  }
}

class BottomNavigation {
  String? title;
  String? icon;
  String? url;

  BottomNavigation({this.title, this.icon, this.url});

  BottomNavigation.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    icon = json['icon'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['icon'] = this.icon;
    data['url'] = this.url;
    return data;
  }
}