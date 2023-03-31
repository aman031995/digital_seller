/*
  By Aman Singh
 */

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/model/data/AppConfigModel.dart';
import 'package:tycho_streams/model/data/BannerDataModel.dart';
import 'package:tycho_streams/model/data/CategoryDataModel.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/model/data/TrayDataModel.dart';
import 'package:tycho_streams/model/data/app_menu_model.dart';
import 'package:tycho_streams/model/data/notification_model.dart';
import 'package:tycho_streams/model/data/search_data_model.dart';
import 'package:tycho_streams/network/ASRequestModal.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/AppNetwork.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/network/NetworkConstants.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';

class HomePageRepository {
  Future<Result?> getBannerData(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      //"Authorization": "Bearer " +"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI4OGI0YTJmZC1kMjk5LTQyNjItODU4Yi0zOGQ1N2I1YTE2MmQiLCJpYXQiOjE2Nzk1NzgwMDQsImV4cCI6MTY4MDg3NDAwNH0.ubqJo3I8UMhiByZvGw88NKwMyi30zfC1lb9PCNFs4WU"
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {"{APP_ID}": "ID-e2946157-ebc3-4ba"};
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetBannerList, RequestType.get,
       );
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
      "{APP_ID}": "b07e2bbc-3ad9-441f-86fe-59caff940d1d",
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
  // Future<Result?> getHomePageData(int videoFor, int pageNum,
  //     BuildContext context, NetworkResponseHandler responseHandler) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var header = {
  //     "Authorization": "Bearer " + sharedPreferences.get("token").toString()
  //   };
  //   AppNetwork appNetwork = AppNetwork();
  //   Map<String, String> urlParams = {
  //     "{USER_ID}": sharedPreferences.get("userId").toString(),
  //     "{APP_ID}": "b07e2bbc-3ad9-441f-86fe-59caff940d1d",
  //     "{VIDEO_FOR}": '$videoFor',
  //     "{PAGE_NUM}": '$pageNum',
  //   };
  //   ASRequestModal requestModal = ASRequestModal.withUrlParams(
  //       urlParams, NetworkConstants.kGetHomePageData, RequestType.get,
  //       headers: header);
  //   appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
  //     if (isSuccess) {
  //       var response = ASResponseModal.fromResult(result);
  //       Map<String, dynamic> map =
  //       (result as SuccessState).value as Map<String, dynamic>;
  //       if (map["data"] is Map<String, dynamic>) {
  //         response.dataModal = HomePageDataModel.fromJson(map["data"]);
  //         // CacheDataManager.cacheData(key: StringConstant.kHomePageData, jsonData: map);
  //       }
  //       responseHandler(Result.success(response), isSuccess);
  //     } else {
  //       responseHandler(result, isSuccess);
  //     }
  //   });
  // }

  Future<Result?> getTrayDataList(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      // "Authorization": "Bearer " + sharedPreferences.get("token").toString() ?? ''
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {"{APP_ID}": "ID-e2946157-ebc3-4ba"};
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetTrayData, RequestType.get,
       );
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map = (result as SuccessState).value as Map<String, dynamic>;
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
      "{APP_ID}": "ID-e2946157-ebc3-4ba",
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
      "{APP_ID}": "ID-e2946157-ebc3-4ba",
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
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kgetMoreLikeThis, RequestType.get,
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

  Future<Result?> getAppConfiguration(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };

    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": 'b07e2bbc-3ad9-441f-86fe-59caff940d1d',
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
          CacheDataManager.cacheData(
              key: StringConstant.kAppConfig, jsonData: map);
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
      "{APP_ID}": '7a72f14a-314c-4038-a7ec-b36e64f1ebd1',
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
      "{PAGE_NUM}": '$pageNum'
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
      "{APP_ID}": 'b07e2bbc-3ad9-441f-86fe-59caff940d1d',
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
}


