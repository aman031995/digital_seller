class ProductListModel {
  Pagination? pagination;
  List<ProductList>? productList;

  ProductListModel({this.pagination, this.productList});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['productList'] != null) {
      productList = <ProductList>[];
      json['productList'].forEach((v) {
        productList!.add(new ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.productList != null) {
      data['productList'] = this.productList!.map((v) => v.toJson()).toList();
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

class ProductList {
  int? id;
  String? productId;
  String? brand;
  List<String>? video;
  String? productCode;
  String? name;
  String? imagePath;
  String? description;
  String? price;
  String? discountedPrice;
  String? discountPercent;
  List<String>? size;
  String? rating;
  List<String>? colors;
  String? manufacturer;
  bool? available;
  bool? addToCart;

  ProductList(
      {this.id,
        this.productId,
        this.brand,
        this.video,
        this.productCode,
        this.name,
        this.imagePath,
        this.description,
        this.price,
        this.discountedPrice,
        this.discountPercent,
        this.size,
        this.rating,
        this.colors,
        this.manufacturer,
        this.available,
        this.addToCart});

  ProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    brand = json['brand'];
    video = json['video'].cast<String>();
    productCode = json['productCode'];
    name = json['name'];
    imagePath = json['imagePath'];
    description = json['description'];
    price = json['price'];
    discountedPrice = json['discounted_price'];
    discountPercent = json['discount_percent'];
    size = json['size'].cast<String>();
    rating = json['rating'];
    colors = json['colors'].cast<String>();
    manufacturer = json['manufacturer'];
    available = json['available'];
    addToCart = json['addToCart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['brand'] = this.brand;
    data['video'] = this.video;
    data['productCode'] = this.productCode;
    data['name'] = this.name;
    data['imagePath'] = this.imagePath;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    data['discount_percent'] = this.discountPercent;
    data['size'] = this.size;
    data['rating'] = this.rating;
    data['colors'] = this.colors;
    data['manufacturer'] = this.manufacturer;
    data['available'] = this.available;
    data['addToCart'] = this.addToCart;
    return data;
  }
}
