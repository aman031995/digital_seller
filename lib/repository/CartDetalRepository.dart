import 'dart:convert';

import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/model/data/category_list_model.dart';
import 'package:TychoStream/model/data/checkout_data_model.dart';
import 'package:TychoStream/model/data/city_state_model.dart';
import 'package:TychoStream/model/data/create_order_model.dart';
import 'package:TychoStream/model/data/offer_discount_model.dart';
import 'package:TychoStream/model/data/promocode_data_model.dart';
import 'package:TychoStream/network/CacheDataManager.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/view/WebScreen/stripepayment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/model/data/category_product_model.dart';
import 'package:TychoStream/network/ASRequestModal.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';
import 'package:http/http.dart' as http;
class CartDetailRepository {

//Get ProductList Method
  Future<Result?> getProductList(
      BuildContext context, pageNum, NetworkResponseHandler responseHandler) async {
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
          CacheDataManager.cacheData(key: StringConstant.kProductList, jsonData: map);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getRecentView(
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
        urlParams, NetworkConstants.KRecentView, RequestType.get,headers:header );
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        if (isSuccess) {
          var response = ASResponseModal.fromResult(result);
          Map<String, dynamic> map =
          (result as SuccessState).value as Map<String, dynamic>;
          if (map['data'] is List<dynamic>) {
            var dataList = map['data'] as List<dynamic>;
            var items = <ProductList>[];
            dataList.forEach((element) {
              items.add(ProductList.fromJson(element));
            });
            response.dataModal = items;
          }
          responseHandler(Result.success(response), isSuccess);
        }
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getRecommendedView(
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {

      "{APP_ID}": NetworkConstants.kAppID,
    };

    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.KRecommended, RequestType.get,headers:header );
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        if (isSuccess) {
          var response = ASResponseModal.fromResult(result);
          Map<String, dynamic> map =
          (result as SuccessState).value as Map<String, dynamic>;
          if (map['data'] is List<dynamic>) {
            var dataList = map['data'] as List<dynamic>;
            var items = <ProductList>[];
            dataList.forEach((element) {
              items.add(ProductList.fromJson(element));
            });
            response.dataModal = items;
            CacheDataManager.cacheData(
                key: StringConstant.kRecommended,
                jsonData: map,
                isCacheRemove: true);
          }
          responseHandler(Result.success(response), isSuccess);
        }
      }

      else {
        responseHandler(result, isSuccess);
      }
    });
  }
  createPaymentIntent(BuildContext context, CreateOrderModel? createOrderModel, String? addressId,
      String productId, String variantId, quantity, String secretKey, NotificationHandler responseHandler, {String? gatewayName}) async{
    try {
      Map<String, dynamic> body = {
        'amount': createOrderModel?.total,
        'currency': "INR",
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          //https://api.stripe.com/v1/checkout/sessions
          body: body,
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      try {
        var paymentIntent = json.decode(response.body);

        //Payment Sheet
        if (paymentIntent != null) {
          final stripe =Stripe("pk_test_51NXhtjSJK48GkIWFjJzBm88uzgrwb7i4aIyls9YoPHT5IvYAV9rMnlEW0U8AUY1VpIJB3ZOBFTFdSFuMYnxM0fkK00KqwNEEeH");
          stripe.redirectToCheckout(CheckoutOptions(
            lineItems: [
              LineItem(
                  price:paymentIntent["id"],
                  quantity:1
              )

            ],
            mode: 'payment',
            successUrl: 'http://localhost:8088/#/success',
          ));

            //Stripe.publishableKey = "pk_live_51NXhtjSJK48GkIWFY3NeBL1mw7CATawc8xbjlwBi5wrTr61UbS9sHQWjnEr5kb9tSytKgZGWsbMkYish4xs2ILIC00OZVlrRNY";

     //
     // await WebStripe.instance.platformPayCreatePaymentMethod(params: params)
       
         // SetupPaymentSheetParameters(
         //          paymentIntentClientSecret: paymentIntent!['client_secret'],
         //          style: ThemeMode.dark,
         //          merchantDisplayName: 'merchant name',
         //          customerId: '1234',
         //          customerEphemeralKeySecret: '1234',
         //          appearance: PaymentSheetAppearance(
         //            colors: PaymentSheetAppearanceColors(
         //              background: Colors.lightBlue,
         //              primary: Colors.blue,
         //              componentBorder: Colors.red,
         //            ),
         //            shapes: PaymentSheetShape(
         //              borderWidth: 4,
         //              shadow: PaymentSheetShadowParams(color: Colors.red),
         //            ),
         //            primaryButton: PaymentSheetPrimaryButtonAppearance(
         //              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
         //              colors: PaymentSheetPrimaryButtonTheme(
         //                light: PaymentSheetPrimaryButtonThemeColors(
         //                  background: Color.fromARGB(255, 231, 235, 30),
         //                  text: Color.fromARGB(255, 235, 92, 30),
         //                  border: Color.fromARGB(255, 235, 92, 30),
         //                ),
         //              ),
         //            ),
         //          ),
         //          billingDetails: BillingDetails(  name: 'Flutter Stripe',
         //            email: 'email@stripe.com',
         //            phone: '+48888000888',
         //            address: Address(
         //              city: 'Houston',
         //              country: 'US',
         //              line1: '1459  Circle Drive',
         //              line2: '',
         //              state: 'Texas',
         //              postalCode: '77063',
         //            ),)));
          responseHandler(paymentIntent);
    // await Stripe.instance.presentPaymentSheet();

          //displayPaymentSheet(paymentIntent, context, createOrderModel, addressId, productId, variantId, quantity);
        }
      } catch (e, s) {
        ToastMessage.message(e.toString(),context);
        print(e);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
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
  Future<Result?> getProductDetails(BuildContext context, String productId,
      NetworkResponseHandler responseHandler,
      {String? colorId, String? sizeName, String? style, String? unitCount, String? materialType}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{USER_ID}": sharedPreferences.get("userId").toString(),
      "{PRODUCT_ID}": productId,
      "{COLOR_ID}": colorId=='null'? "" : colorId ?? "",
      "{STYLE}":style=='null'? "" : style ?? "",
      "{SIZE_NAME}": sizeName=='null'? "" : sizeName ?? "",
      "{MATERIAL_TYPE}" :materialType=='null'? "" : materialType ?? "",
      "{UNIT_COUNT}" : unitCount=='null'? "" : unitCount ?? "",
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
  // addto buy Method
  Future<Result?> buynow(String productId, String quantity,String variantId,
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
        inputParams, NetworkConstants.buynow, RequestType.post,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is Map<String, dynamic>) {
          response.dataModal = CartListDataModel.fromJson(map["data"]);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        return responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getOfferDiscount(BuildContext context, NetworkResponseHandler responseHandler) async {
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {"{APP_ID}" : NetworkConstants.kAppID};
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kDiscountOffer, RequestType.get);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is List<dynamic>) {
          var dataList = map['data'] as List<dynamic>;
          var items = <OfferDiscountModel>[];
          dataList.forEach((element) {
            items.add(OfferDiscountModel.fromJson(element));
          });
          response.dataModal = items;
          responseHandler(Result.success(response), isSuccess);
        }
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }

  Future<Result?> getOfferDiscountList(BuildContext context, String query, int pageNum, String categoryId, NetworkResponseHandler responseHandler) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID,
      "{QUERY}": '$query',
      "{PAGE_NUM}" : '$pageNum',
      "{CATEGORY_ID}" : '$categoryId'
    };

    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kOfferList, RequestType.get);
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


  // GetCartCount Method
  Future<Result?> getCityState(
      BuildContext context,String pincode, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{PINCODE}": pincode,
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kcityState, RequestType.get,headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = CityStateModel.fromJson(map["data"]);
        }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
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


  //getCategoryProductList
  Future<Result?> getCategorySubcategoryProductList(BuildContext context,
      String catId,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Authorization": "Bearer " + sharedPreferences.get("token").toString()
    };
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{USER_ID}": sharedPreferences.get("userId").toString(),
      "{APP_ID}": NetworkConstants.kAppID,
      "{CATEGORY_ID}" : catId,
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kcategoryProduct, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map =
        (result as SuccessState).value as Map<String, dynamic>;
        if (map["data"] is Map<String, dynamic>) {
          response.dataModal = categoryProduct.fromJson(map['data']);

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
      "country": " India",
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
      "variantId":variantId,
      "isLike":fav,
    };
    ASRequestModal requestModal = ASRequestModal.withInputParams(
        inputParams, NetworkConstants.kAddToFavourite, RequestType.post,
        context: context, modalClass: "ABC");
    appNetwork.getNetworkResponse(requestModal,context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
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

  Future<Result?> placeYourOrder(String productId,String variantId,String quantity,
      String addressId, transactionId, orderId, payMethod, payStatus, BuildContext context,
      NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();
    var inputParams = {
      "addressId": addressId,
      "userId": sharedPreferences.get("userId").toString(),
      "appId": NetworkConstants.kAppID,
      "productId": productId,
      "variantId":variantId,
      "quantity" :quantity,
      "transaction_id": transactionId,
      "payment_order_id": orderId==null?'':orderId,
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

  Future<Result?> createOrder(String paymentMethod,String productId,String variantId,String quantity, String? geteway,
      BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppNetwork appNetwork = AppNetwork();

    Map<String, String> inputParam = {
      "userId": sharedPreferences.get("userId").toString(),
      "appId": NetworkConstants.kAppID,
      "productId":productId,
      "variantId":variantId,
      "quantity":quantity,
      "gateway": geteway ?? "",
      "payment_method": paymentMethod
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


  // product category list
  Future<Result?> getProductCategoryList(BuildContext context, NetworkResponseHandler responseHandler) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {"Authorization": "Bearer " + sharedPreferences.get("token").toString()};
    AppNetwork appNetwork = AppNetwork();
    Map<String, String> urlParams = {
      "{APP_ID}": NetworkConstants.kAppID
    };
    ASRequestModal requestModal = ASRequestModal.withUrlParams(
        urlParams, NetworkConstants.kGetAllCategory, RequestType.get,
        headers: header);
    appNetwork.getNetworkResponse(requestModal, context, (result, isSuccess) {
      if (isSuccess) {
        var response = ASResponseModal.fromResult(result);
        Map<String, dynamic> map = (result as SuccessState).value as Map<String, dynamic>;
        if (map['data'] is List<dynamic>) {
          var dataList = map['data'] as List<dynamic>;
          var items = <CategoryListModel>[];
          dataList.forEach((element) {
            items.add(CategoryListModel.fromJson(element));
          });
          response.dataModal = items;
          responseHandler(Result.success(response), isSuccess);
        }
        CacheDataManager.cacheData(
            key: StringConstant.kcategory, jsonData: map, isCacheRemove: true);
        // CacheDataManager.cacheData(
        //     key: StringConstant.kcategory,
        //     jsonData: map,
        //     isCacheRemove: true);
        // if (map["data"] is Map<String, dynamic>) {
        //   response.dataModal = CategoryListModel.fromJson(map["data"]);
        // }
        responseHandler(Result.success(response), isSuccess);
      } else {
        responseHandler(result, isSuccess);
      }
    });
  }



}
