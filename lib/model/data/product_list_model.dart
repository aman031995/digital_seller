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
  String? subCategoryId;
  String? subCategoryName;
  String? productId;
  String? productName;
  String? productShortDesc;
  String? productLongDesc;
  int? productType;
  String? productTypeName;
  ProductDetails? productDetails;
  List<Null>? productReviews;
  ProductSkuDetails? productSkuDetails;
  int? cartQuantity;


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
        this.cartQuantity});

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
    productSkuDetails = json['productSkuDetails'] != null
        ? new ProductSkuDetails.fromJson(json['productSkuDetails'])
        : null;
    cartQuantity = json['cartQuantity'];
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
          // this.productReviews!.map((v) => v.toJson()).toList();
    }
    if (this.productSkuDetails != null) {
      data['productSkuDetails'] = this.productSkuDetails!.toJson();
    }
    data['cartQuantity'] = this.cartQuantity;
    return data;
  }
}

class ProductDetails {
  String? variantId;
  String? productSKU;
  String? productVariantTitle;
  List<String>? productImages;
  int? productPrice;
  int? productDiscountPrice;
  int? productDiscountPercent;
  bool? isAvailable;
  bool? isFavorite;
  bool? isAddToCart;
  bool? inStock;
  int? quantityLeft;
  String? productColorId;
  String? productColor;
  String? productSizeId;
  String? productSize;
  String? productEngine;
  String? productFuel;

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
        this.quantityLeft,
        this.productColorId,
        this.productSizeId,
        this.productColor,
        this.productSize,
        this.productEngine,
        this.productFuel});

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
    productColorId=json['productColorId'];
    productSizeId=json['productSizeId'];
    productColor = json['productColor'];
    productSize = json['productSize'];
    productEngine = json['productEngine'];
    productFuel = json['productFuel'];
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
    data['productColorId']=this.productColorId;
    data['productSizeId']=this.productSizeId;
    data['productColor'] = this.productColor;
    data['productSize'] = this.productSize;
    data['productEngine'] = this.productEngine;
    data['productFuel'] = this.productFuel;
    return data;
  }
}

class ProductSkuDetails {
  List<ColorDetails>? colorDetails;
  List<SizeDetails>? sizeDetails;
  List<Null>? engineDetails;
  List<Null>? fuelDetails;

  ProductSkuDetails(
      {this.colorDetails,
        this.sizeDetails,
        this.engineDetails,
        this.fuelDetails});

  ProductSkuDetails.fromJson(Map<String, dynamic> json) {
    if (json['colorDetails'] != null) {
      colorDetails = <ColorDetails>[];
      json['colorDetails'].forEach((v) {
        colorDetails!.add(new ColorDetails.fromJson(v));
      });
    }
    if (json['sizeDetails'] != null) {
      sizeDetails = <SizeDetails>[];
      json['sizeDetails'].forEach((v) {
        sizeDetails!.add(new SizeDetails.fromJson(v));
      });
    }
    if (json['engineDetails'] != null) {
      engineDetails = <Null>[];
      json['engineDetails'].forEach((v) {
        // engineDetails!.add(new Null.fromJson(v));
      });
    }
    if (json['fuelDetails'] != null) {
      fuelDetails = <Null>[];
      json['fuelDetails'].forEach((v) {
        // fuelDetails!.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.colorDetails != null) {
      data['colorDetails'] = this.colorDetails!.map((v) => v.toJson()).toList();
    }
    if (this.sizeDetails != null) {
      data['sizeDetails'] = this.sizeDetails!.map((v) => v.toJson()).toList();
    }
    if (this.engineDetails != null) {
      // data['engineDetails'] =
      //     this.engineDetails!.map((v) => v.toJson()).toList();
    }
    if (this.fuelDetails != null) {
      // data['fuelDetails'] = this.fuelDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ColorDetails {
  String? colorId;
  String? colorName;
  String? colorCode;

  ColorDetails({this.colorId, this.colorName, this.colorCode});

  ColorDetails.fromJson(Map<String, dynamic> json) {
    colorId = json['colorId'];
    colorName = json['colorName'];
    colorCode = json['colorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['colorId'] = this.colorId;
    data['colorName'] = this.colorName;
    data['colorCode'] = this.colorCode;
    return data;
  }
}

class SizeDetails {
  String? sizeId;
  String? sizeName;

  SizeDetails({this.sizeId, this.sizeName});

  SizeDetails.fromJson(Map<String, dynamic> json) {
    sizeId = json['sizeId'];
    sizeName = json['sizeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sizeId'] = this.sizeId;
    data['sizeName'] = this.sizeName;
    return data;
  }
}
