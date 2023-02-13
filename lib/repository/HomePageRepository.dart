/*
  By Aman Singh
 */

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/model/data/BannerDataModel.dart';
import 'package:tycho_streams/model/data/CategoryDataModel.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/model/data/TrayDataModel.dart';
import 'package:tycho_streams/network/ASRequestModal.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/AppNetwork.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/network/NetworkConstants.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';

class HomePageRepository {
  Future<Result?> getBannerData(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDRjYWQxYy0xMzNmLTQyNGMtYWM0NS02M2VhZmM2MTVmZTgiLCJpYXQiOjE2NzYwMTU0ODYsImV4cCI6MTY3NzMxMTQ4Nn0.PyM-YFy2nB2Ni3UWyyiW8Nh8J7tu3y18sfuPwqRoB88"
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {"{APP_ID}": "ID-e2946157-ebc3-4ba"};
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

  Future<Result?> getHomePageData(int videoFor, int pageNum,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDRjYWQxYy0xMzNmLTQyNGMtYWM0NS02M2VhZmM2MTVmZTgiLCJpYXQiOjE2NzYwMTU0ODYsImV4cCI6MTY3NzMxMTQ4Nn0.PyM-YFy2nB2Ni3UWyyiW8Nh8J7tu3y18sfuPwqRoB88"
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{USER_ID}" : sharedPreferences.get("userId").toString(),
      "{APP_ID}": "ID-e2946157-ebc3-4ba",
      "{VIDEO_FOR}" : '$videoFor',
      "{PAGE_NUM}" : '$pageNum'
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
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDRjYWQxYy0xMzNmLTQyNGMtYWM0NS02M2VhZmM2MTVmZTgiLCJpYXQiOjE2NzYwMTU0ODYsImV4cCI6MTY3NzMxMTQ4Nn0.PyM-YFy2nB2Ni3UWyyiW8Nh8J7tu3y18sfuPwqRoB88"
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": "ID-e2946157-ebc3-4ba",
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

  Future<Result?> getCategoryList(int pageNum,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDRjYWQxYy0xMzNmLTQyNGMtYWM0NS02M2VhZmM2MTVmZTgiLCJpYXQiOjE2NzYwMTU0ODYsImV4cCI6MTY3NzMxMTQ4Nn0.PyM-YFy2nB2Ni3UWyyiW8Nh8J7tu3y18sfuPwqRoB88"
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": "ID-e2946157-ebc3-4ba",
      "{PAGE_NUM}" : '$pageNum'
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
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDRjYWQxYy0xMzNmLTQyNGMtYWM0NS02M2VhZmM2MTVmZTgiLCJpYXQiOjE2NzYwMTU0ODYsImV4cCI6MTY3NzMxMTQ4Nn0.PyM-YFy2nB2Ni3UWyyiW8Nh8J7tu3y18sfuPwqRoB88"
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": "ID-e2946157-ebc3-4ba",
      "{CATEGORY_ID}" : '$categoryId',
      "{PAGE_NUM}" : '$pageNum'
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

  Future<Result?> getMoreLikeThisData(String videoId,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDRjYWQxYy0xMzNmLTQyNGMtYWM0NS02M2VhZmM2MTVmZTgiLCJpYXQiOjE2NzYwMTU0ODYsImV4cCI6MTY3NzMxMTQ4Nn0.PyM-YFy2nB2Ni3UWyyiW8Nh8J7tu3y18sfuPwqRoB88"
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{VIDEO_ID}" : '$videoId',
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
}
