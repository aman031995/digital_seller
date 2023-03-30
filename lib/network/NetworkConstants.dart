import 'result.dart';

typedef void NetworkResponseHandler(Result result, bool isSuccess);
typedef void InternetResponseHandler(bool isSuccess, dynamic result);
typedef void ApiCallback(dynamic response);

class NetworkConstants{
  static String kAppBaseUrl = 'https://eacademyeducation.com:8011/api/';
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
  static String getUserDetails = "get-userprofile-by-id?userId={USER_ID}";
  static String kUpdateProfile = "update-user-profile";
  static String kDeleteProfile = "user-delete/?userId={USER_ID}";
  static String kContactUs = "add-contactUs";
  static String kGetBannerList = "getBannerList?appId={APP_ID}";
  static String kGetHomePageData = "homepageVideo?userId={USER_ID}&appId={APP_ID}&videoFor={VIDEO_FOR}&pageNum={PAGE_NUM}";
  static String kGetTrayData = "getTrayOrder?appId={APP_ID}";
  static String kGetCategoryData = "getAllCategory?appId={APP_ID}&pageNum={PAGE_NUM}";
  static String kGetCategoryDetails = "getCategoryDetails?appId={APP_ID}&categoryId={CATEGORY_ID}&pageNum={PAGE_NUM}";
  static String kgetMoreLikeThis = 'getMoreLikesVideoList?videoId={VIDEO_ID}';

  static String kGetAppConfig = 'getAppConfigurations?appId={APP_ID}';
  static String kGetNotification = 'get-all-notification?appId={APP_ID}&userId={USER_ID}&pageNum={PAGE_NUM}';

  static String kCartDetail = "add-and-update-cart";
  static String kGetCartList = "getall-cart?userId={USER_ID}";
  static String kGetProductList = "product-list";
  static String kGetProductById = "get-by-product-id?productId={PRODUCT_ID}";

  static String kGetSearchData = "search?query={SEARCH_QUERY}&pageNum={PAGE_NUM}";
  static String kGetAppMenu = "getAppMenu?appId={APP_ID}&deviceType={DEVICE_TYPE}";
  static String removeFromCart = "remove-cartItems";
  static String getCartCount = 'cart-item-count?userId={USER_ID}&appId={APP_ID}';
  static String getCheckOutData = 'check-out?userId={USER_ID}&appId={APP_ID}';
  static String addNewAddress = 'add-address';
}
