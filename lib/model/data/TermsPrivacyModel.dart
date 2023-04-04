class TermsPrivacyModel {
  String? pageId;
  String? pageTitle;
  String? pageDescription;
  String? pageSlug;
  String? pageIcon;
  bool? isDisabled;
  bool? isDeleted;

  TermsPrivacyModel(
      {this.pageId,
        this.pageTitle,
        this.pageDescription,
        this.pageSlug,
        this.pageIcon,
        this.isDisabled,
        this.isDeleted});

  TermsPrivacyModel.fromJson(Map<String, dynamic> json) {
    pageId = json['pageId'];
    pageTitle = json['pageTitle'];
    pageDescription = json['pageDescription'];
    pageSlug = json['pageSlug'];
    pageIcon = json['pageIcon'];
    isDisabled = json['isDisabled'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageId'] = this.pageId;
    data['pageTitle'] = this.pageTitle;
    data['pageDescription'] = this.pageDescription;
    data['pageSlug'] = this.pageSlug;
    data['pageIcon'] = this.pageIcon;
    data['isDisabled'] = this.isDisabled;
    data['isDeleted'] = this.isDeleted;
    return data;
  }
}