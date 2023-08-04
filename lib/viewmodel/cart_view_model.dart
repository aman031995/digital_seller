import 'dart:convert';

import 'package:TychoStream/local_storage.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/model/data/checkout_data_model.dart';
import 'package:TychoStream/model/data/city_state_model.dart';
import 'package:TychoStream/model/data/create_order_model.dart';
import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/model/data/promocode_data_model.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/CacheDataManager.dart';
import 'package:TychoStream/network/NetworkApiServices.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/CartDetalRepository.dart';
import 'package:TychoStream/repository/razorpay_services.dart';
import 'package:TychoStream/session_storage.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_cache/json_cache.dart';
import 'package:razorpay_web/razorpay_web.dart';

import '../AppRouter.gr.dart';
import '../model/data/category_list_model.dart';

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

  ProductListModel? _newProductListModel;
  ProductListModel? get newProductListModel => _newProductListModel;

  List<ProductList>? _recentView;
  List<ProductList>? get recentView => _recentView;

  List<ProductList>? _recommendedView;
  List<ProductList>? get recommendedView => _recommendedView;

  List<AddressListModel>? _addressListModel;
  List<AddressListModel>? get addressListModel => _addressListModel;

  PromoCodeDataModel? _promoCodeDataModel;
  PromoCodeDataModel? get promocodeData => _promoCodeDataModel;
  CityStateModel? _cityStateModel;
  CityStateModel? get citystateModel=> _cityStateModel;
  CreateOrderModel? _createOrderModel;
  CreateOrderModel? get createOrderModel => _createOrderModel;
  List<CategoryListModel>? _categoryListModel;
  List<CategoryListModel>? get categoryListModel => _categoryListModel;

  bool activeQuantity = false;
  bool deactiveQuantity = false;

  String cartItemCount = '0';
  bool isAddedToCart = false;
  AddressListModel? selectedAddress;
  int selectedAddressIndex = 0;
  bool? isThankyouPage = false;
  String selectedcolorName = '';
  String selectedSizeName = '';
  String selectedStyleName = '';
  String selectedMaterialName = '';
  String selectedUnitCountName = '';
  String defaultName = '';
  bool favouriteCallback = false;

  int lastPage = 1, nextPage = 1;
  bool isLoading = false;
  bool isSelect = false;
  bool iswishlist = false;
  // get GetProductList from cache api data
  getProductListData(BuildContext context, int pageNum) async{
    final box = await Hive.openBox<String>('appBox');
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    if(await jsonCache.contains(StringConstant.kProductList)){
      CacheDataManager.getCachedData(key: StringConstant.kProductList).then((jsonData) {
        _productListModel = ProductListModel.fromJson(jsonData!['data']);
        print('From Cached AppConfig Data');
        notifyListeners();
      });
    } else {
      getProductList(context, pageNum);
    }
  }
// GetProductList Method
  Future<void> getProductList(BuildContext context, int pageNum) async {
    _cartRepo.getProductList(context, pageNum, (result, isSuccess) {
      if (isSuccess) {
        dataPagination(result);
        isLoading = false;
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }

  //getRecentView
  Future<void> getRecentView(BuildContext context) async{
    _cartRepo.getRecentView(context,(result ,isSuccess ){
      if(isSuccess){
        _recentView=((result as SuccessState).value as ASResponseModal).dataModal;
        // AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }

  // get RecommendedView from cache api data
  getRecommendedViewData(BuildContext context) async {
    final box = await Hive.openBox<String>('appBox');
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    if (await jsonCache.contains(StringConstant.kRecommended)) {
      CacheDataManager.getCachedData(key: StringConstant.kRecommended).then((jsonData) {
        if(jsonData != null){
          if (jsonData['data'] is List<dynamic>) {
            var dataList = jsonData['data'] as List<dynamic>;
            var items = <ProductList>[];
            dataList.forEach((element) {
              items.add(ProductList.fromJson(element));
            });
            _recommendedView = items;
          }

          print('From Cached UserData');
          notifyListeners();
        }
      });
    } else {
      getRecommendedView(context);
    }
  }
  // getRecommendedView Method
  Future<void> getRecommendedView(BuildContext context) async{
    _cartRepo.getRecommendedView(context,(result ,isSuccess ){
      if(isSuccess){
        _recommendedView=((result as SuccessState).value as ASResponseModal).dataModal;
        // AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }

  // GetProductList By Category Method
  Future<void> getProductListCategory(BuildContext context, String prodId, String categoryId, int pageNum) async {
    _cartRepo.getProductByCategory(context, prodId, categoryId, pageNum, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        if(prodId != ""){
          _productListDetails = ((result as SuccessState).value as ASResponseModal).dataModal;
        } else {
          dataPagination(result);
        }
        notifyListeners();
      }
    });
  }


  // get ProductCategoryLists
  getProductCategoryLists(BuildContext context) async {
    final box = await Hive.openBox<String>('appBox');
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    if (await jsonCache.contains(StringConstant.kcategory)) {
      CacheDataManager.getCachedData(key: StringConstant.kcategory).then((jsonData) {
        if(jsonData != null){
          if (jsonData['data'] is List<dynamic>) {
            var dataList = jsonData['data'] as List<dynamic>;
            var items = <CategoryListModel>[];
            dataList.forEach((element) {
              items.add(CategoryListModel.fromJson(element));
            });
            _categoryListModel = items;
          }

          print('From Cached UserData');
          notifyListeners();
        }
      });
    } else {
      getProductCategoryList(context,1);
    }
  }

  // GetProductCategoryLists By Category Method
  Future<void> getProductCategoryList(BuildContext context, pageNum) async {
    _cartRepo.getProductCategoryList(context, (result, isSuccess) {
      if (isSuccess) {
        _categoryListModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }



  //getFavList Method
  Future<void> getFavList(BuildContext context, int pageNum) async {
    _cartRepo.getFavoriteList(context, pageNum, (result, isSuccess) {
      if (isSuccess) {
        dataPagination(result);
        isLoading = false;
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }

  dataPagination(Result result){
    _newProductListModel = ((result as SuccessState).value as ASResponseModal).dataModal;
    if(_newProductListModel?.pagination?.current == 1){
      lastPage = _newProductListModel?.pagination?.lastPage ?? 1;
      nextPage = _newProductListModel?.pagination?.next ?? 1;
      _productListModel = _newProductListModel;
    } else {
      lastPage = _newProductListModel?.pagination?.lastPage ?? 1;
      nextPage = _newProductListModel?.pagination?.next ?? 1;
      _productListModel?.productList?.addAll(_newProductListModel!.productList!);
    }
  }

  // GetCityState Method
  Future<void> getCityState(BuildContext context, String pincode, NetworkResponseHandler responseHandler) async {
    _cartRepo.getCityState(context, pincode, (result, isSuccess) {
      if (isSuccess) {
        _cityStateModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        AppIndicator.disposeIndicator();
        responseHandler(result, isSuccess);
        notifyListeners();
      }

    }
    );
  }

  //buyNow Method
  Future<void> buyNow(
      String productId,
      String quantity,
      variantId,
      bool cartDetail,
      BuildContext context,
      ) async {
   // AppIndicator.loadingIndicator(context);
    _cartRepo.buynow(productId, quantity, variantId, context,
            (result, isSuccess) {
          if (isSuccess) {
            _cartListDataModel =
                ((result as SuccessState).value as ASResponseModal).dataModal;
            buynow=jsonEncode(_cartListDataModel);
            SessionStorageHelper.savevalue("token","${buynow}");
            context.router.push(BuynowCart(
            ));
            notifyListeners();
          }
        });
  }

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
  Future<void> getProductDetails(BuildContext context,String productId,
      String size, String color, String style, String unit, String material) async {
    _cartRepo.getProductDetails(context, productId, colorId: color,
        sizeName: size, materialType: material, style: style, unitCount: unit,(result, isSuccess) {
      if (isSuccess) {
        _productListDetails = ((result as SuccessState).value as ASResponseModal).dataModal;
        if(_productListDetails != null){
          isAddedToCart = _productListDetails?.productDetails?.isAddToCart ?? false;
          AppIndicator.disposeIndicator();
          notifyListeners();
        }
        if (((result as SuccessState).value as ASResponseModal).dataModal == null){
          ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        }
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
      notifyListeners();
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
  updateStyleName(BuildContext context, String name) {
    selectedStyleName = name;
    notifyListeners();
  }

  updateMaterialName(BuildContext context, String name) {
    selectedMaterialName = name;
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
        ToastMessage.message("address deleted");
        getAddressList(context);
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }

  // ADDToFavourite Method
  Future<void> addToFavourite(BuildContext context, String productId,
      String variantId, bool fav, String pageName,{int? listIndex}) async {
    //AppIndicator.loadingIndicator(context);
    _cartRepo.addToFavourite(productId, variantId, fav, context,
        (result, isSuccess) {
          favouriteCallback = true;
      if (isSuccess) {
        reloadPage();
        // getPageName(context, pageName, result,variantId,listIndex);
        // ToastMessage.message(
        //     ((result as SuccessState).value as ASResponseModal).message);
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
      orderId, payMethod, productId,variantId,quantity,payStatus) async {
    _cartRepo.placeYourOrder(productId,variantId,quantity,
        addressId, transactionId, orderId, payMethod, payStatus, context,
        (result, isSuccess) {
      if (isSuccess) {
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);


        context.pushRoute(ThankYouPage());
        SessionStorageHelper.savevalue("payment","true");
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
    selectedcolorName = name;
    notifyListeners();
  }

  updatesizeName(BuildContext context,String name) {
    selectedSizeName = name;
    notifyListeners();
  }

  getPageName(BuildContext context, String name, Result result, String variantId, int? listIndex) {
    switch (name) {
      case 'productList':
        getProductList(context, 1);
        break;
      case 'productDetail':
        _productListDetails = ((result as SuccessState).value as ASResponseModal).dataModal;
        break;
      case 'favouriteList':
        getFavList(context, 1);
        break;
      case 'favouriteDetail':
        _productListDetails = ((result as SuccessState).value as ASResponseModal).dataModal;
        break;
      case 'cartDetail':
        removeProductFromCart(context, variantId, listIndex??0);
    }
  }
  onPagination(BuildContext context, int lastPage, int nextPage, bool isLoading, String name, {String? categoryId}) {
    if (isLoading) return;
    isLoading = true;
    if (nextPage <= lastPage) {
      runIndicator(context);
      switch(name){
        case 'productList' :
          getProductList(context, nextPage);
          break;
        case 'favouriteList' :
          getFavList(context, nextPage);
          break;
        case 'productCategoryList' :
          getProductListCategory(context, "", categoryId ?? "", nextPage);
          break;
      }
    }
  } Future<void> runIndicator(BuildContext context) async {
    isLoading = true;
    notifyListeners();
  }}
