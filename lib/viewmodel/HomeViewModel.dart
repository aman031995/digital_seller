import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/model/data/homepage_data_model.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/model/data/tray_data_model.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/model/data/AppConfigModel.dart';
import 'package:TychoStream/model/data/BannerDataModel.dart';
import 'package:TychoStream/model/data/app_menu_model.dart';
import 'package:TychoStream/model/data/notification_model.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/CacheDataManager.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/HomePageRepository.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/StringConstants.dart';


class HomeViewModel with ChangeNotifier {
  final _homePageRepo = HomePageRepository();

  String _html = '';
  String get html => _html;

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

  ProductListModel? _searchDataModel;
  ProductListModel? get searchDataModel => _searchDataModel;

  ItemCountModel? _itemCountModel;
  ItemCountModel? get itemCountModel => _itemCountModel;

  ProductListModel? _newSearchDataModel;
  ProductListModel? get newSearchDataModel => _newSearchDataModel;

  AppMenuModel? _appMenuModel;
  AppMenuModel? get appMenuModel => _appMenuModel;

  String? _isNetworkAvailable;
  String? get isNetworkAvailable => _isNetworkAvailable;

  int lastPage = 1, nextPage = 1;

  bool isLoading = false;
  bool loginWithPhone = false;

  String notificationItem = '0';
  String? menuVersion, message;

  getLoginType(BuildContext context, bool type) {
    loginWithPhone = type;
    notifyListeners();
  }

  // method for get BannerList from cache
  getBannerList(BuildContext context) async {
    final box = await Hive.openBox<String>('appBox');
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    if (await jsonCache.contains(StringConstant.kBannerList)) {
      CacheDataManager.getCachedData(key: StringConstant.kBannerList).then((jsonData) {
        if(jsonData != null){
          _bannerDataModal = BannerDataModel.fromJson(jsonData['data']);
          print('From Cached banner data');
          notifyListeners();
        }
      });
    } else {
      getBannerLists(context);
    }
  }
  // method for get BannerList
  Future<void> getBannerLists(BuildContext context) async {
    _homePageRepo.getBannerData(context, (result, isSuccess) {
      if (isSuccess) {
        _bannerDataModal = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

//method for get AppConfiguration
  Future getAppConfig(BuildContext context) async{
    _homePageRepo.getAppConfiguration(context, (result, isSuccess) {
      if(isSuccess) {
        _appConfigModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        GlobalVariable.cod = _appConfigModel?.androidConfig?.cod;
        GlobalVariable.isLightTheme = _appConfigModel?.androidConfig?.themeType;
        GlobalVariable.payGatewayName = _appConfigModel?.androidConfig?.paymentGateway;
        GlobalVariable.cod=_appConfigModel?.androidConfig?.cod;
        loginWithPhone = _appConfigModel?.androidConfig?.loginWithPhone ?? false;
        notifyListeners();
      }
    });
  }

// method for get search Data
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
            _searchDataModel?.productList
                ?.addAll(_newSearchDataModel!.productList!);
          }
        }
        isLoading = false;
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }

//method for get AppMenu data from cache
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

  //method for getAppMenu data
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

  // method for open html content from api
  openWebHtmlView(BuildContext context, String query, {String? title}){
    _homePageRepo.openHtmlWebUrl(context, query, (response) {
      if (response != null) {
        _html = response;
        notifyListeners();
      }
    });
  }
}
