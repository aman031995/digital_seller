import 'package:flutter/material.dart';
import 'package:TychoStream/model/data/UserInfoModel.dart';
import 'package:TychoStream/network/ASRequestModal.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/utilities/AppToast.dart';

class SocialLoginProvider{
  Future<Result>? loginUpdate(String userId, String userEmail, String phone,
      BuildContext context, NetworkResponseHandler responseHandler) {
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "userId": userId,
      "email": userEmail,
      "phone": phone,
      "appId": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kSocialUpdate, RequestType.put,
        context: context, modalClass: "ABC");
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
        //ToastMessage.message(response['message']);
      }
    });
  }

  Future<Result>? loginWithSocialMedia(
      String socialId,
      String accessTokenLogin,
      String provider,
      String deviceToken,
      String userEmail,
      String userName,
      String profilePic,
      BuildContext context,
      NetworkResponseHandler responseHandler) {
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "socialId": socialId,
      "social_token": accessTokenLogin,
      "provider": provider,
      "user_device_id": "",
      "login_type": "",
      "deviceToken": deviceToken,
      "userEmail": userEmail,
      "name": userName,
      "profilePic": profilePic,
      "appId": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
      inputParams,
      NetworkConstants.kUserSocialLogin,
      RequestType.post,
      context: context,
      modalClass: "ABC",
    );
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
        responseHandler(result, false);
      }
    });
  }
}