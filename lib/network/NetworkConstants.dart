import 'result.dart';

typedef void NetworkResponseHandler(Result result, bool isSuccess);
typedef void InternetResponseHandler(bool isSuccess, dynamic result);
typedef void NotificationHandler(dynamic response);
typedef void ApiCallback(dynamic response);
class NetworkConstants{

  static String kAppBaseUrl = 'https://api.digitalseller.in:8011/api/';
 //static String kAppBaseUrl = 'https://eacademyeducation.com:8011/api/';
  static String kGetAppConfig = 'getAppConfigurations?appId={APP_ID}';
  static String kContactUs = "add-contactUs";
  static String kOpenWebViewUrl = "web-view?appId={APP_ID}&query={QUERY}";
  static String kSendLogSupport = "email-support";
  static String kGetSearchData = "search-product?appId={APP_ID}&userId={USER_ID}&query={SEARCH_QUERY}&pageNum={PAGE_NUM}";
  static String kGetAppMenu = "getAppMenu?appId={APP_ID}&deviceType={DEVICE_TYPE}";

  // homepage api section
  static String kGetBannerList = "get-all-banner?appId={APP_ID}";
  static String kGetHomePageData = "homepageVideo?userId={USER_ID}&appId={APP_ID}&videoFor={VIDEO_FOR}&type={TYPE}&pageNum={PAGE_NUM}";
  static String kGetTrayData = "getTrayOrder?appId={APP_ID}";
  static String kGetCategoryData = "getAllCategory?appId={APP_ID}&pageNum={PAGE_NUM}";
  static String kGetCategoryDetails = "getCategoryDetails?appId={APP_ID}&categoryId={CATEGORY_ID}&pageNum={PAGE_NUM}";
  static String kGetMoreLikeThis = 'getMoreLikesVideoList?videoId={VIDEO_ID}&appId={APP_ID}';
  static String kGetVideoById = 'homepageVideoDetails?userId={USER_ID}&appId={APP_ID}&videoId={VIDEO_ID}';

  // notification api section
  static String kGetNotification = 'get-all-notification?appId={APP_ID}&userId={USER_ID}&pageNum={PAGE_NUM}';
  static String kGetNotificationCount = 'notification-count?appId={APP_ID}&userId={USER_ID}';

  // user api section
  static String kLogin = "user-login";
  static String kCheckUserAlreadyRegister = "user-register";
  static String kUserRegister = "register-user";
  static String kVerifyOtp = "user-verify-otp";
  static String kResendOtp = "user-resend-otp";
  static String kForgotPassword = "user-forgot-password";
  static String kResetPassword = "user-reset-password";
  static String kGetAllPages = "getAllPages";
  static String kUploadProfilePic = "upload-user-profile-pic";
  static String kUserSocialLogin = "user-social-login";
  static String kSocialUpdate = "user-social-update";
  static String kUserDelete = "user-delete/?userId=dacbd8c0-110d-46f9-a";
  static String getUserDetails = "get-userprofile-by-id?userId={USER_ID}&appId={APP_ID}";
  static String kUpdateProfile = "update-user-profile";
  static String kDeleteProfile = "user-delete/?userId={USER_ID}&appId={APP_ID}";

  // product-cart-address-favourite api section

  static String kGetOrderList = "order-list?userId={USER_ID}&appId={APP_ID}&pageNum={PAGE_NUM}";
  static String kgetAllAddress = "get-all-address?userId={USER_ID}&appId={APP_ID}";
  static String kGetOrderListDetail = "order-detail?userId={USER_ID}&appId={APP_ID}&orderItemId={ORDER_ITEM_ID}";
  static String kAddToFavourite = "add-favorite";
  static String KGetFavourite="get-all-favorite?appId={APP_ID}&userId={USER_ID}&pageNum={PAGE_NUM}";
  static String placeOrder = "place-order";
  static String removeFromCart = "remove-cartItems";
  static String getCartCount = 'cart-item-count?userId={USER_ID}&appId={APP_ID}';
  static String addNewAddress = 'add-address';
  static String updateAddress = 'update-address';
  static String deleteAddress='delete-address';
  static String kAddToCart = "add-and-update-cart";
  static String kGetCartList = "getall-cart?userId={USER_ID}&appId={APP_ID}";
  static String kGetPromocode = "get-all-promocode?userId={USER_ID}&appId={APP_ID}";
  static String kGetProductList = "product-listing?userId={USER_ID}&appId={APP_ID}&pageNum={PAGE_NUM}";
  static String kGetProductById = 'product-details?userId={USER_ID}&productId={PRODUCT_ID}&appId={APP_ID}&variant=[{"color" : "{COLOR_ID}"}, {"size" : "{SIZE_NAME}"},{"material_type" : "{MATERIAL_TYPE}"}, {"style" : "{STYLE}"}, {"unit_count" : "{UNIT_COUNT}"}]';
  static String buynow='buy-now';
  static String kGetProductByCategory = "get-banner-product?appId={APP_ID}&catId={CAT_ID}&productId={PROD_ID}";
  static String KRecentView='view-product-list?userId={USER_ID}&appId={APP_ID}';
  static String KRecommended='recommended-product?appId={APP_ID}';
  // payment-order section
  static String kGetAllCategory = "getAllCategory?appId={APP_ID}";
  static String kCreateOrder = "create-order";
  static String kPaymentResponse = "payment-callback";
  static String kcityState='get-city-state?pincode={PINCODE}';

  // static String kAppID = '8b7e56d4-8d6c-4053-8991-64374d95c353';
 //static String kAppID = 'c5d97fa9-a6b9-48c5-bf23-b847f1a12b09';
  static String kAppID = '5d3f0631-40fd-4047-afa9-47138ee59fc2';
// static String kAppID = 'f11e5fd9-a395-49fb-bbd8-7e6554dc4549';
}
