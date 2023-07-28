import 'dart:convert';
import 'dart:html';
import 'package:TychoStream/AppRouter.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'package:TychoStream/utilities/route_service/routes_name.dart';


class ProfileViewModel with ChangeNotifier {
  final _profileRepo = ProfileRepository();

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  bool enableMobileField = false;
  bool enableEmailField = false;
  List<TermsPrivacyModel>? _termsPrivacyModel;
  List<TermsPrivacyModel>? get termsPrivacyModel => _termsPrivacyModel;

  Future getTermsPrivacy(BuildContext context) async {
    AppIndicator.loadingIndicator(context);
    _profileRepo.getTermsPrivacy(context, (result, isSuccess) {
      if (isSuccess) {
        _termsPrivacyModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        print('Terms Privacy api Successfully');
        notifyListeners();
        AppIndicator.disposeIndicator();
      }
    });
  }

  getUserDetails(BuildContext context) async {
    final box = await Hive.openBox<String>('appBox');
    final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
    if (await jsonCache.contains(StringConstant.kUserDetails)) {
      CacheDataManager.getCachedData(key: StringConstant.kUserDetails).then((jsonData) {
        _userInfoModel = UserInfoModel.fromJson(jsonData!['data']);
        print('From Cached UserData');
        notifyListeners();
      });
      CacheDataManager.getCachedData(key: StringConstant.kPrivacyTerms).then((jsonData) {
        var items = <TermsPrivacyModel>[];
        jsonData?['data'].forEach((element) {
          items.add(TermsPrivacyModel.fromJson(element));
        });
        _termsPrivacyModel = items;
        print('From Cached Privacy and Terms');
        notifyListeners();
      });
    } else {
      getProfileDetails(context);
    }
  }
  //GetVerificationButtonStatus Method
  getVerificationButtonStatus(BuildContext context, String? isPhoneVerified, String? isEmailVerified){
    enableMobileField = isPhoneVerified?.toLowerCase() == 'true';
    enableEmailField =isEmailVerified?.toLowerCase() == 'true';
    notifyListeners();
  }
  Future<void> getProfileDetails(BuildContext context) async {
    //AppIndicator.loadingIndicator(context);
    _profileRepo.getTermsPrivacy(context, (result, isSuccess) {
      if (isSuccess) {
        _termsPrivacyModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        print('Terms Privacy api Successfully');
      }
    });
    _profileRepo.getUserProfileDetails(context, (result, isSuccess) {
      if (isSuccess) {
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
        Future.delayed(Duration(milliseconds: 1500),(){
          AppIndicator.disposeIndicator();
        });
      }
    });
  }
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
                ((result as SuccessState).value as ASResponseModal).message);
            context.router.push(HomePageWeb());
            notifyListeners();
          }
        });
  }

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
  Future<void> deleteProfile(BuildContext context) async {
    AppIndicator.loadingIndicator(context);
    _profileRepo.deleteUserAccount(context, (result, isSuccess) async {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        AppDataManager.deleteSavedDetails();
        CacheDataManager.clearCachedData(key: StringConstant.kPrivacyTerms);
        CacheDataManager.clearCachedData(key: StringConstant.kUserDetails);
        CacheDataManager.clearCachedData(key: StringConstant.kBannerList);
        CacheDataManager.clearCachedData(key: StringConstant.kCategoryList);
        ToastMessage.message(
            ((result as SuccessState).value as ASResponseModal).message);
        Navigator.of(context, rootNavigator: true).pop();
        GoRouter.of(context).pushNamed(RoutesName.home);
        // await Future.delayed(const Duration(seconds: 1)).then((value) =>
        //     Navigator.pushAndRemoveUntil(
        //         context,
        //         MaterialPageRoute(builder: (_) => LoginScreen()),
        //             (route) => false));
        notifyListeners();
      }
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
  Future<void> contactUs(BuildContext context, String name, String email, String query) async{
    AppIndicator.loadingIndicator(context);
    _profileRepo.contactUsApi(context, name, email, query, (result, isSuccess) {
      if(isSuccess){
        AppIndicator.disposeIndicator();
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        Navigator.of(context, rootNavigator: true).pop();
        notifyListeners();
      }
    });
  }
}
