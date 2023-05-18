import 'package:flutter/material.dart';
import 'package:TychoStream/model/data/UserInfoModel.dart';
import 'package:TychoStream/network/ASRequestModal.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  // registration request api
  Future<Result?> register(
      String phone,
      String email,
      String loginType,
      BuildContext context,
      NetworkResponseHandler responseHandler) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "phone": phone,
      "email": email,
      "loginType":loginType,
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
  // user registration request api
  Future<Result?> registerUser(
      String name,
      String email,
      String phone,
      String password,
      String deviceId,
      String deviceTokenId,
      BuildContext context,
      NetworkResponseHandler responseHandler) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "appId": NetworkConstants.kAppID,
      "userDeviceId": deviceId,
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

  // login request api
  Future<Result?> login(String phone, String password, String deviceId, String firebaseId,String loginType, BuildContext context,
      NetworkResponseHandler responseHandler) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "phone": phone,
      "password": password,
      "appId": NetworkConstants.kAppID,
      "loginType": loginType,
      "userDeviceId": deviceId,
      "userFirebaseId": firebaseId
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
          print(map['message']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        return responseHandler(result, isSuccess);
      }
    });
  }
  // otp verify request api
  Future<Result?> verifyOTP(String phone, String otp, String deviceId, String firebaseId, BuildContext context,
      NetworkResponseHandler responseHandler,{String? loginType}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "phone": phone,
      "otp": otp,
      "appId": NetworkConstants.kAppID,
      "userDeviceId": deviceId,
      "userFirebaseId": firebaseId
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

  // Future<Result?> verifyOTP(String phone, String otp, String deviceTokenId, BuildContext context,
  //     NetworkResponseHandler responseHandler) async {
  //   AppNetwork appNetwork = AppNetwork();
  //   var inputParams = {
  //     "phone": phone,
  //     "otp": otp,
  //     "appId": NetworkConstants.kAppID,
  //     "userDeviceId": "",
  //     "userFirebaseId": deviceTokenId
  //   };
  //   ASRequestModal requestModal = ASRequestModal.withInputParams(
  //       inputParams, NetworkConstants.kVerifyOtp, RequestType.post,
  //       context: context, modalClass: "ABC");
  //   appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
  //     if (isSuccess) {
  //       var response = ASResponseModal.fromResult(result);
  //       Map<String, dynamic> map =
  //           (result as SuccessState).value as Map<String, dynamic>;
  //       if (map['data'] is Map<String, dynamic>) {
  //         response.dataModal = UserInfoModel.fromJson(map['data']);
  //       }
  //       responseHandler(Result.success(response), isSuccess);
  //     } else {
  //       responseHandler(result, isSuccess);
  //     }
  //   });
  // }

  // otp resend request api
  Future<Result?> resendOTP(String phone, String otpFor,BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "phone": phone,
      "otp_for": otpFor,
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
// forgot password request api
  Future<Result?> forgotPassword(String phoneNo,String loginType,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    AppNetwork appNetwork = AppNetwork();
    var inputParams = {"phone": phoneNo,"loginType": loginType,"appId": NetworkConstants.kAppID,};
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

// reset password request api
  Future<Result?> resetPassword(
      String userEmail,
      String newPassword,
      String confirmPassword,
      String loginType,
      BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "phone": userEmail,
      "newPassword": newPassword,
      "loginType": loginType,
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
