import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/model/data/CartDetailModel.dart';
import 'package:TychoStream/model/data/checkoutDataModel.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/ASRequestModal.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';

class CartDetailRepository {
  Future<Result?> getProductList(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{USER_ID}": sharedPreferences.get("userId").toString(),
      "{APP_ID}": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetProductList, RequestType.get);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = ProductListModel.fromJson(map["data"]);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> cartDetail(String productId, String quantity,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "productId": productId,
      "quantity": quantity,
      "appId": NetworkConstants.kAppID,
      "userId": sharedPreferences.get("userId").toString()
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kCartDetail, RequestType.post,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = ItemCountModel.fromJson(map['data']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        return responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getCartListData(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{USER_ID}": sharedPreferences.get("userId").toString(),
      "{APP_ID}": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetCartList, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = CartListDataModel.fromJson(map["data"]);
          // CacheDataManager.cacheData(key: StringConstant.kHomePageData, jsonData: map);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getProductDetails(BuildContext context, String productId,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{USER_ID}": sharedPreferences.get("userId").toString(),
      "{PRODUCT_ID}": productId,
      "{APP_ID}": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetProductById, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = ProductList.fromJson(map['data']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> removeItem(String productId, BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString(),
    };
    var inputParams = {
      "productId": productId,
      "appId": NetworkConstants.kAppID,
      "userId": sharedPreferences.get("userId").toString()
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.removeFromCart, RequestType.delete,
        context: context, headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
            (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = ItemCountModel.fromJson(map['data']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getCartCount(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
      "{USER_ID}": sharedPreferences.get("userId").toString()
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.getCartCount, RequestType.get);
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

  // Future<Result?> getCheckoutData(
  //     BuildContext context, NetworkResponseHandler responseHandler) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   AppNetwork appNetwork = AppNetwork();
  //   Map<String, String> urlParams = {
  //     "{APP_ID}": NetworkConstants.kAppID",
  //     "{USER_ID}": sharedPreferences.get("userId").toString()
  //   };
  //   ASRequestModal requestModal = ASRequestModal.withUrlParams(
  //       urlParams, NetworkConstants.getCheckOutData, RequestType.get);
  //   appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
  //     if (isSuccess) {
  //       var response = ASResponseModal.fromResult(result);
  //       Map<String, dynamic> map =
  //           (result as SuccessState).value as Map<String, dynamic>;
  //       if (map["data"] is Map<String, dynamic>) {
  //         response.dataModal = CheckOutDataModel.fromJson(map["data"]);
  //       }
  //       responseHandler(Result.success(response), isSuccess);
  //     } else {
  //       responseHandler(result, isSuccess);
  //     }
  //   });
  // }

  Future<Result?> addAddress(
      String first_name,
      String last_name,
      String email,
      String mobile_number,
      String first_address,
      String second_address,
      int pin_code,
      String city_name,
      String state,
      String country, BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "appId": NetworkConstants.kAppID,
      "userId": sharedPreferences.get("userId").toString(),
      "firstName": first_name,
      "lastName": last_name,
      "email": email,
      "mobile_number": mobile_number,
      "firstAddress": first_address,
      "secondAddress": second_address,
      "pincode": '$pin_code',
      "cityName": city_name,
      "state": state,
      "country": country
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.addNewAddress, RequestType.post,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = ItemCountModel.fromJson(map['data']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        return responseHandler(result, isSuccess);
      }
    });
  }


  Future<Result?> updateAddress(
      String addressId,
      String first_name,
      String last_name,
      String email,
      String mobile_number,
      String first_address,
      String second_address,
      String pin_code,
      String city_name,
      String state,
      String country, BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "addressId": addressId,
      "userId": sharedPreferences.get("userId").toString(),
      "firstName": first_name,
      "lastName": last_name,
      "email": email,
      "mobileNumber": mobile_number,
      "firstAddress": first_address,
      "secondAddress": second_address,
      "pincode": pin_code,
      "cityName": city_name,
      "state": state,
      "country": country,
      "appId": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.updateAddress, RequestType.put,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = ItemCountModel.fromJson(map['data']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        return responseHandler(result, isSuccess);
      }
    });
  }
}
