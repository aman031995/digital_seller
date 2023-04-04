import 'dart:convert';
import 'dart:html';
import 'package:TychoStream/network/result.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/model/data/TermsPrivacyModel.dart';
import 'package:TychoStream/model/data/UserInfoModel.dart';
import 'package:TychoStream/network/ASRequestModal.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/CacheDataManager.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
class ProfileRepository {
  Future<Result?> getTermsPrivacy(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {"appId": NetworkConstants.kAppID};
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
          CacheDataManager.cacheData(key: StringConstant.kPrivacyTerms, jsonData: map, isCacheRemove: true);
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
    var inputParams = {"userId": userId,"appId": NetworkConstants.kAppID};
    ASRequestModal requestModal = ASRequestModal.withInputParams(inputParams,
        NetworkConstants.kUploadProfilePic, RequestType.multipartPost,
        context: buildContext, headers: header);
    requestModal.addFileUploadRequestWithPathString(imagePath, key: 'file');
    appNetwork.getNetworkResponse(requestModal, buildContext, (result, isSuccess) {
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
    var inputParams = {"{USER_ID}": sharedPreferences.get("userId").toString(),"{APP_ID}": NetworkConstants.kAppID,};
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
              CacheDataManager.cacheData(key: StringConstant.kUserDetails, jsonData: map, isCacheRemove: true);
            }
            networkResponseHandler(Result.success(response), isSuccess);
          }
        });
  }

  Future<Result?> editProfile(String name, String phone, String address, String email,
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
      "email": email,
      "address": address, "appId": NetworkConstants.kAppID,
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
          CacheDataManager.clearCachedData(key: StringConstant.kUserDetails);
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
    var inputParams = {"{USER_ID}": sharedPreferences.get("userId").toString(),"{APP_ID}": NetworkConstants.kAppID};
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

  Future<dynamic> uploadProfile(BuildContext context, FileReader reader, File file, ApiCallback responseData) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = '${NetworkConstants.kAppBaseUrl + NetworkConstants.kUploadProfilePic}';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = "Basic " + sharedPreferences.get("token").toString();
    request.fields['userId'] = sharedPreferences.get("userId").toString();;
    reader.onLoadEnd.listen((e) {
      var bytes = reader.result as List<int>;
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: file.name));
      request.send().then((response) async{
        if (response.statusCode == 200) {
          String responseBody = await response.stream.transform(utf8.decoder).join();
          var map = jsonDecode(responseBody);
          responseData(map['data']);

        } else {
          print('Image upload failed with status code ${response.statusCode}.');
        }
      });
    });
  }


  Future<Result?> contactUsApi(BuildContext context, String name, String email,
      String query, NetworkResponseHandler responseHandler) async {
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "appId": "b07e2bbc-3ad9-441f-86fe-59caff940d1d",
      "name": name,
      "email": email,
      "query": query
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kContactUs, RequestType.post,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
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