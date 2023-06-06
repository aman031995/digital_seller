/*
  By Aman Singh
 */

import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/model/data/category_data_model.dart';
import 'package:TychoStream/model/data/homepage_data_model.dart';
import 'package:TychoStream/model/data/tray_data_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/model/data/AppConfigModel.dart';
import 'package:TychoStream/model/data/BannerDataModel.dart';
import 'package:TychoStream/model/data/app_menu_model.dart';
import 'package:TychoStream/model/data/notification_model.dart';
import 'package:TychoStream/model/data/search_data_model.dart';
import 'package:TychoStream/network/ASRequestConstructor.dart';
import 'package:TychoStream/network/ASRequestModal.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/CacheDataManager.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/StringConstants.dart';


class HomePageRepository {
  Future<Result?> getBannerData(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {"{APP_ID}": NetworkConstants.kAppID};
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetBannerList, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = BannerDataModel.fromJson(map["data"]);
          // CacheDataManager.cacheData(key: StringConstant.kBannerList, jsonData: map);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getHomePageData(int videoFor,String type, int pageNum,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{USER_ID}": sharedPreferences.get("userId").toString(),
      "{APP_ID}": NetworkConstants.kAppID,
      "{VIDEO_FOR}": '$videoFor',
      "{TYPE}": type,
      "{PAGE_NUM}": '$pageNum',
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetHomePageData, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = HomePageDataModel.fromJson(map["data"]);
          // CacheDataManager.cacheData(key: StringConstant.kHomePageData, jsonData: map);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getTrayDataList(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetTrayData, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is List<dynamic>) {
          var dataList = map['data'] as List<dynamic>;
          var items = <TrayDataModel>[];
          dataList.forEach((element) {
            items.add(TrayDataModel.fromJson(element));
          });
          response.dataModal = items;
          responseHandler(Result.success(response), isSuccess);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getCategoryList(int pageNum, BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
      "{PAGE_NUM}": '$pageNum'
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetCategoryData, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = CategoryDataModel.fromJson(map["data"]);
          // CacheDataManager.cacheData(key: StringConstant.kCategoryList, jsonData: map);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getCategoryWiseDetails(String categoryId, int pageNum,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
      "{CATEGORY_ID}": '$categoryId',
      "{PAGE_NUM}": '$pageNum'
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetCategoryDetails, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = HomePageDataModel.fromJson(map["data"]);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getMoreLikeThisData(String videoId, BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{VIDEO_ID}": '$videoId',
      "{APP_ID}": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetMoreLikeThis, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = HomePageDataModel.fromJson(map["data"]);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getAppConfiguration(BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };

    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetAppConfig, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = AppConfigModel.fromJson(map["data"]);
          CacheDataManager.cacheData(key: StringConstant.kAppConfig, jsonData: map);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getNotification(int pageNum, BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
      // "{APP_ID}": '7a72f14a-314c-4038-a7ec-b36e64f1ebd1',
      "{USER_ID}": "203d96e8-11c1-422e-8453-199de344687a",
      "{PAGE_NUM}": '$pageNum'
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetNotification, RequestType.get);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = NotificationModel.fromJson(map["data"]);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getSearchApiData(String search, int pageNum,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    AppNetwork appNetwork = AppNetwork();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "x-access-token": sharedPreferences.get("token") as String,
      "Content-Type": "application/json"
    };
    Map<String, String> urlParams = {
      '{SEARCH_QUERY}': search,
      "{PAGE_NUM}": '$pageNum',
      "{APP_ID}": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetSearchData, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = SearchDataModel.fromJson(map["data"]);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getAppMenu(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
      "{DEVICE_TYPE}": 'android',
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetAppMenu, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = AppMenuModel.fromJson(map["data"]);
          CacheDataManager.cacheData(
              key: StringConstant.kAppMenu, jsonData: map);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getNotificationCount(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
      "{USER_ID}": sharedPreferences.get("userId").toString()
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetNotificationCount, RequestType.get);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = ItemCountModel.fromJson(map["data"]);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<ASRequestModal?> openWebUrl(BuildContext context, String query) async {
    ASRequestConstructor requestConstructor = ASRequestConstructor();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
      "{QUERY}": query
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kOpenWebViewUrl, RequestType.get);
    requestConstructor.processRequestFor(requestModal, (result, isSuccess) {});
    return requestModal;
  }
}
