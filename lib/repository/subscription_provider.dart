import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tycho_streams/model/data/consumable_store.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';

import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class SubscriptionProvider with ChangeNotifier {
  List<PurchaseDetails> _purchases = [];
  List<PurchaseDetails> get purchases => _purchases;

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  bool kAutoConsume = true;
  static String kConsumableId = 'com.alifbatakids.yearlyplans';
  static final List<String> kProductIds = <String>[kConsumableId];

  static const String kUpgradeId = 'non_consumable';
  static const String kSilverSubscriptionId = 'subscription_silvers';
  static const String kGoldSubscriptionId = 'subscription_golds';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  InAppPurchase get inAppPurchase => _inAppPurchase;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  StreamSubscription<List<PurchaseDetails>>? get subscription => _subscription;

  List<String> _notFoundIds = [];
  List<String> get notFoundIds => _notFoundIds;

  List<String> _consumables = [];
  List<String> get consumables => _consumables;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  bool _purchasePending = false;
  bool get purchasePending => _purchasePending;

  bool _loading = true;
  bool get loading => _loading;

  String? _queryProductError;
  String? get queryProductError => _queryProductError;

  bool _isPurchased = false;
  bool get isPurchased => _isPurchased;

  bool _removeAds = false;
  bool get removeAds => _removeAds;

  bool _finishedLoad = false;
  bool get finishedLoad => _finishedLoad;

  bool _silverSubscription = false;
  bool get silverSubscription => _silverSubscription;

  bool _goldSubscription = false;
  bool get goldSubscription => _goldSubscription;

  set removeAds(bool value) {
    _removeAds = value;
    notifyListeners();
  }

  set finishedLoad(bool value) {
    _finishedLoad = value;
    notifyListeners();
  }

  set silverSubscription(bool value) {
    _silverSubscription = value;
    notifyListeners();
  }

  void initInApp(BuildContext context) async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(context ,purchaseDetailsList);
      notifyListeners();
    }, onDone: () {
      // isHide = false;
      _subscription?.cancel();
      notifyListeners();
    }, onError: (error) {
      // handle error here.
      // isHide = false;
      print('Error Occurred: ' + error.toString());
      AppIndicator.disposeIndicator();
      notifyListeners();
    });
    initStoreInfo();
  }

  Future<void> inAppStream() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      // button enable and complete payment first bool callback
      AppIndicator.disposeIndicator();
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  verifyPreviousPurchases() async {
    print("=============================verifyPreviousPurchases");
    await _inAppPurchase.restorePurchases();
    await Future.delayed(const Duration(milliseconds: 100), () {
      for (var pur in _purchases) {
        if (pur.productID.contains('non_consumable')) {
          removeAds = true;
        }
        if (pur.productID.contains('subscription_silver')) {
          silverSubscription = true;
        }
        if (pur.productID.contains('subscription_gold')) {
          goldSubscription = true;
        }
      }
      finishedLoad = true;
    });
    notifyListeners();
  }

  set goldSubscription(bool value) {
    _goldSubscription = value;
    notifyListeners();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailableStore = await _inAppPurchase.isAvailable();
    if (!isAvailableStore) {
      _isAvailable = isAvailableStore;
      _products = [];
      _purchases = [];
      _notFoundIds = [];
      _consumables = [];
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }

    // if (Platform.isIOS) {
    //   var iosPlatformAddition =
    //   inAppPurchase.getPlatformAddition<InAppPurchaseIosPlatformAddition>();
    //   await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    // }

    ProductDetailsResponse productDetailResponse =
      await _inAppPurchase.queryProductDetails(kProductIds.toSet());
    if (productDetailResponse.error != null) {
      _queryProductError = productDetailResponse.error!.message;
      _isAvailable = isAvailableStore;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = [];
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      _queryProductError = null;
      _isAvailable = isAvailableStore;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = [];
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }

    List<String> consumableProd = await ConsumableStore.load();
    _isAvailable = isAvailableStore;
    _products = productDetailResponse.productDetails;
    _notFoundIds = productDetailResponse.notFoundIDs;
    _consumables = consumableProd;
    _purchasePending = false;
    _loading = false;
    notifyListeners();
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumableProd = await ConsumableStore.load();
    _consumables = consumableProd;
    notifyListeners();
  }

  void showPendingUI() {
    _purchasePending = true;
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      List<String> consumableProd = await ConsumableStore.load();
      _purchasePending = false;
      _consumables = consumableProd;
      _isPurchased = true;
    } else {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    }
  }

  void handleError(IAPError error) {
    _purchasePending = false;
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  // for purchase update
  void _listenToPurchaseUpdated(BuildContext context, List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume && purchaseDetails.productID == kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
            _inAppPurchase.getPlatformAddition<
                InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (Platform.isIOS) {
          if (purchaseDetails.purchaseID == null) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        }
        AppIndicator.disposeIndicator();
        if (purchaseDetails.pendingCompletePurchase &&
            purchaseDetails.purchaseID != null) {
          AppIndicator.loadingIndicator(context);
          await _inAppPurchase.completePurchase(purchaseDetails);
          if (purchaseDetails.productID == kConsumableId) {
            print('============================ Purchase Successful ========================');
            AppIndicator.disposeIndicator();
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (_) =>
            //           SamplePlayer(url: 'assets/videos/video_sample.mp4'),
            //     ));
            notifyListeners();
          }
          verifyPreviousPurchases();
        }
      }
    });
  }

  // for confirming price changing
  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      var priceChangeConfirmationResult =
      await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                "Price change failed with code ${priceChangeConfirmationResult.responseCode}",
          ),
        ));
      }
    }
    if (Platform.isIOS) {
      // var iapIosPlatformAddition =
      // inAppPurchase.getPlatformAddition();
      // await iapIosPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == kSilverSubscriptionId && purchases[kGoldSubscriptionId] != null) {
      oldSubscription = purchases[kGoldSubscriptionId] as GooglePlayPurchaseDetails;
    } else if (productDetails.id == kGoldSubscriptionId && purchases[kSilverSubscriptionId] != null) {
      oldSubscription = purchases[kSilverSubscriptionId] as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }
}
