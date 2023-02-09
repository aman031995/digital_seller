import 'package:tycho_streams/model/data/BannerDataModel.dart';

class CategoryDataModel {
  Pagination? pagination;
  List<CategoryList>? categoryList;

  CategoryDataModel({this.pagination, this.categoryList});

  CategoryDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['categoryList'] != null) {
      categoryList = <CategoryList>[];
      json['categoryList'].forEach((v) {
        categoryList!.add(new CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.categoryList != null) {
      data['categoryList'] = this.categoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryList {
  String? categoryId;
  String? categoryName;
  String? categoryIcon;
  String? categoryColor;
  String? categoryColorLight;

  CategoryList(
      {this.categoryId,
        this.categoryName,
        this.categoryIcon,
        this.categoryColor,
      this.categoryColorLight});

  CategoryList.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    categoryIcon = json['categoryIcon'];
    categoryColor = json['categoryColor'];
    categoryColorLight = json['categoryColorLight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['categoryIcon'] = this.categoryIcon;
    data['categoryColor'] = this.categoryColor;
    data['categoryColorLight'] = this.categoryColorLight;
    return data;
  }
}