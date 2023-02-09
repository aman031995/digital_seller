import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tycho_streams/model/data/TermsPrivacyModel.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/profile_repository.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/screens/bottom_navigation.dart';
import 'package:tycho_streams/view/screens/login_screen.dart';
import 'package:tycho_streams/view/widgets/profile_bottom_view.dart';

class ProfileViewModel with ChangeNotifier {
  final _profileRepo = ProfileRepository();

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  List<TermsPrivacyModel>? _termsPrivacyModel;
  List<TermsPrivacyModel>? get termsPrivacyModel => _termsPrivacyModel;

  Future getTermsPrivacy(BuildContext context) async {
    AppIndicator.loadingIndicator();
    _profileRepo.getTermsPrivacy(context, (result, isSuccess) {
      if (isSuccess) {
        _termsPrivacyModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        print('Terms Privacy api Successfully');
        if(names.length == 4){
          addItemOnList(_termsPrivacyModel);
        }
        notifyListeners();
        AppIndicator.disposeIndicator();
      }
    });
  }

  void addItemOnList(List<TermsPrivacyModel>? termsPrivacyModel) {
    for (var i = 0; i < termsPrivacyModel!.length; i++) {
        names.insert(3, termsPrivacyModel[i].pageTitle!);
        namesIcon.insert(3, termsPrivacyModel[i].pageIcon!);
    }
  }

  Future<void> imageUpload(BuildContext context, result) async {
    AppIndicator.loadingIndicator();
    var imageToUpload = File(result.path);
    _profileRepo.uploadImage([imageToUpload.path], context,
        (result, isSuccess) {
      _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
      notifyListeners();
    });
  }

  Future<void> getProfileDetails(BuildContext context) async {
    AppIndicator.loadingIndicator();
    getTermsPrivacy(context);
    _profileRepo.getUserProfileDetails(context, (result, isSuccess) {
      if (isSuccess) {
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

  Future<void> updateProfile(BuildContext context, String? name, String? phone,
      String? address) async {
    AppIndicator.loadingIndicator();
    _profileRepo.editProfile(name!, phone!, address!, context,
        (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomNavigation(index: 0)));
        GoRouter.of(context).pushReplacementNamed(RoutesName.bottomNavigation);
        notifyListeners();
      }
    });
  }

  Future<void> deleteProfile(BuildContext context) async {
    AppIndicator.loadingIndicator();
    _profileRepo.deleteUserAccount(context, (result, isSuccess) async {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        AppDataManager.deleteSavedDetails();
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        Navigator.of(context, rootNavigator: true).pop();
        await Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false));
        notifyListeners();
      }
    });
  }
}
