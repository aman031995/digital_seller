// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i18;
import 'package:easy_stepper/easy_stepper.dart' as _i19;
import 'package:flutter/material.dart' as _i20;
import 'package:TychoStream/view/Products/address_list_page.dart' as _i1;
import 'package:TychoStream/view/Products/banner_product.dart' as _i2;
import 'package:TychoStream/view/Products/buynowcart.dart' as _i3;
import 'package:TychoStream/view/Products/cart_detail_page.dart' as _i4;
import 'package:TychoStream/view/Products/favourite_list_page.dart' as _i5;
import 'package:TychoStream/view/Products/product_details.dart' as _i7;
import 'package:TychoStream/view/Products/ProductList.dart' as _i6;
import 'package:TychoStream/view/Products/thankyou_page.dart' as _i8;
import 'package:TychoStream/view/Profile/my_order_page.dart' as _i9;
import 'package:TychoStream/view/search/search_page.dart' as _i10;
import 'package:TychoStream/view/WebScreen/contact_us.dart' as _i11;
import 'package:TychoStream/view/WebScreen/EditProfile.dart' as _i12;
import 'package:TychoStream/view/WebScreen/FAQ.dart' as _i13;
import 'package:TychoStream/view/WebScreen/HomePageWeb.dart' as _i14;
import 'package:TychoStream/view/WebScreen/Privacy.dart' as _i15;
import 'package:TychoStream/view/widgets/web_html_page.dart' as _i17;
import 'package:TychoStream/viewmodel/profile_view_model.dart' as _i21;

abstract class $AppRouter extends _i18.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i18.PageFactory> pagesMap = {
    AddressListPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AddressListPageArgs>(
          orElse: () =>
              AddressListPageArgs(buynow: pathParams.optBool('buynow')));
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddressListPage(
          key: args.key,
          buynow: args.buynow,
        ),
      );
    },
    Banner_product.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<Banner_productArgs>(
          orElse: () => Banner_productArgs(
                productId: pathParams.optString('bannerId'),
                productdata: queryParams.optString('productdata'),
              ));
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.banner_product(
          productId: args.productId,
          productdata: args.productdata,
          key: args.key,
        ),
      );
    },
    BuynowCart.name: (routeData) {
      final args = routeData.argsAs<BuynowCartArgs>(
          orElse: () => const BuynowCartArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.BuynowCart(key: args.key),
      );
    },
    CartDetail.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CartDetailArgs>(
          orElse: () =>
              CartDetailArgs(itemCount: pathParams.optString('itemCount')));
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.CartDetail(
          key: args.key,
          itemCount: args.itemCount,
          callback: args.callback,
        ),
      );
    },
    FavouriteListPage.name: (routeData) {
      final args = routeData.argsAs<FavouriteListPageArgs>(
          orElse: () => const FavouriteListPageArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.FavouriteListPage(
          key: args.key,
          callback: args.callback,
        ),
      );
    },
    ProductListGallery.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.ProductListGallery(),
      );
    },
    ProductDetailPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<ProductDetailPageArgs>(
          orElse: () => ProductDetailPageArgs(
                productId: pathParams.optString('productId'),
                productdata: queryParams.get('productdata'),
              ));
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.ProductDetailPage(
          productId: args.productId,
          productdata: args.productdata,
          key: args.key,
        ),
      );
    },
    ThankYouPage.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.ThankYouPage(),
      );
    },
    MyOrderPage.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.MyOrderPage(),
      );
    },
    SearchPage.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SearchPage(),
      );
    },
    ContactUs.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.ContactUs(),
      );
    },
    EditProfile.name: (routeData) {
      final args = routeData.argsAs<EditProfileArgs>(
          orElse: () => const EditProfileArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.EditProfile(
          key: args.key,
          viewmodel: args.viewmodel,
        ),
      );
    },
    FAQ.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.FAQ(),
      );
    },
    HomePageWeb.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.HomePageWeb(),
      );
    },
    Privacy.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.Privacy(),
      );
    },
    WebHtmlPage.name: (routeData) {
      final args = routeData.argsAs<WebHtmlPageArgs>(
          orElse: () => const WebHtmlPageArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i17.WebHtmlPage(
          key: args.key,
          html: args.html,
          title: args.title,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AddressListPage]
class AddressListPage extends _i18.PageRouteInfo<AddressListPageArgs> {
  AddressListPage({
    _i19.Key? key,
    bool? buynow,
    List<_i18.PageRouteInfo>? children,
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

  static const _i18.PageInfo<AddressListPageArgs> page =
      _i18.PageInfo<AddressListPageArgs>(name);
}

class AddressListPageArgs {
  const AddressListPageArgs({
    this.key,
    this.buynow,
  });

  final _i19.Key? key;

  final bool? buynow;

  @override
  String toString() {
    return 'AddressListPageArgs{key: $key, buynow: $buynow}';
  }
}

/// generated route for
/// [_i2.banner_product]
class Banner_product extends _i18.PageRouteInfo<Banner_productArgs> {
  Banner_product({
    String? productId,
    String? productdata,
    _i20.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          Banner_product.name,
          args: Banner_productArgs(
            productId: productId,
            productdata: productdata,
            key: key,
          ),
          rawPathParams: {'bannerId': productId},
          rawQueryParams: {'productdata': productdata},
          initialChildren: children,
        );

  static const String name = 'Banner_product';

  static const _i18.PageInfo<Banner_productArgs> page =
      _i18.PageInfo<Banner_productArgs>(name);
}

class Banner_productArgs {
  const Banner_productArgs({
    this.productId,
    this.productdata,
    this.key,
  });

  final String? productId;

  final String? productdata;

  final _i20.Key? key;

  @override
  String toString() {
    return 'Banner_productArgs{productId: $productId, productdata: $productdata, key: $key}';
  }
}

/// generated route for
/// [_i3.BuynowCart]
class BuynowCart extends _i18.PageRouteInfo<BuynowCartArgs> {
  BuynowCart({
    _i20.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          BuynowCart.name,
          args: BuynowCartArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'BuynowCart';

  static const _i18.PageInfo<BuynowCartArgs> page =
      _i18.PageInfo<BuynowCartArgs>(name);
}

class BuynowCartArgs {
  const BuynowCartArgs({this.key});

  final _i20.Key? key;

  @override
  String toString() {
    return 'BuynowCartArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.CartDetail]
class CartDetail extends _i18.PageRouteInfo<CartDetailArgs> {
  CartDetail({
    _i19.Key? key,
    String? itemCount,
    Function? callback,
    List<_i18.PageRouteInfo>? children,
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

  static const _i18.PageInfo<CartDetailArgs> page =
      _i18.PageInfo<CartDetailArgs>(name);
}

class CartDetailArgs {
  const CartDetailArgs({
    this.key,
    this.itemCount,
    this.callback,
  });

  final _i19.Key? key;

  final String? itemCount;

  final Function? callback;

  @override
  String toString() {
    return 'CartDetailArgs{key: $key, itemCount: $itemCount, callback: $callback}';
  }
}

/// generated route for
/// [_i5.FavouriteListPage]
class FavouriteListPage extends _i18.PageRouteInfo<FavouriteListPageArgs> {
  FavouriteListPage({
    _i20.Key? key,
    Function? callback,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          FavouriteListPage.name,
          args: FavouriteListPageArgs(
            key: key,
            callback: callback,
          ),
          initialChildren: children,
        );

  static const String name = 'FavouriteListPage';

  static const _i18.PageInfo<FavouriteListPageArgs> page =
      _i18.PageInfo<FavouriteListPageArgs>(name);
}

class FavouriteListPageArgs {
  const FavouriteListPageArgs({
    this.key,
    this.callback,
  });

  final _i20.Key? key;

  final Function? callback;

  @override
  String toString() {
    return 'FavouriteListPageArgs{key: $key, callback: $callback}';
  }
}

/// generated route for
/// [_i6.ProductListGallery]
class ProductListGallery extends _i18.PageRouteInfo<void> {
  const ProductListGallery({List<_i18.PageRouteInfo>? children})
      : super(
          ProductListGallery.name,
          initialChildren: children,
        );

  static const String name = 'ProductListGallery';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ProductDetailPage]
class ProductDetailPage extends _i18.PageRouteInfo<ProductDetailPageArgs> {
  ProductDetailPage({
    String? productId,
    List<String>? productdata,
    _i20.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          ProductDetailPage.name,
          args: ProductDetailPageArgs(
            productId: productId,
            productdata: productdata,
            key: key,
          ),
          rawPathParams: {'productId': productId},
          rawQueryParams: {'productdata': productdata},
          initialChildren: children,
        );

  static const String name = 'ProductDetailPage';

  static const _i18.PageInfo<ProductDetailPageArgs> page =
      _i18.PageInfo<ProductDetailPageArgs>(name);
}

class ProductDetailPageArgs {
  const ProductDetailPageArgs({
    this.productId,
    this.productdata,
    this.key,
  });

  final String? productId;

  final List<String>? productdata;

  final _i20.Key? key;

  @override
  String toString() {
    return 'ProductDetailPageArgs{productId: $productId, productdata: $productdata, key: $key}';
  }
}

/// generated route for
/// [_i8.ThankYouPage]
class ThankYouPage extends _i18.PageRouteInfo<void> {
  const ThankYouPage({List<_i18.PageRouteInfo>? children})
      : super(
          ThankYouPage.name,
          initialChildren: children,
        );

  static const String name = 'ThankYouPage';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i9.MyOrderPage]
class MyOrderPage extends _i18.PageRouteInfo<void> {
  const MyOrderPage({List<_i18.PageRouteInfo>? children})
      : super(
          MyOrderPage.name,
          initialChildren: children,
        );

  static const String name = 'MyOrderPage';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i10.SearchPage]
class SearchPage extends _i18.PageRouteInfo<void> {
  const SearchPage({List<_i18.PageRouteInfo>? children})
      : super(
          SearchPage.name,
          initialChildren: children,
        );

  static const String name = 'SearchPage';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i11.ContactUs]
class ContactUs extends _i18.PageRouteInfo<void> {
  const ContactUs({List<_i18.PageRouteInfo>? children})
      : super(
          ContactUs.name,
          initialChildren: children,
        );

  static const String name = 'ContactUs';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i12.EditProfile]
class EditProfile extends _i18.PageRouteInfo<EditProfileArgs> {
  EditProfile({
    _i20.Key? key,
    _i21.ProfileViewModel? viewmodel,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          EditProfile.name,
          args: EditProfileArgs(
            key: key,
            viewmodel: viewmodel,
          ),
          initialChildren: children,
        );

  static const String name = 'EditProfile';

  static const _i18.PageInfo<EditProfileArgs> page =
      _i18.PageInfo<EditProfileArgs>(name);
}

class EditProfileArgs {
  const EditProfileArgs({
    this.key,
    this.viewmodel,
  });

  final _i20.Key? key;

  final _i21.ProfileViewModel? viewmodel;

  @override
  String toString() {
    return 'EditProfileArgs{key: $key, viewmodel: $viewmodel}';
  }
}

/// generated route for
/// [_i13.FAQ]
class FAQ extends _i18.PageRouteInfo<void> {
  const FAQ({List<_i18.PageRouteInfo>? children})
      : super(
          FAQ.name,
          initialChildren: children,
        );

  static const String name = 'FAQ';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i14.HomePageWeb]
class HomePageWeb extends _i18.PageRouteInfo<void> {
  const HomePageWeb({List<_i18.PageRouteInfo>? children})
      : super(
          HomePageWeb.name,
          initialChildren: children,
        );

  static const String name = 'HomePageWeb';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i15.Privacy]
class Privacy extends _i18.PageRouteInfo<void> {
  const Privacy({List<_i18.PageRouteInfo>? children})
      : super(
          Privacy.name,
          initialChildren: children,
        );

  static const String name = 'Privacy';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i16.Terms]
class Terms extends _i18.PageRouteInfo<void> {
  const Terms({List<_i18.PageRouteInfo>? children})
      : super(
          Terms.name,
          initialChildren: children,
        );

  static const String name = 'Terms';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i17.WebHtmlPage]
class WebHtmlPage extends _i18.PageRouteInfo<WebHtmlPageArgs> {
  WebHtmlPage({
    _i20.Key? key,
    String? html,
    String? title,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          WebHtmlPage.name,
          args: WebHtmlPageArgs(
            key: key,
            html: html,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'WebHtmlPage';

  static const _i18.PageInfo<WebHtmlPageArgs> page =
      _i18.PageInfo<WebHtmlPageArgs>(name);
}

class WebHtmlPageArgs {
  const WebHtmlPageArgs({
    this.key,
    this.html,
    this.title,
  });

  final _i20.Key? key;

  final String? html;

  final String? title;

  @override
  String toString() {
    return 'WebHtmlPageArgs{key: $key, html: $html, title: $title}';
  }
}
