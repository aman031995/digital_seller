import 'dart:convert';

import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/model/data/homepage_data_model.dart';
import 'package:TychoStream/model/data/tray_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/model/data/AppConfigModel.dart';
import 'package:TychoStream/model/data/BannerDataModel.dart';
import 'package:TychoStream/model/data/app_menu_model.dart';
import 'package:TychoStream/model/data/notification_model.dart';
import 'package:TychoStream/model/data/search_data_model.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/CacheDataManager.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/HomePageRepository.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/StringConstants.dart';



class HomeViewModel with ChangeNotifier {
  final _homePageRepo = HomePageRepository();

  BannerDataModel? _bannerDataModal;
  BannerDataModel? get bannerDataModal => _bannerDataModal;

  HomePageDataModel? _homePageDataModel;
  HomePageDataModel? get homePageDataModel => _homePageDataModel;

  HomePageDataModel? _newHomePageDataModel;
  HomePageDataModel? get newHomePageDataModel => _newHomePageDataModel;

  NotificationModel? _notificationModel;
  NotificationModel? get notificationModel => _notificationModel;

  NotificationModel? _newNotificationModel;
  NotificationModel? get newNotificationModel => _newNotificationModel;

  List<TrayDataModel>? _trayDataModel;
  List<TrayDataModel>? get trayDataModel => _trayDataModel;

  AppConfigModel? _appConfigModel;
  AppConfigModel? get appConfigModel => _appConfigModel;

  SearchDataModel? _searchDataModel;
  SearchDataModel? get searchDataModel => _searchDataModel;


  ItemCountModel? _itemCountModel;

  ItemCountModel? get itemCountModel => _itemCountModel;

  SearchDataModel? _newSearchDataModel;
  SearchDataModel? get newSearchDataModel => _newSearchDataModel;
  AppMenuModel? _appMenuModel;
  AppMenuModel? get appMenuModel => _appMenuModel;
  String? _isNetworkAvailable;
  String? get isNetworkAvailable => _isNetworkAvailable;
  int lastPage = 1, nextPage = 1;
  bool isLoading = false;
  bool loginWithPhone = false;
  String notificationItem = '0';
  String? menuVersion, message;
  // getBanner(BuildContext context) async{
  //   final box = await Hive.openBox<String>('appBox');
  //   final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
  //
  //   if (await jsonCache.contains(StringConstant.kBannerList)) {
  //     CacheDataManager.getCachedData(key: StringConstant.kBannerList).then((jsonData) {
  //       _bannerDataModal = BannerDataModel.fromJson(jsonData!['data']);
  //       print('From Cached BannerList');
  //       notifyListeners();
  //     });
  //   } else {
  //     getBannerLists(context);
  //   }
  // }
  getLoginType(BuildContext context, bool type) {
    loginWithPhone = type;
    notifyListeners();
  }
  Future<void> getBannerLists(BuildContext context) async {
    _homePageRepo.getBannerData(context, (result, isSuccess) {
      if (isSuccess) {
        _bannerDataModal = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }
  Future<void> getNotificationCountText(BuildContext context) async {
    _homePageRepo.getNotificationCount(context, (result, isSuccess) {
      if (isSuccess) {
        _itemCountModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        notificationItem = _itemCountModel?.count.toString() ?? '';
        notifyListeners();
      }
    });
  }
  Future<void> getHomePageData(
      BuildContext context, TrayDataModel? element,int pageNum,String type) async {
    // AppIndicator.loadingIndicator();
    _homePageRepo.getHomePageData(element?.trayId ?? 1,type, pageNum, context,
            (result, isSuccess) {
          if (isSuccess) {
            // _homePageDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            ASResponseModal responseModal = (result as SuccessState).value as ASResponseModal;
            _homePageDataModel = responseModal.dataModal;
            PlatformMovieData platformMovieData = new PlatformMovieData(
                element?.trayIdentifier ?? '',
                element?.trayIdentifier ?? '',
                _homePageDataModel!.videoList!);
            element?.updatePlatformData(platformMovieData);
            notifyListeners();
          }
        });
  }

  Future<void> getTrayData(BuildContext context) async {
    _homePageRepo.getTrayDataList(context, (result, isSuccess) {
      if (isSuccess) {
        _trayDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        _trayDataModel?.forEach((element) {
          getHomePageData(context, element,1,'video');
        });
        notifyListeners();
      }
    });
  }

  Future<void> getMoreLikeThis(BuildContext context, String videoId)async{
    _homePageRepo.getMoreLikeThisData(videoId, context,
            (result, isSuccess) {
          if (isSuccess) {
            _homePageDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            notifyListeners();
          }
        });
  }

  Future<void> checkConnectivity(BuildContext context) async{
    AppNetwork.checkInternet((isSuccess, result) {
      if(isSuccess){
        _isNetworkAvailable = result;
        notifyListeners();
      }
    });
  }

  getAppConfigData(BuildContext context) async{
    final box = await Hive.openBox<String>('appBox');
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    if(await jsonCache.contains(StringConstant.kAppConfig)){
      CacheDataManager.getCachedData(key: StringConstant.kAppConfig).then((jsonData) {
        _appConfigModel = AppConfigModel.fromJson(jsonData!['data']);
        loginWithPhone = _appConfigModel?.androidConfig?.loginWithPhone ?? false;
        print('From Cached AppConfig Data');
        notifyListeners();
      });
    }
  }

  Future getAppConfig(BuildContext context) async{
    _homePageRepo.getAppConfiguration(context, (result, isSuccess) {
      if(isSuccess) {
        _appConfigModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        navigation(context, _appConfigModel);
        notifyListeners();
      }
    });
  }

  void navigation(BuildContext context, AppConfigModel? appConfigModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isPhone = sharedPreferences.getString('phone');
    if (isPhone != null) {
      // Navigator.pushNamedAndRemoveUntil(
      //     context, RoutesName.bottomNavigation, (route) => false);
    } else {
      // Navigator.pushAndRemoveUntil(context,
      //     MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
    }
  }

  Future<void> getSearchData(BuildContext context, String searchKeyword, int pageNum) async{
    _homePageRepo.getSearchApiData(searchKeyword, pageNum, context, (result, isSuccess) {
      if(isSuccess){
        _newSearchDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        message = ((result).value as ASResponseModal).message;
        if (_newSearchDataModel?.pagination?.current == 1) {
          lastPage = _newSearchDataModel?.pagination?.lastPage ?? 1;
          nextPage = _newSearchDataModel?.pagination?.next ?? 1;
          _searchDataModel = _newSearchDataModel;
        } else {
          lastPage = _newSearchDataModel?.pagination?.lastPage ?? 1;
          nextPage = _newSearchDataModel?.pagination?.next ?? 1;
          if(_newSearchDataModel != null){
            _searchDataModel?.searchList?.addAll(_newSearchDataModel!.searchList!);
          }
        }
        isLoading = false;
        notifyListeners();
      }
    });
  }
  void getNotification(BuildContext context, int pageNum){
    _homePageRepo.getNotification(pageNum,context, (result, isSuccess) {
      if(isSuccess){
        _newNotificationModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        if (_newNotificationModel?.pagination?.current == 1) {
          lastPage = _newNotificationModel?.pagination?.lastPage ?? 1;
          nextPage = _newNotificationModel?.pagination?.next ?? 1;
          _notificationModel = _newNotificationModel;
        } else {
          lastPage = _newNotificationModel?.pagination?.lastPage ?? 1;
          nextPage = _newNotificationModel?.pagination?.next ?? 1;
          _notificationModel?.notificationList?.addAll(_newNotificationModel!.notificationList!);
        }
        isLoading = false;
        notifyListeners();
      }
    });
  }
  getAppMenuData(BuildContext context) async{
    final box = await Hive.openBox<String>('appBox');
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    if(await jsonCache.contains(StringConstant.kAppMenu)){
      CacheDataManager.getCachedData(key: StringConstant.kAppMenu).then((jsonData) {
        _appMenuModel = AppMenuModel.fromJson(jsonData!['data']);
        print('From Cached AppConfig Data');
        notifyListeners();
      });
    } else {
      getAppMenu(context);
    }
  }

  Future getAppMenu(BuildContext context) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _homePageRepo.getAppMenu(context, (result, isSuccess) {
      if(isSuccess){
        _appMenuModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        String? newMenuVersion = sharedPreferences.getString('newMenuVersion');
        sharedPreferences.setString('oldMenuVersion', '${newMenuVersion}');
        notifyListeners();
      }
    });
  }
  Future<void> runIndicator(BuildContext context)async {
    isLoading = true;
    notifyListeners();
  }

  Future<void> stopIndicator(BuildContext context)async {
    isLoading = false;
    notifyListeners();
  }
  Future<void> updateNotificationCount(BuildContext context, String count) async {
    notificationItem = count;
    notifyListeners();
  }
}
