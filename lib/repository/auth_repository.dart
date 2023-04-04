import 'package:flutter/material.dart';
import 'package:TychoStream/model/data/UserInfoModel.dart';
import 'package:TychoStream/network/ASRequestModal.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';

class AuthRepository {
  Future<Result>? register(
      String phone,
      String email,
      BuildContext context,
      NetworkResponseHandler responseHandler) {
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "phone": phone,
      "email": email,
      "appId": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kCheckUserAlreadyRegister, RequestType.post,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map = (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = UserInfoModel.fromJson(map['data']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        return responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result>? registerUser(
      String name,
      String email,
      String phone,
      String password,
      String deviceTokenId,
      BuildContext context,
      NetworkResponseHandler responseHandler) {
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "appId": NetworkConstants.kAppID,
      "userDeviceId": "",
      "userFirebaseId": deviceTokenId
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kUserRegister, RequestType.post,
        context: context, modalClass: "ABC");

    appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map = (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = UserInfoModel.fromJson(map['data']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        return responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result>? login(String phone, String password, String deviceTokenId, BuildContext context,
      NetworkResponseHandler responseHandler) {
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "phone": phone,
      "password": password,
      "appId": NetworkConstants.kAppID,
      "userDeviceId": "",
      "userFirebaseId": deviceTokenId
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kLogin, RequestType.post,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = UserInfoModel.fromJson(map['data']);
        } else {
          // Utils.ToastMessage(map['message']);
          print(map['message']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        return responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> verifyOTP(String phone, String otp, String deviceTokenId, BuildContext context,
      NetworkResponseHandler responseHandler) async {
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "phone": phone,
      "otp": otp,
      "appId": NetworkConstants.kAppID,
      "userDeviceId": "",
      "userFirebaseId": deviceTokenId
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kVerifyOtp, RequestType.post,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = UserInfoModel.fromJson(map['data']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

Future<Result?> resendOTP(String phone, BuildContext context,
    NetworkResponseHandler responseHandler) async {
  AppNetwork appNetwork = AppNetwork();
  var inputParams = {
    "phone": phone,
    "appId": NetworkConstants.kAppID,
  };
  ASRequestModal requestModal = ASRequestModal.withInputParams(
      inputParams, NetworkConstants.kResendOtp, RequestType.post,
      context: context, modalClass: "ABC");
  appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
    if (isSuccess) {
      var response = ASResponseModal.fromResult(result);
      Map<String, dynamic> map =
          (result as SuccessState).value as Map<String, dynamic>;
      if (map['data'] is Map<String, dynamic>) {
        response.dataModal = UserInfoModel.fromJson(map['data']);
      }
      responseHandler(Result.success(response), isSuccess);
    } else {
      responseHandler(result, isSuccess);
    }
  });
}

Future<Result?> forgotPassword(String phoneNo,
    BuildContext context, NetworkResponseHandler responseHandler) async {
  AppNetwork appNetwork = AppNetwork();
  var inputParams = {"phone": phoneNo,"appId": NetworkConstants.kAppID,};
  ASRequestModal requestModal = ASRequestModal.withInputParams(
      inputParams, NetworkConstants.kForgotPassword, RequestType.post,
      context: context, modalClass: "ABC");
  appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
    if (isSuccess) {
      var response = ASResponseModal.fromResult(result);
      Map<String, dynamic> map = (result as SuccessState).value as Map<String, dynamic>;
      responseHandler(Result.success(response), isSuccess);
    } else {
      responseHandler(result, isSuccess);
    }
  });
}

Future<Result?> resetPassword(
    String userEmail,
    String newPassword,
    String confirmPassword,
    BuildContext context,
    NetworkResponseHandler responseHandler) async {
  AppNetwork appNetwork = AppNetwork();
  var inputParams = {
    "phone": userEmail,
    "newPassword": newPassword,
    "confirmPassword": confirmPassword,
    "appId": NetworkConstants.kAppID,
  };
  ASRequestModal requestModal = ASRequestModal.withInputParams(
      inputParams, NetworkConstants.kResetPassword, RequestType.post,
      context: context, modalClass: "ABC");
  appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
    if (isSuccess) {
      var response = ASResponseModal.fromResult(result);
      Map<String, dynamic> map =
          (result as SuccessState).value as Map<String, dynamic>;
      if (map['data'] is Map<String, dynamic>) {
        // response.dataModal = UserInfoModel.fromJson(map);
      }
      responseHandler(Result.success(response), isSuccess);
    } else {
      responseHandler(result, isSuccess);
    }
  });
}
}
