import 'result.dart';

typedef void NetworkResponseHandler(Result result, bool isSuccess);
typedef void InternetResponseHandler(bool isSuccess, dynamic result);
typedef void NotificationHandler(dynamic response);
typedef void ApiCallback(dynamic response);
class NetworkConstants{
  static String kAppBaseUrl = 'https://eacademyeducation.com:8011/api/';

  static String kGetAppConfig = 'getAppConfigurations?appId={APP_ID}';
  static String kContactUs = "add-contactUs";
  static String kOpenWebViewUrl = "web-view?appId={APP_ID}&query={QUERY}";
  static String kSendLogSupport = "email-support";
  static String kGetSearchData = "search?query={SEARCH_QUERY}&pageNum={PAGE_NUM}&appId={APP_ID}";
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
  static String kGetOrderListDetail = "order-detail?userId={USER_ID}&appId={APP_ID}&order_id={ORDER_ID}";
  static String kAddToFavourite = "add-favorite";
  static String KGetFavourite="get-all-favorite?appId={APP_ID}&userId={USER_ID}";
  static String placeOrder = "place-order";
  static String removeFromCart = "remove-cartItems";
  static String getCartCount = 'cart-item-count?userId={USER_ID}&appId={APP_ID}';
  // static String getCheckOutData = 'check-out?userId={USER_ID}&appId={APP_ID}';
  static String addNewAddress = 'add-address';
  static String updateAddress = 'update-address';
  static String deleteAddress='delete-address';
  static String kAddToCart = "add-and-update-cart";
  static String kGetCartList = "getall-cart?userId={USER_ID}&appId={APP_ID}";
  // static String kGetPromocode = "get-all-promocode?userId={USER_ID}&appId={APP_ID}";
  static String kGetPromocode = "get-all-promocode?userId={USER_ID}&appId={APP_ID}";
  // static String kGetProductList = "product-list?userId={USER_ID}&appId={APP_ID}";
  static String kGetProductList = "product-listing?userId={USER_ID}&appId={APP_ID}&pageNum={PAGE_NUM}";
  // static String kGetProductById = "get-by-product-id?productId={PRODUCT_ID}&userId={USER_ID}&appId={APP_ID}";
  static String kGetProductById = "product-details?userId={USER_ID}&productId={PRODUCT_ID}&appId={APP_ID}&colorName={COLOR_ID}&sizeName={SIZE_NAME}&variantId={VARIANT_ID}";

  // payment-order section
  static String kCreateOrder = "create-order";
  static String kPaymentResponse = "payment-callback";

  // static String kAppID = '8b7e56d4-8d6c-4053-8991-64374d95c353';
  static String kAppID = 'a2108f43-9011-4440-9984-6f3d19810c27';
}
