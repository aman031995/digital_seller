import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';


class AppDataManager {
  static AppDataManager? _instance;

  AppDataManager._();

  static AppDataManager get getInstance => _instance ??= AppDataManager._();
  UserInfoModel? _userDetails;

  updateUserDetails(UserInfoModel userInfoModel) {
    this._userDetails = userInfoModel;
    saveUserDetailsInCache(userInfoModel);
  }

  static Future<String?> updatefirstTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("firstTime");
  }

  static Future<String?> setFirstTimeValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("firstTime", '1');
  }

  static Future<int?> setFirstTimeAlert() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt("isAlert");
  }

  static Future<String?> loggedInUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("userId");
  }

  Future<UserInfoModel> currentUser() async {
    if (this._userDetails == null) {
      await populateUserModalFromSavedData();
    }
    return this._userDetails!;
  }

  populateUserModalFromSavedData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.get("userId");
  }

  saveUserDetailsInCache(UserInfoModel userInfoModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("userId", userInfoModel.userId.toString());
    if (userInfoModel.loginToken != '') {
      sharedPreferences.setString("token", userInfoModel.loginToken ?? '');
    }
    sharedPreferences.setString("name", userInfoModel.name ?? '');
    sharedPreferences.setString("email", userInfoModel.email ?? '');
    sharedPreferences.setString("phone", userInfoModel.phone ?? '');
    sharedPreferences.setString("address", userInfoModel.address ?? '');
    sharedPreferences.setString("profileImg", userInfoModel.profilePic ?? '');
  }

  static deleteSavedDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("userId");
    sharedPreferences.remove("token");
    sharedPreferences.remove("name");
    sharedPreferences.remove("profileImg");
    sharedPreferences.remove("email");
    sharedPreferences.remove("phone");
    sharedPreferences.remove("address");
    sharedPreferences.remove("firstTime");
    sharedPreferences.remove("isAlert");
    // SocialLoginManager.handleSignOut();
  }
}
