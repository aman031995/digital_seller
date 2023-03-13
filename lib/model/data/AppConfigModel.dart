class AppConfigModel {
  int? id;
  String? clientId;
  String? appId;
  String? appName;
  String? fileBaseUrl;
  AndroidConfig? androidConfig;
  String? iosConfig;

  AppConfigModel(
      {this.id,
        this.clientId,
        this.appId,
        this.appName,
        this.fileBaseUrl,
        this.androidConfig,
        this.iosConfig});

  AppConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    appId = json['appId'];
    appName = json['appName'];
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
  String? keystoreFile;
  String? googleServiceFile;
  String? baseUrl;
  String? termsUrl;
  String? privacyUrl;
  String? faqUrl;
  bool? pushNotification;
  DeviceOrientation? deviceOrientation;
  AppTheme? appTheme;
  FontStyle? fontStyle;
  SocialMedia? socialMedia;
  AppVersion? appVersion;
  Localization? localization;
  SocialLogin? socialLogin;
  AppMenu? appMenu;
  List<Map<String, dynamic>>? appMenuItems = [];

  AndroidConfig(
      {this.images,
        this.keystoreFile,
        this.googleServiceFile,
        this.baseUrl,
        this.termsUrl,
        this.privacyUrl,
        this.faqUrl,
        this.pushNotification,
        this.deviceOrientation,
        this.appTheme,
        this.fontStyle,
        this.socialMedia,
        this.appVersion,
        this.localization,
        this.socialLogin,
        this.appMenu});

  AndroidConfig.fromJson(Map<String, dynamic> json) {
    images = json['images'];
    keystoreFile = json['keystoreFile'];
    googleServiceFile = json['googleServiceFile'];
    baseUrl = json['baseUrl'];
    termsUrl = json['termsUrl'];
    privacyUrl = json['privacyUrl'];
    faqUrl = json['faqUrl'];
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
    appVersion = json['appVersion'] != null
        ? new AppVersion.fromJson(json['appVersion'])
        : null;
    localization = json['localization'] != null
        ? new Localization.fromJson(json['localization'])
        : null;
    socialLogin = json['socialLogin'] != null
        ? new SocialLogin.fromJson(json['socialLogin'])
        : null;
    appMenu = json['appMenu'] != null ? new AppMenu.fromJson(json['appMenu']) : null;
    if (json['appMenu'] != null) {
      Map<String, dynamic> appMenuMap = json['appMenu'];
      appMenuItems = appMenuMap.values.cast<Map<String, dynamic>>().toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['keystoreFile'] = this.keystoreFile;
    data['googleServiceFile'] = this.googleServiceFile;
    data['baseUrl'] = this.baseUrl;
    data['termsUrl'] = this.termsUrl;
    data['privacyUrl'] = this.privacyUrl;
    data['faqUrl'] = this.faqUrl;
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
    if (this.appVersion != null) {
      data['appVersion'] = this.appVersion!.toJson();
    }
    if (this.localization != null) {
      data['localization'] = this.localization!.toJson();
    }
    if (this.socialLogin != null) {
      data['socialLogin'] = this.socialLogin!.toJson();
    }
    if (this.appMenu != null) {
      data['appMenu'] = this.appMenu!.toJson();
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

  AppTheme({this.themeColor, this.primaryColor, this.secondaryColor});

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
  Instagram? instagram;
  Instagram? twitter;

  SocialMedia({this.instagram, this.twitter});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    instagram = json['instagram'] != null
        ? new Instagram.fromJson(json['instagram'])
        : null;
    twitter = json['twitter'] != null
        ? new Instagram.fromJson(json['twitter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.instagram != null) {
      data['instagram'] = this.instagram!.toJson();
    }
    if (this.twitter != null) {
      data['twitter'] = this.twitter!.toJson();
    }
    return data;
  }
}

class Instagram {
  String? url;
  String? appId;
  String? pixelId;
  String? clientToken;

  Instagram({this.url, this.appId, this.pixelId, this.clientToken});

  Instagram.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    appId = json['appId'];
    pixelId = json['pixelId'];
    clientToken = json['clientToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['appId'] = this.appId;
    data['pixelId'] = this.pixelId;
    data['clientToken'] = this.clientToken;
    return data;
  }
}

class AppVersion {
  Ios? ios;
  Ios? android;

  AppVersion({this.ios, this.android});

  AppVersion.fromJson(Map<String, dynamic> json) {
    ios = json['ios'] != null ? new Ios.fromJson(json['ios']) : null;
    android =
    json['android'] != null ? new Ios.fromJson(json['android']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ios != null) {
      data['ios'] = this.ios!.toJson();
    }
    if (this.android != null) {
      data['android'] = this.android!.toJson();
    }
    return data;
  }
}

class Ios {
  String? version;
  String? url;

  Ios({this.version, this.url});

  Ios.fromJson(Map<String, dynamic> json) {
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
  Facebook? facebook;
  Facebook? google;

  SocialLogin({this.facebook, this.google});

  SocialLogin.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'] != null
        ? new Facebook.fromJson(json['facebook'])
        : null;
    google =
    json['google'] != null ? new Facebook.fromJson(json['google']) : null;
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

class Facebook {
  String? apiKey;
  String? appId;
  String? clientToken;

  Facebook({this.apiKey, this.appId, this.clientToken});

  Facebook.fromJson(Map<String, dynamic> json) {
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

class AppMenu {
  HelpFaqs? helpFaqs;
  HelpFaqs? shareApp;

  AppMenu({this.helpFaqs, this.shareApp});

  AppMenu.fromJson(Map<String, dynamic> json) {
    helpFaqs = json['help_faqs'] != null
        ? new HelpFaqs.fromJson(json['help_faqs'])
        : null;
    shareApp = json['share_app'] != null
        ? new HelpFaqs.fromJson(json['share_app'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.helpFaqs != null) {
      data['help_faqs'] = this.helpFaqs!.toJson();
    }
    if (this.shareApp != null) {
      data['share_app'] = this.shareApp!.toJson();
    }
    return data;
  }
}

class HelpFaqs {
  String? alias;
  String? icon;
  String? subtitle;

  HelpFaqs({this.alias, this.icon, this.subtitle});

  HelpFaqs.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    icon = json['icon'];
    subtitle = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alias'] = this.alias;
    data['icon'] = this.icon;
    data['subtitle'] = this.subtitle;
    return data;
  }
}
