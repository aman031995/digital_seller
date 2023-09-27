
import 'package:TychoStream/main.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/services/session_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppRouter.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {

  @override
  List<AutoRoute> routes = [
    // AutoRoute(page: HomePageWeb.page, path: '/',initial: true),
   AutoRoute(page: HomePageRestaurant.page,path: '/',initial: true),
    AutoRoute(page: ProductListRestaurantGallery.page,path: "/ProductListRestaurantGallery"),
    AutoRoute(page: RestaurantSubcategoryProductList.page,path: '/RestaurantSubcategoryProductList/:SubcategoryProductName'),
    AutoRoute(page: RestaurantFavouriteListPage.page,path: '/RestaurantFavouriteListPage',guards: [AutoRouteGuard.simple(
          (resolver, scope) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        if (sharedPreferences.get('token') != null) {
          resolver.next();
        } else {
          resolver.redirect(HomePageRestaurant());
        }
      },
    )]),


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

    AutoRoute(page: NotificationRoute.page,path: '/NotificationScreen'),
    AutoRoute(page: ProductListGallery.page,path: '/ProductListGallery'),
    AutoRoute(page: BuynowAddress.page,path: '/BuynowAddress'),


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
        GlobalVariable.token= SessionStorageHelper.getValue("payment");
          if(GlobalVariable.token==null){
            resolver.next();
          }
          else if (GlobalVariable.token=='false') {
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
              GlobalVariable.token= SessionStorageHelper.getValue("payment");
          if(GlobalVariable.token==null){
            resolver.next();
          }
          else if (GlobalVariable.token=='false') {
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

