import 'dart:convert';
import 'dart:html';
import 'package:TychoStream/AppRouter.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_cache/json_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/model/data/TermsPrivacyModel.dart';
import 'package:TychoStream/model/data/UserInfoModel.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppDataManager.dart';
import 'package:TychoStream/network/CacheDataManager.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/profile_repository.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/StringConstants.dart';

class ProfileViewModel with ChangeNotifier {
  final _profileRepo = ProfileRepository();

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  bool enableMobileField = false;
  bool enableEmailField = false;
  List<TermsPrivacyModel>? _termsPrivacyModel;
  List<TermsPrivacyModel>? get termsPrivacyModel => _termsPrivacyModel;




// method for get profile details from cache
  getProfileDetails(BuildContext context) async {
    final box = await Hive.openBox<String>('appBox');
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    if (await jsonCache.contains(StringConstant.kUserDetails)) { CacheDataManager.getCachedData(key: StringConstant.kUserDetails).then((jsonData) {
      if(jsonData != null){
        _userInfoModel = UserInfoModel.fromJson(jsonData);
        print('From Cached profile data');
        notifyListeners();
      }
    });
    } else {
      getProfileDetail(context);
    }
  }

  //GetVerificationButtonStatus Method
  getVerificationButtonStatus(BuildContext context, bool? isPhoneVerified, bool? isEmailVerified){
    enableMobileField = isPhoneVerified ?? false;
    enableEmailField = isEmailVerified ?? false;
    notifyListeners();
  }

  // Method for get Profile details
  Future<void> getProfileDetail(BuildContext context) async {
    _profileRepo.getUserProfileDetails(context, (result, isSuccess) {
      if (isSuccess) {
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        getVerificationButtonStatus(
            context,
            _userInfoModel?.isPhoneVerified,
            _userInfoModel?.isEmailVerified);
        notifyListeners();
      }
    });
  }

  // Method for Update Profile
  Future<void> updateProfile(BuildContext context, String? name, String? phone,
      String? address, String? email) async {
    AppIndicator.loadingIndicator(context);
    _profileRepo.editProfile(name!, phone!, address!, email!, context,
            (result, isSuccess) {
          if (isSuccess) {
            AppIndicator.disposeIndicator();
            _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            AppDataManager.getInstance.updateUserDetails(userInfoModel!);
            ToastMessage.message(
                ((result as SuccessState).value as ASResponseModal).message,context);
            context.router.push(HomePageWeb());
            notifyListeners();
          }
        });
  }

  // Method for Upload Profile image
  Future<dynamic> uploadProfile(BuildContext context, FileReader reader, File file, ApiCallback responseData) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = '${NetworkConstants.kAppBaseUrl + NetworkConstants.kUploadProfilePic}';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = "Basic " + sharedPreferences.get("token").toString();
    request.fields['userId'] = sharedPreferences.get("userId").toString();;
    reader.onLoadEnd.listen((e) {
      var bytes = reader.result as List<int>;
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: file.name));
      request.send().then((response) async{
        if (response.statusCode == 200) {
          String responseBody = await response.stream.transform(utf8.decoder).join();
          var map = jsonDecode(responseBody);
          responseData(map['data']);

        } else {
          print('Image upload failed with status code ${response.statusCode}.');
        }
      });
    });
  }


  Future<void> uploadProfileImage(BuildContext context) async {
    var input = FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    File file = input.files!.first;
    var start = 0;
    var end = file.size;
    var blob = file.slice(start, end);
    var reader = FileReader();
    reader.readAsArrayBuffer(blob);
    AppIndicator.loadingIndicator(context);
    _profileRepo.uploadProfile(context, reader, file, (response) {
      if(response != null){
        _userInfoModel = UserInfoModel.fromJson(response);
        AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        print('Image uploaded successfully!');
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }

  //Method for contact Us
  Future<void> contactUs(BuildContext context, String name, String email, String query) async{
    AppIndicator.loadingIndicator(context);
    _profileRepo.contactUsApi(context, name, email, query, (result, isSuccess) {
      if(isSuccess){
        AppIndicator.disposeIndicator();
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message,context);
        context.router.push(HomePageWeb());
        notifyListeners();
      }
    });
  }
}
