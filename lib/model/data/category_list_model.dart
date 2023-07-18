
class CategoryListModel {
  int? id;
  String? appId;
  String? categoryId;
  String? categoryTitle;
  String? parentId;
  String? slug;
  String? description;
  String? imageUrl;
  List<Subcategories>? subcategories;

  CategoryListModel(
      {this.id,
        this.appId,
        this.categoryId,
        this.categoryTitle,
        this.parentId,
        this.slug,
        this.description,
        this.imageUrl,
        this.subcategories});

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appId = json['appId'];
    categoryId = json['categoryId'];
    categoryTitle = json['categoryTitle'];
    parentId = json['parent_id'];
    slug = json['slug'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    if (json['subcategories'] != null) {
      subcategories = <Subcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(new Subcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appId'] = this.appId;
    data['categoryId'] = this.categoryId;
    data['categoryTitle'] = this.categoryTitle;
    data['parent_id'] = this.parentId;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    if (this.subcategories != null) {
      data['subcategories'] =
          this.subcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategories {
  int? id;
  String? appId;
  String? categoryId;
  String? categoryTitle;
  String? parentId;
  String? slug;
  String? description;
  String? imageUrl;
  List<Subcategories>? subcategories;

  Subcategories(
      {this.id,
        this.appId,
        this.categoryId,
        this.categoryTitle,
        this.parentId,
        this.slug,
        this.description,
        this.imageUrl,
        this.subcategories});

  Subcategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appId = json['appId'];
    categoryId = json['categoryId'];
    categoryTitle = json['categoryTitle'];
    parentId = json['parent_id'];
    slug = json['slug'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    if (json['subcategories'] != null) {
      subcategories = <Subcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(new Subcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appId'] = this.appId;
    data['categoryId'] = this.categoryId;
    data['categoryTitle'] = this.categoryTitle;
    data['parent_id'] = this.parentId;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    if (this.subcategories != null) {
      data['subcategories'] =
          this.subcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
