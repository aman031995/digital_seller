import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/model/data/TermsPrivacyModel.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/ASRequestModal.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/AppNetwork.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/network/NetworkConstants.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';

class ProfileRepository {
  Future<Result?> getTermsPrivacy(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {};
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetAllPages, RequestType.get);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map = (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is List<dynamic>) {
          var dataList = map['data'] as List<dynamic>;
          var items = <TermsPrivacyModel>[];
          dataList.forEach((element) {
            items.add(TermsPrivacyModel.fromJson(element));
          });
          response.dataModal = items;
          // CacheDataManager.cacheData(key: StringConstant.kPrivacyTerms, jsonData: map);
          responseHandler(Result.success(response), isSuccess);
        }
      } else {
        var response = (result as SuccessState).value;
        ToastMessage.message(response['message']);
      }
    });
  }

  Future<Result?> uploadImage(List<String> imagePath, BuildContext buildContext,
      NetworkResponseHandler networkResponseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId = '';
    userId = sharedPreferences.get("userId").toString();
    AppNetwork appNetwork = AppNetwork();
    var header = {
      "Authorization": "Basic " + sharedPreferences.get("token").toString()
    };
    var inputParams = {"userId": userId};
    ASRequestModal requestModal = ASRequestModal.withInputParams(inputParams,
        NetworkConstants.kUploadProfilePic, RequestType.multipartPost,
        context: buildContext, headers: header);
    requestModal.addFileUploadRequestWithPathString(imagePath, key: 'file');
    appNetwork.getNetworkResponse(requestModal, buildContext,
        (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = UserInfoModel.fromJson(map['data']);
        }
        networkResponseHandler(Result.success(response), isSuccess);
      }
    });
  }

  Future<Result?> getUserProfileDetails(BuildContext buildContext,
      NetworkResponseHandler networkResponseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var header = {
      "Authorization": "Basic " + sharedPreferences.get("token").toString()
    };
    var inputParams = {"{USER_ID}": sharedPreferences.get("userId").toString()};
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        inputParams, NetworkConstants.getUserDetails, RequestType.get,
        context: buildContext, headers: header);
    appNetwork.getNetworkResponse(requestModal, buildContext,
        (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = UserInfoModel.fromJson(map['data']);
          // CacheDataManager.cacheData(key: StringConstant.kUserDetails, jsonData: map);
        }
        networkResponseHandler(Result.success(response), isSuccess);
      }
    });
  }

  Future<Result?> editProfile(String name, String phone, String address,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString(),
      'Content-Type': 'application/json'
    };
    var inputParams = {
      "userId": sharedPreferences.get("userId").toString(),
      "name": name,
      "phone": phone,
      "address": address,
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kUpdateProfile, RequestType.put,
        context: context, modalClass: "ABC", headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = UserInfoModel.fromJson(map['data']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        var response = (result as SuccessState).value;
        ToastMessage.message(response['message']);
      }
    });
  }

  Future<Result?> deleteUserAccount(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString(),
    };
    var inputParams = {"{USER_ID}": sharedPreferences.get("userId").toString()};
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        inputParams, NetworkConstants.kDeleteProfile, RequestType.delete,
        context: context, headers: header);
    appNetwork.getNetworkResponse(requestModal, context,(result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        response.dataModal =
        ((result as SuccessState).value as Map<String, dynamic>)['data'];
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }
}
