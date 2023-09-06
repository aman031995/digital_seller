
import 'package:TychoStream/main.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppRouter.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {

  @override
  List<AutoRoute> routes = [
     AutoRoute(page: HomePageWeb.page, path: '/',initial: true),

    AutoRoute(page: SearchPage.page,path: '/SearchPage'),

    AutoRoute(page: EditProfile.page,path: '/EditProfile',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            resolver.redirect(HomePageWeb());
          }
        },
      )]),

    AutoRoute(page: ProductListGallery.page,path: '/ProductListGallery'),

    AutoRoute(page: FavouriteListPage.page,path: '/FavouriteListPage',guards: [AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            resolver.redirect(HomePageWeb());
          }
        },
      )]),

    AutoRoute(page: AddressListPage.page,path: '/AddressListPage/:buynow',guards: [
      AutoRouteGuard.simple((resolver, scope) async {
              token= SessionStorageHelper.getValue("payment");
          if(token==null){
            resolver.next();
          }
          else if (token=='false') {
            resolver.next();
          } else {
            resolver.redirect(HomePageWeb());
          }
        },
      )]),

    AutoRoute(page: MyOrderPage.page,path:'/MyOrderPage',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            resolver.redirect(HomePageWeb());

          }
        },
      )]),

    AutoRoute(page: ProductDetailPage.page,path: '/ProductDetailPage/:productName'),

    AutoRoute(page: CategorySubcategoryProduct.page,path: '/CategorySubcategoryProduct/:CategoryName'),

    AutoRoute(page: SubcategoryProductList.page,path: '/SubcategoryProductList/:SubcategoryProductName'),

    AutoRoute(page: BannerProductDetailPage.page,path: '/BannerProductDetailPage'),

    AutoRoute(page: CartDetail.page,path: '/CartDetails/:itemCount',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            resolver.redirect(HomePageWeb());
          }
        },
      )]),

    AutoRoute(page: WebHtmlPage.page,path: '/WebHtmlPage/:title'),

    AutoRoute(page: ContactUs.page,path: '/ContactUs',guards: [
  AutoRouteGuard.simple(
  (resolver, scope) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.get('token') != null) {
  resolver.next();
  } else {
    resolver.redirect(HomePageWeb());
  }
  },
  )]),

    AutoRoute(page: ThankYouPage.page,path: '/ThankYouPage',keepHistory: false,guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          token= SessionStorageHelper.getValue("payment");
          if(token==null){
            resolver.next();
          }
          else if (token=='false') {
            resolver.next();
          } else {
            resolver.redirect(HomePageWeb());
          }
        },
      )]),

    AutoRoute(page:BuynowCart.page,path: '/Buynow',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            resolver.redirect(HomePageWeb());
          }
        },
      )])
  ];
}

