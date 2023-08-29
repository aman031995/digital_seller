
import 'package:TychoStream/model/data/product_list_model.dart';

// class categoryProduct {
//   List<ProductListData>? productList;
//   List<SubCategoryList>? subCategoryList;
//
//   categoryProduct({this.productList, this.subCategoryList});
//
//   categoryProduct.fromJson(Map<String, dynamic> json) {
//     if (json['productList'] != null) {
//       productList = <ProductListData>[];
//       json['productList'].forEach((v) {
//         productList!.add(new ProductListData.fromJson(v));
//       });
//     }
//     if (json['subCategoryList'] != null) {
//       subCategoryList = <SubCategoryList>[];
//       json['subCategoryList'].forEach((v) {
//         subCategoryList!.add(new SubCategoryList.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.productList != null) {
//       data['productList'] = this.productList!.map((v) => v.toJson()).toList();
//     }
//     if (this.subCategoryList != null) {
//       data['subCategoryList'] =
//           this.subCategoryList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
class categoryProduct {
  List<ProductList>? productList;
  List<SubCategoryList>? subCategoryList;

  categoryProduct({this.productList, this.subCategoryList});

  categoryProduct.fromJson(Map<String, dynamic> json) {
    if (json['productList'] != null) {
      productList = <ProductList>[];
      json['productList'].forEach((v) {
        productList!.add(new ProductList.fromJson(v));
      });
    }
    if (json['subCategoryList'] != null) {
      subCategoryList = <SubCategoryList>[];
      json['subCategoryList'].forEach((v) {
        subCategoryList!.add(new SubCategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productList != null) {
      data['productList'] = this.productList!.map((v) => v.toJson()).toList();
    }
    if (this.subCategoryList != null) {
      data['subCategoryList'] =
          this.subCategoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class DefaultVariationSku {
  SkuData? size;
  SkuData? color;
  SkuData? materialType;
  SkuData? style;
  SkuData? unitCount;

  DefaultVariationSku(
      {this.size, this.color, this.materialType, this.style, this.unitCount});

  DefaultVariationSku.fromJson(Map<String, dynamic> json) {
    size = json['size'] != null ? new SkuData.fromJson(json['size']) : null;
    color = json['color'] != null ? new SkuData.fromJson(json['color']) : null;
    materialType = json['material_type'] != null
        ? new SkuData.fromJson(json['material_type'])
        : null;
    style = json['style'] != null ? new SkuData.fromJson(json['style']) : null;
    unitCount = json['unit_count'] != null
        ? new SkuData.fromJson(json['unit_count'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.size != null) {
      data['size'] = this.size!.toJson();
    }
    if (this.color != null) {
      data['color'] = this.color!.toJson();
    }
    if (this.materialType != null) {
      data['material_type'] = this.materialType!.toJson();
    }
    if (this.style != null) {
      data['style'] = this.style!.toJson();
    }
    if (this.unitCount != null) {
      data['unit_count'] = this.unitCount!.toJson();
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
class ProductListdata {
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
  String? deeplink;

  ProductListdata(
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
        this.deeplink});

  ProductListdata.fromJson(Map<String, dynamic> json) {
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

    }
    if (json['productSkuDetails'] != null) {
      productSkuDetails = <ProductSkuDetails>[];
      json['productSkuDetails'].forEach((v) {
        productSkuDetails!.add(new ProductSkuDetails.fromJson(v));
      });
    }
    cartQuantity = json['cartQuantity'];
    deeplink = json['deeplink'];
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

    }
    if (this.productSkuDetails != null) {
      data['productSkuDetails'] =
          this.productSkuDetails!.map((v) => v.toJson()).toList();
    }
    data['cartQuantity'] = this.cartQuantity;
    data['deeplink'] = this.deeplink;
    return data;
  }
}

class ProductDetails {
  String? variantId;
  DefaultVariationSku? defaultVariationSku;
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
        this.defaultVariationSku,
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
    defaultVariationSku = json['defaultVariationSku'] != null
        ? new DefaultVariationSku.fromJson(json['defaultVariationSku'])
        : null;
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
    if (this.defaultVariationSku != null) {
      data['defaultVariationSku'] = this.defaultVariationSku!.toJson();
    }
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


class SubCategoryList {
  int? id;
  String? appId;
  String? catId;
  String? title;
  String? parentId;
  String? slug;
  String? description;
  String? imageUrl;


  SubCategoryList(
      {this.id,
        this.appId,
        this.catId,
        this.title,
        this.parentId,
        this.slug,
        this.description,
        this.imageUrl,
   });

  SubCategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appId = json['appId'];
    catId = json['categoryId'];
    title = json['categoryTitle'];
    parentId = json['parentId'];
    slug = json['slug'];
    description = json['description'];
    imageUrl = json['imageUrl'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appId'] = this.appId;
    data['categoryId'] = this.catId;
    data['categoryTitle']=this.title;
    data['parentId'] = this.parentId;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}

