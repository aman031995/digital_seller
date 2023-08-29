
import 'package:TychoStream/main.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppRouter.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {

  @override
  // TODO: implement routes
  List<AutoRoute> routes = [
     AutoRoute(page: HomePageWeb.page, path: '/',initial: true),

    AutoRoute(page: SearchPage.page,path: '/SearchPage',
        // guards: [
      // AutoRouteGuard.simple(
      //       (resolver, scope) async {
      //     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      //     if (sharedPreferences.get('token') != null) {
      //       resolver.next();
      //
      //     } else {
      //       ToastMessage.message("Please Login User");
      //       resolver.redirect(HomePageWeb());
      //     }
      //   },
      // )]

    ),

    AutoRoute(page: EditProfile.page,path: '/EditProfile',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            // ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());
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
            //ToastMessage.message("Please Login User");
            resolver.next();
          }
        },
      )]),

    AutoRoute(page: FavouriteListPage.page,path: '/FavouriteListPage',guards: [AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            // ToastMessage.message("Please Login User");
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
          //  ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());

          }
        },
      )]),

    AutoRoute(page: ProductDetailPage.page,path: '/ProductDetailPage/:productName',guards: [
  AutoRouteGuard.simple(
  (resolver, scope) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.get('token') != null) {
  resolver.next();
  } else {
  //ToastMessage.message("Please Login User");
  resolver.next();
  }
  },
  )]),
    AutoRoute(page: CategorySubcategoryProduct.page,path: '/CategorySubcategoryProduct/:CategoryName',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            //ToastMessage.message("Please Login User");
            resolver.next();
          }
        },
      )]),
    AutoRoute(page: SubcategoryProductList.page,path: '/SubcategoryProductList/:SubcategoryProductName',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            //ToastMessage.message("Please Login User");
            resolver.next();
          }
        },
      )]),
    AutoRoute(page: BannerProductDetailPage.page,path: '/BannerProductDetailPage',guards: [
      AutoRouteGuard.simple(
            (resolver, scope) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if (sharedPreferences.get('token') != null) {
            resolver.next();
          } else {
            //ToastMessage.message("Please Login User");
            resolver.next();
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
           // ToastMessage.message("Please Login User");
            resolver.redirect(HomePageWeb());
          }
        },
      )]),


    AutoRoute(page: WebHtmlPage.page,path: '/WebHtmlPage/:title',guards: [
  AutoRouteGuard.simple(
  (resolver, scope) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.get('token') != null) {
  resolver.next();
  } else {
  //ToastMessage.message("Please Login User");
  resolver.next();
  }
  },
  )]),

    AutoRoute(page: ContactUs.page,path: '/ContactUs'),
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
          //  ToastMessage.message("Please Login User");
          }
        },
      )])
  ];
}

