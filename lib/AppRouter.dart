
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/services/session_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppRouter.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {

  @override
  List<AutoRoute> routes = [
     AutoRoute(page: HomePageWeb.page, path: '/',initial: true,maintainState: false),
  // AutoRoute(page: HomePageRestaurant.page,path: '/',initial: true),
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
    AutoRoute(page: EditProfile.page,path: '/EditProfile',maintainState: false,guards: [
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
    AutoRoute(page: NotificationRoute.page,path: '/NotificationScreen',maintainState: false),
    AutoRoute(page: SearchPage.page,path: '/SearchPage',maintainState: false),

    AutoRoute(page: ProductListGallery.page,path: '/Category',maintainState: false),
    AutoRoute(page: BuynowAddress.page,path: '/BuynowAddress',maintainState: false),
    AutoRoute(page: FavouriteListPage.page,path: '/FavouriteListPage',maintainState: false,guards: [AutoRouteGuard.simple(
          (resolver, scope) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        if (sharedPreferences.get('token') != null) {
          resolver.next();
        } else {
          resolver.redirect(HomePageWeb());
        }
      },
    )]),

    AutoRoute(page: AddressListPage.page,path: '/AddressListPage',maintainState: false,guards: [
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

    AutoRoute(page: MyOrderPage.page,path:'/MyOrderPage',maintainState: false,guards: [
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

    AutoRoute(page: ProductDetailPage.page,path: '/:productName',maintainState: false),

    AutoRoute(page: CategorySubcategoryProduct.page,path: '/Cs/:CategoryName',maintainState: false),

    AutoRoute(page: SubcategoryProductList.page,path: '/Sp/:SubcategoryProductName',maintainState: false),

    AutoRoute(page: BannerProductDetailPage.page,path: '/BPD/:ds',maintainState: false),

    AutoRoute(page: CartDetail.page,path: '/CartDetail/:itemCount',maintainState: false,guards: [
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

    AutoRoute(page: WebHtmlPage.page,path: '/Web/:title',maintainState: false),

    AutoRoute(page: ContactUs.page,path: '/ContactUs',maintainState: true,guards: [
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

    AutoRoute(page: ThankYouPage.page,path: '/ThankYouPage',maintainState: false,keepHistory: false,guards: [
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

    AutoRoute(page:BuynowCart.page,path: '/Buynow/:product',maintainState: false),
    RedirectRoute(path: '*', redirectTo: '/')

  ];
}

