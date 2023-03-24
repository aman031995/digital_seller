import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_cache/json_cache.dart';
import 'package:tycho_streams/model/data/TermsPrivacyModel.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/profile_repository.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'dart:html' as html;


class ProfileViewModel with ChangeNotifier {
  final _profileRepo = ProfileRepository();

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

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

  Future<void> imageUpload(BuildContext context, result) async {
    AppIndicator.loadingIndicator(context);
    var imageToUpload = File(result.path);
    _profileRepo.uploadImage([imageToUpload.path], context,
            (result, isSuccess) {
          _userInfoModel =
              ((result as SuccessState).value as ASResponseModal).dataModal;
          notifyListeners();
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

  Future<void> getProfileDetails(BuildContext context) async {
    AppIndicator.loadingIndicator(context);
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
            GoRouter.of(context).pushNamed(RoutesName.home);
            notifyListeners();
          }
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
}
