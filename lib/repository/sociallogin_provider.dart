import 'package:flutter/material.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/ASRequestModal.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/AppNetwork.dart';
import 'package:tycho_streams/network/NetworkConstants.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/utilities/AppToast.dart';

class SocialLoginProvider{

  Future<Result>? loginUpdate(String userId, String userEmail, String phone,
      BuildContext context, NetworkResponseHandler responseHandler) {
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "userId": userId,
      "email": userEmail,
      "phone": phone
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
        ToastMessage.message(response['message']);
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