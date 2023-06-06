
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
  int? subCategoryId;
  String? subCategoryName;
  String? productId;
  String? productName;
  String? productShortDesc;
  String? productLongDesc;
  int? productType;
  String? productTypeName;
  ProductDetails? productDetails;
  List? productReviews;
  List<ProductSkuDetails>? productSkuDetails;
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
      productReviews = [];
      json['productReviews'].forEach((v) {
        // productReviews!.add(new Null.fromJson(v));
      });
    }
    if (json['productSkuDetails'] != null) {
      productSkuDetails = <ProductSkuDetails>[];
      json['productSkuDetails'].forEach((v) {
        productSkuDetails!.add(new ProductSkuDetails.fromJson(v));
      });
    }
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
      data['productReviews'] =
          this.productReviews!.map((v) => v.toJson()).toList();
    }
    if (this.productSkuDetails != null) {
      data['productSkuDetails'] =
          this.productSkuDetails!.map((v) => v.toJson()).toList();
    }
    data['cartQuantity'] = this.cartQuantity;
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
  String? productColor;
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
    data['productColor'] = this.productColor;
    data['productSize'] = this.productSize;
    data['productEngine'] = this.productEngine;
    data['productFuel'] = this.productFuel;
    return data;
  }
}

class ProductSkuDetails {
  int? variationId;
  List<int>? availableId;
  String? variationName;
  String? variationKey;
  bool? isColorEnable;
  List<SkuSizeData>? data;
  List<SkuColorData>? colorData;

  ProductSkuDetails(
      {this.variationId,
        this.availableId,
        this.variationName,
        this.variationKey,
        this.isColorEnable,
        this.data,
        this.colorData});

  ProductSkuDetails.fromJson(Map<String, dynamic> json) {
    variationId = json['variationId'];
    availableId = json['availableId'].cast<int>();
    variationName = json['variationName'];
    variationKey = json['variationKey'];
    isColorEnable = json['isColorEnable'];

    if(isColorEnable == true){
      if(json['data'] != null) {
        colorData = <SkuColorData>[];
        json['data'].forEach((v) {
          colorData!.add(new SkuColorData.fromJson(v));
        });
      }
    } else {
      if (json['data'] != null) {
        data = <SkuSizeData>[];
        json['data'].forEach((v) {
          data!.add(new SkuSizeData.fromJson(v));
        });
      }
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
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkuSizeData {
  String? name;
  String? val;

  SkuSizeData({this.name, this.val});

  SkuSizeData.fromJson(Map<String, dynamic> json) {
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

class SkuColorData {
  String? name;
  Val? val;

  SkuColorData({this.name, this.val});

  SkuColorData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    val = json['val'] != null ? new Val.fromJson(json['val']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.val != null) {
      data['val'] = this.val!.toJson();
    }
    return data;
  }
}

class Val {
  Hsl? hsl;
  String? hex;
  Rgb? rgb;
  Hsv? hsv;
  var oldHue;
  var source;

  Val({this.hsl, this.hex, this.rgb, this.hsv, this.oldHue, this.source});

  Val.fromJson(Map<String, dynamic> json) {
    hsl = json['hsl'] != null ? new Hsl.fromJson(json['hsl']) : null;
    hex = json['hex'];
    rgb = json['rgb'] != null ? new Rgb.fromJson(json['rgb']) : null;
    hsv = json['hsv'] != null ? new Hsv.fromJson(json['hsv']) : null;
    oldHue = json['oldHue'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hsl != null) {
      data['hsl'] = this.hsl!.toJson();
    }
    data['hex'] = this.hex;
    if (this.rgb != null) {
      data['rgb'] = this.rgb!.toJson();
    }
    if (this.hsv != null) {
      data['hsv'] = this.hsv!.toJson();
    }
    data['oldHue'] = this.oldHue;
    data['source'] = this.source;
    return data;
  }
}

class Hsl {
  var h;
  var s;
  var l;
  var a;

  Hsl({this.h, this.s, this.l, this.a});

  Hsl.fromJson(Map<String, dynamic> json) {
    h = json['h'];
    s = json['s'];
    l = json['l'];
    a = json['a'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['h'] = this.h;
    data['s'] = this.s;
    data['l'] = this.l;
    data['a'] = this.a;
    return data;
  }
}

class Rgb {
  var r;
  var g;
  var b;
  var a;

  Rgb({this.r, this.g, this.b, this.a});

  Rgb.fromJson(Map<String, dynamic> json) {
    r = json['r'];
    g = json['g'];
    b = json['b'];
    a = json['a'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['r'] = this.r;
    data['g'] = this.g;
    data['b'] = this.b;
    data['a'] = this.a;
    return data;
  }
}

class Hsv {
  var h;
  var s;
  var v;
  var a;

  Hsv({this.h, this.s, this.v, this.a});

  Hsv.fromJson(Map<String, dynamic> json) {
    h = json['h'];
    s = json['s'];
    v = json['v'];
    a = json['a'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['h'] = this.h;
    data['s'] = this.s;
    data['v'] = this.v;
    data['a'] = this.a;
    return data;
  }
}
