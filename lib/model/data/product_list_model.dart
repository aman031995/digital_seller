
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
  String? appId;
  String? categoryId;
  String? categoryName;
  Null? subCategoryId;
  String? subCategoryName;
  String? productId;
  String? productName;
  String? productShortDesc;
  String? productLongDesc;
  int? productType;
  String? productTypeName;
  ProductDetails? productDetails;
  List<Null>? productReviews;
  List<ProductSkuDetails>? productSkuDetails;
  int? cartQuantity;
  SkuData? productSelectedSku;

  ProductList(
      {this.appId,
        this.categoryId,
        this.categoryName,
        this.subCategoryId,
        this.subCategoryName,
        this.productId,
        this.productName,
        this.productShortDesc,
        this.productLongDesc,
        this.productType,
        this.productTypeName,
        this.productDetails,
        this.productReviews,
        this.productSkuDetails,
        this.cartQuantity,
        this.productSelectedSku});

  ProductList.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    subCategoryId = json['subCategoryId'];
    subCategoryName = json['subCategoryName'];
    productId = json['productId'];
    productName = json['productName'];
    productShortDesc = json['productShortDesc'];
    productLongDesc = json['productLongDesc'];
    productType = json['productType'];
    productTypeName = json['productTypeName'];
    productDetails = json['productDetails'] != null
        ? new ProductDetails.fromJson(json['productDetails'])
        : null;
    if (json['productReviews'] != null) {
      productReviews = <Null>[];
      // json['productReviews'].forEach((v) {
      //   productReviews!.add(new Null.fromJson(v));
      // });
    }
    if (json['productSkuDetails'] != null) {
      productSkuDetails = <ProductSkuDetails>[];
      json['productSkuDetails'].forEach((v) {
        productSkuDetails!.add(new ProductSkuDetails.fromJson(v));
      });
    }
    cartQuantity = json['cartQuantity'];
    productSelectedSku = json['productSelectedSku'] != null
        ? new SkuData.fromJson(json['productSelectedSku'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appId'] = this.appId;
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['subCategoryId'] = this.subCategoryId;
    data['subCategoryName'] = this.subCategoryName;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productShortDesc'] = this.productShortDesc;
    data['productLongDesc'] = this.productLongDesc;
    data['productType'] = this.productType;
    data['productTypeName'] = this.productTypeName;
    if (this.productDetails != null) {
      data['productDetails'] = this.productDetails!.toJson();
    }
    if (this.productReviews != null) {
      // data['productReviews'] =
      //     this.productReviews!.map((v) => v.toJson()).toList();
    }
    if (this.productSkuDetails != null) {
      data['productSkuDetails'] =
          this.productSkuDetails!.map((v) => v.toJson()).toList();
    }
    data['cartQuantity'] = this.cartQuantity;
    if (this.productSelectedSku != null) {
      data['productSelectedSku'] = this.productSelectedSku!.toJson();
    }
    return data;
  }
}

class ProductDetails {
  String? variantId;
  Null? productSKU;
  String? productVariantTitle;
  List<String>? productImages;
  String? productPrice;
  String? productDiscountPrice;
  String? productDiscountPercent;
  bool? isAvailable;
  bool? isFavorite;
  bool? isAddToCart;
  bool? inStock;
  int? quantityLeft;

  ProductDetails(
      {this.variantId,
        this.productSKU,
        this.productVariantTitle,
        this.productImages,
        this.productPrice,
        this.productDiscountPrice,
        this.productDiscountPercent,
        this.isAvailable,
        this.isFavorite,
        this.isAddToCart,
        this.inStock,
        this.quantityLeft});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    variantId = json['variantId'];
    productSKU = json['productSKU'];
    productVariantTitle = json['productVariantTitle'];
    productImages = json['productImages'].cast<String>();
    productPrice = json['productPrice'];
    productDiscountPrice = json['productDiscountPrice'];
    productDiscountPercent = json['productDiscountPercent'];
    isAvailable = json['isAvailable'];
    isFavorite = json['isFavorite'];
    isAddToCart = json['isAddToCart'];
    inStock = json['inStock'];
    quantityLeft = json['quantityLeft'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variantId'] = this.variantId;
    data['productSKU'] = this.productSKU;
    data['productVariantTitle'] = this.productVariantTitle;
    data['productImages'] = this.productImages;
    data['productPrice'] = this.productPrice;
    data['productDiscountPrice'] = this.productDiscountPrice;
    data['productDiscountPercent'] = this.productDiscountPercent;
    data['isAvailable'] = this.isAvailable;
    data['isFavorite'] = this.isFavorite;
    data['isAddToCart'] = this.isAddToCart;
    data['inStock'] = this.inStock;
    data['quantityLeft'] = this.quantityLeft;
    return data;
  }
}

class ProductSkuDetails {
  int? variationId;
  List<int>? availableId;
  String? variationName;
  String? variationKey;
  bool? isColorEnable;
  List<SkuData>? data;

  ProductSkuDetails(
      {this.variationId,
        this.availableId,
        this.variationName,
        this.variationKey,
        this.isColorEnable,
        this.data});

  ProductSkuDetails.fromJson(Map<String, dynamic> json) {
    variationId = json['variationId'];
    availableId = json['availableId'].cast<int>();
    variationName = json['variationName'];
    variationKey = json['variationKey'];
    isColorEnable = json['isColorEnable'];
    if (json['data'] != null) {
      data = <SkuData>[];
      json['data'].forEach((v) {
        data!.add(new SkuData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variationId'] = this.variationId;
    data['availableId'] = this.availableId;
    data['variationName'] = this.variationName;
    data['variationKey'] = this.variationKey;
    data['isColorEnable'] = this.isColorEnable;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkuData {
  String? name;
  String? val;

  SkuData({this.name, this.val});

  SkuData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    val = json['val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['val'] = this.val;
    return data;
  }
}
