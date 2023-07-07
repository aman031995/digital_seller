

import 'dart:js';

import 'package:TychoStream/main.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppRouter.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {

  @override
  // TODO: implement routes
  List<AutoRoute> routes = [
     AutoRoute(page: HomePageWeb.page, path: '/',initial: true),
    AutoRoute(page: DetailPage.page,path: '/DetailPage'),
    AutoRoute(page: SeeAllListPages.page,path: '/SeeAllListPages'),
    AutoRoute(page: SearchPage.page,path: '/SearchPage',guards: [
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
    AutoRoute(page: Banner_product.page,path: '/banner_product/:bannerId',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            ToastMessage.message("Please Login User");
          //  resolver.redirect(HomePageWeb());
          }
        },
      )]),
    AutoRoute(page: EditProfile.page,path: '/EditProfile',guards: [
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
    AutoRoute(page: ProductListGallery.page,path: '/ProductListGallery',guards: [
      AutoRouteGuard.simple(
          (resolver, scope) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
         if (sharedPreferences.get('token') != null) {
          resolver.next();
        } else {
           ToastMessage.message("Please Login User");
           //resolver.redirect(HomePageWeb());
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
          }
        },
      )]),
    AutoRoute(page: AddressListPage.page,path: '/AddressListPage/:buynow',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
              token= SessionStorageHelper.getValue("payment");
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if(token==null){
            resolver.next();
          }
          else if (token=='false') {
            resolver.next();
          } else {
            resolver.redirect(HomePageWeb());
            // ToastMessage.message("Please Login User");
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
            ToastMessage.message("Please Login User");

          }
        },
      )]),
    AutoRoute(page: ProductDetailPage.page,path: '/ProductDetailPage/:productId',guards: [
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
    AutoRoute(page: CartDetail.page,path: '/CartDetails/:itemCount',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            ToastMessage.message("Please Login User");
            //resolver.redirect(HomePageWeb());
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
           // resolver.redirect(HomePageWeb());
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
           // resolver.redirect(HomePageWeb());
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
           // resolver.redirect(HomePageWeb());
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
           // resolver.redirect(HomePageWeb());
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
           // resolver.redirect(HomePageWeb());
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
            ToastMessage.message("Please Login User");
            // resolver.redirect(HomePageWeb());
          }
        },
      )])
  ];
}

