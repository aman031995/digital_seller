import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/model/data/AppConfigModel.dart';
import 'package:tycho_streams/model/data/BannerDataModel.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/model/data/TrayDataModel.dart';
import 'package:tycho_streams/model/data/notification_model.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/AppNetwork.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/HomePageRepository.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';



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

  String? _isNetworkAvailable;
  String? get isNetworkAvailable => _isNetworkAvailable;
  int lastPage = 1, nextPage = 1;
  bool isLoading = false;

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

  Future<void> getBannerLists(BuildContext context) async {
    // AppIndicator.loadingIndicator();
    _homePageRepo.getBannerData(context, (result, isSuccess) {
      if (isSuccess) {
        _bannerDataModal = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

  Future<void> getHomePageData(
      BuildContext context, TrayDataModel? element,int pageNum) async {
    // AppIndicator.loadingIndicator();
    _homePageRepo.getHomePageData(element?.trayId ?? 1, pageNum, context,
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
          getHomePageData(context, element,1);
        });
        notifyListeners();
      }
    });
  }

  Future<void> getMoreLikeThis(BuildContext context, String videoId)async{
    _homePageRepo.getMoreLikeThisData(videoId ?? '', context,
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
        print('From Cached AppConfig Data');
        notifyListeners();
      });
    }
  }

  Future getAppConfig(BuildContext context) async{
    CacheDataManager.clearCachedData();
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

  Future<void> runIndicator(BuildContext context)async {
    isLoading = true;
    notifyListeners();
  }

  Future<void> stopIndicator(BuildContext context)async {
    isLoading = false;
    notifyListeners();
  }
}
