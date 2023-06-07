

import 'package:TychoStream/utilities/AppToast.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppRouter.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {

  @override
  // TODO: implement routes
  List<AutoRoute> routes = [
    AutoRoute(page: HomePageWeb.page, path: '/'),
    AutoRoute(page: DetailPage.page,path: '/DetailPage'),
    AutoRoute(page: SeeAllListPages.page,path: '/SeeAllListPages'),
    AutoRoute(page: SearchPage.page,path: '/SearchPage'),
    AutoRoute(page: EditProfile.page,path: '/EditProfile' ),
    AutoRoute(page: ProductListGallery.page,path: '/ProductListGallery',guards: [
      AutoRouteGuard.simple(
          (resolver, scope) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
         if (sharedPreferences.get('token') != null) {
          resolver.next();
        } else {
           ToastMessage.message("Please Login User");
        }
      },
    )]),
    AutoRoute(page: FavouriteListPage.page,path: '/FavouriteListPage',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());
          }
        },
      )]),
    AutoRoute(page: AddressListPage.page,path: '/AddressListPage'),
    AutoRoute(page: ProductDetailPage.page,path: '/ProductDetailPage/:productId',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());
          }
        },
      )]),
    AutoRoute(page: CartDetail.page,path: '/CartDetails/:itemCount',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());
          }
        },
      )]),
    AutoRoute(page: ContactUs.page,path: '/ContactUs',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());
          }
        },
      )]),
    AutoRoute(page: FAQ.page,path: '/FAQ',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());
          }
        },
      )]),
    AutoRoute(page: Privacy.page,path: '/Privacy',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());
          }
        },
      )]),
    AutoRoute(page: Terms.page,path: '/Terms',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());
          }
        },
      )]),
    AutoRoute(page: ThankYouPage.page,path: '/ThankYouPage',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());
          }
        },
      )]),


  ];
}

