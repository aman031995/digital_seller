import 'result.dart';

typedef void NetworkResponseHandler(Result result, bool isSuccess);
typedef void InternetResponseHandler(bool isSuccess, dynamic result);

class NetworkConstants{
  static String kAppBaseUrl = 'http://eacademyeducation.com:8011/api/';
  static String kLogin = "user-login";
  static String kRegister = "user-register";
  static String kUserRegister = "register-user";
  static String kVerifyOtp = "user-verify-otp";
  static String kResendOtp = "user-resend-otp";
  static String kForgotPassword = "user-forgot-password";
  static String kResetPassword = "user-reset-password";
  static String kGetAllPages = "getAllPages";
  static String kUploadProfilePic = "upload-user-profile-pic";
  static String kUserSocialLogin = "user-social-login";
  static String kUserDelete = "user-delete/?userId=dacbd8c0-110d-46f9-a";
  static String getUserDetails = "get-userprofile-by-id?userId={USER_ID}";
  static String kUpdateProfile = "update-user-profile";
}