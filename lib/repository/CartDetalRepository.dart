import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/model/data/checkout_data_model.dart';
import 'package:TychoStream/model/data/create_order_model.dart';
import 'package:TychoStream/model/data/promocode_data_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/network/ASRequestModal.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';

class CartDetailRepository {

//Get ProductList Method
  Future<Result?> getProductList(
      BuildContext context,int pageNum, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{USER_ID}": sharedPreferences.get("userId").toString(),
      "{PAGE_NUM}": '$pageNum',
      "{APP_ID}": NetworkConstants.kAppID,
    };

    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetProductList, RequestType.get,headers:header );
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

  // GetCartDetail Method
  Future<Result?> addToCart(String productId, String quantity,String variantId,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "productId": productId,
      "quantity": quantity,
      "appId": NetworkConstants.kAppID,
      "variantId": variantId,
      "userId": sharedPreferences.get("userId").toString()
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kAddToCart, RequestType.post,
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
  // GetProductDetails Method
  Future<Result?> getProductByCategory(BuildContext context,
      String productId,
      String catId,
      int pageNum,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{PROD_ID}": productId,
      "{APP_ID}": NetworkConstants.kAppID,
      "{CAT_ID}" : catId,
      "{PAGE_NUM}" : '$pageNum',
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetProductByCategory, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          if(productId != ""){
            response.dataModal = ProductList.fromJson(map['data']);
          } else {
            response.dataModal = ProductListModel.fromJson(map['data']);
          }
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }


  // GetCartList Method
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

  // GetProductDetails Method
  Future<Result?> getProductDetails(BuildContext context,
      String productId,
      String variantId,
      String color,
      String sizeName,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{USER_ID}": sharedPreferences.get("userId").toString(),
      "{PRODUCT_ID}": productId,
      "{VARIANT_ID}": variantId,
      "{COLOR_ID}": color,
      "{SIZE_NAME}": sizeName,
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


  //RemoveItems Method
  Future<Result?> removeItem(String variantId, BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString(),
    };
    var inputParams = {
      "variantId": variantId,
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

  // GetCartCount Method
  Future<Result?> getCartCount(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
      "{USER_ID}": sharedPreferences.get("userId").toString()
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.getCartCount, RequestType.get,headers: header);
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


  // AddAddress Method
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
      BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "appId": NetworkConstants.kAppID,
      "userId": sharedPreferences.get("userId").toString(),
      "firstName": first_name,
      "lastName": last_name,
      "email": email,
      "mobileNumber": mobile_number,
      "firstAddress": first_address,
      "secondAddress": second_address,
      "pincode": '$pin_code',
      "cityName": city_name,
      "state": state,
      "country": "INDIA"
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

  // Update Address
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
      BuildContext context,
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
      "country": " ",
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

  // AddToFavorite Method
  Future<Result?> addToFavourite(
      String productId,String variantId,bool fav,
      BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "appId": NetworkConstants.kAppID,
      "userId": sharedPreferences.get("userId").toString(),
      "productId": productId,
      "colorName":variantId,
      "isLike":fav,
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kAddToFavourite, RequestType.post,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = ProductList.fromJson(map['data']);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        return responseHandler(result, isSuccess);
      }
    });
  }

  // DeleteAddress Method
  Future<Result?> deleteAddress( String addressId,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString(),
    };
    var inputParams = {
      "addressId": addressId,
      "userId": sharedPreferences.get("userId").toString(),
      "appId": NetworkConstants.kAppID,
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.deleteAddress, RequestType.delete,
        context: context, headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        response.dataModal = ((result as SuccessState).value as Map<String, dynamic>)['data'];
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }


  Future<Result?> addressList(BuildContext context,
      NetworkResponseHandler responseHandler) async {
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
        urlParams, NetworkConstants.kgetAllAddress, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is List<dynamic>) {
          var dataList = map['data'] as List<dynamic>;
          var items = <AddressListModel>[];
          dataList.forEach((element) {
            items.add(AddressListModel.fromJson(element));
          });
          response.dataModal = items;
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> placeYourOrder(
      String addressId, transactionId, orderId, payMethod, payStatus, BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "addressId": addressId,
      "userId": sharedPreferences.get("userId").toString(),
      "appId": NetworkConstants.kAppID,
      "transaction_id": transactionId,
      "payment_order_id": orderId,
      "payment_method": payMethod,
      "payment_status": payStatus
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.placeOrder, RequestType.post,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        responseHandler(Result.success(response), isSuccess);
      } else {
        return responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getFavoriteList(
      BuildContext context, int pageNum, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{USER_ID}": sharedPreferences.get("userId").toString(),
      "{APP_ID}": NetworkConstants.kAppID,
      "{PAGE_NUM}": '$pageNum',
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.KGetFavourite, RequestType.get);
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

  Future<Result?> createOrder(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();

    Map<String, String> inputParam = {
      "userId": sharedPreferences.get("userId").toString(),
      "appId": NetworkConstants.kAppID,
      "gateway": "razorpay",
      "payment_method": "online"
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(inputParam, NetworkConstants.kCreateOrder, RequestType.post);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map = (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = CreateOrderModel.fromJson(map["data"]);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> paymentResponse(
      BuildContext context, receiptId, orderId, transactionId, paymentStatus, failedResponse,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> inputParam = {
      "userId" : sharedPreferences.get("userId").toString(),
      "appId" : NetworkConstants.kAppID,
      "receipt" : receiptId,
      "payment_order_id" : orderId,
      "transaction_id" : transactionId,
      "payment_status" : paymentStatus,
      "failed_response": failedResponse
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(inputParam,
        NetworkConstants.kPaymentResponse, RequestType.post);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getPromoCode(
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
        urlParams, NetworkConstants.kGetPromocode, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map = (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = PromoCodeDataModel.fromJson(map["data"]);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

}