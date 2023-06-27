import 'package:TychoStream/MobileAppRouter.gr.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class MobileAppRouter extends $MobileAppRouter{

  List<AutoRoute> routes = [
    AutoRoute(page: BottomNavigationWidget.page, path: '/',initial: true),
    AutoRoute(page: HomePageWeb.page, path: '/homePage',),
    AutoRoute(page: ProductListGallery.page,path: '/ProductListGallery'),
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
      )] ),
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
    AutoRoute(page: AddressListPage.page,path: '/AddressListPage'),
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



  ];

}