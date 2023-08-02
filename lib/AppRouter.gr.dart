// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:easy_stepper/easy_stepper.dart' as _i17;
import 'package:flutter/material.dart' as _i18;
import 'package:TychoStream/view/Products/address_list_page.dart' as _i1;
import 'package:TychoStream/view/Products/banner_product.dart' as _i2;
import 'package:TychoStream/view/Products/buynowcart.dart' as _i3;
import 'package:TychoStream/view/Products/cart_detail_page.dart' as _i4;
import 'package:TychoStream/view/Products/favourite_list_page.dart' as _i5;
import 'package:TychoStream/view/Products/product_details.dart' as _i7;
import 'package:TychoStream/view/Products/ProductList.dart' as _i6;
import 'package:TychoStream/view/Products/thankyou_page.dart' as _i8;
import 'package:TychoStream/view/search/search_page.dart' as _i9;
import 'package:TychoStream/view/WebScreen/contact_us.dart' as _i10;
import 'package:TychoStream/view/WebScreen/EditProfile.dart' as _i11;
import 'package:TychoStream/view/WebScreen/FAQ.dart' as _i12;
import 'package:TychoStream/view/WebScreen/HomePageWeb.dart' as _i13;
import 'package:TychoStream/view/WebScreen/Privacy.dart' as _i14;
import 'package:TychoStream/view/WebScreen/Terms.dart' as _i15;
import 'package:TychoStream/viewmodel/profile_view_model.dart' as _i19;

abstract class $AppRouter extends _i16.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i16.PageFactory> pagesMap = {
    AddressListPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AddressListPageArgs>(
          orElse: () =>
              AddressListPageArgs(buynow: pathParams.optBool('buynow')));
      return _i16.AutoRoutePage<dynamic>(
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
      return _i16.AutoRoutePage<dynamic>(
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
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.BuynowCart(key: args.key),
      );
    },
    CartDetail.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CartDetailArgs>(
          orElse: () =>
              CartDetailArgs(itemCount: pathParams.optString('itemCount')));
      return _i16.AutoRoutePage<dynamic>(
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
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.FavouriteListPage(
          key: args.key,
          callback: args.callback,
        ),
      );
    },
    ProductListGallery.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
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
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.ProductDetailPage(
          productId: args.productId,
          productdata: args.productdata,
          key: args.key,
        ),
      );
    },
    ThankYouPage.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.ThankYouPage(),
      );
    },
    SearchPage.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SearchPage(),
      );
    },
    ContactUs.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ContactUs(),
      );
    },
    EditProfile.name: (routeData) {
      final args = routeData.argsAs<EditProfileArgs>(
          orElse: () => const EditProfileArgs());
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.EditProfile(
          key: args.key,
          viewmodel: args.viewmodel,
          isEmailVerified: args.isEmailVerified,
          isPhoneVerified: args.isPhoneVerified,
        ),
      );
    },
    FAQ.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.FAQ(),
      );
    },
    HomePageWeb.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.HomePageWeb(),
      );
    },
    Privacy.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.Privacy(),
      );
    },
    Terms.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.Terms(),
      );
    },
  };
}

/// generated route for
/// [_i1.AddressListPage]
class AddressListPage extends _i16.PageRouteInfo<AddressListPageArgs> {
  AddressListPage({
    _i17.Key? key,
    bool? buynow,
    List<_i16.PageRouteInfo>? children,
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

  static const _i16.PageInfo<AddressListPageArgs> page =
      _i16.PageInfo<AddressListPageArgs>(name);
}

class AddressListPageArgs {
  const AddressListPageArgs({
    this.key,
    this.buynow,
  });

  final _i17.Key? key;

  final bool? buynow;

  @override
  String toString() {
    return 'AddressListPageArgs{key: $key, buynow: $buynow}';
  }
}

/// generated route for
/// [_i2.banner_product]
class Banner_product extends _i16.PageRouteInfo<Banner_productArgs> {
  Banner_product({
    String? productId,
    String? productdata,
    _i18.Key? key,
    List<_i16.PageRouteInfo>? children,
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

  static const _i16.PageInfo<Banner_productArgs> page =
      _i16.PageInfo<Banner_productArgs>(name);
}

class Banner_productArgs {
  const Banner_productArgs({
    this.productId,
    this.productdata,
    this.key,
  });

  final String? productId;

  final String? productdata;

  final _i18.Key? key;

  @override
  String toString() {
    return 'Banner_productArgs{productId: $productId, productdata: $productdata, key: $key}';
  }
}

/// generated route for
/// [_i3.BuynowCart]
class BuynowCart extends _i16.PageRouteInfo<BuynowCartArgs> {
  BuynowCart({
    _i18.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          BuynowCart.name,
          args: BuynowCartArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'BuynowCart';

  static const _i16.PageInfo<BuynowCartArgs> page =
      _i16.PageInfo<BuynowCartArgs>(name);
}

class BuynowCartArgs {
  const BuynowCartArgs({this.key});

  final _i18.Key? key;

  @override
  String toString() {
    return 'BuynowCartArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.CartDetail]
class CartDetail extends _i16.PageRouteInfo<CartDetailArgs> {
  CartDetail({
    _i17.Key? key,
    String? itemCount,
    Function? callback,
    List<_i16.PageRouteInfo>? children,
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

  static const _i16.PageInfo<CartDetailArgs> page =
      _i16.PageInfo<CartDetailArgs>(name);
}

class CartDetailArgs {
  const CartDetailArgs({
    this.key,
    this.itemCount,
    this.callback,
  });

  final _i17.Key? key;

  final String? itemCount;

  final Function? callback;

  @override
  String toString() {
    return 'CartDetailArgs{key: $key, itemCount: $itemCount, callback: $callback}';
  }
}

/// generated route for
/// [_i5.FavouriteListPage]
class FavouriteListPage extends _i16.PageRouteInfo<FavouriteListPageArgs> {
  FavouriteListPage({
    _i18.Key? key,
    Function? callback,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          FavouriteListPage.name,
          args: FavouriteListPageArgs(
            key: key,
            callback: callback,
          ),
          initialChildren: children,
        );

  static const String name = 'FavouriteListPage';

  static const _i16.PageInfo<FavouriteListPageArgs> page =
      _i16.PageInfo<FavouriteListPageArgs>(name);
}

class FavouriteListPageArgs {
  const FavouriteListPageArgs({
    this.key,
    this.callback,
  });

  final _i18.Key? key;

  final Function? callback;

  @override
  String toString() {
    return 'FavouriteListPageArgs{key: $key, callback: $callback}';
  }
}

/// generated route for
/// [_i6.ProductListGallery]
class ProductListGallery extends _i16.PageRouteInfo<void> {
  const ProductListGallery({List<_i16.PageRouteInfo>? children})
      : super(
          ProductListGallery.name,
          initialChildren: children,
        );

  static const String name = 'ProductListGallery';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ProductDetailPage]
class ProductDetailPage extends _i16.PageRouteInfo<ProductDetailPageArgs> {
  ProductDetailPage({
    String? productId,
    List<String>? productdata,
    _i18.Key? key,
    List<_i16.PageRouteInfo>? children,
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

  static const _i16.PageInfo<ProductDetailPageArgs> page =
      _i16.PageInfo<ProductDetailPageArgs>(name);
}

class ProductDetailPageArgs {
  const ProductDetailPageArgs({
    this.productId,
    this.productdata,
    this.key,
  });

  final String? productId;

  final List<String>? productdata;

  final _i18.Key? key;

  @override
  String toString() {
    return 'ProductDetailPageArgs{productId: $productId, productdata: $productdata, key: $key}';
  }
}

/// generated route for
/// [_i8.ThankYouPage]
class ThankYouPage extends _i16.PageRouteInfo<void> {
  const ThankYouPage({List<_i16.PageRouteInfo>? children})
      : super(
          ThankYouPage.name,
          initialChildren: children,
        );

  static const String name = 'ThankYouPage';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SearchPage]
class SearchPage extends _i16.PageRouteInfo<void> {
  const SearchPage({List<_i16.PageRouteInfo>? children})
      : super(
          SearchPage.name,
          initialChildren: children,
        );

  static const String name = 'SearchPage';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i10.ContactUs]
class ContactUs extends _i16.PageRouteInfo<void> {
  const ContactUs({List<_i16.PageRouteInfo>? children})
      : super(
          ContactUs.name,
          initialChildren: children,
        );

  static const String name = 'ContactUs';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i11.EditProfile]
class EditProfile extends _i16.PageRouteInfo<EditProfileArgs> {
  EditProfile({
    _i18.Key? key,
    _i19.ProfileViewModel? viewmodel,
    String? isEmailVerified,
    String? isPhoneVerified,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          EditProfile.name,
          args: EditProfileArgs(
            key: key,
            viewmodel: viewmodel,
            isEmailVerified: isEmailVerified,
            isPhoneVerified: isPhoneVerified,
          ),
          initialChildren: children,
        );

  static const String name = 'EditProfile';

  static const _i16.PageInfo<EditProfileArgs> page =
      _i16.PageInfo<EditProfileArgs>(name);
}

class EditProfileArgs {
  const EditProfileArgs({
    this.key,
    this.viewmodel,
    this.isEmailVerified,
    this.isPhoneVerified,
  });

  final _i18.Key? key;

  final _i19.ProfileViewModel? viewmodel;

  final String? isEmailVerified;

  final String? isPhoneVerified;

  @override
  String toString() {
    return 'EditProfileArgs{key: $key, viewmodel: $viewmodel, isEmailVerified: $isEmailVerified, isPhoneVerified: $isPhoneVerified}';
  }
}

/// generated route for
/// [_i12.FAQ]
class FAQ extends _i16.PageRouteInfo<void> {
  const FAQ({List<_i16.PageRouteInfo>? children})
      : super(
          FAQ.name,
          initialChildren: children,
        );

  static const String name = 'FAQ';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i13.HomePageWeb]
class HomePageWeb extends _i16.PageRouteInfo<void> {
  const HomePageWeb({List<_i16.PageRouteInfo>? children})
      : super(
          HomePageWeb.name,
          initialChildren: children,
        );

  static const String name = 'HomePageWeb';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i14.Privacy]
class Privacy extends _i16.PageRouteInfo<void> {
  const Privacy({List<_i16.PageRouteInfo>? children})
      : super(
          Privacy.name,
          initialChildren: children,
        );

  static const String name = 'Privacy';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i15.Terms]
class Terms extends _i16.PageRouteInfo<void> {
  const Terms({List<_i16.PageRouteInfo>? children})
      : super(
          Terms.name,
          initialChildren: children,
        );

  static const String name = 'Terms';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}
