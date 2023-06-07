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
import 'package:TychoStream/view/Products/cart_detail_page.dart' as _i2;
import 'package:TychoStream/view/Products/favourite_list_page.dart' as _i3;
import 'package:TychoStream/view/Products/product_details.dart' as _i5;
import 'package:TychoStream/view/Products/ProductList.dart' as _i4;
import 'package:TychoStream/view/Products/thankyou_page.dart' as _i6;
import 'package:TychoStream/view/search/search_page.dart' as _i7;
import 'package:TychoStream/view/WebScreen/contact_us.dart' as _i8;
import 'package:TychoStream/view/WebScreen/DetailPage.dart' as _i9;
import 'package:TychoStream/view/WebScreen/EditProfile.dart' as _i10;
import 'package:TychoStream/view/WebScreen/FAQ.dart' as _i11;
import 'package:TychoStream/view/WebScreen/HomePageWeb.dart' as _i12;
import 'package:TychoStream/view/WebScreen/Privacy.dart' as _i13;
import 'package:TychoStream/view/WebScreen/Terms.dart' as _i14;
import 'package:TychoStream/view/WebScreen/ViewAllListPages.dart' as _i15;
import 'package:TychoStream/viewmodel/profile_view_model.dart' as _i19;

abstract class $AppRouter extends _i16.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i16.PageFactory> pagesMap = {
    AddressListPage.name: (routeData) {
      final args = routeData.argsAs<AddressListPageArgs>(
          orElse: () => const AddressListPageArgs());
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddressListPage(key: args.key),
      );
    },
    CartDetail.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CartDetailArgs>(
          orElse: () =>
              CartDetailArgs(itemCount: pathParams.optString('itemCount')));
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.CartDetail(
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
        child: _i3.FavouriteListPage(
          key: args.key,
          callback: args.callback,
        ),
      );
    },
    ProductListGallery.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.ProductListGallery(),
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
        child: _i5.ProductDetailPage(
          productId: args.productId,
          productdata: args.productdata,
          key: args.key,
        ),
      );
    },
    ThankYouPage.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ThankYouPage(),
      );
    },
    SearchPage.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SearchPage(),
      );
    },
    ContactUs.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.ContactUs(),
      );
    },
    DetailPage.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<DetailPageArgs>(
          orElse: () =>
              DetailPageArgs(VideoDetails: queryParams.get('VideoDetails')));
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.DetailPage(
          VideoDetails: args.VideoDetails,
          movieID: args.movieID,
          Desc: args.Desc,
          Title: args.Title,
          VideoId: args.VideoId,
        ),
      );
    },
    EditProfile.name: (routeData) {
      final args = routeData.argsAs<EditProfileArgs>(
          orElse: () => const EditProfileArgs());
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.EditProfile(
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
        child: const _i11.FAQ(),
      );
    },
    HomePageWeb.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.HomePageWeb(),
      );
    },
    Privacy.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.Privacy(),
      );
    },
    Terms.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.Terms(),
      );
    },
    SeeAllListPages.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<SeeAllListPagesArgs>(
          orElse: () =>
              SeeAllListPagesArgs(SeeDetail: queryParams.get('SeeDetail')));
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.SeeAllListPages(
          SeeDetail: args.SeeDetail,
          key: args.key,
          title: args.title,
          VideoId: args.VideoId,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AddressListPage]
class AddressListPage extends _i16.PageRouteInfo<AddressListPageArgs> {
  AddressListPage({
    _i17.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          AddressListPage.name,
          args: AddressListPageArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AddressListPage';

  static const _i16.PageInfo<AddressListPageArgs> page =
      _i16.PageInfo<AddressListPageArgs>(name);
}

class AddressListPageArgs {
  const AddressListPageArgs({this.key});

  final _i17.Key? key;

  @override
  String toString() {
    return 'AddressListPageArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.CartDetail]
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
/// [_i3.FavouriteListPage]
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
/// [_i4.ProductListGallery]
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
/// [_i5.ProductDetailPage]
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
/// [_i6.ThankYouPage]
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
/// [_i7.SearchPage]
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
/// [_i8.ContactUs]
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
/// [_i9.DetailPage]
class DetailPage extends _i16.PageRouteInfo<DetailPageArgs> {
  DetailPage({
    List<String>? VideoDetails,
    String? movieID,
    String? Desc,
    String? Title,
    String? VideoId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          DetailPage.name,
          args: DetailPageArgs(
            VideoDetails: VideoDetails,
            movieID: movieID,
            Desc: Desc,
            Title: Title,
            VideoId: VideoId,
          ),
          rawQueryParams: {'VideoDetails': VideoDetails},
          initialChildren: children,
        );

  static const String name = 'DetailPage';

  static const _i16.PageInfo<DetailPageArgs> page =
      _i16.PageInfo<DetailPageArgs>(name);
}

class DetailPageArgs {
  const DetailPageArgs({
    this.VideoDetails,
    this.movieID,
    this.Desc,
    this.Title,
    this.VideoId,
  });

  final List<String>? VideoDetails;

  final String? movieID;

  final String? Desc;

  final String? Title;

  final String? VideoId;

  @override
  String toString() {
    return 'DetailPageArgs{VideoDetails: $VideoDetails, movieID: $movieID, Desc: $Desc, Title: $Title, VideoId: $VideoId}';
  }
}

/// generated route for
/// [_i10.EditProfile]
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
/// [_i11.FAQ]
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
/// [_i12.HomePageWeb]
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
/// [_i13.Privacy]
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
/// [_i14.Terms]
class Terms extends _i16.PageRouteInfo<void> {
  const Terms({List<_i16.PageRouteInfo>? children})
      : super(
          Terms.name,
          initialChildren: children,
        );

  static const String name = 'Terms';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i15.SeeAllListPages]
class SeeAllListPages extends _i16.PageRouteInfo<SeeAllListPagesArgs> {
  SeeAllListPages({
    List<String>? SeeDetail,
    _i18.Key? key,
    String? title,
    String? VideoId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          SeeAllListPages.name,
          args: SeeAllListPagesArgs(
            SeeDetail: SeeDetail,
            key: key,
            title: title,
            VideoId: VideoId,
          ),
          rawQueryParams: {'SeeDetail': SeeDetail},
          initialChildren: children,
        );

  static const String name = 'SeeAllListPages';

  static const _i16.PageInfo<SeeAllListPagesArgs> page =
      _i16.PageInfo<SeeAllListPagesArgs>(name);
}

class SeeAllListPagesArgs {
  const SeeAllListPagesArgs({
    this.SeeDetail,
    this.key,
    this.title,
    this.VideoId,
  });

  final List<String>? SeeDetail;

  final _i18.Key? key;

  final String? title;

  final String? VideoId;

  @override
  String toString() {
    return 'SeeAllListPagesArgs{SeeDetail: $SeeDetail, key: $key, title: $title, VideoId: $VideoId}';
  }
}
