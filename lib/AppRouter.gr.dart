// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:easy_stepper/easy_stepper.dart' as _i15;
import 'package:flutter/material.dart' as _i16;
import 'package:TychoStream/view/Products/address_list_page.dart' as _i1;
import 'package:TychoStream/view/Products/buynowcart.dart' as _i2;
import 'package:TychoStream/view/Products/cart_detail_page.dart' as _i3;
import 'package:TychoStream/view/Products/favourite_list_page.dart' as _i4;
import 'package:TychoStream/view/Products/product_details.dart' as _i6;
import 'package:TychoStream/view/Products/ProductList.dart' as _i5;
import 'package:TychoStream/view/Products/thankyou_page.dart' as _i7;
import 'package:TychoStream/view/Profile/my_order_page.dart' as _i8;
import 'package:TychoStream/view/search/search_page.dart' as _i9;
import 'package:TychoStream/view/WebScreen/contact_us.dart' as _i10;
import 'package:TychoStream/view/WebScreen/EditProfile.dart' as _i11;
import 'package:TychoStream/view/WebScreen/HomePageWeb.dart' as _i12;
import 'package:TychoStream/view/widgets/web_html_page.dart' as _i13;

abstract class $AppRouter extends _i14.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    AddressListPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AddressListPageArgs>(
          orElse: () =>
              AddressListPageArgs(buynow: pathParams.optBool('buynow')));
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddressListPage(
          key: args.key,
          buynow: args.buynow,
        ),
      );
    },
    BuynowCart.name: (routeData) {
      final args = routeData.argsAs<BuynowCartArgs>(
          orElse: () => const BuynowCartArgs());
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.BuynowCart(key: args.key),
      );
    },
    CartDetail.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CartDetailArgs>(
          orElse: () =>
              CartDetailArgs(itemCount: pathParams.optString('itemCount')));
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.CartDetail(
          key: args.key,
          itemCount: args.itemCount,
          callback: args.callback,
        ),
      );
    },
    FavouriteListPage.name: (routeData) {
      final args = routeData.argsAs<FavouriteListPageArgs>(
          orElse: () => const FavouriteListPageArgs());
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.FavouriteListPage(
          key: args.key,
          callback: args.callback,
        ),
      );
    },
    ProductListGallery.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ProductListGallery(),
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
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.ProductDetailPage(
          productName: args.productName,
          productdata: args.productdata,
          key: args.key,
        ),
      );
    },
    ThankYouPage.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ThankYouPage(),
      );
    },
    MyOrderPage.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.MyOrderPage(),
      );
    },
    SearchPage.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SearchPage(),
      );
    },
    ContactUs.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ContactUs(),
      );
    },
    EditProfile.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.EditProfile(),
      );
    },
    HomePageWeb.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.HomePageWeb(),
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
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WebHtmlPage(
          title: args.title,
          html: args.html,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AddressListPage]
class AddressListPage extends _i14.PageRouteInfo<AddressListPageArgs> {
  AddressListPage({
    _i15.Key? key,
    bool? buynow,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          AddressListPage.name,
          args: AddressListPageArgs(
            key: key,
            buynow: buynow,
          ),
          rawPathParams: {'buynow': buynow},
          initialChildren: children,
        );

  static const String name = 'AddressListPage';

  static const _i14.PageInfo<AddressListPageArgs> page =
      _i14.PageInfo<AddressListPageArgs>(name);
}

class AddressListPageArgs {
  const AddressListPageArgs({
    this.key,
    this.buynow,
  });

  final _i15.Key? key;

  final bool? buynow;

  @override
  String toString() {
    return 'AddressListPageArgs{key: $key, buynow: $buynow}';
  }
}

/// generated route for
/// [_i2.BuynowCart]
class BuynowCart extends _i14.PageRouteInfo<BuynowCartArgs> {
  BuynowCart({
    _i16.Key? key,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          BuynowCart.name,
          args: BuynowCartArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'BuynowCart';

  static const _i14.PageInfo<BuynowCartArgs> page =
      _i14.PageInfo<BuynowCartArgs>(name);
}

class BuynowCartArgs {
  const BuynowCartArgs({this.key});

  final _i16.Key? key;

  @override
  String toString() {
    return 'BuynowCartArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.CartDetail]
class CartDetail extends _i14.PageRouteInfo<CartDetailArgs> {
  CartDetail({
    _i15.Key? key,
    String? itemCount,
    Function? callback,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          CartDetail.name,
          args: CartDetailArgs(
            key: key,
            itemCount: itemCount,
            callback: callback,
          ),
          rawPathParams: {'itemCount': itemCount},
          initialChildren: children,
        );

  static const String name = 'CartDetail';

  static const _i14.PageInfo<CartDetailArgs> page =
      _i14.PageInfo<CartDetailArgs>(name);
}

class CartDetailArgs {
  const CartDetailArgs({
    this.key,
    this.itemCount,
    this.callback,
  });

  final _i15.Key? key;

  final String? itemCount;

  final Function? callback;

  @override
  String toString() {
    return 'CartDetailArgs{key: $key, itemCount: $itemCount, callback: $callback}';
  }
}

/// generated route for
/// [_i4.FavouriteListPage]
class FavouriteListPage extends _i14.PageRouteInfo<FavouriteListPageArgs> {
  FavouriteListPage({
    _i16.Key? key,
    Function? callback,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          FavouriteListPage.name,
          args: FavouriteListPageArgs(
            key: key,
            callback: callback,
          ),
          initialChildren: children,
        );

  static const String name = 'FavouriteListPage';

  static const _i14.PageInfo<FavouriteListPageArgs> page =
      _i14.PageInfo<FavouriteListPageArgs>(name);
}

class FavouriteListPageArgs {
  const FavouriteListPageArgs({
    this.key,
    this.callback,
  });

  final _i16.Key? key;

  final Function? callback;

  @override
  String toString() {
    return 'FavouriteListPageArgs{key: $key, callback: $callback}';
  }
}

/// generated route for
/// [_i5.ProductListGallery]
class ProductListGallery extends _i14.PageRouteInfo<void> {
  const ProductListGallery({List<_i14.PageRouteInfo>? children})
      : super(
          ProductListGallery.name,
          initialChildren: children,
        );

  static const String name = 'ProductListGallery';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ProductDetailPage]
class ProductDetailPage extends _i14.PageRouteInfo<ProductDetailPageArgs> {
  ProductDetailPage({
    String? productName,
    List<String>? productdata,
    _i16.Key? key,
    List<_i14.PageRouteInfo>? children,
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

  static const _i14.PageInfo<ProductDetailPageArgs> page =
      _i14.PageInfo<ProductDetailPageArgs>(name);
}

class ProductDetailPageArgs {
  const ProductDetailPageArgs({
    this.productName,
    this.productdata,
    this.key,
  });

  final String? productName;

  final List<String>? productdata;

  final _i16.Key? key;

  @override
  String toString() {
    return 'ProductDetailPageArgs{productName: $productName, productdata: $productdata, key: $key}';
  }
}

/// generated route for
/// [_i7.ThankYouPage]
class ThankYouPage extends _i14.PageRouteInfo<void> {
  const ThankYouPage({List<_i14.PageRouteInfo>? children})
      : super(
          ThankYouPage.name,
          initialChildren: children,
        );

  static const String name = 'ThankYouPage';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i8.MyOrderPage]
class MyOrderPage extends _i14.PageRouteInfo<void> {
  const MyOrderPage({List<_i14.PageRouteInfo>? children})
      : super(
          MyOrderPage.name,
          initialChildren: children,
        );

  static const String name = 'MyOrderPage';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SearchPage]
class SearchPage extends _i14.PageRouteInfo<void> {
  const SearchPage({List<_i14.PageRouteInfo>? children})
      : super(
          SearchPage.name,
          initialChildren: children,
        );

  static const String name = 'SearchPage';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i10.ContactUs]
class ContactUs extends _i14.PageRouteInfo<void> {
  const ContactUs({List<_i14.PageRouteInfo>? children})
      : super(
          ContactUs.name,
          initialChildren: children,
        );

  static const String name = 'ContactUs';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i11.EditProfile]
class EditProfile extends _i14.PageRouteInfo<void> {
  const EditProfile({List<_i14.PageRouteInfo>? children})
      : super(
          EditProfile.name,
          initialChildren: children,
        );

  static const String name = 'EditProfile';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i12.HomePageWeb]
class HomePageWeb extends _i14.PageRouteInfo<void> {
  const HomePageWeb({List<_i14.PageRouteInfo>? children})
      : super(
          HomePageWeb.name,
          initialChildren: children,
        );

  static const String name = 'HomePageWeb';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i13.WebHtmlPage]
class WebHtmlPage extends _i14.PageRouteInfo<WebHtmlPageArgs> {
  WebHtmlPage({
    String? title,
    String? html,
    _i16.Key? key,
    List<_i14.PageRouteInfo>? children,
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

  static const _i14.PageInfo<WebHtmlPageArgs> page =
      _i14.PageInfo<WebHtmlPageArgs>(name);
}

class WebHtmlPageArgs {
  const WebHtmlPageArgs({
    this.title,
    this.html,
    this.key,
  });

  final String? title;

  final String? html;

  final _i16.Key? key;

  @override
  String toString() {
    return 'WebHtmlPageArgs{title: $title, html: $html, key: $key}';
  }
}
