// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i23;
import 'package:flutter/material.dart' as _i24;
import 'package:TychoStream/view/restaurant/home_page_restaurant.dart' as _i19;
import 'package:TychoStream/view/restaurant/product_list_restaurant.dart'
    as _i20;
import 'package:TychoStream/view/restaurant/restaurant_favourite_list_page.dart'
    as _i22;
import 'package:TychoStream/view/restaurant/restaurant_subcategory_product_list.dart'
    as _i21;
import 'package:TychoStream/view/WebScreen/authentication/contact_us.dart'
    as _i1;
import 'package:TychoStream/view/WebScreen/authentication/EditProfile.dart'
    as _i2;
import 'package:TychoStream/view/WebScreen/HomePageWeb.dart' as _i3;
import 'package:TychoStream/view/WebScreen/order_history/my_order_page.dart'
    as _i4;
import 'package:TychoStream/view/WebScreen/product/address_list_page.dart'
    as _i5;
import 'package:TychoStream/view/WebScreen/product/banner_product_details.dart'
    as _i6;
import 'package:TychoStream/view/WebScreen/product/buynowaddress.dart' as _i7;
import 'package:TychoStream/view/WebScreen/product/buynowcart.dart' as _i8;
import 'package:TychoStream/view/WebScreen/product/cart_detail_page.dart'
    as _i9;
import 'package:TychoStream/view/WebScreen/product/category_subcategory_product.dart'
    as _i10;
import 'package:TychoStream/view/WebScreen/product/favourite_list_page.dart'
    as _i11;
import 'package:TychoStream/view/WebScreen/product/product_details.dart'
    as _i13;
import 'package:TychoStream/view/WebScreen/product/ProductList.dart' as _i12;
import 'package:TychoStream/view/WebScreen/product/subcategory_product_list.dart'
    as _i14;
import 'package:TychoStream/view/WebScreen/product/thankyou_page.dart' as _i15;
import 'package:TychoStream/view/WebScreen/search/search_page.dart' as _i16;
import 'package:TychoStream/view/widgets/NotificationScreen.dart' as _i17;
import 'package:TychoStream/view/widgets/web_html_page.dart' as _i18;

abstract class $AppRouter extends _i23.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i23.PageFactory> pagesMap = {
    ContactUs.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ContactUs(),
      );
    },
    EditProfile.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.EditProfile(),
      );
    },
    HomePageWeb.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomePageWeb(),
      );
    },
    MyOrderPage.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.MyOrderPage(),
      );
    },
    AddressListPage.name: (routeData) {
      final args = routeData.argsAs<AddressListPageArgs>(
          orElse: () => const AddressListPageArgs());
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.AddressListPage(key: args.key),
      );
    },
    BannerProductDetailPage.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<BannerProductDetailPageArgs>(
          orElse: () => BannerProductDetailPageArgs(
              ProductDetails: queryParams.get('ProductDetails')));
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.BannerProductDetailPage(
          ProductDetails: args.ProductDetails,
          key: args.key,
        ),
      );
    },
    BuynowAddress.name: (routeData) {
      final args = routeData.argsAs<BuynowAddressArgs>(
          orElse: () => const BuynowAddressArgs());
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.BuynowAddress(key: args.key),
      );
    },
    BuynowCart.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<BuynowCartArgs>(
          orElse: () => BuynowCartArgs(buynow: queryParams.get('buynow')));
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.BuynowCart(
          buynow: args.buynow,
          key: args.key,
        ),
      );
    },
    CartDetail.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CartDetailArgs>(
          orElse: () =>
              CartDetailArgs(itemCount: pathParams.optString('itemCount')));
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.CartDetail(
          key: args.key,
          itemCount: args.itemCount,
        ),
      );
    },
    CategorySubcategoryProduct.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CategorySubcategoryProductArgs>(
          orElse: () => CategorySubcategoryProductArgs(
              CategoryName: pathParams.optString('CategoryName')));
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.CategorySubcategoryProduct(
          CategoryName: args.CategoryName,
          key: args.key,
        ),
      );
    },
    FavouriteListPage.name: (routeData) {
      final args = routeData.argsAs<FavouriteListPageArgs>(
          orElse: () => const FavouriteListPageArgs());
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.FavouriteListPage(key: args.key),
      );
    },
    ProductListGallery.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<ProductListGalleryArgs>(
          orElse: () => ProductListGalleryArgs(
              discountdata: queryParams.get('discountdata')));
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.ProductListGallery(
          discountdata: args.discountdata,
          key: args.key,
        ),
      );
    },
    ProductDetailPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<ProductDetailPageArgs>(
          orElse: () => ProductDetailPageArgs(
                productName: pathParams.optString('productName'),
                productdata: queryParams.get('productdata'),
              ));
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.ProductDetailPage(
          productName: args.productName,
          productdata: args.productdata,
          key: args.key,
        ),
      );
    },
    SubcategoryProductList.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SubcategoryProductListArgs>(
          orElse: () => SubcategoryProductListArgs(
              SubcategoryProductName:
                  pathParams.optString('SubcategoryProductName')));
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.SubcategoryProductList(
          SubcategoryProductName: args.SubcategoryProductName,
          key: args.key,
        ),
      );
    },
    ThankYouPage.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.ThankYouPage(),
      );
    },
    SearchPage.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.SearchPage(),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.NotificationScreen(),
      );
    },
    WebHtmlPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<WebHtmlPageArgs>(
          orElse: () => WebHtmlPageArgs(
                title: pathParams.optString('title'),
                html: queryParams.optString('html'),
              ));
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.WebHtmlPage(
          title: args.title,
          html: args.html,
          key: args.key,
        ),
      );
    },
    HomePageRestaurant.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.HomePageRestaurant(),
      );
    },
    ProductListRestaurantGallery.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<ProductListRestaurantGalleryArgs>(
          orElse: () => ProductListRestaurantGalleryArgs(
              discountdata: queryParams.get('discountdata')));
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i20.ProductListRestaurantGallery(
          discountdata: args.discountdata,
          key: args.key,
        ),
      );
    },
    RestaurantSubcategoryProductList.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<RestaurantSubcategoryProductListArgs>(
          orElse: () => RestaurantSubcategoryProductListArgs(
              SubcategoryProductName:
                  pathParams.optString('SubcategoryProductName')));
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i21.RestaurantSubcategoryProductList(
          SubcategoryProductName: args.SubcategoryProductName,
          key: args.key,
        ),
      );
    },
    RestaurantFavouriteListPage.name: (routeData) {
      final args = routeData.argsAs<RestaurantFavouriteListPageArgs>(
          orElse: () => const RestaurantFavouriteListPageArgs());
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i22.RestaurantFavouriteListPage(key: args.key),
      );
    },
  };
}

/// generated route for
/// [_i1.ContactUs]
class ContactUs extends _i23.PageRouteInfo<void> {
  const ContactUs({List<_i23.PageRouteInfo>? children})
      : super(
          ContactUs.name,
          initialChildren: children,
        );

  static const String name = 'ContactUs';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i2.EditProfile]
class EditProfile extends _i23.PageRouteInfo<void> {
  const EditProfile({List<_i23.PageRouteInfo>? children})
      : super(
          EditProfile.name,
          initialChildren: children,
        );

  static const String name = 'EditProfile';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HomePageWeb]
class HomePageWeb extends _i23.PageRouteInfo<void> {
  const HomePageWeb({List<_i23.PageRouteInfo>? children})
      : super(
          HomePageWeb.name,
          initialChildren: children,
        );

  static const String name = 'HomePageWeb';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i4.MyOrderPage]
class MyOrderPage extends _i23.PageRouteInfo<void> {
  const MyOrderPage({List<_i23.PageRouteInfo>? children})
      : super(
          MyOrderPage.name,
          initialChildren: children,
        );

  static const String name = 'MyOrderPage';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i5.AddressListPage]
class AddressListPage extends _i23.PageRouteInfo<AddressListPageArgs> {
  AddressListPage({
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          AddressListPage.name,
          args: AddressListPageArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AddressListPage';

  static const _i23.PageInfo<AddressListPageArgs> page =
      _i23.PageInfo<AddressListPageArgs>(name);
}

class AddressListPageArgs {
  const AddressListPageArgs({this.key});

  final _i24.Key? key;

  @override
  String toString() {
    return 'AddressListPageArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.BannerProductDetailPage]
class BannerProductDetailPage
    extends _i23.PageRouteInfo<BannerProductDetailPageArgs> {
  BannerProductDetailPage({
    List<String>? ProductDetails,
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          BannerProductDetailPage.name,
          args: BannerProductDetailPageArgs(
            ProductDetails: ProductDetails,
            key: key,
          ),
          rawQueryParams: {'ProductDetails': ProductDetails},
          initialChildren: children,
        );

  static const String name = 'BannerProductDetailPage';

  static const _i23.PageInfo<BannerProductDetailPageArgs> page =
      _i23.PageInfo<BannerProductDetailPageArgs>(name);
}

class BannerProductDetailPageArgs {
  const BannerProductDetailPageArgs({
    this.ProductDetails,
    this.key,
  });

  final List<String>? ProductDetails;

  final _i24.Key? key;

  @override
  String toString() {
    return 'BannerProductDetailPageArgs{ProductDetails: $ProductDetails, key: $key}';
  }
}

/// generated route for
/// [_i7.BuynowAddress]
class BuynowAddress extends _i23.PageRouteInfo<BuynowAddressArgs> {
  BuynowAddress({
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          BuynowAddress.name,
          args: BuynowAddressArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'BuynowAddress';

  static const _i23.PageInfo<BuynowAddressArgs> page =
      _i23.PageInfo<BuynowAddressArgs>(name);
}

class BuynowAddressArgs {
  const BuynowAddressArgs({this.key});

  final _i24.Key? key;

  @override
  String toString() {
    return 'BuynowAddressArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.BuynowCart]
class BuynowCart extends _i23.PageRouteInfo<BuynowCartArgs> {
  BuynowCart({
    List<String>? buynow,
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          BuynowCart.name,
          args: BuynowCartArgs(
            buynow: buynow,
            key: key,
          ),
          rawQueryParams: {'buynow': buynow},
          initialChildren: children,
        );

  static const String name = 'BuynowCart';

  static const _i23.PageInfo<BuynowCartArgs> page =
      _i23.PageInfo<BuynowCartArgs>(name);
}

class BuynowCartArgs {
  const BuynowCartArgs({
    this.buynow,
    this.key,
  });

  final List<String>? buynow;

  final _i24.Key? key;

  @override
  String toString() {
    return 'BuynowCartArgs{buynow: $buynow, key: $key}';
  }
}

/// generated route for
/// [_i9.CartDetail]
class CartDetail extends _i23.PageRouteInfo<CartDetailArgs> {
  CartDetail({
    _i24.Key? key,
    String? itemCount,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          CartDetail.name,
          args: CartDetailArgs(
            key: key,
            itemCount: itemCount,
          ),
          rawPathParams: {'itemCount': itemCount},
          initialChildren: children,
        );

  static const String name = 'CartDetail';

  static const _i23.PageInfo<CartDetailArgs> page =
      _i23.PageInfo<CartDetailArgs>(name);
}

class CartDetailArgs {
  const CartDetailArgs({
    this.key,
    this.itemCount,
  });

  final _i24.Key? key;

  final String? itemCount;

  @override
  String toString() {
    return 'CartDetailArgs{key: $key, itemCount: $itemCount}';
  }
}

/// generated route for
/// [_i10.CategorySubcategoryProduct]
class CategorySubcategoryProduct
    extends _i23.PageRouteInfo<CategorySubcategoryProductArgs> {
  CategorySubcategoryProduct({
    String? CategoryName,
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          CategorySubcategoryProduct.name,
          args: CategorySubcategoryProductArgs(
            CategoryName: CategoryName,
            key: key,
          ),
          rawPathParams: {'CategoryName': CategoryName},
          initialChildren: children,
        );

  static const String name = 'CategorySubcategoryProduct';

  static const _i23.PageInfo<CategorySubcategoryProductArgs> page =
      _i23.PageInfo<CategorySubcategoryProductArgs>(name);
}

class CategorySubcategoryProductArgs {
  const CategorySubcategoryProductArgs({
    this.CategoryName,
    this.key,
  });

  final String? CategoryName;

  final _i24.Key? key;

  @override
  String toString() {
    return 'CategorySubcategoryProductArgs{CategoryName: $CategoryName, key: $key}';
  }
}

/// generated route for
/// [_i11.FavouriteListPage]
class FavouriteListPage extends _i23.PageRouteInfo<FavouriteListPageArgs> {
  FavouriteListPage({
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          FavouriteListPage.name,
          args: FavouriteListPageArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'FavouriteListPage';

  static const _i23.PageInfo<FavouriteListPageArgs> page =
      _i23.PageInfo<FavouriteListPageArgs>(name);
}

class FavouriteListPageArgs {
  const FavouriteListPageArgs({this.key});

  final _i24.Key? key;

  @override
  String toString() {
    return 'FavouriteListPageArgs{key: $key}';
  }
}

/// generated route for
/// [_i12.ProductListGallery]
class ProductListGallery extends _i23.PageRouteInfo<ProductListGalleryArgs> {
  ProductListGallery({
    List<String>? discountdata,
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          ProductListGallery.name,
          args: ProductListGalleryArgs(
            discountdata: discountdata,
            key: key,
          ),
          rawQueryParams: {'discountdata': discountdata},
          initialChildren: children,
        );

  static const String name = 'ProductListGallery';

  static const _i23.PageInfo<ProductListGalleryArgs> page =
      _i23.PageInfo<ProductListGalleryArgs>(name);
}

class ProductListGalleryArgs {
  const ProductListGalleryArgs({
    this.discountdata,
    this.key,
  });

  final List<String>? discountdata;

  final _i24.Key? key;

  @override
  String toString() {
    return 'ProductListGalleryArgs{discountdata: $discountdata, key: $key}';
  }
}

/// generated route for
/// [_i13.ProductDetailPage]
class ProductDetailPage extends _i23.PageRouteInfo<ProductDetailPageArgs> {
  ProductDetailPage({
    String? productName,
    List<String>? productdata,
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          ProductDetailPage.name,
          args: ProductDetailPageArgs(
            productName: productName,
            productdata: productdata,
            key: key,
          ),
          rawPathParams: {'productName': productName},
          rawQueryParams: {'productdata': productdata},
          initialChildren: children,
        );

  static const String name = 'ProductDetailPage';

  static const _i23.PageInfo<ProductDetailPageArgs> page =
      _i23.PageInfo<ProductDetailPageArgs>(name);
}

class ProductDetailPageArgs {
  const ProductDetailPageArgs({
    this.productName,
    this.productdata,
    this.key,
  });

  final String? productName;

  final List<String>? productdata;

  final _i24.Key? key;

  @override
  String toString() {
    return 'ProductDetailPageArgs{productName: $productName, productdata: $productdata, key: $key}';
  }
}

/// generated route for
/// [_i14.SubcategoryProductList]
class SubcategoryProductList
    extends _i23.PageRouteInfo<SubcategoryProductListArgs> {
  SubcategoryProductList({
    String? SubcategoryProductName,
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          SubcategoryProductList.name,
          args: SubcategoryProductListArgs(
            SubcategoryProductName: SubcategoryProductName,
            key: key,
          ),
          rawPathParams: {'SubcategoryProductName': SubcategoryProductName},
          initialChildren: children,
        );

  static const String name = 'SubcategoryProductList';

  static const _i23.PageInfo<SubcategoryProductListArgs> page =
      _i23.PageInfo<SubcategoryProductListArgs>(name);
}

class SubcategoryProductListArgs {
  const SubcategoryProductListArgs({
    this.SubcategoryProductName,
    this.key,
  });

  final String? SubcategoryProductName;

  final _i24.Key? key;

  @override
  String toString() {
    return 'SubcategoryProductListArgs{SubcategoryProductName: $SubcategoryProductName, key: $key}';
  }
}

/// generated route for
/// [_i15.ThankYouPage]
class ThankYouPage extends _i23.PageRouteInfo<void> {
  const ThankYouPage({List<_i23.PageRouteInfo>? children})
      : super(
          ThankYouPage.name,
          initialChildren: children,
        );

  static const String name = 'ThankYouPage';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i16.SearchPage]
class SearchPage extends _i23.PageRouteInfo<void> {
  const SearchPage({List<_i23.PageRouteInfo>? children})
      : super(
          SearchPage.name,
          initialChildren: children,
        );

  static const String name = 'SearchPage';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i17.NotificationScreen]
class NotificationRoute extends _i23.PageRouteInfo<void> {
  const NotificationRoute({List<_i23.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i18.WebHtmlPage]
class WebHtmlPage extends _i23.PageRouteInfo<WebHtmlPageArgs> {
  WebHtmlPage({
    String? title,
    String? html,
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          WebHtmlPage.name,
          args: WebHtmlPageArgs(
            title: title,
            html: html,
            key: key,
          ),
          rawPathParams: {'title': title},
          rawQueryParams: {'html': html},
          initialChildren: children,
        );

  static const String name = 'WebHtmlPage';

  static const _i23.PageInfo<WebHtmlPageArgs> page =
      _i23.PageInfo<WebHtmlPageArgs>(name);
}

class WebHtmlPageArgs {
  const WebHtmlPageArgs({
    this.title,
    this.html,
    this.key,
  });

  final String? title;

  final String? html;

  final _i24.Key? key;

  @override
  String toString() {
    return 'WebHtmlPageArgs{title: $title, html: $html, key: $key}';
  }
}

/// generated route for
/// [_i19.HomePageRestaurant]
class HomePageRestaurant extends _i23.PageRouteInfo<void> {
  const HomePageRestaurant({List<_i23.PageRouteInfo>? children})
      : super(
          HomePageRestaurant.name,
          initialChildren: children,
        );

  static const String name = 'HomePageRestaurant';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i20.ProductListRestaurantGallery]
class ProductListRestaurantGallery
    extends _i23.PageRouteInfo<ProductListRestaurantGalleryArgs> {
  ProductListRestaurantGallery({
    List<String>? discountdata,
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          ProductListRestaurantGallery.name,
          args: ProductListRestaurantGalleryArgs(
            discountdata: discountdata,
            key: key,
          ),
          rawQueryParams: {'discountdata': discountdata},
          initialChildren: children,
        );

  static const String name = 'ProductListRestaurantGallery';

  static const _i23.PageInfo<ProductListRestaurantGalleryArgs> page =
      _i23.PageInfo<ProductListRestaurantGalleryArgs>(name);
}

class ProductListRestaurantGalleryArgs {
  const ProductListRestaurantGalleryArgs({
    this.discountdata,
    this.key,
  });

  final List<String>? discountdata;

  final _i24.Key? key;

  @override
  String toString() {
    return 'ProductListRestaurantGalleryArgs{discountdata: $discountdata, key: $key}';
  }
}

/// generated route for
/// [_i21.RestaurantSubcategoryProductList]
class RestaurantSubcategoryProductList
    extends _i23.PageRouteInfo<RestaurantSubcategoryProductListArgs> {
  RestaurantSubcategoryProductList({
    String? SubcategoryProductName,
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          RestaurantSubcategoryProductList.name,
          args: RestaurantSubcategoryProductListArgs(
            SubcategoryProductName: SubcategoryProductName,
            key: key,
          ),
          rawPathParams: {'SubcategoryProductName': SubcategoryProductName},
          initialChildren: children,
        );

  static const String name = 'RestaurantSubcategoryProductList';

  static const _i23.PageInfo<RestaurantSubcategoryProductListArgs> page =
      _i23.PageInfo<RestaurantSubcategoryProductListArgs>(name);
}

class RestaurantSubcategoryProductListArgs {
  const RestaurantSubcategoryProductListArgs({
    this.SubcategoryProductName,
    this.key,
  });

  final String? SubcategoryProductName;

  final _i24.Key? key;

  @override
  String toString() {
    return 'RestaurantSubcategoryProductListArgs{SubcategoryProductName: $SubcategoryProductName, key: $key}';
  }
}

/// generated route for
/// [_i22.RestaurantFavouriteListPage]
class RestaurantFavouriteListPage
    extends _i23.PageRouteInfo<RestaurantFavouriteListPageArgs> {
  RestaurantFavouriteListPage({
    _i24.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          RestaurantFavouriteListPage.name,
          args: RestaurantFavouriteListPageArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'RestaurantFavouriteListPage';

  static const _i23.PageInfo<RestaurantFavouriteListPageArgs> page =
      _i23.PageInfo<RestaurantFavouriteListPageArgs>(name);
}

class RestaurantFavouriteListPageArgs {
  const RestaurantFavouriteListPageArgs({this.key});

  final _i24.Key? key;

  @override
  String toString() {
    return 'RestaurantFavouriteListPageArgs{key: $key}';
  }
}
