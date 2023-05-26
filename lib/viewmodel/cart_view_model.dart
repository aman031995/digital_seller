import 'dart:convert';

import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/model/data/checkout_data_model.dart';
import 'package:TychoStream/model/data/create_order_model.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/model/data/promocode_data_model.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/CartDetalRepository.dart';
import 'package:TychoStream/repository/razorpay_services.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_web/razorpay_web.dart';

import '../view/Products/thankyou_page.dart';

class CartViewModel extends ChangeNotifier {
  final _cartRepo = CartDetailRepository();

  CartListDataModel? _cartListDataModel;

  CartListDataModel? get cartListData => _cartListDataModel;

  ItemCountModel? _itemCountModel;

  ItemCountModel? get itemCountModel => _itemCountModel;

  ProductList? _productListDetails;

  ProductList? get productListDetails => _productListDetails;

  ProductListModel? _productListModel;

  ProductListModel? get productListModel => _productListModel;

  List<AddressListModel>? _addressListModel;

  List<AddressListModel>? get addressListModel => _addressListModel;

  PromoCodeDataModel? _promoCodeDataModel;

  PromoCodeDataModel? get promocodeData => _promoCodeDataModel;

  CreateOrderModel? _createOrderModel;

  CreateOrderModel? get createOrderModel => _createOrderModel;

  bool activeQuantity = false;
  bool deactiveQuantity = false;

  String cartItemCount = '0';
  bool isAddedToCart = false;
  AddressListModel? selectedAddress;
  int selectedAddressIndex = 0;
  bool? isThankyouPage = false;
  String selectedColorName = '';
  String selectedSizeName = '';
  bool favouriteCallback = false;

  // GetProductList Method
  Future<void> getProductList(BuildContext context) async {
    _cartRepo.getProductList(context, 1, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        _productListModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

  //getFavList Method
  Future<void> getFavList(BuildContext context) async {
    _cartRepo.getFavoriteList(context, (result, isSuccess) {
      if (isSuccess) {
        _productListModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }

  // GetCartCount Method
  Future<void> getCartCount(BuildContext context) async {
    _cartRepo.getCartCount(context, (result, isSuccess) {
      if (isSuccess) {
        _itemCountModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        cartItemCount = _itemCountModel?.count.toString() ?? '';
        notifyListeners();
      }
    });
  }

  //ADDTOCart Method
  Future<void> addToCart(
      String productId,
      String quantity,
      variantId,
      bool cartDetail,
      BuildContext context,
      NetworkResponseHandler responseHandler) async {
    AppIndicator.loadingIndicator(context);
    _cartRepo.addToCart(productId, quantity, variantId, context,
        (result, isSuccess) {
      if (isSuccess) {
        isAddedToCart = true;
        _itemCountModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        if (cartDetail == true) {
          getCartListData(context);
        }
        responseHandler(Result.success(result), isSuccess);
        updateCartCount(context, _itemCountModel?.count.toString() ?? '');
        isAddedToCart = true;
        ToastMessage.message(
            ((result as SuccessState).value as ASResponseModal).message);
        notifyListeners();
      }
    });
  }

  // GetCartListData Method
  Future<void> getCartListData(BuildContext context) async {
    _cartRepo.getCartListData(context, (result, isSuccess) {
      if (isSuccess) {
        _cartListDataModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        deactiveQuantity = false;
        activeQuantity = false;
        notifyListeners();
      }
    });
  }

  // GetProductDetails Method
  Future<void> getProductDetails(BuildContext context, String productId,
      String variantId, String color, String sizeName) async {
    _cartRepo.getProductDetails(context, productId, variantId, color, sizeName,
        (result, isSuccess) {
      if (isSuccess) {
        _productListDetails =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        isAddedToCart =
            _productListDetails?.productDetails?.isAddToCart ?? false;
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }

  //GetProductDetailsFromProduct Method
  Future<void> getProductDetailsFromProduct(
      BuildContext context, ProductList? items) async {
    _productListDetails = items;
    notifyListeners();
  }

  //RemoveProductFromCart Method
  Future<void> removeProductFromCart(
      BuildContext context, varientId, int index) async {
    AppIndicator.loadingIndicator(context);
    _cartRepo.removeItem(varientId, context, (result, isSuccess) {
      if (isSuccess) {
        _itemCountModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        cartListData?.cartList?.removeAt(index);
        getCartListData(context);
        AppIndicator.disposeIndicator();
        updateCartCount(context, _itemCountModel?.count.toString() ?? '');
        ToastMessage.message(((result).value as ASResponseModal).message);
        notifyListeners();
      }
    });
  }

  Future<void> updateCartCount(BuildContext context, String count) async {
    cartItemCount = count;
    notifyListeners();
  }

  Future<void> getCheckOutInfo(
      BuildContext context, CartListDataModel? checkOutData) async {
    _cartListDataModel = checkOutData;
    notifyListeners();
  }

  Future<void> getAddressList(BuildContext context) async {
    _cartRepo.addressList(context, (result, isSuccess) {
      if (isSuccess) {
        _addressListModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  //AddNewAddress Method
  Future<void> addNewAddress(
    BuildContext context,
    String first_name,
    String last_name,
    String email,
    String mobile_number,
    String first_address,
    String second_address,
    int pin_code,
    String city_name,
    String state,
  ) async {
    AppIndicator.loadingIndicator(context);
    _cartRepo.addAddress(
        first_name,
        last_name,
        email,
        mobile_number,
        first_address,
        second_address,
        pin_code,
        city_name,
        state,
        context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        Navigator.pop(context);
        reloadPage();
        // GoRouter.of(context).pushNamed(RoutesName.AddressListPage);
        notifyListeners();
      }
    });
  }

  // UpdateExistingAddress Method
  Future<void> updateExistingAddress(
    BuildContext context,
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
    String country,
  ) async {
    AppIndicator.loadingIndicator(context);
    _cartRepo.updateAddress(
        addressId,
        first_name,
        last_name,
        email,
        mobile_number,
        first_address,
        second_address,
        pin_code,
        city_name,
        state,
        context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        Navigator.pop(context);
        reloadPage();
        notifyListeners();
      }
    });
  }

  // DeleteAddress Method
  Future<void> deleteAddress(BuildContext context, String addressId) async {
    AppIndicator.loadingIndicator(context);
    _cartRepo.deleteAddress(addressId, context, (result, isSuccess) {
      if (isSuccess) {
        ToastMessage.message("adress deleted");
        getAddressList(context);
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }

  // ADDToFavourite Method
  Future<void> addToFavourite(BuildContext context, String productId,
      String variantId, bool fav, String pageName,{int? listIndex}) async {
    AppIndicator.loadingIndicator(context);
    _cartRepo.addToFavourite(productId, variantId, fav, context,
        (result, isSuccess) {
          favouriteCallback = true;
      if (isSuccess) {
        getPageName(context, pageName, result,variantId,listIndex);
        ToastMessage.message(
            ((result as SuccessState).value as ASResponseModal).message);
        notifyListeners();
      }
    });
  }

  thankYouPageImageTimer(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 3000), () {
      isThankyouPage = true;
      notifyListeners();
    });
  }

  Future<void> placeOrder(BuildContext context, String addressId, transactionId,
      orderId, payMethod, payStatus) async {
    _cartRepo.placeYourOrder(
        addressId, transactionId, orderId, payMethod, payStatus, context,
        (result, isSuccess) {
      if (isSuccess) {
        ToastMessage.message(
            ((result as SuccessState).value as ASResponseModal).message);
        GoRouter.of(context).pushNamed(RoutesName.ThankYouPage);
        // AppNavigator.pushNamedAndRemoveUntil(context, RoutesName.thankYouPage, screenName: RouteBuilder.thankYou);
        notifyListeners();
      }
    });
  }

  Future<void> createOrder(BuildContext context, Razorpay razorPay) async {
    AppIndicator.loadingIndicator(context);
    _cartRepo.createOrder(context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        _createOrderModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        RazorpayServices.openPaymentGateway(_createOrderModel, razorPay);
        notifyListeners();
      }
    });
  }

  Future<void> getPromocodeList(BuildContext context) async {
    _cartRepo.getPromoCode(context, (result, isSuccess) {
      if (isSuccess) {
        _promoCodeDataModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

  void paymentCallbackHandling(CartViewModel? cartModel, Razorpay _razorPay,
      addressId, BuildContext context) {
    if (cartModel != null) {
      // handling when payment success
      _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse successResponse) {
        print(successResponse);
        paymentResponse(
            context,
            cartModel.createOrderModel?.receipt ?? '',
            successResponse.orderId,
            successResponse.paymentId,
            'Success',
            '',
            addressId);
        GoRouter.of(context).pushNamed(RoutesName.ThankYouPage);
        placeOrder(context, addressId, successResponse.paymentId,
            successResponse.orderId, 'Online', 'Success');
        // Navigator.pushNamed(context, RoutesName.ThankYouPage);
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        //     ThankYouPage()), (Route<dynamic> route) => false);
      //  Navigator.pushAndRemoveUntil(context, ThankYouPage, (route) => false);
       // AppNavigator.pushNamedAndRemoveUntil(context, RoutesName.thankYouPage);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(StringConstant.paymentSuccessful)));
      });

      // handling when payment fails
      _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
          (PaymentFailureResponse failureResponse) {
        // Map? error = failureResponse.message;
        // String failedResponse = jsonEncode(error);
        // print(failureResponse.message);
        // paymentResponse(
        //     context,
        //     cartModel.createOrderModel?.receipt ?? '',
        //     failureResponse.error?['metadata']['order_id'],
        //     failureResponse.error?['metadata']['payment_id'],
        //     'Failed',
        //     failedResponse,
        //     addressId);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureResponse.message ?? '')));
      });

      // handling when external wallet is selected
      _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET,
          (ExternalWalletResponse walletResponse) {
        print(walletResponse.walletName);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(walletResponse.walletName ?? '')));
      });
    }
  }

  Future<void> paymentResponse(BuildContext context, String receiptId, orderId,
      transactionId, paymentStatus, failedResponse, String addressId) async {
    _cartRepo.paymentResponse(context, receiptId, orderId, transactionId,
        paymentStatus, failedResponse, (result, isSuccess) {
      if (isSuccess) {
        notifyListeners();
      }
    });
  }

  updatecolorName(BuildContext context,String name) {
    selectedColorName = name;
    notifyListeners();
  }

  updatesizeName(BuildContext context,String name) {
    selectedSizeName = name;
    notifyListeners();
  }

  getPageName(BuildContext context, String name, Result result, String variantId, int? listIndex) {
    switch (name) {
      case 'productList':
        getProductList(context);
        break;
      case 'productDetail':
        _productListDetails =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        break;
      case 'favouriteList':
        getFavList(context);
        break;
      case 'favouriteDetail':
        _productListDetails =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        break;
      case 'cartDetail':
        removeProductFromCart(context, variantId, listIndex ?? 0);
    }
  }
}
